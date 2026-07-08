--[=[
================================================================================
              NEXZAN UI LIBRARY + KEY SYSTEM (FULL MERGED SCRIPT)
================================================================================
    * Key System kecil, draggable, centered
    * Theme sama persis dengan UI Utama
    * Key & Link bisa diubah di bagian CONFIG
    * Setelah key benar → langsung load UI Library lengkap
================================================================================
]=]

-- ========================== CONFIG ==========================
local KeySystemConfig = {
    Title = "Key System - Nexzan",
    Subtitle = "Keys? Pencet GetKey",
    
    -- === EDIT DI SINI ===
    ValidKeys = {
        "NEXZAN2025",
        "PREMIUM-KEY-001",
        -- Tambah key lain di sini
    },
    
    GetKeyLink = "https://discord.gg/nexzan",   -- Link yang akan dicopy
    
    -- Tema Warna (sama dengan UI Utama)
    Theme = {
        Primary       = Color3.fromRGB(20, 20, 35),
        Secondary     = Color3.fromRGB(30, 30, 50),
        Accent        = Color3.fromRGB(0, 170, 255),
        Text          = Color3.fromRGB(255, 255, 255),
        TextDark      = Color3.fromRGB(180, 180, 200),
        Success       = Color3.fromRGB(0, 200, 120),
        Error         = Color3.fromRGB(255, 80, 80),
        Button        = Color3.fromRGB(40, 40, 65),
        Sidebar       = Color3.fromRGB(12, 12, 12),
        Element       = Color3.fromRGB(25, 25, 25),
    }
}

-- ========================== SERVICES ==========================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ========================== KEY SYSTEM ==========================
local function CreateKeySystem(onSuccess)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NexzanKeySystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 320, 0, 280)
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -140)
    MainFrame.BackgroundColor3 = KeySystemConfig.Theme.Primary
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = MainFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = KeySystemConfig.Theme.Accent
    Stroke.Thickness = 1.5
    Stroke.Parent = MainFrame

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 15)
    Title.BackgroundTransparency = 1
    Title.Text = KeySystemConfig.Title
    Title.TextColor3 = KeySystemConfig.Theme.Text
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame

    -- Subtitle
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, 0, 0, 25)
    Subtitle.Position = UDim2.new(0, 0, 0, 55)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = KeySystemConfig.Subtitle
    Subtitle.TextColor3 = KeySystemConfig.Theme.TextDark
    Subtitle.TextSize = 14
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Parent = MainFrame

    -- Get Key Button (atas)
    local GetKeyTop = Instance.new("TextButton")
    GetKeyTop.Size = UDim2.new(0, 100, 0, 28)
    GetKeyTop.Position = UDim2.new(0.5, -50, 0, 90)
    GetKeyTop.BackgroundColor3 = KeySystemConfig.Theme.Button
    GetKeyTop.Text = "Get Key"
    GetKeyTop.TextColor3 = KeySystemConfig.Theme.Text
    GetKeyTop.TextSize = 13
    GetKeyTop.Font = Enum.Font.GothamBold
    GetKeyTop.Parent = MainFrame
    Instance.new("UICorner", GetKeyTop).CornerRadius = UDim.new(0, 6)

    -- Key TextBox
    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(0.85, 0, 0, 38)
    KeyBox.Position = UDim2.new(0.075, 0, 0, 130)
    KeyBox.BackgroundColor3 = KeySystemConfig.Theme.Secondary
    KeyBox.PlaceholderText = "Masukkan Key..."
    KeyBox.PlaceholderColor3 = KeySystemConfig.Theme.TextDark
    KeyBox.TextColor3 = KeySystemConfig.Theme.Text
    KeyBox.TextSize = 14
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.ClearTextOnFocus = false
    KeyBox.Parent = MainFrame
    Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

    -- Status Label
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 22)
    StatusLabel.Position = UDim2.new(0, 0, 0, 175)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = KeySystemConfig.Theme.Text
    StatusLabel.TextSize = 13
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = MainFrame

    -- Button Container
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(0.85, 0, 0, 38)
    ButtonContainer.Position = UDim2.new(0.075, 0, 0, 210)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = MainFrame

    -- GetKey Button (Kiri)
    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Size = UDim2.new(0.48, 0, 1, 0)
    GetKeyBtn.Position = UDim2.new(0, 0, 0, 0)
    GetKeyBtn.BackgroundColor3 = KeySystemConfig.Theme.Accent
    GetKeyBtn.Text = "GetKey"
    GetKeyBtn.TextColor3 = Color3.fromRGB(255,255,255)
    GetKeyBtn.TextSize = 14
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.Parent = ButtonContainer
    Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8)

    -- Verified Key Button (Kanan)
    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Size = UDim2.new(0.48, 0, 1, 0)
    VerifyBtn.Position = UDim2.new(0.52, 0, 0, 0)
    VerifyBtn.BackgroundColor3 = KeySystemConfig.Theme.Success
    VerifyBtn.Text = "Verified Key"
    VerifyBtn.TextColor3 = Color3.fromRGB(255,255,255)
    VerifyBtn.TextSize = 14
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.Parent = ButtonContainer
    Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 8)

    -- Draggable
    local function MakeDraggable(frame)
        local dragging, dragStart, startPos
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
            end
        end)
        frame.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        frame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end
    MakeDraggable(MainFrame)

    local function CopyLink()
        pcall(setclipboard, KeySystemConfig.GetKeyLink)
        StatusLabel.Text = "Link berhasil disalin!"
        StatusLabel.TextColor3 = KeySystemConfig.Theme.Success
        task.delay(1.8, function()
            if StatusLabel and StatusLabel.Parent then StatusLabel.Text = "" end
        end)
    end

    GetKeyTop.MouseButton1Click:Connect(CopyLink)
    GetKeyBtn.MouseButton1Click:Connect(CopyLink)

    -- Verify
    VerifyBtn.MouseButton1Click:Connect(function()
        local entered = KeyBox.Text
        if entered == "" then
            StatusLabel.Text = "Key tidak boleh kosong!"
            StatusLabel.TextColor3 = KeySystemConfig.Theme.Error
            return
        end

        local valid = false
        for _, k in ipairs(KeySystemConfig.ValidKeys) do
            if entered == k then valid = true break end
        end

        if valid then
            StatusLabel.Text = "Key Benar! Memuat UI..."
            StatusLabel.TextColor3 = KeySystemConfig.Theme.Success
            
            TweenService:Create(MainFrame, TweenInfo.new(0.35), {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            
            task.wait(0.45)
            ScreenGui:Destroy()
            if onSuccess then onSuccess() end
        else
            StatusLabel.Text = "Key Salah!"
            StatusLabel.TextColor3 = KeySystemConfig.Theme.Error
            KeyBox.Text = ""
            task.delay(2, function()
                if StatusLabel and StatusLabel.Parent then StatusLabel.Text = "" end
            end)
        end
    end)

    KeyBox.FocusLost:Connect(function(enter)
        if enter then VerifyBtn:Fire("MouseButton1Click") end
    end)
end

-- ========================== NEXZAN UI LIBRARY (ORIGINAL) ==========================
local function LoadNexzanLibrary()
    local Library = {}
    Library.Unloaded = false

    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local HttpService = game:GetService("HttpService")

    local Player = Players.LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")

    local Theme = KeySystemConfig.Theme

    -- Dragging Function
    local function MakeDraggable(guiObject)
        local dragging, dragStart, startPos
        guiObject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = guiObject.Position
            end
        end)
        guiObject.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                TweenService:Create(guiObject, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {
                    Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                }):Play()
            end
        end)
        guiObject.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    function Library:CreateWindow(config)
        config = config or {}
        local UiTitle = config.Title or "Nexzan UI"
        local UiSize = config.Size or UDim2.new(0, 620, 0, 420)

        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "NexzanUI"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.Parent = PlayerGui

        -- Main Window
        local MainWindow = Instance.new("Frame")
        MainWindow.Name = "MainWindow"
        MainWindow.Size = UiSize
        MainWindow.Position = UDim2.new(0.5, -UiSize.X.Offset/2, 0.5, -UiSize.Y.Offset/2)
        MainWindow.BackgroundColor3 = Theme.Primary
        MainWindow.BorderSizePixel = 0
        MainWindow.Parent = ScreenGui
        Instance.new("UICorner", MainWindow).CornerRadius = UDim.new(0, 12)
        Instance.new("UIStroke", MainWindow).Color = Theme.Accent
        Instance.new("UIStroke", MainWindow).Thickness = 1.5

        -- Top Bar
        local TopBar = Instance.new("Frame", MainWindow)
        TopBar.Size = UDim2.new(1, 0, 0, 45)
        TopBar.BackgroundColor3 = Theme.Secondary
        TopBar.BorderSizePixel = 0
        Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

        local TitleLabel = Instance.new("TextLabel", TopBar)
        TitleLabel.Size = UDim2.new(1, -120, 1, 0)
        TitleLabel.Position = UDim2.new(0, 18, 0, 0)
        TitleLabel.Text = UiTitle
        TitleLabel.TextColor3 = Theme.Text
        TitleLabel.TextSize = 18
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.BackgroundTransparency = 1

        -- Minimize & Close Buttons
        local ControlContainer = Instance.new("Frame", TopBar)
        ControlContainer.Size = UDim2.new(0, 60, 0, 25)
        ControlContainer.Position = UDim2.new(1, -70, 0, 10)
        ControlContainer.BackgroundTransparency = 1

        local BtnMinimize = Instance.new("TextButton", ControlContainer)
        BtnMinimize.Size = UDim2.new(0, 22, 0, 22)
        BtnMinimize.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        BtnMinimize.Text = "-"
        BtnMinimize.TextColor3 = Color3.fromRGB(255, 255, 255)
        BtnMinimize.Font = Enum.Font.SourceSansBold
        BtnMinimize.TextSize = 14
        Instance.new("UICorner", BtnMinimize).CornerRadius = UDim.new(0, 6)

        local BtnClose = Instance.new("TextButton", ControlContainer)
        BtnClose.Size = UDim2.new(0, 22, 0, 22)
        BtnClose.Position = UDim2.new(0, 28, 0, 0)
        BtnClose.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
        BtnClose.Text = "X"
        BtnClose.TextColor3 = Color3.fromRGB(255, 255, 255)
        BtnClose.Font = Enum.Font.SourceSansBold
        BtnClose.TextSize = 12
        Instance.new("UICorner", BtnClose).CornerRadius = UDim.new(0, 6)

        -- Minimized Button
        local MinimizedBtn = Instance.new("TextButton")
        MinimizedBtn.Name = "MinimizedBtn"
        MinimizedBtn.Size = UDim2.new(0, 140, 0, 36)
        MinimizedBtn.Position = UDim2.new(0, 20, 0, 20)
        MinimizedBtn.BackgroundColor3 = Theme.Primary
        MinimizedBtn.Text = UiTitle
        MinimizedBtn.TextColor3 = Theme.Text
        MinimizedBtn.Font = Enum.Font.GothamBold
        MinimizedBtn.TextSize = 14
        MinimizedBtn.Visible = false
        MinimizedBtn.Parent = ScreenGui
        Instance.new("UICorner", MinimizedBtn).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", MinimizedBtn).Color = Theme.Accent

        BtnMinimize.MouseButton1Click:Connect(function()
            MainWindow.Visible = false
            MinimizedBtn.Visible = true
        end)
        MinimizedBtn.MouseButton1Click:Connect(function()
            MinimizedBtn.Visible = false
            MainWindow.Visible = true
        end)
        BtnClose.MouseButton1Click:Connect(function()
            Library.Unloaded = true
            ScreenGui:Destroy()
        end)

        -- Sidebar
        local Sidebar = Instance.new("Frame", MainWindow)
        Sidebar.Size = UDim2.new(0, 190, 1, 0)
        Sidebar.BackgroundColor3 = Theme.Sidebar
        Sidebar.BorderSizePixel = 0
        Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

        local SidebarPatch = Instance.new("Frame", Sidebar)
        SidebarPatch.Size = UDim2.new(0, 15, 1, 0)
        SidebarPatch.Position = UDim2.new(1, -15, 0, 0)
        SidebarPatch.BackgroundColor3 = Theme.Sidebar
        SidebarPatch.BorderSizePixel = 0

        -- Header
        local Header = Instance.new("Frame", Sidebar)
        Header.Size = UDim2.new(1, 0, 0, 60)
        Header.BackgroundTransparency = 1

        local GameTitle = Instance.new("TextLabel", Header)
        GameTitle.Size = UDim2.new(1, -15, 0, 20)
        GameTitle.Position = UDim2.new(0, 15, 0, 12)
        GameTitle.Text = UiTitle
        GameTitle.TextColor3 = Theme.Text
        GameTitle.TextSize = 14
        GameTitle.Font = Enum.Font.SourceSansBold
        GameTitle.TextXAlignment = Enum.TextXAlignment.Left
        GameTitle.BackgroundTransparency = 1

        local AuthorContainer = Instance.new("Frame", Header)
        AuthorContainer.Size = UDim2.new(1, -15, 0, 16)
        AuthorContainer.Position = UDim2.new(0, 15, 0, 32)
        AuthorContainer.BackgroundTransparency = 1

        local AuthorLabel = Instance.new("TextLabel", AuthorContainer)
        AuthorLabel.Size = UDim2.new(0, 0, 1, 0)
        AuthorLabel.AutomaticSize = Enum.AutomaticSize.X
        AuthorLabel.Text = "Made by Nexzan"
        AuthorLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        AuthorLabel.TextSize = 11
        AuthorLabel.Font = Enum.Font.SourceSansItalic
        AuthorLabel.BackgroundTransparency = 1

        local VerifiedIcon = Instance.new("ImageLabel", AuthorContainer)
        VerifiedIcon.Size = UDim2.new(0, 12, 0, 12)
        VerifiedIcon.Position = UDim2.new(1, 5, 0.5, -6)
        VerifiedIcon.Image = "rbxassetid://4732109923"
        VerifiedIcon.ImageColor3 = Color3.fromRGB(57, 137, 243)
        VerifiedIcon.BackgroundTransparency = 1

        -- Tab Container
        local TabContainer = Instance.new("ScrollingFrame", Sidebar)
        TabContainer.Size = UDim2.new(1, 0, 1, -135)
        TabContainer.Position = UDim2.new(0, 0, 0, 65)
        TabContainer.BackgroundTransparency = 1
        TabContainer.ScrollBarThickness = 0

        local TabListLayout = Instance.new("UIListLayout", TabContainer)
        TabListLayout.Padding = UDim.new(0, 5)
        TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        -- Footer Profile
        local Footer = Instance.new("Frame", Sidebar)
        Footer.Size = UDim2.new(1, -16, 0, 48)
        Footer.Position = UDim2.new(0, 8, 1, -56)
        Footer.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
        Instance.new("UICorner", Footer).CornerRadius = UDim.new(0, 8)

        local AvatarImg = Instance.new("ImageLabel", Footer)
        AvatarImg.Size = UDim2.new(0, 32, 0, 32)
        AvatarImg.Position = UDim2.new(0, 8, 0.5, -16)
        AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id="..Player.UserId.."&w=150&h=150"
        Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

        local DisplayNameLabel = Instance.new("TextLabel", Footer)
        DisplayNameLabel.Size = UDim2.new(1, -50, 0, 15)
        DisplayNameLabel.Position = UDim2.new(0, 46, 0, 8)
        DisplayNameLabel.Text = Player.DisplayName
        DisplayNameLabel.TextColor3 = Theme.Text
        DisplayNameLabel.Font = Enum.Font.SourceSansBold
        DisplayNameLabel.TextSize = 13
        DisplayNameLabel.BackgroundTransparency = 1

        local UsernameLabel = Instance.new("TextLabel", Footer)
        UsernameLabel.Size = UDim2.new(1, -50, 0, 12)
        UsernameLabel.Position = UDim2.new(0, 46, 0, 23)
        UsernameLabel.Text = "@" .. Player.Name
        UsernameLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
        UsernameLabel.Font = Enum.Font.SourceSans
        UsernameLabel.TextSize = 11
        UsernameLabel.BackgroundTransparency = 1

        -- Pages Holder
        local PagesHolder = Instance.new("Frame", MainWindow)
        PagesHolder.Size = UDim2.new(1, -210, 1, -55)
        PagesHolder.Position = UDim2.new(0, 200, 0, 45)
        PagesHolder.BackgroundTransparency = 1

        local Pages = {}
        local Tabs = {}
        local FirstTab = nil

        local function SwitchToTab(tabName)
            for name, page in pairs(Pages) do page.Visible = (name == tabName) end
            for name, btn in pairs(Tabs) do
                if name == tabName then
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.82, BackgroundColor3 = Color3.fromRGB(57, 137, 243)}):Play()
                    btn.TabLayout.Txt.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                    btn.TabLayout.Txt.TextColor3 = Color3.fromRGB(170, 170, 170)
                end
            end
        end

        local WindowFunctions = {}

        function WindowFunctions:CreateTab(tabName, iconId)
            iconId = iconId or "rbxassetid://4483362458"

            local TabBtn = Instance.new("TextButton", TabContainer)
            TabBtn.Size = UDim2.new(1, -16, 0, 34)
            TabBtn.BackgroundTransparency = 1
            TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TabBtn.Text = ""
            Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

            local TabLayout = Instance.new("Frame", TabBtn)
            TabLayout.Name = "TabLayout"
            TabLayout.Size = UDim2.new(1, 0, 1, 0)
            TabLayout.BackgroundTransparency = 1

            local Icon = Instance.new("ImageLabel", TabLayout)
            Icon.Size = UDim2.new(0, 16, 0, 16)
            Icon.Position = UDim2.new(0, 10, 0.5, -8)
            Icon.Image = iconId
            Icon.BackgroundTransparency = 1

            local Txt = Instance.new("TextLabel", TabLayout)
            Txt.Name = "Txt"
            Txt.Size = UDim2.new(1, -38, 1, 0)
            Txt.Position = UDim2.new(0, 32, 0, 0)
            Txt.Text = tabName
            Txt.TextColor3 = Color3.fromRGB(170, 170, 170)
            Txt.TextSize = 13
            Txt.Font = Enum.Font.SourceSansSemibold
            Txt.TextXAlignment = Enum.TextXAlignment.Left
            Txt.BackgroundTransparency = 1

            local ContentPage = Instance.new("ScrollingFrame", PagesHolder)
            ContentPage.Size = UDim2.new(1, 0, 1, 0)
            ContentPage.BackgroundTransparency = 1
            ContentPage.ScrollBarThickness = 3
            ContentPage.Visible = false

            local ContentLayout = Instance.new("UIListLayout", ContentPage)
            ContentLayout.Padding = UDim.new(0, 8)
            ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

            ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                ContentPage.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 15)
            end)

            local Padding = Instance.new("UIPadding", ContentPage)
            Padding.PaddingTop = UDim.new(0, 2)
            Padding.PaddingBottom = UDim.new(0, 10)
            Padding.PaddingLeft = UDim.new(0, 2)
            Padding.PaddingRight = UDim.new(0, 2)

            Pages[tabName] = ContentPage
            Tabs[tabName] = TabBtn

            if not FirstTab then
                FirstTab = tabName
                ContentPage.Visible = true
                TabBtn.BackgroundTransparency = 0.82
                TabBtn.BackgroundColor3 = Color3.fromRGB(57, 137, 243)
                Txt.TextColor3 = Color3.fromRGB(255, 255, 255)
            end

            TabBtn.MouseButton1Click:Connect(function() SwitchToTab(tabName) end)

            local TabFunctions = {}

            -- BUTTON
            function TabFunctions:CreateButton(text, desc, callback)
                local FeatureFrame = Instance.new("Frame", ContentPage)
                FeatureFrame.Size = UDim2.new(1, -10, 0, 48)
                FeatureFrame.BackgroundColor3 = Theme.Element
                FeatureFrame.BackgroundTransparency = 0.4
                Instance.new("UICorner", FeatureFrame).CornerRadius = UDim.new(0, 6)
                Instance.new("UIStroke", FeatureFrame).Color = Color3.fromRGB(55, 55, 55)

                local Title = Instance.new("TextLabel", FeatureFrame)
                Title.Size = UDim2.new(0.7, 0, 0, 18)
                Title.Position = UDim2.new(0, 12, 0, 6)
                Title.Text = text
                Title.TextColor3 = Theme.Text
                Title.Font = Enum.Font.SourceSansBold
                Title.TextSize = 13
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.BackgroundTransparency = 1

                local Description = Instance.new("TextLabel", FeatureFrame)
                Description.Size = UDim2.new(0.7, 0, 0, 14)
                Description.Position = UDim2.new(0, 12, 0, 24)
                Description.Text = desc or "No description."
                Description.TextColor3 = Color3.fromRGB(150, 150, 150)
                Description.Font = Enum.Font.SourceSans
                Description.TextSize = 11
                Description.TextXAlignment = Enum.TextXAlignment.Left
                Description.BackgroundTransparency = 1

                FeatureFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if callback then callback() end
                    end
                end)
            end

            -- TOGGLE
            function TabFunctions:CreateToggle(text, desc, default, callback)
                local ToggleFrame = Instance.new("Frame", ContentPage)
                ToggleFrame.Size = UDim2.new(1, -10, 0, 48)
                ToggleFrame.BackgroundColor3 = Theme.Element
                ToggleFrame.BackgroundTransparency = 0.4
                Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)
                Instance.new("UIStroke", ToggleFrame).Color = Color3.fromRGB(55, 55, 55)

                local Title = Instance.new("TextLabel", ToggleFrame)
                Title.Size = UDim2.new(0.65, 0, 0, 18)
                Title.Position = UDim2.new(0, 12, 0, 6)
                Title.Text = text
                Title.TextColor3 = Theme.Text
                Title.Font = Enum.Font.SourceSansBold
                Title.TextSize = 13
                Title.BackgroundTransparency = 1

                local Description = Instance.new("TextLabel", ToggleFrame)
                Description.Size = UDim2.new(0.65, 0, 0, 14)
                Description.Position = UDim2.new(0, 12, 0, 24)
                Description.Text = desc or ""
                Description.TextColor3 = Color3.fromRGB(150, 150, 150)
                Description.Font = Enum.Font.SourceSans
                Description.TextSize = 11
                Description.BackgroundTransparency = 1

                local Switch = Instance.new("Frame", ToggleFrame)
                Switch.Size = UDim2.new(0, 46, 0, 24)
                Switch.Position = UDim2.new(1, -58, 0.5, -12)
                Switch.BackgroundColor3 = default and Theme.Success or Theme.Secondary
                Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

                local Knob = Instance.new("Frame", Switch)
                Knob.Size = UDim2.new(0, 20, 0, 20)
                Knob.Position = default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                Knob.BackgroundColor3 = Color3.new(1,1,1)
                Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

                local state = default or false

                local function Update()
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Success or Theme.Secondary}):Play()
                    TweenService:Create(Knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}):Play()
                end

                ToggleFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        state = not state
                        Update()
                        if callback then callback(state) end
                    end
                end)
                Update()
            end

            -- TEXTBOX
            function TabFunctions:CreateTextbox(text, placeholder, callback)
                local BoxFrame = Instance.new("Frame", ContentPage)
                BoxFrame.Size = UDim2.new(1, -10, 0, 48)
                BoxFrame.BackgroundColor3 = Theme.Element
                BoxFrame.BackgroundTransparency = 0.4
                Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 6)

                local Title = Instance.new("TextLabel", BoxFrame)
                Title.Size = UDim2.new(0.4, 0, 1, 0)
                Title.Position = UDim2.new(0, 12, 0, 0)
                Title.Text = text
                Title.TextColor3 = Theme.Text
                Title.Font = Enum.Font.SourceSansBold
                Title.TextSize = 13
                Title.BackgroundTransparency = 1

                local TextBox = Instance.new("TextBox", BoxFrame)
                TextBox.Size = UDim2.new(0.5, 0, 0, 28)
                TextBox.Position = UDim2.new(0.45, 0, 0.5, -14)
                TextBox.BackgroundColor3 = Theme.Secondary
                TextBox.PlaceholderText = placeholder or ""
                TextBox.TextColor3 = Theme.Text
                TextBox.Font = Enum.Font.SourceSans
                TextBox.TextSize = 13
                TextBox.ClearTextOnFocus = false
                Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)

                TextBox.FocusLost:Connect(function(enter)
                    if enter and callback then callback(TextBox.Text) end
                end)
            end

            -- SLIDER
            function TabFunctions:CreateSlider(text, min, max, default, callback)
                local SliderFrame = Instance.new("Frame", ContentPage)
                SliderFrame.Size = UDim2.new(1, -10, 0, 58)
                SliderFrame.BackgroundColor3 = Theme.Element
                SliderFrame.BackgroundTransparency = 0.4
                Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

                local Title = Instance.new("TextLabel", SliderFrame)
                Title.Size = UDim2.new(0.6, 0, 0, 18)
                Title.Position = UDim2.new(0, 12, 0, 6)
                Title.Text = text
                Title.TextColor3 = Theme.Text
                Title.Font = Enum.Font.SourceSansBold
                Title.TextSize = 13
                Title.BackgroundTransparency = 1

                local ValueLabel = Instance.new("TextLabel", SliderFrame)
                ValueLabel.Size = UDim2.new(0.3, 0, 0, 18)
                ValueLabel.Position = UDim2.new(0.65, 0, 0, 6)
                ValueLabel.Text = tostring(default or min)
                ValueLabel.TextColor3 = Theme.Accent
                ValueLabel.Font = Enum.Font.SourceSansBold
                ValueLabel.TextSize = 13
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.BackgroundTransparency = 1

                local SliderBG = Instance.new("Frame", SliderFrame)
                SliderBG.Size = UDim2.new(1, -24, 0, 6)
                SliderBG.Position = UDim2.new(0, 12, 0, 36)
                SliderBG.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Instance.new("UICorner", SliderBG).CornerRadius = UDim.new(1, 0)

                local SliderFill = Instance.new("Frame", SliderBG)
                SliderFill.BackgroundColor3 = Theme.Accent
                Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

                local Knob = Instance.new("Frame", SliderBG)
                Knob.Size = UDim2.new(0, 14, 0, 14)
                Knob.Position = UDim2.new(0, 0, 0.5, -7)
                Knob.BackgroundColor3 = Color3.new(1,1,1)
                Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

                local value = default or min
                local percent = (value - min) / (max - min)

                local function UpdateSlider(newPercent)
                    percent = math.clamp(newPercent, 0, 1)
                    value = math.floor(min + (max - min) * percent)
                    ValueLabel.Text = tostring(value)
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    Knob.Position = UDim2.new(percent, -7, 0.5, -7)
                    if callback then callback(value) end
                end

                UpdateSlider(percent)

                local dragging = false
                SliderBG.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        local pos = (input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X
                        UpdateSlider(pos)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local pos = (input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X
                        UpdateSlider(pos)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
            end

            -- LABEL
            function TabFunctions:CreateLabel(text)
                local LabelFrame = Instance.new("Frame", ContentPage)
                LabelFrame.Size = UDim2.new(1, -10, 0, 32)
                LabelFrame.BackgroundColor3 = Theme.Element
                LabelFrame.BackgroundTransparency = 0.4
                Instance.new("UICorner", LabelFrame).CornerRadius = UDim.new(0, 6)

                local LabelText = Instance.new("TextLabel", LabelFrame)
                LabelText.Size = UDim2.new(1, -20, 1, 0)
                LabelText.Position = UDim2.new(0, 10, 0, 0)
                LabelText.Text = text
                LabelText.TextColor3 = Theme.Text
                LabelText.Font = Enum.Font.SourceSans
                LabelText.TextSize = 13
                LabelText.BackgroundTransparency = 1
            end

            return TabFunctions
        end

        MakeDraggable(MainWindow)

        return WindowFunctions
    end

    -- Notification
    function Library:Notify(title, text, duration)
        print("[Nexzan] " .. title .. " - " .. text)
    end

    return Library
end
