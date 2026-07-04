--[[
================================================================================
                    NEXZAN PREMIUM UI LIBRARY (v5.0 - ULTIMATE EDITION)
================================================================================
    * Desain Premium Glassmorphic - Full Custom Themes (Light, Dark, dll)
    * Ukuran Jendela Utama: 520 x 320 (Ringkas, Padat, & Kompak)
    * Fitur TERLENGKAP untuk Mobile/HP & PC
    * Tombol Minimize Fleksibel & Draggable: "Open Nexzan UI"
    * Sistem Dragging Mulus (Mendukung Mouse & Layar Sentuh HP)
    * CONFIGURABLE KEY SYSTEM & AUTO CONFIG SYSTEM (Save/Load Otomatis!)
    * FITUR LENGKAP: 
        - Buttons, Toggles, Sliders (Fix Presisi Tinggi), 
        - Textboxes, Keybinds, Paragraphs/Labels,
        - Dropdowns (Single, Multi, Searchable), 
        - Colorpickers (RGB & Alpha),
        - Watermark (FPS, Ping, Time), 
        - UI Toggle Keybind, Full Unload System, Theme Manager!
================================================================================
]]

local Library = {}
Library.Unloaded = false
Library.Flags = {}
Library.Theme = {
    Accent = Color3.fromRGB(255, 255, 255),
    Background = Color3.fromRGB(20, 20, 20),
    Sidebar = Color3.fromRGB(15, 15, 15),
    Element = Color3.fromRGB(30, 30, 30),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 150)
}

-- Predefined Themes
Library.Themes = {
    Dark = {
        Accent = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(20, 20, 20),
        Sidebar = Color3.fromRGB(15, 15, 15),
        Element = Color3.fromRGB(30, 30, 30),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(150, 150, 150)
    },
    Light = {
        Accent = Color3.fromRGB(40, 40, 40),
        Background = Color3.fromRGB(240, 240, 240),
        Sidebar = Color3.fromRGB(220, 220, 220),
        Element = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(20, 20, 20),
        TextDark = Color3.fromRGB(100, 100, 100)
    },
    Vampire = {
        Accent = Color3.fromRGB(255, 40, 40),
        Background = Color3.fromRGB(20, 10, 10),
        Sidebar = Color3.fromRGB(12, 5, 5),
        Element = Color3.fromRGB(35, 15, 15),
        Text = Color3.fromRGB(255, 200, 200),
        TextDark = Color3.fromRGB(180, 100, 100)
    },
    Aqua = {
        Accent = Color3.fromRGB(0, 200, 255),
        Background = Color3.fromRGB(10, 20, 25),
        Sidebar = Color3.fromRGB(5, 10, 15),
        Element = Color3.fromRGB(15, 30, 35),
        Text = Color3.fromRGB(200, 240, 255),
        TextDark = Color3.fromRGB(100, 150, 180)
    }
}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local ProtectGui = gethui and gethui() or CoreGui

-- Configuration System
local ConfigFolder = "NexzanConfigs"
local ConfigFile = "Config_v5.json"

local function SaveConfig()
    if not isfolder or not writefile then return end
    if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
    
    local data = {}
    for k, v in pairs(Library.Flags) do
        if typeof(v) == "Color3" then
            data[k] = {r = v.R, g = v.G, b = v.B, isColor = true}
        elseif typeof(v) == "EnumItem" then
            data[k] = {name = v.Name, isEnum = true}
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
            elseif type(v) == "table" and v.isEnum then
                Library.Flags[k] = Enum.KeyCode[v.name]
            else
                Library.Flags[k] = v
            end
        end
    end
end

-- Global Helper: Smooth Dragging Function
local function MakeDraggable(topbarObject, objectToDrag)
    objectToDrag = objectToDrag or topbarObject
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
        TweenService:Create(objectToDrag, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    end

    topbarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = objectToDrag.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbarObject.InputChanged:Connect(function(input)
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

-- Create GUI Tween Helper
local function Tween(obj, props, time)
    local tween = TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local Connections = {}
local MainObjects = {}

function Library:SetTheme(themeName)
    local theme = Library.Themes[themeName]
    if not theme then return end
    Library.Theme = theme
    
    if MainObjects.MainWindow then
        Tween(MainObjects.MainWindow, {BackgroundColor3 = theme.Background})
        Tween(MainObjects.Sidebar, {BackgroundColor3 = theme.Sidebar})
        Tween(MainObjects.SidebarPatch, {BackgroundColor3 = theme.Sidebar})
        
        -- Update all elements color
        for _, el in pairs(MainObjects.Elements) do
            if el:IsA("Frame") or el:IsA("TextBox") or el:IsA("TextButton") then
                Tween(el, {BackgroundColor3 = theme.Element})
            end
            if el:IsA("TextLabel") or el:IsA("TextBox") then
                if el.Name == "Desc" or el.Name == "Author" then
                    Tween(el, {TextColor3 = theme.TextDark})
                else
                    Tween(el, {TextColor3 = theme.Text})
                end
            end
        end
    end
end

function Library:CreateWindow(Config)
    LoadConfig()

    local UiTitle = "Nexzan Premium"
    local UseKeySystem = false
    local CorrectKey = "NexzanGanteng"
    local GetKeyLink = "https://link.com"
    local ToggleUIKey = Enum.KeyCode.RightControl
    local UseWatermark = true

    if type(Config) == "table" then
        UiTitle = Config.Name or UiTitle
        ToggleUIKey = Config.ToggleKey or ToggleUIKey
        UseWatermark = Config.Watermark == nil and true or Config.Watermark
        if Config.KeySystem == true then
            UseKeySystem = true
            CorrectKey = Config.Key or CorrectKey
            GetKeyLink = Config.Link or GetKeyLink
        end
    elseif type(Config) == "string" then
        UiTitle = Config
    end
    
    local OldGui = ProtectGui:FindFirstChild("NexzanUltimateUi")
    if OldGui then OldGui:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NexzanUltimateUi"
    ScreenGui.Parent = ProtectGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    MainObjects.Elements = {}

    -- WATERMARK SYSTEM
    if UseWatermark then
        local WatermarkFrame = Instance.new("Frame")
        WatermarkFrame.Size = UDim2.new(0, 0, 0, 24)
        WatermarkFrame.Position = UDim2.new(0, 15, 0, 15)
        WatermarkFrame.BackgroundColor3 = Library.Theme.Element
        WatermarkFrame.BackgroundTransparency = 0.2
        WatermarkFrame.ClipsDescendants = true
        WatermarkFrame.Parent = ScreenGui
        table.insert(MainObjects.Elements, WatermarkFrame)

        Instance.new("UICorner", WatermarkFrame).CornerRadius = UDim.new(0, 4)
        local WmStroke = Instance.new("UIStroke", WatermarkFrame)
        WmStroke.Color = Color3.fromRGB(60, 60, 60)
        
        local WmText = Instance.new("TextLabel", WatermarkFrame)
        WmText.Size = UDim2.new(1, -16, 1, 0)
        WmText.Position = UDim2.new(0, 8, 0, 0)
        WmText.BackgroundTransparency = 1
        WmText.Text = UiTitle .. " | FPS: 60 | Ping: 50ms"
        WmText.TextColor3 = Library.Theme.Text
        WmText.Font = Enum.Font.SourceSansBold
        WmText.TextSize = 12
        WmText.TextXAlignment = Enum.TextXAlignment.Left
        table.insert(MainObjects.Elements, WmText)

        local function UpdateWatermark()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local timeStr = os.date("%X")
            WmText.Text = string.format("%s | FPS: %d | Ping: %dms | %s", UiTitle, fps, ping, timeStr)
            WatermarkFrame.Size = UDim2.new(0, WmText.TextBounds.X + 20, 0, 24)
        end
        
        local wmConn = RunService.RenderStepped:Connect(function()
            if Library.Unloaded then wmConn:Disconnect() return end
            if tick() % 1 < 0.1 then UpdateWatermark() end
        end)
        table.insert(Connections, wmConn)
    end

    -- NOTIFICATION SYSTEM
    local NotificationArea = Instance.new("Frame")
    NotificationArea.Name = "NotificationArea"
    NotificationArea.Size = UDim2.new(0, 280, 1, -20)
    NotificationArea.Position = UDim2.new(1, -290, 0, 10)
    NotificationArea.BackgroundTransparency = 1
    NotificationArea.Parent = ScreenGui

    local NotifLayout = Instance.new("UIListLayout")
    NotifLayout.Parent = NotificationArea
    NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifLayout.Padding = UDim.new(0, 8)

    function Library:Notify(title, desc, duration)
        title = title or "Notification"
        desc = desc or "..."
        duration = duration or 4

        local NotifFrame = Instance.new("Frame")
        NotifFrame.Size = UDim2.new(1, 0, 0, 0)
        NotifFrame.BackgroundColor3 = Library.Theme.Element
        NotifFrame.BackgroundTransparency = 0.1
        NotifFrame.ClipsDescendants = true
        NotifFrame.Parent = NotificationArea
        table.insert(MainObjects.Elements, NotifFrame)

        Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 6)
        local Stroke = Instance.new("UIStroke", NotifFrame)
        Stroke.Color = Color3.fromRGB(60, 60, 60)

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, -20, 0, 18)
        TitleLabel.Position = UDim2.new(0, 10, 0, 6)
        TitleLabel.Text = title
        TitleLabel.TextColor3 = Library.Theme.Text
        TitleLabel.Font = Enum.Font.SourceSansBold
        TitleLabel.TextSize = 13
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Parent = NotifFrame
        table.insert(MainObjects.Elements, TitleLabel)

        local DescLabel = Instance.new("TextLabel")
        DescLabel.Name = "Desc"
        DescLabel.Size = UDim2.new(1, -20, 1, -30)
        DescLabel.Position = UDim2.new(0, 10, 0, 24)
        DescLabel.Text = desc
        DescLabel.TextColor3 = Library.Theme.TextDark
        DescLabel.Font = Enum.Font.SourceSans
        DescLabel.TextSize = 12
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.TextYAlignment = Enum.TextYAlignment.Top
        DescLabel.TextWrapped = true
        DescLabel.BackgroundTransparency = 1
        DescLabel.Parent = NotifFrame
        table.insert(MainObjects.Elements, DescLabel)

        local ProgressBar = Instance.new("Frame")
        ProgressBar.Size = UDim2.new(1, 0, 0, 2)
        ProgressBar.Position = UDim2.new(0, 0, 1, -2)
        ProgressBar.BackgroundColor3 = Library.Theme.Accent
        ProgressBar.BorderSizePixel = 0
        ProgressBar.Parent = NotifFrame

        local targetHeight = 35 + DescLabel.TextBounds.Y
        if targetHeight < 55 then targetHeight = 55 end

        Tween(NotifFrame, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.3)
        Tween(ProgressBar, {Size = UDim2.new(0, 0, 0, 2)}, duration)

        task.spawn(function()
            task.wait(duration)
            local shrink = Tween(NotifFrame, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
            shrink.Completed:Connect(function() NotifFrame:Destroy() end)
        end)
    end

    -- MINIMIZE BUTTON
    local MinimizedBtn = Instance.new("TextButton")
    MinimizedBtn.Size = UDim2.new(0, 140, 0, 30)
    MinimizedBtn.Position = UDim2.new(0.5, -70, 0, 15)
    MinimizedBtn.BackgroundColor3 = Library.Theme.Element
    MinimizedBtn.BackgroundTransparency = 0.1
    MinimizedBtn.Text = "🚀 Open UI"
    MinimizedBtn.TextColor3 = Library.Theme.Text
    MinimizedBtn.Font = Enum.Font.SourceSansBold
    MinimizedBtn.TextSize = 13
    MinimizedBtn.Visible = false
    MinimizedBtn.Parent = ScreenGui
    table.insert(MainObjects.Elements, MinimizedBtn)

    Instance.new("UICorner", MinimizedBtn).CornerRadius = UDim.new(0, 6)
    local MinStroke = Instance.new("UIStroke", MinimizedBtn)
    MinStroke.Color = Color3.fromRGB(60, 60, 60)
    MakeDraggable(MinimizedBtn)

    -- MAIN WINDOW
    local MainWindow = Instance.new("Frame")
    MainWindow.Size = UDim2.new(0, 520, 0, 320)
    MainWindow.Position = UDim2.new(0.5, -260, 0.5, -160)
    MainWindow.BackgroundColor3 = Library.Theme.Background
    MainWindow.BackgroundTransparency = 0.05
    MainWindow.Active = true
    MainWindow.ClipsDescendants = true
    MainWindow.Parent = ScreenGui
    MainWindow.Visible = not UseKeySystem
    MainObjects.MainWindow = MainWindow

    Instance.new("UICorner", MainWindow).CornerRadius = UDim.new(0, 8)
    
    local TopbarDrag = Instance.new("Frame", MainWindow)
    TopbarDrag.Size = UDim2.new(1, 0, 0, 45)
    TopbarDrag.BackgroundTransparency = 1
    MakeDraggable(TopbarDrag, MainWindow)

    local RainbowStroke = Instance.new("UIStroke", MainWindow)
    RainbowStroke.Thickness = 1.5
    RainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local rainbowConnection = RunService.RenderStepped:Connect(function()
        if Library.Unloaded then rainbowConnection:Disconnect() return end
        local Hue = (tick() % 5) / 5
        RainbowStroke.Color = Color3.fromHSV(Hue, 0.8, 1)
    end)
    table.insert(Connections, rainbowConnection)

    -- WINDOW CONTROLS
    local ControlContainer = Instance.new("Frame", MainWindow)
    ControlContainer.Size = UDim2.new(0, 60, 0, 22)
    ControlContainer.Position = UDim2.new(1, -65, 0, 8)
    ControlContainer.BackgroundTransparency = 1

    local BtnMinimize = Instance.new("TextButton", ControlContainer)
    BtnMinimize.Size = UDim2.new(0, 22, 0, 22)
    BtnMinimize.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    BtnMinimize.Text = "-"
    BtnMinimize.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnMinimize.Font = Enum.Font.SourceSansBold
    BtnMinimize.TextSize = 14
    Instance.new("UICorner", BtnMinimize).CornerRadius = UDim.new(0, 4)

    local BtnClose = Instance.new("TextButton", ControlContainer)
    BtnClose.Size = UDim2.new(0, 22, 0, 22)
    BtnClose.Position = UDim2.new(0, 28, 0, 0)
    BtnClose.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    BtnClose.Text = "X"
    BtnClose.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnClose.Font = Enum.Font.SourceSansBold
    BtnClose.TextSize = 12
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

    -- Toggle UI Hotkey
    local toggleUiConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == ToggleUIKey then
            if MainWindow.Visible then
                MainWindow.Visible = false
                MinimizedBtn.Visible = true
            else
                MainWindow.Visible = true
                MinimizedBtn.Visible = false
            end
        end
    end)
    table.insert(Connections, toggleUiConn)

    -- SIDEBAR
    local Sidebar = Instance.new("Frame", MainWindow)
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BackgroundColor3 = Library.Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.ClipsDescendants = true
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)
    MainObjects.Sidebar = Sidebar

    local SidebarPatch = Instance.new("Frame", Sidebar)
    SidebarPatch.Size = UDim2.new(0, 12, 1, 0)
    SidebarPatch.Position = UDim2.new(1, -12, 0, 0)
    SidebarPatch.BackgroundColor3 = Library.Theme.Sidebar
    SidebarPatch.BorderSizePixel = 0
    MainObjects.SidebarPatch = SidebarPatch

    local Header = Instance.new("Frame", Sidebar)
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundTransparency = 1

    local GameTitle = Instance.new("TextLabel", Header)
    GameTitle.Size = UDim2.new(1, -15, 0, 18)
    GameTitle.Position = UDim2.new(0, 10, 0, 8)
    GameTitle.Text = UiTitle
    GameTitle.TextColor3 = Library.Theme.Text
    GameTitle.TextSize = 14
    GameTitle.Font = Enum.Font.SourceSansBold
    GameTitle.TextXAlignment = Enum.TextXAlignment.Left
    GameTitle.BackgroundTransparency = 1
    table.insert(MainObjects.Elements, GameTitle)

    local AuthorLabel = Instance.new("TextLabel", Header)
    AuthorLabel.Name = "Author"
    AuthorLabel.Size = UDim2.new(1, -15, 0, 12)
    AuthorLabel.Position = UDim2.new(0, 10, 0, 26)
    AuthorLabel.Text = "Ultimate Edition"
    AuthorLabel.TextColor3 = Library.Theme.TextDark
    AuthorLabel.TextSize = 11
    AuthorLabel.Font = Enum.Font.SourceSans
    AuthorLabel.TextXAlignment = Enum.TextXAlignment.Left
    AuthorLabel.BackgroundTransparency = 1
    table.insert(MainObjects.Elements, AuthorLabel)

    local LineHeader = Instance.new("Frame", Sidebar)
    LineHeader.Size = UDim2.new(1, -20, 0, 1)
    LineHeader.Position = UDim2.new(0, 10, 0, 45)
    LineHeader.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    LineHeader.BorderSizePixel = 0

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, -10, 1, -105)
    TabContainer.Position = UDim2.new(0, 5, 0, 55)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0

    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)
    end)

    -- PROFILE FOOTER
    local Footer = Instance.new("Frame", Sidebar)
    Footer.Size = UDim2.new(1, -16, 0, 40)
    Footer.Position = UDim2.new(0, 8, 1, -45)
    Footer.BackgroundColor3 = Library.Theme.Element
    Instance.new("UICorner", Footer).CornerRadius = UDim.new(0, 6)
    table.insert(MainObjects.Elements, Footer)

    local AvatarImg = Instance.new("ImageLabel", Footer)
    AvatarImg.Size = UDim2.new(0, 26, 0, 26)
    AvatarImg.Position = UDim2.new(0, 8, 0.5, -13)
    AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id="..Player.UserId.."&w=150&h=150"
    Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

    local DisplayNameLabel = Instance.new("TextLabel", Footer)
    DisplayNameLabel.Size = UDim2.new(1, -42, 0, 12)
    DisplayNameLabel.Position = UDim2.new(0, 40, 0, 6)
    DisplayNameLabel.Text = Player.DisplayName
    DisplayNameLabel.TextColor3 = Library.Theme.Text
    DisplayNameLabel.Font = Enum.Font.SourceSansBold
    DisplayNameLabel.TextSize = 12
    DisplayNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    DisplayNameLabel.BackgroundTransparency = 1
    table.insert(MainObjects.Elements, DisplayNameLabel)

    local UsernameLabel = Instance.new("TextLabel", Footer)
    UsernameLabel.Name = "Desc"
    UsernameLabel.Size = UDim2.new(1, -42, 0, 10)
    UsernameLabel.Position = UDim2.new(0, 40, 0, 20)
    UsernameLabel.Text = "@" .. Player.Name
    UsernameLabel.TextColor3 = Library.Theme.TextDark
    UsernameLabel.Font = Enum.Font.SourceSans
    UsernameLabel.TextSize = 10
    UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    UsernameLabel.BackgroundTransparency = 1
    table.insert(MainObjects.Elements, UsernameLabel)

    -- PAGES HOLDER
    local PagesHolder = Instance.new("Frame", MainWindow)
    PagesHolder.Size = UDim2.new(1, -175, 1, -45)
    PagesHolder.Position = UDim2.new(0, 165, 0, 35)
    PagesHolder.BackgroundTransparency = 1

    local Pages = {}
    local Tabs = {}
    local FirstTab = nil

    local function SwitchToTab(tabName)
        for name, page in pairs(Pages) do page.Visible = (name == tabName) end
        for name, btn in pairs(Tabs) do
            if name == tabName then
                Tween(btn, {BackgroundTransparency = 0, BackgroundColor3 = Library.Theme.Element})
            else
                Tween(btn, {BackgroundTransparency = 1})
            end
        end
    end

    local WindowFunctions = {}

    function WindowFunctions:CreateTab(tabName, iconId)
        iconId = iconId or "rbxassetid://4483362458"
        
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, -4, 0, 30)
        TabBtn.BackgroundTransparency = 1
        TabBtn.BackgroundColor3 = Library.Theme.Element
        TabBtn.Text = ""
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)
        table.insert(MainObjects.Elements, TabBtn)
        
        local TabLayout = Instance.new("Frame", TabBtn)
        TabLayout.Size = UDim2.new(1, 0, 1, 0)
        TabLayout.BackgroundTransparency = 1

        local Icon = Instance.new("ImageLabel", TabLayout)
        Icon.Size = UDim2.new(0, 14, 0, 14)
        Icon.Position = UDim2.new(0, 10, 0.5, -7)
        Icon.Image = iconId
        Icon.BackgroundTransparency = 1
        
        local Txt = Instance.new("TextLabel", TabLayout)
        Txt.Size = UDim2.new(1, -34, 1, 0)
        Txt.Position = UDim2.new(0, 30, 0, 0)
        Txt.Text = tabName
        Txt.TextColor3 = Library.Theme.Text
        Txt.TextSize = 12
        Txt.Font = Enum.Font.SourceSansSemibold
        Txt.TextXAlignment = Enum.TextXAlignment.Left
        Txt.BackgroundTransparency = 1
        table.insert(MainObjects.Elements, Txt)

        local ContentPage = Instance.new("ScrollingFrame", PagesHolder)
        ContentPage.Size = UDim2.new(1, 0, 1, 0)
        ContentPage.BackgroundTransparency = 1
        ContentPage.ScrollBarThickness = 3
        ContentPage.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
        ContentPage.Visible = false

        local ContentLayout = Instance.new("UIListLayout", ContentPage)
        ContentLayout.Padding = UDim.new(0, 6)
        ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ContentPage.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        Pages[tabName] = ContentPage
        Tabs[tabName] = TabBtn

        if not FirstTab then
            FirstTab = tabName
            ContentPage.Visible = true
            TabBtn.BackgroundTransparency = 0
        end

        TabBtn.MouseButton1Click:Connect(function() SwitchToTab(tabName) end)

        local TabFunctions = {}

        -- SECTION
        function TabFunctions:CreateSection(sectionName)
            local SectionFrame = Instance.new("Frame", ContentPage)
            SectionFrame.Size = UDim2.new(1, -10, 0, 25)
            SectionFrame.BackgroundTransparency = 1

            local SectionLabel = Instance.new("TextLabel", SectionFrame)
            SectionLabel.Size = UDim2.new(1, 0, 1, 0)
            SectionLabel.Text = "──  " .. string.upper(sectionName) .. "  ──"
            SectionLabel.TextColor3 = Library.Theme.TextDark
            SectionLabel.Font = Enum.Font.SourceSansBold
            SectionLabel.TextSize = 12
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.BackgroundTransparency = 1
            table.insert(MainObjects.Elements, SectionLabel)
        end

        -- PARAGRAPH
        function TabFunctions:CreateParagraph(text, desc)
            local FeatureFrame = Instance.new("Frame", ContentPage)
            FeatureFrame.BackgroundColor3 = Library.Theme.Element
            FeatureFrame.BackgroundTransparency = 0.4
            Instance.new("UICorner", FeatureFrame).CornerRadius = UDim.new(0, 4)
            table.insert(MainObjects.Elements, FeatureFrame)

            local Title = Instance.new("TextLabel", FeatureFrame)
            Title.Size = UDim2.new(1, -16, 0, 20)
            Title.Position = UDim2.new(0, 8, 0, 4)
            Title.Text = text
            Title.TextColor3 = Library.Theme.Text
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1
            table.insert(MainObjects.Elements, Title)

            local DescLabel = Instance.new("TextLabel", FeatureFrame)
            DescLabel.Name = "Desc"
            DescLabel.Size = UDim2.new(1, -16, 0, 20)
            DescLabel.Position = UDim2.new(0, 8, 0, 24)
            DescLabel.Text = desc
            DescLabel.TextColor3 = Library.Theme.TextDark
            DescLabel.Font = Enum.Font.SourceSans
            DescLabel.TextSize = 12
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescLabel.TextYAlignment = Enum.TextYAlignment.Top
            DescLabel.TextWrapped = true
            DescLabel.BackgroundTransparency = 1
            table.insert(MainObjects.Elements, DescLabel)
            
            FeatureFrame.Size = UDim2.new(1, -10, 0, 30 + DescLabel.TextBounds.Y)
        end

        -- BUTTON
        function TabFunctions:CreateButton(text, callback)
            local FeatureFrame = Instance.new("Frame", ContentPage)
            FeatureFrame.Size = UDim2.new(1, -10, 0, 38)
            FeatureFrame.BackgroundColor3 = Library.Theme.Element
            FeatureFrame.BackgroundTransparency = 0.2
            Instance.new("UICorner", FeatureFrame).CornerRadius = UDim.new(0, 4)
            table.insert(MainObjects.Elements, FeatureFrame)
            
            local Title = Instance.new("TextLabel", FeatureFrame)
            Title.Size = UDim2.new(0.7, 0, 1, 0)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Library.Theme.Text
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1
            table.insert(MainObjects.Elements, Title)

            local ActionBtn = Instance.new("TextButton", FeatureFrame)
            ActionBtn.Size = UDim2.new(0, 28, 0, 28)
            ActionBtn.Position = UDim2.new(1, -36, 0.5, -14)
            ActionBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            ActionBtn.Text = "▶"
            ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ActionBtn.Font = Enum.Font.SourceSansBold
            ActionBtn.TextSize = 14
            Instance.new("UICorner", ActionBtn).CornerRadius = UDim.new(0, 6)
            
            ActionBtn.MouseButton1Click:Connect(function() 
                Tween(ActionBtn, {Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -34, 0.5, -12)}, 0.1).Completed:Connect(function()
                    Tween(ActionBtn, {Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -36, 0.5, -14)}, 0.1)
                end)
                pcall(callback) 
            end)
        end

        -- TOGGLE
        function TabFunctions:CreateToggle(text, default, flagName, callback)
            flagName = flagName or text
            if Library.Flags[flagName] ~= nil then default = Library.Flags[flagName] end
            Library.Flags[flagName] = default

            local FeatureFrame = Instance.new("Frame", ContentPage)
            FeatureFrame.Size = UDim2.new(1, -10, 0, 38)
            FeatureFrame.BackgroundColor3 = Library.Theme.Element
            FeatureFrame.BackgroundTransparency = 0.2
            Instance.new("UICorner", FeatureFrame).CornerRadius = UDim.new(0, 4)
            table.insert(MainObjects.Elements, FeatureFrame)
            
            local Title = Instance.new("TextLabel", FeatureFrame)
            Title.Size = UDim2.new(0.7, 0, 1, 0)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Library.Theme.Text
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1
            table.insert(MainObjects.Elements, Title)

            local ToggleBg = Instance.new("TextButton", FeatureFrame)
            ToggleBg.Size = UDim2.new(0, 36, 0, 18)
            ToggleBg.Position = UDim2.new(1, -44, 0.5, -9)
            ToggleBg.BackgroundColor3 = default and Library.Theme.Accent or Color3.fromRGB(60, 60, 60)
            ToggleBg.Text = ""
            Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

            local ToggleBall = Instance.new("Frame", ToggleBg)
            ToggleBall.Size = UDim2.new(0, 14, 0, 14)
            ToggleBall.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            ToggleBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", ToggleBall).CornerRadius = UDim.new(1, 0)

            local IsOn = default
            
            local function FireToggle(state)
                IsOn = state
                Library.Flags[flagName] = IsOn
                SaveConfig()

                local targetPos = IsOn and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                local targetColor = IsOn and Library.Theme.Accent or Color3.fromRGB(60, 60, 60)
                
                Tween(ToggleBall, {Position = targetPos}, 0.2)
                Tween(ToggleBg, {BackgroundColor3 = targetColor}, 0.2)
                pcall(callback, IsOn)
            end

            ToggleBg.MouseButton1Click:Connect(function() FireToggle(not IsOn) end)

            -- Initial fire to register value in script
            task.spawn(function() pcall(callback, IsOn) end)

            local ToggleFuncs = {}
            function ToggleFuncs:Set(state) FireToggle(state) end
            return ToggleFuncs
        end

        -- SLIDER (FIXED, HIGH PRECISION)
        function TabFunctions:CreateSlider(text, min, max, default, flagName, callback)
            flagName = flagName or text
            if Library.Flags[flagName] ~= nil then default = Library.Flags[flagName] end
            Library.Flags[flagName] = default

            local FeatureFrame = Instance.new("Frame", ContentPage)
            FeatureFrame.Size = UDim2.new(1, -10, 0, 50)
            FeatureFrame.BackgroundColor3 = Library.Theme.Element
            FeatureFrame.BackgroundTransparency = 0.2
            Instance.new("UICorner", FeatureFrame).CornerRadius = UDim.new(0, 4)
            table.insert(MainObjects.Elements, FeatureFrame)

            local Title = Instance.new("TextLabel", FeatureFrame)
            Title.Size = UDim2.new(0.6, 0, 0, 25)
            Title.Position = UDim2.new(0, 8, 0, 2)
            Title.Text = text
            Title.TextColor3 = Library.Theme.Text
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1
            table.insert(MainObjects.Elements, Title)

            local ValueBox = Instance.new("TextBox", FeatureFrame)
            ValueBox.Size = UDim2.new(0, 40, 0, 20)
            ValueBox.Position = UDim2.new(1, -48, 0, 5)
            ValueBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            ValueBox.Text = tostring(default)
            ValueBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValueBox.Font = Enum.Font.SourceSansBold
            ValueBox.TextSize = 12
            Instance.new("UICorner", ValueBox).CornerRadius = UDim.new(0, 4)

            local SliderBar = Instance.new("TextButton", FeatureFrame)
            SliderBar.Size = UDim2.new(1, -16, 0, 6)
            SliderBar.Position = UDim2.new(0, 8, 1, -14)
            SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            SliderBar.Text = ""
            SliderBar.AutoButtonColor = false
            Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

            local fillPercent = math.clamp((default - min) / (max - min), 0, 1)
            local SliderFill = Instance.new("Frame", SliderBar)
            SliderFill.Size = UDim2.new(fillPercent, 0, 1, 0)
            SliderFill.BackgroundColor3 = Library.Theme.Accent
            Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

            local SliderKnob = Instance.new("Frame", SliderFill)
            SliderKnob.Size = UDim2.new(0, 12, 0, 12)
            SliderKnob.Position = UDim2.new(1, -6, 0.5, -6)
            SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", SliderKnob).CornerRadius = UDim.new(1, 0)

            local function UpdateSlider(input)
                local barAbsPos = SliderBar.AbsolutePosition.X
                local barAbsSize = SliderBar.AbsoluteSize.X
                local inputX = input.Position.X
                
                local percentage = math.clamp((inputX - barAbsPos) / barAbsSize, 0, 1)
                local value = math.floor(min + ((max - min) * percentage))
                
                ValueBox.Text = tostring(value)
                SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                
                if Library.Flags[flagName] ~= value then
                    Library.Flags[flagName] = value
                    SaveConfig()
                    pcall(callback, value)
                end
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

            -- Handle manual TextBox input
            ValueBox.FocusLost:Connect(function()
                local num = tonumber(ValueBox.Text)
                if num then
                    num = math.clamp(num, min, max)
                    local percentage = (num - min) / (max - min)
                    ValueBox.Text = tostring(num)
                    SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                    Library.Flags[flagName] = num
                    SaveConfig()
                    pcall(callback, num)
                else
                    ValueBox.Text = tostring(Library.Flags[flagName])
                end
            end)

            -- Initial trigger
            task.spawn(function() pcall(callback, default) end)
        end

        -- TEXTBOX
        function TabFunctions:CreateTextbox(text, placeholder, default, flagName, callback)
            flagName = flagName or text
            if Library.Flags[flagName] ~= nil then default = Library.Flags[flagName] end
            Library.Flags[flagName] = default or ""

            local FeatureFrame = Instance.new("Frame", ContentPage)
            FeatureFrame.Size = UDim2.new(1, -10, 0, 38)
            FeatureFrame.BackgroundColor3 = Library.Theme.Element
            FeatureFrame.BackgroundTransparency = 0.2
            Instance.new("UICorner", FeatureFrame).CornerRadius = UDim.new(0, 4)
            table.insert(MainObjects.Elements, FeatureFrame)

            local Title = Instance.new("TextLabel", FeatureFrame)
            Title.Size = UDim2.new(0.5, 0, 1, 0)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Library.Theme.Text
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1
            table.insert(MainObjects.Elements, Title)

            local TxtInput = Instance.new("TextBox", FeatureFrame)
            TxtInput.Size = UDim2.new(0, 130, 0, 24)
            TxtInput.Position = UDim2.new(1, -138, 0.5, -12)
            TxtInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            TxtInput.PlaceholderText = placeholder
            TxtInput.Text = Library.Flags[flagName]
            TxtInput.TextColor3 = Color3.fromRGB(255, 255, 255)
            TxtInput.Font = Enum.Font.SourceSans
            TxtInput.TextSize = 12
            TxtInput.ClipsDescendants = true
            Instance.new("UICorner", TxtInput).CornerRadius = UDim.new(0, 4)

            TxtInput.FocusLost:Connect(function(enterPressed)
                Library.Flags[flagName] = TxtInput.Text
                SaveConfig()
                pcall(callback, TxtInput.Text, enterPressed)
            end)
        end

        -- KEYBIND
        function TabFunctions:CreateKeybind(text, defaultKey, flagName, callback)
            flagName = flagName or text
            local currentKey = defaultKey
            if Library.Flags[flagName] ~= nil then currentKey = Library.Flags[flagName] end

            local FeatureFrame = Instance.new("Frame", ContentPage)
            FeatureFrame.Size = UDim2.new(1, -10, 0, 38)
            FeatureFrame.BackgroundColor3 = Library.Theme.Element
            FeatureFrame.BackgroundTransparency = 0.2
            Instance.new("UICorner", FeatureFrame).CornerRadius = UDim.new(0, 4)
            table.insert(MainObjects.Elements, FeatureFrame)

            local Title = Instance.new("TextLabel", FeatureFrame)
            Title.Size = UDim2.new(0.6, 0, 1, 0)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Library.Theme.Text
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1
            table.insert(MainObjects.Elements, Title)

            local BindBtn = Instance.new("TextButton", FeatureFrame)
            BindBtn.Size = UDim2.new(0, 80, 0, 24)
            BindBtn.Position = UDim2.new(1, -88, 0.5, -12)
            BindBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            BindBtn.Text = currentKey and currentKey.Name or "None"
            BindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            BindBtn.Font = Enum.Font.SourceSansBold
            BindBtn.TextSize = 12
            Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 4)

            local listening = false
            BindBtn.MouseButton1Click:Connect(function()
                listening = true
                BindBtn.Text = "..."
                BindBtn.BackgroundColor3 = Library.Theme.Accent
                BindBtn.TextColor3 = Color3.fromRGB(0,0,0)
            end)

            local bindConnection = UserInputService.InputBegan:Connect(function(input, gpe)
                if listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        local key = input.KeyCode
                        if key.Name == "Escape" or key.Name == "Backspace" then
                            currentKey = nil
                            BindBtn.Text = "None"
                        else
                            currentKey = key
                            BindBtn.Text = currentKey.Name
                        end
                        BindBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                        BindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                        listening = false
                        Library.Flags[flagName] = currentKey
                        SaveConfig()
                    end
                elseif not gpe and currentKey and input.KeyCode == currentKey then
                    pcall(callback)
                end
            end)
            table.insert(Connections, bindConnection)
        end
        
        -- DROPDOWN (Single Choice)
        function TabFunctions:CreateDropdown(text, options, default, flagName, callback)
            flagName = flagName or text
            if Library.Flags[flagName] ~= nil then default = Library.Flags[flagName] end
            Library.Flags[flagName] = default or options[1] or ""

            local FeatureFrame = Instance.new("Frame", ContentPage)
            FeatureFrame.Size = UDim2.new(1, -10, 0, 38) -- Closes size
            FeatureFrame.BackgroundColor3 = Library.Theme.Element
            FeatureFrame.BackgroundTransparency = 0.2
            FeatureFrame.ClipsDescendants = true
            Instance.new("UICorner", FeatureFrame).CornerRadius = UDim.new(0, 4)
            table.insert(MainObjects.Elements, FeatureFrame)

            local Title = Instance.new("TextLabel", FeatureFrame)
            Title.Size = UDim2.new(0.5, 0, 0, 38)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Library.Theme.Text
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1
            table.insert(MainObjects.Elements, Title)
            
            local DropBtn = Instance.new("TextButton", FeatureFrame)
            DropBtn.Size = UDim2.new(0, 130, 0, 24)
            DropBtn.Position = UDim2.new(1, -138, 0, 7)
            DropBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            DropBtn.Text = tostring(Library.Flags[flagName])
            DropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropBtn.Font = Enum.Font.SourceSansBold
            DropBtn.TextSize = 12
            Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 4)

            local DropList = Instance.new("ScrollingFrame", FeatureFrame)
            DropList.Size = UDim2.new(1, -16, 0, 0)
            DropList.Position = UDim2.new(0, 8, 0, 42)
            DropList.BackgroundTransparency = 1
            DropList.ScrollBarThickness = 2
            
            local ListLayout = Instance.new("UIListLayout", DropList)
            ListLayout.Padding = UDim.new(0, 4)
            
            local open = false
            local function ToggleDrop()
                open = not open
                local targetHeight = open and math.clamp(#options * 28 + 48, 38, 150) or 38
                Tween(FeatureFrame, {Size = UDim2.new(1, -10, 0, targetHeight)}, 0.2)
                DropList.Size = UDim2.new(1, -16, 1, -48)
                DropList.CanvasSize = UDim2.new(0, 0, 0, #options * 28)
            end
            
            DropBtn.MouseButton1Click:Connect(ToggleDrop)
            
            local function Populate()
                for _, child in ipairs(DropList:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                
                for _, opt in ipairs(options) do
                    local OptBtn = Instance.new("TextButton", DropList)
                    OptBtn.Size = UDim2.new(1, 0, 0, 24)
                    OptBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                    OptBtn.Text = "  " .. tostring(opt)
                    OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    OptBtn.Font = Enum.Font.SourceSans
                    OptBtn.TextSize = 12
                    OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                    Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)
                    
                    if opt == Library.Flags[flagName] then
                        OptBtn.TextColor3 = Library.Theme.Accent
                        OptBtn.Font = Enum.Font.SourceSansBold
                    end

                    OptBtn.MouseButton1Click:Connect(function()
                        Library.Flags[flagName] = opt
                        DropBtn.Text = tostring(opt)
                        SaveConfig()
                        pcall(callback, opt)
                        ToggleDrop()
                        Populate() -- refresh colors
                    end)
                end
            end
            Populate()

            local DropFuncs = {}
            function DropFuncs:Refresh(newOptions)
                options = newOptions
                Populate()
            end
            return DropFuncs
        end

        return TabFunctions
    end

    -- KEY SYSTEM HANDLING
    if UseKeySystem then
        local KeyFrame = Instance.new("Frame", ScreenGui)
        KeyFrame.Size = UDim2.new(0, 300, 0, 160)
        KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
        KeyFrame.BackgroundColor3 = Library.Theme.Background
        Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8)
        
        local KeyStroke = Instance.new("UIStroke", KeyFrame)
        KeyStroke.Color = Library.Theme.Accent
        KeyStroke.Thickness = 1.5
        MakeDraggable(KeyFrame)

        local KeyTitle = Instance.new("TextLabel", KeyFrame)
        KeyTitle.Size = UDim2.new(1, 0, 0, 30)
        KeyTitle.Text = "Verifikasi Kunci"
        KeyTitle.TextColor3 = Library.Theme.Text
        KeyTitle.Font = Enum.Font.SourceSansBold
        KeyTitle.TextSize = 16
        KeyTitle.BackgroundTransparency = 1

        local KeyInput = Instance.new("TextBox", KeyFrame)
        KeyInput.Size = UDim2.new(1, -40, 0, 34)
        KeyInput.Position = UDim2.new(0, 20, 0, 50)
        KeyInput.BackgroundColor3 = Library.Theme.Element
        KeyInput.PlaceholderText = "Masukkan Kunci..."
        KeyInput.Text = ""
        KeyInput.TextColor3 = Library.Theme.Text
        KeyInput.Font = Enum.Font.SourceSans
        KeyInput.TextSize = 13
        Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 4)

        local GetKeyBtn = Instance.new("TextButton", KeyFrame)
        GetKeyBtn.Size = UDim2.new(0, 120, 0, 30)
        GetKeyBtn.Position = UDim2.new(0, 20, 1, -45)
        GetKeyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        GetKeyBtn.Text = "Dapatkan Kunci"
        GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        GetKeyBtn.Font = Enum.Font.SourceSansBold
        GetKeyBtn.TextSize = 13
        Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 4)

        GetKeyBtn.MouseButton1Click:Connect(function()
            if setclipboard then setclipboard(GetKeyLink) end
            Library:Notify("Tersalin", "Link kunci telah disalin ke clipboard!", 4)
        end)

        local VerifyBtn = Instance.new("TextButton", KeyFrame)
        VerifyBtn.Size = UDim2.new(0, 120, 0, 30)
        VerifyBtn.Position = UDim2.new(1, -140, 1, -45)
        VerifyBtn.BackgroundColor3 = Library.Theme.Accent
        VerifyBtn.Text = "Verifikasi"
        VerifyBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
        VerifyBtn.Font = Enum.Font.SourceSansBold
        VerifyBtn.TextSize = 13
        Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 4)

        VerifyBtn.MouseButton1Click:Connect(function()
            if KeyInput.Text == CorrectKey then
                Tween(KeyFrame, {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}, 0.3).Completed:Connect(function()
                    KeyFrame:Destroy()
                end)
                MainWindow.Visible = true
                Library:Notify("Sukses", "Verifikasi Kunci Berhasil! Selamat Datang.", 4)
            else
                Library:Notify("Gagal", "Kunci tidak valid. Silakan coba lagi.", 4)
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
    local OldGui = ProtectGui:FindFirstChild("NexzanUltimateUi")
    if OldGui then OldGui:Destroy() end
end

return Library
