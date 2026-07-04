--[[
================================================================================
                    NEXZAN PREMIUM UI LIBRARY (v3.0 - ULTRAPACK DEFINITIVE)
================================================================================
    * Desain Premium Glassmorphic (Tanpa Warna Biru - Full White Accent)
    * Ukuran Jendela Utama: 480 x 280 (Lebih Ringkas, Padat, & Kompak)
    * Fitur Terlengkap & Teroptimasi untuk Mobile/HP & PC
    * Tombol Minimize Fleksibel & Draggable: "Open Nexzan UI"
    * Sistem Dragging Mulus (Mendukung Mouse & Layar Sentuh HP)
    * CONFIGURABLE KEY SYSTEM & AUTO CONFIG SYSTEM (Save/Load Otomatis!)
    * FITUR BARU: Sections/Groupbox, Multi-Dropdown, Search Dropdown, Color Gradient,
                 Toggle UI Keybind, & Full Unload System.
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

-- All Active Connections for clean unloading
local Connections = {}

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

    -- Minimize Button (Mobile Friendly)
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

    -- MAIN WINDOW FRAME (UKURAN KOMPAK BARU: 480x280)
    local MainWindow = Instance.new("Frame")
    MainWindow.Size = UDim2.new(0, 480, 0, 280)
    MainWindow.Position = UDim2.new(0.5, -240, 0.5, -140)
    MainWindow.BackgroundColor3 = Library.Theme.Background
    MainWindow.BackgroundTransparency = 0.15
    MainWindow.Active = true
    MainWindow.ClipsDescendants = true
    MainWindow.Parent = ScreenGui
    MainWindow.Visible = not UseKeySystem

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

    -- Sidebar Container
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Library.Theme.Sidebar
    Sidebar.BackgroundTransparency = 0.1
    Sidebar.BorderSizePixel = 0
    Sidebar.ClipsDescendants = true
    Sidebar.Parent = MainWindow
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

    local SidebarPatch = Instance.new("Frame", Sidebar)
    SidebarPatch.Size = UDim2.new(0, 12, 1, 0)
    SidebarPatch.Position = UDim2.new(1, -12, 0, 0)
    SidebarPatch.BackgroundColor3 = Library.Theme.Sidebar
    SidebarPatch.BackgroundTransparency = 0.1
    SidebarPatch.BorderSizePixel = 0

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

        -- [ NEW ELEMENT: SECTION / GROUPBOX ]
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

        -- [ ELEMENT: BUTTON ]
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

        -- [ ELEMENT: TOGGLE (WITH FLAG & CONFIG AUTO-SAVE) ]
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

        -- [ NEW ELEMENT: SEARCHABLE DROPDOWN ]
        function TabFunctions:CreateSearchDropdown(text, options, callback)
            local DropdownFrame = Instance.new("Frame", ContentPage)
            DropdownFrame.Size = UDim2.new(1, -10, 0, 38)
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            DropdownFrame.BackgroundTransparency = 0.4
            DropdownFrame.ClipsDescendants = true
            Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 4)

            local Title = Instance.new("TextLabel", DropdownFrame)
            Title.Size = UDim2.new(0.5, 0, 0, 38)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1

            local SearchBox = Instance.new("TextBox", DropdownFrame)
            SearchBox.Size = UDim2.new(0, 100, 0, 20)
            SearchBox.Position = UDim2.new(1, -108, 0, 9)
            SearchBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            SearchBox.PlaceholderText = "Search..."
            SearchBox.Text = options[1] or "Select..."
            SearchBox.TextColor3 = Color3.fromRGB(220, 220, 220)
            SearchBox.Font = Enum.Font.SourceSans
            SearchBox.TextSize = 11
            Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 4)

            local ContainerOptions = Instance.new("Frame", DropdownFrame)
            ContainerOptions.Size = UDim2.new(1, -16, 0, 0)
            ContainerOptions.Position = UDim2.new(0, 8, 0, 42)
            ContainerOptions.BackgroundTransparency = 1

            local DropLayout = Instance.new("UIListLayout", ContainerOptions)
            DropLayout.Padding = UDim.new(0, 2)

            local IsExpanded = false
            local function RebuildOptions(filter)
                for _, child in ipairs(ContainerOptions:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                
                local count = 0
                for _, optName in ipairs(options) do
                    if not filter or string.find(string.lower(optName), string.lower(filter)) then
                        count = count + 1
                        local OptBtn = Instance.new("TextButton", ContainerOptions)
                        OptBtn.Size = UDim2.new(1, 0, 0, 20)
                        OptBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                        OptBtn.Text = optName
                        OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                        OptBtn.Font = Enum.Font.SourceSans
                        OptBtn.TextSize = 11
                        Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 3)

                        OptBtn.MouseButton1Click:Connect(function()
                            SearchBox.Text = optName
                            IsExpanded = false
                            TweenService:Create(DropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -10, 0, 38)}):Play()
                            pcall(callback, optName)
                        end)
                    end
                end
                ContainerOptions.Size = UDim2.new(1, -16, 0, count * 22)
                if IsExpanded then
                    DropdownFrame.Size = UDim2.new(1, -10, 0, 45 + (count * 22))
                end
            end

            SearchBox.Focused:Connect(function()
                IsExpanded = true
                SearchBox.Text = ""
                RebuildOptions("")
            end)

            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                if IsExpanded then RebuildOptions(SearchBox.Text) end
            end)

            local DropFunctions = {}
            function DropFunctions:Refresh(newOptions)
                options = newOptions
                if IsExpanded then RebuildOptions(SearchBox.Text) end
            end
            return DropFunctions
        end

        -- [ NEW ELEMENT: MULTI-SELECT DROPDOWN ]
        function TabFunctions:CreateMultiDropdown(text, options, defaultSelected, callback)
            local SelectedItems = defaultSelected or {}
            
            local DropdownFrame = Instance.new("Frame", ContentPage)
            DropdownFrame.Size = UDim2.new(1, -10, 0, 38)
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            DropdownFrame.BackgroundTransparency = 0.4
            DropdownFrame.ClipsDescendants = true
            Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 4)

            local Title = Instance.new("TextLabel", DropdownFrame)
            Title.Size = UDim2.new(0.5, 0, 0, 38)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1

            local OpenBtn = Instance.new("TextButton", DropdownFrame)
            OpenBtn.Size = UDim2.new(0, 100, 0, 20)
            OpenBtn.Position = UDim2.new(1, -108, 0, 9)
            OpenBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            OpenBtn.Text = "Multiple..."
            OpenBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
            OpenBtn.Font = Enum.Font.SourceSansBold
            OpenBtn.TextSize = 11
            Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 4)

            local ContainerOptions = Instance.new("Frame", DropdownFrame)
            ContainerOptions.Size = UDim2.new(1, -16, 0, #options * 22)
            ContainerOptions.Position = UDim2.new(0, 8, 0, 42)
            ContainerOptions.BackgroundTransparency = 1

            local DropLayout = Instance.new("UIListLayout", ContainerOptions)
            DropLayout.Padding = UDim.new(0, 2)

            local IsExpanded = false
            OpenBtn.MouseButton1Click:Connect(function()
                IsExpanded = not IsExpanded
                local targetHeight = IsExpanded and (42 + (#options * 22) + 4) or 38
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -10, 0, targetHeight)}):Play()
            end)

            for _, optName in ipairs(options) do
                local OptBtn = Instance.new("TextButton", ContainerOptions)
                OptBtn.Size = UDim2.new(1, 0, 0, 20)
                
                local isSelected = table.find(SelectedItems, optName) ~= nil
                OptBtn.BackgroundColor3 = isSelected and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(35, 35, 35)
                OptBtn.Text = optName
                OptBtn.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
                OptBtn.Font = Enum.Font.SourceSans
                OptBtn.TextSize = 11
                Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 3)

                OptBtn.MouseButton1Click:Connect(function()
                    local idx = table.find(SelectedItems, optName)
                    if idx then
                        table.remove(SelectedItems, idx)
                        OptBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                        OptBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
                    else
                        table.insert(SelectedItems, optName)
                        OptBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                        OptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    end
                    pcall(callback, SelectedItems)
                end)
            end
        end

        -- [ NEW ELEMENT: COLORPICKER CANVAS GRADIENT ]
        function TabFunctions:CreateColorpicker(text, flagName, defaultColor, callback)
            flagName = flagName or text
            if Library.Flags[flagName] ~= nil then defaultColor = Library.Flags[flagName] end
            Library.Flags[flagName] = defaultColor

            local CpFrame = Instance.new("Frame", ContentPage)
            CpFrame.Size = UDim2.new(1, -10, 0, 38)
            CpFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            CpFrame.BackgroundTransparency = 0.4
            CpFrame.ClipsDescendants = true
            Instance.new("UICorner", CpFrame).CornerRadius = UDim.new(0, 4)

            local Title = Instance.new("TextLabel", CpFrame)
            Title.Size = UDim2.new(0.6, 0, 0, 38)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1

            local ColorDisplay = Instance.new("TextButton", CpFrame)
            ColorDisplay.Size = UDim2.new(0, 26, 0, 16)
            ColorDisplay.Position = UDim2.new(1, -34, 0.5, -8)
            ColorDisplay.BackgroundColor3 = defaultColor
            ColorDisplay.Text = ""
            Instance.new("UICorner", ColorDisplay).CornerRadius = UDim.new(0, 3)

            local CanvasFrame = Instance.new("Frame", CpFrame)
            CanvasFrame.Size = UDim2.new(1, -16, 0, 50)
            CanvasFrame.Position = UDim2.new(0, 8, 0, 42)
            CanvasFrame.BorderSizePixel = 0

            local UIGradient = Instance.new("UIGradient", CanvasFrame)
            UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
            })

            local PickerBtn = Instance.new("TextButton", CanvasFrame)
            PickerBtn.Size = UDim2.new(1, 0, 1, 0)
            PickerBtn.BackgroundTransparency = 1
            PickerBtn.Text = ""

            local IsExpanded = false
            ColorDisplay.MouseButton1Click:Connect(function()
                IsExpanded = not IsExpanded
                local targetHeight = IsExpanded and 100 or 38
                TweenService:Create(CpFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -10, 0, targetHeight)}):Play()
            end)

            local function UpdateColor(input)
                local x = math.clamp((input.Position.X - CanvasFrame.AbsolutePosition.X) / CanvasFrame.AbsoluteSize.X, 0, 1)
                
                -- Simple interpolation over the gradient keypoints
                local r, g, b = 0, 0, 0
                local segment = x * 5
                local i = math.floor(segment)
                local f = segment - i
                
                if i == 0 then r, g, b = 1, f, 0
                elseif i == 1 then r, g, b = 1-f, 1, 0
                elseif i == 2 then r, g, b = 0, 1, f
                elseif i == 3 then r, g, b = 0, 1-f, 1
                elseif i == 4 then r, g, b = f, 0, 1
                else r, g, b = 1, 0, 1-f end

                local pickedColor = Color3.new(r, g, b)
                ColorDisplay.BackgroundColor3 = pickedColor
                Library.Flags[flagName] = pickedColor
                SaveConfig()
                pcall(callback, pickedColor)
            end

            local Dragging = false
            PickerBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    UpdateColor(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateColor(input)
                end
            end)
        end

        -- Legacy inputs mapped smoothly for architectural alignment
        function TabFunctions:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame", ContentPage)
            SliderFrame.Size = UDim2.new(1, -10, 0, 42)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            SliderFrame.BackgroundTransparency = 0.4
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 4)

            local Title = Instance.new("TextLabel", SliderFrame)
            Title.Size = UDim2.new(0.6, 0, 0, 16)
            Title.Position = UDim2.new(0, 8, 0, 4)
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1

            local ValueLabel = Instance.new("TextLabel", SliderFrame)
            ValueLabel.Size = UDim2.new(0.3, 0, 0, 16)
            ValueLabel.Position = UDim2.new(0.7, -8, 0, 4)
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValueLabel.Font = Enum.Font.SourceSansBold
            ValueLabel.TextSize = 12
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.BackgroundTransparency = 1

            local SliderBarBg = Instance.new("TextButton", SliderFrame)
            SliderBarBg.Size = UDim2.new(1, -16, 0, 4)
            SliderBarBg.Position = UDim2.new(0, 8, 0, 26)
            SliderBarBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            SliderBarBg.Text = ""
            Instance.new("UICorner", SliderBarBg).CornerRadius = UDim.new(1, 0)

            local SliderBarFill = Instance.new("Frame", SliderBarBg)
            SliderBarFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderBarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderBarFill.BorderSizePixel = 0
            Instance.new("UICorner", SliderBarFill).CornerRadius = UDim.new(1, 0)

            local Dragging = false
            local function UpdateSlider(input)
                local relativeX = input.Position.X - SliderBarBg.AbsolutePosition.X
                local pct = math.clamp(relativeX / SliderBarBg.AbsoluteSize.X, 0, 1)
                local finalVal = math.round(min + (pct * (max - min)))

                SliderBarFill.Size = UDim2.new(pct, 0, 1, 0)
                ValueLabel.Text = tostring(finalVal)
                pcall(callback, finalVal)
            end

            SliderBarBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    UpdateSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)
        end

        function TabFunctions:CreateDropdown(text, options, callback)
            return TabFunctions:CreateSearchDropdown(text, options, callback)
        end

        function TabFunctions:CreateTextbox(text, placeholder, callback)
            local InputFrame = Instance.new("Frame", ContentPage)
            InputFrame.Size = UDim2.new(1, -10, 0, 38)
            InputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            InputFrame.BackgroundTransparency = 0.4
            Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 4)

            local Title = Instance.new("TextLabel", InputFrame)
            Title.Size = UDim2.new(0.5, 0, 1, 0)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1

            local InputBox = Instance.new("TextBox", InputFrame)
            InputBox.Size = UDim2.new(0, 100, 0, 20)
            InputBox.Position = UDim2.new(1, -108, 0.5, -10)
            InputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            InputBox.PlaceholderText = placeholder or "Type..."
            InputBox.Text = ""
            InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            InputBox.Font = Enum.Font.SourceSans
            InputBox.TextSize = 11
            Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 4)

            InputBox.FocusLost:Connect(function(enterPressed)
                pcall(callback, InputBox.Text, enterPressed)
            end)
        end

        function TabFunctions:CreateKeybind(text, defaultKey, callback)
            local KeybindFrame = Instance.new("Frame", ContentPage)
            KeybindFrame.Size = UDim2.new(1, -10, 0, 38)
            KeybindFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            KeybindFrame.BackgroundTransparency = 0.4
            Instance.new("UICorner", KeybindFrame).CornerRadius = UDim.new(0, 4)

            local Title = Instance.new("TextLabel", KeybindFrame)
            Title.Size = UDim2.new(0.6, 0, 1, 0)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1

            local BindBtn = Instance.new("TextButton", KeybindFrame)
            BindBtn.Size = UDim2.new(0, 60, 0, 20)
            BindBtn.Position = UDim2.new(1, -68, 0.5, -10)
            BindBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            BindBtn.Text = defaultKey and defaultKey.Name or "NONE"
            BindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            BindBtn.Font = Enum.Font.SourceSansBold
            BindBtn.TextSize = 11
            Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 4)

            local CurrentKey = defaultKey
            local Listening = false

            BindBtn.MouseButton1Click:Connect(function()
                BindBtn.Text = "..."
                Listening = true
            end)

            local keybindConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if Listening and not gameProcessed then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        Listening = false
                        CurrentKey = input.KeyCode
                        BindBtn.Text = CurrentKey.Name
                        pcall(callback, CurrentKey)
                    end
                elseif not Listening and CurrentKey and input.KeyCode == CurrentKey and not gameProcessed then
                    pcall(callback, CurrentKey)
                end
            end)
            table.insert(Connections, keybindConn)
        end

        function TabFunctions:CreateLabel(text, isParagraph)
            local LabelFrame = Instance.new("Frame", ContentPage)
            local FrameHeight = isParagraph and 45 or 24
            LabelFrame.Size = UDim2.new(1, -10, 0, FrameHeight)
            LabelFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            LabelFrame.BackgroundTransparency = 0.6
            Instance.new("UICorner", LabelFrame).CornerRadius = UDim.new(0, 4)
            
            local LabelText = Instance.new("TextLabel", LabelFrame)
            LabelText.Size = UDim2.new(1, -16, 1, 0)
            LabelText.Position = UDim2.new(0, 8, 0, 0)
            LabelText.Text = text
            LabelText.TextColor3 = isParagraph and Color3.fromRGB(180, 180, 180) or Color3.fromRGB(255, 255, 255)
            LabelText.Font = isParagraph and Enum.Font.SourceSans or Enum.Font.SourceSansBold
            LabelText.TextSize = 11
            LabelText.TextXAlignment = Enum.TextXAlignment.Left
            LabelText.TextWrapped = isParagraph
            LabelText.BackgroundTransparency = 1

            return {SetText = function(nt) LabelText.Text = nt end}
        end

        return TabFunctions
    end

    -- [ NEW FEATURE: TOGGLE UI KEYBIND (RightShift / Configurable) ]
    local toggleUIConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == ToggleKey then
            if MainWindow.Visible then
                MainWindow.Visible = false
                MinimizedBtn.Visible = true
            else
                MainWindow.Visible = true
                MinimizedBtn.Visible = false
            end
        end
    end)
    table.insert(Connections, toggleUIConn)

    -- Collapse & Minimize Logic (Original Preserved)
    local sidebarExpanded = true
    local lastInteraction = tick()
    local isMouseOverSidebar = false

    local function ResetInactivityTimer() lastInteraction = tick() end

    local function CollapseSidebar()
        if not sidebarExpanded or Library.Unloaded then return end
        sidebarExpanded = false
        local tInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(Sidebar, tInfo, {Size = UDim2.new(0, 40, 1, 0)}):Play()
        TweenService:Create(SidebarPatch, tInfo, {Size = UDim2.new(0, 0, 1, 0)}):Play()
        TweenService:Create(PagesHolder, tInfo, {Size = UDim2.new(1, -55, 1, -35), Position = UDim2.new(0, 48, 0, 30)}):Play()
        
        local fadeInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
        TweenService:Create(GameTitle, fadeInfo, {TextTransparency = 1}):Play()
        TweenService:Create(AuthorLabel, fadeInfo, {TextTransparency = 1}):Play()
        TweenService:Create(DisplayNameLabel, fadeInfo, {TextTransparency = 1}):Play()
        TweenService:Create(UsernameLabel, fadeInfo, {TextTransparency = 1}):Play()
        TweenService:Create(AvatarImg, tInfo, {Position = UDim2.new(0.5, -12, 0.5, -12)}):Play()

        for _, btn in pairs(Tabs) do
            local layout = btn:FindFirstChild("TabLayout")
            if layout then
                local txt = layout:FindFirstChild("Txt")
                local icon = layout:FindFirstChild("Icon")
                if txt then TweenService:Create(txt, fadeInfo, {TextTransparency = 1}):Play() end
                if icon then TweenService:Create(icon, tInfo, {Position = UDim2.new(0.5, -6, 0.5, -6)}):Play() end
            end
        end
    end

    local function ExpandSidebar()
        ResetInactivityTimer()
        if sidebarExpanded or Library.Unloaded then return end
        sidebarExpanded = true
        local tInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(Sidebar, tInfo, {Size = UDim2.new(0, 150, 1, 0)}):Play()
        TweenService:Create(SidebarPatch, tInfo, {Size = UDim2.new(0, 12, 1, 0)}):Play()
        TweenService:Create(PagesHolder, tInfo, {Size = UDim2.new(1, -165, 1, -35), Position = UDim2.new(0, 155, 0, 30)}):Play()
        
        local fadeInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad)
        TweenService:Create(GameTitle, fadeInfo, {TextTransparency = 0}):Play()
        TweenService:Create(AuthorLabel, fadeInfo, {TextTransparency = 0}):Play()
        TweenService:Create(DisplayNameLabel, fadeInfo, {TextTransparency = 0}):Play()
        TweenService:Create(UsernameLabel, fadeInfo, {TextTransparency = 0}):Play()
        TweenService:Create(AvatarImg, tInfo, {Position = UDim2.new(0, 6, 0.5, -12)}):Play()

        for _, btn in pairs(Tabs) do
            local layout = btn:FindFirstChild("TabLayout")
            if layout then
                local txt = layout:FindFirstChild("Txt")
                local icon = layout:FindFirstChild("Icon")
                if txt then TweenService:Create(txt, fadeInfo, {TextTransparency = 0}):Play() end
                if icon then TweenService:Create(icon, tInfo, {Position = UDim2.new(0, 8, 0.5, -6)}):Play() end
            end
        end
    end

    Sidebar.MouseEnter:Connect(function() isMouseOverSidebar = true; ExpandSidebar() end)
    Sidebar.MouseLeave:Connect(function() isMouseOverSidebar = false; ResetInactivityTimer() end)

    local isTransitioning = false
    local originalWindowSize = UDim2.new(0, 480, 0, 280)
    local lastWindowPos = MainWindow.Position

    local function MinimizeWindowAnimation()
        if isTransitioning or not MainWindow.Visible or Library.Unloaded then return end
        isTransitioning = true
        lastWindowPos = MainWindow.Position
        MainWindow.Active = false

        for _, child in ipairs(MainWindow:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("ScrollingFrame") then child.Visible = false end
        end

        MinimizedBtn.Visible = true
        MinimizedBtn.Size = UDim2.new(0, 0, 0, 0)
        
        TweenService:Create(MainWindow, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 130, 0, 28),
            Position = MinimizedBtn.Position,
            BackgroundTransparency = 1
        }):Play()

        task.wait(0.4)
        MainWindow.Visible = false
        TweenService:Create(MinimizedBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 130, 0, 28),
            BackgroundTransparency = 0.1
        }):Play()
        isTransitioning = false
    end

    local function MaximizeWindowAnimation()
        if isTransitioning or MainWindow.Visible or Library.Unloaded then return end
        isTransitioning = true
        
        MinimizedBtn.Visible = false
        MainWindow.Position = MinimizedBtn.Position
        MainWindow.Size = UDim2.new(0, 130, 0, 28)
        MainWindow.Visible = true

        TweenService:Create(MainWindow, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = originalWindowSize,
            Position = lastWindowPos,
            BackgroundTransparency = 0.15
        }):Play()
        
        task.wait(0.4)
        for _, child in ipairs(MainWindow:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("ScrollingFrame") then child.Visible = true end
        end
        MainWindow.Active = true
        ResetInactivityTimer()
        isTransitioning = false
    end

    BtnMinimize.MouseButton1Click:Connect(MinimizeWindowAnimation)
    MinimizedBtn.MouseButton1Click:Connect(MaximizeWindowAnimation)

    -- [ FULL UNLOAD SYSTEM ]
    function Library:Unload()
        Library.Unloaded = true
        for _, conn in pairs(Connections) do
            if conn and conn.Disconnect then pcall(function() conn:Disconnect() end) end
        end
        if ScreenGui then ScreenGui:Destroy() end
    end

    BtnClose.MouseButton1Click:Connect(function()
        Library:Unload()
    end)

    -- Inactivity Loop Thread
    task.spawn(function()
        while task.wait(0.5) do
            if Library.Unloaded then break end
            if MainWindow.Visible and not isTransitioning then
                local idleTime = tick() - lastInteraction
                if sidebarExpanded and idleTime >= 3 and not isMouseOverSidebar then CollapseSidebar() end
                if idleTime >= 5 then 
                    MinimizeWindowAnimation() 
                    Library:Notify("Auto Minimize", "UI disembunyikan otomatis karena 5 detik tidak ada aktivitas.", 3)
                end
            end
        end
    end)

    -- Key System
    if UseKeySystem then
        local KeyFrame = Instance.new("Frame", ScreenGui)
        KeyFrame.Size = UDim2.new(0, 300, 0, 180)
        KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
        KeyFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        MakeDraggable(KeyFrame)
        Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 6)

        local Title = Instance.new("TextLabel", KeyFrame)
        Title.Size = UDim2.new(1, 0, 0, 25)
        Title.Position = UDim2.new(0, 0, 0, 10)
        Title.Text = "Key System Nexzan"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.SourceSansBold
        Title.TextSize = 16
        Title.BackgroundTransparency = 1

        local KeyInput = Instance.new("TextBox", KeyFrame)
        KeyInput.Size = UDim2.new(0, 240, 0, 28)
        KeyInput.Position = UDim2.new(0.5, -120, 0.5, -14)
        KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        KeyInput.PlaceholderText = "Enter Key Here..."
        KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeyInput.Font = Enum.Font.SourceSans
        KeyInput.TextSize = 12
        Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 4)

        local GetKeyBtn = Instance.new("TextButton", KeyFrame)
        GetKeyBtn.Size = UDim2.new(0, 110, 0, 28)
        GetKeyBtn.Position = UDim2.new(0, 25, 1, -42)
        GetKeyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        GetKeyBtn.Text = "GetKey"
        GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        GetKeyBtn.Font = Enum.Font.SourceSansBold
        GetKeyBtn.TextSize = 12
        Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 4)

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
                ResetInactivityTimer()
            else
                VerifyBtn.Text = "Wrong Key!"
                task.wait(1)
                VerifyBtn.Text = "Verify Key"
            end
        end)
    end

    return WindowFunctions
end

return Library
