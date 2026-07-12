--!strict
-- AeroUI v1.0.0
-- Modern Roblox UI library with a WindUI-style API.
-- Designed for LocalScripts. This is an original implementation.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer
local AeroUI = {
    Version = "1.0.0",
    Themes = {},
    Windows = {},
    Options = {},
}

local function rgb(r, g, b) return Color3.fromRGB(r, g, b) end
local function tween(object, duration, properties, style, direction)
    local info = TweenInfo.new(duration or 0.18, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    local animation = TweenService:Create(object, info, properties)
    animation:Play()
    return animation
end
local function corner(parent, radius)
    local value = Instance.new("UICorner")
    value.CornerRadius = UDim.new(0, radius or 8)
    value.Parent = parent
    return value
end
local function stroke(parent, color, transparency, thickness)
    local value = Instance.new("UIStroke")
    value.Color = color or rgb(255,255,255)
    value.Transparency = transparency or 0.8
    value.Thickness = thickness or 1
    value.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    value.Parent = parent
    return value
end
local function padding(parent, left, right, top, bottom)
    local value = Instance.new("UIPadding")
    value.PaddingLeft = UDim.new(0, left or 0)
    value.PaddingRight = UDim.new(0, right or left or 0)
    value.PaddingTop = UDim.new(0, top or left or 0)
    value.PaddingBottom = UDim.new(0, bottom or top or left or 0)
    value.Parent = parent
    return value
end
local function list(parent, gap, horizontal)
    local value = Instance.new("UIListLayout")
    value.SortOrder = Enum.SortOrder.LayoutOrder
    value.Padding = UDim.new(0, gap or 6)
    value.FillDirection = horizontal and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
    value.HorizontalAlignment = horizontal and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center
    value.VerticalAlignment = horizontal and Enum.VerticalAlignment.Center or Enum.VerticalAlignment.Top
    value.Parent = parent
    return value
end
local function safeCall(callback, ...)
    if type(callback) ~= "function" then return end
    local ok, err = pcall(callback, ...)
    if not ok then warn("[AeroUI Callback] " .. tostring(err)) end
end
local function clampRound(value, minimum, maximum, rounding)
    value = math.clamp(value, minimum, maximum)
    local power = 10 ^ (rounding or 0)
    return math.floor(value * power + 0.5) / power
end
local function textWidth(text, size, font)
    local ok, result = pcall(function()
        return TextService:GetTextSize(text, size, font, Vector2.new(10000, 10000)).X
    end)
    return ok and result or 0
end

local BASE_DARK = {
    Background = rgb(13,14,18), Surface = rgb(20,22,28), Surface2 = rgb(28,30,38),
    Element = rgb(30,33,42), ElementHover = rgb(39,43,54), Border = rgb(58,62,76),
    Text = rgb(245,247,255), SubText = rgb(158,164,183), Accent = rgb(90,155,255),
    AccentText = rgb(255,255,255), Success = rgb(66,201,126), Warning = rgb(255,187,70),
    Error = rgb(242,82,82), Overlay = rgb(0,0,0), IsLight = false,
}
local function theme(name, accent, background, surface, element, text, subText, isLight)
    local t = {}
    for k,v in pairs(BASE_DARK) do t[k] = v end
    t.Name = name
    t.Accent = accent
    if background then t.Background = background end
    if surface then t.Surface = surface; t.Surface2 = surface:Lerp(accent, isLight and 0.05 or 0.08) end
    if element then t.Element = element; t.ElementHover = element:Lerp(accent, isLight and 0.10 or 0.18) end
    if text then t.Text = text end
    if subText then t.SubText = subText end
    t.Border = (isLight and rgb(185,190,205) or t.Surface2:Lerp(accent, 0.23))
    t.AccentText = isLight and rgb(20,20,28) or rgb(255,255,255)
    t.IsLight = isLight == true
    return t
end

-- Theme collection adapted from the color identities listed in FluentPro.txt.
local THEME_LIST = {
    theme("AMOLED", rgb(255,255,255), rgb(0,0,0), rgb(5,5,5), rgb(10,10,10), rgb(255,255,255), rgb(150,150,150), false),
    theme("Ash Gray", rgb(150,150,150), rgb(28,28,28), rgb(40,40,40), rgb(52,52,52), rgb(240,240,240), rgb(170,170,170), false),
    theme("Blood Red", rgb(180,10,20), rgb(24,4,7), rgb(35,8,10), rgb(58,10,15), rgb(255,230,230), rgb(210,175,178), false),
    theme("Cyanic", rgb(57,197,187), rgb(4,12,16), rgb(8,18,22), rgb(14,38,46), rgb(210,248,246), rgb(130,210,205), false),
    theme("Amber Glow", rgb(255,170,40), rgb(10,5,1), rgb(18,10,4), rgb(38,20,5), rgb(255,245,225), rgb(230,195,145), false),
    theme("Deep Violet", rgb(97,62,167), rgb(16,10,28), rgb(27,20,42), rgb(48,36,68), rgb(240,240,240), rgb(180,170,195), false),
    theme("Neon Cyber", rgb(57,255,20), rgb(3,8,3), rgb(5,10,5), rgb(10,22,10), rgb(200,255,190), rgb(80,200,60), false),
    theme("Neon Purple", rgb(180,0,255), rgb(5,0,15), rgb(12,3,30), rgb(32,5,60), rgb(252,245,255), rgb(210,185,255), false),
    theme("Royal Blue", rgb(15,82,186), rgb(5,15,35), rgb(10,25,50), rgb(12,40,78), rgb(220,235,255), rgb(170,190,220), false),
    theme("Deep Ocean", rgb(0,150,200), rgb(6,18,30), rgb(15,30,45), rgb(14,48,66), rgb(240,248,255), rgb(180,210,230), false),
    theme("RGB", rgb(0,255,180), rgb(8,8,14), rgb(14,12,27), rgb(20,20,35), rgb(220,255,245), rgb(100,220,190), false),
    theme("Orange", rgb(255,140,30), rgb(2,1,0), rgb(8,4,1), rgb(30,12,3), rgb(255,240,220), rgb(220,175,130), false),
    theme("Charcoal", rgb(102,102,102), rgb(10,10,10), rgb(20,20,20), rgb(35,35,35), rgb(240,240,240), rgb(170,170,170), false),
    theme("Pearl White", rgb(60,160,255), rgb(238,240,245), rgb(250,250,252), rgb(224,228,235), rgb(20,20,20), rgb(90,90,90), true),
    theme("Midnight Blue", rgb(100,80,200), rgb(5,3,15), rgb(10,8,25), rgb(28,23,58), rgb(220,220,255), rgb(170,170,210), false),
    theme("Galaxy Purple", rgb(160,60,220), rgb(5,2,14), rgb(12,5,25), rgb(37,15,57), rgb(242,232,255), rgb(200,178,228), false),
    theme("Cosmic Violet", rgb(80,60,140), rgb(5,3,10), rgb(12,10,22), rgb(28,22,50), rgb(230,225,245), rgb(185,175,210), false),
    theme("Cotton Candy", rgb(255,130,190), rgb(248,224,242), rgb(255,235,250), rgb(246,205,232), rgb(75,25,55), rgb(145,75,115), true),
    theme("Arctic Frost", rgb(100,180,240), rgb(218,237,249), rgb(235,248,255), rgb(205,231,247), rgb(20,40,70), rgb(65,105,148), true),
}
for _, value in ipairs(THEME_LIST) do AeroUI.Themes[value.Name] = value end
AeroUI.ThemeNames = {}
for _, value in ipairs(THEME_LIST) do table.insert(AeroUI.ThemeNames, value.Name) end

function AeroUI:AddTheme(config)
    assert(type(config) == "table" and type(config.Name) == "string", "Theme requires Name")
    local built = {}
    for k,v in pairs(BASE_DARK) do built[k] = v end
    for k,v in pairs(config) do built[k] = v end
    self.Themes[built.Name] = built
    if not table.find(self.ThemeNames, built.Name) then table.insert(self.ThemeNames, built.Name) end
    return built
end
AeroUI.CreateTheme = AeroUI.AddTheme

local function getParent()
    local ok, hidden = pcall(function()
        if type(gethui) == "function" then return gethui() end
        return nil
    end)
    if ok and hidden then return hidden end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local function make(className, properties)
    local object = Instance.new(className)
    for key, value in pairs(properties or {}) do
        if key ~= "Parent" then object[key] = value end
    end
    if properties and properties.Parent then object.Parent = properties.Parent end
    return object
end

local function bindTheme(window, object, property, key, transform)
    table.insert(window._themeBindings, {Object=object, Property=property, Key=key, Transform=transform})
    local value = window.Theme[key]
    if transform then value = transform(value, window.Theme) end
    pcall(function() object[property] = value end)
end
local function applyTheme(window)
    for i = #window._themeBindings, 1, -1 do
        local item = window._themeBindings[i]
        if not item.Object or not item.Object.Parent then
            table.remove(window._themeBindings, i)
        else
            local value = window.Theme[item.Key]
            if item.Transform then value = item.Transform(value, window.Theme) end
            pcall(function() item.Object[item.Property] = value end)
        end
    end
end

local function connect(window, signal, callback)
    local connection = signal:Connect(callback)
    table.insert(window._connections, connection)
    return connection
end

local function createText(window, parent, value, size, bold)
    local label = make("TextLabel", {
        Parent=parent, BackgroundTransparency=1, Text=value or "", TextSize=size or 13,
        Font=bold and Enum.Font.GothamSemibold or Enum.Font.Gotham,
        TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Center,
        TextTruncate=Enum.TextTruncate.AtEnd,
    })
    bindTheme(window, label, "TextColor3", bold and "Text" or "SubText")
    return label
end

local function addRipple(window, button, x, y)
    local p = button.AbsolutePosition
    local s = button.AbsoluteSize
    local diameter = math.max(s.X, s.Y) * 1.8
    local ripple = make("Frame", {
        Parent=button, AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromOffset(x-p.X,y-p.Y),
        Size=UDim2.fromOffset(0,0), BackgroundTransparency=0.72, ZIndex=button.ZIndex+5,
    })
    bindTheme(window, ripple, "BackgroundColor3", "Accent")
    corner(ripple, 999)
    tween(ripple, 0.45, {Size=UDim2.fromOffset(diameter,diameter), BackgroundTransparency=1})
    task.delay(0.48, function() if ripple then ripple:Destroy() end end)
end

local ElementMethods = {}
ElementMethods.__index = ElementMethods
function ElementMethods:SetTitle(value)
    self.Config.Title = tostring(value)
    if self.TitleLabel then self.TitleLabel.Text = self.Config.Title end
    return self
end
function ElementMethods:SetDesc(value)
    self.Config.Desc = tostring(value or "")
    if self.DescLabel then self.DescLabel.Text = self.Config.Desc; self.DescLabel.Visible = self.Config.Desc ~= "" end
    return self
end
function ElementMethods:SetLocked(value)
    self.Locked = value == true
    if self.Frame then self.Frame.Active = not self.Locked end
    if self.LockIcon then self.LockIcon.Visible = self.Locked end
    return self
end
function ElementMethods:SetVisible(value)
    if self.Frame then self.Frame.Visible = value == true end
    return self
end
function ElementMethods:Destroy()
    if self.Frame then self.Frame:Destroy() end
end

local function elementShell(container, config, height)
    config = config or {}
    local window = container.Window
    local object = setmetatable({Config=config, Window=window, Locked=config.Locked == true}, ElementMethods)
    local frame = make("Frame", {
        Parent=container.Container, Size=UDim2.new(1,0,0,height or ((config.Desc or config.Description) and 54 or 44)),
        BackgroundTransparency=0, BorderSizePixel=0, ClipsDescendants=true,
    })
    object.Frame = frame
    bindTheme(window, frame, "BackgroundColor3", "Element")
    corner(frame, window.CornerRadius)
    local border = stroke(frame, window.Theme.Border, 0.45, 1)
    bindTheme(window, border, "Color", "Border")

    local rightSpace = config.RightSpace or 92
    local hasDesc = config.Desc ~= nil or config.Description ~= nil
    local title = createText(window, frame, tostring(config.Title or config.Text or "Element"), 13, true)
    title.Size = UDim2.new(1,-rightSpace-13,0,22)
    if hasDesc then
        title.Position = UDim2.fromOffset(13,8)
    else
        title.AnchorPoint=Vector2.new(0,0.5)
        title.Position=UDim2.fromOffset(13,(height or 44)/2)
    end
    object.TitleLabel = title
    local desc = createText(window, frame, tostring(config.Desc or config.Description or ""), 11, false)
    desc.Position = UDim2.fromOffset(13,27)
    desc.Size = UDim2.new(1,-rightSpace-13,0,16)
    desc.Visible = hasDesc
    object.DescLabel = desc
    local lockLabel = createText(window, frame, "LOCK", 9, true)
    lockLabel.TextXAlignment = Enum.TextXAlignment.Center
    lockLabel.Size = UDim2.fromOffset(38,18)
    lockLabel.Position = UDim2.new(1,-46,0.5,-9)
    lockLabel.Visible = object.Locked
    bindTheme(window, lockLabel, "TextColor3", "Warning")
    object.LockIcon = lockLabel
    return object
end

local ContainerMethods = {}
ContainerMethods.__index = ContainerMethods

function ContainerMethods:Paragraph(config)
    if type(config) == "string" then config = {Title=config} end
    config = config or {}
    local object = elementShell(self, {Title=config.Title or "Paragraph", Desc=config.Desc or config.Content or "", RightSpace=20}, 58)
    object.Frame.BackgroundTransparency = 0.35
    return object
end
ContainerMethods.Label = ContainerMethods.Paragraph

function ContainerMethods:Button(config)
    if type(config) == "string" then config = {Title=config} end
    config = config or {}
    local object = elementShell(self, config, (config.Desc or config.Description) and 54 or 44)
    local button = make("TextButton", {Parent=object.Frame, Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", AutoButtonColor=false})
    local arrow = createText(self.Window, object.Frame, "›", 24, false)
    arrow.TextXAlignment = Enum.TextXAlignment.Center
    arrow.Position = UDim2.new(1,-42,0,0); arrow.Size = UDim2.fromOffset(32,object.Frame.Size.Y.Offset)
    connect(self.Window, button.MouseEnter, function() if not object.Locked then tween(object.Frame,0.15,{BackgroundColor3=self.Window.Theme.ElementHover}) end end)
    connect(self.Window, button.MouseLeave, function() tween(object.Frame,0.15,{BackgroundColor3=self.Window.Theme.Element}) end)
    connect(self.Window, button.MouseButton1Click, function()
        if object.Locked then return end
        local location = UserInputService:GetMouseLocation()
        addRipple(self.Window, object.Frame, location.X, location.Y)
        safeCall(config.Callback)
    end)
    function object:Fire() if not self.Locked then safeCall(config.Callback) end end
    return object
end

function ContainerMethods:Toggle(config)
    config = config or {}
    local object = elementShell(self, config, (config.Desc or config.Description) and 54 or 44)
    object.Value = config.Value == true or config.Default == true
    object.Type = "Toggle"
    local track = make("Frame", {Parent=object.Frame, Size=UDim2.fromOffset(42,22), Position=UDim2.new(1,-54,0.5,-11), BorderSizePixel=0})
    corner(track, 999)
    local knob = make("Frame", {Parent=track, Size=UDim2.fromOffset(16,16), Position=UDim2.fromOffset(3,3), BorderSizePixel=0})
    corner(knob, 999)
    bindTheme(self.Window, knob, "BackgroundColor3", "AccentText")
    local click = make("TextButton", {Parent=object.Frame, Size=UDim2.fromScale(1,1), Text="", BackgroundTransparency=1, AutoButtonColor=false})
    local function render(instant)
        local targetColor = object.Value and self.Window.Theme.Accent or self.Window.Theme.Surface2
        local targetPos = object.Value and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)
        if instant then track.BackgroundColor3=targetColor; knob.Position=targetPos
        else tween(track,0.18,{BackgroundColor3=targetColor}); tween(knob,0.18,{Position=targetPos}) end
    end
    function object:Set(value, silent)
        self.Value = value == true
        render(false)
        if not silent then safeCall(config.Callback, self.Value) end
        return self
    end
    object.SetValue = object.Set
    connect(self.Window, click.MouseButton1Click, function() if not object.Locked then object:Set(not object.Value) end end)
    render(true)
    if config.Flag then AeroUI.Options[config.Flag] = object end
    return object
end

function ContainerMethods:Slider(config)
    config = config or {}
    local object = elementShell(self, config, (config.Desc or config.Description) and 68 or 60)
    object.Type = "Slider"
    object.Min = tonumber(config.Min) or 0; object.Max = tonumber(config.Max) or 100
    object.Rounding = tonumber(config.Rounding) or 0
    object.Value = clampRound(tonumber(config.Value or config.Default) or object.Min, object.Min, object.Max, object.Rounding)
    local valueLabel = createText(self.Window, object.Frame, tostring(object.Value), 12, true)
    valueLabel.TextXAlignment=Enum.TextXAlignment.Right; valueLabel.Size=UDim2.fromOffset(70,20); valueLabel.Position=UDim2.new(1,-82,0,8)
    local rail = make("Frame", {Parent=object.Frame, Size=UDim2.new(1,-26,0,5), Position=UDim2.new(0,13,1,-14), BorderSizePixel=0})
    bindTheme(self.Window, rail, "BackgroundColor3", "Surface2"); corner(rail,999)
    local fill = make("Frame", {Parent=rail, Size=UDim2.fromScale(0,1), BorderSizePixel=0})
    bindTheme(self.Window, fill, "BackgroundColor3", "Accent"); corner(fill,999)
    local knob = make("Frame", {Parent=rail, AnchorPoint=Vector2.new(0.5,0.5), Size=UDim2.fromOffset(13,13), Position=UDim2.fromScale(0,0.5), BorderSizePixel=0})
    bindTheme(self.Window, knob, "BackgroundColor3", "Accent"); corner(knob,999)
    local dragging = false
    local function render()
        local alpha = (object.Value-object.Min)/math.max(object.Max-object.Min,0.0001)
        fill.Size=UDim2.fromScale(alpha,1); knob.Position=UDim2.fromScale(alpha,0.5); valueLabel.Text=tostring(object.Value)..tostring(config.Suffix or "")
    end
    function object:Set(value, silent)
        self.Value = clampRound(tonumber(value) or self.Min, self.Min, self.Max, self.Rounding)
        render(); if not silent then safeCall(config.Callback,self.Value) end; return self
    end
    object.SetValue = object.Set
    local function fromX(x)
        local alpha=math.clamp((x-rail.AbsolutePosition.X)/math.max(rail.AbsoluteSize.X,1),0,1)
        object:Set(object.Min+(object.Max-object.Min)*alpha)
    end
    connect(self.Window, rail.InputBegan, function(input)
        if object.Locked then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true; fromX(input.Position.X) end
    end)
    connect(self.Window, UserInputService.InputChanged, function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then fromX(input.Position.X) end
    end)
    connect(self.Window, UserInputService.InputEnded, function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end)
    render()
    if config.Flag then AeroUI.Options[config.Flag]=object end
    return object
end

function ContainerMethods:Input(config)
    config=config or {}
    local object=elementShell(self,config,(config.Desc or config.Description) and 64 or 52)
    object.Type="Input"; object.Value=tostring(config.Value or config.Default or "")
    local box=make("TextBox",{Parent=object.Frame,Size=UDim2.new(config.Expand and 1 or 0,config.Expand and -26 or 170,0,30),Position=config.Expand and UDim2.new(0,13,1,-37) or UDim2.new(1,-183,0.5,-15),BackgroundTransparency=0,Text=object.Value,PlaceholderText=tostring(config.Placeholder or config.PlaceholderText or "Type..."),TextSize=12,Font=Enum.Font.Gotham,ClearTextOnFocus=config.ClearTextOnFocus==true,TextXAlignment=Enum.TextXAlignment.Left,MultiLine=config.MultiLine==true})
    bindTheme(self.Window,box,"BackgroundColor3","Surface2"); bindTheme(self.Window,box,"TextColor3","Text"); bindTheme(self.Window,box,"PlaceholderColor3","SubText")
    corner(box,7); padding(box,9,9,0,0)
    local border=stroke(box,self.Window.Theme.Border,0.5,1); bindTheme(self.Window,border,"Color","Border")
    function object:Set(value,silent) self.Value=tostring(value or ""); box.Text=self.Value; if not silent then safeCall(config.Callback,self.Value) end; return self end
    object.SetValue=object.Set
    connect(self.Window,box.Focused,function() tween(border,0.15,{Color=self.Window.Theme.Accent,Transparency=0}) end)
    connect(self.Window,box.FocusLost,function(enter) object.Value=box.Text; tween(border,0.15,{Color=self.Window.Theme.Border,Transparency=0.5}); safeCall(config.Callback,object.Value,enter) end)
    if config.Flag then AeroUI.Options[config.Flag]=object end
    return object
end

function ContainerMethods:Dropdown(config)
    config=config or {}
    local object=elementShell(self,config,(config.Desc or config.Description) and 54 or 44)
    object.Type="Dropdown"; object.Values=config.Values or config.List or {}; object.Multi=config.Multi==true
    object.Value=config.Value or config.Default or (object.Multi and {} or nil)
    local selectButton=make("TextButton",{Parent=object.Frame,Size=UDim2.fromOffset(150,30),Position=UDim2.new(1,-163,0.5,-15),BackgroundTransparency=0,Text="",AutoButtonColor=false})
    bindTheme(self.Window,selectButton,"BackgroundColor3","Surface2"); corner(selectButton,7)
    local selected=createText(self.Window,selectButton,"Select",11,false); selected.Position=UDim2.fromOffset(9,0); selected.Size=UDim2.new(1,-30,1,0)
    local chevron=createText(self.Window,selectButton,"⌄",16,true); chevron.TextXAlignment=Enum.TextXAlignment.Center; chevron.Position=UDim2.new(1,-25,0,0); chevron.Size=UDim2.fromOffset(22,30)
    local popup=nil
    local function display()
        if object.Multi then
            local names={}; for _,v in ipairs(object.Values) do if object.Value[v] then table.insert(names,tostring(v)) end end
            selected.Text=#names>0 and table.concat(names,", ") or tostring(config.Placeholder or "Select")
        else selected.Text=object.Value~=nil and tostring(object.Value) or tostring(config.Placeholder or "Select") end
    end
    function object:Set(value,silent) self.Value=value; display(); if not silent then safeCall(config.Callback,self.Value) end; return self end
    object.SetValue=object.Set
    function object:SetValues(values) self.Values=values or {}; display(); return self end
    function object:Close() if popup then popup:Destroy(); popup=nil; chevron.Text="⌄" end end
    local function open()
        if popup then object:Close(); return end
        chevron.Text="⌃"
        popup=make("Frame",{Parent=self.Window.PopupLayer,Size=UDim2.fromOffset(selectButton.AbsoluteSize.X,math.min(#object.Values*32+12,188)),Position=UDim2.fromOffset(selectButton.AbsolutePosition.X,selectButton.AbsolutePosition.Y+selectButton.AbsoluteSize.Y+5),BorderSizePixel=0,ZIndex=50,ClipsDescendants=true})
        bindTheme(self.Window,popup,"BackgroundColor3","Surface"); corner(popup,8); local ps=stroke(popup,self.Window.Theme.Border,0.2,1); bindTheme(self.Window,ps,"Color","Border")
        local scroll=make("ScrollingFrame",{Parent=popup,Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ScrollBarThickness=2,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=51}); padding(scroll,6,6,6,6); list(scroll,3,false)
        for _,value in ipairs(object.Values) do
            local option=make("TextButton",{Parent=scroll,Size=UDim2.new(1,0,0,28),BackgroundTransparency=1,Text=tostring(value),TextSize=11,Font=Enum.Font.Gotham,AutoButtonColor=false,ZIndex=52})
            bindTheme(self.Window,option,"TextColor3","Text"); corner(option,6)
            connect(self.Window,option.MouseEnter,function() tween(option,0.12,{BackgroundTransparency=0,BackgroundColor3=self.Window.Theme.ElementHover}) end)
            connect(self.Window,option.MouseLeave,function() tween(option,0.12,{BackgroundTransparency=1}) end)
            connect(self.Window,option.MouseButton1Click,function()
                if object.Multi then object.Value[value]=not object.Value[value]; object:Set(object.Value) else object:Set(value); object:Close() end
            end)
        end
    end
    connect(self.Window,selectButton.MouseButton1Click,function() if not object.Locked then open() end end)
    display(); if config.Flag then AeroUI.Options[config.Flag]=object end
    return object
end

function ContainerMethods:Keybind(config)
    config=config or {}
    local object=elementShell(self,config,(config.Desc or config.Description) and 54 or 44)
    object.Type="Keybind"; object.Value=config.Value or config.Default or Enum.KeyCode.Unknown; object.Listening=false
    if type(object.Value)=="string" then object.Value=Enum.KeyCode[object.Value] or Enum.KeyCode.Unknown end
    local keyButton=make("TextButton",{Parent=object.Frame,Size=UDim2.fromOffset(88,28),Position=UDim2.new(1,-101,0.5,-14),Text="",BackgroundTransparency=0,AutoButtonColor=false})
    bindTheme(self.Window,keyButton,"BackgroundColor3","Surface2"); bindTheme(self.Window,keyButton,"TextColor3","Text"); corner(keyButton,7)
    local function display() keyButton.Text=object.Listening and "..." or (object.Value.Name or tostring(object.Value)) end
    function object:Set(value,silent) if type(value)=="string" then value=Enum.KeyCode[value] or Enum.KeyCode.Unknown end; self.Value=value; display(); if not silent then safeCall(config.ChangedCallback or config.OnChanged,value) end; return self end
    object.SetValue=object.Set
    connect(self.Window,keyButton.MouseButton1Click,function() if not object.Locked then object.Listening=true; display() end end)
    connect(self.Window,UserInputService.InputBegan,function(input,processed)
        if object.Listening then object.Listening=false; object:Set(input.KeyCode~=Enum.KeyCode.Unknown and input.KeyCode or input.UserInputType); return end
        if not processed and input.KeyCode==object.Value then safeCall(config.Callback,object.Value) end
    end)
    display(); if config.Flag then AeroUI.Options[config.Flag]=object end
    return object
end

function ContainerMethods:Colorpicker(config)
    config=config or {}
    local object=elementShell(self,config,(config.Desc or config.Description) and 54 or 44)
    object.Type="Colorpicker"; object.Value=config.Value or config.Default or self.Window.Theme.Accent
    local swatch=make("TextButton",{Parent=object.Frame,Size=UDim2.fromOffset(48,26),Position=UDim2.new(1,-61,0.5,-13),Text="",BackgroundColor3=object.Value,AutoButtonColor=false})
    corner(swatch,7); stroke(swatch,rgb(255,255,255),0.6,1)
    local popup=nil
    function object:Set(value,silent) self.Value=value; swatch.BackgroundColor3=value; if not silent then safeCall(config.Callback,value) end; return self end
    object.SetValue=object.Set
    function object:Close() if popup then popup:Destroy(); popup=nil end end
    local function open()
        if popup then object:Close(); return end
        local h,s,v=object.Value:ToHSV()
        popup=make("Frame",{Parent=self.Window.PopupLayer,Size=UDim2.fromOffset(220,170),Position=UDim2.fromOffset(swatch.AbsolutePosition.X-172,swatch.AbsolutePosition.Y+32),BorderSizePixel=0,ZIndex=60})
        bindTheme(self.Window,popup,"BackgroundColor3","Surface"); corner(popup,9); local ps=stroke(popup,self.Window.Theme.Border,0.2,1); bindTheme(self.Window,ps,"Color","Border")
        local sv=make("ImageButton",{Parent=popup,Size=UDim2.fromOffset(190,105),Position=UDim2.fromOffset(15,14),Image="rbxassetid://4155801252",BackgroundColor3=Color3.fromHSV(h,1,1),AutoButtonColor=false,ZIndex=61}); corner(sv,6)
        local hue=make("ImageButton",{Parent=popup,Size=UDim2.fromOffset(190,15),Position=UDim2.fromOffset(15,130),Image="rbxassetid://3641079629",AutoButtonColor=false,ZIndex=61}); corner(hue,999)
        local marker=make("Frame",{Parent=sv,Size=UDim2.fromOffset(10,10),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(s,1-v),BackgroundTransparency=1,ZIndex=62}); corner(marker,999); stroke(marker,rgb(255,255,255),0,2)
        local hmark=make("Frame",{Parent=hue,Size=UDim2.fromOffset(4,19),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(h,0.5),BackgroundColor3=rgb(255,255,255),ZIndex=62}); corner(hmark,2)
        local draggingSV,draggingH=false,false
        local function updateColor() sv.BackgroundColor3=Color3.fromHSV(h,1,1); object:Set(Color3.fromHSV(h,s,v)) end
        local function setSV(pos) s=math.clamp((pos.X-sv.AbsolutePosition.X)/sv.AbsoluteSize.X,0,1); v=1-math.clamp((pos.Y-sv.AbsolutePosition.Y)/sv.AbsoluteSize.Y,0,1); marker.Position=UDim2.fromScale(s,1-v); updateColor() end
        local function setH(pos) h=math.clamp((pos.X-hue.AbsolutePosition.X)/hue.AbsoluteSize.X,0,1); hmark.Position=UDim2.fromScale(h,0.5); updateColor() end
        connect(self.Window,sv.InputBegan,function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then draggingSV=true;setSV(i.Position) end end)
        connect(self.Window,hue.InputBegan,function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then draggingH=true;setH(i.Position) end end)
        connect(self.Window,UserInputService.InputChanged,function(i) if draggingSV then setSV(i.Position) elseif draggingH then setH(i.Position) end end)
        connect(self.Window,UserInputService.InputEnded,function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then draggingSV=false;draggingH=false end end)
    end
    connect(self.Window,swatch.MouseButton1Click,function() if not object.Locked then open() end end)
    if config.Flag then AeroUI.Options[config.Flag]=object end
    return object
end
ContainerMethods.ColorPicker=ContainerMethods.Colorpicker

function ContainerMethods:Group(config)
    config=config or {}
    local root=make("Frame",{Parent=self.Container,Size=UDim2.new(1,0,0,44),BackgroundTransparency=1})
    local layout=list(root,config.Spacing or 6,true)
    layout.HorizontalAlignment=Enum.HorizontalAlignment.Left
    local group=setmetatable({Window=self.Window,Container=root,Root=root,Layout=layout},ContainerMethods)
    local function resize()
        local children={}
        for _,child in ipairs(root:GetChildren()) do
            if child:IsA("GuiObject") then table.insert(children,child) end
        end
        local count=#children
        if count==0 then return end
        local gap=(config.Spacing or 6)*(count-1)
        local tallest=44
        for _,child in ipairs(children) do
            child.Size=UDim2.new(1/count,-gap/count,0,child.Size.Y.Offset)
            tallest=math.max(tallest,child.Size.Y.Offset)
        end
        root.Size=UDim2.new(1,0,0,tallest)
    end
    connect(self.Window,root.ChildAdded,function() task.defer(resize) end)
    connect(self.Window,root.ChildRemoved,function() task.defer(resize) end)
    return group
end

function ContainerMethods:Space(config)
    local height=type(config)=="number" and config or ((config and config.Height) or 8)
    return make("Frame",{Parent=self.Container,Size=UDim2.new(1,0,0,height),BackgroundTransparency=1})
end
function ContainerMethods:Divider(config)
    local holder=make("Frame",{Parent=self.Container,Size=UDim2.new(1,0,0,17),BackgroundTransparency=1})
    local line=make("Frame",{Parent=holder,Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0.5,0),BorderSizePixel=0})
    bindTheme(self.Window,line,"BackgroundColor3","Border")
    return holder
end
function ContainerMethods:Section(config)
    if type(config)=="string" then config={Title=config} end; config=config or {}
    local root=make("Frame",{Parent=self.Container,Size=UDim2.new(1,0,0,28),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1})
    local title=createText(self.Window,root,tostring(config.Title or "Section"),14,true); title.Size=UDim2.new(1,0,0,25)
    local content=make("Frame",{Parent=root,Position=UDim2.fromOffset(0,29),Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1})
    list(content,6,false)
    local section=setmetatable({Window=self.Window,Container=content,Root=root},ContainerMethods)
    return section
end

local TabMethods=setmetatable({},ContainerMethods); TabMethods.__index=TabMethods
function TabMethods:Select() self.Window:SelectTab(self) end

local WindowMethods={}; WindowMethods.__index=WindowMethods
function WindowMethods:SetTheme(name)
    local selected=type(name)=="table" and name or AeroUI.Themes[name]
    if not selected then warn("[AeroUI] Unknown theme: "..tostring(name)); return self end
    self.Theme=selected; self.ThemeName=selected.Name; applyTheme(self)
    if self._rgbConnection then self._rgbConnection:Disconnect(); self._rgbConnection=nil end
    if selected.Name=="RGB" then
        local hue=0
        self._rgbConnection=RunService.RenderStepped:Connect(function(dt)
            hue=(hue+dt*0.09)%1; selected.Accent=Color3.fromHSV(hue,0.9,1); applyTheme(self)
        end)
    end
    safeCall(self.Config.OnThemeChange,selected.Name,selected)
    return self
end
function WindowMethods:Tab(config)
    if type(config)=="string" then config={Title=config} end; config=config or {}
    local tab={Window=self,Title=tostring(config.Title or "Tab"),Icon=config.Icon,Index=#self.Tabs+1}
    setmetatable(tab,TabMethods)
    local button=make("TextButton",{Parent=self.TabList,Size=UDim2.new(1,0,0,38),BackgroundTransparency=1,Text="",AutoButtonColor=false})
    corner(button,7)
    local icon=createText(self,button,tostring(config.Icon or "•"),config.Icon and 13 or 17,true); icon.TextXAlignment=Enum.TextXAlignment.Center; icon.Size=UDim2.fromOffset(28,38)
    local label=createText(self,button,tab.Title,12,true); label.Position=UDim2.fromOffset(31,0); label.Size=UDim2.new(1,-38,1,0)
    local page=make("ScrollingFrame",{Parent=self.PageHolder,Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ScrollBarThickness=3,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false})
    bindTheme(self,page,"ScrollBarImageColor3","Accent"); padding(page,2,10,2,10); list(page,8,false)
    tab.Button=button; tab.Page=page; tab.Container=page
    table.insert(self.Tabs,tab)
    connect(self,button.MouseButton1Click,function() self:SelectTab(tab) end)
    connect(self,button.MouseEnter,function() if self.SelectedTab~=tab then tween(button,0.12,{BackgroundTransparency=0.55,BackgroundColor3=self.Theme.Element}) end end)
    connect(self,button.MouseLeave,function() if self.SelectedTab~=tab then tween(button,0.12,{BackgroundTransparency=1}) end end)
    if #self.Tabs==1 then self:SelectTab(tab) end
    return tab
end
WindowMethods.CreateTab=WindowMethods.Tab
function WindowMethods:SelectTab(tab)
    for _,item in ipairs(self.Tabs) do
        local selected=item==tab; item.Page.Visible=selected
        tween(item.Button,0.16,{BackgroundTransparency=selected and 0 or 1,BackgroundColor3=self.Theme.ElementHover})
    end
    self.SelectedTab=tab; self.PageTitle.Text=tab.Title
end
function WindowMethods:Toggle(value)
    if value==nil then value=not self.Visible end; self.Visible=value==true
    self.Root.Visible=true
    if self.Visible then self.Root.Position=self._position; self.Root.GroupTransparency=1; tween(self.Root,0.22,{GroupTransparency=0})
    else self._position=self.Root.Position; local t=tween(self.Root,0.18,{GroupTransparency=1}); t.Completed:Once(function() if not self.Visible then self.Root.Visible=false end end) end
    return self
end
function WindowMethods:Minimize(value)
    if value==nil then value=not self.Minimized end; self.Minimized=value==true
    if self.Minimized then self._fullSize=self.Root.Size; tween(self.Root,0.22,{Size=UDim2.fromOffset(self.Root.AbsoluteSize.X,48)}); self.Body.Visible=false
    else self.Body.Visible=true; tween(self.Root,0.22,{Size=self._fullSize or self.Config.Size or UDim2.fromOffset(650,460)}) end
    return self
end
function WindowMethods:Notify(config) return AeroUI:Notify(config,self) end
function WindowMethods:Dialog(config)
    config=config or {}
    local overlay=make("TextButton",{Parent=self.Root,Size=UDim2.fromScale(1,1),BackgroundColor3=rgb(0,0,0),BackgroundTransparency=0.4,Text="",AutoButtonColor=false,ZIndex=100})
    corner(overlay,self.CornerRadius)
    local box=make("Frame",{Parent=overlay,AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(360,190),ZIndex=101})
    bindTheme(self,box,"BackgroundColor3","Surface"); corner(box,12); local bs=stroke(box,self.Theme.Border,0.2,1);bindTheme(self,bs,"Color","Border")
    local title=createText(self,box,tostring(config.Title or "Dialog"),18,true); title.Position=UDim2.fromOffset(20,15);title.Size=UDim2.new(1,-40,0,28);title.ZIndex=102
    local content=createText(self,box,tostring(config.Content or config.Desc or ""),12,false);content.Position=UDim2.fromOffset(20,48);content.Size=UDim2.new(1,-40,0,70);content.TextWrapped=true;content.TextYAlignment=Enum.TextYAlignment.Top;content.ZIndex=102
    local buttons=make("Frame",{Parent=box,Size=UDim2.new(1,-40,0,34),Position=UDim2.new(0,20,1,-49),BackgroundTransparency=1,ZIndex=102});local layout=list(buttons,8,true);layout.HorizontalAlignment=Enum.HorizontalAlignment.Right
    local dialog={Root=overlay}
    function dialog:Close() tween(overlay,0.15,{BackgroundTransparency=1});task.delay(0.16,function()overlay:Destroy()end) end
    for _,cfg in ipairs(config.Buttons or {{Title="OK"}}) do
        local btn=make("TextButton",{Parent=buttons,Size=UDim2.fromOffset(math.max(76,textWidth(tostring(cfg.Title),12,Enum.Font.GothamSemibold)+26),32),Text=tostring(cfg.Title),TextSize=12,Font=Enum.Font.GothamSemibold,AutoButtonColor=false,ZIndex=103})
        bindTheme(self,btn,"BackgroundColor3",cfg.Variant=="Primary" and "Accent" or "Element");bindTheme(self,btn,"TextColor3",cfg.Variant=="Primary" and "AccentText" or "Text");corner(btn,7)
        connect(self,btn.MouseButton1Click,function() safeCall(cfg.Callback);dialog:Close() end)
    end
    return dialog
end
function WindowMethods:Destroy()
    if self._rgbConnection then self._rgbConnection:Disconnect() end
    for _,connection in ipairs(self._connections) do pcall(function()connection:Disconnect()end) end
    self.ScreenGui:Destroy()
    local index=table.find(AeroUI.Windows,self);if index then table.remove(AeroUI.Windows,index) end
end

function AeroUI:CreateWindow(config)
    config=config or {}
    local selected=self.Themes[config.Theme or "Midnight Blue"] or THEME_LIST[1]
    local window=setmetatable({Config=config,Theme=selected,ThemeName=selected.Name,Tabs={},_themeBindings={},_connections={},Visible=true,Minimized=false,CornerRadius=config.CornerRadius or 11},WindowMethods)
    local screen=make("ScreenGui",{Name="AeroUI_"..tostring(math.random(10000,99999)),ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,DisplayOrder=config.DisplayOrder or 20,Parent=getParent()})
    local popupLayer=make("Frame",{Parent=screen,Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=40})
    local size=config.Size or UDim2.fromOffset(650,460)
    if type(size)=="table" then size=UDim2.fromOffset(size.X or 650,size.Y or 460) end
    local root=make("CanvasGroup",{Parent=screen,AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=size,BorderSizePixel=0,ClipsDescendants=true})
    bindTheme(window,root,"BackgroundColor3","Background");corner(root,window.CornerRadius);local rs=stroke(root,selected.Border,0.2,1);bindTheme(window,rs,"Color","Border")
    local top=make("Frame",{Parent=root,Size=UDim2.new(1,0,0,48),BackgroundTransparency=1})
    local title=createText(window,top,tostring(config.Title or "AeroUI"),15,true);title.Position=UDim2.fromOffset(17,4);title.Size=UDim2.new(1,-145,0,23)
    local subtitle=createText(window,top,tostring(config.SubTitle or config.Author or ""),10,false);subtitle.Position=UDim2.fromOffset(17,25);subtitle.Size=UDim2.new(1,-145,0,15);subtitle.Visible=subtitle.Text~=""
    local controls=make("Frame",{Parent=top,Size=UDim2.fromOffset(102,32),Position=UDim2.new(1,-112,0,8),BackgroundTransparency=1});list(controls,4,true)
    local function control(textValue,colorKey,callback)
        local b=make("TextButton",{Parent=controls,Size=UDim2.fromOffset(30,30),Text=textValue,TextSize=14,Font=Enum.Font.GothamSemibold,BackgroundTransparency=1,AutoButtonColor=false});bindTheme(window,b,"TextColor3",colorKey or "SubText");corner(b,7)
        connect(window,b.MouseEnter,function()tween(b,0.12,{BackgroundTransparency=0,BackgroundColor3=window.Theme.ElementHover})end);connect(window,b.MouseLeave,function()tween(b,0.12,{BackgroundTransparency=1})end);connect(window,b.MouseButton1Click,callback);return b
    end
    control("—","SubText",function()window:Minimize()end);control("□","SubText",function()window:Toggle()end);control("×","Error",function()if config.CloseCallback then safeCall(config.CloseCallback,window) else window:Destroy() end end)
    local line=make("Frame",{Parent=root,Size=UDim2.new(1,0,0,1),Position=UDim2.fromOffset(0,47),BorderSizePixel=0});bindTheme(window,line,"BackgroundColor3","Border")
    local body=make("Frame",{Parent=root,Size=UDim2.new(1,0,1,-48),Position=UDim2.fromOffset(0,48),BackgroundTransparency=1})
    local sidebar=make("Frame",{Parent=body,Size=UDim2.new(0,config.TabWidth or 170,1,0),BorderSizePixel=0});bindTheme(window,sidebar,"BackgroundColor3","Surface")
    local tabList=make("ScrollingFrame",{Parent=sidebar,Size=UDim2.new(1,-16,1,-20),Position=UDim2.fromOffset(8,10),BackgroundTransparency=1,ScrollBarThickness=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y});list(tabList,5,false)
    local separator=make("Frame",{Parent=body,Size=UDim2.new(0,1,1,0),Position=UDim2.fromOffset(config.TabWidth or 170,0),BorderSizePixel=0});bindTheme(window,separator,"BackgroundColor3","Border")
    local content=make("Frame",{Parent=body,Size=UDim2.new(1,-(config.TabWidth or 170)-1,1,0),Position=UDim2.fromOffset((config.TabWidth or 170)+1,0),BackgroundTransparency=1})
    local pageTitle=createText(window,content,"",17,true);pageTitle.Position=UDim2.fromOffset(18,8);pageTitle.Size=UDim2.new(1,-36,0,32)
    local pages=make("Frame",{Parent=content,Size=UDim2.new(1,-32,1,-50),Position=UDim2.fromOffset(16,44),BackgroundTransparency=1})
    window.ScreenGui=screen;window.PopupLayer=popupLayer;window.Root=root;window.Body=body;window.Sidebar=sidebar;window.TabList=tabList;window.PageHolder=pages;window.PageTitle=pageTitle;window._position=root.Position;window._fullSize=size
    local dragging=false;local dragStart;local startPosition
    connect(window,top.InputBegan,function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true;dragStart=input.Position;startPosition=root.Position end end)
    connect(window,UserInputService.InputChanged,function(input) if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then local d=input.Position-dragStart;root.Position=UDim2.new(startPosition.X.Scale,startPosition.X.Offset+d.X,startPosition.Y.Scale,startPosition.Y.Offset+d.Y);window._position=root.Position end end)
    connect(window,UserInputService.InputEnded,function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
    local bind=config.ToggleKey or config.KeySystem and config.KeySystem.ToggleKey
    if type(bind)=="string" then bind=Enum.KeyCode[bind] end
    if bind then connect(window,UserInputService.InputBegan,function(input,processed)if not processed and input.KeyCode==bind then window:Toggle() end end) end
    table.insert(self.Windows,window);applyTheme(window)
    return window
end

function AeroUI:Notify(config, window)
    config=config or {}
    local owner=window or self.Windows[#self.Windows]
    if not owner then warn("[AeroUI] Create a window before sending notifications");return end
    if not owner.NotificationHolder then
        local holder=make("Frame",{Parent=owner.ScreenGui,Size=UDim2.fromOffset(320,500),Position=UDim2.new(1,-20,1,-20),AnchorPoint=Vector2.new(1,1),BackgroundTransparency=1,ZIndex=80});local l=list(holder,9,false);l.VerticalAlignment=Enum.VerticalAlignment.Bottom;owner.NotificationHolder=holder
    end
    local toast=make("Frame",{Parent=owner.NotificationHolder,Size=UDim2.new(1,0,0,76),BackgroundTransparency=0,BorderSizePixel=0,ZIndex=81});bindTheme(owner,toast,"BackgroundColor3","Surface");corner(toast,10);local ts=stroke(toast,owner.Theme.Border,0.2,1);bindTheme(owner,ts,"Color","Border")
    local kind=config.Type or "Info";local key=kind=="Success" and "Success" or kind=="Warning" and "Warning" or kind=="Error" and "Error" or "Accent"
    local stripe=make("Frame",{Parent=toast,Size=UDim2.new(0,3,1,-16),Position=UDim2.fromOffset(7,8),BorderSizePixel=0,ZIndex=82});bindTheme(owner,stripe,"BackgroundColor3",key);corner(stripe,999)
    local title=createText(owner,toast,tostring(config.Title or kind),13,true);title.Position=UDim2.fromOffset(18,10);title.Size=UDim2.new(1,-50,0,20);title.ZIndex=82
    local content=createText(owner,toast,tostring(config.Content or config.Desc or ""),11,false);content.Position=UDim2.fromOffset(18,31);content.Size=UDim2.new(1,-35,0,34);content.TextWrapped=true;content.TextYAlignment=Enum.TextYAlignment.Top;content.ZIndex=82
    local close=make("TextButton",{Parent=toast,Size=UDim2.fromOffset(24,24),Position=UDim2.new(1,-29,0,5),Text="×",TextSize=15,BackgroundTransparency=1,ZIndex=83});bindTheme(owner,close,"TextColor3","SubText")
    toast.Position=UDim2.fromOffset(350,0);tween(toast,0.3,{Position=UDim2.fromOffset(0,0)})
    local closed=false;local function dismiss()if closed then return end;closed=true;tween(toast,0.22,{Position=UDim2.fromOffset(350,0),BackgroundTransparency=1});task.delay(0.23,function()toast:Destroy()end)end
    connect(owner,close.MouseButton1Click,dismiss);if config.Duration~=0 then task.delay(config.Duration or 4,dismiss)end
    return {Close=dismiss,Root=toast}
end

function AeroUI:SetTheme(name)
    for _,window in ipairs(self.Windows) do window:SetTheme(name) end
end
function AeroUI:Destroy()
    local copy=table.clone(self.Windows);for _,window in ipairs(copy) do window:Destroy() end
end

return AeroUI
