--[[
    NEXZAN HUB PREMIUM UI EXECUTOR
    Designed for Roblox Mobile (Android/iOS) & PC
    Theme: Modern Premium Dark Glass
    Features: Responsive, Dragable, Automated Game Title, Search System, Multi-component Support, Advanced Smooth Animations
--]]

local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local localPlayer = Players.LocalPlayer
local targetParent = localPlayer:WaitForChild("PlayerGui")

-- Attempt to use CoreGui if possible (for executor independence), fallback to PlayerGui
pcall(function()
    if CoreGui and game:FindFirstChild("CoreGui") then
        targetParent = CoreGui
    end
end)

-- Safe removal of old instance
if targetParent:FindFirstChild("NexzanHubPremium") then
    targetParent:FindFirstChild("NexzanHubPremium"):Destroy()
end

-- Create Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexzanHubPremium"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = targetParent

-- Helper function to make UI elements dragable smoothly
local function makeDragable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle = dragHandle or frame

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

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
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(frame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        end
    end)
end

-- Helper function to add components easily
local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or UDim.new(0, 8)
    corner.Parent = parent
    return corner
end

local function createUIStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(60, 60, 60)
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

-- Get automated map name
local currentMapName = "Unknown Game"
pcall(function()
    currentMapName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

-- Color Palette Configuration
local Colors = {
    MainBg = Color3.fromRGB(22, 22, 22),
    HeaderBg = Color3.fromRGB(20, 20, 20),
    SidebarBg = Color3.fromRGB(27, 27, 27),
    CardBg = Color3.fromRGB(39, 39, 39),
    SearchBg = Color3.fromRGB(44, 44, 44),
    Border = Color3.fromRGB(60, 60, 60),
    TextWhite = Color3.fromRGB(245, 245, 245),
    TextGrey = Color3.fromRGB(170, 170, 170),
    BadgeBlue = Color3.fromRGB(50, 110, 255),
    ToggleOff = Color3.fromRGB(85, 85, 85),
    ToggleOn = Color3.fromRGB(0, 255, 120),
    GlowGreen = Color3.fromRGB(0, 255, 120)
}

----------------------------------------------------
-- WATERMARK IMPLEMENTATION
----------------------------------------------------
local Watermark = Instance.new("Frame")
Watermark.Name = "Watermark"
Watermark.Size = UDim2.new(0, 130, 0, 30)
Watermark.Position = UDim2.new(0, 20, 0, 20)
Watermark.BackgroundColor3 = Colors.MainBg
Watermark.BorderSizePixel = 0
Watermark.Active = true
Watermark.Selectable = true
Watermark.Parent = ScreenGui
createUICorner(Watermark, UDim.new(0, 6))
createUIStroke(Watermark, Colors.Border, 1)

local WatermarkGlow = Instance.new("Frame")
WatermarkGlow.Size = UDim2.new(0, 4, 1, 0)
WatermarkGlow.BackgroundColor3 = Colors.GlowGreen
WatermarkGlow.BorderSizePixel = 0
WatermarkGlow.Parent = Watermark
createUICorner(WatermarkGlow, UDim.new(0, 6))

local WatermarkText = Instance.new("TextLabel")
WatermarkText.Size = UDim2.new(1, -15, 1, 0)
WatermarkText.Position = UDim2.new(0, 12, 0, 0)
WatermarkText.BackgroundTransparency = 1
WatermarkText.Text = "Nexzan Hub"
WatermarkText.TextColor3 = Colors.TextWhite
WatermarkText.TextSize = 13
WatermarkText.Font = Enum.Font.GothamBold
WatermarkText.TextXAlignment = Enum.TextXAlignment.Left
WatermarkText.Parent = Watermark

makeDragable(Watermark)


----------------------------------------------------
-- MAIN WINDOW IMPLEMENTATION
----------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 360)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -180)
MainFrame.BackgroundColor3 = Colors.MainBg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = false
MainFrame.Parent = ScreenGui
createUICorner(MainFrame, UDim.new(0, 12))
createUIStroke(MainFrame, Colors.Border, 1.2)

-- Drop Shadow Emulation using ImageLabel
local MainShadow = Instance.new("ImageLabel")
MainShadow.Name = "Shadow"
MainShadow.AnchorPoint = Vector2.new(0.5, 0.5)
MainShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
MainShadow.Size = UDim2.new(1, 40, 1, 40)
MainShadow.BackgroundTransparency = 1
MainShadow.Image = "rbxassetid://6014262001"
MainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
MainShadow.ImageTransparency = 0.4
MainShadow.ZIndex = 0
MainShadow.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = Colors.HeaderBg
Header.BorderSizePixel = 0
Header.Parent = MainFrame
createUICorner(Header, UDim.new(0, 12))

-- Clean bottom corners of header to blend into content layout
local HeaderBottomFill = Instance.new("Frame")
HeaderBottomFill.Size = UDim2.new(1, 0, 0, 10)
HeaderBottomFill.Position = UDim2.new(0, 0, 1, -10)
HeaderBottomFill.BackgroundColor3 = Colors.HeaderBg
HeaderBottomFill.BorderSizePixel = 0
HeaderBottomFill.ZIndex = 1
HeaderBottomFill.Parent = Header

-- Logo Circle
local LogoContainer = Instance.new("Frame")
LogoContainer.Size = UDim2.new(0, 36, 0, 36)
LogoContainer.Position = UDim2.new(0, 12, 0, 9)
LogoContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LogoContainer.ZIndex = 2
LogoContainer.Parent = Header
createUICorner(LogoContainer, UDim.new(1, 0))
createUIStroke(LogoContainer, Colors.GlowGreen, 1.5)

local LogoImage = Instance.new("ImageLabel")
LogoImage.Size = UDim2.new(1, 0, 1, 0)
LogoImage.BackgroundTransparency = 1
LogoImage.Image = "rbxassetid://94703576073885"
LogoImage.ZIndex = 2
LogoImage.Parent = LogoContainer
createUICorner(LogoImage, UDim.new(1, 0))

-- Map Title & Subtitle Container
local TitleContainer = Instance.new("Frame")
TitleContainer.Size = UDim2.new(0, 220, 1, 0)
TitleContainer.Position = UDim2.new(0, 56, 0, 0)
TitleContainer.BackgroundTransparency = 1
TitleContainer.ZIndex = 2
TitleContainer.Parent = Header

local MapTitleLabel = Instance.new("TextLabel")
MapTitleLabel.Size = UDim2.new(1, 0, 0, 22)
MapTitleLabel.Position = UDim2.new(0, 0, 0, 10)
MapTitleLabel.BackgroundTransparency = 1
MapTitleLabel.Text = currentMapName
MapTitleLabel.TextColor3 = Colors.TextWhite
MapTitleLabel.TextSize = 14
MapTitleLabel.Font = Enum.Font.GothamBold
MapTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
MapTitleLabel.ClipsDescendants = true
MapTitleLabel.ZIndex = 2
MapTitleLabel.Parent = TitleContainer

local CreatorLabel = Instance.new("TextLabel")
CreatorLabel.Size = UDim2.new(1, 0, 0, 14)
CreatorLabel.Position = UDim2.new(0, 0, 0, 28)
CreatorLabel.BackgroundTransparency = 1
CreatorLabel.Text = "Made Nexzan"
CreatorLabel.TextColor3 = Colors.TextGrey
CreatorLabel.TextSize = 11
CreatorLabel.Font = Enum.Font.Gotham
CreatorLabel.TextXAlignment = Enum.TextXAlignment.Left
CreatorLabel.ZIndex = 2
CreatorLabel.Parent = TitleContainer

-- New Version Capsule Badge
local VersionBadge = Instance.new("Frame")
VersionBadge.Size = UDim2.new(0, 120, 0, 24)
VersionBadge.Position = UDim2.new(0, 280, 0, 15)
VersionBadge.BackgroundColor3 = Colors.BadgeBlue
VersionBadge.BorderSizePixel = 0
VersionBadge.ZIndex = 2
VersionBadge.Parent = Header
createUICorner(VersionBadge, UDim.new(1, 0))

local VersionText = Instance.new("TextLabel")
VersionText.Size = UDim2.new(1, 0, 1, 0)
VersionText.BackgroundTransparency = 1
VersionText.Text = "New Version | 2.0.0"
VersionText.TextColor3 = Colors.TextWhite
VersionText.TextSize = 11
VersionText.Font = Enum.Font.GothamBold
VersionText.ZIndex = 2
VersionText.Parent = VersionBadge

-- Window Controls (Minimize, Fullscreen Dummy, Close)
local ControlsContainer = Instance.new("Frame")
ControlsContainer.Size = UDim2.new(0, 100, 1, 0)
ControlsContainer.Position = UDim2.new(1, -110, 0, 0)
ControlsContainer.BackgroundTransparency = 1
ControlsContainer.ZIndex = 2
ControlsContainer.Parent = Header

local UIListLayoutControls = Instance.new("UIListLayout")
UIListLayoutControls.FillDirection = Enum.FillDirection.Horizontal
UIListLayoutControls.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIListLayoutControls.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayoutControls.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutControls.Padding = UDim.new(0, 10)
UIListLayoutControls.Parent = ControlsContainer

local function createHeaderButton(text, layoutOrder, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 24, 0, 24)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = color or Colors.TextGrey
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.LayoutOrder = layoutOrder
    btn.ZIndex = 2
    btn.Parent = ControlsContainer
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Colors.TextWhite}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = color or Colors.TextGrey}):Play()
    end)
    return btn
end

local MinBtn = createHeaderButton("-", 1)
local FullBtn = createHeaderButton("□", 2)
local CloseBtn = createHeaderButton("×", 3, Color3.fromRGB(240, 80, 80))

makeDragable(MainFrame, Header)

----------------------------------------------------
-- SIDEBAR IMPLEMENTATION
----------------------------------------------------
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 180, 1, -55)
Sidebar.Position = UDim2.new(0, 0, 0, 55)
Sidebar.BackgroundColor3 = Colors.SidebarBg
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
createUICorner(Sidebar, UDim.new(0, 12))

-- Clean layout alignment
local SidebarTopFill = Instance.new("Frame")
SidebarTopFill.Size = UDim2.new(1, 0, 0, 10)
SidebarTopFill.Position = UDim2.new(0, 0, 0, 0)
SidebarTopFill.BackgroundColor3 = Colors.SidebarBg
SidebarTopFill.BorderSizePixel = 0
SidebarTopFill.Parent = Sidebar

local SidebarRightFill = Instance.new("Frame")
SidebarRightFill.Size = UDim2.new(0, 10, 1, 0)
SidebarRightFill.Position = UDim2.new(1, -10, 0, 0)
SidebarRightFill.BackgroundColor3 = Colors.SidebarBg
SidebarRightFill.BorderSizePixel = 0
SidebarRightFill.Parent = Sidebar

-- Search Box
local SearchContainer = Instance.new("Frame")
SearchContainer.Size = UDim2.new(1, -20, 0, 32)
SearchContainer.Position = UDim2.new(0, 10, 0, 12)
SearchContainer.BackgroundColor3 = Colors.SearchBg
SearchContainer.BorderSizePixel = 0
SearchContainer.Parent = Sidebar
createUICorner(SearchContainer, UDim.new(0, 6))
createUIStroke(SearchContainer, Colors.Border, 1)

local SearchIcon = Instance.new("TextLabel")
SearchIcon.Size = UDim2.new(0, 24, 1, 0)
SearchIcon.Position = UDim2.new(0, 6, 0, 0)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Text = "🔍"
SearchIcon.TextSize = 12
SearchIcon.TextColor3 = Colors.TextGrey
SearchIcon.Parent = SearchContainer

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -34, 1, 0)
SearchBox.Position = UDim2.new(0, 30, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Text = ""
SearchBox.PlaceholderText = "Search features..."
SearchBox.PlaceholderColor3 = Colors.TextGrey
SearchBox.TextColor3 = Colors.TextWhite
SearchBox.TextSize = 12
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.Parent = SearchContainer

-- Sidebar Tab ScrollingFrame
local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Size = UDim2.new(1, 0, 1, -56)
TabScroll.Position = UDim2.new(0, 0, 0, 50)
TabScroll.BackgroundTransparency = 1
TabScroll.BorderSizePixel = 0
TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TabScroll.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
TabScroll.ScrollBarThickness = 2
TabScroll.ScrollBarImageColor3 = Colors.Border
TabScroll.Parent = Sidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 4)
TabListLayout.Parent = TabScroll

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingLeft = UDim.new(0, 10)
TabPadding.PaddingRight = UDim.new(0, 10)
TabPadding.Parent = TabScroll

----------------------------------------------------
-- FEATURE CONTAINER AREA
----------------------------------------------------
local FeatureArea = Instance.new("Frame")
FeatureArea.Name = "FeatureArea"
FeatureArea.Size = UDim2.new(1, -180, 1, -55)
FeatureArea.Position = UDim2.new(0, 180, 0, 55)
FeatureArea.BackgroundTransparency = 1
FeatureArea.Parent = MainFrame

local TabsData = {}
local ActiveTabButton = nil

local function createTabContentFrame(tabName)
    local PageScroll = Instance.new("ScrollingFrame")
    PageScroll.Name = tabName .. "_Page"
    PageScroll.Size = UDim2.new(1, 0, 1, 0)
    PageScroll.BackgroundTransparency = 1
    PageScroll.BorderSizePixel = 0
    PageScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    PageScroll.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    PageScroll.ScrollBarThickness = 4
    PageScroll.ScrollBarImageColor3 = Colors.Border
    PageScroll.Visible = false
    PageScroll.Parent = FeatureArea

    local PageListLayout = Instance.new("UIListLayout")
    PageListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageListLayout.Padding = UDim.new(0, 8)
    PageListLayout.Parent = PageScroll

    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingTop = UDim.new(0, 12)
    PagePadding.PaddingBottom = UDim.new(0, 12)
    PagePadding.PaddingLeft = UDim.new(0, 12)
    PagePadding.PaddingRight = UDim.new(0, 12)
    PagePadding.Parent = PageScroll

    return PageScroll
end

local function switchTab(tabButton, pageFrame)
    if ActiveTabButton then
        TweenService:Create(ActiveTabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35), TextColor3 = Colors.TextGrey}):Play()
        TabsData[ActiveTabButton.Name].Visible = false
    end
    ActiveTabButton = tabButton
    TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Colors.CardBg, TextColor3 = Colors.TextWhite}):Play()
    pageFrame.Visible = true
end

local function addTab(name)
    local page = createTabContentFrame(name)
    
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = name
    TabBtn.Size = UDim2.new(1, 0, 0, 36)
    TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = "  " .. name
    TabBtn.TextColor3 = Colors.TextGrey
    TabBtn.TextSize = 12
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.Parent = TabScroll
    createUICorner(TabBtn, UDim.new(0, 6))
    createUIStroke(TabBtn, Color3.fromRGB(45, 45, 45), 1)

    TabsData[name] = page

    TabBtn.MouseButton1Click:Connect(function()
        switchTab(TabBtn, page)
    end)

    if ActiveTabButton == nil then
        switchTab(TabBtn, page)
    end
    
    return page
end

----------------------------------------------------
-- INTERACTIVE SCRIPT COMPONENTS GENERATION
----------------------------------------------------
local function createBaseCard(parent, title, desc, height)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, height or 60)
    Card.BackgroundColor3 = Colors.CardBg
    Card.BorderSizePixel = 0
    Card.Parent = parent
    createUICorner(Card, UDim.new(0, 8))
    createUIStroke(Card, Colors.Border, 1)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0.6, 0, 0, 20)
    TitleLabel.Position = UDim2.new(0, 12, 0, 8)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Colors.TextWhite
    TitleLabel.TextSize = 13
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Card

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(0.6, 0, 0, 16)
    DescLabel.Position = UDim2.new(0, 12, 0, 26)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = desc or "Fitur bawaan script"
    DescLabel.TextColor3 = Colors.TextGrey
    DescLabel.TextSize = 10
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Parent = Card

    return Card
end

local function addButton(parent, title, desc, callback)
    local Card = createBaseCard(parent, title, desc, 55)
    
    local ActionBtn = Instance.new("TextButton")
    ActionBtn.Size = UDim2.new(0, 100, 0, 28)
    ActionBtn.Position = UDim2.new(1, -112, 0.5, -14)
    ActionBtn.BackgroundColor3 = Colors.SearchBg
    ActionBtn.Text = "Execute"
    ActionBtn.TextColor3 = Colors.TextWhite
    ActionBtn.TextSize = 11
    ActionBtn.Font = Enum.Font.GothamBold
    ActionBtn.Parent = Card
    createUICorner(ActionBtn, UDim.new(0, 6))
    createUIStroke(ActionBtn, Colors.Border, 1)

    ActionBtn.MouseButton1Click:Connect(function()
        ActionBtn.Text = "Clicked!"
        task.wait(0.2)
        ActionBtn.Text = "Execute"
        callback()
    end)
end

local function addToggle(parent, title, desc, default, callback)
    local Card = createBaseCard(parent, title, desc, 55)
    local state = default or false

    local ToggleFrame = Instance.new("TextButton")
    ToggleFrame.Size = UDim2.new(0, 42, 0, 22)
    ToggleFrame.Position = UDim2.new(1, -54, 0.5, -11)
    ToggleFrame.BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff
    ToggleFrame.Text = ""
    ToggleFrame.Parent = Card
    createUICorner(ToggleFrame, UDim.new(1, 0))

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 16, 0, 16)
    Dot.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    Dot.BackgroundColor3 = Colors.TextWhite
    Dot.BorderSizePixel = 0
    Dot.Parent = ToggleFrame
    createUICorner(Dot, UDim.new(1, 0))

    ToggleFrame.MouseButton1Click:Connect(function()
        state = not state
        local targetColor = state and Colors.ToggleOn or Colors.ToggleOff
        local targetPos = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        
        TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(Dot, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = targetPos}):Play()
        
        callback(state)
    end)
end

local function addTextBox(parent, title, desc, placeholder, callback)
    local Card = createBaseCard(parent, title, desc, 60)

    local TBox = Instance.new("TextBox")
    TBox.Size = UDim2.new(0, 120, 0, 28)
    TBox.Position = UDim2.new(1, -132, 0.5, -14)
    TBox.BackgroundColor3 = Colors.SearchBg
    TBox.Text = ""
    TBox.PlaceholderText = placeholder
    TBox.PlaceholderColor3 = Colors.TextGrey
    TBox.TextColor3 = Colors.TextWhite
    TBox.TextSize = 11
    TBox.Font = Enum.Font.Gotham
    TBox.Parent = Card
    createUICorner(TBox, UDim.new(0, 6))
    createUIStroke(TBox, Colors.Border, 1)

    TBox.FocusLost:Connect(function(enterPressed)
        callback(TBox.Text, enterPressed)
    end)
end

local function addSlider(parent, title, desc, min, max, default, callback)
    local Card = createBaseCard(parent, title, desc, 75)

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 40, 0, 20)
    ValueLabel.Position = UDim2.new(1, -52, 0, 8)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Colors.GlowGreen
    ValueLabel.TextSize = 12
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Card

    local SliderBg = Instance.new("TextButton")
    SliderBg.Size = UDim2.new(1, -24, 0, 6)
    SliderBg.Position = UDim2.new(0, 12, 0, 52)
    SliderBg.BackgroundColor3 = Colors.ToggleOff
    SliderBg.Text = ""
    SliderBg.Parent = Card
    createUICorner(SliderBg, UDim.new(1, 0))

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Colors.GlowGreen
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBg
    createUICorner(SliderFill, UDim.new(1, 0))

    local function updateSlider(input)
        local percentage = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        local value = math.round(min + (max - min) * percentage)
        ValueLabel.Text = tostring(value)
        callback(value)
    end

    local sliding = false
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
end

local function addDropdown(parent, title, desc, list, callback)
    local Card = createBaseCard(parent, title, desc, 60)
    local isOpen = false

    local DropBtn = Instance.new("TextButton")
    DropBtn.Size = UDim2.new(0, 130, 0, 28)
    DropBtn.Position = UDim2.new(1, -142, 0.5, -14)
    DropBtn.BackgroundColor3 = Colors.SearchBg
    DropBtn.Text = "Select Item  ▼"
    DropBtn.TextColor3 = Colors.TextWhite
    DropBtn.TextSize = 11
    DropBtn.Font = Enum.Font.GothamBold
    DropBtn.Parent = Card
    createUICorner(DropBtn, UDim.new(0, 6))
    createUIStroke(DropBtn, Colors.Border, 1)

    local DropContainer = Instance.new("Frame")
    DropContainer.Size = UDim2.new(1, 0, 0, 0)
    DropContainer.Position = UDim2.new(0, 0, 1, 4)
    DropContainer.BackgroundColor3 = Colors.MainBg
    DropContainer.ClipsDescendants = true
    DropContainer.ZIndex = 5
    DropContainer.Parent = DropBtn
    createUICorner(DropContainer, UDim.new(0, 6))
    createUIStroke(DropContainer, Colors.Border, 1)

    local DropList = Instance.new("UIListLayout")
    DropList.SortOrder = Enum.SortOrder.LayoutOrder
    DropList.Parent = DropContainer

    for _, v in ipairs(list) do
        local ItemBtn = Instance.new("TextButton")
        ItemBtn.Size = UDim2.new(1, 0, 0, 26)
        ItemBtn.BackgroundTransparency = 1
        ItemBtn.Text = tostring(v)
        ItemBtn.TextColor3 = Colors.TextGrey
        ItemBtn.TextSize = 11
        ItemBtn.Font = Enum.Font.Gotham
        ItemBtn.ZIndex = 6
        ItemBtn.Parent = DropContainer
        
        ItemBtn.MouseButton1Click:Connect(function()
            DropBtn.Text = tostring(v) .. "  ▼"
            isOpen = false
            TweenService:Create(DropContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            callback(v)
        end)
    end

    DropBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        local targetHeight = isOpen and (#list * 26) or 0
        TweenService:Create(DropContainer, TweenInfo.new(0.25), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
    end)
end

local function addCopyableButton(parent, title, desc, copyText)
    local Card = createBaseCard(parent, title, desc, 55)

    local CopyBtn = Instance.new("TextButton")
    CopyBtn.Size = UDim2.new(0, 100, 0, 28)
    CopyBtn.Position = UDim2.new(1, -112, 0.5, -14)
    CopyBtn.BackgroundColor3 = Colors.SearchBg
    CopyBtn.Text = "Copy Script"
    CopyBtn.TextColor3 = Colors.TextWhite
    CopyBtn.TextSize = 11
    CopyBtn.Font = Enum.Font.GothamBold
    CopyBtn.Parent = Card
    createUICorner(CopyBtn, UDim.new(0, 6))
    createUIStroke(CopyBtn, Colors.Border, 1)

    CopyBtn.MouseButton1Click:Connect(function()
        setclipboard(copyText)
        CopyBtn.Text = "Copied!"
        task.wait(1)
        CopyBtn.Text = "Copy Script"
    end)
end

local function addImageContainer(parent, title, desc, assetId)
    local Card = createBaseCard(parent, title, desc, 110)

    local ImgLabel = Instance.new("ImageLabel")
    ImgLabel.Size = UDim2.new(0, 100, 0, 50)
    ImgLabel.Position = UDim2.new(1, -112, 0, 48)
    ImgLabel.BackgroundColor3 = Colors.SearchBg
    ImgLabel.Image = "rbxassetid://" .. tostring(assetId)
    ImgLabel.Parent = Card
    createUICorner(ImgLabel, UDim.new(0, 6))
    createUIStroke(ImgLabel, Colors.Border, 1)
end

local function addTextLabel(parent, text, isItalic)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 24)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Colors.TextWhite
    Label.TextSize = 12
    Label.Font = isItalic and Enum.Font.GothamItalic or Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = parent
end

----------------------------------------------------
-- SEARCH ALGORITHM SYSTEM
----------------------------------------------------
SearchBox.GetPropertiesChangedSignal("Text"):Connect(function()
    local query = SearchBox.Text:lower()
    for _, page in pairs(TabsData) do
        for _, card in ipairs(page:GetChildren()) do
            if card:IsA("Frame") then
                local titleLabel = card:FindFirstChildOfClass("TextLabel")
                if titleLabel then
                    local match = titleLabel.Text:lower():find(query)
                    card.Visible = (query == "" or match ~= nil)
                end
            end
        end
    end
end)

----------------------------------------------------
-- FLOATING MINI WINDOW (MINIMIZE WINDOW)
----------------------------------------------------
local FloatingWindow = Instance.new("Frame")
FloatingWindow.Name = "FloatingWindow"
FloatingWindow.Size = UDim2.new(0, 130, 0, 36)
FloatingWindow.Position = UDim2.new(0.5, -65, 0.1, 0)
FloatingWindow.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
FloatingWindow.BackgroundTransparency = 0.2
FloatingWindow.BorderSizePixel = 0
FloatingWindow.Visible = false
FloatingWindow.Active = true
FloatingWindow.Parent = ScreenGui
createUICorner(FloatingWindow, UDim.new(0, 8))
createUIStroke(FloatingWindow, Colors.GlowGreen, 1.2)

-- Inner content for Mini Window
local MiniDrag = Instance.new("TextLabel")
MiniDrag.Size = UDim2.new(0, 24, 1, 0)
MiniDrag.Position = UDim2.new(0, 6, 0, 0)
MiniDrag.BackgroundTransparency = 1
MiniDrag.Text = "☰"
MiniDrag.TextColor3 = Colors.TextGrey
MiniDrag.TextSize = 14
MiniDrag.Parent = FloatingWindow

local MiniIcon = Instance.new("TextLabel")
MiniIcon.Size = UDim2.new(0, 20, 1, 0)
MiniIcon.Position = UDim2.new(0, 26, 0, 0)
MiniIcon.BackgroundTransparency = 1
MiniIcon.Text = "🌙"
MiniIcon.TextSize = 12
MiniIcon.Parent = FloatingWindow

local MiniTitle = Instance.new("TextButton")
MiniTitle.Size = UDim2.new(1, -50, 1, 0)
MiniTitle.Position = UDim2.new(0, 46, 0, 0)
MiniTitle.BackgroundTransparency = 1
MiniTitle.Text = "Nexzan Hub"
MiniTitle.TextColor3 = Colors.TextWhite
MiniTitle.TextSize = 12
MiniTitle.Font = Enum.Font.GothamBold
MiniTitle.TextXAlignment = Enum.TextXAlignment.Left
MiniTitle.Parent = FloatingWindow

makeDragable(FloatingWindow, FloatingWindow)

----------------------------------------------------
-- MINIMIZE / CLOSE HOOKS
----------------------------------------------------
MinBtn.MouseButton1Click:Connect(function()
    MainFrame.ClipsDescendants = true
    local shrinkTween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 580, 0, 0),
        Position = MainFrame.Position + UDim2.new(0, 0, 0, 180),
        BackgroundTransparency = 1
    })
    shrinkTween:Play()
    shrinkTween.Completed:Connect(function()
        MainFrame.Visible = false
        FloatingWindow.Visible = true
        MainFrame.ClipsDescendants = false
    end)
end)

MiniTitle.MouseButton1Click:Connect(function()
    FloatingWindow.Visible = false
    MainFrame.Visible = true
    MainFrame.ClipsDescendants = true
    
    local targetPos = MainFrame.Position - UDim2.new(0, 0, 0, 180)
    MainFrame.Size = UDim2.new(0, 580, 0, 0)
    
    local growTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 580, 0, 360),
        BackgroundTransparency = 0
    })
    growTween:Play()
    growTween.Completed:Connect(function()
        MainFrame.ClipsDescendants = false
    end)
end)

CloseBtn.MouseButton1Click:Connect(function()
    local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        ScreenGui:Destroy()
    end)
end)

----------------------------------------------------
-- POPULATING TABS & DEMO SCRIPT FITUR
----------------------------------------------------
local MainFeaturesPage = addTab("Main Features")
local MiscPage = addTab("Misc Options")
local SupportPage = addTab("Support")

-- Tab: Main Features Content
addTextLabel(MainFeaturesPage, "— Karakter Pemain —")
addSlider(MainFeaturesPage, "Movement Speed", "Atur kecepatan berjalan karakter (Default 16)", 16, 250, 70, function(value)
    pcall(function() localPlayer.Character.Humanoid.WalkSpeed = value end)
end)

addToggle(MainFeaturesPage, "Enable Fly Mode", "Terbang bebas melintasi map [WASD + Space]", false, function(state)
    print("Fly mode status:", state)
end)

addTextLabel(MainFeaturesPage, "— Otomatisasi Game —")
addButton(MainFeaturesPage, "Auto Farm Lemons", "Otomatis mengumpulkan lemon terdekat di map", function()
    print("Auto Farm Activated")
end)

addDropdown(MainFeaturesPage, "Select Teleport Zone", "Pilih lokasi teleportasi instan", {"Spawn Point", "Lemon Stand", "Sugar Mixer", "VIP Lounge"}, function(selected)
    print("Teleporting to: " .. selected)
end)

-- Tab: Misc Content
addTextLabel(MiscPage, "— Pengaturan Kustom Perangkat —")
addTextBox(MiscPage, "Custom Fly Speed", "Masukkan angka speed terbang khusus", "Masukkan angka...", function(text)
    print("Fly speed custom set to: " .. text)
end)

addCopyableButton(MiscPage, "Infinite Yield Loader", "Klik untuk menyalin script admin serbaguna", "loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()")

addImageContainer(MiscPage, "Logo Banner Preview", "Menampilkan aset gambar referensi internal", 94703576073885)

-- Tab: Support Content
addTextLabel(SupportPage, "— Informasi Pembuat —", false)
addTextLabel(SupportPage, "Script ini dirancang khusus dengan optimasi mobile.", true)
addButton(SupportPage, "Join Community Discord", "Dapatkan pembaruan script terbaru", function()
    setclipboard("https://discord.gg/nexzanhub")
end)
