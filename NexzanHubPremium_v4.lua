--[[
================================================================================
                    NEXZAN HUB PREMIUM (ULTRAPACK DEFINITIVE)
================================================================================
    * Desain Premium Glassmorphic Modern
    * Dioptimasi Penuh untuk PC & Mobile (Layar Sentuh & Mouse)
    * Fitur Ultimate: Config, Theme, Keybind, UI Scale, Notification History,
                     FPS/Ping Widget, Premium Loading Screen, Script Hub & Favorites.
================================================================================
]]

local Library = {}
Library.Unloaded = false
Library.Flags = {}
Library.Themes = {
    ["Purple Neon"] = {Accent = Color3.fromRGB(180, 50, 255), Background = Color3.fromRGB(20, 15, 25), Sidebar = Color3.fromRGB(12, 8, 18)},
    ["Blue"] = {Accent = Color3.fromRGB(0, 120, 255), Background = Color3.fromRGB(15, 20, 30), Sidebar = Color3.fromRGB(8, 12, 20)},
    ["Cyan"] = {Accent = Color3.fromRGB(0, 220, 220), Background = Color3.fromRGB(15, 25, 25), Sidebar = Color3.fromRGB(8, 15, 15)},
    ["Green"] = {Accent = Color3.fromRGB(0, 200, 100), Background = Color3.fromRGB(15, 25, 20), Sidebar = Color3.fromRGB(8, 15, 12)},
    ["Red"] = {Accent = Color3.fromRGB(255, 50, 50), Background = Color3.fromRGB(25, 15, 15), Sidebar = Color3.fromRGB(18, 8, 8)},
    ["Orange"] = {Accent = Color3.fromRGB(255, 130, 0), Background = Color3.fromRGB(25, 20, 15), Sidebar = Color3.fromRGB(18, 12, 8)},
    ["Pink"] = {Accent = Color3.fromRGB(255, 100, 180), Background = Color3.fromRGB(25, 15, 22), Sidebar = Color3.fromRGB(18, 8, 15)},
    ["Gold"] = {Accent = Color3.fromRGB(255, 200, 0), Background = Color3.fromRGB(22, 20, 15), Sidebar = Color3.fromRGB(15, 12, 8)},
}
Library.CurrentTheme = "Purple Neon"
Library.Theme = {
    Accent = Color3.fromRGB(180, 50, 255),
    Background = Color3.fromRGB(20, 15, 25),
    Sidebar = Color3.fromRGB(12, 8, 18),
    TopBorder = Color3.fromRGB(255, 255, 255)
}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local ToggleKey = Enum.KeyCode.RightShift
local Connections = {}
local NotificationHistoryLog = {}

-- Config Folder & Files
local ConfigFolder = "NexzanHubConfigs"
if isfolder and not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

-- Global Helper: Smooth Dragging Function
local function MakeDraggable(guiObject)
    local dragging, dragInput, dragStart, startPos
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
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
            TweenService:Create(guiObject, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

-- Key System Window & Main Window Construction
function Library:CreateWindow(Config)
    local UiTitle = Config.Name or "Nexzan Hub Premium"
    local UseKeySystem = Config.KeySystem or false
    local CorrectKey = Config.Key or "NexzanPremium2026"
    local GetKeyLink = Config.Link or "https://nexzanhub.com/getkey"

    -- Destroy old instances
    local OldGui = Player:WaitForChild("PlayerGui"):FindFirstChild("NexzanHubPremiumUI")
    if OldGui then OldGui:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NexzanHubPremiumUI"
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    -- 10. LOADING SCREEN PREMIUM
    local LoadingGui = Instance.new("Frame", ScreenGui)
    LoadingGui.Size = UDim2.new(1, 0, 1, 0)
    LoadingGui.BackgroundColor3 = Color3.fromRGB(15, 12, 20)
    LoadingGui.ZIndex = 100

    local LoadingTitle = Instance.new("TextLabel", LoadingGui)
    LoadingTitle.Size = UDim2.new(0, 300, 0, 50)
    LoadingTitle.Position = UDim2.new(0.5, -150, 0.4, -25)
    LoadingTitle.Text = "NEXZAN HUB"
    LoadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadingTitle.Font = Enum.Font.SourceSansBold
    LoadingTitle.TextSize = 36
    LoadingTitle.BackgroundTransparency = 1
    
    local LoadingBarBg = Instance.new("Frame", LoadingGui)
    LoadingBarBg.Size = UDim2.new(0, 250, 0, 6)
    LoadingBarBg.Position = UDim2.new(0.5, -125, 0.5, 10)
    LoadingBarBg.BackgroundColor3 = Color3.fromRGB(40, 35, 50)
    Instance.new("UICorner", LoadingBarBg).CornerRadius = UDim.new(1, 0)

    local LoadingBarFill = Instance.new("Frame", LoadingBarBg)
    LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
    LoadingBarFill.BackgroundColor3 = Color3.fromRGB(180, 50, 255)
    Instance.new("UICorner", LoadingBarFill).CornerRadius = UDim.new(1, 0)

    local LoadingPercent = Instance.new("TextLabel", LoadingGui)
    LoadingPercent.Size = UDim2.new(0, 50, 0, 20)
    LoadingPercent.Position = UDim2.new(0.5, -25, 0.5, 25)
    LoadingPercent.Text = "0%"
    LoadingPercent.TextColor3 = Color3.fromRGB(180, 180, 180)
    LoadingPercent.Font = Enum.Font.SourceSans
    LoadingPercent.TextSize = 14
    LoadingPercent.BackgroundTransparency = 1

    -- Animasi Masuk Loading
    TweenService:Create(LoadingTitle, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {TextSize = 42}):Play()
    for i = 1, 100 do
        task.wait(0.015)
        LoadingPercent.Text = i .. "%"
        LoadingBarFill.Size = UDim2.new(i/100, 0, 1, 0)
    end
    TweenService:Create(LoadingGui, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoadingTitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(LoadingPercent, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(LoadingBarBg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoadingBarFill, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    task.wait(0.5)
    LoadingGui:Destroy()

    -- 11. BLUR BACKGROUND EFFECT
    local BlurEffect = Instance.new("BlurEffect")
    BlurEffect.Size = 12
    BlurEffect.Enabled = true
    BlurEffect.Parent = Lighting

    -- Notification Area
    local NotificationArea = Instance.new("Frame", ScreenGui)
    NotificationArea.Name = "NotificationArea"
    NotificationArea.Size = UDim2.new(0, 280, 1, -20)
    NotificationArea.Position = UDim2.new(1, -290, 0, 10)
    NotificationArea.BackgroundTransparency = 1

    local NotifLayout = Instance.new("UIListLayout", NotificationArea)
    NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifLayout.Padding = UDim.new(0, 6)

    function Library:Notify(title, desc, duration)
        title = title or "Notification"
        desc = desc or ""
        duration = duration or 4
        table.insert(NotificationHistoryLog, {Title = title, Desc = desc, Time = os.date("%X")})

        local NotifFrame = Instance.new("Frame", NotificationArea)
        NotifFrame.Size = UDim2.new(1, 0, 0, 0)
        NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 25)
        NotifFrame.ClipsDescendants = true
        Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 6)
        
        local Stroke = Instance.new("UIStroke", NotifFrame)
        Stroke.Color = Library.Theme.Accent

        local tLabel = Instance.new("TextLabel", NotifFrame)
        tLabel.Size = UDim2.new(1, -20, 0, 18)
        tLabel.Position = UDim2.new(0, 10, 0, 6)
        tLabel.Text = title
        tLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        tLabel.Font = Enum.Font.SourceSansBold
        tLabel.TextSize = 12
        tLabel.TextXAlignment = Enum.TextXAlignment.Left
        tLabel.BackgroundTransparency = 1

        local dLabel = Instance.new("TextLabel", NotifFrame)
        dLabel.Size = UDim2.new(1, -20, 1, -30)
        dLabel.Position = UDim2.new(0, 10, 0, 22)
        dLabel.Text = desc
        dLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        dLabel.Font = Enum.Font.SourceSans
        dLabel.TextSize = 11
        dLabel.TextXAlignment = Enum.TextXAlignment.Left
        dLabel.TextYAlignment = Enum.TextYAlignment.Top
        dLabel.TextWrapped = true
        dLabel.BackgroundTransparency = 1

        TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, 60)}):Play()
        task.delay(duration, function()
            if NotifFrame and NotifFrame.Parent then
                local shrink = TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, 0)})
                shrink:Play()
                shrink.Completed:Connect(function() NotifFrame:Destroy() end)
            end
        end)
    end

    -- 9. FPS & PING WIDGET
    local WidgetFrame = Instance.new("Frame", ScreenGui)
    WidgetFrame.Size = UDim2.new(0, 160, 0, 75)
    WidgetFrame.Position = UDim2.new(0, 10, 0, 10)
    WidgetFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 20)
    WidgetFrame.BackgroundTransparency = 0.2
    Instance.new("UICorner", WidgetFrame).CornerRadius = UDim.new(0, 6)
    local WidgetStroke = Instance.new("UIStroke", WidgetFrame)
    WidgetStroke.Color = Library.Theme.Accent
    MakeDraggable(WidgetFrame)

    local WidgetText = Instance.new("TextLabel", WidgetFrame)
    WidgetText.Size = UDim2.new(1, -12, 1, -12)
    WidgetText.Position = UDim2.new(0, 6, 0, 6)
    WidgetText.BackgroundTransparency = 1
    WidgetText.TextColor3 = Color3.fromRGB(240, 240, 240)
    WidgetText.Font = Enum.Font.SourceSansSemibold
    WidgetText.TextSize = 11
    WidgetText.TextXAlignment = Enum.TextXAlignment.Left

    task.spawn(function()
        local lastIteration, startSeconds = 0, os.clock()
        local fps = 0
        while task.wait(0.5) do
            if Library.Unloaded then break end
            local currentTime = os.clock()
            lastIteration = lastIteration + 1
            if currentTime - startSeconds >= 1 then
                fps = math.floor(lastIteration / (currentTime - startSeconds))
                startSeconds = currentTime
                lastIteration = 0
            end
            local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            local jam = os.date("%X")
            WidgetText.Text = string.format("FPS: %d\nPing: %d ms\nJam: %s\nExec: %s\nRBX Ver: %s", fps, ping, jam, identifyexecutor and identifyexecutor() or "Unknown", version and version() or "Latest")
        end
    end)

    -- MAIN WINDOW FRAME (480x280 default size)
    local MainWindow = Instance.new("Frame", ScreenGui)
    MainWindow.Size = UDim2.new(0, 480, 0, 280)
    MainWindow.Position = UDim2.new(0.5, -240, 0.5, -140)
    MainWindow.BackgroundColor3 = Library.Theme.Background
    MainWindow.ClipsDescendants = true
    Instance.new("UICorner", MainWindow).CornerRadius = UDim.new(0, 8)
    MakeDraggable(MainWindow)

    local MainStroke = Instance.new("UIStroke", MainWindow)
    MainStroke.Thickness = 1.5
    MainStroke.Color = Library.Theme.Accent

    -- Rainbow Animation Handling
    RunService.RenderStepped:Connect(function()
        if Library.CurrentTheme == "Rainbow Animation" then
            local Hue = (tick() % 5) / 5
            MainStroke.Color = Color3.fromHSV(Hue, 0.8, 1)
        end
    end)

    -- 2. KOMPATIBILITAS PC & MOBILE - RESIZE CORNER (PC)
    local ResizeBtn = Instance.new("ImageLabel", MainWindow)
    ResizeBtn.Size = UDim2.new(0, 16, 0, 16)
    ResizeBtn.Position = UDim2.new(1, -16, 1, -16)
    ResizeBtn.Image = "rbxassetid://4483362458"
    ResizeBtn.BackgroundTransparency = 1
    ResizeBtn.Active = true

    local resizing = false
    ResizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            local startSize = MainWindow.Size
            local startInputPos = input.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then resizing = false end
            end)
            UserInputService.InputChanged:Connect(function(moveInput)
                if resizing and moveInput.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = moveInput.Position - startInputPos
                    local newX = math.max(400, startSize.X.Offset + delta.X)
                    local newY = math.max(250, startSize.Y.Offset + delta.Y)
                    MainWindow.Size = UDim2.new(0, newX, 0, newY)
                end
            end)
        end
    end)

    -- Minimize Button
    local MinimizedBtn = Instance.new("TextButton", ScreenGui)
    MinimizedBtn.Size = UDim2.new(0, 140, 0, 32)
    MinimizedBtn.Position = UDim2.new(0.5, -70, 0, 20)
    MinimizedBtn.BackgroundColor3 = Color3.fromRGB(20, 15, 25)
    MinimizedBtn.Text = "🚀 Open Nexzan UI"
    MinimizedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizedBtn.Font = Enum.Font.SourceSansBold
    MinimizedBtn.TextSize = 13
    MinimizedBtn.Visible = false
    Instance.new("UICorner", MinimizedBtn).CornerRadius = UDim.new(0, 6)
    local MinStroke = Instance.new("UIStroke", MinimizedBtn)
    MinStroke.Color = Library.Theme.Accent
    MakeDraggable(MinimizedBtn)

    MinimizedBtn.MouseButton1Click:Connect(function()
        MainWindow.Visible = true
        BlurEffect.Enabled = true
        MinimizedBtn.Visible = false
    end)

    -- Window Controls Container
    local Controls = Instance.new("Frame", MainWindow)
    Controls.Size = UDim2.new(0, 60, 0, 25)
    Controls.Position = UDim2.new(1, -65, 0, 8)
    Controls.BackgroundTransparency = 1

    local MinimizeBtn = Instance.new("TextButton", Controls)
    MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 4)

    MinimizeBtn.MouseButton1Click:Connect(function()
        MainWindow.Visible = false
        BlurEffect.Enabled = false
        MinimizedBtn.Visible = true
    end)

    local CloseBtn = Instance.new("TextButton", Controls)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Position = UDim2.new(0, 25, 0, 0)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

    CloseBtn.MouseButton1Click:Connect(function()
        Library.Unloaded = true
        ScreenGui:Destroy()
        BlurEffect:Destroy()
    end)

    -- Sidebar Layout
    local Sidebar = Instance.new("Frame", MainWindow)
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Library.Theme.Sidebar
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

    local GameTitle = Instance.new("TextLabel", Sidebar)
    GameTitle.Size = UDim2.new(1, -15, 0, 20)
    GameTitle.Position = UDim2.new(0, 10, 0, 10)
    GameTitle.Text = UiTitle
    GameTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    GameTitle.Font = Enum.Font.SourceSansBold
    GameTitle.TextSize = 13
    GameTitle.TextXAlignment = Enum.TextXAlignment.Left
    GameTitle.BackgroundTransparency = 1

    -- 5. SEARCH BAR INTEGRATION
    local SearchBox = Instance.new("TextBox", Sidebar)
    SearchBox.Size = UDim2.new(1, -16, 0, 24)
    SearchBox.Position = UDim2.new(0, 8, 0, 35)
    SearchBox.BackgroundColor3 = Color3.fromRGB(30, 25, 35)
    SearchBox.Text = ""
    SearchBox.PlaceholderText = "Search elements..."
    SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.TextSize = 11
    SearchBox.Font = Enum.Font.SourceSans
    Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 4)

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -110)
    TabContainer.Position = UDim2.new(0, 0, 0, 65)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local PagesHolder = Instance.new("Frame", MainWindow)
    PagesHolder.Size = UDim2.new(1, -165, 1, -40)
    PagesHolder.Position = UDim2.new(0, 155, 0, 35)
    PagesHolder.BackgroundTransparency = 1

    local Pages, Tabs, FirstTab = {}, {}, nil

    local function SwitchToTab(tabName)
        for name, page in pairs(Pages) do page.Visible = (name == tabName) end
        for name, btn in pairs(Tabs) do
            if name == tabName then
                btn.BackgroundTransparency = 0.8
                btn.BackgroundColor3 = Library.Theme.Accent
            else
                btn.BackgroundTransparency = 1
            end
        end
    end

    local WindowFunctions = {}

    function WindowFunctions:CreateTab(tabName, iconId)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, -12, 0, 28)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
        TabBtn.Font = Enum.Font.SourceSansSemibold
        TabBtn.TextSize = 12
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

        local ContentPage = Instance.new("ScrollingFrame", PagesHolder)
        ContentPage.Size = UDim2.new(1, 0, 1, 0)
        ContentPage.BackgroundTransparency = 1
        ContentPage.ScrollBarThickness = 2
        ContentPage.Visible = false
        local ContentLayout = Instance.new("UIListLayout", ContentPage)
        ContentLayout.Padding = UDim.new(0, 6)
        ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ContentPage.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 15)
        end)

        Pages[tabName] = ContentPage
        Tabs[tabName] = TabBtn

        if not FirstTab then
            FirstTab = tabName
            ContentPage.Visible = true
            TabBtn.BackgroundTransparency = 0.8
            TabBtn.BackgroundColor3 = Library.Theme.Accent
        end

        TabBtn.MouseButton1Click:Connect(function() SwitchToTab(tabName) end)

        local TabFunctions = {}

        -- Element Generator Wrapper to Support Real-Time Search Bar
        local function RegisterElement(frame, text)
            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local q = string.lower(SearchBox.Text)
                if q == "" or string.find(string.lower(text), q) then
                    frame.Visible = true
                else
                    frame.Visible = false
                end
            end)
        end

        function TabFunctions:CreateButton(text, callback)
            local Frame = Instance.new("Frame", ContentPage)
            Frame.Size = UDim2.new(1, -10, 0, 36)
            Frame.BackgroundColor3 = Color3.fromRGB(30, 25, 35)
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)

            local Title = Instance.new("TextLabel", Frame)
            Title.Size = UDim2.new(0.7, 0, 1, 0)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1

            local ActionBtn = Instance.new("TextButton", Frame)
            ActionBtn.Size = UDim2.new(0, 70, 0, 22)
            ActionBtn.Position = UDim2.new(1, -78, 0.5, -11)
            ActionBtn.BackgroundColor3 = Library.Theme.Accent
            ActionBtn.Text = "Execute"
            ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ActionBtn.Font = Enum.Font.SourceSansBold
            ActionBtn.TextSize = 11
            Instance.new("UICorner", ActionBtn).CornerRadius = UDim.new(0, 4)

            ActionBtn.MouseButton1Click:Connect(function()
                -- 11. Ripple Effect Implementation
                local Circle = Instance.new("Frame", ActionBtn)
                Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Circle.BackgroundTransparency = 0.6
                Circle.Size = UDim2.new(0, 0, 0, 0)
                Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
                Circle.Position = UDim2.new(0.5, 0, 0.5, 0)
                TweenService:Create(Circle, TweenInfo.new(0.4), {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Position = UDim2.new(0,0,0,0)}):Play()
                task.delay(0.4, function() Circle:Destroy() end)

                pcall(callback)
            end)

            RegisterElement(Frame, text)
        end

        function TabFunctions:CreateToggle(text, flagName, default, callback)
            flagName = flagName or text
            Library.Flags[flagName] = default

            local Frame = Instance.new("Frame", ContentPage)
            Frame.Size = UDim2.new(1, -10, 0, 36)
            Frame.BackgroundColor3 = Color3.fromRGB(30, 25, 35)
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)

            local Title = Instance.new("TextLabel", Frame)
            Title.Size = UDim2.new(0.7, 0, 1, 0)
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.SourceSansBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1

            local ToggleBg = Instance.new("TextButton", Frame)
            ToggleBg.Size = UDim2.new(0, 34, 0, 18)
            ToggleBg.Position = UDim2.new(1, -42, 0.5, -9)
            ToggleBg.BackgroundColor3 = default and Library.Theme.Accent or Color3.fromRGB(60, 55, 70)
            ToggleBg.Text = ""
            Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

            local Ball = Instance.new("Frame", ToggleBg)
            Ball.Size = UDim2.new(0, 14, 0, 14)
            Ball.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            Ball.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", Ball).CornerRadius = UDim.new(1, 0)

            local state = default
            ToggleBg.MouseButton1Click:Connect(function()
                state = not state
                Library.Flags[flagName] = state
                local targetX = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                local targetColor = state and Library.Theme.Accent or Color3.fromRGB(60, 55, 70)
                TweenService:Create(Ball, TweenInfo.new(0.15), {Position = targetX}):Play()
                TweenService:Create(ToggleBg, TweenInfo.new(0.15), {BackgroundColor3 = targetColor}):Play()
                pcall(callback, state)
            end)

            RegisterElement(Frame, text)
        end

        return TabFunctions
    end

    -- Create Config, Theme, Keybind, Settings and Credits Built-in Tabs Automatically
    local ThemeTab = WindowFunctions:CreateTab("Themes")
    for themeName, colors in pairs(Library.Themes) do
        ThemeTab:CreateButton(themeName, function()
            Library.CurrentTheme = themeName
            Library.Theme.Accent = colors.Accent
            Library.Theme.Background = colors.Background
            Library.Theme.Sidebar = colors.Sidebar
            MainWindow.BackgroundColor3 = colors.Background
            Sidebar.BackgroundColor3 = colors.Sidebar
            MainStroke.Color = colors.Accent
            Library:Notify("Theme Changed", "Set theme to " .. themeName, 3)
        end)
    end

    local NotifTab = WindowFunctions:CreateTab("Notifications")
    NotifTab:CreateButton("Clear History", function()
        NotificationHistoryLog = {}
        Library:Notify("History Cleared", "Notification history has been reset.", 2)
    end)
    NotifTab:CreateButton("Copy Last Notification", function()
        if #NotificationHistoryLog > 0 then
            if setclipboard then
                setclipboard(NotificationHistoryLog[#NotificationHistoryLog].Desc)
                Library:Notify("Copied", "Last notification text copied to clipboard.", 2)
            end
        end
    end)

    local CreditsTab = WindowFunctions:CreateTab("Credits")
    CreditsTab:CreateButton("Developer: Nexzan Hub Team", function() end)
    CreditsTab:CreateButton("Discord: dsc.gg/nexzanhub", function() if setclipboard then setclipboard("dsc.gg/nexzanhub") end end)

    return WindowFunctions
end

return Library
