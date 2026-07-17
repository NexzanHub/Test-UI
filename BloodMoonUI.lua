--[[
    ============================================================================
    🌙 BloodMoon UI Library - Standalone Single-File Bundle
    Version : 2.0.0
    Developer : Nexzan Hub
    ============================================================================
    TUJUAN:
    UI ini dibuat untuk Script Hub Roblox.
    Support: Delta, Fluxus, Codex, Arceus X, Vega X, Hydrogen, Solara, Swift, KRNL, PC & Mobile.
    
    Fitur Utama:
    - 31 UI Components Lengkap (Toggle, Button, Slider, Dropdown, MultiDropdown, ColorPicker, Keybind,
      Label, Paragraph, Notification, Dialog, ProgressBar, Watermark, Status, Divider, Image, Input,
      Console, CodeBlock, Terminal, Badge, Chip, Switch, Loading, MiniButton, Footer).
    - Real-Time Global Search across all tabs and elements.
    - 70x70 Draggable Round BloodMoon Icon for minimize/restore.
    - Responsive Auto-Scale & Safe Area for Mobile (Landscape & Portrait).
    - JSON Config Manager & Live Theme Editor.
    - Zero Memory Leak (Clean Connection Tracker).
    ============================================================================
]]

local BloodMoonLibrary = {}
BloodMoonLibrary.Version = "2.0.0"
BloodMoonLibrary.Developer = "Nexzan Hub"
BloodMoonLibrary.Name = "🌙 BloodMoon UI Library"

-- Internal Modules Scope
local Modules = {}


-- ============================================================================
-- MODULE: Config
-- ============================================================================
do

local Config = {}

-- Default Color Palette (As specified by specifications)
Config.DefaultColors = {
    Background = Color3.fromRGB(9, 9, 9),       -- #090909
    Secondary = Color3.fromRGB(18, 18, 18),     -- #121212
    Card = Color3.fromRGB(23, 23, 23),          -- #171717
    Border = Color3.fromRGB(42, 42, 42),        -- #2A2A2A
    PrimaryRed = Color3.fromRGB(215, 38, 56),   -- #D72638 (Merah Utama)
    HoverRed = Color3.fromRGB(255, 60, 77),     -- #FF3C4D (Merah Hover)
    NeonRed = Color3.fromRGB(255, 48, 64),      -- #FF3040 (Merah Neon)
    TextWhite = Color3.fromRGB(255, 255, 255),  -- #FFFFFF (Text Putih)
    TextGray = Color3.fromRGB(200, 200, 200),   -- #C8C8C8 (Text Abu)
    Placeholder = Color3.fromRGB(136, 136, 136),-- #888888 (Placeholder)
    Success = Color3.fromRGB(61, 255, 122),     -- #3DFF7A (Success)
    Warning = Color3.fromRGB(255, 213, 61),     -- #FFD53D (Warning)
    Error = Color3.fromRGB(255, 69, 69),        -- #FF4545 (Error)
    Shadow = Color3.fromRGB(0, 0, 0),           -- Hitam Transparan
    ShadowTransparency = 0.5,
    BackgroundOpacity = 0.2                     -- 20% opacity for Blood Moon background
}

-- Current active colors (Copy of default colors initially)
Config.Colors = {}
for key, value in pairs(Config.DefaultColors) do
    Config.Colors[key] = value
end

-- Font configurations
Config.Fonts = {
    Regular = Enum.Font.Gotham,
    Semibold = Enum.Font.GothamSemibold,
    Bold = Enum.Font.GothamBold,
    Monospace = Enum.Font.Code
}

-- Image & Asset IDs
Config.Assets = {
    Logo = "rbxassetid://94703576073885",
    Background = "rbxassetid://0", -- Can be set to a BloodMoon anime ID or left 0 for fallback gradient
    MoonIcon = "rbxassetid://6031154871",
    SearchIcon = "rbxassetid://6031154871",
    Home = "rbxassetid://6031260782",
    Player = "rbxassetid://6031280882",
    Visual = "rbxassetid://6031094678",
    Combat = "rbxassetid://6031265976",
    Teleport = "rbxassetid://6031225819",
    Settings = "rbxassetid://6031289461",
    Info = "rbxassetid://6031079154",
    Search = "rbxassetid://6031154871",
    Close = "rbxassetid://6031090990",
    Minimize = "rbxassetid://6031094677",
    Maximize = "rbxassetid://6031094678",
    Dropdown = "rbxassetid://6031091004",
    Arrow = "rbxassetid://6034818372",
    Check = "rbxassetid://6031094667",
    Warning = "rbxassetid://6031075938",
    Success = "rbxassetid://6031068425",
    Error = "rbxassetid://6031075938"
}

-- Settings & Flags
Config.Settings = {
    WindowSize = UDim2.new(0, 900, 0, 560),
    MinWindowSize = Vector2.new(580, 360),
    SidebarWidth = 220,
    HeaderHeight = 52,
    CornerRadius = UDim.new(0, 10),
    SmallCornerRadius = UDim.new(0, 6),
    RoundCornerRadius = UDim.new(1, 0),
    AnimationSpeed = 0.25,
    FastAnimationSpeed = 0.15,
    AutoSave = true,
    SaveInterval = 5,
    ConfigFolder = "BloodMoonHub",
    ConfigFile = "config.json"
}

-- Theme Update Listeners
Config.Listeners = {}

function Config:OnThemeChange(callback)
    table.insert(self.Listeners, callback)
end

function Config:SetColor(key, color3Value)
    if self.Colors[key] then
        self.Colors[key] = color3Value
        for _, listener in ipairs(self.Listeners) do
            task.spawn(listener, key, color3Value)
        end
    end
end

function Config:ResetColors()
    for key, value in pairs(self.DefaultColors) do
        self.Colors[key] = value
        for _, listener in ipairs(self.Listeners) do
            task.spawn(listener, key, value)
        end
    end
end

function Config:GetColorHex(key)
    local c = self.Colors[key] or Color3.new(1, 1, 1)
    return string.format("#%02X%02X%02X", math.floor(c.R * 255), math.floor(c.G * 255), math.floor(c.B * 255))
end

Modules.Config = Config
end

-- ============================================================================
-- MODULE: Icons
-- ============================================================================
do

local Config = Modules.Config

local Icons = {}

Icons.Map = {
    ["logo"] = Config.Assets.Logo,
    ["moon"] = Config.Assets.MoonIcon,
    ["search"] = Config.Assets.SearchIcon,
    ["home"] = Config.Assets.Home,
    ["main"] = Config.Assets.Home,
    ["player"] = Config.Assets.Player,
    ["visual"] = Config.Assets.Visual,
    ["visuals"] = Config.Assets.Visual,
    ["esp"] = Config.Assets.Visual,
    ["combat"] = Config.Assets.Combat,
    ["pvp"] = Config.Assets.Combat,
    ["aimbot"] = Config.Assets.Combat,
    ["teleport"] = Config.Assets.Teleport,
    ["tp"] = Config.Assets.Teleport,
    ["misc"] = Config.Assets.Info,
    ["server"] = Config.Assets.Info,
    ["settings"] = Config.Assets.Settings,
    ["config"] = Config.Assets.Settings,
    ["scripthub"] = Config.Assets.MoonIcon,
    ["webhook"] = Config.Assets.Info,
    ["executor"] = Config.Assets.MoonIcon,
    ["credits"] = Config.Assets.Info,
    ["info"] = Config.Assets.Info,
    ["close"] = Config.Assets.Close,
    ["minimize"] = Config.Assets.Minimize,
    ["maximize"] = Config.Assets.Maximize,
    ["dropdown"] = Config.Assets.Dropdown,
    ["arrow"] = Config.Assets.Arrow,
    ["check"] = Config.Assets.Check,
    ["warning"] = Config.Assets.Warning,
    ["success"] = Config.Assets.Success,
    ["error"] = Config.Assets.Error
}

function Icons.Get(iconNameOrId)
    if not iconNameOrId or iconNameOrId == "" then
        return Config.Assets.MoonIcon
    end
    
    -- If already an rbxassetid string or http url
    if string.find(tostring(iconNameOrId), "rbxassetid://") or string.find(tostring(iconNameOrId), "http") then
        return tostring(iconNameOrId)
    end
    
    -- If pure numbers, format as rbxassetid
    if tonumber(iconNameOrId) then
        return "rbxassetid://" .. tostring(iconNameOrId)
    end
    
    -- Check map with lowercase
    local lower = string.lower(tostring(iconNameOrId))
    if Icons.Map[lower] then
        return Icons.Map[lower]
    end
    
    return Config.Assets.MoonIcon
end

Modules.Icons = Icons
end

-- ============================================================================
-- MODULE: Utilities
-- ============================================================================
do

local Utilities = {}

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--------------------------------------------------------------------------------
-- MULTI-EXECUTOR COMPATIBILITY LAYER
--------------------------------------------------------------------------------

Utilities.Env = (getgenv and getgenv()) or _G or shared or {}

-- Get optimal GUI target container across all executors
function Utilities.GetTargetGui()
    if gethui then
        local success, target = pcall(gethui)
        if success and target then return target end
    end
    if CoreGui and pcall(function() return CoreGui.Name end) then
        return CoreGui
    end
    if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
        return LocalPlayer.PlayerGui
    end
    return game:GetService("StarterGui")
end

-- Filesystem compatibility functions
function Utilities.WriteFile(path, content)
    if writefile then
        local success, err = pcall(writefile, path, content)
        return success, err
    end
    return false, "writefile not supported"
end

function Utilities.ReadFile(path)
    if readfile and (not isfile or isfile(path)) then
        local success, content = pcall(readfile, path)
        if success then return content end
    end
    return nil
end

function Utilities.IsFile(path)
    if isfile then
        local success, res = pcall(isfile, path)
        return success and res
    end
    if readfile then
        local success = pcall(readfile, path)
        return success
    end
    return false
end

function Utilities.MakeFolder(path)
    if makefolder then
        local success, err = pcall(makefolder, path)
        return success, err
    end
    return false, "makefolder not supported"
end

function Utilities.SetClipboard(text)
    if setclipboard then
        pcall(setclipboard, tostring(text))
    elseif toclipboard then
        pcall(toclipboard, tostring(text))
    end
end

function Utilities.GetExecutorName()
    if identifyexecutor then
        local success, name = pcall(identifyexecutor)
        if success and name then return name end
    end
    if getexecutorname then
        local success, name = pcall(getexecutorname)
        if success and name then return name end
    end
    return "Roblox Executor"
end

--------------------------------------------------------------------------------
-- CONNECTION MANAGER (ZERO MEMORY LEAK)
--------------------------------------------------------------------------------

local ConnectionManager = {}
ConnectionManager.__index = ConnectionManager

function Utilities.CreateConnectionManager()
    local self = setmetatable({
        _connections = {}
    }, ConnectionManager)
    return self
end

function ConnectionManager:Add(connection)
    if connection and typeof(connection) == "RBXScriptConnection" then
        table.insert(self._connections, connection)
    end
    return connection
end

function ConnectionManager:DisconnectAll()
    for _, conn in ipairs(self._connections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    self._connections = {}
end

--------------------------------------------------------------------------------
-- DEVICE & VIEWPORT ADAPTATION (MOBILE & PC)
--------------------------------------------------------------------------------

function Utilities.IsMobile()
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
        return true
    end
    local viewportSize = Camera and Camera.ViewportSize or Vector2.new(1920, 1080)
    if viewportSize.X <= 950 or viewportSize.Y <= 600 then
        return true
    end
    return false
end

function Utilities.ApplyAutoResponsiveScale(targetFrame, baseWidth, baseHeight)
    baseWidth = baseWidth or 900
    baseHeight = baseHeight or 560
    
    local uiScale = targetFrame:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
    uiScale.Name = "AutoResponsiveUIScale"
    uiScale.Parent = targetFrame
    
    local aspectRatio = targetFrame:FindFirstChildOfClass("UIAspectRatioConstraint") or Instance.new("UIAspectRatioConstraint")
    aspectRatio.Name = "AutoResponsiveAspectRatio"
    aspectRatio.AspectRatio = baseWidth / baseHeight
    aspectRatio.AspectType = Enum.AspectType.FitWithinMaxSize
    aspectRatio.DominantAxis = Enum.DominantAxis.Width
    aspectRatio.Parent = targetFrame
    
    local function updateScale()
        local vp = Camera and Camera.ViewportSize or Vector2.new(1920, 1080)
        local isMob = Utilities.IsMobile()
        
        if isMob then
            -- Auto Scale for Mobile screen, leaving safe margin
            local margin = 30
            local scaleX = (vp.X - margin) / baseWidth
            local scaleY = (vp.Y - margin) / baseHeight
            local scale = math.min(scaleX, scaleY, 1)
            uiScale.Scale = math.max(0.45, scale)
        else
            uiScale.Scale = 1
        end
    end
    
    updateScale()
    if Camera then
        Camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
    end
    return uiScale
end

--------------------------------------------------------------------------------
-- SMOOTH DRAGGABLE (PC & MOBILE TOUCH SUPPORT)
--------------------------------------------------------------------------------

function Utilities.MakeDraggable(dragHandle, targetFrame, onDragCallback)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = targetFrame.Position
            
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
            local newPos = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            -- Use tween for ultra-smooth non-jerky drag movement
            TweenService:Create(targetFrame, TweenInfo.new(0.04, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Position = newPos
            }):Play()
            
            if onDragCallback then
                onDragCallback(newPos)
            end
        end
    end)
end

--------------------------------------------------------------------------------
-- SMOOTH RESIZABLE (DESKTOP BOTTOM-RIGHT CORNER)
--------------------------------------------------------------------------------

function Utilities.MakeResizable(resizeHandle, targetFrame, minSize, maxSize)
    minSize = minSize or Vector2.new(580, 360)
    maxSize = maxSize or Vector2.new(1600, 1000)
    
    local resizing = false
    local resizeStart = nil
    local startSize = nil
    
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = targetFrame.AbsoluteSize
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - resizeStart
            local newWidth = math.clamp(startSize.X + delta.X, minSize.X, maxSize.X)
            local newHeight = math.clamp(startSize.Y + delta.Y, minSize.Y, maxSize.Y)
            
            targetFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)
end

--------------------------------------------------------------------------------
-- COLOR & MATH UTILITIES
--------------------------------------------------------------------------------

function Utilities.ColorToHex(color)
    local r = math.round(color.R * 255)
    local g = math.round(color.G * 255)
    local b = math.round(color.B * 255)
    return string.format("#%02X%02X%02X", r, g, b)
end

function Utilities.HexToColor(hex)
    hex = hex:gsub("#", "")
    local r = tonumber(hex:sub(1, 2), 16) or 255
    local g = tonumber(hex:sub(3, 4), 16) or 255
    local b = tonumber(hex:sub(5, 6), 16) or 255
    return Color3.fromRGB(r, g, b)
end

function Utilities.ColorToHSV(color)
    return Color3.toHSV(color)
end

function Utilities.HSVToColor(h, s, v)
    return Color3.fromHSV(h, s, v)
end

function Utilities.CreateCorner(parent, radiusUDim)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radiusUDim or UDim.new(0, 8)
    corner.Parent = parent
    return corner
end

function Utilities.CreateStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(42, 42, 42)
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

function Utilities.CreatePadding(parent, top, bottom, left, right)
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, top or 8)
    padding.PaddingBottom = UDim.new(0, bottom or top or 8)
    padding.PaddingLeft = UDim.new(0, left or 12)
    padding.PaddingRight = UDim.new(0, right or left or 12)
    padding.Parent = parent
    return padding
end

function Utilities.PlaySound(soundId, volume)
    task.spawn(function()
        pcall(function()
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://" .. tostring(soundId or "6031068425")
            sound.Volume = volume or 0.5
            sound.Parent = workspace
            sound:Play()
            sound.Ended:Connect(function()
                sound:Destroy()
            end)
            task.delay(3, function()
                if sound and sound.Parent then sound:Destroy() end
            end)
        end)
    end)
end

Modules.Utilities = Utilities
end

-- ============================================================================
-- MODULE: Animations
-- ============================================================================
do

local TweenService = game:GetService("TweenService")
local Config = Modules.Config

local Animations = {}

-- Standard smooth tweens
function Animations.Tween(instance, duration, properties, easingStyle, easingDirection)
    if not instance then return nil end
    local info = TweenInfo.new(
        duration or Config.Settings.AnimationSpeed,
        easingStyle or Enum.EasingStyle.Quart,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

-- Fast bounce tween for interactive elements
function Animations.Bounce(instance, targetSize, duration)
    if not instance then return end
    local origSize = instance.Size
    local bounceSize = targetSize or UDim2.new(origSize.X.Scale, origSize.X.Offset * 0.95, origSize.Y.Scale, origSize.Y.Offset * 0.95)
    
    local t1 = TweenService:Create(instance, TweenInfo.new((duration or 0.12) * 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = bounceSize
    })
    t1:Play()
    t1.Completed:Connect(function()
        TweenService:Create(instance, TweenInfo.new((duration or 0.12) * 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = origSize
        }):Play()
    end)
end

-- Hover animation (Color gradient or background glow)
function Animations.Hover(instance, normalColor, hoverColor, duration)
    if not instance then return end
    instance.MouseEnter:Connect(function()
        Animations.Tween(instance, duration or Config.Settings.FastAnimationSpeed, {
            BackgroundColor3 = hoverColor
        })
    end)
    instance.MouseLeave:Connect(function()
        Animations.Tween(instance, duration or Config.Settings.FastAnimationSpeed, {
            BackgroundColor3 = normalColor
        })
    end)
end

-- Ripple effect inside any button / card
function Animations.CreateRipple(parentFrame, inputPosition, rippleColor)
    if not parentFrame then return end
    
    task.spawn(function()
        local rippleContainer = Instance.new("Frame")
        rippleContainer.Name = "RippleContainer"
        rippleContainer.Size = UDim2.new(1, 0, 1, 0)
        rippleContainer.BackgroundTransparency = 1
        rippleContainer.ClipsDescendants = true
        rippleContainer.ZIndex = parentFrame.ZIndex + 5
        rippleContainer.Parent = parentFrame
        
        local corner = parentFrame:FindFirstChildOfClass("UICorner")
        if corner then
            local rCorner = corner:Clone()
            rCorner.Parent = rippleContainer
        end
        
        local absPos = parentFrame.AbsolutePosition
        local absSize = parentFrame.AbsoluteSize
        
        local relX = (inputPosition and inputPosition.X) and (inputPosition.X - absPos.X) or (absSize.X / 2)
        local relY = (inputPosition and inputPosition.Y) and (inputPosition.Y - absPos.Y) or (absSize.Y / 2)
        
        local maxDist = math.max(absSize.X, absSize.Y) * 2.2
        
        local rippleCircle = Instance.new("ImageLabel")
        rippleCircle.Name = "Ripple"
        rippleCircle.BackgroundTransparency = 1
        rippleCircle.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png" -- Or soft circle asset
        rippleCircle.ImageColor3 = rippleColor or Config.Colors.TextWhite
        rippleCircle.ImageTransparency = 0.65
        rippleCircle.Position = UDim2.new(0, relX, 0, relY)
        rippleCircle.Size = UDim2.new(0, 0, 0, 0)
        rippleCircle.AnchorPoint = Vector2.new(0.5, 0.5)
        rippleCircle.ZIndex = rippleContainer.ZIndex
        
        local circleCorner = Instance.new("UICorner")
        circleCorner.CornerRadius = UDim.new(1, 0)
        circleCorner.Parent = rippleCircle
        
        rippleCircle.Parent = rippleContainer
        
        local tweenInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        local tweenSize = TweenService:Create(rippleCircle, tweenInfo, {
            Size = UDim2.new(0, maxDist, 0, maxDist),
            ImageTransparency = 1
        })
        
        tweenSize:Play()
        tweenSize.Completed:Connect(function()
            rippleContainer:Destroy()
        end)
    end)
end

-- Toggle Switch Circle Animation
function Animations.ToggleCircle(circleFrame, isOn, activePos, inactivePos, activeColor, inactiveColor)
    local targetPos = isOn and activePos or inactivePos
    local targetColor = isOn and (activeColor or Config.Colors.NeonRed) or (inactiveColor or Config.Colors.TextGray)
    
    Animations.Tween(circleFrame, 0.22, {
        Position = targetPos,
        BackgroundColor3 = targetColor
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

-- Fade in & out helper
function Animations.Fade(instance, targetTransparency, duration)
    return Animations.Tween(instance, duration or Config.Settings.AnimationSpeed, {
        BackgroundTransparency = targetTransparency
    })
end

-- Slide transition helper
function Animations.Slide(instance, targetPosition, duration, easingStyle)
    return Animations.Tween(instance, duration or Config.Settings.AnimationSpeed, {
        Position = targetPosition
    }, easingStyle or Enum.EasingStyle.Quart)
end

Modules.Animations = Animations
end

-- ============================================================================
-- MODULE: ConfigSystem
-- ============================================================================
do

local HttpService = game:GetService("HttpService")
local Config = Modules.Config
local Utilities = Modules.Utilities

local ConfigSystem = {
    Flags = {},
    Elements = {},
    AutoSaveEnabled = true,
    FolderName = Config.Settings.ConfigFolder,
    FileName = Config.Settings.ConfigFile
}

-- Ensure configuration folder exists
function ConfigSystem.Init(folderName, fileName)
    if folderName then ConfigSystem.FolderName = folderName end
    if fileName then ConfigSystem.FileName = fileName end
    
    local folderPath = ConfigSystem.FolderName
    if not Utilities.IsFile(folderPath) then
        Utilities.MakeFolder(folderPath)
    end
    
    -- Start auto-save loop if enabled
    task.spawn(function()
        while ConfigSystem.AutoSaveEnabled do
            task.wait(Config.Settings.SaveInterval or 5)
            if ConfigSystem.AutoSaveEnabled then
                ConfigSystem.SaveConfig()
            end
        end
    end)
end

-- Register an element flag so it saves/loads automatically
function ConfigSystem.RegisterFlag(flagName, elementInstance)
    if not flagName or flagName == "" then return end
    ConfigSystem.Elements[flagName] = elementInstance
end

-- Save all flags and current theme settings to JSON file
function ConfigSystem.SaveConfig(customFileName)
    local targetFile = customFileName or ConfigSystem.FileName
    local fullPath = ConfigSystem.FolderName .. "/" .. targetFile
    
    local saveData = {
        Version = "2.0.0",
        Timestamp = os.time(),
        Theme = {
            PrimaryRed = Utilities.ColorToHex(Config.Colors.PrimaryRed),
            HoverRed = Utilities.ColorToHex(Config.Colors.HoverRed),
            NeonRed = Utilities.ColorToHex(Config.Colors.NeonRed),
            Background = Utilities.ColorToHex(Config.Colors.Background),
            Secondary = Utilities.ColorToHex(Config.Colors.Secondary),
            Card = Utilities.ColorToHex(Config.Colors.Card)
        },
        Flags = {}
    }
    
    for flagName, element in pairs(ConfigSystem.Elements) do
        if element and element.GetValue then
            local val = element:GetValue()
            if typeof(val) == "Color3" then
                saveData.Flags[flagName] = {Type = "Color3", Hex = Utilities.ColorToHex(val)}
            elseif typeof(val) == "EnumItem" then
                saveData.Flags[flagName] = {Type = "EnumItem", Value = val.Name}
            else
                saveData.Flags[flagName] = val
            end
        end
    end
    
    local success, jsonString = pcall(function()
        return HttpService:JSONEncode(saveData)
    end)
    
    if success and jsonString then
        Utilities.WriteFile(fullPath, jsonString)
        return true
    end
    return false
end

-- Load configuration from JSON file
function ConfigSystem.LoadConfig(customFileName)
    local targetFile = customFileName or ConfigSystem.FileName
    local fullPath = ConfigSystem.FolderName .. "/" .. targetFile
    
    if not Utilities.IsFile(fullPath) then return false end
    
    local content = Utilities.ReadFile(fullPath)
    if not content or content == "" then return false end
    
    local success, decoded = pcall(function()
        return HttpService:JSONDecode(content)
    end)
    
    if not success or not decoded then return false end
    
    -- Restore Theme
    if decoded.Theme then
        if decoded.Theme.PrimaryRed then Config:SetColor("PrimaryRed", Utilities.HexToColor(decoded.Theme.PrimaryRed)) end
        if decoded.Theme.HoverRed then Config:SetColor("HoverRed", Utilities.HexToColor(decoded.Theme.HoverRed)) end
        if decoded.Theme.NeonRed then Config:SetColor("NeonRed", Utilities.HexToColor(decoded.Theme.NeonRed)) end
        if decoded.Theme.Background then Config:SetColor("Background", Utilities.HexToColor(decoded.Theme.Background)) end
        if decoded.Theme.Secondary then Config:SetColor("Secondary", Utilities.HexToColor(decoded.Theme.Secondary)) end
        if decoded.Theme.Card then Config:SetColor("Card", Utilities.HexToColor(decoded.Theme.Card)) end
    end
    
    -- Restore Flags
    if decoded.Flags then
        for flagName, valData in pairs(decoded.Flags) do
            local element = ConfigSystem.Elements[flagName]
            if element and element.SetValue then
                if type(valData) == "table" and valData.Type == "Color3" and valData.Hex then
                    element:SetValue(Utilities.HexToColor(valData.Hex))
                elseif type(valData) == "table" and valData.Type == "EnumItem" and valData.Value then
                    pcall(function()
                        if Enum.KeyCode[valData.Value] then
                            element:SetValue(Enum.KeyCode[valData.Value])
                        end
                    end)
                else
                    element:SetValue(valData)
                end
            end
        end
    end
    
    return true
end

function ConfigSystem.ResetConfig()
    Config:ResetColors()
    for flagName, element in pairs(ConfigSystem.Elements) do
        if element and element.Reset then
            element:Reset()
        end
    end
end

Modules.ConfigSystem = ConfigSystem
end

-- ============================================================================
-- MODULE: Elements
-- ============================================================================
do

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Config = Modules.Config
local Utilities = Modules.Utilities
local Animations = Modules.Animations
local Icons = Modules.Icons
local ConfigSystem = Modules.ConfigSystem

local Elements = {}

--------------------------------------------------------------------------------
-- 1. CREATE TOGGLE (Animasi ON/OFF, Warna Merah Neon, Circle bergerak halus)
--------------------------------------------------------------------------------
function Elements.CreateToggle(parentContainer, options)
    options = options or {}
    local name = options.Name or "Toggle"
    local defaultVal = options.CurrentValue or options.Default or false
    local callback = options.Callback or function() end
    local flag = options.Flag or name
    
    local toggleCard = Instance.new("Frame")
    toggleCard.Name = "Toggle_" .. name
    toggleCard.Size = UDim2.new(1, 0, 0, 44)
    toggleCard.BackgroundColor3 = Config.Colors.Card
    toggleCard.BorderSizePixel = 0
    toggleCard.Parent = parentContainer
    Utilities.CreateCorner(toggleCard, Config.Settings.SmallCornerRadius)
    Utilities.CreateStroke(toggleCard, Config.Colors.Border, 1)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -64, 1, 0)
    titleLabel.Position = UDim2.new(0, 14, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = name
    titleLabel.Font = Config.Fonts.Semibold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = Config.Colors.TextWhite
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = toggleCard
    
    local switchBG = Instance.new("Frame")
    switchBG.Name = "SwitchBG"
    switchBG.Size = UDim2.new(0, 42, 0, 22)
    switchBG.Position = UDim2.new(1, -54, 0.5, -11)
    switchBG.BackgroundColor3 = defaultVal and Config.Colors.PrimaryRed or Config.Colors.Border
    switchBG.BorderSizePixel = 0
    switchBG.Parent = toggleCard
    Utilities.CreateCorner(switchBG, UDim.new(1, 0))
    
    local circle = Instance.new("Frame")
    circle.Name = "Circle"
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultVal and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    circle.BackgroundColor3 = defaultVal and Config.Colors.TextWhite or Config.Colors.TextGray
    circle.BorderSizePixel = 0
    circle.Parent = switchBG
    Utilities.CreateCorner(circle, UDim.new(1, 0))
    
    local triggerButton = Instance.new("TextButton")
    triggerButton.Size = UDim2.new(1, 0, 1, 0)
    triggerButton.BackgroundTransparency = 1
    triggerButton.Text = ""
    triggerButton.Parent = toggleCard
    
    local isToggled = defaultVal
    
    local function updateVisuals(animate)
        local targetBGColor = isToggled and Config.Colors.PrimaryRed or Config.Colors.Border
        local targetCircleColor = isToggled and Config.Colors.TextWhite or Config.Colors.TextGray
        local targetPos = isToggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        
        if animate then
            Animations.Tween(switchBG, 0.2, {BackgroundColor3 = targetBGColor})
            Animations.Tween(circle, 0.2, {Position = targetPos, BackgroundColor3 = targetCircleColor}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            switchBG.BackgroundColor3 = targetBGColor
            circle.Position = targetPos
            circle.BackgroundColor3 = targetCircleColor
        end
    end
    
    triggerButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        updateVisuals(true)
        Animations.CreateRipple(toggleCard, triggerButton.AbsolutePosition, Config.Colors.PrimaryRed)
        Utilities.PlaySound("6031068425", 0.4)
        task.spawn(callback, isToggled)
    end)
    
    local toggleObj = {
        Frame = toggleCard,
        Title = name,
        Type = "Toggle"
    }
    function toggleObj:SetValue(val)
        isToggled = val
        updateVisuals(true)
        task.spawn(callback, isToggled)
    end
    function toggleObj:GetValue()
        return isToggled
    end
    function toggleObj:Reset()
        self:SetValue(defaultVal)
    end
    
    ConfigSystem.RegisterFlag(flag, toggleObj)
    return toggleObj
end

--------------------------------------------------------------------------------
-- 2. CREATE BUTTON (Hover, Click, Ripple, Gradient, Scale Animation)
--------------------------------------------------------------------------------
function Elements.CreateButton(parentContainer, options)
    options = options or {}
    local name = options.Name or "Button"
    local callback = options.Callback or function() end
    
    local buttonCard = Instance.new("Frame")
    buttonCard.Name = "Button_" .. name
    buttonCard.Size = UDim2.new(1, 0, 0, 44)
    buttonCard.BackgroundColor3 = Config.Colors.Card
    buttonCard.BorderSizePixel = 0
    buttonCard.Parent = parentContainer
    Utilities.CreateCorner(buttonCard, Config.Settings.SmallCornerRadius)
    local stroke = Utilities.CreateStroke(buttonCard, Config.Colors.Border, 1)
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 220, 220))
    })
    gradient.Parent = buttonCard
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -28, 1, 0)
    titleLabel.Position = UDim2.new(0, 14, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = name
    titleLabel.Font = Config.Fonts.Semibold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = Config.Colors.TextWhite
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = buttonCard
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = buttonCard
    
    btn.MouseEnter:Connect(function()
        Animations.Tween(buttonCard, 0.15, {BackgroundColor3 = Config.Colors.PrimaryRed})
        Animations.Tween(stroke, 0.15, {Color = Config.Colors.HoverRed})
    end)
    btn.MouseLeave:Connect(function()
        Animations.Tween(buttonCard, 0.15, {BackgroundColor3 = Config.Colors.Card})
        Animations.Tween(stroke, 0.15, {Color = Config.Colors.Border})
    end)
    
    btn.MouseButton1Down:Connect(function()
        Animations.Bounce(buttonCard, UDim2.new(1, -6, 0, 40), 0.12)
    end)
    
    btn.MouseButton1Click:Connect(function()
        Animations.CreateRipple(buttonCard, btn.AbsolutePosition, Config.Colors.TextWhite)
        Utilities.PlaySound("6031068425", 0.4)
        task.spawn(callback)
    end)
    
    local buttonObj = {
        Frame = buttonCard,
        Title = name,
        Type = "Button"
    }
    function buttonObj:Fire()
        task.spawn(callback)
    end
    return buttonObj
end

--------------------------------------------------------------------------------
-- 3. CREATE SLIDER (0 sampai 100, Drag Smooth, Menampilkan Value)
--------------------------------------------------------------------------------
function Elements.CreateSlider(parentContainer, options)
    options = options or {}
    local name = options.Name or "Slider"
    local range = options.Range or {0, 100}
    local minVal = range[1] or 0
    local maxVal = range[2] or 100
    local increment = options.Increment or 1
    local currentVal = options.CurrentValue or options.Default or minVal
    local suffix = options.Suffix or ""
    local callback = options.Callback or function() end
    local flag = options.Flag or name
    
    local sliderCard = Instance.new("Frame")
    sliderCard.Name = "Slider_" .. name
    sliderCard.Size = UDim2.new(1, 0, 0, 60)
    sliderCard.BackgroundColor3 = Config.Colors.Card
    sliderCard.BorderSizePixel = 0
    sliderCard.Parent = parentContainer
    Utilities.CreateCorner(sliderCard, Config.Settings.SmallCornerRadius)
    Utilities.CreateStroke(sliderCard, Config.Colors.Border, 1)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.6, 0, 0, 26)
    titleLabel.Position = UDim2.new(0, 14, 0, 6)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = name
    titleLabel.Font = Config.Fonts.Semibold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = Config.Colors.TextWhite
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = sliderCard
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.35, 0, 0, 26)
    valueLabel.Position = UDim2.new(0.6, 0, 0, 6)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(currentVal) .. suffix
    valueLabel.Font = Config.Fonts.Bold
    valueLabel.TextSize = 14
    valueLabel.TextColor3 = Config.Colors.PrimaryRed
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderCard
    
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, -28, 0, 6)
    track.Position = UDim2.new(0, 14, 0, 40)
    track.BackgroundColor3 = Config.Colors.Secondary
    track.BorderSizePixel = 0
    track.Parent = sliderCard
    Utilities.CreateCorner(track, UDim.new(1, 0))
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    local initialPercent = math.clamp((currentVal - minVal) / (maxVal - minVal), 0, 1)
    fill.Size = UDim2.new(initialPercent, 0, 1, 0)
    fill.BackgroundColor3 = Config.Colors.PrimaryRed
    fill.BorderSizePixel = 0
    fill.Parent = track
    Utilities.CreateCorner(fill, UDim.new(1, 0))
    
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(1, -7, 0.5, -7)
    knob.BackgroundColor3 = Config.Colors.TextWhite
    knob.BorderSizePixel = 0
    knob.Parent = fill
    Utilities.CreateCorner(knob, UDim.new(1, 0))
    
    local triggerButton = Instance.new("TextButton")
    triggerButton.Size = UDim2.new(1, 0, 0, 24)
    triggerButton.Position = UDim2.new(0, 0, 0, 34)
    triggerButton.BackgroundTransparency = 1
    triggerButton.Text = ""
    triggerButton.Parent = sliderCard
    
    local dragging = false
    
    local function updateSlider(inputPosition)
        local absPos = track.AbsolutePosition.X
        local absSize = track.AbsoluteSize.X
        local relX = math.clamp(inputPosition.X - absPos, 0, absSize)
        local percent = relX / absSize
        
        local rawValue = minVal + (maxVal - minVal) * percent
        local roundedValue = math.floor(rawValue / increment + 0.5) * increment
        roundedValue = math.clamp(roundedValue, minVal, maxVal)
        
        currentVal = roundedValue
        valueLabel.Text = tostring(currentVal) .. suffix
        
        local targetPercent = math.clamp((currentVal - minVal) / (maxVal - minVal), 0, 1)
        Animations.Tween(fill, 0.05, {Size = UDim2.new(targetPercent, 0, 1, 0)}, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        
        task.spawn(callback, currentVal)
    end
    
    triggerButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input.Position)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input.Position)
        end
    end)
    
    local sliderObj = {
        Frame = sliderCard,
        Title = name,
        Type = "Slider"
    }
    function sliderObj:SetValue(val)
        currentVal = math.clamp(val, minVal, maxVal)
        valueLabel.Text = tostring(currentVal) .. suffix
        local percent = (currentVal - minVal) / (maxVal - minVal)
        Animations.Tween(fill, 0.15, {Size = UDim2.new(percent, 0, 1, 0)})
        task.spawn(callback, currentVal)
    end
    function sliderObj:GetValue()
        return currentVal
    end
    function sliderObj:Reset()
        self:SetValue(options.CurrentValue or options.Default or minVal)
    end
    
    ConfigSystem.RegisterFlag(flag, sliderObj)
    return sliderObj
end

--------------------------------------------------------------------------------
-- 4. CREATE TEXTBOX (Placeholder, Auto Clear, Number/Text Only, Max Length)
--------------------------------------------------------------------------------
function Elements.CreateTextbox(parentContainer, options)
    options = options or {}
    local name = options.Name or "Textbox"
    local placeholder = options.Placeholder or "Enter text..."
    local autoClear = options.AutoClear == nil and true or options.AutoClear
    local numberOnly = options.NumberOnly or false
    local textOnly = options.TextOnly or false
    local maxLength = options.MaxLength or 100
    local defaultVal = options.CurrentValue or options.Default or ""
    local callback = options.Callback or function() end
    local flag = options.Flag or name
    
    local textboxCard = Instance.new("Frame")
    textboxCard.Name = "Textbox_" .. name
    textboxCard.Size = UDim2.new(1, 0, 0, 48)
    textboxCard.BackgroundColor3 = Config.Colors.Card
    textboxCard.BorderSizePixel = 0
    textboxCard.Parent = parentContainer
    Utilities.CreateCorner(textboxCard, Config.Settings.SmallCornerRadius)
    local stroke = Utilities.CreateStroke(textboxCard, Config.Colors.Border, 1)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.45, -14, 1, 0)
    titleLabel.Position = UDim2.new(0, 14, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = name
    titleLabel.Font = Config.Fonts.Semibold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = Config.Colors.TextWhite
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = textboxCard
    
    local inputBG = Instance.new("Frame")
    inputBG.Size = UDim2.new(0.5, 0, 0, 32)
    inputBG.Position = UDim2.new(0.5, -10, 0.5, -16)
    inputBG.BackgroundColor3 = Config.Colors.Secondary
    inputBG.BorderSizePixel = 0
    inputBG.Parent = textboxCard
    Utilities.CreateCorner(inputBG, Config.Settings.SmallCornerRadius)
    
    local inputField = Instance.new("TextBox")
    inputField.Size = UDim2.new(1, -16, 1, 0)
    inputField.Position = UDim2.new(0, 8, 0, 0)
    inputField.BackgroundTransparency = 1
    inputField.Text = defaultVal
    inputField.PlaceholderText = placeholder
    inputField.PlaceholderColor3 = Config.Colors.Placeholder
    inputField.Font = Config.Fonts.Regular
    inputField.TextSize = 13
    inputField.TextColor3 = Config.Colors.TextWhite
    inputField.ClearTextOnFocus = autoClear
    inputField.TextXAlignment = Enum.TextXAlignment.Left
    inputField.Parent = inputBG
    
    inputField.Focused:Connect(function()
        Animations.Tween(stroke, 0.2, {Color = Config.Colors.PrimaryRed})
    end)
    
    inputField.FocusLost:Connect(function(enterPressed)
        Animations.Tween(stroke, 0.2, {Color = Config.Colors.Border})
        local text = inputField.Text
        
        if numberOnly then
            text = text:gsub("[^%d%.%-]", "")
        elseif textOnly then
            text = text:gsub("[^%a%s]", "")
        end
        
        if #text > maxLength then
            text = string.sub(text, 1, maxLength)
        end
        
        inputField.Text = text
        task.spawn(callback, text, enterPressed)
    end)
    
    local textboxObj = {
        Frame = textboxCard,
        Title = name,
        Type = "Textbox"
    }
    function textboxObj:SetValue(val)
        inputField.Text = tostring(val)
        task.spawn(callback, tostring(val), false)
    end
    function textboxObj:GetValue()
        return inputField.Text
    end
    
    ConfigSystem.RegisterFlag(flag, textboxObj)
    return textboxObj
end

--------------------------------------------------------------------------------
-- 5. CREATE DROPDOWN (Single Select, Multi Select, Search, Auto Scroll)
--------------------------------------------------------------------------------
function Elements.CreateDropdown(parentContainer, options)
    options = options or {}
    local name = options.Name or "Dropdown"
    local optionsList = options.Options or {"Option 1", "Option 2"}
    local multiSelect = options.MultiSelect or false
    local hasSearch = options.Search == nil and true or options.Search
    local currentSelection = options.CurrentOption or options.Default or (multiSelect and {} or optionsList[1])
    local callback = options.Callback or function() end
    local flag = options.Flag or name
    
    local isOpen = false
    local selectedItems = multiSelect and (type(currentSelection) == "table" and currentSelection or {}) or currentSelection
    
    local dropdownCard = Instance.new("Frame")
    dropdownCard.Name = "Dropdown_" .. name
    dropdownCard.Size = UDim2.new(1, 0, 0, 48) -- Collapsed size
    dropdownCard.BackgroundColor3 = Config.Colors.Card
    dropdownCard.BorderSizePixel = 0
    dropdownCard.ClipsDescendants = true
    dropdownCard.Parent = parentContainer
    Utilities.CreateCorner(dropdownCard, Config.Settings.SmallCornerRadius)
    local stroke = Utilities.CreateStroke(dropdownCard, Config.Colors.Border, 1)
    
    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 48)
    headerFrame.BackgroundTransparency = 1
    headerFrame.Parent = dropdownCard
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.45, -14, 1, 0)
    titleLabel.Position = UDim2.new(0, 14, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = name
    titleLabel.Font = Config.Fonts.Semibold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = Config.Colors.TextWhite
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = headerFrame
    
    local selectedBox = Instance.new("Frame")
    selectedBox.Size = UDim2.new(0.5, 0, 0, 32)
    selectedBox.Position = UDim2.new(0.5, -10, 0.5, -16)
    selectedBox.BackgroundColor3 = Config.Colors.Secondary
    selectedBox.BorderSizePixel = 0
    selectedBox.Parent = headerFrame
    Utilities.CreateCorner(selectedBox, Config.Settings.SmallCornerRadius)
    
    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Size = UDim2.new(1, -30, 1, 0)
    selectedLabel.Position = UDim2.new(0, 10, 0, 0)
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Font = Config.Fonts.Regular
    selectedLabel.TextSize = 13
    selectedLabel.TextColor3 = Config.Colors.TextGray
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedLabel.TextTruncate = Enum.TextTruncate.AtEnd
    selectedLabel.Parent = selectedBox
    
    local function getSelectionText()
        if multiSelect then
            if type(selectedItems) == "table" and #selectedItems > 0 then
                return table.concat(selectedItems, ", ")
            end
            return "Select items..."
        else
            return tostring(selectedItems or "Select option...")
        end
    end
    selectedLabel.Text = getSelectionText()
    
    local arrowIcon = Instance.new("ImageLabel")
    arrowIcon.Size = UDim2.new(0, 16, 0, 16)
    arrowIcon.Position = UDim2.new(1, -22, 0.5, -8)
    arrowIcon.BackgroundTransparency = 1
    arrowIcon.Image = Config.Assets.Arrow
    arrowIcon.ImageColor3 = Config.Colors.TextGray
    arrowIcon.Parent = selectedBox
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, 0, 1, 0)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    toggleBtn.Parent = headerFrame
    
    -- Dropdown List Container
    local listContainer = Instance.new("Frame")
    listContainer.Size = UDim2.new(1, -28, 0, 160)
    listContainer.Position = UDim2.new(0, 14, 0, 56)
    listContainer.BackgroundTransparency = 1
    listContainer.Parent = dropdownCard
    
    local searchBox = nil
    if hasSearch then
        local searchBG = Instance.new("Frame")
        searchBG.Size = UDim2.new(1, 0, 0, 32)
        searchBG.BackgroundColor3 = Config.Colors.Secondary
        searchBG.BorderSizePixel = 0
        searchBG.Parent = listContainer
        Utilities.CreateCorner(searchBG, Config.Settings.SmallCornerRadius)
        
        searchBox = Instance.new("TextBox")
        searchBox.Size = UDim2.new(1, -16, 1, 0)
        searchBox.Position = UDim2.new(0, 8, 0, 0)
        searchBox.BackgroundTransparency = 1
        searchBox.PlaceholderText = "Search options..."
        searchBox.PlaceholderColor3 = Config.Colors.Placeholder
        searchBox.Font = Config.Fonts.Regular
        searchBox.TextSize = 13
        searchBox.TextColor3 = Config.Colors.TextWhite
        searchBox.TextXAlignment = Enum.TextXAlignment.Left
        searchBox.Parent = searchBG
    end
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = hasSearch and UDim2.new(1, 0, 1, -40) or UDim2.new(1, 0, 1, 0)
    scrollFrame.Position = hasSearch and UDim2.new(0, 0, 0, 40) or UDim2.new(0, 0, 0, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Config.Colors.PrimaryRed
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = listContainer
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 6)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scrollFrame
    
    local optionButtons = {}
    
    local function populateOptions(list)
        for _, child in ipairs(scrollFrame:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextButton") then
                child:Destroy()
            end
        end
        optionButtons = {}
        
        for idx, optName in ipairs(list) do
            local optBtn = Instance.new("TextButton")
            optBtn.Name = "Opt_" .. tostring(optName)
            optBtn.Size = UDim2.new(1, -8, 0, 32)
            optBtn.BackgroundColor3 = Config.Colors.Secondary
            optBtn.BorderSizePixel = 0
            optBtn.Font = Config.Fonts.Regular
            optBtn.TextSize = 13
            optBtn.TextColor3 = Config.Colors.TextWhite
            optBtn.Text = "   " .. tostring(optName)
            optBtn.TextXAlignment = Enum.TextXAlignment.Left
            optBtn.Parent = scrollFrame
            Utilities.CreateCorner(optBtn, Config.Settings.SmallCornerRadius)
            
            local checkIndicator = Instance.new("Frame")
            checkIndicator.Size = UDim2.new(0, 8, 0, 8)
            checkIndicator.Position = UDim2.new(1, -20, 0.5, -4)
            checkIndicator.BackgroundColor3 = Config.Colors.PrimaryRed
            checkIndicator.BorderSizePixel = 0
            checkIndicator.Parent = optBtn
            Utilities.CreateCorner(checkIndicator, UDim.new(1, 0))
            
            local function checkIsSelected(val)
                if multiSelect then
                    for _, v in ipairs(selectedItems) do
                        if v == val then return true end
                    end
                    return false
                else
                    return selectedItems == val
                end
            end
            
            checkIndicator.Visible = checkIsSelected(optName)
            if checkIndicator.Visible then
                optBtn.TextColor3 = Config.Colors.PrimaryRed
                optBtn.Font = Config.Fonts.Semibold
            end
            
            optBtn.MouseButton1Click:Connect(function()
                if multiSelect then
                    local foundIdx = nil
                    for i, v in ipairs(selectedItems) do
                        if v == optName then foundIdx = i; break end
                    end
                    if foundIdx then
                        table.remove(selectedItems, foundIdx)
                        checkIndicator.Visible = false
                        optBtn.TextColor3 = Config.Colors.TextWhite
                        optBtn.Font = Config.Fonts.Regular
                    else
                        table.insert(selectedItems, optName)
                        checkIndicator.Visible = true
                        optBtn.TextColor3 = Config.Colors.PrimaryRed
                        optBtn.Font = Config.Fonts.Semibold
                    end
                    selectedLabel.Text = getSelectionText()
                    task.spawn(callback, selectedItems)
                else
                    selectedItems = optName
                    for _, b in pairs(optionButtons) do
                        local chk = b:FindFirstChild("Frame")
                        if chk then chk.Visible = false end
                        b.TextColor3 = Config.Colors.TextWhite
                        b.Font = Config.Fonts.Regular
                    end
                    checkIndicator.Visible = true
                    optBtn.TextColor3 = Config.Colors.PrimaryRed
                    optBtn.Font = Config.Fonts.Semibold
                    selectedLabel.Text = getSelectionText()
                    
                    -- Close on single select
                    isOpen = false
                    Animations.Tween(dropdownCard, 0.25, {Size = UDim2.new(1, 0, 0, 48)})
                    Animations.Tween(arrowIcon, 0.25, {Rotation = 0})
                    task.spawn(callback, selectedItems)
                end
            end)
            
            table.insert(optionButtons, optBtn)
        end
    end
    
    populateOptions(optionsList)
    
    if searchBox then
        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local query = string.lower(searchBox.Text)
            for _, btn in ipairs(optionButtons) do
                local text = string.lower(btn.Text)
                if query == "" or string.find(text, query, 1, true) then
                    btn.Visible = true
                else
                    btn.Visible = false
                end
            end
        end)
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            local targetHeight = math.min(#optionsList * 38 + (hasSearch and 106 or 66), 240)
            Animations.Tween(dropdownCard, 0.25, {Size = UDim2.new(1, 0, 0, targetHeight)}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            Animations.Tween(arrowIcon, 0.25, {Rotation = 180})
            Animations.Tween(stroke, 0.25, {Color = Config.Colors.PrimaryRed})
        else
            Animations.Tween(dropdownCard, 0.25, {Size = UDim2.new(1, 0, 0, 48)}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            Animations.Tween(arrowIcon, 0.25, {Rotation = 0})
            Animations.Tween(stroke, 0.25, {Color = Config.Colors.Border})
        end
    end)
    
    local dropdownObj = {
        Frame = dropdownCard,
        Title = name,
        Type = "Dropdown"
    }
    function dropdownObj:SetValue(val)
        selectedItems = val
        selectedLabel.Text = getSelectionText()
        populateOptions(optionsList)
        task.spawn(callback, selectedItems)
    end
    function dropdownObj:Refresh(newOptions, newDefault)
        optionsList = newOptions or optionsList
        if newDefault then selectedItems = newDefault end
        populateOptions(optionsList)
        selectedLabel.Text = getSelectionText()
    end
    function dropdownObj:GetValue()
        return selectedItems
    end
    
    ConfigSystem.RegisterFlag(flag, dropdownObj)
    return dropdownObj
end

--------------------------------------------------------------------------------
-- 6. CREATE MULTI DROPDOWN
--------------------------------------------------------------------------------
function Elements.CreateMultiDropdown(parentContainer, options)
    options = options or {}
    options.MultiSelect = true
    return Elements.CreateDropdown(parentContainer, options)
end

--------------------------------------------------------------------------------
-- 7. CREATE COLOR PICKER (Interactive RGB sliders/palette with Hex & Preview)
--------------------------------------------------------------------------------
function Elements.CreateColorPicker(parentContainer, options)
    options = options or {}
    local name = options.Name or "Color Picker"
    local defaultColor = options.Color or options.Default or Config.Colors.PrimaryRed
    local callback = options.Callback or function() end
    local flag = options.Flag or name
    
    local currentColor = defaultColor
    local isOpen = false
    
    local colorCard = Instance.new("Frame")
    colorCard.Name = "ColorPicker_" .. name
    colorCard.Size = UDim2.new(1, 0, 0, 48)
    colorCard.BackgroundColor3 = Config.Colors.Card
    colorCard.BorderSizePixel = 0
    colorCard.ClipsDescendants = true
    colorCard.Parent = parentContainer
    Utilities.CreateCorner(colorCard, Config.Settings.SmallCornerRadius)
    local stroke = Utilities.CreateStroke(colorCard, Config.Colors.Border, 1)
    
    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 48)
    headerFrame.BackgroundTransparency = 1
    headerFrame.Parent = colorCard
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.6, -14, 1, 0)
    titleLabel.Position = UDim2.new(0, 14, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = name
    titleLabel.Font = Config.Fonts.Semibold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = Config.Colors.TextWhite
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = headerFrame
    
    local previewBox = Instance.new("Frame")
    previewBox.Size = UDim2.new(0, 42, 0, 24)
    previewBox.Position = UDim2.new(1, -56, 0.5, -12)
    previewBox.BackgroundColor3 = currentColor
    previewBox.BorderSizePixel = 0
    previewBox.Parent = headerFrame
    Utilities.CreateCorner(previewBox, Config.Settings.SmallCornerRadius)
    Utilities.CreateStroke(previewBox, Config.Colors.TextWhite, 1, 0.4)
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, 0, 1, 0)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    toggleBtn.Parent = headerFrame
    
    -- Color sliders (R, G, B)
    local slidersContainer = Instance.new("Frame")
    slidersContainer.Size = UDim2.new(1, -28, 0, 140)
    slidersContainer.Position = UDim2.new(0, 14, 0, 56)
    slidersContainer.BackgroundTransparency = 1
    slidersContainer.Parent = colorCard
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 10)
    listLayout.Parent = slidersContainer
    
    local function createColorChannelSlider(channelName, initialVal, channelColor, onUpdate)
        local channelFrame = Instance.new("Frame")
        channelFrame.Size = UDim2.new(1, 0, 0, 36)
        channelFrame.BackgroundTransparency = 1
        channelFrame.Parent = slidersContainer
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0, 20, 0, 18)
        lbl.BackgroundTransparency = 1
        lbl.Text = channelName
        lbl.Font = Config.Fonts.Bold
        lbl.TextSize = 13
        lbl.TextColor3 = channelColor
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = channelFrame
        
        local valLbl = Instance.new("TextLabel")
        valLbl.Size = UDim2.new(0, 40, 0, 18)
        valLbl.Position = UDim2.new(1, -40, 0, 0)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = tostring(math.floor(initialVal * 255))
        valLbl.Font = Config.Fonts.Regular
        valLbl.TextSize = 13
        valLbl.TextColor3 = Config.Colors.TextWhite
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.Parent = channelFrame
        
        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, 0, 0, 8)
        track.Position = UDim2.new(0, 0, 0, 24)
        track.BackgroundColor3 = Config.Colors.Secondary
        track.BorderSizePixel = 0
        track.Parent = channelFrame
        Utilities.CreateCorner(track, UDim.new(1, 0))
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(initialVal, 0, 1, 0)
        fill.BackgroundColor3 = channelColor
        fill.BorderSizePixel = 0
        fill.Parent = track
        Utilities.CreateCorner(fill, UDim.new(1, 0))
        
        local dragging = false
        local trigger = Instance.new("TextButton")
        trigger.Size = UDim2.new(1, 0, 0, 20)
        trigger.Position = UDim2.new(0, 0, 0, 16)
        trigger.BackgroundTransparency = 1
        trigger.Text = ""
        trigger.Parent = channelFrame
        
        local function updateChannel(inputPos)
            local relX = math.clamp(inputPos.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
            local pct = relX / track.AbsoluteSize.X
            valLbl.Text = tostring(math.floor(pct * 255))
            Animations.Tween(fill, 0.05, {Size = UDim2.new(pct, 0, 1, 0)})
            onUpdate(pct)
        end
        
        trigger.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                updateChannel(inp.Position)
            end
        end)
        UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                updateChannel(inp.Position)
            end
        end)
        
        return function(newPct)
            valLbl.Text = tostring(math.floor(newPct * 255))
            fill.Size = UDim2.new(newPct, 0, 1, 0)
        end
    end
    
    local rSetter = createColorChannelSlider("R", currentColor.R, Color3.fromRGB(255, 60, 77), function(val)
        currentColor = Color3.new(val, currentColor.G, currentColor.B)
        previewBox.BackgroundColor3 = currentColor
        task.spawn(callback, currentColor)
    end)
    
    local gSetter = createColorChannelSlider("G", currentColor.G, Color3.fromRGB(61, 255, 122), function(val)
        currentColor = Color3.new(currentColor.R, val, currentColor.B)
        previewBox.BackgroundColor3 = currentColor
        task.spawn(callback, currentColor)
    end)
    
    local bSetter = createColorChannelSlider("B", currentColor.B, Color3.fromRGB(77, 148, 255), function(val)
        currentColor = Color3.new(currentColor.R, currentColor.G, val)
        previewBox.BackgroundColor3 = currentColor
        task.spawn(callback, currentColor)
    end)
    
    toggleBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            Animations.Tween(colorCard, 0.25, {Size = UDim2.new(1, 0, 0, 204)}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        else
            Animations.Tween(colorCard, 0.25, {Size = UDim2.new(1, 0, 0, 48)}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        end
    end)
    
    local colorObj = {
        Frame = colorCard,
        Title = name,
        Type = "ColorPicker"
    }
    function colorObj:SetValue(newColor)
        currentColor = newColor
        previewBox.BackgroundColor3 = currentColor
        rSetter(currentColor.R)
        gSetter(currentColor.G)
        bSetter(currentColor.B)
        task.spawn(callback, currentColor)
    end
    function colorObj:GetValue()
        return currentColor
    end
    
    ConfigSystem.RegisterFlag(flag, colorObj)
    return colorObj
end

--------------------------------------------------------------------------------
-- 8. CREATE KEYBIND (Keyboard & Mobile Touch Trigger Button!)
--------------------------------------------------------------------------------
function Elements.CreateKeybind(parentContainer, options)
    options = options or {}
    local name = options.Name or "Keybind"
    local defaultKey = options.CurrentKeybind or options.Default or Enum.KeyCode.RightShift
    if typeof(defaultKey) == "string" then
        pcall(function() defaultKey = Enum.KeyCode[defaultKey] end)
    end
    local callback = options.Callback or function() end
    local flag = options.Flag or name
    
    local currentKey = defaultKey
    local isListening = false
    
    local keybindCard = Instance.new("Frame")
    keybindCard.Name = "Keybind_" .. name
    keybindCard.Size = UDim2.new(1, 0, 0, 48)
    keybindCard.BackgroundColor3 = Config.Colors.Card
    keybindCard.BorderSizePixel = 0
    keybindCard.Parent = parentContainer
    Utilities.CreateCorner(keybindCard, Config.Settings.SmallCornerRadius)
    Utilities.CreateStroke(keybindCard, Config.Colors.Border, 1)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.5, -14, 1, 0)
    titleLabel.Position = UDim2.new(0, 14, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = name
    titleLabel.Font = Config.Fonts.Semibold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = Config.Colors.TextWhite
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = keybindCard
    
    local keyBox = Instance.new("Frame")
    keyBox.Size = UDim2.new(0, 110, 0, 28)
    keyBox.Position = UDim2.new(1, -124, 0.5, -14)
    keyBox.BackgroundColor3 = Config.Colors.Secondary
    keyBox.BorderSizePixel = 0
    keyBox.Parent = keybindCard
    Utilities.CreateCorner(keyBox, Config.Settings.SmallCornerRadius)
    local keyStroke = Utilities.CreateStroke(keyBox, Config.Colors.Border, 1)
    
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Size = UDim2.new(1, 0, 1, 0)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Text = currentKey and currentKey.Name or "None"
    keyLabel.Font = Config.Fonts.Bold
    keyLabel.TextSize = 12
    keyLabel.TextColor3 = Config.Colors.PrimaryRed
    keyLabel.Parent = keyBox
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = keybindCard
    
    btn.MouseButton1Click:Connect(function()
        if Utilities.IsMobile() then
            -- On mobile touch, directly trigger keybind callback since keyboard isn't used!
            Animations.Bounce(keyBox, UDim2.new(0, 100, 0, 24), 0.12)
            Utilities.PlaySound("6031068425", 0.4)
            task.spawn(callback, currentKey)
        else
            isListening = true
            keyLabel.Text = "Press any key..."
            Animations.Tween(keyStroke, 0.2, {Color = Config.Colors.PrimaryRed})
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if isListening and input.UserInputType == Enum.UserInputType.Keyboard then
            isListening = false
            currentKey = input.KeyCode
            keyLabel.Text = currentKey.Name
            Animations.Tween(keyStroke, 0.2, {Color = Config.Colors.Border})
            task.spawn(callback, currentKey)
        elseif not gameProcessed and input.KeyCode == currentKey and currentKey ~= Enum.KeyCode.Unknown then
            Animations.Bounce(keyBox, UDim2.new(0, 100, 0, 24), 0.12)
            Utilities.PlaySound("6031068425", 0.3)
            task.spawn(callback, currentKey)
        end
    end)
    
    local keybindObj = {
        Frame = keybindCard,
        Title = name,
        Type = "Keybind"
    }
    function keybindObj:SetValue(key)
        if typeof(key) == "string" then
            pcall(function() key = Enum.KeyCode[key] end)
        end
        currentKey = key
        keyLabel.Text = currentKey and currentKey.Name or "None"
    end
    function keybindObj:GetValue()
        return currentKey
    end
    
    ConfigSystem.RegisterFlag(flag, keybindObj)
    return keybindObj
end

--------------------------------------------------------------------------------
-- 9. CREATE LABEL
--------------------------------------------------------------------------------
function Elements.CreateLabel(parentContainer, options)
    options = options or {}
    local text = options.Text or "Label Text"
    local color = options.Color or Config.Colors.TextWhite
    local icon = options.Icon
    
    local labelCard = Instance.new("Frame")
    labelCard.Name = "Label"
    labelCard.Size = UDim2.new(1, 0, 0, 36)
    labelCard.BackgroundTransparency = 1
    labelCard.Parent = parentContainer
    
    local iconLabel = nil
    if icon then
        iconLabel = Instance.new("ImageLabel")
        iconLabel.Size = UDim2.new(0, 20, 0, 20)
        iconLabel.Position = UDim2.new(0, 14, 0.5, -10)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Image = Icons.Get(icon)
        iconLabel.ImageColor3 = color
        iconLabel.Parent = labelCard
    end
    
    local txtLbl = Instance.new("TextLabel")
    txtLbl.Size = icon and UDim2.new(1, -44, 1, 0) or UDim2.new(1, -28, 1, 0)
    txtLbl.Position = icon and UDim2.new(0, 42, 0, 0) or UDim2.new(0, 14, 0, 0)
    txtLbl.BackgroundTransparency = 1
    txtLbl.Text = text
    txtLbl.Font = Config.Fonts.Regular
    txtLbl.TextSize = 14
    txtLbl.TextColor3 = color
    txtLbl.TextXAlignment = Enum.TextXAlignment.Left
    txtLbl.Parent = labelCard
    
    return {
        Frame = labelCard,
        SetText = function(self, newText)
            txtLbl.Text = tostring(newText)
        end
    }
end

--------------------------------------------------------------------------------
-- 10. CREATE PARAGRAPH
--------------------------------------------------------------------------------
function Elements.CreateParagraph(parentContainer, options)
    options = options or {}
    local title = options.Title or "Paragraph Title"
    local content = options.Content or "Paragraph content description..."
    
    local paraCard = Instance.new("Frame")
    paraCard.Name = "Paragraph"
    paraCard.Size = UDim2.new(1, 0, 0, 0)
    paraCard.BackgroundColor3 = Config.Colors.Card
    paraCard.BorderSizePixel = 0
    paraCard.AutomaticSize = Enum.AutomaticSize.Y
    paraCard.Parent = parentContainer
    Utilities.CreateCorner(paraCard, Config.Settings.SmallCornerRadius)
    Utilities.CreateStroke(paraCard, Config.Colors.Border, 1)
    Utilities.CreatePadding(paraCard, 12, 12, 14, 14)
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, 0, 0, 20)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.Font = Config.Fonts.Bold
    titleLbl.TextSize = 15
    titleLbl.TextColor3 = Config.Colors.PrimaryRed
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = paraCard
    
    local contentLbl = Instance.new("TextLabel")
    contentLbl.Size = UDim2.new(1, 0, 0, 0)
    contentLbl.Position = UDim2.new(0, 0, 0, 24)
    contentLbl.BackgroundTransparency = 1
    contentLbl.Text = content
    contentLbl.Font = Config.Fonts.Regular
    contentLbl.TextSize = 13
    contentLbl.TextColor3 = Config.Colors.TextGray
    contentLbl.TextXAlignment = Enum.TextXAlignment.Left
    contentLbl.TextWrapped = true
    contentLbl.AutomaticSize = Enum.AutomaticSize.Y
    contentLbl.Parent = paraCard
    
    return {
        Frame = paraCard,
        SetContent = function(self, newTitle, newContent)
            if newTitle then titleLbl.Text = newTitle end
            if newContent then contentLbl.Text = newContent end
        end
    }
end

--------------------------------------------------------------------------------
-- 11. CREATE PROGRESS BAR
--------------------------------------------------------------------------------
function Elements.CreateProgressBar(parentContainer, options)
    options = options or {}
    local name = options.Name or "Progress"
    local progress = options.Progress or 0
    local maxVal = options.Max or 100
    local color = options.Color or Config.Colors.PrimaryRed
    
    local progressCard = Instance.new("Frame")
    progressCard.Name = "ProgressBar_" .. name
    progressCard.Size = UDim2.new(1, 0, 0, 52)
    progressCard.BackgroundColor3 = Config.Colors.Card
    progressCard.BorderSizePixel = 0
    progressCard.Parent = parentContainer
    Utilities.CreateCorner(progressCard, Config.Settings.SmallCornerRadius)
    Utilities.CreateStroke(progressCard, Config.Colors.Border, 1)
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(0.6, 0, 0, 22)
    titleLbl.Position = UDim2.new(0, 14, 0, 6)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = name
    titleLbl.Font = Config.Fonts.Semibold
    titleLbl.TextSize = 13
    titleLbl.TextColor3 = Config.Colors.TextWhite
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = progressCard
    
    local pctLbl = Instance.new("TextLabel")
    pctLbl.Size = UDim2.new(0.35, 0, 0, 22)
    pctLbl.Position = UDim2.new(0.6, 0, 0, 6)
    pctLbl.BackgroundTransparency = 1
    pctLbl.Text = string.format("%.0f%%", (progress/maxVal)*100)
    pctLbl.Font = Config.Fonts.Bold
    pctLbl.TextSize = 13
    pctLbl.TextColor3 = color
    pctLbl.TextXAlignment = Enum.TextXAlignment.Right
    pctLbl.Parent = progressCard
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -28, 0, 8)
    track.Position = UDim2.new(0, 14, 0, 34)
    track.BackgroundColor3 = Config.Colors.Secondary
    track.BorderSizePixel = 0
    track.Parent = progressCard
    Utilities.CreateCorner(track, UDim.new(1, 0))
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(math.clamp(progress/maxVal, 0, 1), 0, 1, 0)
    fill.BackgroundColor3 = color
    fill.BorderSizePixel = 0
    fill.Parent = track
    Utilities.CreateCorner(fill, UDim.new(1, 0))
    
    return {
        Frame = progressCard,
        SetProgress = function(self, val)
            progress = val
            pctLbl.Text = string.format("%.0f%%", (progress/maxVal)*100)
            Animations.Tween(fill, 0.25, {Size = UDim2.new(math.clamp(progress/maxVal, 0, 1), 0, 1, 0)})
        end
    }
end

--------------------------------------------------------------------------------
-- 12. CREATE STATUS
--------------------------------------------------------------------------------
function Elements.CreateStatus(parentContainer, options)
    options = options or {}
    local name = options.Name or "Status"
    local statusText = options.Status or "Online"
    local color = options.Color or Config.Colors.Success
    if statusText == "Offline" or statusText == "Error" then color = Config.Colors.Error end
    if statusText == "Warning" or statusText == "Loading" then color = Config.Colors.Warning end
    
    local statusCard = Instance.new("Frame")
    statusCard.Name = "Status_" .. name
    statusCard.Size = UDim2.new(1, 0, 0, 44)
    statusCard.BackgroundColor3 = Config.Colors.Card
    statusCard.BorderSizePixel = 0
    statusCard.Parent = parentContainer
    Utilities.CreateCorner(statusCard, Config.Settings.SmallCornerRadius)
    Utilities.CreateStroke(statusCard, Config.Colors.Border, 1)
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(0.5, -14, 1, 0)
    titleLbl.Position = UDim2.new(0, 14, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = name
    titleLbl.Font = Config.Fonts.Semibold
    titleLbl.TextSize = 14
    titleLbl.TextColor3 = Config.Colors.TextWhite
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = statusCard
    
    local statusPill = Instance.new("Frame")
    statusPill.Size = UDim2.new(0, 90, 0, 26)
    statusPill.Position = UDim2.new(1, -104, 0.5, -13)
    statusPill.BackgroundColor3 = Config.Colors.Secondary
    statusPill.BorderSizePixel = 0
    statusPill.Parent = statusCard
    Utilities.CreateCorner(statusPill, UDim.new(1, 0))
    Utilities.CreateStroke(statusPill, color, 1)
    
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new(0, 10, 0.5, -4)
    dot.BackgroundColor3 = color
    dot.BorderSizePixel = 0
    dot.Parent = statusPill
    Utilities.CreateCorner(dot, UDim.new(1, 0))
    
    -- Pulsing glow animation
    task.spawn(function()
        while statusCard and statusCard.Parent do
            Animations.Tween(dot, 0.8, {BackgroundTransparency = 0.6})
            task.wait(0.85)
            Animations.Tween(dot, 0.8, {BackgroundTransparency = 0})
            task.wait(0.85)
        end
    end)
    
    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size = UDim2.new(1, -26, 1, 0)
    statusLbl.Position = UDim2.new(0, 22, 0, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = statusText
    statusLbl.Font = Config.Fonts.Bold
    statusLbl.TextSize = 12
    statusLbl.TextColor3 = color
    statusLbl.TextXAlignment = Enum.TextXAlignment.Center
    statusLbl.Parent = statusPill
    
    return {
        Frame = statusCard,
        SetStatus = function(self, newStatus, newColor)
            statusLbl.Text = newStatus
            if newColor then
                dot.BackgroundColor3 = newColor
                statusLbl.TextColor3 = newColor
            end
        end
    }
end

--------------------------------------------------------------------------------
-- 13. CREATE DIVIDER
--------------------------------------------------------------------------------
function Elements.CreateDivider(parentContainer, options)
    options = options or {}
    local text = options.Text or ""
    
    local dividerFrame = Instance.new("Frame")
    dividerFrame.Name = "Divider"
    dividerFrame.Size = UDim2.new(1, 0, 0, text ~= "" and 30 or 16)
    dividerFrame.BackgroundTransparency = 1
    dividerFrame.Parent = parentContainer
    
    if text ~= "" then
        local lineLeft = Instance.new("Frame")
        lineLeft.Size = UDim2.new(0.4, -20, 0, 1)
        lineLeft.Position = UDim2.new(0, 0, 0.5, 0)
        lineLeft.BackgroundColor3 = Config.Colors.Border
        lineLeft.BorderSizePixel = 0
        lineLeft.Parent = dividerFrame
        
        local txtLbl = Instance.new("TextLabel")
        txtLbl.Size = UDim2.new(0.2, 40, 1, 0)
        txtLbl.Position = UDim2.new(0.4, -20, 0, 0)
        txtLbl.BackgroundTransparency = 1
        txtLbl.Text = text
        txtLbl.Font = Config.Fonts.Semibold
        txtLbl.TextSize = 12
        txtLbl.TextColor3 = Config.Colors.Placeholder
        txtLbl.TextXAlignment = Enum.TextXAlignment.Center
        txtLbl.Parent = dividerFrame
        
        local lineRight = Instance.new("Frame")
        lineRight.Size = UDim2.new(0.4, -20, 0, 1)
        lineRight.Position = UDim2.new(0.6, 20, 0.5, 0)
        lineRight.BackgroundColor3 = Config.Colors.Border
        lineRight.BorderSizePixel = 0
        lineRight.Parent = dividerFrame
    else
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, 0, 0, 1)
        line.Position = UDim2.new(0, 0, 0.5, 0)
        line.BackgroundColor3 = Config.Colors.Border
        line.BorderSizePixel = 0
        line.Parent = dividerFrame
    end
    
    return {Frame = dividerFrame}
end

--------------------------------------------------------------------------------
-- 14. CREATE IMAGE
--------------------------------------------------------------------------------
function Elements.CreateImage(parentContainer, options)
    options = options or {}
    local imageId = Icons.Get(options.Image or Config.Assets.Logo)
    local height = options.Height or 150
    
    local imageCard = Instance.new("Frame")
    imageCard.Name = "ImageCard"
    imageCard.Size = UDim2.new(1, 0, 0, height)
    imageCard.BackgroundColor3 = Config.Colors.Card
    imageCard.BorderSizePixel = 0
    imageCard.ClipsDescendants = true
    imageCard.Parent = parentContainer
    Utilities.CreateCorner(imageCard, Config.Settings.SmallCornerRadius)
    Utilities.CreateStroke(imageCard, Config.Colors.Border, 1)
    
    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1, 0, 1, 0)
    img.BackgroundTransparency = 1
    img.Image = imageId
    img.ScaleType = Enum.ScaleType.Fit
    img.Parent = imageCard
    
    return {
        Frame = imageCard,
        SetImage = function(self, newId)
            img.Image = Icons.Get(newId)
        end
    }
end

--------------------------------------------------------------------------------
-- 15. CREATE INPUT
--------------------------------------------------------------------------------
function Elements.CreateInput(parentContainer, options)
    options = options or {}
    options.Name = options.Name or "Quick Input"
    return Elements.CreateTextbox(parentContainer, options)
end

--------------------------------------------------------------------------------
-- 16. CREATE CONSOLE (Mini Built-In Logger)
--------------------------------------------------------------------------------
function Elements.CreateConsole(parentContainer, options)
    options = options or {}
    local name = options.Name or "Console Logs"
    local maxLines = options.MaxLines or 50
    
    local consoleCard = Instance.new("Frame")
    consoleCard.Name = "Console_" .. name
    consoleCard.Size = UDim2.new(1, 0, 0, 180)
    consoleCard.BackgroundColor3 = Config.Colors.Card
    consoleCard.BorderSizePixel = 0
    consoleCard.Parent = parentContainer
    Utilities.CreateCorner(consoleCard, Config.Settings.SmallCornerRadius)
    Utilities.CreateStroke(consoleCard, Config.Colors.Border, 1)
    
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 32)
    titleBar.BackgroundColor3 = Config.Colors.Secondary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = consoleCard
    Utilities.CreateCorner(titleBar, Config.Settings.SmallCornerRadius)
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -80, 1, 0)
    titleLbl.Position = UDim2.new(0, 12, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "🖥️ " .. name
    titleLbl.Font = Config.Fonts.Semibold
    titleLbl.TextSize = 13
    titleLbl.TextColor3 = Config.Colors.TextWhite
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = titleBar
    
    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(0, 60, 0, 22)
    clearBtn.Position = UDim2.new(1, -68, 0.5, -11)
    clearBtn.BackgroundColor3 = Config.Colors.Card
    clearBtn.Font = Config.Fonts.Bold
    clearBtn.TextSize = 11
    clearBtn.TextColor3 = Config.Colors.PrimaryRed
    clearBtn.Text = "CLEAR"
    clearBtn.Parent = titleBar
    Utilities.CreateCorner(clearBtn, UDim.new(0, 4))
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -16, 1, -40)
    scroll.Position = UDim2.new(0, 8, 0, 36)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Config.Colors.PrimaryRed
    scroll.Parent = consoleCard
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.Parent = scroll
    
    local lines = {}
    
    local function addLog(msg, color)
        if #lines >= maxLines then
            local first = table.remove(lines, 1)
            if first and first.Parent then first:Destroy() end
        end
        local lineLbl = Instance.new("TextLabel")
        lineLbl.Size = UDim2.new(1, 0, 0, 18)
        lineLbl.BackgroundTransparency = 1
        lineLbl.Text = string.format("[%s] %s", os.date("%H:%M:%S"), tostring(msg))
        lineLbl.Font = Config.Fonts.Monospace
        lineLbl.TextSize = 12
        lineLbl.TextColor3 = color or Config.Colors.TextGray
        lineLbl.TextXAlignment = Enum.TextXAlignment.Left
        lineLbl.Parent = scroll
        table.insert(lines, lineLbl)
    end
    
    clearBtn.MouseButton1Click:Connect(function()
        for _, l in ipairs(lines) do l:Destroy() end
        lines = {}
    end)
    
    addLog("Console initialized. Ready for logs.", Config.Colors.Success)
    
    return {
        Frame = consoleCard,
        Log = function(self, msg, color) addLog(msg, color or Config.Colors.TextWhite) end,
        Warn = function(self, msg) addLog(msg, Config.Colors.Warning) end,
        Error = function(self, msg) addLog(msg, Config.Colors.Error) end,
        Clear = function(self)
            for _, l in ipairs(lines) do l:Destroy() end
            lines = {}
        end
    }
end

--------------------------------------------------------------------------------
-- 17. CREATE CODE BLOCK (Monospaced with Copy to Clipboard button!)
--------------------------------------------------------------------------------
function Elements.CreateCodeBlock(parentContainer, options)
    options = options or {}
    local code = options.Code or "-- Lua Script Example\nprint('Hello BloodMoon!')"
    local language = options.Language or "Lua"
    
    local codeCard = Instance.new("Frame")
    codeCard.Name = "CodeBlock"
    codeCard.Size = UDim2.new(1, 0, 0, 140)
    codeCard.BackgroundColor3 = Config.Colors.Card
    codeCard.BorderSizePixel = 0
    codeCard.Parent = parentContainer
    Utilities.CreateCorner(codeCard, Config.Settings.SmallCornerRadius)
    Utilities.CreateStroke(codeCard, Config.Colors.Border, 1)
    
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 28)
    topBar.BackgroundColor3 = Config.Colors.Secondary
    topBar.BorderSizePixel = 0
    topBar.Parent = codeCard
    Utilities.CreateCorner(topBar, Config.Settings.SmallCornerRadius)
    
    local langLbl = Instance.new("TextLabel")
    langLbl.Size = UDim2.new(0.5, 0, 1, 0)
    langLbl.Position = UDim2.new(0, 12, 0, 0)
    langLbl.BackgroundTransparency = 1
    langLbl.Text = string.upper(language) .. " CODE"
    langLbl.Font = Config.Fonts.Bold
    langLbl.TextSize = 11
    langLbl.TextColor3 = Config.Colors.PrimaryRed
    langLbl.TextXAlignment = Enum.TextXAlignment.Left
    langLbl.Parent = topBar
    
    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0, 80, 0, 20)
    copyBtn.Position = UDim2.new(1, -88, 0.5, -10)
    copyBtn.BackgroundColor3 = Config.Colors.Card
    copyBtn.Font = Config.Fonts.Bold
    copyBtn.TextSize = 11
    copyBtn.TextColor3 = Config.Colors.TextWhite
    copyBtn.Text = "📋 COPY"
    copyBtn.Parent = topBar
    Utilities.CreateCorner(copyBtn, UDim.new(0, 4))
    
    local codeBox = Instance.new("TextLabel")
    codeBox.Size = UDim2.new(1, -24, 1, -36)
    codeBox.Position = UDim2.new(0, 12, 0, 32)
    codeBox.BackgroundTransparency = 1
    codeBox.Text = code
    codeBox.Font = Config.Fonts.Monospace
    codeBox.TextSize = 12
    codeBox.TextColor3 = Config.Colors.TextGray
    codeBox.TextXAlignment = Enum.TextXAlignment.Left
    codeBox.TextYAlignment = Enum.TextYAlignment.Top
    codeBox.Parent = codeCard
    
    copyBtn.MouseButton1Click:Connect(function()
        Utilities.SetClipboard(code)
        copyBtn.Text = "✅ COPIED!"
        copyBtn.TextColor3 = Config.Colors.Success
        task.wait(1.5)
        if copyBtn and copyBtn.Parent then
            copyBtn.Text = "📋 COPY"
            copyBtn.TextColor3 = Config.Colors.TextWhite
        end
    end)
    
    return {Frame = codeCard}
end

--------------------------------------------------------------------------------
-- 18. CREATE TERMINAL (Interactive Command Prompt inside UI!)
--------------------------------------------------------------------------------
function Elements.CreateTerminal(parentContainer, options)
    options = options or {}
    local name = options.Name or "Interactive Terminal"
    local prompt = options.Prompt or "BloodMoon> "
    local onCommand = options.OnCommand or function(cmd) return "Executed: " .. cmd end
    
    local termCard = Instance.new("Frame")
    termCard.Name = "Terminal_" .. name
    termCard.Size = UDim2.new(1, 0, 0, 160)
    termCard.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    termCard.BorderSizePixel = 0
    termCard.Parent = parentContainer
    Utilities.CreateCorner(termCard, Config.Settings.SmallCornerRadius)
    Utilities.CreateStroke(termCard, Config.Colors.PrimaryRed, 1)
    
    local outputScroll = Instance.new("ScrollingFrame")
    outputScroll.Size = UDim2.new(1, -16, 1, -40)
    outputScroll.Position = UDim2.new(0, 8, 0, 8)
    outputScroll.BackgroundTransparency = 1
    outputScroll.BorderSizePixel = 0
    outputScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    outputScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    outputScroll.Parent = termCard
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.Parent = outputScroll
    
    local function addTermLine(txt, color)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 0, 16)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.Font = Config.Fonts.Monospace
        l.TextSize = 12
        l.TextColor3 = color or Config.Colors.TextWhite
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = outputScroll
    end
    
    addTermLine("🌙 BloodMoon OS Terminal v2.0.0 Ready. Type 'help' for commands.", Config.Colors.PrimaryRed)
    
    local inputBar = Instance.new("Frame")
    inputBar.Size = UDim2.new(1, -16, 0, 26)
    inputBar.Position = UDim2.new(0, 8, 1, -32)
    inputBar.BackgroundColor3 = Config.Colors.Card
    inputBar.BorderSizePixel = 0
    inputBar.Parent = termCard
    Utilities.CreateCorner(inputBar, UDim.new(0, 4))
    
    local promptLbl = Instance.new("TextLabel")
    promptLbl.Size = UDim2.new(0, 85, 1, 0)
    promptLbl.Position = UDim2.new(0, 6, 0, 0)
    promptLbl.BackgroundTransparency = 1
    promptLbl.Text = prompt
    promptLbl.Font = Config.Fonts.Monospace
    promptLbl.TextSize = 12
    promptLbl.TextColor3 = Config.Colors.PrimaryRed
    promptLbl.TextXAlignment = Enum.TextXAlignment.Left
    promptLbl.Parent = inputBar
    
    local cmdBox = Instance.new("TextBox")
    cmdBox.Size = UDim2.new(1, -95, 1, 0)
    cmdBox.Position = UDim2.new(0, 90, 0, 0)
    cmdBox.BackgroundTransparency = 1
    cmdBox.Text = ""
    cmdBox.PlaceholderText = "type command..."
    cmdBox.PlaceholderColor3 = Config.Colors.Placeholder
    cmdBox.Font = Config.Fonts.Monospace
    cmdBox.TextSize = 12
    cmdBox.TextColor3 = Config.Colors.TextWhite
    cmdBox.TextXAlignment = Enum.TextXAlignment.Left
    cmdBox.ClearTextOnFocus = true
    cmdBox.Parent = inputBar
    
    cmdBox.FocusLost:Connect(function(enter)
        if enter and cmdBox.Text ~= "" then
            local cmd = cmdBox.Text
            addTermLine(prompt .. cmd, Config.Colors.TextWhite)
            if cmd == "clear" then
                for _, ch in ipairs(outputScroll:GetChildren()) do
                    if ch:IsA("TextLabel") then ch:Destroy() end
                end
            elseif cmd == "help" then
                addTermLine("Commands: clear, help, version, status, or custom commands.", Config.Colors.Warning)
            else
                local res = onCommand(cmd)
                if res then addTermLine(tostring(res), Config.Colors.Success) end
            end
            cmdBox.Text = ""
        end
    end)
    
    return {Frame = termCard, AddOutput = addTermLine}
end

--------------------------------------------------------------------------------
-- 19. CREATE BADGE
--------------------------------------------------------------------------------
function Elements.CreateBadge(parentContainer, options)
    options = options or {}
    local text = options.Text or "NEW"
    local color = options.Color or Config.Colors.PrimaryRed
    
    local badgeFrame = Instance.new("Frame")
    badgeFrame.Size = UDim2.new(0, 50, 0, 22)
    badgeFrame.BackgroundColor3 = color
    badgeFrame.BorderSizePixel = 0
    badgeFrame.Parent = parentContainer
    Utilities.CreateCorner(badgeFrame, UDim.new(1, 0))
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Config.Fonts.Bold
    lbl.TextSize = 11
    lbl.TextColor3 = Config.Colors.TextWhite
    lbl.Parent = badgeFrame
    
    return {Frame = badgeFrame}
end

--------------------------------------------------------------------------------
-- 20. CREATE CHIP
--------------------------------------------------------------------------------
function Elements.CreateChip(parentContainer, options)
    options = options or {}
    local text = options.Text or "Tag Chip"
    local closable = options.Closable == nil and true or options.Closable
    local onClose = options.OnClose or function() end
    
    local chipFrame = Instance.new("Frame")
    chipFrame.Size = UDim2.new(0, 100, 0, 28)
    chipFrame.BackgroundColor3 = Config.Colors.Secondary
    chipFrame.BorderSizePixel = 0
    chipFrame.Parent = parentContainer
    Utilities.CreateCorner(chipFrame, UDim.new(1, 0))
    Utilities.CreateStroke(chipFrame, Config.Colors.Border, 1)
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = closable and UDim2.new(1, -32, 1, 0) or UDim2.new(1, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Config.Fonts.Semibold
    lbl.TextSize = 12
    lbl.TextColor3 = Config.Colors.TextWhite
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = chipFrame
    
    if closable then
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 20, 0, 20)
        closeBtn.Position = UDim2.new(1, -24, 0.5, -10)
        closeBtn.BackgroundColor3 = Config.Colors.Card
        closeBtn.Text = "×"
        closeBtn.Font = Config.Fonts.Bold
        closeBtn.TextSize = 14
        closeBtn.TextColor3 = Config.Colors.PrimaryRed
        closeBtn.Parent = chipFrame
        Utilities.CreateCorner(closeBtn, UDim.new(1, 0))
        
        closeBtn.MouseButton1Click:Connect(function()
            Animations.Tween(chipFrame, 0.15, {Size = UDim2.new(0, 0, 0, 28), BackgroundTransparency = 1})
            task.wait(0.15)
            chipFrame:Destroy()
            task.spawn(onClose)
        end)
    end
    
    return {Frame = chipFrame}
end

--------------------------------------------------------------------------------
-- 21. CREATE SWITCH
--------------------------------------------------------------------------------
function Elements.CreateSwitch(parentContainer, options)
    return Elements.CreateToggle(parentContainer, options)
end

--------------------------------------------------------------------------------
-- 22. CREATE LOADING (Spinner & Bar)
--------------------------------------------------------------------------------
function Elements.CreateLoading(parentContainer, options)
    options = options or {}
    local text = options.Name or "Loading data..."
    
    local loadCard = Instance.new("Frame")
    loadCard.Name = "Loading"
    loadCard.Size = UDim2.new(1, 0, 0, 44)
    loadCard.BackgroundColor3 = Config.Colors.Card
    loadCard.BorderSizePixel = 0
    loadCard.Parent = parentContainer
    Utilities.CreateCorner(loadCard, Config.Settings.SmallCornerRadius)
    Utilities.CreateStroke(loadCard, Config.Colors.Border, 1)
    
    local spinner = Instance.new("ImageLabel")
    spinner.Size = UDim2.new(0, 22, 0, 22)
    spinner.Position = UDim2.new(0, 14, 0.5, -11)
    spinner.BackgroundTransparency = 1
    spinner.Image = "rbxassetid://6031094678" -- Or refresh icon
    spinner.ImageColor3 = Config.Colors.PrimaryRed
    spinner.Parent = loadCard
    
    task.spawn(function()
        local rot = 0
        while loadCard and loadCard.Parent do
            rot = (rot + 8) % 360
            spinner.Rotation = rot
            task.wait()
        end
    end)
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 46, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Config.Fonts.Semibold
    lbl.TextSize = 13
    lbl.TextColor3 = Config.Colors.TextWhite
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = loadCard
    
    return {Frame = loadCard}
end

--------------------------------------------------------------------------------
-- 23. CREATE MINI BUTTON
--------------------------------------------------------------------------------
function Elements.CreateMiniButton(parentContainer, options)
    options = options or {}
    local name = options.Name or "Action"
    local callback = options.Callback or function() end
    
    local miniBtn = Instance.new("TextButton")
    miniBtn.Size = UDim2.new(0, 110, 0, 32)
    miniBtn.BackgroundColor3 = Config.Colors.Secondary
    miniBtn.BorderSizePixel = 0
    miniBtn.Font = Config.Fonts.Semibold
    miniBtn.TextSize = 13
    miniBtn.TextColor3 = Config.Colors.TextWhite
    miniBtn.Text = name
    miniBtn.Parent = parentContainer
    Utilities.CreateCorner(miniBtn, Config.Settings.SmallCornerRadius)
    local stroke = Utilities.CreateStroke(miniBtn, Config.Colors.Border, 1)
    
    miniBtn.MouseEnter:Connect(function()
        Animations.Tween(miniBtn, 0.15, {BackgroundColor3 = Config.Colors.PrimaryRed})
        Animations.Tween(stroke, 0.15, {Color = Config.Colors.HoverRed})
    end)
    miniBtn.MouseLeave:Connect(function()
        Animations.Tween(miniBtn, 0.15, {BackgroundColor3 = Config.Colors.Secondary})
        Animations.Tween(stroke, 0.15, {Color = Config.Colors.Border})
    end)
    miniBtn.MouseButton1Click:Connect(function()
        Animations.Bounce(miniBtn, UDim2.new(0, 102, 0, 28), 0.12)
        Utilities.PlaySound("6031068425", 0.4)
        task.spawn(callback)
    end)
    
    return {Frame = miniBtn}
end

--------------------------------------------------------------------------------
-- 24. CREATE FOOTER
--------------------------------------------------------------------------------
function Elements.CreateFooter(parentContainer, options)
    options = options or {}
    local text = options.Text or "Powered by Nexzan Hub | 🌙 BloodMoon UI v2.0.0"
    
    local footerFrame = Instance.new("Frame")
    footerFrame.Name = "Footer"
    footerFrame.Size = UDim2.new(1, 0, 0, 36)
    footerFrame.BackgroundTransparency = 1
    footerFrame.Parent = parentContainer
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Config.Fonts.Semibold
    lbl.TextSize = 12
    lbl.TextColor3 = Config.Colors.Placeholder
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.Parent = footerFrame
    
    return {Frame = footerFrame}
end

Modules.Elements = Elements
end

-- ============================================================================
-- MODULE: Tab
-- ============================================================================
do

local TweenService = game:GetService("TweenService")
local Config = Modules.Config
local Utilities = Modules.Utilities
local Animations = Modules.Animations
local Icons = Modules.Icons
local Elements = Modules.Elements

local Tab = {}
Tab.__index = Tab

function Tab.new(windowInstance, tabName, iconName)
    local self = setmetatable({}, Tab)
    
    self.Window = windowInstance
    self.Name = tabName or "Tab"
    self.Icon = Icons.Get(iconName or tabName)
    self.ElementsList = {}
    self.SectionsList = {}
    
    -- 1. Create Sidebar Button
    local sidebarScroll = windowInstance.SidebarScroll
    
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "TabBtn_" .. self.Name
    tabButton.Size = UDim2.new(1, -12, 0, 40)
    tabButton.BackgroundColor3 = Config.Colors.Background
    tabButton.BackgroundTransparency = 1
    tabButton.BorderSizePixel = 0
    tabButton.Text = ""
    tabButton.AutoButtonColor = false
    tabButton.Parent = sidebarScroll
    Utilities.CreateCorner(tabButton, Config.Settings.SmallCornerRadius)
    
    local activeIndicator = Instance.new("Frame")
    activeIndicator.Name = "ActiveIndicator"
    activeIndicator.Size = UDim2.new(0, 4, 0, 22)
    activeIndicator.Position = UDim2.new(0, 4, 0.5, -11)
    activeIndicator.BackgroundColor3 = Config.Colors.PrimaryRed
    activeIndicator.BorderSizePixel = 0
    activeIndicator.BackgroundTransparency = 1 -- Hidden by default
    activeIndicator.Parent = tabButton
    Utilities.CreateCorner(activeIndicator, UDim.new(1, 0))
    
    local iconImage = Instance.new("ImageLabel")
    iconImage.Name = "Icon"
    iconImage.Size = UDim2.new(0, 20, 0, 20)
    iconImage.Position = UDim2.new(0, 16, 0.5, -10)
    iconImage.BackgroundTransparency = 1
    iconImage.Image = self.Icon
    iconImage.ImageColor3 = Config.Colors.TextGray
    iconImage.Parent = tabButton
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -48, 1, 0)
    titleLabel.Position = UDim2.new(0, 44, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = self.Name
    titleLabel.Font = Config.Fonts.Semibold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = Config.Colors.TextGray
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = tabButton
    
    self.Button = tabButton
    self.ActiveIndicator = activeIndicator
    self.IconImage = iconImage
    self.TitleLabel = titleLabel
    
    -- 2. Create Content Page Container (ScrollingFrame)
    local contentContainer = windowInstance.ContentContainer
    
    local pageFrame = Instance.new("ScrollingFrame")
    pageFrame.Name = "Page_" .. self.Name
    pageFrame.Size = UDim2.new(1, 0, 1, 0)
    pageFrame.BackgroundTransparency = 1
    pageFrame.BorderSizePixel = 0
    pageFrame.ScrollBarThickness = 4
    pageFrame.ScrollBarImageColor3 = Config.Colors.PrimaryRed
    pageFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    pageFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    pageFrame.ClipsDescendants = true
    pageFrame.Visible = false
    pageFrame.Parent = contentContainer
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 10)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = pageFrame
    
    Utilities.CreatePadding(pageFrame, 14, 20, 16, 16)
    
    self.Page = pageFrame
    
    -- 3. Connect Button Interactions
    tabButton.MouseEnter:Connect(function()
        if windowInstance.ActiveTab ~= self then
            Animations.Tween(tabButton, 0.15, {BackgroundTransparency = 0.6, BackgroundColor3 = Config.Colors.Secondary})
            Animations.Tween(titleLabel, 0.15, {TextColor3 = Config.Colors.TextWhite})
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if windowInstance.ActiveTab ~= self then
            Animations.Tween(tabButton, 0.15, {BackgroundTransparency = 1})
            Animations.Tween(titleLabel, 0.15, {TextColor3 = Config.Colors.TextGray})
        end
    end)
    
    tabButton.MouseButton1Click:Connect(function()
        Animations.CreateRipple(tabButton, tabButton.AbsolutePosition, Config.Colors.PrimaryRed)
        Utilities.PlaySound("6031068425", 0.4)
        windowInstance:SelectTab(self)
    end)
    
    -- Index for global search
    windowInstance:RegisterTabSearch(self)
    
    return self
end

function Tab:Show()
    self.Page.Visible = true
    Animations.Tween(self.Button, 0.2, {BackgroundTransparency = 0.2, BackgroundColor3 = Config.Colors.Secondary})
    Animations.Tween(self.TitleLabel, 0.2, {TextColor3 = Config.Colors.TextWhite, Font = Config.Fonts.Bold})
    Animations.Tween(self.IconImage, 0.2, {ImageColor3 = Config.Colors.PrimaryRed})
    Animations.Tween(self.ActiveIndicator, 0.2, {BackgroundTransparency = 0})
end

function Tab:Hide()
    self.Page.Visible = false
    Animations.Tween(self.Button, 0.2, {BackgroundTransparency = 1})
    Animations.Tween(self.TitleLabel, 0.2, {TextColor3 = Config.Colors.TextGray, Font = Config.Fonts.Semibold})
    Animations.Tween(self.IconImage, 0.2, {ImageColor3 = Config.Colors.TextGray})
    Animations.Tween(self.ActiveIndicator, 0.2, {BackgroundTransparency = 1})
end

--------------------------------------------------------------------------------
-- CREATE SECTION
--------------------------------------------------------------------------------
function Tab:CreateSection(sectionTitle)
    local sectionCard = Instance.new("Frame")
    sectionCard.Name = "Section_" .. tostring(sectionTitle)
    sectionCard.Size = UDim2.new(1, 0, 0, 0)
    sectionCard.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    sectionCard.BorderSizePixel = 0
    sectionCard.AutomaticSize = Enum.AutomaticSize.Y
    sectionCard.Parent = self.Page
    Utilities.CreateCorner(sectionCard, Config.Settings.CornerRadius)
    Utilities.CreateStroke(sectionCard, Config.Colors.Border, 1)
    
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 36)
    header.BackgroundTransparency = 1
    header.Parent = sectionCard
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -24, 1, 0)
    titleLbl.Position = UDim2.new(0, 12, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = string.upper(tostring(sectionTitle))
    titleLbl.Font = Config.Fonts.Bold
    titleLbl.TextSize = 12
    titleLbl.TextColor3 = Config.Colors.PrimaryRed
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = header
    
    local div = Instance.new("Frame")
    div.Size = UDim2.new(1, -24, 0, 1)
    div.Position = UDim2.new(0, 12, 0, 35)
    div.BackgroundColor3 = Config.Colors.Border
    div.BorderSizePixel = 0
    div.Parent = header
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "SectionContent"
    contentFrame.Size = UDim2.new(1, 0, 0, 0)
    contentFrame.Position = UDim2.new(0, 0, 0, 42)
    contentFrame.BackgroundTransparency = 1
    contentFrame.AutomaticSize = Enum.AutomaticSize.Y
    contentFrame.Parent = sectionCard
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = contentFrame
    
    Utilities.CreatePadding(contentFrame, 4, 12, 12, 12)
    
    local sectionObj = {
        Frame = sectionCard,
        Content = contentFrame,
        Title = sectionTitle
    }
    
    -- Attach all creation methods to section object
    for elemName, createFunc in pairs(Elements) do
        sectionObj[elemName] = function(selfSection, options)
            local elem = createFunc(selfSection.Content, options)
            if elem and elem.Frame then
                table.insert(self.ElementsList, elem)
                self.Window:RegisterElementSearch(elem, self)
            end
            return elem
        end
    end
    
    table.insert(self.SectionsList, sectionObj)
    self.Window:RegisterSectionSearch(sectionObj, self)
    return sectionObj
end

--------------------------------------------------------------------------------
-- PROXY ALL ELEMENT CREATION ON TAB DIRECTLY
--------------------------------------------------------------------------------
for elemName, createFunc in pairs(Elements) do
    Tab[elemName] = function(self, options)
        local elem = createFunc(self.Page, options)
        if elem and elem.Frame then
            table.insert(self.ElementsList, elem)
            self.Window:RegisterElementSearch(elem, self)
        end
        return elem
    end
end

Modules.Tab = Tab
end

-- ============================================================================
-- MODULE: Window
-- ============================================================================
do

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")

local Config = Modules.Config
local Utilities = Modules.Utilities
local Animations = Modules.Animations
local Icons = Modules.Icons
local Tab = Modules.Tab
local ConfigSystem = Modules.ConfigSystem

local LocalPlayer = Players.LocalPlayer

local Window = {}
Window.__index = Window

function Window.new(options)
    options = options or {}
    local self = setmetatable({}, Window)
    
    self.Name = options.Name or "BloodMoon Hub"
    self.Version = options.Version or "v2.0.0"
    self.Tabs = {}
    self.ActiveTab = nil
    self.SearchItems = {}
    self.Connections = Utilities.CreateConnectionManager()
    self.IsMinimized = false
    self.IsMaximized = false
    self.NormalSize = Config.Settings.WindowSize
    self.NormalPosition = UDim2.new(0.5, -self.NormalSize.X.Offset/2, 0.5, -self.NormalSize.Y.Offset/2)
    
    -- Initialize ConfigSystem folder/file if provided
    ConfigSystem.Init(options.ConfigFolder or "BloodMoonHub", options.ConfigFile or "config.json")
    
    -- 1. Create Target ScreenGui Container
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BloodMoonHubGui_" .. tostring(math.random(1000, 9999))
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 100
    
    local targetGui = Utilities.GetTargetGui()
    if pcall(function() screenGui.Parent = targetGui end) then
        -- Inserted successfully into optimal container
    else
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    self.ScreenGui = screenGui
    
    -- 2. Create Main Window Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainWindow"
    mainFrame.Size = self.NormalSize
    mainFrame.Position = self.NormalPosition
    mainFrame.BackgroundColor3 = Config.Colors.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    Utilities.CreateCorner(mainFrame, Config.Settings.CornerRadius)
    Utilities.CreateStroke(mainFrame, Config.Colors.Border, 1.2)
    self.MainFrame = mainFrame
    
    -- Responsive Auto-Scale for Mobile
    self.UIScale = Utilities.ApplyAutoResponsiveScale(mainFrame, 900, 560)
    
    -- 3. Background Anime BloodMoon (Slightly blurred / 20% opacity)
    local bgImage = Instance.new("ImageLabel")
    bgImage.Name = "BloodMoonBackground"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = Config.Assets.Logo -- Character/Theme in background
    bgImage.ImageTransparency = 1 - Config.DefaultColors.BackgroundOpacity -- ~0.8 (20% visible)
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 1
    bgImage.Parent = mainFrame
    self.BGImage = bgImage
    
    -- Soft Dark Overlay to ensure readability
    local darkOverlay = Instance.new("Frame")
    darkOverlay.Name = "DarkOverlay"
    darkOverlay.Size = UDim2.new(1, 0, 1, 0)
    darkOverlay.BackgroundColor3 = Config.Colors.Background
    darkOverlay.BackgroundTransparency = 0.25
    darkOverlay.BorderSizePixel = 0
    darkOverlay.ZIndex = 2
    darkOverlay.Parent = mainFrame
    
    -- Main Container inside Window
    local uiContainer = Instance.new("Frame")
    uiContainer.Name = "UIContainer"
    uiContainer.Size = UDim2.new(1, 0, 1, 0)
    uiContainer.BackgroundTransparency = 1
    uiContainer.ZIndex = 3
    uiContainer.Parent = mainFrame
    
    ----------------------------------------------------------------------------
    -- 4. HEADER (Left: Logo Bulat, Name, Version. Right: Minimize, Maximize, Close)
    ----------------------------------------------------------------------------
    local headerFrame = Instance.new("Frame")
    headerFrame.Name = "Header"
    headerFrame.Size = UDim2.new(1, 0, 0, Config.Settings.HeaderHeight)
    headerFrame.BackgroundColor3 = Config.Colors.Secondary
    headerFrame.BorderSizePixel = 0
    headerFrame.Parent = uiContainer
    
    local headerBorder = Instance.new("Frame")
    headerBorder.Size = UDim2.new(1, 0, 0, 1)
    headerBorder.Position = UDim2.new(0, 0, 1, -1)
    headerBorder.BackgroundColor3 = Config.Colors.Border
    headerBorder.BorderSizePixel = 0
    headerBorder.Parent = headerFrame
    
    -- Left Header Info
    local logoImage = Instance.new("ImageLabel")
    logoImage.Name = "Logo"
    logoImage.Size = UDim2.new(0, 32, 0, 32)
    logoImage.Position = UDim2.new(0, 14, 0.5, -16)
    logoImage.BackgroundColor3 = Config.Colors.PrimaryRed
    logoImage.Image = Config.Assets.Logo
    logoImage.Parent = headerFrame
    Utilities.CreateCorner(logoImage, UDim.new(1, 0))
    Utilities.CreateStroke(logoImage, Config.Colors.HoverRed, 1.5)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "HubTitle"
    titleLabel.Size = UDim2.new(0, 200, 0, 20)
    titleLabel.Position = UDim2.new(0, 56, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = self.Name
    titleLabel.Font = Config.Fonts.Bold
    titleLabel.TextSize = 16
    titleLabel.TextColor3 = Config.Colors.TextWhite
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = headerFrame
    
    local versionBadge = Instance.new("Frame")
    versionBadge.Name = "VersionBadge"
    versionBadge.Size = UDim2.new(0, 56, 0, 18)
    versionBadge.Position = UDim2.new(0, 56, 0, 28)
    versionBadge.BackgroundColor3 = Config.Colors.PrimaryRed
    versionBadge.BorderSizePixel = 0
    versionBadge.Parent = headerFrame
    Utilities.CreateCorner(versionBadge, UDim.new(0, 4))
    
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Size = UDim2.new(1, 0, 1, 0)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = self.Version
    versionLabel.Font = Config.Fonts.Bold
    versionLabel.TextSize = 11
    versionLabel.TextColor3 = Config.Colors.TextWhite
    versionLabel.Parent = versionBadge
    
    -- Make window draggable via Header
    Utilities.MakeDraggable(headerFrame, mainFrame)
    
    -- Right Header Buttons (Minimize, Maximize, Close)
    local buttonsContainer = Instance.new("Frame")
    buttonsContainer.Size = UDim2.new(0, 110, 1, 0)
    buttonsContainer.Position = UDim2.new(1, -118, 0, 0)
    buttonsContainer.BackgroundTransparency = 1
    buttonsContainer.Parent = headerFrame
    
    local function createHeaderButton(btnName, iconId, color, onClick)
        local btn = Instance.new("TextButton")
        btn.Name = btnName
        btn.Size = UDim2.new(0, 30, 0, 30)
        btn.BackgroundColor3 = Config.Colors.Card
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.Parent = buttonsContainer
        Utilities.CreateCorner(btn, Config.Settings.SmallCornerRadius)
        
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 16, 0, 16)
        icon.Position = UDim2.new(0.5, -8, 0.5, -8)
        icon.BackgroundTransparency = 1
        icon.Image = iconId
        icon.ImageColor3 = Config.Colors.TextWhite
        icon.Parent = btn
        
        btn.MouseEnter:Connect(function()
            Animations.Tween(btn, 0.15, {BackgroundColor3 = color})
        end)
        btn.MouseLeave:Connect(function()
            Animations.Tween(btn, 0.15, {BackgroundColor3 = Config.Colors.Card})
        end)
        btn.MouseButton1Click:Connect(function()
            Animations.CreateRipple(btn, btn.AbsolutePosition, Config.Colors.TextWhite)
            Utilities.PlaySound("6031068425", 0.4)
            onClick()
        end)
        return btn
    end
    
    local closeBtn = createHeaderButton("CloseBtn", Config.Assets.Close, Config.Colors.Error, function()
        self:Destroy()
    end)
    closeBtn.Position = UDim2.new(1, -32, 0.5, -15)
    
    local maxBtn = createHeaderButton("MaxBtn", Config.Assets.Maximize, Config.Colors.PrimaryRed, function()
        self:ToggleMaximize()
    end)
    maxBtn.Position = UDim2.new(1, -68, 0.5, -15)
    
    local minBtn = createHeaderButton("MinBtn", Config.Assets.Minimize, Config.Colors.Warning, function()
        self:Minimize()
    end)
    minBtn.Position = UDim2.new(1, -104, 0.5, -15)
    
    ----------------------------------------------------------------------------
    -- 5. TOP SEARCH BAR (Lebar penuh, Realtime Search)
    ----------------------------------------------------------------------------
    local searchContainer = Instance.new("Frame")
    searchContainer.Name = "SearchBarContainer"
    searchContainer.Size = UDim2.new(1, -28, 0, 38)
    searchContainer.Position = UDim2.new(0, 14, 0, Config.Settings.HeaderHeight + 10)
    searchContainer.BackgroundColor3 = Config.Colors.Secondary
    searchContainer.BorderSizePixel = 0
    searchContainer.Parent = uiContainer
    Utilities.CreateCorner(searchContainer, Config.Settings.SmallCornerRadius)
    Utilities.CreateStroke(searchContainer, Config.Colors.Border, 1)
    
    local searchIcon = Instance.new("ImageLabel")
    searchIcon.Size = UDim2.new(0, 18, 0, 18)
    searchIcon.Position = UDim2.new(0, 12, 0.5, -9)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Image = Config.Assets.SearchIcon
    searchIcon.ImageColor3 = Config.Colors.Placeholder
    searchIcon.Parent = searchContainer
    
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(1, -44, 1, 0)
    searchBox.Position = UDim2.new(0, 38, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.PlaceholderText = "Search across all Tabs, Sections, Toggles, Buttons, Sliders, Dropdowns..."
    searchBox.PlaceholderColor3 = Config.Colors.Placeholder
    searchBox.Font = Config.Fonts.Regular
    searchBox.TextSize = 13
    searchBox.TextColor3 = Config.Colors.TextWhite
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = searchContainer
    self.SearchBox = searchBox
    
    ----------------------------------------------------------------------------
    -- 6. SIDEBAR (220 Pixel width, Auto Scroll)
    ----------------------------------------------------------------------------
    local sidebarFrame = Instance.new("Frame")
    sidebarFrame.Name = "Sidebar"
    sidebarFrame.Size = UDim2.new(0, Config.Settings.SidebarWidth, 1, -(Config.Settings.HeaderHeight + 58))
    sidebarFrame.Position = UDim2.new(0, 0, 0, Config.Settings.HeaderHeight + 58)
    sidebarFrame.BackgroundColor3 = Config.Colors.Secondary
    sidebarFrame.BackgroundTransparency = 0.15
    sidebarFrame.BorderSizePixel = 0
    sidebarFrame.Parent = uiContainer
    
    local sidebarBorder = Instance.new("Frame")
    sidebarBorder.Size = UDim2.new(0, 1, 1, 0)
    sidebarBorder.Position = UDim2.new(1, -1, 0, 0)
    sidebarBorder.BackgroundColor3 = Config.Colors.Border
    sidebarBorder.BorderSizePixel = 0
    sidebarBorder.Parent = sidebarFrame
    
    local sidebarScroll = Instance.new("ScrollingFrame")
    sidebarScroll.Name = "SidebarScroll"
    sidebarScroll.Size = UDim2.new(1, 0, 1, 0)
    sidebarScroll.BackgroundTransparency = 1
    sidebarScroll.BorderSizePixel = 0
    sidebarScroll.ScrollBarThickness = 3
    sidebarScroll.ScrollBarImageColor3 = Config.Colors.PrimaryRed
    sidebarScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    sidebarScroll.Parent = sidebarFrame
    self.SidebarScroll = sidebarScroll
    
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Parent = sidebarScroll
    
    Utilities.CreatePadding(sidebarScroll, 12, 12, 6, 6)
    
    ----------------------------------------------------------------------------
    -- 7. CONTENT CONTAINER
    ----------------------------------------------------------------------------
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentContainer"
    contentFrame.Size = UDim2.new(1, -(Config.Settings.SidebarWidth + 2), 1, -(Config.Settings.HeaderHeight + 58))
    contentFrame.Position = UDim2.new(0, Config.Settings.SidebarWidth + 2, 0, Config.Settings.HeaderHeight + 58)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ClipsDescendants = true
    contentFrame.Parent = uiContainer
    self.ContentContainer = contentFrame
    
    -- Bottom-Right Resize Handle for Desktop
    if not Utilities.IsMobile() then
        local resizeHandle = Instance.new("ImageLabel")
        resizeHandle.Name = "ResizeHandle"
        resizeHandle.Size = UDim2.new(0, 16, 0, 16)
        resizeHandle.Position = UDim2.new(1, -16, 1, -16)
        resizeHandle.BackgroundTransparency = 1
        resizeHandle.Image = Config.Assets.Arrow
        resizeHandle.ImageColor3 = Config.Colors.Border
        resizeHandle.Rotation = 135
        resizeHandle.ZIndex = 10
        resizeHandle.Parent = mainFrame
        
        Utilities.MakeResizable(resizeHandle, mainFrame)
    end
    
    ----------------------------------------------------------------------------
    -- 8. 70x70 ROUND DRAGGABLE MINIMIZE ICON (BloodMoon Icon)
    ----------------------------------------------------------------------------
    local minIconFrame = Instance.new("ImageButton")
    minIconFrame.Name = "BloodMoonMinimizeIcon"
    minIconFrame.Size = UDim2.new(0, 70, 0, 70)
    minIconFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
    minIconFrame.BackgroundColor3 = Config.Colors.Card
    minIconFrame.Image = Config.Assets.Logo
    minIconFrame.AutoButtonColor = false
    minIconFrame.Visible = false
    minIconFrame.ZIndex = 1000
    minIconFrame.Parent = screenGui
    Utilities.CreateCorner(minIconFrame, UDim.new(1, 0))
    local minStroke = Utilities.CreateStroke(minIconFrame, Config.Colors.PrimaryRed, 2.5)
    
    -- Glow pulse on minimize icon
    task.spawn(function()
        while minIconFrame and minIconFrame.Parent do
            if minIconFrame.Visible then
                Animations.Tween(minStroke, 0.8, {Thickness = 4, Color = Config.Colors.HoverRed})
                task.wait(0.85)
                Animations.Tween(minStroke, 0.8, {Thickness = 2.5, Color = Config.Colors.PrimaryRed})
                task.wait(0.85)
            else
                task.wait(0.5)
            end
        end
    end)
    
    Utilities.MakeDraggable(minIconFrame, minIconFrame)
    
    minIconFrame.MouseButton1Click:Connect(function()
        self:Restore()
    end)
    self.MinimizeIcon = minIconFrame
    
    ----------------------------------------------------------------------------
    -- 9. NOTIFICATION QUEUE CONTAINER (Top Right)
    ----------------------------------------------------------------------------
    local notifContainer = Instance.new("Frame")
    notifContainer.Name = "NotificationContainer"
    notifContainer.Size = UDim2.new(0, 320, 1, -20)
    notifContainer.Position = UDim2.new(1, -330, 0, 10)
    notifContainer.BackgroundTransparency = 1
    notifContainer.ZIndex = 500
    notifContainer.Parent = screenGui
    
    local notifLayout = Instance.new("UIListLayout")
    notifLayout.Padding = UDim.new(0, 10)
    notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    notifLayout.Parent = notifContainer
    self.NotificationContainer = notifContainer
    
    ----------------------------------------------------------------------------
    -- 10. DIALOG MODAL CONTAINER
    ----------------------------------------------------------------------------
    local dialogOverlay = Instance.new("Frame")
    dialogOverlay.Name = "DialogOverlay"
    dialogOverlay.Size = UDim2.new(1, 0, 1, 0)
    dialogOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
    dialogOverlay.BackgroundTransparency = 1
    dialogOverlay.Visible = false
    dialogOverlay.ZIndex = 800
    dialogOverlay.Parent = screenGui
    self.DialogOverlay = dialogOverlay
    
    ----------------------------------------------------------------------------
    -- 11. CONNECT REALTIME SEARCH BAR LOGIC
    ----------------------------------------------------------------------------
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(searchBox.Text)
        self:FilterSearch(query)
    end)
    
    return self
end

--------------------------------------------------------------------------------
-- TAB MANAGEMENT & SELECTION
--------------------------------------------------------------------------------
function Window:CreateTab(name, icon)
    local tab = Tab.new(self, name, icon)
    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    return tab
end

function Window:SelectTab(tab)
    for _, t in ipairs(self.Tabs) do
        if t == tab then
            t:Show()
            self.ActiveTab = t
        else
            t:Hide()
        end
    end
end

--------------------------------------------------------------------------------
-- REALTIME SEARCH INDEXING & FILTERING across Tabs, Sections, Elements
--------------------------------------------------------------------------------
function Window:RegisterTabSearch(tabInstance)
    table.insert(self.SearchItems, {Type = "Tab", Instance = tabInstance, Title = string.lower(tabInstance.Name)})
end

function Window:RegisterSectionSearch(sectionObj, parentTab)
    table.insert(self.SearchItems, {Type = "Section", Instance = sectionObj, Tab = parentTab, Title = string.lower(sectionObj.Title)})
end

function Window:RegisterElementSearch(elementObj, parentContainer)
    table.insert(self.SearchItems, {Type = "Element", Instance = elementObj, Container = parentContainer, Title = string.lower(elementObj.Title or "")})
end

function Window:FilterSearch(query)
    if query == "" then
        -- Restore active tab normally
        if self.ActiveTab then
            self:SelectTab(self.ActiveTab)
        end
        for _, item in ipairs(self.SearchItems) do
            if item.Type == "Section" and item.Instance.Frame then
                item.Instance.Frame.Visible = true
            elseif item.Type == "Element" and item.Instance.Frame then
                item.Instance.Frame.Visible = true
            elseif item.Type == "Tab" and item.Instance.Button then
                item.Instance.Button.Visible = true
            end
        end
        return
    end
    
    -- When searching, filter sidebar tabs and display matching elements/sections
    for _, item in ipairs(self.SearchItems) do
        local matches = string.find(item.Title, query, 1, true) ~= nil
        
        if item.Type == "Tab" then
            item.Instance.Button.Visible = matches
        elseif item.Type == "Section" then
            item.Instance.Frame.Visible = matches
        elseif item.Type == "Element" then
            item.Instance.Frame.Visible = matches
            if matches and item.Container and item.Container.Tab then
                -- Auto switch to tab containing the matched element if current tab has no matches
                if self.ActiveTab ~= item.Container.Tab then
                    self:SelectTab(item.Container.Tab)
                end
            end
        end
    end
end

--------------------------------------------------------------------------------
-- MINIMIZE / RESTORE / MAXIMIZE
--------------------------------------------------------------------------------
function Window:Minimize()
    if self.IsMinimized then return end
    self.IsMinimized = true
    
    Animations.Tween(self.MainFrame, 0.25, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    task.wait(0.25)
    self.MainFrame.Visible = false
    self.MinimizeIcon.Visible = true
    Animations.Bounce(self.MinimizeIcon, UDim2.new(0, 78, 0, 78), 0.2)
end

function Window:Restore()
    if not self.IsMinimized then return end
    self.IsMinimized = false
    
    self.MinimizeIcon.Visible = false
    self.MainFrame.Visible = true
    Animations.Tween(self.MainFrame, 0.3, {Size = self.IsMaximized and UDim2.new(1, 0, 1, 0) or self.NormalSize, BackgroundTransparency = 0}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

function Window:ToggleMaximize()
    self.IsMaximized = not self.IsMaximized
    if self.IsMaximized then
        self.NormalPosition = self.MainFrame.Position
        Animations.Tween(self.MainFrame, 0.25, {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0)})
    else
        Animations.Tween(self.MainFrame, 0.25, {Size = self.NormalSize, Position = self.NormalPosition})
    end
end

--------------------------------------------------------------------------------
-- WATERMARK (Top Right, Draggable, Live FPS/Ping/Executor/Time/User)
--------------------------------------------------------------------------------
function Window:CreateWatermark(options)
    options = options or {}
    local title = options.Title or ("🌙 " .. self.Name .. " " .. self.Version)
    
    local wmFrame = Instance.new("Frame")
    wmFrame.Name = "BloodMoonWatermark"
    wmFrame.Size = UDim2.new(0, 360, 0, 34)
    wmFrame.Position = UDim2.new(1, -380, 0, 12)
    wmFrame.BackgroundColor3 = Config.Colors.Card
    wmFrame.BorderSizePixel = 0
    wmFrame.ZIndex = 400
    wmFrame.Parent = self.ScreenGui
    Utilities.CreateCorner(wmFrame, Config.Settings.SmallCornerRadius)
    local stroke = Utilities.CreateStroke(wmFrame, Config.Colors.PrimaryRed, 1.2)
    
    local wmLbl = Instance.new("TextLabel")
    wmLbl.Size = UDim2.new(1, -20, 1, 0)
    wmLbl.Position = UDim2.new(0, 10, 0, 0)
    wmLbl.BackgroundTransparency = 1
    wmLbl.Font = Config.Fonts.Bold
    wmLbl.TextSize = 12
    wmLbl.TextColor3 = Config.Colors.TextWhite
    wmLbl.TextXAlignment = Enum.TextXAlignment.Center
    wmLbl.Parent = wmFrame
    
    Utilities.MakeDraggable(wmFrame, wmFrame)
    
    -- Live update loop for FPS, Ping, Executor, Time, User
    local lastUpdate = 0
    local fpsCount = 0
    
    local conn = RunService.RenderStepped:Connect(function(dt)
        fpsCount = fpsCount + 1
        if os.clock() - lastUpdate >= 0.5 then
            local fps = math.floor(fpsCount / (os.clock() - lastUpdate))
            fpsCount = 0
            lastUpdate = os.clock()
            
            local ping = 0
            pcall(function()
                ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValueString():match("%d+") or 0)
            end)
            
            local execName = Utilities.GetExecutorName()
            local timeStr = os.date("%H:%M:%S")
            local userName = LocalPlayer and LocalPlayer.Name or "Player"
            
            wmLbl.Text = string.format("%s | %d FPS | %dms | %s | %s", title, fps, ping, execName, timeStr)
            
            -- Adjust watermark size dynamically based on text width
            wmFrame.Size = UDim2.new(0, math.max(340, #wmLbl.Text * 7.5), 0, 34)
        end
    end)
    self.Connections:Add(conn)
    
    return {
        Frame = wmFrame,
        SetVisible = function(s, v) wmFrame.Visible = v end
    }
end

--------------------------------------------------------------------------------
-- NOTIFICATION SYSTEM (Top Right, Tween Slide/Fade, Queue, Icon, Sound)
--------------------------------------------------------------------------------
function Window:CreateNotification(options)
    options = options or {}
    local title = options.Title or "Notification"
    local content = options.Content or "Here is some information for you."
    local duration = options.Duration or 5
    local notifType = options.Type or "Info" -- Info, Success, Warning, Error
    local imageIcon = options.Image
    
    local borderColor = Config.Colors.PrimaryRed
    if notifType == "Success" then borderColor = Config.Colors.Success
    elseif notifType == "Warning" then borderColor = Config.Colors.Warning
    elseif notifType == "Error" then borderColor = Config.Colors.Error end
    
    local notifCard = Instance.new("Frame")
    notifCard.Name = "NotifCard"
    notifCard.Size = UDim2.new(1, 0, 0, 76)
    notifCard.Position = UDim2.new(1, 350, 0, 0) -- Start off-screen right
    notifCard.BackgroundColor3 = Config.Colors.Card
    notifCard.BorderSizePixel = 0
    notifCard.Parent = self.NotificationContainer
    Utilities.CreateCorner(notifCard, Config.Settings.SmallCornerRadius)
    Utilities.CreateStroke(notifCard, borderColor, 1.5)
    
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 1, 0)
    accentBar.BackgroundColor3 = borderColor
    accentBar.BorderSizePixel = 0
    accentBar.Parent = notifCard
    Utilities.CreateCorner(accentBar, UDim.new(1, 0))
    
    local iconId = imageIcon and Icons.Get(imageIcon) or Icons.Get(string.lower(notifType))
    local iconLbl = Instance.new("ImageLabel")
    iconLbl.Size = UDim2.new(0, 24, 0, 24)
    iconLbl.Position = UDim2.new(0, 16, 0, 12)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Image = iconId
    iconLbl.ImageColor3 = borderColor
    iconLbl.Parent = notifCard
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -60, 0, 20)
    titleLbl.Position = UDim2.new(0, 48, 0, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.Font = Config.Fonts.Bold
    titleLbl.TextSize = 14
    titleLbl.TextColor3 = Config.Colors.TextWhite
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = notifCard
    
    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -60, 0, 36)
    descLbl.Position = UDim2.new(0, 48, 0, 30)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = content
    descLbl.Font = Config.Fonts.Regular
    descLbl.TextSize = 12
    descLbl.TextColor3 = Config.Colors.TextGray
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextWrapped = true
    descLbl.Parent = notifCard
    
    -- Play notification sound
    Utilities.PlaySound("6031068425", 0.5)
    
    -- Slide in tween
    Animations.Tween(notifCard, 0.35, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    task.spawn(function()
        task.wait(duration)
        if notifCard and notifCard.Parent then
            Animations.Tween(notifCard, 0.3, {Position = UDim2.new(1, 350, 0, 0), BackgroundTransparency = 1})
            task.wait(0.3)
            notifCard:Destroy()
        end
    end)
    
    return notifCard
end

--------------------------------------------------------------------------------
-- MODAL DIALOG SYSTEM (Smooth bounce in/out)
--------------------------------------------------------------------------------
function Window:CreateDialog(options)
    options = options or {}
    local title = options.Title or "Dialog Title"
    local content = options.Content or "Are you sure you want to proceed with this action?"
    local buttons = options.Buttons or {
        {Title = "Confirm", Callback = function() end},
        {Title = "Cancel", Callback = function() end}
    }
    
    self.DialogOverlay.Visible = true
    Animations.Tween(self.DialogOverlay, 0.25, {BackgroundTransparency = 0.45})
    
    local dialogBox = Instance.new("Frame")
    dialogBox.Name = "DialogBox"
    dialogBox.Size = UDim2.new(0, 420, 0, 200)
    dialogBox.Position = UDim2.new(0.5, -210, 0.5, -100)
    dialogBox.BackgroundColor3 = Config.Colors.Card
    dialogBox.BorderSizePixel = 0
    dialogBox.ZIndex = 810
    dialogBox.Parent = self.DialogOverlay
    Utilities.CreateCorner(dialogBox, Config.Settings.CornerRadius)
    Utilities.CreateStroke(dialogBox, Config.Colors.PrimaryRed, 1.5)
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -28, 0, 30)
    titleLbl.Position = UDim2.new(0, 14, 0, 14)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.Font = Config.Fonts.Bold
    titleLbl.TextSize = 16
    titleLbl.TextColor3 = Config.Colors.PrimaryRed
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 811
    titleLbl.Parent = dialogBox
    
    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -28, 0, 70)
    descLbl.Position = UDim2.new(0, 14, 0, 50)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = content
    descLbl.Font = Config.Fonts.Regular
    descLbl.TextSize = 13
    descLbl.TextColor3 = Config.Colors.TextWhite
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextWrapped = true
    descLbl.ZIndex = 811
    descLbl.Parent = dialogBox
    
    local btnsContainer = Instance.new("Frame")
    btnsContainer.Size = UDim2.new(1, -28, 0, 40)
    btnsContainer.Position = UDim2.new(0, 14, 1, -54)
    btnsContainer.BackgroundTransparency = 1
    btnsContainer.ZIndex = 811
    btnsContainer.Parent = dialogBox
    
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.Padding = UDim.new(0, 10)
    layout.Parent = btnsContainer
    
    local function closeDialog()
        Animations.Tween(dialogBox, 0.2, {Position = UDim2.new(0.5, -210, 0.5, -130), BackgroundTransparency = 1})
        Animations.Tween(self.DialogOverlay, 0.2, {BackgroundTransparency = 1})
        task.wait(0.2)
        dialogBox:Destroy()
        self.DialogOverlay.Visible = false
    end
    
    for _, btnData in ipairs(buttons) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 110, 1, 0)
        btn.BackgroundColor3 = Config.Colors.Secondary
        btn.Font = Config.Fonts.Bold
        btn.TextSize = 13
        btn.TextColor3 = Config.Colors.TextWhite
        btn.Text = btnData.Title or "Button"
        btn.ZIndex = 812
        btn.Parent = btnsContainer
        Utilities.CreateCorner(btn, Config.Settings.SmallCornerRadius)
        Utilities.CreateStroke(btn, Config.Colors.Border, 1)
        
        btn.MouseButton1Click:Connect(function()
            Utilities.PlaySound("6031068425", 0.4)
            closeDialog()
            if btnData.Callback then task.spawn(btnData.Callback) end
        end)
    end
    
    -- Smooth bounce in
    dialogBox.Position = UDim2.new(0.5, -210, 0.5, -70)
    Animations.Tween(dialogBox, 0.25, {Position = UDim2.new(0.5, -210, 0.5, -100)}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

--------------------------------------------------------------------------------
-- DESTROY & CLEANUP (PERFORMANCE: No Memory Leak!)
--------------------------------------------------------------------------------
function Window:Destroy()
    self.Connections:DisconnectAll()
    if self.ScreenGui and self.ScreenGui.Parent then
        self.ScreenGui:Destroy()
    end
end

Modules.Window = Window
end


-- Expose Library API
BloodMoonLibrary.Config = Modules.Config
BloodMoonLibrary.Icons = Modules.Icons
BloodMoonLibrary.Utilities = Modules.Utilities
BloodMoonLibrary.Animations = Modules.Animations
BloodMoonLibrary.ConfigSystem = Modules.ConfigSystem
BloodMoonLibrary.Elements = Modules.Elements

function BloodMoonLibrary:CreateWindow(options)
    return Modules.Window.new(options)
end

function BloodMoonLibrary:SetThemeColor(key, color3Value)
    Modules.Config:SetColor(key, color3Value)
end

function BloodMoonLibrary:ResetTheme()
    Modules.Config:ResetColors()
end

function BloodMoonLibrary:SaveConfig(customFileName)
    return Modules.ConfigSystem.SaveConfig(customFileName)
end

function BloodMoonLibrary:LoadConfig(customFileName)
    return Modules.ConfigSystem.LoadConfig(customFileName)
end

return BloodMoonLibrary
