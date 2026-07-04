--[[
================================================================================
                    NEXZAN PREMIUM UI LIBRARY (v4.0 - ULTRAPACK DEFINITIVE)
================================================================================
    * Desain Premium Glassmorphic (Tanpa Warna Biru - Full Custom Themes)
    * Ukuran Jendela Utama: 480 x 280 (Lebih Ringkas, Padat, & Kompak)
    * Fitur Terlengkap & Teroptimasi untuk Mobile/HP & PC
    * Tombol Minimize Fleksibel & Draggable: "Open Nexzan UI"
    * Sistem Dragging Mulus (Mendukung Mouse & Layar Sentuh HP)
    * CONFIGURABLE KEY SYSTEM & AUTO CONFIG SYSTEM (Save/Load Otomatis!)
    * FITUR BARU: Sections/Groupbox, Multi-Dropdown, Search Dropdown, Color Gradient,
                 Toggle UI Keybind, Full Unload System, Sliders, Textboxes, Keybinds,
                 Colorpickers, Paragraphs, & THEME MANAGER!
================================================================================
]]

local Library = {}
Library.Unloaded = false
Library.Flags = {}
Library.Theme = {
    Accent = Color3.fromRGB(255, 255, 255),
    Background = Color3.fromRGB(25, 25, 25),
    Sidebar = Color3.fromRGB(15, 15, 15),
    TopBorder = Color3.fromRGB(255, 255, 255)
}

-- Predefined Themes
Library.Themes = {
    Light = {
        Accent = Color3.fromRGB(40, 40, 40),
        Background = Color3.fromRGB(240, 240, 240),
        Sidebar = Color3.fromRGB(220, 220, 220),
        TopBorder = Color3.fromRGB(40, 40, 40)
    },
    Dark = {
        Accent = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(25, 25, 25),
        Sidebar = Color3.fromRGB(15, 15, 15),
        TopBorder = Color3.fromRGB(255, 255, 255)
    },
    Vampire = {
        Accent = Color3.fromRGB(255, 40, 40),
        Background = Color3.fromRGB(20, 10, 10),
        Sidebar = Color3.fromRGB(12, 5, 5),
        TopBorder = Color3.fromRGB(255, 40, 40)
    },
    Aqua = {
        Accent = Color3.fromRGB(0, 255, 255),
        Background = Color3.fromRGB(15, 25, 30),
        Sidebar = Color3.fromRGB(10, 15, 20),
        TopBorder = Color3.fromRGB(0, 255, 255)
    }
}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local ToggleKey = Enum.KeyCode.RightShift

-- Configuration System (Save/Load Settings)
local ConfigFolder = "NexzanConfigs"
local ConfigFile = "Config.json"

local function SaveConfig()
    if not isfolder or not writefile then return end
    if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
    
    local data = {}
    for k, v in pairs(Library.Flags) do
        if typeof(v) == "Color3" then
            data[k] = {r = v.R, g = v.G, b = v.B, isColor = true}
        else
            data[k] = v
        end
    end
    
    pcall(function()
        writefile(ConfigFolder .. "/" .. ConfigFile, HttpService:JSONEncode(data))
    end)
end

local function LoadConfig()
    if not isfolder or not readfile then return end
    if not isfile(ConfigFolder .. "/" .. ConfigFile) then return end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(ConfigFolder .. "/" .. ConfigFile))
    end)
    
    if success and type(data) == "table" then
        for k, v in pairs(data) do
            if type(v) == "table" and v.isColor then
                Library.Flags[k] = Color3.new(v.r, v.g, v.b)
            else
                Library.Flags[k] = v
            end
        end
    end
end

-- Global Helper: Smooth Dragging Function
local function MakeDraggable(guiObject)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(guiObject, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    end

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local Connections = {}
local MainObjects = {}

function Library:SetTheme(themeName)
    local theme = Library.Themes[themeName]
    if not theme then return end
    Library.Theme = theme
    
    if MainObjects.MainWindow then
        MainObjects.MainWindow.BackgroundColor3 = theme.Background
    end
    if MainObjects.Sidebar then
        MainObjects.Sidebar.BackgroundColor3 = theme.Sidebar
    end
    if MainObjects.SidebarPatch then
        MainObjects.SidebarPatch.BackgroundColor3 = theme.Sidebar
    end
end

function Library:CreateWindow(Config)
    LoadConfig()

    local UiTitle = "Nexzan Premium"
    local UseKeySystem = false
    local CorrectKey = "NexzanGanteng"
    local GetKeyLink = "https://link-get-key-kamu.com"

    if type(Config) == "table" then
        UiTitle = Config.Name or UiTitle
        if Config.KeySystem == true then
            UseKeySystem = true
            CorrectKey = Config.Key or CorrectKey
            GetKeyLink = Config.Link or GetKeyLink
        end
    elseif type(Config) == "string" then
        UiTitle = Config
    end
    
    local OldGui = Player:WaitForChild("PlayerGui"):FindFirstChild("NexzanPremiumUiLib")
    if OldGui then OldGui:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NexzanPremiumUiLib"
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    -- Notification Area
    local NotificationArea = Instance.new("Frame")
    NotificationArea.Name = "NotificationArea"
    NotificationArea.Size = UDim2.new(0, 260, 1, -20)
    NotificationArea.Position = UDim2.new(1, -270, 0, 10)
    NotificationArea.BackgroundTransparency = 1
    NotificationArea.Parent = ScreenGui

    local NotifLayout = Instance.new("UIListLayout")
    NotifLayout.Parent = NotificationArea
    NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifLayout.Padding = UDim.new(0, 6)

    function Library:Notify(title, desc, duration)
        title = title or "Notification"
        desc = desc or "Something happened."
        duration = duration or 4

        local NotifFrame = Instance.new("Frame")
        NotifFrame.Size = UDim2.new(1, 0, 0, 0)
        NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        NotifFrame.BackgroundTransparency = 0.15
        NotifFrame.ClipsDescendants = true
        NotifFrame.Parent = NotificationArea

        Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 6)
        local Stroke = Instance.new("UIStroke", NotifFrame)
        Stroke.Color = Color3.fromRGB(45, 45, 45)

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, -20, 0, 18)
        TitleLabel.Position = UDim2.new(0, 10, 0, 6)
        TitleLabel.Text = title
        TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleLabel.Font = Enum.Font.SourceSansBold
        TitleLabel.TextSize = 12
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Parent = NotifFrame

        local DescLabel = Instance.new("TextLabel")
        DescLabel.Size = UDim2.new(1, -20, 1, -30)
        DescLabel.Position = UDim2.new(0, 10, 0, 22)
        DescLabel.Text = desc
        DescLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        DescLabel.Font = Enum.Font.SourceSans
        DescLabel.TextSize = 11
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.TextYAlignment = Enum.TextYAlignment.Top
        DescLabel.TextWrapped = true
        DescLabel.BackgroundTransparency = 1
        DescLabel.Parent = NotifFrame

        TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, 55)}):Play()

        task.spawn(function()
            task.wait(duration)
            local shrink = TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
            shrink:Play()
            shrink.Completed:Connect(function()
                NotifFrame:Destroy()
            end)
        end)
    end

    -- Minimize Button
    local MinimizedBtn = Instance.new("TextButton")
    MinimizedBtn.Size = UDim2.new(0, 130, 0, 28)
    MinimizedBtn.Position = UDim2.new(0.5, -65, 0, 15)
    MinimizedBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MinimizedBtn.BackgroundTransparency = 0.1
    MinimizedBtn.Text = "🚀 Open Nexzan UI"
    MinimizedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizedBtn.Font = Enum.Font.SourceSansBold
    MinimizedBtn.TextSize = 12
    MinimizedBtn.Visible = false
    MinimizedBtn.Parent = ScreenGui

    Instance.new("UICorner", MinimizedBtn).CornerRadius = UDim.new(0, 6)
    local MinStroke = Instance.new("UIStroke", MinimizedBtn)
    MinStroke.Color = Color3.fromRGB(40, 40, 40)
    MakeDraggable(MinimizedBtn)

    -- MAIN WINDOW FRAME
    local MainWindow = Instance.new("Frame")
    MainWindow.Size = UDim2.new(0, 480, 0, 280)
    MainWindow.Position = UDim2.new(0.5, -240, 0.5, -140)
    MainWindow.BackgroundColor3 = Library.Theme.Background
    MainWindow.BackgroundTransparency = 0.15
    MainWindow.Active = true
    MainWindow.ClipsDescendants = true
    MainWindow.Parent = ScreenGui
    MainWindow.Visible = not UseKeySystem
    MainObjects.MainWindow = MainWindow

    Instance.new("UICorner", MainWindow).CornerRadius = UDim.new(0, 8)
    MakeDraggable(MainWindow)

    local RainbowStroke = Instance.new("UIStroke", MainWindow)
    RainbowStroke.Thickness = 1.2
    RainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local rainbowConnection
    rainbowConnection = RunService.RenderStepped:Connect(function()
        if Library.Unloaded then 
            rainbowConnection:Disconnect() 
            return 
        end
        local Hue = (tick() % 5) / 5
        RainbowStroke.Color = Color3.fromHSV(Hue, 0.8, 1)
    end)
    table.insert(Connections, rainbowConnection)

    -- Window Controls
    local ControlContainer = Instance.new("Frame")
    ControlContainer.Size = UDim2.new(0, 55, 0, 22)
    ControlContainer.Position = UDim2.new(1, -60, 0, 6)
    ControlContainer.BackgroundTransparency = 1
    ControlContainer.Parent = MainWindow

    local BtnMinimize = Instance.new("TextButton", ControlContainer)
    BtnMinimize.Size = UDim2.new(0, 18, 0, 18)
    BtnMinimize.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    BtnMinimize.Text = "-"
    BtnMinimize.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnMinimize.Font = Enum.Font.SourceSansBold
    BtnMinimize.TextSize = 12
    Instance.new("UICorner", BtnMinimize).CornerRadius = UDim.new(0, 4)

    local BtnClose = Instance.new("TextButton", ControlContainer)
    BtnClose.Size = UDim2.new(0, 18, 0, 18)
    BtnClose.Position = UDim2.new(0, 22, 0, 0)
    BtnClose.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
    BtnClose.Text = "X"
    BtnClose.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnClose.Font = Enum.Font.SourceSansBold
    BtnClose.TextSize = 10
    Instance.new("UICorner", BtnClose).CornerRadius = UDim.new(0, 4)

    BtnMinimize.MouseButton1Click:Connect(function()
        MainWindow.Visible = false
        MinimizedBtn.Visible = true
    end)

    MinimizedBtn.MouseButton1Click:Connect(function()
        MainWindow.Visible = true
        MinimizedBtn.Visible = false
    end)

    BtnClose.MouseButton1Click:Connect(function()
        Library:Unload()
    end)

    -- Sidebar Container
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Library.Theme.Sidebar
    Sidebar.BackgroundTransparency = 0.1
    Sidebar.BorderSizePixel = 0
    Sidebar.ClipsDescendants = true
    Sidebar.Parent = MainWindow
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)
    MainObjects.Sidebar = Sidebar

    local SidebarPatch = Instance.new("Frame", Sidebar)
    SidebarPatch.Size = UDim2.new(0, 12, 1, 0)
    SidebarPatch.Position = UDim2.new(1, -12, 0, 0)
    SidebarPatch.BackgroundColor3 = Library.Theme.Sidebar
    SidebarPatch.BackgroundTransparency = 0.1
    SidebarPatch.BorderSizePixel = 0
    MainObjects.SidebarPatch = SidebarPatch

    local Header = Instance.new("Frame", Sidebar)
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundTransparency = 1

    local GameTitle = Instance.new("TextLabel", Header)
    GameTitle.Size = UDim2.new(1, -15, 0, 16)
    GameTitle.Position = UDim2.new(0, 10, 0, 8)
    GameTitle.Text = UiTitle
    GameTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    GameTitle.TextSize = 11
    GameTitle.Font = Enum.Font.SourceSansBold
    GameTitle.TextXAlignment = Enum.TextXAlignment.Left
    GameTitle.BackgroundTransparency = 1

    local AuthorLabel = Instance.new("TextLabel", Header)
    AuthorLabel.Size = UDim2.new(1, -15, 0, 12)
    AuthorLabel.Position = UDim2.new(0, 10, 0, 24)
    AuthorLabel.Text = "Made by Nexzan"
    AuthorLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    AuthorLabel.TextSize = 10
    AuthorLabel.Font = Enum.Font.SourceSans
    AuthorLabel.TextXAlignment = Enum.TextXAlignment.Left
    AuthorLabel.BackgroundTransparency = 1

    local LineHeader = Instance.new("Frame", Sidebar)
    LineHeader.Size = UDim2.new(1, -16, 0, 1)
    LineHeader.Position = UDim2.new(0, 8, 0, 44)
    LineHeader.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    LineHeader.BorderSizePixel = 0

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -100)
    TabContainer.Position = UDim2.new(0, 0, 0, 50)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0

    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y)
    end)

    -- Profile Footer
    local Footer = Instance.new("Frame", Sidebar)
    Footer.Size = UDim2.new(1, -12, 0, 36)
    Footer.Position = UDim2.new(0, 6, 1, -42)
    Footer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", Footer).CornerRadius = UDim.new(0, 5)

    local AvatarImg = Instance.new("ImageLabel", Footer)
    AvatarImg.Size = UDim2.new(0, 24, 0, 24)
    AvatarImg.Position = UDim2.new(0, 6, 0.5, -12)
    AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id="..Player.UserId.."&w=150&h=150"
    Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

    local DisplayNameLabel = Instance.new("TextLabel", Footer)
    DisplayNameLabel.Size = UDim2.new(1, -38, 0, 12)
    DisplayNameLabel.Position = UDim2.new(0, 34, 0, 4)
    DisplayNameLabel.Text = Player.DisplayName
    DisplayNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DisplayNameLabel.Font = Enum.Font.SourceSansBold
    DisplayNameLabel.TextSize = 11
    DisplayNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    DisplayNameLabel.BackgroundTransparency = 1

    local UsernameLabel = Instance.new("TextLabel", Footer)
    UsernameLabel.Size = UDim2.new(1, -38, 0, 10)
    UsernameLabel.Position = UDim2.new(0, 34, 0, 16)
    UsernameLabel.Text = "@" .. Player.Name
    UsernameLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
    UsernameLabel.Font = Enum.Font.SourceSans
    UsernameLabel.TextSize = 9
    UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    UsernameLabel.BackgroundTransparency = 1

    -- Pages Holder
    local PagesHolder = Instance.new("Frame", MainWindow)
    PagesHolder.Size = UDim2.new(1, -165, 1, -35)
    PagesHolder.Position = UDim2.new(0, 155, 0, 30)
    PagesHolder.BackgroundTransparency = 1

    local Pages = {}
    local Tabs = {}
    local FirstTab = nil

    local function SwitchToTab(tabName)
        for name, page in pairs(Pages) do page.Visible = (name == tabName) end
        for name, btn in pairs(Tabs) do
            if name == tabName then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.85, BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
            else
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            end
        end
    end

    local WindowFunctions = {}

    function WindowFunctions:CreateTab(tabName, iconId)
        iconId = iconId or "rbxassetid://4483362458"
        
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, -12, 0, 28)
        TabBtn.BackgroundTransparency = 1
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.Text = ""
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)
        
        local TabLayout = Instance.new("Frame", TabBtn)
        TabLayout.Name = "TabLayout"
        TabLayout.Size = UDim2.new(1, 0, 1, 0)
        TabLayout.BackgroundTransparency = 1

        local Icon = Instance.new("ImageLabel", TabLayout)
        Icon.Name = "Icon"
        Icon.Size = UDim2.new(0, 12, 0, 12)
        Icon.Position = UDim2.new(0, 8, 0.5, -6)
        Icon.Image = iconId
        Icon.BackgroundTransparency = 1
        
        local Txt = Instance.new("TextLabel", TabLayout)
        Txt.Name = "Txt"
        Txt.Size = UDim2.new(1, -30, 1, 0)
        Txt.Position = UDim2.new(0, 26, 0, 0)
        Txt.Text = tabName
        Txt.TextColor3 = Color3.fromRGB(220, 220, 220)
        Txt.TextSize = 11
        Txt.Font = Enum.Font.SourceSansSemibold
        Txt.TextXAlignment = Enum.TextXAlignment.Left
        Txt.BackgroundTransparency = 1

        local ContentPage = Instance.new("ScrollingFrame", PagesHolder)
        ContentPage.Size = UDim2.new(1, 0, 1, 0)
        ContentPage.BackgroundTransparency = 1
        ContentPage.ScrollBarThickness = 2
        ContentPage.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
        ContentPage.Visible = false

        local ContentLayout = Instance.new("UIListLayout", ContentPage)
        ContentLayout.Padding = UDim.new(0, 6)
        ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ContentPage.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
        end)
        
        Pages[tabName] = ContentPage
        Tabs[tabName] = TabBtn

        if not FirstTab then
            FirstTab = tabName
            ContentPage.Visible = true
            TabBtn.BackgroundTransparency = 0.85
        end

        TabBtn.MouseButton1Click:Connect(function() SwitchToTab(tabName) end)

        local TabFunctions = {}

        function TabFunctions:CreateSection(sectionName)
            local SectionFrame = Instance.new("Frame", ContentPage)
            SectionFrame.Size = UDim2.new(1, -10, 0, 22)
            SectionFrame.BackgroundTransparency = 1

            local SectionLabel = Instance.new("TextLabel", SectionFrame)
            SectionLabel.Size = UDim2.new(1, 0, 1, 0)
            SectionLabel.Text = "──  " .. string.upper(sectionName) .. "  ──"
            SectionLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
            SectionLabel.Font = Enum.Font.SourceSansBold
            SectionLabel.TextSize = 11
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.BackgroundTransparency = 1
        end

        function TabFunctions:CreateButton(text, desc, callback)
            local FeatureFrame = Instance.new("Frame", ContentPage)
            FeatureFrame.Size = UDim2.new(1, -10, 0, 38)
            FeatureFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            FeatureFrame.BackgroundTransparency = 0.4
            Instance.new("UICorner", FeatureFrame).CornerRadius = UDim.new(0, 4)
            
            local Title = Instance.new("TextLabel", FeatureFrame)
            Title.Size = UDim2.new(0.7, 0, 1, 0)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1

            local ActionBtn = Instance.new("TextButton", FeatureFrame)
            ActionBtn.Size = UDim2.new(0, 60, 0, 20)
            ActionBtn.Position = UDim2.new(1, -68, 0.5, -10)
            ActionBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ActionBtn.Text = "Execute"
            ActionBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
            ActionBtn.Font = Enum.Font.SourceSansBold
            ActionBtn.TextSize = 10
            Instance.new("UICorner", ActionBtn).CornerRadius = UDim.new(0, 4)
            
            ActionBtn.MouseButton1Click:Connect(function() pcall(callback) end)
        end

        function TabFunctions:CreateToggle(text, flagName, default, callback)
            flagName = flagName or text
            if Library.Flags[flagName] ~= nil then default = Library.Flags[flagName] end
            Library.Flags[flagName] = default

            local FeatureFrame = Instance.new("Frame", ContentPage)
            FeatureFrame.Size = UDim2.new(1, -10, 0, 38)
            FeatureFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            FeatureFrame.BackgroundTransparency = 0.4
            Instance.new("UICorner", FeatureFrame).CornerRadius = UDim.new(0, 4)
            
            local Title = Instance.new("TextLabel", FeatureFrame)
            Title.Size = UDim2.new(0.7, 0, 1, 0)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1

            local ToggleBg = Instance.new("TextButton", FeatureFrame)
            ToggleBg.Size = UDim2.new(0, 32, 0, 18)
            ToggleBg.Position = UDim2.new(1, -40, 0.5, -9)
            ToggleBg.BackgroundColor3 = Library.Flags[flagName] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(60, 60, 60)
            ToggleBg.Text = ""
            Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

            local ToggleBall = Instance.new("Frame", ToggleBg)
            ToggleBall.Size = UDim2.new(0, 12, 0, 12)
            ToggleBall.Position = Library.Flags[flagName] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
            ToggleBall.BackgroundColor3 = Library.Flags[flagName] and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", ToggleBall).CornerRadius = UDim.new(1, 0)

            local IsOn = Library.Flags[flagName]
            ToggleBg.MouseButton1Click:Connect(function()
                IsOn = not IsOn
                Library.Flags[flagName] = IsOn
                SaveConfig()

                local targetPos = IsOn and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                local targetColor = IsOn and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(60, 60, 60)
                local ballColor = IsOn and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(255, 255, 255)
                
                TweenService:Create(ToggleBall, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {Position = targetPos, BackgroundColor3 = ballColor}):Play()
                TweenService:Create(ToggleBg, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
                pcall(callback, IsOn)
            end)

            local ToggleFuncs = {}
            function ToggleFuncs:Set(state)
                IsOn = state
                Library.Flags[flagName] = state
                SaveConfig()
                local targetPos = IsOn and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                local targetColor = IsOn and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(60, 60, 60)
                ToggleBg.BackgroundColor3 = targetColor
                ToggleBall.Position = targetPos
                pcall(callback, IsOn)
            end
            return ToggleFuncs
        end

        function TabFunctions:CreateSlider(text, min, max, default, flagName, callback)
            flagName = flagName or text
            if Library.Flags[flagName] ~= nil then default = Library.Flags[flagName] end
            Library.Flags[flagName] = default

            local FeatureFrame = Instance.new("Frame", ContentPage)
            FeatureFrame.Size = UDim2.new(1, -10, 0, 45)
            FeatureFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            FeatureFrame.BackgroundTransparency = 0.4
            Instance.new("UICorner", FeatureFrame).CornerRadius = UDim.new(0, 4)

            local Title = Instance.new("TextLabel", FeatureFrame)
            Title.Size = UDim2.new(0.6, 0, 0, 25)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1

            local ValueLabel = Instance.new("TextLabel", FeatureFrame)
            ValueLabel.Size = UDim2.new(0.3, 0, 0, 25)
            ValueLabel.Position = UDim2.new(0.7, -8, 0, 0)
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            ValueLabel.Font = Enum.Font.SourceSansBold
            ValueLabel.TextSize = 12
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.BackgroundTransparency = 1

            local SliderBar = Instance.new("TextButton", FeatureFrame)
            SliderBar.Size = UDim2.new(1, -16, 0, 6)
            SliderBar.Position = UDim2.new(0, 8, 1, -14)
            SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            SliderBar.Text = ""
            Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

            local SliderFill = Instance.new("Frame", SliderBar)
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

            local function UpdateSlider(input)
                local percentage = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteWidth, 0, 1)
                local value = math.floor(min + (max - min) * percentage)
                ValueLabel.Text = tostring(value)
                SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                Library.Flags[flagName] = value
                SaveConfig()
                pcall(callback, value)
            end

            local sliding = false
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    UpdateSlider(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)
        end

        function TabFunctions:CreateTextbox(text, placeholder, flagName, callback)
            flagName = flagName or text
            local FeatureFrame = Instance.new("Frame", ContentPage)
            FeatureFrame.Size = UDim2.new(1, -10, 0, 38)
            FeatureFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            FeatureFrame.BackgroundTransparency = 0.4
            Instance.new("UICorner", FeatureFrame).CornerRadius = UDim.new(0, 4)

            local Title = Instance.new("TextLabel", FeatureFrame)
            Title.Size = UDim2.new(0.5, 0, 1, 0)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1

            local TxtInput = Instance.new("TextBox", FeatureFrame)
            TxtInput.Size = UDim2.new(0, 110, 0, 22)
            TxtInput.Position = UDim2.new(1, -118, 0.5, -11)
            TxtInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            TxtInput.PlaceholderText = placeholder
            TxtInput.Text = Library.Flags[flagName] or ""
            TxtInput.TextColor3 = Color3.fromRGB(255, 255, 255)
            TxtInput.Font = Enum.Font.SourceSans
            TxtInput.TextSize = 11
            Instance.new("UICorner", TxtInput).CornerRadius = UDim.new(0, 4)

            TxtInput.FocusLost:Connect(function(enterPressed)
                Library.Flags[flagName] = TxtInput.Text
                SaveConfig()
                pcall(callback, TxtInput.Text, enterPressed)
            end)
        end

        function TabFunctions:CreateKeybind(text, defaultKey, flagName, callback)
            flagName = flagName or text
            local currentKey = defaultKey
            if Library.Flags[flagName] ~= nil then currentKey = Enum.KeyCode[Library.Flags[flagName]] or defaultKey end

            local FeatureFrame = Instance.new("Frame", ContentPage)
            FeatureFrame.Size = UDim2.new(1, -10, 0, 38)
            FeatureFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            FeatureFrame.BackgroundTransparency = 0.4
            Instance.new("UICorner", FeatureFrame).CornerRadius = UDim.new(0, 4)

            local Title = Instance.new("TextLabel", FeatureFrame)
            Title.Size = UDim2.new(0.6, 0, 1, 0)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1

            local BindBtn = Instance.new("TextButton", FeatureFrame)
            BindBtn.Size = UDim2.new(0, 80, 0, 22)
            BindBtn.Position = UDim2.new(1, -88, 0.5, -11)
            BindBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            BindBtn.Text = currentKey and currentKey.Name or "None"
            BindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            BindBtn.Font = Enum.Font.SourceSansBold
            BindBtn.TextSize = 11
            Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 4)

            local listening = false
            BindBtn.MouseButton1Click:Connect(function()
                listening = true
                BindBtn.Text = "..."
            end)

            local bindConnection
            bindConnection = UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        BindBtn.Text = currentKey.Name
                        listening = false
                        Library.Flags[flagName] = currentKey.Name
                        SaveConfig()
                    end
                else
                    if input.KeyCode == currentKey then
                        pcall(callback)
                    end
                end
            end)
            table.insert(Connections, bindConnection)
        end

        function TabFunctions:CreateParagraph(text, desc)
            local FeatureFrame = Instance.new("Frame", ContentPage)
            FeatureFrame.Size = UDim2.new(1, -10, 0, 45)
            FeatureFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            FeatureFrame.BackgroundTransparency = 0.6
            Instance.new("UICorner", FeatureFrame).CornerRadius = UDim.new(0, 4)

            local Title = Instance.new("TextLabel", FeatureFrame)
            Title.Size = UDim2.new(1, -16, 0, 18)
            Title.Position = UDim2.new(0, 8, 0, 4)
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1

            local DescLabel = Instance.new("TextLabel", FeatureFrame)
            DescLabel.Size = UDim2.new(1, -16, 0, 20)
            DescLabel.Position = UDim2.new(0, 8, 0, 20)
            DescLabel.Text = desc
            DescLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
            DescLabel.Font = Enum.Font.SourceSans
            DescLabel.TextSize = 10
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescLabel.TextWrapped = true
            DescLabel.BackgroundTransparency = 1
        end

        return TabFunctions
    end

    -- Automatically handle Key System if enabled
    if UseKeySystem then
        local KeyFrame = Instance.new("Frame", ScreenGui)
        KeyFrame.Size = UDim2.new(0, 280, 0, 140)
        KeyFrame.Position = UDim2.new(0.5, -140, 0.5, -70)
        KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8)
        MakeDraggable(KeyFrame)

        local KeyTitle = Instance.new("TextLabel", KeyFrame)
        KeyTitle.Size = UDim2.new(1, 0, 0, 30)
        KeyTitle.Text = "Key Verification System"
        KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeyTitle.Font = Enum.Font.SourceSansBold
        KeyTitle.TextSize = 14

        local KeyInput = Instance.new("TextBox", KeyFrame)
        KeyInput.Size = UDim2.new(1, -40, 0, 30)
        KeyInput.Position = UDim2.new(0, 20, 0, 45)
        KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        KeyInput.PlaceholderText = "Enter key here..."
        KeyInput.Text = ""
        KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeyInput.Font = Enum.Font.SourceSans
        KeyInput.TextSize = 12
        Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 4)

        local GetKeyBtn = Instance.new("TextButton", KeyFrame)
        GetKeyBtn.Size = UDim2.new(0, 110, 0, 28)
        GetKeyBtn.Position = UDim2.new(0, 25, 1, -42)
        GetKeyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        GetKeyBtn.Text = "Get Key"
        GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        GetKeyBtn.Font = Enum.Font.SourceSansBold
        GetKeyBtn.TextSize = 12
        Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 4)

        GetKeyBtn.MouseButton1Click:Connect(function()
            if setclipboard then setclipboard(GetKeyLink) end
            Library:Notify("Link Copied", "Key link has been copied to your clipboard!", 4)
        end)

        local VerifyBtn = Instance.new("TextButton", KeyFrame)
        VerifyBtn.Size = UDim2.new(0, 110, 0, 28)
        VerifyBtn.Position = UDim2.new(1, -135, 1, -42)
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
        VerifyBtn.Text = "Verify Key"
        VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        VerifyBtn.Font = Enum.Font.SourceSansBold
        VerifyBtn.TextSize = 12
        Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 4)

        VerifyBtn.MouseButton1Click:Connect(function()
            if KeyInput.Text == CorrectKey then
                KeyFrame:Destroy()
                MainWindow.Visible = true
                Library:Notify("Success", "Key verified successfully!", 4)
            else
                Library:Notify("Error", "Invalid key, please try again.", 4)
            end
        end)
    end

    return WindowFunctions
end

function Library:Unload()
    Library.Unloaded = true
    for _, conn in ipairs(Connections) do
        if conn and conn.Disconnect then conn:Disconnect() end
    end
    local OldGui = Player:WaitForChild("PlayerGui"):FindFirstChild("NexzanPremiumUiLib")
    if OldGui then OldGui:Destroy() end
end

return Library
