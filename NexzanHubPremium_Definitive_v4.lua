--[[
================================================================================
                    NEXZAN HUB PREMIUM (v4.0 - ULTRAPACK DEFINITIVE)
================================================================================
    * Premium Glassmorphic Layout - Customizable Themes & Accents
    * Windows Compatibility: Mobile / HP & PC Support
    * Key System, Configuration Manager, Theme Manager, UI Scaler, Search Bar,
      Keybind Manager, Notification History, FPS & Ping Widget, Loading Screen,
      Blur Effects, Favorite System & Script Hub.
================================================================================
]]

local Library = {
    Unloaded = false,
    Flags = {},
    Favorites = {Buttons = {}, Toggles = {}, Scripts = {}},
    NotifHistory = {},
    CurrentTheme = "Custom RGB",
    Theme = {
        Accent = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(25, 25, 25),
        Sidebar = Color3.fromRGB(15, 15, 15),
        TopBorder = Color3.fromRGB(255, 255, 255)
    },
    ElementsRegistry = {}, -- For real-time search engine
    Settings = {
        AutoSave = true,
        AutoLoad = true,
        ShowWidget = true
    }
}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local ToggleKey = Enum.KeyCode.RightShift

-- Folders Setup
local ConfigFolder = "NexzanConfigs"
local CurrentConfigName = "Default"

local function EnsureFolders()
    if makefolder then
        if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
        if not isfolder(ConfigFolder.."/Themes") then makefolder(ConfigFolder.."/Themes") end
        if not isfolder(ConfigFolder.."/Scripts") then makefolder(ConfigFolder.."/Scripts") end
    end
end
EnsureFolders()

local function SaveConfig(name)
    name = name or CurrentConfigName
    if not writefile then return end
    
    local data = {
        Flags = {},
        Favorites = Library.Favorites,
        Settings = Library.Settings,
        ThemeName = Library.CurrentTheme,
        CustomThemeColor = {r = Library.Theme.Accent.R, g = Library.Theme.Accent.G, b = Library.Theme.Accent.B},
        ToggleKey = ToggleKey.Name
    }
    
    for k, v in pairs(Library.Flags) do
        if typeof(v) == "Color3" then
            data.Flags[k] = {r = v.R, g = v.G, b = v.B, isColor = true}
        else
            data.Flags[k] = v
        end
    end
    
    pcall(function()
        writefile(ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
    end)
end

local function LoadConfig(name)
    name = name or CurrentConfigName
    if not readfile or not isfile(ConfigFolder .. "/" .. name .. ".json") then return end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(ConfigFolder .. "/" .. name .. ".json"))
    end)
    
    if success and type(data) == "table" then
        if data.Flags then
            for k, v in pairs(data.Flags) do
                if type(v) == "table" and v.isColor then
                    Library.Flags[k] = Color3.new(v.r, v.g, v.b)
                else
                    Library.Flags[k] = v
                end
            end
        end
        if data.Favorites then Library.Favorites = data.Favorites end
        if data.Settings then Library.Settings = data.Settings end
        if data.ThemeName then Library.CurrentTheme = data.ThemeName end
        if data.ToggleKey then pcall(function() ToggleKey = Enum.KeyCode[data.ToggleKey] end) end
    end
end

-- Smooth Dragging Helper
local function MakeDraggable(guiObject)
    local dragging, dragInput, dragStart, startPos
    
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            
            input.Changed:Connect(function(state)
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
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(guiObject, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        end
    end)
end

-- Ripple Effect
local function CreateRipple(button)
    button.ClipsDescendants = true
    button.MouseButton1Click:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        local relativePos = mousePos - button.AbsolutePosition - Vector2.new(0, 36)
        
        local ripple = Instance.new("Frame")
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.BackgroundTransparency = 0.6
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(0, relativePos.X, 0, relativePos.Y)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.Parent = button
        
        Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
        
        local targetSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
        local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        TweenService:Create(ripple, tweenInfo, {
            Size = UDim2.new(0, targetSize, 0, targetSize),
            BackgroundTransparency = 1
        }):Play()
        
        task.delay(0.4, function() ripple:Destroy() end)
    end)
end

local Connections = {}

function Library:CreateWindow(Config)
    if Library.Settings.AutoLoad then LoadConfig() end

    local UiTitle = "Nexzan Hub Premium"
    local UseKeySystem = false
    local CorrectKey = "NexzanPremium2026"
    local GetKeyLink = "https://link-get-key-kamu.com"
    
    if type(Config) == "table" then
        UiTitle = Config.Name or UiTitle
        UseKeySystem = Config.KeySystem or false
        CorrectKey = Config.Key or CorrectKey
        GetKeyLink = Config.Link or GetKeyLink
    end

    -- Clear Old GUI
    local TargetParent = (RunService:IsStudio() and Player:WaitForChild("PlayerGui")) or CoreGui
    local OldGui = TargetParent:FindFirstChild("NexzanHubPremiumUi")
    if OldGui then OldGui:Destroy() end

    -- Custom Premium Loading Screen
    local LoadGui = Instance.new("ScreenGui", TargetParent)
    LoadGui.Name = "NexzanLoadingScreen"
    
    local LoadFrame = Instance.new("Frame", LoadGui)
    LoadFrame.Size = UDim2.new(1, 0, 1, 0)
    LoadFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    
    local LoadTitle = Instance.new("TextLabel", LoadFrame)
    LoadTitle.Size = UDim2.new(1, 0, 0, 50)
    LoadTitle.Position = UDim2.new(0, 0, 0.4, -25)
    LoadTitle.Text = UiTitle
    LoadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadTitle.Font = Enum.Font.SourceSansBold
    LoadTitle.TextSize = 32
    LoadTitle.BackgroundTransparency = 1
    LoadTitle.TextTransparency = 1
    
    local ProgressBarBg = Instance.new("Frame", LoadFrame)
    ProgressBarBg.Size = UDim2.new(0, 300, 0, 6)
    ProgressBarBg.Position = UDim2.new(0.5, -150, 0.5, 20)
    ProgressBarBg.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Instance.new("UICorner", ProgressBarBg).CornerRadius = UDim.new(1, 0)
    
    local ProgressBar = Instance.new("Frame", ProgressBarBg)
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    ProgressBar.BackgroundColor3 = Library.Theme.Accent
    Instance.new("UICorner", ProgressBar).CornerRadius = UDim.new(1, 0)
    
    local PercentLabel = Instance.new("TextLabel", LoadFrame)
    PercentLabel.Size = UDim2.new(0, 100, 0, 20)
    PercentLabel.Position = UDim2.new(0.5, -50, 0.5, 35)
    PercentLabel.Text = "0%"
    PercentLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    PercentLabel.Font = Enum.Font.SourceSans
    PercentLabel.TextSize = 14
    PercentLabel.BackgroundTransparency = 1
    
    TweenService:Create(LoadTitle, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    
    for i = 1, 100 do
        ProgressBar.Size = UDim2.new(i/100, 0, 1, 0)
        PercentLabel.Text = tostring(i).."%"
        task.wait(0.015)
    end
    
    TweenService:Create(LoadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoadTitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    PercentLabel:Destroy()
    ProgressBarBg:Destroy()
    task.wait(0.5)
    LoadGui:Destroy()

    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NexzanHubPremiumUi"
    ScreenGui.Parent = TargetParent
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    -- Blur Background Effect
    local Blur = Instance.new("BlurEffect", game.Lighting)
    Blur.Size = 12
    Blur.Enabled = true

    -- Notification Area System
    local NotificationArea = Instance.new("Frame", ScreenGui)
    NotificationArea.Name = "NotificationArea"
    NotificationArea.Size = UDim2.new(0, 260, 1, -20)
    NotificationArea.Position = UDim2.new(1, -270, 0, 10)
    NotificationArea.BackgroundTransparency = 1

    local NotifLayout = Instance.new("UIListLayout", NotificationArea)
    NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifLayout.Padding = UDim.new(0, 6)

    function Library:Notify(title, desc, duration)
        title = title or "Notification"
        desc = desc or "Information message."
        duration = duration or 4

        table.insert(Library.NotifHistory, {Title = title, Desc = desc, Time = os.date("%X")})

        local NotifFrame = Instance.new("Frame", NotificationArea)
        NotifFrame.Size = UDim2.new(1, 0, 0, 0)
        NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        NotifFrame.BackgroundTransparency = 0.15
        NotifFrame.ClipsDescendants = true
        Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 6)
        
        local Stroke = Instance.new("UIStroke", NotifFrame)
        Stroke.Color = Library.Theme.Accent

        local TitleLabel = Instance.new("TextLabel", NotifFrame)
        TitleLabel.Size = UDim2.new(1, -20, 0, 18)
        TitleLabel.Position = UDim2.new(0, 10, 0, 6)
        TitleLabel.Text = title
        TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleLabel.Font = Enum.Font.SourceSansBold
        TitleLabel.TextSize = 12
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.BackgroundTransparency = 1

        local DescLabel = Instance.new("TextLabel", NotifFrame)
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

        TweenService:Create(NotifFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 55)}):Play()

        task.spawn(function()
            task.wait(duration)
            local shrink = TweenService:Create(NotifFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
            shrink:Play()
            shrink.Completed:Connect(function() NotifFrame:Destroy() end)
        end)
    end

    -- Floating Widget (FPS, PING, TIME, EXECUTOR)
    local WidgetFrame = Instance.new("Frame", ScreenGui)
    WidgetFrame.Size = UDim2.new(0, 140, 0, 90)
    WidgetFrame.Position = UDim2.new(0, 20, 0, 20)
    WidgetFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    WidgetFrame.BackgroundTransparency = 0.2
    Instance.new("UICorner", WidgetFrame).CornerRadius = UDim.new(0, 6)
    local WidgetStroke = Instance.new("UIStroke", WidgetFrame)
    WidgetStroke.Color = Library.Theme.Accent
    MakeDraggable(WidgetFrame)

    local WidgetList = Instance.new("UIListLayout", WidgetFrame)
    WidgetList.Padding = UDim.new(0, 2)
    WidgetList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    WidgetList.VerticalAlignment = Enum.VerticalAlignment.Center

    local function CreateWidgetLabel(text)
        local lbl = Instance.new("TextLabel", WidgetFrame)
        lbl.Size = UDim2.new(1, -10, 0, 14)
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
        lbl.Font = Enum.Font.SourceSans
        lbl.TextSize = 11
        lbl.BackgroundTransparency = 1
        return lbl
    end

    local FpsLbl = CreateWidgetLabel("FPS: --")
    local PingLbl = CreateWidgetLabel("Ping: --")
    local TimeLbl = CreateWidgetLabel("Jam: --")
    local ExecLbl = CreateWidgetLabel("Exec: "..(identifyexecutor and identifyexecutor() or "Unknown"))
    local VerLbl = CreateWidgetLabel("Roblox: "..version())

    local lastTick = tick()
    local frameCount = 0
    local widgetConnection = RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        if tick() - lastTick >= 1 then
            FpsLbl.Text = "FPS: "..tostring(frameCount)
            frameCount = 0
            lastTick = tick()
        end
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        PingLbl.Text = "Ping: "..string.split(ping, " ")[1].." ms"
        TimeLbl.Text = "Jam: "..os.date("%X")
    end)
    table.insert(Connections, widgetConnection)

    -- Key System Frame
    local KeyFrame = Instance.new("Frame", ScreenGui)
    KeyFrame.Size = UDim2.new(0, 320, 0, 180)
    KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8)
    local KeyStroke = Instance.new("UIStroke", KeyFrame)
    KeyStroke.Color = Library.Theme.Accent
    KeyFrame.Visible = UseKeySystem
    MakeDraggable(KeyFrame)

    local KeyTitle = Instance.new("TextLabel", KeyFrame)
    KeyTitle.Size = UDim2.new(1, 0, 0, 30)
    KeyTitle.Text = "Enter Activation Key"
    KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyTitle.Font = Enum.Font.SourceSansBold
    KeyTitle.TextSize = 14
    KeyTitle.BackgroundTransparency = 1

    local KeyInput = Instance.new("TextBox", KeyFrame)
    KeyInput.Size = UDim2.new(1, -40, 0, 32)
    KeyInput.Position = UDim2.new(0, 20, 0, 50)
    KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.Font = Enum.Font.SourceSans
    KeyInput.TextSize = 12
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 4)

    local GetKeyBtn = Instance.new("TextButton", KeyFrame)
    GetKeyBtn.Size = UDim2.new(0, 130, 0, 30)
    GetKeyBtn.Position = UDim2.new(0, 20, 1, -50)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    GetKeyBtn.Text = "Get Key Link"
    GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyBtn.Font = Enum.Font.SourceSansBold
    GetKeyBtn.TextSize = 12
    Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 4)
    GetKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(GetKeyLink) Library:Notify("Link Copied", "Key link copied to clipboard!", 3) end
    end)

    local VerifyBtn = Instance.new("TextButton", KeyFrame)
    VerifyBtn.Size = UDim2.new(0, 130, 0, 30)
    VerifyBtn.Position = UDim2.new(1, -150, 1, -50)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(35, 120, 35)
    VerifyBtn.Text = "Verify Key"
    VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyBtn.Font = Enum.Font.SourceSansBold
    VerifyBtn.TextSize = 12
    Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 4)

    -- Main Frame Window
    local MainWindow = Instance.new("Frame", ScreenGui)
    MainWindow.Size = UDim2.new(0, 480, 0, 280)
    MainWindow.Position = UDim2.new(0.5, -240, 0.5, -140)
    MainWindow.BackgroundColor3 = Library.Theme.Background
    MainWindow.BackgroundTransparency = 0.15
    MainWindow.Active = true
    MainWindow.ClipsDescendants = false
    MainWindow.Visible = not UseKeySystem
    Instance.new("UICorner", MainWindow).CornerRadius = UDim.new(0, 8)
    MakeDraggable(MainWindow)

    local MainStroke = Instance.new("UIStroke", MainWindow)
    MainStroke.Thickness = 1.2
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Theme Loop Connection
    local themeConnection = RunService.RenderStepped:Connect(function()
        if Library.Unloaded then return end
        if Library.CurrentTheme == "Rainbow Animation" then
            local Hue = (tick() % 5) / 5
            Library.Theme.Accent = Color3.fromHSV(Hue, 0.8, 1)
        end
        MainStroke.Color = Library.Theme.Accent
        WidgetStroke.Color = Library.Theme.Accent
    end)
    table.insert(Connections, themeConnection)

    VerifyBtn.MouseButton1Click:Connect(function()
        if KeyInput.Text == CorrectKey then
            KeyFrame.Visible = false
            MainWindow.Visible = true
            Library:Notify("Success", "Key authorized successfully!", 4)
        else
            Library:Notify("Error", "Invalid key entered. Please try again.", 4)
        end
    end)

    -- Minimize Button
    local MinimizedBtn = Instance.new("TextButton", ScreenGui)
    MinimizedBtn.Size = UDim2.new(0, 130, 0, 28)
    MinimizedBtn.Position = UDim2.new(0.5, -65, 0, 15)
    MinimizedBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MinimizedBtn.Text = "🚀 Open Nexzan UI"
    MinimizedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizedBtn.Font = Enum.Font.SourceSansBold
    MinimizedBtn.TextSize = 12
    MinimizedBtn.Visible = false
    Instance.new("UICorner", MinimizedBtn).CornerRadius = UDim.new(0, 6)
    MakeDraggable(MinimizedBtn)

    local function ToggleUI()
        local state = not MainWindow.Visible
        MainWindow.Visible = state
        Blur.Enabled = state
    end

    MinimizedBtn.MouseButton1Click:Connect(function()
        ToggleUI()
        MinimizedBtn.Visible = false
    end)

    -- Resize Handle for PC users (Right bottom corner drag)
    local ResizeHandle = Instance.new("Frame", MainWindow)
    ResizeHandle.Size = UDim2.new(0, 16, 0, 16)
    ResizeHandle.Position = UDim2.new(1, -16, 1, -16)
    ResizeHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ResizeHandle.BackgroundTransparency = 0.8
    Instance.new("UICorner", ResizeHandle).CornerRadius = UDim.new(1, 0)

    local resizing = false
    local resizeStartSize, resizeStartPos
    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStartSize = MainWindow.Size
            resizeStartPos = input.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then resizing = false end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStartPos
            local newX = math.clamp(resizeStartSize.X.Offset + delta.X, 400, 800)
            local newY = math.clamp(resizeStartSize.Y.Offset + delta.Y, 250, 600)
            MainWindow.Size = UDim2.new(0, newX, 0, newY)
        end
    end)

    -- Window Controls
    local ControlContainer = Instance.new("Frame", MainWindow)
    ControlContainer.Size = UDim2.new(0, 55, 0, 22)
    ControlContainer.Position = UDim2.new(1, -60, 0, 6)
    ControlContainer.BackgroundTransparency = 1

    local BtnMinimize = Instance.new("TextButton", ControlContainer)
    BtnMinimize.Size = UDim2.new(0, 18, 0, 18)
    BtnMinimize.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    BtnMinimize.Text = "-"
    BtnMinimize.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnMinimize.Font = Enum.Font.SourceSansBold
    BtnMinimize.TextSize = 12
    Instance.new("UICorner", BtnMinimize).CornerRadius = UDim.new(0, 4)
    BtnMinimize.MouseButton1Click:Connect(function()
        MainWindow.Visible = false
        MinimizedBtn.Visible = true
    end)

    local BtnClose = Instance.new("TextButton", ControlContainer)
    BtnClose.Size = UDim2.new(0, 18, 0, 18)
    BtnClose.Position = UDim2.new(0, 22, 0, 0)
    BtnClose.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
    BtnClose.Text = "X"
    BtnClose.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnClose.Font = Enum.Font.SourceSansBold
    BtnClose.TextSize = 10
    Instance.new("UICorner", BtnClose).CornerRadius = UDim.new(0, 4)
    BtnClose.MouseButton1Click:Connect(function()
        Library:Unload()
    end)

    -- Sidebar Layout
    local Sidebar = Instance.new("Frame", MainWindow)
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Library.Theme.Sidebar
    Sidebar.BackgroundTransparency = 0.1
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -140)
    TabContainer.Position = UDim2.new(0, 0, 0, 90)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0

    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y)
    end)

    -- Real-time Search Engine Bar inside Sidebar Top
    local SearchBoxBar = Instance.new("TextBox", Sidebar)
    SearchBoxBar.Size = UDim2.new(1, -16, 0, 24)
    SearchBoxBar.Position = UDim2.new(0, 8, 0, 55)
    SearchBoxBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SearchBoxBar.PlaceholderText = "Search Elements..."
    SearchBoxBar.Text = ""
    SearchBoxBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBoxBar.TextSize = 11
    SearchBoxBar.Font = Enum.Font.SourceSans
    Instance.new("UICorner", SearchBoxBar).CornerRadius = UDim.new(0, 4)

    SearchBoxBar:GetPropertyChangedSignal("Text"):Connect(function()
        local filter = string.lower(SearchBoxBar.Text)
        for _, item in ipairs(Library.ElementsRegistry) do
            if filter == "" then
                item.Frame.Visible = true
            else
                if string.find(string.lower(item.Text), filter) then
                    item.Frame.Visible = true
                else
                    item.Frame.Visible = false
                end
            end
        end
    end)

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
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.85}):Play()
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
        TabBtn.Text = "  " .. tabName
        TabBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
        TabBtn.Font = Enum.Font.SourceSansSemibold
        TabBtn.TextSize = 12
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)
        CreateRipple(TabBtn)

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

        function TabFunctions:CreateSection(name)
            local Frame = Instance.new("Frame", ContentPage)
            Frame.Size = UDim2.new(1, -10, 0, 20)
            Frame.BackgroundTransparency = 1
            
            local lbl = Instance.new("TextLabel", Frame)
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.Text = "── " .. string.upper(name) .. " ──"
            lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
            lbl.Font = Enum.Font.SourceSansBold
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.BackgroundTransparency = 1
            
            table.insert(Library.ElementsRegistry, {Text = name, Frame = Frame, Type = "Label"})
        end

        function TabFunctions:CreateButton(text, desc, callback)
            local Frame = Instance.new("Frame", ContentPage)
            Frame.Size = UDim2.new(1, -10, 0, 38)
            Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Frame.BackgroundTransparency = 0.4
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
            
            local Title = Instance.new("TextLabel", Frame)
            Title.Size = UDim2.new(0.6, 0, 1, 0)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1

            local ActionBtn = Instance.new("TextButton", Frame)
            ActionBtn.Size = UDim2.new(0, 65, 0, 22)
            ActionBtn.Position = UDim2.new(1, -105, 0.5, -11)
            ActionBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ActionBtn.Text = "Execute"
            ActionBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
            ActionBtn.Font = Enum.Font.SourceSansBold
            ActionBtn.TextSize = 10
            Instance.new("UICorner", ActionBtn).CornerRadius = UDim.new(0, 4)
            CreateRipple(ActionBtn)
            ActionBtn.MouseButton1Click:Connect(function() pcall(callback) end)

            local FavBtn = Instance.new("TextButton", Frame)
            FavBtn.Size = UDim2.new(0, 22, 0, 22)
            FavBtn.Position = UDim2.new(1, -32, 0.5, -11)
            FavBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            FavBtn.Text = "★"
            FavBtn.TextColor3 = Library.Favorites.Buttons[text] and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(255, 255, 255)
            FavBtn.Font = Enum.Font.SourceSans
            FavBtn.TextSize = 12
            Instance.new("UICorner", FavBtn).CornerRadius = UDim.new(0, 4)
            
            FavBtn.MouseButton1Click:Connect(function()
                Library.Favorites.Buttons[text] = not Library.Favorites.Buttons[text]
                FavBtn.TextColor3 = Library.Favorites.Buttons[text] and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(255, 255, 255)
                if Library.Settings.AutoSave then SaveConfig() end
            end)

            table.insert(Library.ElementsRegistry, {Text = text, Frame = Frame, Type = "Button"})
        end

        function TabFunctions:CreateToggle(text, flagName, default, callback)
            flagName = flagName or text
            if Library.Flags[flagName] ~= nil then default = Library.Flags[flagName] end
            Library.Flags[flagName] = default

            local Frame = Instance.new("Frame", ContentPage)
            Frame.Size = UDim2.new(1, -10, 0, 38)
            Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Frame.BackgroundTransparency = 0.4
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
            
            local Title = Instance.new("TextLabel", Frame)
            Title.Size = UDim2.new(0.6, 0, 1, 0)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1

            local ToggleBg = Instance.new("TextButton", Frame)
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
                if Library.Settings.AutoSave then SaveConfig() end
                
                local targetPos = IsOn and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                local targetColor = IsOn and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(60, 60, 60)
                local ballColor = IsOn and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(255, 255, 255)
                
                TweenService:Create(ToggleBall, TweenInfo.new(0.15), {Position = targetPos, BackgroundColor3 = ballColor}):Play()
                TweenService:Create(ToggleBg, TweenInfo.new(0.15), {BackgroundColor3 = targetColor}):Play()
                pcall(callback, IsOn)
            end)

            table.insert(Library.ElementsRegistry, {Text = text, Frame = Frame, Type = "Toggle"})
        end

        function TabFunctions:CreateSlider(text, flagName, min, max, default, callback)
            flagName = flagName or text
            if Library.Flags[flagName] ~= nil then default = Library.Flags[flagName] end
            Library.Flags[flagName] = default

            local Frame = Instance.new("Frame", ContentPage)
            Frame.Size = UDim2.new(1, -10, 0, 45)
            Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Frame.BackgroundTransparency = 0.4
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)

            local Title = Instance.new("TextLabel", Frame)
            Title.Size = UDim2.new(0.5, 0, 0, 20)
            Title.Position = UDim2.new(0, 8, 0, 2)
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1

            local ValueLabel = Instance.new("TextLabel", Frame)
            ValueLabel.Size = UDim2.new(0, 40, 0, 20)
            ValueLabel.Position = UDim2.new(1, -48, 0, 2)
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            ValueLabel.Font = Enum.Font.SourceSans
            ValueLabel.TextSize = 11
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.BackgroundTransparency = 1

            local SliderBg = Instance.new("TextButton", Frame)
            SliderBg.Size = UDim2.new(1, -16, 0, 6)
            SliderBg.Position = UDim2.new(0, 8, 1, -14)
            SliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            SliderBg.Text = ""
            Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)

            local SliderBar = Instance.new("Frame", SliderBg)
            SliderBar.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            SliderBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

            local sliding = false
            local function updateSlider(input)
                local percentage = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * percentage)
                ValueLabel.Text = tostring(value)
                SliderBar.Size = UDim2.new(percentage, 0, 1, 0)
                Library.Flags[flagName] = value
                if Library.Settings.AutoSave then SaveConfig() end
                pcall(callback, value)
            end

            SliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    updateSlider(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)

            table.insert(Library.ElementsRegistry, {Text = text, Frame = Frame, Type = "Slider"})
        end

        function TabFunctions:CreateDropdown(text, flagName, options, default, callback)
            flagName = flagName or text
            if Library.Flags[flagName] ~= nil then default = Library.Flags[flagName] end
            Library.Flags[flagName] = default

            local Frame = Instance.new("Frame", ContentPage)
            Frame.Size = UDim2.new(1, -10, 0, 38)
            Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Frame.BackgroundTransparency = 0.4
            Frame.ClipsDescendants = true
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)

            local Title = Instance.new("TextLabel", Frame)
            Title.Size = UDim2.new(0.5, 0, 0, 38)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1

            local OpenBtn = Instance.new("TextButton", Frame)
            OpenBtn.Size = UDim2.new(0, 100, 0, 22)
            OpenBtn.Position = UDim2.new(1, -108, 0, 8)
            OpenBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            OpenBtn.Text = tostring(default or "Select...")
            OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            OpenBtn.Font = Enum.Font.SourceSans
            OpenBtn.TextSize = 11
            Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 4)

            local OptionsContainer = Instance.new("Frame", Frame)
            OptionsContainer.Size = UDim2.new(1, -16, 0, #options * 24)
            OptionsContainer.Position = UDim2.new(0, 8, 0, 40)
            OptionsContainer.BackgroundTransparency = 1

            local list = Instance.new("UIListLayout", OptionsContainer)
            list.Padding = UDim.new(0, 2)

            for _, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton", OptionsContainer)
                optBtn.Size = UDim2.new(1, 0, 0, 22)
                optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                optBtn.Text = opt
                optBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
                optBtn.Font = Enum.Font.SourceSans
                optBtn.TextSize = 11
                Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)
                
                optBtn.MouseButton1Click:Connect(function()
                    OpenBtn.Text = opt
                    Library.Flags[flagName] = opt
                    if Library.Settings.AutoSave then SaveConfig() end
                    TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, 38)}):Play()
                    pcall(callback, opt)
                end)
            end

            local opened = false
            OpenBtn.MouseButton1Click:Connect(function()
                opened = not opened
                local targetHeight = opened and (42 + #options * 24) or 38
                TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, targetHeight)}):Play()
            end)

            table.insert(Library.ElementsRegistry, {Text = text, Frame = Frame, Type = "Dropdown"})
        end

        function TabFunctions:CreateTextBox(text, flagName, default, callback)
            flagName = flagName or text
            if Library.Flags[flagName] ~= nil then default = Library.Flags[flagName] end
            Library.Flags[flagName] = default

            local Frame = Instance.new("Frame", ContentPage)
            Frame.Size = UDim2.new(1, -10, 0, 38)
            Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Frame.BackgroundTransparency = 0.4
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)

            local Title = Instance.new("TextLabel", Frame)
            Title.Size = UDim2.new(0.5, 0, 1, 0)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1

            local Box = Instance.new("TextBox", Frame)
            Box.Size = UDim2.new(0, 120, 0, 22)
            Box.Position = UDim2.new(1, -128, 0.5, -11)
            Box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Box.Text = tostring(default or "")
            Box.TextColor3 = Color3.fromRGB(255, 255, 255)
            Box.Font = Enum.Font.SourceSans
            Box.TextSize = 11
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

            Box.FocusLost:Connect(function()
                Library.Flags[flagName] = Box.Text
                if Library.Settings.AutoSave then SaveConfig() end
                pcall(callback, Box.Text)
            end)

            table.insert(Library.ElementsRegistry, {Text = text, Frame = Frame, Type = "TextBox"})
        end

        return TabFunctions
    end

    -- Add Default Premium Windows Manager/Tabs inside Library Initialization
    local SettingsTab = WindowFunctions:CreateTab("Settings")
    SettingsTab:CreateSection("Configuration Profiles")
    SettingsTab:CreateTextBox("Profile Name", "CustomConfigName", "Default", function(val)
        CurrentConfigName = val
    end)
    SettingsTab:CreateButton("Save Profile Data", "Saves all flags", function()
        SaveConfig(CurrentConfigName)
        Library:Notify("Config Saved", "Profile "..CurrentConfigName.." saved successfully!", 3)
    end)
    SettingsTab:CreateButton("Load Profile Data", "Loads standard fields", function()
        LoadConfig(CurrentConfigName)
        Library:Notify("Config Loaded", "Profile "..CurrentConfigName.." parsed correctly!", 3)
    end)

    SettingsTab:CreateSection("Theme Customizer")
    local themesList = {"Purple Neon", "Blue", "Cyan", "Green", "Red", "Orange", "Pink", "Gold", "Rainbow Animation", "Custom RGB"}
    SettingsTab:CreateDropdown("Select Active Palette", "SelectedThemeColor", themesList, "Custom RGB", function(choice)
        Library.CurrentTheme = choice
        if choice == "Purple Neon" then Library.Theme.Accent = Color3.fromRGB(186, 85, 211) end
        if choice == "Blue" then Library.Theme.Accent = Color3.fromRGB(30, 144, 255) end
        if choice == "Cyan" then Library.Theme.Accent = Color3.fromRGB(0, 255, 255) end
        if choice == "Green" then Library.Theme.Accent = Color3.fromRGB(50, 205, 50) end
        if choice == "Red" then Library.Theme.Accent = Color3.fromRGB(220, 20, 60) end
        if choice == "Orange" then Library.Theme.Accent = Color3.fromRGB(255, 140, 0) end
        if choice == "Pink" then Library.Theme.Accent = Color3.fromRGB(255, 105, 180) end
        if choice == "Gold" then Library.Theme.Accent = Color3.fromRGB(255, 215, 0) end
    end)

    SettingsTab:CreateSection("Keybind Manager")
    local bindOptions = {"RightShift", "F1", "F2", "F3", "F4", "End", "Insert", "Delete", "Home", "RightControl", "LeftControl"}
    SettingsTab:CreateDropdown("Open/Close Trigger bind", "UiTriggerBindKey", bindOptions, "RightShift", function(keyName)
        pcall(function() ToggleKey = Enum.KeyCode[keyName] end)
    end)

    -- Keybind listener mapping
    local bindConnection = UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == ToggleKey then
            ToggleUI()
        end
    end)
    table.insert(Connections, bindConnection)

    -- Script Hub Tab Setup
    local HubTab = WindowFunctions:CreateTab("Script Hub")
    HubTab:CreateSection("Community Scripts Catalog")
    HubTab:CreateButton("Infinite Yield Admin", "Load community admin command lines", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)

    -- Credits Tab Setup
    local CreditTab = WindowFunctions:CreateTab("Credits")
    CreditTab:CreateSection("Authors & Main Acknowledgements")
    CreditTab:CreateSection("Nexzan Hub - Powered by definitive v4")
    CreditTab:CreateSection("Developer: Nexzan Core Devs Team")
    CreditTab:CreateSection("Discord community server supported")

    return WindowFunctions
end

function Library:Unload()
    Library.Unloaded = true
    for _, conn in ipairs(Connections) do
        if conn and conn.Disconnect then conn:Disconnect() end
    end
    local TargetParent = (RunService:IsStudio() and Player:WaitForChild("PlayerGui")) or CoreGui
    local old = TargetParent:FindFirstChild("NexzanHubPremiumUi")
    if old then old:Destroy() end
    local blur = game.Lighting:FindFirstChildOfClass("BlurEffect")
    if blur then blur:Destroy() end
end

return Library
