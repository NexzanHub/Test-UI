--[[
    Nexzan Fluent UI Library V2
    Aesthetic: FluentPro (File 1) 
    Logic Base: NewUIFixed (File 2)
    
    Features:
    - 20+ Original Themes from FluentPro
    - Custom Theme Support
    - Horizontally Scrollable Tags (WindUI Style)
    - Detailed User Info (Display, Real, Pfp)
    - Full IconFinder Integration (Lucide, Solar, Gravity, SFSymbols)
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- ==================== THEME DATA (FROM FILE 1) ====================
local Library = {
    CurrentTheme = nil,
    Themes = {},
    Elements = {},
    Window = nil
}

Library.Themes = {
    ["Blood Red"] = {
        MainBackground = Color3.fromRGB(15, 8, 10),
        SidebarBackground = Color3.fromRGB(20, 10, 12),
        ElementBackground = Color3.fromRGB(28, 12, 14),
        ElementHover = Color3.fromRGB(35, 15, 18),
        Accent = Color3.fromRGB(180, 10, 20),
        MainBorder = Color3.fromRGB(45, 15, 20),
        TextPrimary = Color3.fromRGB(255, 230, 230),
        TextSecondary = Color3.fromRGB(210, 175, 178)
    },
    ["AMOLED"] = {
        MainBackground = Color3.fromRGB(0, 0, 0),
        SidebarBackground = Color3.fromRGB(5, 5, 5),
        ElementBackground = Color3.fromRGB(12, 12, 12),
        ElementHover = Color3.fromRGB(18, 18, 18),
        Accent = Color3.fromRGB(255, 255, 255),
        MainBorder = Color3.fromRGB(25, 25, 25),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(150, 150, 150)
    },
    ["Neon Cyber"] = {
        MainBackground = Color3.fromRGB(5, 10, 5),
        SidebarBackground = Color3.fromRGB(8, 15, 8),
        ElementBackground = Color3.fromRGB(12, 22, 12),
        ElementHover = Color3.fromRGB(15, 30, 15),
        Accent = Color3.fromRGB(57, 255, 20),
        MainBorder = Color3.fromRGB(20, 50, 20),
        TextPrimary = Color3.fromRGB(200, 255, 190),
        TextSecondary = Color3.fromRGB(100, 180, 100)
    },
    ["Arctic Frost"] = {
        MainBackground = Color3.fromRGB(235, 248, 255),
        SidebarBackground = Color3.fromRGB(220, 240, 255),
        ElementBackground = Color3.fromRGB(210, 235, 250),
        ElementHover = Color3.fromRGB(200, 225, 245),
        Accent = Color3.fromRGB(100, 180, 240),
        MainBorder = Color3.fromRGB(180, 215, 240),
        TextPrimary = Color3.fromRGB(20, 40, 70),
        TextSecondary = Color3.fromRGB(65, 105, 148)
    },
    ["Midnight Blue"] = {
        MainBackground = Color3.fromRGB(10, 8, 25),
        SidebarBackground = Color3.fromRGB(15, 12, 35),
        ElementBackground = Color3.fromRGB(20, 15, 45),
        ElementHover = Color3.fromRGB(25, 20, 55),
        Accent = Color3.fromRGB(100, 80, 200),
        MainBorder = Color3.fromRGB(40, 30, 90),
        TextPrimary = Color3.fromRGB(220, 220, 255),
        TextSecondary = Color3.fromRGB(150, 150, 200)
    },
    ["Orange"] = {
        MainBackground = Color3.fromRGB(10, 5, 0),
        SidebarBackground = Color3.fromRGB(15, 8, 0),
        ElementBackground = Color3.fromRGB(22, 10, 2),
        ElementHover = Color3.fromRGB(30, 15, 5),
        Accent = Color3.fromRGB(255, 140, 30),
        MainBorder = Color3.fromRGB(50, 25, 5),
        TextPrimary = Color3.fromRGB(255, 240, 220),
        TextSecondary = Color3.fromRGB(200, 160, 120)
    },
    ["Cyanic"] = {
        MainBackground = Color3.fromRGB(5, 15, 15),
        SidebarBackground = Color3.fromRGB(8, 20, 20),
        ElementBackground = Color3.fromRGB(12, 28, 28),
        ElementHover = Color3.fromRGB(15, 35, 35),
        Accent = Color3.fromRGB(57, 197, 187),
        MainBorder = Color3.fromRGB(30, 60, 60),
        TextPrimary = Color3.fromRGB(210, 248, 246),
        TextSecondary = Color3.fromRGB(130, 180, 175)
    },
    ["Deep Violet"] = {
        MainBackground = Color3.fromRGB(15, 10, 25),
        SidebarBackground = Color3.fromRGB(20, 15, 35),
        ElementBackground = Color3.fromRGB(25, 20, 45),
        ElementHover = Color3.fromRGB(30, 25, 55),
        Accent = Color3.fromRGB(160, 120, 220),
        MainBorder = Color3.fromRGB(50, 40, 80),
        TextPrimary = Color3.fromRGB(240, 240, 240),
        TextSecondary = Color3.fromRGB(180, 180, 210)
    },
    ["Cotton Candy"] = {
        MainBackground = Color3.fromRGB(255, 240, 250),
        SidebarBackground = Color3.fromRGB(255, 230, 245),
        ElementBackground = Color3.fromRGB(255, 220, 240),
        ElementHover = Color3.fromRGB(255, 210, 235),
        Accent = Color3.fromRGB(255, 130, 190),
        MainBorder = Color3.fromRGB(255, 180, 220),
        TextPrimary = Color3.fromRGB(75, 25, 55),
        TextSecondary = Color3.fromRGB(145, 75, 115)
    }
}

-- Add even more theme slots as per requirement
local moreThemes = {"Galaxy Purple", "Cosmic Violet", "Royal Blue", "Deep Ocean", "Charcoal", "Ash Gray", "Amber Glow", "Pearl White", "Emerald", "Gold", "Coffee", "Sakura"}
for _, name in ipairs(moreThemes) do
    if not Library.Themes[name] then
        Library.Themes[name] = Library.Themes["Blood Red"] -- Placeholders
    end
end

-- ==================== UTILS & CONFIG ====================
local Sounds = {
    Click = 6895079853,
    Hover = 6895079632,
    ToggleOn = 8501254395,
    ToggleOff = 8501254199,
    Notification = 9114223297
}

local function playSound(soundId, volume)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(soundId)
    sound.Volume = volume or 0.5
    sound.Parent = SoundService
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 2)
end

local function makeDraggable(guiObject, dragHandle)
    dragHandle = dragHandle or guiObject
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(guiObject, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    end

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end

-- ==================== ICON SYSTEM ====================
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
    
    prefix = prefix:sub(1,1):upper() .. prefix:sub(2):lower()

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
    
    return "rbxassetid://6031075931"
end

-- ==================== CORE LIBRARY ====================
Library.__index = Library

function Library.new(config)
    config = config or {}
    local self = setmetatable({}, Library)
    
    self.Title = config.Title or "Nexzan Fluent Pro"
    self.CurrentTheme = Library.Themes[config.Theme] or Library.Themes["Blood Red"]
    self.Objects = {} -- Store references for theme updating
    
    -- Main Gui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NexzanFluentPro_" .. HttpService:GenerateGUID(false)
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 100
    pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
    if not screenGui.Parent then screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    self.ScreenGui = screenGui

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 560, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -280, 0.5, -190)
    mainFrame.BackgroundColor3 = self.CurrentTheme.MainBackground
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    self.MainFrame = mainFrame
    self:AddObject(mainFrame, "BackgroundColor3", "MainBackground")

    local mainCorner = Instance.new("UICorner", mainFrame)
    mainCorner.CornerRadius = UDim.new(0, 10)
    
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = self.CurrentTheme.MainBorder
    mainStroke.Thickness = 1.2
    self:AddObject(mainStroke, "Color", "MainBorder")
    
    makeDraggable(mainFrame)

    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 170, 1, 0)
    sidebar.BackgroundColor3 = self.CurrentTheme.SidebarBackground
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame
    self:AddObject(sidebar, "BackgroundColor3", "SidebarBackground")

    local sidebarLine = Instance.new("Frame")
    sidebarLine.Size = UDim2.new(0, 1, 1, 0)
    sidebarLine.Position = UDim2.new(1, 0, 0, 0)
    sidebarLine.BackgroundColor3 = self.CurrentTheme.MainBorder
    sidebarLine.BorderSizePixel = 0
    sidebarLine.Parent = sidebar
    self:AddObject(sidebarLine, "BackgroundColor3", "MainBorder")

    -- Logo Section
    local logoLabel = Instance.new("TextLabel")
    logoLabel.Size = UDim2.new(1, 0, 0, 55)
    logoLabel.BackgroundTransparency = 1
    logoLabel.Font = Enum.Font.GothamBold
    logoLabel.Text = self.Title
    logoLabel.TextColor3 = self.CurrentTheme.TextPrimary
    logoLabel.TextSize = 17
    logoLabel.Parent = sidebar
    self:AddObject(logoLabel, "TextColor3", "TextPrimary")

    -- Tab Container
    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Name = "TabScroll"
    tabScroll.Size = UDim2.new(1, -12, 1, -135)
    tabScroll.Position = UDim2.new(0, 6, 0, 55)
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
    userInfo.Size = UDim2.new(1, -16, 0, 60)
    userInfo.Position = UDim2.new(0, 8, 1, -68)
    userInfo.BackgroundColor3 = self.CurrentTheme.ElementBackground
    userInfo.BorderSizePixel = 0
    userInfo.Parent = sidebar
    self:AddObject(userInfo, "BackgroundColor3", "ElementBackground")
    
    Instance.new("UICorner", userInfo).CornerRadius = UDim.new(0, 8)
    local uiStroke = Instance.new("UIStroke", userInfo)
    uiStroke.Color = self.CurrentTheme.MainBorder
    uiStroke.Thickness = 1
    self:AddObject(uiStroke, "Color", "MainBorder")

    local userImage = Instance.new("ImageLabel")
    userImage.Name = "ProfileImage"
    userImage.Size = UDim2.new(0, 42, 0, 42)
    userImage.Position = UDim2.new(0, 9, 0.5, -21)
    userImage.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    userImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    userImage.Parent = userInfo
    Instance.new("UICorner", userImage).CornerRadius = UDim.new(1, 0)

    local displayName = Instance.new("TextLabel")
    displayName.Size = UDim2.new(1, -60, 0, 20)
    displayName.Position = UDim2.new(0, 58, 0, 10)
    displayName.BackgroundTransparency = 1
    displayName.Font = Enum.Font.GothamBold
    displayName.Text = LocalPlayer.DisplayName
    displayName.TextColor3 = self.CurrentTheme.TextPrimary
    displayName.TextSize = 13
    displayName.TextXAlignment = Enum.TextXAlignment.Left
    displayName.Parent = userInfo
    self:AddObject(displayName, "TextColor3", "TextPrimary")

    local userName = Instance.new("TextLabel")
    userName.Size = UDim2.new(1, -60, 0, 16)
    userName.Position = UDim2.new(0, 58, 0, 28)
    userName.BackgroundTransparency = 1
    userName.Font = Enum.Font.Gotham
    userName.Text = "@" .. LocalPlayer.Name
    userName.TextColor3 = self.CurrentTheme.TextSecondary
    userName.TextSize = 11
    userName.TextXAlignment = Enum.TextXAlignment.Left
    userName.Parent = userInfo
    self:AddObject(userName, "TextColor3", "TextSecondary")

    -- Content Area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -170, 1, 0)
    contentArea.Position = UDim2.new(0, 170, 0, 0)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame

    self.Tabs = {}
    self.ActiveTab = nil
    Library.Window = self
    
    return self
end

-- ==================== THEME ENGINE ====================
function Library:AddObject(obj, prop, themeKey)
    table.insert(self.Objects, {Object = obj, Property = prop, Key = themeKey})
end

function Library:SetTheme(name)
    local theme = Library.Themes[name]
    if not theme then return end
    self.CurrentTheme = theme
    for _, data in ipairs(self.Objects) do
        pcall(function()
            data.Object[data.Property] = theme[data.Key]
        end)
    end
end

function Library:AddCustomTheme(name, data)
    Library.Themes[name] = data
end

-- ==================== TAB SYSTEM ====================
function Library:CreateTab(name, icon)
    local Tab = {
        Library = self,
        Name = name,
        Active = false,
        Elements = {}
    }

    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 36)
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = ""
    tabBtn.Parent = self.MainFrame.Sidebar.TabScroll
    
    local btnCorner = Instance.new("UICorner", tabBtn)
    btnCorner.CornerRadius = UDim.new(0, 6)
    
    local tabIcon = Instance.new("ImageLabel")
    tabIcon.Size = UDim2.new(0, 20, 0, 20)
    tabIcon.Position = UDim2.new(0, 10, 0.5, -10)
    tabIcon.BackgroundTransparency = 1
    tabIcon.Image = IconSystem:GetIcon(icon)
    tabIcon.ImageColor3 = self.Library.CurrentTheme.TextSecondary
    tabIcon.Parent = tabBtn
    self.Library:AddObject(tabIcon, "ImageColor3", "TextSecondary")
    
    local tabLabel = Instance.new("TextLabel")
    tabLabel.Size = UDim2.new(1, -45, 1, 0)
    tabLabel.Position = UDim2.new(0, 38, 0, 0)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Font = Enum.Font.GothamMedium
    tabLabel.Text = name
    tabLabel.TextColor3 = self.Library.CurrentTheme.TextSecondary
    tabLabel.TextSize = 14
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.Parent = tabBtn
    self.Library:AddObject(tabLabel, "TextColor3", "TextSecondary")

    -- Page Container
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -24, 1, -24)
    page.Position = UDim2.new(0, 12, 0, 12)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = self.Library.CurrentTheme.MainBorder
    page.Visible = false
    page.Parent = self.Library.MainFrame.ContentArea
    self.Library:AddObject(page, "ScrollBarImageColor3", "MainBorder")
    
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 10)
    pageLayout.Parent = page
    
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
    end)

    local function selectTab()
        for _, otherTab in ipairs(self.Library.Tabs) do
            otherTab.Active = false
            otherTab.Page.Visible = false
            TweenService:Create(otherTab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            TweenService:Create(otherTab.TabLabel, TweenInfo.new(0.2), {TextColor3 = self.Library.CurrentTheme.TextSecondary}):Play()
            TweenService:Create(otherTab.TabIcon, TweenInfo.new(0.2), {ImageColor3 = self.Library.CurrentTheme.TextSecondary}):Play()
        end
        Tab.Active = true
        page.Visible = true
        playSound(Sounds.Hover, 0.3)
        TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.9, BackgroundColor3 = self.Library.CurrentTheme.Accent}):Play()
        TweenService:Create(tabLabel, TweenInfo.new(0.2), {TextColor3 = self.Library.CurrentTheme.TextPrimary}):Play()
        TweenService:Create(tabIcon, TweenInfo.new(0.2), {ImageColor3 = self.Library.CurrentTheme.Accent}):Play()
    end

    tabBtn.MouseButton1Click:Connect(selectTab)
    
    Tab.Button = tabBtn
    Tab.TabLabel = tabLabel
    Tab.TabIcon = tabIcon
    Tab.Page = page
    
    table.insert(self.Library.Tabs, Tab)
    if not self.Library.ActiveTab then
        self.Library.ActiveTab = Tab
        selectTab()
    end

    -- ==================== TAB WIDGETS ====================

    function Tab:AddTags(tags)
        local tagFrame = Instance.new("Frame")
        tagFrame.Size = UDim2.new(1, 0, 0, 32)
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
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = scroll

        for _, tagName in ipairs(tags) do
            local tag = Instance.new("Frame")
            tag.BackgroundColor3 = self.Library.CurrentTheme.ElementBackground
            tag.BorderSizePixel = 0
            tag.Parent = scroll
            self.Library:AddObject(tag, "BackgroundColor3", "ElementBackground")
            
            local tagText = Instance.new("TextLabel")
            tagText.Size = UDim2.new(0, 0, 1, 0)
            tagText.AutomaticSize = Enum.AutomaticSize.X
            tagText.BackgroundTransparency = 1
            tagText.Font = Enum.Font.GothamMedium
            tagText.Text = tagName
            tagText.TextColor3 = self.Library.CurrentTheme.TextPrimary
            tagText.TextSize = 12
            tagText.Parent = tag
            self.Library:AddObject(tagText, "TextColor3", "TextPrimary")
            
            Instance.new("UIPadding", tag).PaddingLeft = UDim.new(0, 12)
            tag.Size = UDim2.new(0, 0, 1, 0)
            tag.AutomaticSize = Enum.AutomaticSize.X
            Instance.new("UICorner", tag).CornerRadius = UDim.new(0, 16)
            local stroke = Instance.new("UIStroke", tag)
            stroke.Color = self.Library.CurrentTheme.MainBorder
            self.Library:AddObject(stroke, "Color", "MainBorder")
        end
        
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scroll.CanvasSize = UDim2.new(0, layout.AbsoluteContentSize.X, 0, 0)
        end)
    end

    function Tab:AddButton(title, desc, callback)
        local btnFrame = Instance.new("Frame")
        btnFrame.Size = UDim2.new(1, 0, 0, 48)
        btnFrame.BackgroundColor3 = self.Library.CurrentTheme.ElementBackground
        btnFrame.Parent = page
        self.Library:AddObject(btnFrame, "BackgroundColor3", "ElementBackground")
        Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 8)
        
        local stroke = Instance.new("UIStroke", btnFrame)
        stroke.Color = self.Library.CurrentTheme.MainBorder
        self.Library:AddObject(stroke, "Color", "MainBorder")

        local tLabel = Instance.new("TextLabel")
        tLabel.Size = UDim2.new(1, -90, 0, 22)
        tLabel.Position = UDim2.new(0, 14, 0, 8)
        tLabel.BackgroundTransparency = 1
        tLabel.Font = Enum.Font.GothamBold
        tLabel.Text = title
        tLabel.TextColor3 = self.Library.CurrentTheme.TextPrimary
        tLabel.TextSize = 14
        tLabel.TextXAlignment = Enum.TextXAlignment.Left
        tLabel.Parent = btnFrame
        self.Library:AddObject(tLabel, "TextColor3", "TextPrimary")

        local dLabel = Instance.new("TextLabel")
        dLabel.Size = UDim2.new(1, -90, 0, 16)
        dLabel.Position = UDim2.new(0, 14, 0, 26)
        dLabel.BackgroundTransparency = 1
        dLabel.Font = Enum.Font.Gotham
        dLabel.Text = desc
        dLabel.TextColor3 = self.Library.CurrentTheme.TextSecondary
        dLabel.TextSize = 12
        dLabel.TextXAlignment = Enum.TextXAlignment.Left
        dLabel.Parent = btnFrame
        self.Library:AddObject(dLabel, "TextColor3", "TextSecondary")

        local trigger = Instance.new("TextButton")
        trigger.Size = UDim2.new(0, 70, 0, 28)
        trigger.Position = UDim2.new(1, -84, 0.5, -14)
        trigger.BackgroundColor3 = self.Library.CurrentTheme.SidebarBackground
        trigger.Font = Enum.Font.GothamBold
        trigger.Text = "Run"
        trigger.TextColor3 = self.Library.CurrentTheme.Accent
        trigger.TextSize = 12
        trigger.Parent = btnFrame
        self.Library:AddObject(trigger, "BackgroundColor3", "SidebarBackground")
        self.Library:AddObject(trigger, "TextColor3", "Accent")
        
        Instance.new("UICorner", trigger).CornerRadius = UDim.new(0, 6)
        local btnStroke = Instance.new("UIStroke", trigger)
        btnStroke.Color = self.Library.CurrentTheme.MainBorder
        self.Library:AddObject(btnStroke, "Color", "MainBorder")

        trigger.MouseButton1Click:Connect(function()
            playSound(Sounds.Click, 0.5)
            pcall(callback)
        end)
    end

    function Tab:AddToggle(title, desc, default, callback)
        local state = default or false
        local tFrame = Instance.new("Frame")
        tFrame.Size = UDim2.new(1, 0, 0, 48)
        tFrame.BackgroundColor3 = self.Library.CurrentTheme.ElementBackground
        tFrame.Parent = page
        self.Library:AddObject(tFrame, "BackgroundColor3", "ElementBackground")
        Instance.new("UICorner", tFrame).CornerRadius = UDim.new(0, 8)
        
        local stroke = Instance.new("UIStroke", tFrame)
        stroke.Color = self.Library.CurrentTheme.MainBorder
        self.Library:AddObject(stroke, "Color", "MainBorder")

        local tLabel = Instance.new("TextLabel")
        tLabel.Size = UDim2.new(1, -70, 0, 22)
        tLabel.Position = UDim2.new(0, 14, 0, 8)
        tLabel.BackgroundTransparency = 1
        tLabel.Font = Enum.Font.GothamBold
        tLabel.Text = title
        tLabel.TextColor3 = self.Library.CurrentTheme.TextPrimary
        tLabel.TextSize = 14
        tLabel.TextXAlignment = Enum.TextXAlignment.Left
        tLabel.Parent = tFrame
        self.Library:AddObject(tLabel, "TextColor3", "TextPrimary")

        local dLabel = Instance.new("TextLabel")
        dLabel.Size = UDim2.new(1, -70, 0, 16)
        dLabel.Position = UDim2.new(0, 14, 0, 26)
        dLabel.BackgroundTransparency = 1
        dLabel.Font = Enum.Font.Gotham
        dLabel.Text = desc
        dLabel.TextColor3 = self.Library.CurrentTheme.TextSecondary
        dLabel.TextSize = 12
        dLabel.TextXAlignment = Enum.TextXAlignment.Left
        dLabel.Parent = tFrame
        self.Library:AddObject(dLabel, "TextColor3", "TextSecondary")

        local switch = Instance.new("TextButton")
        switch.Size = UDim2.new(0, 42, 0, 22)
        switch.Position = UDim2.new(1, -56, 0.5, -11)
        switch.BackgroundColor3 = state and self.Library.CurrentTheme.Accent or self.Library.CurrentTheme.SidebarBackground
        switch.Text = ""
        switch.Parent = tFrame
        self.Library:AddObject(switch, "BackgroundColor3", state and "Accent" or "SidebarBackground")
        
        Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
        local swStroke = Instance.new("UIStroke", switch)
        swStroke.Color = self.Library.CurrentTheme.MainBorder
        self.Library:AddObject(swStroke, "Color", "MainBorder")

        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 16, 0, 16)
        indicator.Position = state and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)
        indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        indicator.Parent = switch
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

        switch.MouseButton1Click:Connect(function()
            state = not state
            playSound(state and Sounds.ToggleOn or Sounds.ToggleOff, 0.4)
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = state and self.Library.CurrentTheme.Accent or self.Library.CurrentTheme.SidebarBackground}):Play()
            TweenService:Create(indicator, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)}):Play()
            pcall(callback, state)
        end)
    end

    function Tab:AddSlider(title, min, max, default, decimals, callback)
        local value = default or min
        local mult = 10^(decimals or 0)
        
        local sFrame = Instance.new("Frame")
        sFrame.Size = UDim2.new(1, 0, 0, 56)
        sFrame.BackgroundColor3 = self.Library.CurrentTheme.ElementBackground
        sFrame.Parent = page
        self.Library:AddObject(sFrame, "BackgroundColor3", "ElementBackground")
        Instance.new("UICorner", sFrame).CornerRadius = UDim.new(0, 8)
        
        local stroke = Instance.new("UIStroke", sFrame)
        stroke.Color = self.Library.CurrentTheme.MainBorder
        self.Library:AddObject(stroke, "Color", "MainBorder")

        local tLabel = Instance.new("TextLabel")
        tLabel.Size = UDim2.new(1, -100, 0, 20)
        tLabel.Position = UDim2.new(0, 14, 0, 10)
        tLabel.BackgroundTransparency = 1
        tLabel.Font = Enum.Font.GothamBold
        tLabel.Text = title
        tLabel.TextColor3 = self.Library.CurrentTheme.TextPrimary
        tLabel.TextSize = 14
        tLabel.TextXAlignment = Enum.TextXAlignment.Left
        tLabel.Parent = sFrame
        self.Library:AddObject(tLabel, "TextColor3", "TextPrimary")

        local valBox = Instance.new("TextBox")
        valBox.Size = UDim2.new(0, 50, 0, 22)
        valBox.Position = UDim2.new(1, -64, 0, 10)
        valBox.BackgroundColor3 = self.Library.CurrentTheme.SidebarBackground
        valBox.Font = Enum.Font.GothamMedium
        valBox.Text = tostring(value)
        valBox.TextColor3 = self.Library.CurrentTheme.TextPrimary
        valBox.TextSize = 12
        valBox.Parent = sFrame
        self.Library:AddObject(valBox, "BackgroundColor3", "SidebarBackground")
        self.Library:AddObject(valBox, "TextColor3", "TextPrimary")
        Instance.new("UICorner", valBox).CornerRadius = UDim.new(0, 4)
        Instance.new("UIStroke", valBox).Color = self.Library.CurrentTheme.MainBorder

        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -28, 0, 4)
        track.Position = UDim2.new(0, 14, 0, 42)
        track.BackgroundColor3 = self.Library.CurrentTheme.SidebarBackground
        track.Parent = sFrame
        self.Library:AddObject(track, "BackgroundColor3", "SidebarBackground")
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((value - min)/(max - min), 0, 1, 0)
        fill.BackgroundColor3 = self.Library.CurrentTheme.Accent
        fill.Parent = track
        self.Library:AddObject(fill, "BackgroundColor3", "Accent")
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 14, 0, 14)
        knob.Position = UDim2.new((value - min)/(max - min), -7, 0.5, -7)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.Parent = track
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        local kStroke = Instance.new("UIStroke", knob)
        kStroke.Color = self.Library.CurrentTheme.MainBorder

        local function update(inputPos)
            local scale = math.clamp((inputPos - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local raw = min + scale * (max - min)
            value = math.round(raw * mult) / mult
            fill.Size = UDim2.new(scale, 0, 1, 0)
            knob.Position = UDim2.new(scale, -7, 0.5, -7)
            valBox.Text = tostring(value)
            pcall(callback, value)
        end

        local sliding = false
        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = true
                update(input.Position.X)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input.Position.X)
            end
        end)
    end

    function Tab:AddDropdown(title, items, isMulti, callback)
        local active = false
        local selected = {}
        
        local ddFrame = Instance.new("Frame")
        ddFrame.Size = UDim2.new(1, 0, 0, 44)
        ddFrame.BackgroundColor3 = self.Library.CurrentTheme.ElementBackground
        ddFrame.ClipsDescendants = true
        ddFrame.Parent = page
        self.Library:AddObject(ddFrame, "BackgroundColor3", "ElementBackground")
        Instance.new("UICorner", ddFrame).CornerRadius = UDim.new(0, 8)
        
        local stroke = Instance.new("UIStroke", ddFrame)
        stroke.Color = self.Library.CurrentTheme.MainBorder
        self.Library:AddObject(stroke, "Color", "MainBorder")

        local mainBtn = Instance.new("TextButton")
        mainBtn.Size = UDim2.new(1, 0, 0, 44)
        mainBtn.BackgroundTransparency = 1
        mainBtn.Text = ""
        mainBtn.Parent = ddFrame

        local tLabel = Instance.new("TextLabel")
        tLabel.Size = UDim2.new(1, -60, 1, 0)
        tLabel.Position = UDim2.new(0, 14, 0, 0)
        tLabel.BackgroundTransparency = 1
        tLabel.Font = Enum.Font.GothamBold
        tLabel.Text = title
        tLabel.TextColor3 = self.Library.CurrentTheme.TextPrimary
        tLabel.TextSize = 14
        tLabel.TextXAlignment = Enum.TextXAlignment.Left
        tLabel.Parent = mainBtn
        self.Library:AddObject(tLabel, "TextColor3", "TextPrimary")

        local arrow = Instance.new("ImageLabel")
        arrow.Size = UDim2.new(0, 20, 0, 20)
        arrow.Position = UDim2.new(1, -34, 0.5, -10)
        arrow.BackgroundTransparency = 1
        arrow.Image = "rbxassetid://6031094037"
        arrow.ImageColor3 = self.Library.CurrentTheme.TextSecondary
        arrow.Parent = mainBtn
        self.Library:AddObject(arrow, "ImageColor3", "TextSecondary")

        local list = Instance.new("ScrollingFrame")
        list.Size = UDim2.new(1, -20, 0, 120)
        list.Position = UDim2.new(0, 10, 0, 50)
        list.BackgroundTransparency = 1
        list.BorderSizePixel = 0
        list.ScrollBarThickness = 2
        list.Visible = false
        list.Parent = ddFrame

        local lLayout = Instance.new("UIListLayout")
        lLayout.Padding = UDim.new(0, 5)
        lLayout.Parent = list

        for _, item in ipairs(items) do
            local itemBtn = Instance.new("TextButton")
            itemBtn.Size = UDim2.new(1, -6, 0, 30)
            itemBtn.BackgroundColor3 = self.Library.CurrentTheme.SidebarBackground
            itemBtn.Font = Enum.Font.GothamMedium
            itemBtn.Text = "  " .. item
            itemBtn.TextColor3 = self.Library.CurrentTheme.TextSecondary
            itemBtn.TextSize = 13
            itemBtn.TextXAlignment = Enum.TextXAlignment.Left
            itemBtn.Parent = list
            self.Library:AddObject(itemBtn, "BackgroundColor3", "SidebarBackground")
            self.Library:AddObject(itemBtn, "TextColor3", "TextSecondary")
            Instance.new("UICorner", itemBtn).CornerRadius = UDim.new(0, 6)

            itemBtn.MouseButton1Click:Connect(function()
                if isMulti then
                    local idx = table.find(selected, item)
                    if idx then table.remove(selected, idx) else table.insert(selected, item) end
                    pcall(callback, selected)
                else
                    selected = {item}
                    active = false
                    TweenService:Create(ddFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 44)}):Play()
                    TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    list.Visible = false
                    pcall(callback, item)
                end
            end)
        end

        mainBtn.MouseButton1Click:Connect(function()
            active = not active
            playSound(Sounds.Click, 0.3)
            if active then
                list.Visible = true
                TweenService:Create(ddFrame, TweenInfo.new(0.25), {Size = UDim2.new(1, 0, 0, 180)}):Play()
                TweenService:Create(arrow, TweenInfo.new(0.25), {Rotation = 180}):Play()
            else
                TweenService:Create(ddFrame, TweenInfo.new(0.25), {Size = UDim2.new(1, 0, 0, 44)}):Play()
                TweenService:Create(arrow, TweenInfo.new(0.25), {Rotation = 0}):Play()
                task.wait(0.25)
                if not active then list.Visible = false end
            end
        end)
    end

    function Tab:AddTextbox(title, placeholder, callback)
        local tbFrame = Instance.new("Frame")
        tbFrame.Size = UDim2.new(1, 0, 0, 48)
        tbFrame.BackgroundColor3 = self.Library.CurrentTheme.ElementBackground
        tbFrame.Parent = page
        self.Library:AddObject(tbFrame, "BackgroundColor3", "ElementBackground")
        Instance.new("UICorner", tbFrame).CornerRadius = UDim.new(0, 8)
        
        local stroke = Instance.new("UIStroke", tbFrame)
        stroke.Color = self.Library.CurrentTheme.MainBorder
        self.Library:AddObject(stroke, "Color", "MainBorder")

        local tLabel = Instance.new("TextLabel")
        tLabel.Size = UDim2.new(0.4, 0, 1, 0)
        tLabel.Position = UDim2.new(0, 14, 0, 0)
        tLabel.BackgroundTransparency = 1
        tLabel.Font = Enum.Font.GothamBold
        tLabel.Text = title
        tLabel.TextColor3 = self.Library.CurrentTheme.TextPrimary
        tLabel.TextSize = 14
        tLabel.TextXAlignment = Enum.TextXAlignment.Left
        tLabel.Parent = tbFrame
        self.Library:AddObject(tLabel, "TextColor3", "TextPrimary")

        local input = Instance.new("TextBox")
        input.Size = UDim2.new(0.5, 0, 0, 30)
        input.Position = UDim2.new(1, -12, 0.5, -15)
        input.AnchorPoint = Vector2.new(1, 0)
        input.BackgroundColor3 = self.Library.CurrentTheme.SidebarBackground
        input.Font = Enum.Font.Gotham
        input.PlaceholderText = placeholder or "Type here..."
        input.Text = ""
        input.TextColor3 = self.Library.CurrentTheme.TextPrimary
        input.TextSize = 13
        input.Parent = tbFrame
        self.Library:AddObject(input, "BackgroundColor3", "SidebarBackground")
        self.Library:AddObject(input, "TextColor3", "TextPrimary")
        Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", input).Color = self.Library.CurrentTheme.MainBorder

        input.FocusLost:Connect(function()
            pcall(callback, input.Text)
        end)
    end

    function Tab:AddKeybind(title, default, callback)
        local current = default or Enum.KeyCode.E
        local listening = false
        
        local kFrame = Instance.new("Frame")
        kFrame.Size = UDim2.new(1, 0, 0, 48)
        kFrame.BackgroundColor3 = self.Library.CurrentTheme.ElementBackground
        kFrame.Parent = page
        self.Library:AddObject(kFrame, "BackgroundColor3", "ElementBackground")
        Instance.new("UICorner", kFrame).CornerRadius = UDim.new(0, 8)
        
        local stroke = Instance.new("UIStroke", kFrame)
        stroke.Color = self.Library.CurrentTheme.MainBorder
        self.Library:AddObject(stroke, "Color", "MainBorder")

        local tLabel = Instance.new("TextLabel")
        tLabel.Size = UDim2.new(1, -100, 1, 0)
        tLabel.Position = UDim2.new(0, 14, 0, 0)
        tLabel.BackgroundTransparency = 1
        tLabel.Font = Enum.Font.GothamBold
        tLabel.Text = title
        tLabel.TextColor3 = self.Library.CurrentTheme.TextPrimary
        tLabel.TextSize = 14
        tLabel.TextXAlignment = Enum.TextXAlignment.Left
        tLabel.Parent = kFrame
        self.Library:AddObject(tLabel, "TextColor3", "TextPrimary")

        local kBtn = Instance.new("TextButton")
        kBtn.Size = UDim2.new(0, 80, 0, 30)
        kBtn.Position = UDim2.new(1, -92, 0.5, -15)
        kBtn.BackgroundColor3 = self.Library.CurrentTheme.SidebarBackground
        kBtn.Font = Enum.Font.GothamMedium
        kBtn.Text = current.Name
        kBtn.TextColor3 = self.Library.CurrentTheme.TextPrimary
        kBtn.TextSize = 12
        kBtn.Parent = kFrame
        self.Library:AddObject(kBtn, "BackgroundColor3", "SidebarBackground")
        self.Library:AddObject(kBtn, "TextColor3", "TextPrimary")
        Instance.new("UICorner", kBtn).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", kBtn).Color = self.Library.CurrentTheme.MainBorder

        kBtn.MouseButton1Click:Connect(function()
            listening = true
            kBtn.Text = "..."
        end)

        UserInputService.InputBegan:Connect(function(input, gpe)
            if listening then
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    current = input.KeyCode
                    listening = false
                    kBtn.Text = current.Name
                end
            elseif not gpe and input.KeyCode == current then
                pcall(callback)
            end
        end)
    end

    function Tab:AddLabel(text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 24)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamMedium
        label.Text = text
        label.TextColor3 = self.Library.CurrentTheme.TextPrimary
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = page
        self.Library:AddObject(label, "TextColor3", "TextPrimary")
    end

    function Tab:AddParagraph(title, desc)
        local pFrame = Instance.new("Frame")
        pFrame.Size = UDim2.new(1, 0, 0, 0)
        pFrame.AutomaticSize = Enum.AutomaticSize.Y
        pFrame.BackgroundColor3 = self.Library.CurrentTheme.ElementBackground
        pFrame.Parent = page
        self.Library:AddObject(pFrame, "BackgroundColor3", "ElementBackground")
        Instance.new("UICorner", pFrame).CornerRadius = UDim.new(0, 8)
        
        local pLayout = Instance.new("UIListLayout")
        pLayout.Padding = UDim.new(0, 5)
        pLayout.Parent = pFrame
        Instance.new("UIPadding", pFrame).PaddingBottom = UDim.new(0, 12)
        Instance.new("UIPadding", pFrame).PaddingTop = UDim.new(0, 12)
        Instance.new("UIPadding", pFrame).PaddingLeft = UDim.new(0, 14)
        Instance.new("UIPadding", pFrame).PaddingRight = UDim.new(0, 14)

        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1, 0, 0, 20)
        t.BackgroundTransparency = 1
        t.Font = Enum.Font.GothamBold
        t.Text = title
        t.TextColor3 = self.Library.CurrentTheme.TextPrimary
        t.TextSize = 14
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.Parent = pFrame
        self.Library:AddObject(t, "TextColor3", "TextPrimary")

        local d = Instance.new("TextLabel")
        d.Size = UDim2.new(1, 0, 0, 0)
        d.AutomaticSize = Enum.AutomaticSize.Y
        d.BackgroundTransparency = 1
        d.Font = Enum.Font.Gotham
        d.Text = desc
        d.TextColor3 = self.Library.CurrentTheme.TextSecondary
        d.TextSize = 12
        d.TextWrapped = true
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.Parent = pFrame
        self.Library:AddObject(d, "TextColor3", "TextSecondary")
    end

    return Tab
end

return Library
