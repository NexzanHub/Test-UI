--[[
    Nexzan Fluent UI Library
    Aesthetic: FluentPro (File 1)
    Logic Base: NewUIFixed (File 2)
    
    Features:
    - Fluent Design (Acrylic-ish, Modern Strokes, Gotham Font)
    - Horizontally Scrollable Tags (WindUI style)
    - User Info Display (Display Name, Actual username, Profile Picture)
    - Multi-Source Icon Support (Lucide, Gravity, Solar, SFSymbols) from GitHub
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- Configuration & Theme (FluentPro Style)
local Theme = {
    MainBackground = Color3.fromRGB(12, 12, 12),
    SidebarBackground = Color3.fromRGB(16, 16, 16),
    ElementBackground = Color3.fromRGB(22, 22, 22),
    ElementHover = Color3.fromRGB(28, 28, 28),
    MainBorder = Color3.fromRGB(40, 40, 40),
    Accent = Color3.fromRGB(180, 10, 20), -- Default Blood Red from FluentPro
    TextPrimary = Color3.fromRGB(240, 240, 240),
    TextSecondary = Color3.fromRGB(160, 160, 160),
    Font = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold,
    CornerRadius = UDim.new(0, 8)
}

local Sounds = {
    Click = 6895079853,
    Hover = 6895079632,
    ToggleOn = 8501254395,
    ToggleOff = 8501254199,
    Notification = 9114223297
}

-- Utility: Sound Player
local function playSound(soundId, volume)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(soundId)
    sound.Volume = volume or 0.5
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

-- Utility: Draggable
local function makeDraggable(guiObject, dragHandle)
    dragHandle = dragHandle or guiObject
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(guiObject, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    end

    dragHandle.InputBegan:Connect(function(input)
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

    dragHandle.InputChanged:Connect(function(input)
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

-- Icon System (IconFinder Integration)
local IconSystem = {}
IconSystem.Mappings = {}
IconSystem.Sources = {
    Lucide = "https://raw.githubusercontent.com/Orvez83/IconFinder/refs/heads/main/Icons/Lucide.lua",
    Gravity = "https://raw.githubusercontent.com/Orvez83/IconFinder/refs/heads/main/Icons/Gravity.lua",
    Solar = "https://raw.githubusercontent.com/Orvez83/IconFinder/refs/heads/main/Icons/Solar.lua",
    SFSymbols = "https://raw.githubusercontent.com/Orvez83/IconFinder/refs/heads/main/Icons/SFSymbols.lua"
}

function IconSystem:GetIcon(name)
    if not name or name == "" then return "" end
    if name:find("rbxassetid://") then return name end
    
    local prefix, iconName = name:match("^(%w+)/(%w+)")
    if not prefix then
        prefix = "Lucide"
        iconName = name
    end
    
    prefix = prefix:sub(1,1):upper() .. prefix:sub(2):lower() -- Normalize case

    if not self.Mappings[prefix] then
        local url = self.Sources[prefix]
        if url then
            local success, content = pcall(function() return game:HttpGet(url) end)
            if success then
                local data = loadstring(content)()
                self.Mappings[prefix] = data
            end
        end
    end
    
    if self.Mappings[prefix] and self.Mappings[prefix][iconName] then
        return self.Mappings[prefix][iconName]
    end
    
    return "rbxassetid://6031075931" -- Default fallback
end

-- UI Library Object
local Library = {}
Library.__index = Library

function Library.new(config)
    config = config or {}
    local self = setmetatable({}, Library)
    self.Title = config.Title or "Nexzan Fluent"
    
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NexzanFluent_UI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
    if not screenGui.Parent then screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    self.ScreenGui = screenGui

    -- Main Container
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 520, 0, 360)
    mainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
    mainFrame.BackgroundColor3 = Theme.MainBackground
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    self.MainFrame = mainFrame

    Instance.new("UICorner", mainFrame).CornerRadius = Theme.CornerRadius
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = Theme.MainBorder
    mainStroke.Thickness = 1.2
    
    makeDraggable(mainFrame)

    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 160, 1, 0)
    sidebar.BackgroundColor3 = Theme.SidebarBackground
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame

    local sidebarLine = Instance.new("Frame")
    sidebarLine.Size = UDim2.new(0, 1, 1, 0)
    sidebarLine.Position = UDim2.new(1, 0, 0, 0)
    sidebarLine.BackgroundColor3 = Theme.MainBorder
    sidebarLine.BorderSizePixel = 0
    sidebarLine.Parent = sidebar

    -- Logo Section
    local logoLabel = Instance.new("TextLabel")
    logoLabel.Size = UDim2.new(1, 0, 0, 50)
    logoLabel.BackgroundTransparency = 1
    logoLabel.Font = Theme.FontBold
    logoLabel.Text = self.Title
    logoLabel.TextColor3 = Theme.TextPrimary
    logoLabel.TextSize = 16
    logoLabel.Parent = sidebar

    -- Tab Scroll Area
    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Name = "TabScroll"
    tabScroll.Size = UDim2.new(1, -10, 1, -120)
    tabScroll.Position = UDim2.new(0, 5, 0, 50)
    tabScroll.BackgroundTransparency = 1
    tabScroll.BorderSizePixel = 0
    tabScroll.ScrollBarThickness = 0
    tabScroll.Parent = sidebar

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tabScroll

    -- User Info (Bottom Sidebar)
    local userInfo = Instance.new("Frame")
    userInfo.Name = "UserInfo"
    userInfo.Size = UDim2.new(1, -10, 0, 50)
    userInfo.Position = UDim2.new(0, 5, 1, -55)
    userInfo.BackgroundColor3 = Theme.ElementBackground
    userInfo.BorderSizePixel = 0
    userInfo.Parent = sidebar
    
    Instance.new("UICorner", userInfo).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", userInfo).Color = Theme.MainBorder

    local userImage = Instance.new("ImageLabel")
    userImage.Name = "ProfileImage"
    userImage.Size = UDim2.new(0, 36, 0, 36)
    userImage.Position = UDim2.new(0, 7, 0.5, -18)
    userImage.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    userImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    userImage.Parent = userInfo
    Instance.new("UICorner", userImage).CornerRadius = UDim.new(1, 0)

    local displayName = Instance.new("TextLabel")
    displayName.Size = UDim2.new(1, -55, 0, 18)
    displayName.Position = UDim2.new(0, 50, 0, 8)
    displayName.BackgroundTransparency = 1
    displayName.Font = Theme.FontBold
    displayName.Text = LocalPlayer.DisplayName
    displayName.TextColor3 = Theme.TextPrimary
    displayName.TextSize = 12
    displayName.TextXAlignment = Enum.TextXAlignment.Left
    displayName.Parent = userInfo

    local userName = Instance.new("TextLabel")
    userName.Size = UDim2.new(1, -55, 0, 14)
    userName.Position = UDim2.new(0, 50, 0, 24)
    userName.BackgroundTransparency = 1
    userName.Font = Theme.Font
    userName.Text = "@" .. LocalPlayer.Name
    userName.TextColor3 = Theme.TextSecondary
    userName.TextSize = 10
    userName.TextXAlignment = Enum.TextXAlignment.Left
    userName.Parent = userInfo

    -- Content Area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -160, 1, 0)
    contentArea.Position = UDim2.new(0, 160, 0, 0)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame

    self.Tabs = {}
    self.ActiveTab = nil
    
    return self
end

function Library:CreateTab(name, icon)
    local Tab = {
        Library = self,
        Name = name,
        Active = false
    }

    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 32)
    tabBtn.BackgroundColor3 = Theme.Accent
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = ""
    tabBtn.Parent = self.MainFrame.Sidebar.TabScroll
    
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    
    local tabIcon = Instance.new("ImageLabel")
    tabIcon.Size = UDim2.new(0, 18, 0, 18)
    tabIcon.Position = UDim2.new(0, 8, 0.5, -9)
    tabIcon.BackgroundTransparency = 1
    tabIcon.Image = IconSystem:GetIcon(icon)
    tabIcon.ImageColor3 = Theme.TextSecondary
    tabIcon.Parent = tabBtn
    
    local tabLabel = Instance.new("TextLabel")
    tabLabel.Size = UDim2.new(1, -35, 1, 0)
    tabLabel.Position = UDim2.new(0, 32, 0, 0)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Font = Theme.Font
    tabLabel.Text = name
    tabLabel.TextColor3 = Theme.TextSecondary
    tabLabel.TextSize = 13
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.Parent = tabBtn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Theme.MainBorder
    page.Visible = false
    page.Parent = self.MainFrame.ContentArea
    
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 8)
    pageLayout.Parent = page
    
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
    end)

    local function selectTab()
        for _, otherTab in ipairs(self.Tabs) do
            otherTab.Active = false
            otherTab.Page.Visible = false
            TweenService:Create(otherTab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            TweenService:Create(otherTab.Label, TweenInfo.new(0.2), {TextColor3 = Theme.TextSecondary}):Play()
            TweenService:Create(otherTab.Icon, TweenInfo.new(0.2), {ImageColor3 = Theme.TextSecondary}):Play()
        end
        Tab.Active = true
        page.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.9}):Play()
        TweenService:Create(tabLabel, TweenInfo.new(0.2), {TextColor3 = Theme.TextPrimary}):Play()
        TweenService:Create(tabIcon, TweenInfo.new(0.2), {ImageColor3 = Theme.Accent}):Play()
    end

    tabBtn.MouseButton1Click:Connect(selectTab)
    
    Tab.Button = tabBtn
    Tab.Label = tabLabel
    Tab.Icon = tabIcon
    Tab.Page = page
    
    table.insert(self.Tabs, Tab)
    if not self.ActiveTab then
        self.ActiveTab = Tab
        selectTab()
    end

    -- ==================== TAGS FEATURE (WindUI Style) ====================
    function Tab:AddTags(tags)
        local tagFrame = Instance.new("Frame")
        tagFrame.Size = UDim2.new(1, 0, 0, 30)
        tagFrame.BackgroundTransparency = 1
        tagFrame.Parent = page

        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.ScrollBarThickness = 0
        scroll.ScrollingDirection = Enum.ScrollingDirection.X
        scroll.Parent = tagFrame

        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = scroll

        for _, tagName in ipairs(tags) do
            local tag = Instance.new("Frame")
            tag.BackgroundColor3 = Theme.ElementBackground
            tag.BorderSizePixel = 0
            tag.Parent = scroll
            
            local tagText = Instance.new("TextLabel")
            tagText.Size = UDim2.new(0, 0, 1, 0)
            tagText.AutomaticSize = Enum.AutomaticSize.X
            tagText.BackgroundTransparency = 1
            tagText.Font = Theme.Font
            tagText.Text = tagName
            tagText.TextColor3 = Theme.TextPrimary
            tagText.TextSize = 11
            tagText.Parent = tag
            
            local padding = Instance.new("UIPadding", tag)
            padding.PaddingLeft = UDim.new(0, 10)
            padding.PaddingRight = UDim.new(0, 10)
            
            tag.Size = UDim2.new(0, 0, 1, 0)
            tag.AutomaticSize = Enum.AutomaticSize.X
            Instance.new("UICorner", tag).CornerRadius = UDim.new(0, 15)
            Instance.new("UIStroke", tag).Color = Theme.MainBorder
        end
        
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scroll.CanvasSize = UDim2.new(0, layout.AbsoluteContentSize.X, 0, 0)
        end)
    end

    -- ==================== WIDGETS ====================

    function Tab:AddButton(title, desc, callback)
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Size = UDim2.new(1, 0, 0, 45)
        buttonFrame.BackgroundColor3 = Theme.ElementBackground
        buttonFrame.Parent = page
        Instance.new("UICorner", buttonFrame).CornerRadius = UDim.new(0, 6)
        local stroke = Instance.new("UIStroke", buttonFrame)
        stroke.Color = Theme.MainBorder
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -80, 0, 20)
        label.Position = UDim2.new(0, 12, 0, 6)
        label.BackgroundTransparency = 1
        label.Font = Theme.FontBold
        label.Text = title
        label.TextColor3 = Theme.TextPrimary
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = buttonFrame
        
        local dlabel = Instance.new("TextLabel")
        dlabel.Size = UDim2.new(1, -80, 0, 15)
        dlabel.Position = UDim2.new(0, 12, 0, 24)
        dlabel.BackgroundTransparency = 1
        dlabel.Font = Theme.Font
        dlabel.Text = desc
        dlabel.TextColor3 = Theme.TextSecondary
        dlabel.TextSize = 11
        dlabel.TextXAlignment = Enum.TextXAlignment.Left
        dlabel.Parent = buttonFrame

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 60, 0, 24)
        btn.Position = UDim2.new(1, -70, 0.5, -12)
        btn.BackgroundColor3 = Theme.MainBackground
        btn.Font = Theme.FontBold
        btn.Text = "Run"
        btn.TextColor3 = Theme.TextPrimary
        btn.TextSize = 11
        btn.Parent = buttonFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        Instance.new("UIStroke", btn).Color = Theme.MainBorder
        
        btn.MouseButton1Click:Connect(function()
            playSound(Sounds.Click)
            pcall(callback)
        end)
    end

    function Tab:AddToggle(title, desc, default, callback)
        local state = default or false
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, 0, 0, 45)
        toggleFrame.BackgroundColor3 = Theme.ElementBackground
        toggleFrame.Parent = page
        Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", toggleFrame).Color = Theme.MainBorder
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -60, 0, 20)
        label.Position = UDim2.new(0, 12, 0, 6)
        label.BackgroundTransparency = 1
        label.Font = Theme.FontBold
        label.Text = title
        label.TextColor3 = Theme.TextPrimary
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame

        local dlabel = Instance.new("TextLabel")
        dlabel.Size = UDim2.new(1, -60, 0, 15)
        dlabel.Position = UDim2.new(0, 12, 0, 24)
        dlabel.BackgroundTransparency = 1
        dlabel.Font = Theme.Font
        dlabel.Text = desc
        dlabel.TextColor3 = Theme.TextSecondary
        dlabel.TextSize = 11
        dlabel.TextXAlignment = Enum.TextXAlignment.Left
        dlabel.Parent = toggleFrame

        local switch = Instance.new("TextButton")
        switch.Size = UDim2.new(0, 36, 0, 20)
        switch.Position = UDim2.new(1, -48, 0.5, -10)
        switch.BackgroundColor3 = state and Theme.Accent or Theme.MainBackground
        switch.Text = ""
        switch.Parent = toggleFrame
        Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
        Instance.new("UIStroke", switch).Color = Theme.MainBorder
        
        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 14, 0, 14)
        indicator.Position = state and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 4, 0.5, -7)
        indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        indicator.Parent = switch
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

        switch.MouseButton1Click:Connect(function()
            state = not state
            playSound(state and Sounds.ToggleOn or Sounds.ToggleOff)
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Accent or Theme.MainBackground}):Play()
            TweenService:Create(indicator, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 4, 0.5, -7)}):Play()
            pcall(callback, state)
        end)
    end

    function Tab:AddSlider(title, min, max, default, decimals, callback)
        callback = callback or function() end
        decimals = decimals or 0
        local value = default or min

        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, 0, 0, 50)
        sliderFrame.BackgroundColor3 = Theme.ElementBackground
        sliderFrame.Parent = page
        Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", sliderFrame).Color = Theme.MainBorder

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(0.6, 0, 0, 20)
        titleLabel.Position = UDim2.new(0, 12, 0, 6)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Theme.FontBold
        titleLabel.Text = title
        titleLabel.TextColor3 = Theme.TextPrimary
        titleLabel.TextSize = 13
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = sliderFrame

        local valBox = Instance.new("TextBox")
        valBox.Size = UDim2.new(0, 45, 0, 20)
        valBox.Position = UDim2.new(1, -55, 0, 6)
        valBox.BackgroundColor3 = Theme.MainBackground
        valBox.Font = Theme.Font
        valBox.TextSize = 11
        valBox.TextColor3 = Theme.TextPrimary
        valBox.Text = tostring(value)
        valBox.Parent = sliderFrame
        Instance.new("UICorner", valBox).CornerRadius = UDim.new(0, 4)
        Instance.new("UIStroke", valBox).Color = Theme.MainBorder

        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -24, 0, 4)
        track.Position = UDim2.new(0, 12, 0, 35)
        track.BackgroundColor3 = Theme.MainBackground
        track.BorderSizePixel = 0
        track.Parent = sliderFrame
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((value - min)/(max - min), 0, 1, 0)
        fill.BackgroundColor3 = Theme.Accent
        fill.BorderSizePixel = 0
        fill.Parent = track
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 12, 0, 12)
        knob.Position = UDim2.new((value - min)/(max - min), -6, 0.5, -6)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.Parent = track
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        Instance.new("UIStroke", knob).Color = Theme.MainBorder

        local isSliding = false
        local function updateSlider(inputPos)
            local scale = math.clamp((inputPos - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local rawVal = min + scale * (max - min)
            local mult = 10^decimals
            value = math.round(rawVal * mult) / mult
            fill.Size = UDim2.new(scale, 0, 1, 0)
            knob.Position = UDim2.new(scale, -6, 0.5, -6)
            valBox.Text = tostring(value)
            pcall(callback, value)
        end

        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isSliding = true
                updateSlider(input.Position.X)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input.Position.X)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isSliding = false
            end
        end)
    end

    function Tab:AddDropdown(title, items, isMulti, callback)
        callback = callback or function() end
        local active = false
        local selected = {}
        
        local ddFrame = Instance.new("Frame")
        ddFrame.Size = UDim2.new(1, 0, 0, 40)
        ddFrame.BackgroundColor3 = Theme.ElementBackground
        ddFrame.ClipsDescendants = true
        ddFrame.Parent = page
        Instance.new("UICorner", ddFrame).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", ddFrame).Color = Theme.MainBorder
        
        local mainBtn = Instance.new("TextButton")
        mainBtn.Size = UDim2.new(1, 0, 0, 40)
        mainBtn.BackgroundTransparency = 1
        mainBtn.Text = ""
        mainBtn.Parent = ddFrame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -40, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Font = Theme.FontBold
        label.Text = title
        label.TextColor3 = Theme.TextPrimary
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = mainBtn
        
        local arrow = Instance.new("ImageLabel")
        arrow.Size = UDim2.new(0, 16, 0, 16)
        arrow.Position = UDim2.new(1, -30, 0.5, -8)
        arrow.BackgroundTransparency = 1
        arrow.Image = "rbxassetid://6031094037"
        arrow.ImageColor3 = Theme.TextSecondary
        arrow.Parent = mainBtn
        
        local options = Instance.new("ScrollingFrame")
        options.Size = UDim2.new(1, -10, 0, 100)
        options.Position = UDim2.new(0, 5, 0, 45)
        options.BackgroundTransparency = 1
        options.BorderSizePixel = 0
        options.ScrollBarThickness = 2
        options.Visible = false
        options.Parent = ddFrame
        
        local oLayout = Instance.new("UIListLayout")
        oLayout.Padding = UDim.new(0, 4)
        oLayout.Parent = options
        
        for _, item in ipairs(items) do
            local oBtn = Instance.new("TextButton")
            oBtn.Size = UDim2.new(1, -5, 0, 26)
            oBtn.BackgroundColor3 = Theme.MainBackground
            oBtn.Font = Theme.Font
            oBtn.Text = item
            oBtn.TextColor3 = Theme.TextSecondary
            oBtn.TextSize = 12
            oBtn.Parent = options
            Instance.new("UICorner", oBtn).CornerRadius = UDim.new(0, 4)
            
            oBtn.MouseButton1Click:Connect(function()
                if isMulti then
                    local idx = table.find(selected, item)
                    if idx then table.remove(selected, idx) else table.insert(selected, item) end
                    pcall(callback, selected)
                else
                    selected = {item}
                    active = false
                    TweenService:Create(ddFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                    TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    options.Visible = false
                    pcall(callback, item)
                end
            end)
        end
        
        mainBtn.MouseButton1Click:Connect(function()
            active = not active
            if active then
                options.Visible = true
                TweenService:Create(ddFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 150)}):Play()
                TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
            else
                TweenService:Create(ddFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                task.wait(0.2)
                if not active then options.Visible = false end
            end
        end)
    end

    function Tab:AddTextbox(title, placeholder, callback)
        callback = callback or function() end
        local tbFrame = Instance.new("Frame")
        tbFrame.Size = UDim2.new(1, 0, 0, 45)
        tbFrame.BackgroundColor3 = Theme.ElementBackground
        tbFrame.Parent = page
        Instance.new("UICorner", tbFrame).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", tbFrame).Color = Theme.MainBorder
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.4, 0, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Font = Theme.FontBold
        label.Text = title
        label.TextColor3 = Theme.TextPrimary
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = tbFrame
        
        local input = Instance.new("TextBox")
        input.Size = UDim2.new(0.5, 0, 0, 26)
        input.Position = UDim2.new(1, -12, 0.5, -13)
        input.AnchorPoint = Vector2.new(1, 0)
        input.BackgroundColor3 = Theme.MainBackground
        input.Font = Theme.Font
        input.PlaceholderText = placeholder or "Enter text..."
        input.Text = ""
        input.TextColor3 = Theme.TextPrimary
        input.TextSize = 12
        input.Parent = tbFrame
        Instance.new("UICorner", input).CornerRadius = UDim.new(0, 4)
        Instance.new("UIStroke", input).Color = Theme.MainBorder
        
        input.FocusLost:Connect(function()
            pcall(callback, input.Text)
        end)
    end

    function Tab:AddKeybind(title, default, callback)
        callback = callback or function() end
        local current = default or Enum.KeyCode.E
        local listening = false
        
        local kbFrame = Instance.new("Frame")
        kbFrame.Size = UDim2.new(1, 0, 0, 45)
        kbFrame.BackgroundColor3 = Theme.ElementBackground
        kbFrame.Parent = page
        Instance.new("UICorner", kbFrame).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", kbFrame).Color = Theme.MainBorder
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -80, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Font = Theme.FontBold
        label.Text = title
        label.TextColor3 = Theme.TextPrimary
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = kbFrame
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 70, 0, 26)
        btn.Position = UDim2.new(1, -82, 0.5, -13)
        btn.BackgroundColor3 = Theme.MainBackground
        btn.Font = Theme.Font
        btn.Text = current.Name
        btn.TextColor3 = Theme.TextPrimary
        btn.TextSize = 12
        btn.Parent = kbFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        Instance.new("UIStroke", btn).Color = Theme.MainBorder
        
        btn.MouseButton1Click:Connect(function()
            listening = true
            btn.Text = "..."
        end)
        
        UserInputService.InputBegan:Connect(function(input, gpe)
            if listening then
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    current = input.KeyCode
                    listening = false
                    btn.Text = current.Name
                end
            elseif not gpe and input.KeyCode == current then
                pcall(callback)
            end
        end)
    end

    function Tab:AddLabel(text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Font = Theme.Font
        label.Text = text
        label.TextColor3 = Theme.TextPrimary
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = page
    end

    function Tab:AddParagraph(title, desc)
        local paraFrame = Instance.new("Frame")
        paraFrame.Size = UDim2.new(1, 0, 0, 0)
        paraFrame.AutomaticSize = Enum.AutomaticSize.Y
        paraFrame.BackgroundColor3 = Theme.ElementBackground
        paraFrame.Parent = page
        Instance.new("UICorner", paraFrame).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", paraFrame).Color = Theme.MainBorder
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 4)
        layout.Parent = paraFrame
        Instance.new("UIPadding", paraFrame).PaddingBottom = UDim.new(0, 10)
        Instance.new("UIPadding", paraFrame).PaddingTop = UDim.new(0, 10)
        Instance.new("UIPadding", paraFrame).PaddingLeft = UDim.new(0, 12)
        Instance.new("UIPadding", paraFrame).PaddingRight = UDim.new(0, 12)

        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1, 0, 0, 20)
        t.BackgroundTransparency = 1
        t.Font = Theme.FontBold
        t.Text = title
        t.TextColor3 = Theme.TextPrimary
        t.TextSize = 13
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.Parent = paraFrame
        
        local d = Instance.new("TextLabel")
        d.Size = UDim2.new(1, 0, 0, 0)
        d.AutomaticSize = Enum.AutomaticSize.Y
        d.BackgroundTransparency = 1
        d.Font = Theme.Font
        d.Text = desc
        d.TextColor3 = Theme.TextSecondary
        d.TextSize = 11
        d.TextWrapped = true
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.Parent = paraFrame
    end

    return Tab
end

return Library
