-- ============================================================
--  NH HUB - BLOODMOON UI LIBRARY (Single File)
--  Phone-style Script Hub • Tab Bar (Icons) • Key System
--  Icons referenced by NAME (Lucide) -> resolved internally
--  Drag • Minimize • Small UI • NH Logo (N=White, H=Blue)
-- ============================================================
--  Cara pakai ada di paling bawah (CONTOH PEMAKAIAN)
-- ============================================================

local NHHub = {}
NHHub.__index = NHHub

-- // SERVICES
local Players       = game:GetService("Players")
local TweenService  = game:GetService("TweenService")
local UIS           = game:GetService("UserInputService")
local RunService    = game:GetService("RunService")
local HttpService   = game:GetService("HttpService")
local LocalPlayer   = Players.LocalPlayer
local PlayerGui     = LocalPlayer:WaitForChild("PlayerGui")

-- // HELPERS
local function CSK(t,c) return ColorSequenceKeypoint.new(t,c) end
local function NSK(t,n) return NumberSequenceKeypoint.new(t,n) end

local function Inst(class, parent, props)
	local i = Instance.new(class)
	if props then
		for k, v in pairs(props) do
			if v ~= nil then i[k] = v end
		end
	end
	i.Parent = parent
	return i
end

local function Tween(obj, props, dur, style, dir)
	TweenService:Create(obj,
		TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
		props):Play()
end

-- // ICON LIBRARY (Lucide) - dipanggil pakai NAMA, bukan Asset ID
local Icons = {
	["activity"]="rbxassetid://94212016861936",["award"]="rbxassetid://132740088158419",
	["badge-check"]="rbxassetid://76078495178149",["bell"]="rbxassetid://97392696311902",
	["bomb"]="rbxassetid://139223800924636",["bookmark"]="rbxassetid://121093149326239",
	["bot"]="rbxassetid://80451686744860",["box"]="rbxassetid://101768155599700",
	["bug"]="rbxassetid://83626408925438",["calendar"]="rbxassetid://114792700814035",
	["camera"]="rbxassetid://79950339943067",["cat"]="rbxassetid://124252153404931",
	["check"]="rbxassetid://93898873302694",["chevron-down"]="rbxassetid://134243273101015",
	["chevron-left"]="rbxassetid://73780377692148",["chevron-right"]="rbxassetid://92473583511724",
	["chevron-up"]="rbxassetid://122444883127455",["chevrons-left"]="rbxassetid://82617201744347",
	["chevrons-right"]="rbxassetid://139121276490483",["circle"]="rbxassetid://130359823580534",
	["circle-dot"]="rbxassetid://82947033619201",["circle-user"]="rbxassetid://136220511671311",
	["clock"]="rbxassetid://121808839832144",["code"]="rbxassetid://107380207681249",
	["coins"]="rbxassetid://116510979641930",["command"]="rbxassetid://93648221906330",
	["compass"]="rbxassetid://115123411028382",["copy"]="rbxassetid://78979572434545",
	["cpu"]="rbxassetid://77549309870247",["credit-card"]="rbxassetid://99163352872346",
	["crosshair"]="rbxassetid://134242818164054",["crown"]="rbxassetid://127843403295538",
	["dog"]="rbxassetid://71920105558570",["download"]="rbxassetid://134814648082393",
	["droplet"]="rbxassetid://100597455015098",["external-link"]="rbxassetid://129331830773832",
	["eye"]="rbxassetid://100033680381365",["eye-off"]="rbxassetid://135928786788378",
	["feather"]="rbxassetid://91872927606406",["file"]="rbxassetid://74748492079329",
	["fish"]="rbxassetid://124360663785796",["flame"]="rbxassetid://98218034436456",
	["folder"]="rbxassetid://80846616596607",["gamepad"]="rbxassetid://121607283959010",
	["gamepad-2"]="rbxassetid://92483947987410",["gauge"]="rbxassetid://110273524101447",
	["gem"]="rbxassetid://112904952151156",["ghost"]="rbxassetid://113822048130017",
	["gift"]="rbxassetid://109855212076373",["globe"]="rbxassetid://114238209622913",
	["hammer"]="rbxassetid://83545120140895",["hand"]="rbxassetid://130703864968637",
	["heart"]="rbxassetid://116559368303288",["home"]="rbxassetid://98755624629571",
	["house"]="rbxassetid://98755624629571",["image"]="rbxassetid://112751259236831",
	["info"]="rbxassetid://124560466474914",["key"]="rbxassetid://96510194465420",
	["key-round"]="rbxassetid://83619031955390",["layout-dashboard"]="rbxassetid://139929981863901",
	["layout-grid"]="rbxassetid://81344910161871",["lightbulb"]="rbxassetid://103871245626488",
	["link"]="rbxassetid://131607023382430",["list"]="rbxassetid://113179976918783",
	["loader"]="rbxassetid://78408734580845",["lock"]="rbxassetid://134724289526879",
	["log-in"]="rbxassetid://103768533135201",["log-out"]="rbxassetid://84895399304975",
	["mail"]="rbxassetid://103945161245599",["map"]="rbxassetid://95107167260947",
	["maximize"]="rbxassetid://76045941763188",["megaphone"]="rbxassetid://118759541854879",
	["menu"]="rbxassetid://77021539815611",["message-circle"]="rbxassetid://127255077587058",
	["minimize"]="rbxassetid://121304296213645",["minimize-2"]="rbxassetid://116269596042539",
	["minus"]="rbxassetid://118026365011536",["monitor"]="rbxassetid://72664649203050",
	["moon"]="rbxassetid://83380517901735",["mouse-pointer"]="rbxassetid://72322454962935",
	["music"]="rbxassetid://113343203848535",["nut"]="rbxassetid://127146410705656",
	["package"]="rbxassetid://97261141732706",["palette"]="rbxassetid://86350350950064",
	["pause"]="rbxassetid://74873705394436",["pencil"]="rbxassetid://137986121120732",
	["phone"]="rbxassetid://128804946640049",["play"]="rbxassetid://135609604299893",
	["plus"]="rbxassetid://111774323017047",["power"]="rbxassetid://96479131758775",
	["puzzle"]="rbxassetid://136837798892463",["radar"]="rbxassetid://138528222906635",
	["recycle"]="rbxassetid://140417023381961",["refresh-cw"]="rbxassetid://138133190015277",
	["repeat"]="rbxassetid://121886242955173",["rocket"]="rbxassetid://87412317685854",
	["rotate-ccw"]="rbxassetid://110116685948665",["rotate-cw"]="rbxassetid://84183336178654",
	["save"]="rbxassetid://126116963775616",["scan"]="rbxassetid://123104789658180",
	["search"]="rbxassetid://121018724060431",["send"]="rbxassetid://127751956873796",
	["settings"]="rbxassetid://80758916183665",["settings-2"]="rbxassetid://135684703553372",
	["shield"]="rbxassetid://110987169760162",["shield-alert"]="rbxassetid://114995877719925",
	["shield-check"]="rbxassetid://87354736164608",["shield-x"]="rbxassetid://73370117343811",
	["shopping-cart"]="rbxassetid://128420521375441",["skull"]="rbxassetid://137726256442333",
	["sliders-horizontal"]="rbxassetid://85538382643347",["smartphone"]="rbxassetid://96623008834511",
	["sparkles"]="rbxassetid://138635884129147",["speaker"]="rbxassetid://96227183003618",
	["square"]="rbxassetid://86304921356806",["star"]="rbxassetid://136141469398409",
	["sun"]="rbxassetid://110150589884127",["sun-moon"]="rbxassetid://75752898854559",
	["sword"]="rbxassetid://124448418211665",["swords"]="rbxassetid://81872698913435",
	["tablet"]="rbxassetid://128403991264386",["tag"]="rbxassetid://129104970103940",
	["target"]="rbxassetid://87563802520297",["telescope"]="rbxassetid://91755049143647",
	["terminal"]="rbxassetid://106783148545356",["thumbs-up"]="rbxassetid://111137070767020",
	["ticket"]="rbxassetid://126527071492145",["toggle-left"]="rbxassetid://85887872573050",
	["trash-2"]="rbxassetid://109843431391323",["trending-up"]="rbxassetid://81819858538839",
	["triangle"]="rbxassetid://126330486745540",["trophy"]="rbxassetid://131545003268773",
	["upload"]="rbxassetid://138212042425501",["user"]="rbxassetid://81589895647169",
	["users"]="rbxassetid://115398113982385",["video"]="rbxassetid://107587444636945",
	["volume-2"]="rbxassetid://89344380902620",["wallet"]="rbxassetid://132331555762628",
	["wand"]="rbxassetid://114580617777835",["wifi"]="rbxassetid://104669375183960",
	["wifi-off"]="rbxassetid://74113634330106",["wind"]="rbxassetid://114551690399915",
	["wrench"]="rbxassetid://112148279212860",["x"]="rbxassetid://110786993356448",
	["zap"]="rbxassetid://130551565616516",["zap-off"]="rbxassetid://81385483183652",
	["app-window"]="rbxassetid://93142176757189",["arrow-big-down"]="rbxassetid://81081164158885",
	["arrow-big-up"]="rbxassetid://93136954756149",["circle-alert"]="rbxassetid://83898160590116",
	["circle-check"]="rbxassetid://85262178816537",["circle-x"]="rbxassetid://76821953846248",
	["panel-left"]="rbxassetid://97419752870313",["panel-right"]="rbxassetid://116365035443156",
}

-- alias nama umum
local IconAlias = {
	["alert-triangle"]="circle-alert",["alert-circle"]="circle-alert",
	["check-circle"]="circle-check",["help-circle"]="circle-alert",
	["edit"]="pencil",["grid"]="layout-grid",["filter"]="sliders-horizontal",
	["settings-gear"]="settings",
}

local function GetIcon(name)
	if type(name) == "string" then
		if name:match("^rbxasset") then return name end
		local n = IconAlias[name] or name
		if Icons[n] then return Icons[n] end
	end
	return Icons["circle-dot"]
end

-- // THEME : BLOODMOON
local C = {
	BG        = Color3.fromRGB(15, 9, 11),
	Surface   = Color3.fromRGB(26, 16, 19),
	Surface2  = Color3.fromRGB(38, 24, 28),
	Stroke    = Color3.fromRGB(74, 40, 46),
	Blood     = Color3.fromRGB(205, 32, 48),
	BloodDark = Color3.fromRGB(120, 18, 28),
	BloodGlow = Color3.fromRGB(255, 84, 98),
	Text      = Color3.fromRGB(242, 232, 234),
	TextDim   = Color3.fromRGB(168, 152, 156),
	White     = Color3.fromRGB(255, 255, 255),
	Blue      = Color3.fromRGB(64, 140, 255), -- warna H
	Success   = Color3.fromRGB(40, 175, 110),
	Error     = Color3.fromRGB(225, 65, 75),
}

-- // GUI PARENT
local function GetGuiParent()
	local ok, hui = pcall(function() return gethui() end)
	if ok and hui then return hui end
	local ok2, cg = pcall(function() return game:GetService("CoreGui") end)
	if ok2 and cg then return cg end
	return PlayerGui
end

-- ============================================================
--  BUILD LIBRARY
-- ============================================================
function NHHub.new(cfg)
	cfg = cfg or {}
	local self = setmetatable({}, NHHub)

	self.Config = {
		Name        = cfg.Name or "NH HUB",
		Key         = cfg.Key or "NHHUB-BLOODMOON",
		Keys        = cfg.Keys or nil,
		ValidateKey = cfg.ValidateKey or nil,
		GetKeyLink  = cfg.GetKeyLink or "https://your-link.com/getkey",
		Discord     = cfg.Discord or "https://discord.gg/yourserver",
		SkipKey     = cfg.SkipKey or false,
		Size        = cfg.Size or UDim2.new(0, 350, 0, 600),
	}
	self.Tabs = {}
	self._dropdowns = {}

	-- valid keys normalization
	self.ValidKeys = {}
	if type(self.Config.Keys) == "table" then
		for _, v in ipairs(self.Config.Keys) do table.insert(self.ValidKeys, tostring(v)) end
	else
		table.insert(self.ValidKeys, tostring(self.Config.Key))
	end

	-- // SCREEN GUI
	local ScreenGui = Inst("ScreenGui", GetGuiParent(), {
		Name = "NH_Hub", ResetOnSpawn = false, IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Global, DisplayOrder = 999,
	})
	self.ScreenGui = ScreenGui

	-- // MAIN (phone frame)
	local Main = Inst("Frame", ScreenGui, {
		Name = "MainPhone", Size = self.Config.Size,
		Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = C.BG, BorderSizePixel = 0, ClipsDescendants = true,
		Visible = false, ZIndex = 1,
	})
	Inst("UICorner", Main, { CornerRadius = UDim.new(0, 26) })
	Inst("UIStroke", Main, { Color = C.Blood, Thickness = 1.5, Transparency = 0.35 })

	-- glow aura behind phone
	local Aura = Inst("Frame", ScreenGui, {
		Name = "Aura", Size = self.Config.Size + UDim2.new(0, 26, 0, 26),
		Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = C.BloodDark, BackgroundTransparency = 0.82,
		BorderSizePixel = 0, ZIndex = 0, Visible = false,
	})
	Inst("UICorner", Aura, { CornerRadius = UDim.new(0, 34) })
	self.Aura = Aura

	-- top blood-moon glow
	local TopGlow = Inst("Frame", Main, {
		Size = UDim2.new(1, 0, 0, 160), Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = C.BloodDark, BackgroundTransparency = 0.55,
		BorderSizePixel = 0, ZIndex = 1,
	})
	Inst("UIGradient", TopGlow, {
		Color = ColorSequence.new{ CSK(0, C.BloodDark), CSK(1, C.BG) },
		Transparency = NumberSequence.new{ NSK(0, 0.35), NSK(1, 1) },
	})

	-- // HEADER (drag area)
	local Header = Inst("Frame", Main, {
		Size = UDim2.new(1, 0, 0, 50), Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1, ZIndex = 10,
	})

	-- logo NH (N putih, H biru)
	local Logo = Inst("Frame", Header, {
		Size = UDim2.new(0, 34, 0, 34), Position = UDim2.new(0, 12, 0.5, -17),
		BackgroundColor3 = C.BloodDark, ZIndex = 11,
	})
	Inst("UICorner", Logo, { CornerRadius = UDim.new(0, 9) })
	Inst("UIGradient", Logo, {
		Color = ColorSequence.new{ CSK(0, C.Blood), CSK(1, C.BloodDark) },
	})
	Inst("UIStroke", Logo, { Color = C.BloodGlow, Thickness = 1.5, Transparency = 0.4 })
	local LogoTxt = Inst("TextLabel", Logo, {
		Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, RichText = true,
		Text = [[<font color="#FFFFFF">N</font><font color="#46A0FF">H</font>]],
		Font = Enum.Font.FredokaOne, TextSize = 20, TextColor3 = C.White,
		ZIndex = 12,
	})

	local Title = Inst("TextLabel", Header, {
		Size = UDim2.new(0, 150, 1, 0), Position = UDim2.new(0, 54, 0, 0),
		BackgroundTransparency = 1, Text = self.Config.Name, TextColor3 = C.Text,
		Font = Enum.Font.GothamBold, TextSize = 17, TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 11,
	})

	-- clock
	local Clock = Inst("TextLabel", Header, {
		Size = UDim2.new(0, 64, 1, 0), Position = UDim2.new(1, -118, 0, 0),
		BackgroundTransparency = 1, Text = "00:00", TextColor3 = C.BloodGlow,
		Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right,
		ZIndex = 11,
	})
	task.spawn(function()
		while Clock.Parent do
			local ok, t = pcall(function() return os.date("%H:%M") end)
			if ok then Clock.Text = t end
			task.wait(1)
		end
	end)

	-- wifi icon (decorative)
	Inst("ImageLabel", Header, {
		Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -150, 0.5, -8),
		BackgroundTransparency = 1, Image = GetIcon("wifi"), ImageColor3 = C.TextDim, ZIndex = 11,
	})

	-- // MINIMIZE + CLOSE buttons (siblings of header, not children -> no drag conflict)
	local MinBtn = Inst("TextButton", Main, {
		Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -66, 0, 10),
		BackgroundTransparency = 1, AutoButtonColor = false, ZIndex = 20,
	})
	Inst("ImageLabel", MinBtn, {
		Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0.5, -9, 0.5, -9),
		BackgroundTransparency = 1, Image = GetIcon("minus"), ImageColor3 = C.Text, ZIndex = 21,
	})
	local CloseBtn = Inst("TextButton", Main, {
		Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -34, 0, 10),
		BackgroundTransparency = 1, AutoButtonColor = false, ZIndex = 20,
	})
	Inst("ImageLabel", CloseBtn, {
		Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0.5, -9, 0.5, -9),
		BackgroundTransparency = 1, Image = GetIcon("x"), ImageColor3 = C.Text, ZIndex = 21,
	})

	-- // CONTENT
	local Content = Inst("ScrollingFrame", Main, {
		Size = UDim2.new(1, 0, 1, -112), Position = UDim2.new(0, 0, 0, 50),
		BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4,
		ScrollBarImageColor3 = C.BloodDark, ScrollBarImageTransparency = 0.3,
		TopImage = "rbxassetid://0", BottomImage = "rbxassetid://0",
		AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar, ZIndex = 2,
	})
	self.Content = Content

	-- // TAB BAR (app-like)
	local TabBar = Inst("Frame", Main, {
		Size = UDim2.new(1, 0, 0, 62), Position = UDim2.new(0, 0, 1, -62),
		BackgroundColor3 = C.Surface, BorderSizePixel = 0, ZIndex = 10,
	})
	Inst("UIStroke", TabBar, { Color = C.Stroke, Thickness = 1, Transparency = 0.4 })
	local TabLayout = Inst("UIListLayout", TabBar, {
		SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalFlex = Enum.UIFlexAlignment.Fill, Padding = UDim.new(0, 0),
	})

	-- // DROPDOWN backdrop (global Z)
	local DropBackdrop = Inst("TextButton", Main, {
		Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
		AutoButtonColor = false, ZIndex = 90, Visible = false,
	})
	DropBackdrop.MouseButton1Click:Connect(function()
		for _, d in ipairs(self._dropdowns) do d.Visible = false end
		DropBackdrop.Visible = false
	end)
	self.DropBackdrop = DropBackdrop

	self.Main = Main

	-- // FLOATING MINIMIZE BUTTON (on ScreenGui)
	local Float = Inst("TextButton", ScreenGui, {
		Size = UDim2.new(0, 52, 0, 52), Position = UDim2.new(1, -64, 1, -64),
		BackgroundColor3 = C.BloodDark, BorderSizePixel = 0, ZIndex = 300, Visible = false,
		AutoButtonColor = false, Text = "",
	})
	Inst("UICorner", Float, { CornerRadius = UDim.new(1, 0) })
	Inst("UIGradient", Float, {
		Color = ColorSequence.new{ CSK(0, C.Blood), CSK(1, C.BloodDark) },
	})
	Inst("UIStroke", Float, { Color = C.BloodGlow, Thickness = 2, Transparency = 0.3 })
	local FloatTxt = Inst("TextLabel", Float, {
		Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, RichText = true,
		Text = [[<font color="#FFFFFF">N</font><font color="#46A0FF">H</font>]],
		Font = Enum.Font.FredokaOne, TextSize = 22, TextColor3 = C.White, ZIndex = 301,
	})
	self.Float = Float

	-- ============================================================
	--  DRAG (header)
	-- ============================================================
	local dragging, dragStart, startPos
	Header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
		end
	end)
	Header.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - dragStart
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	Header.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	-- drag floating button
	local fDragging, fStart, fPos
	Float.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			fDragging = true; fStart = input.Position; fPos = Float.Position
		end
	end)
	Float.InputChanged:Connect(function(input)
		if fDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - fStart
			Float.Position = UDim2.new(fPos.X.Scale, fPos.X.Offset + d.X, fPos.Y.Scale, fPos.Y.Offset + d.Y)
		end
	end)
	Float.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			fDragging = false
		end
	end)

	MinBtn.MouseButton1Click:Connect(function() self:Minimize() end)
	CloseBtn.MouseButton1Click:Connect(function() self:Destroy() end)
	Float.MouseButton1Click:Connect(function() self:Restore() end)

	-- ============================================================
	--  TAB MANAGEMENT
	-- ============================================================
	function self:SelectTab(idx)
		for i, t in ipairs(self.Tabs) do
			local act = (i == idx)
			t.Page.Visible = act
			t.Icon.ImageColor3 = act and C.BloodGlow or C.TextDim
			t.Label.TextColor3 = act and C.BloodGlow or C.TextDim
			t.Indicator.Visible = act
		end
	end

	function self:CreateTab(opts)
		opts = opts or {}
		local name = opts.Name or ("Tab " .. (#self.Tabs + 1))
		local iconName = opts.Icon or "layout-grid"
		local isFirst = (#self.Tabs == 0)

		local page = Inst("ScrollingFrame", Content, {
			Name = name, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
			BorderSizePixel = 0, ScrollBarThickness = 4, ScrollBarImageColor3 = C.BloodDark,
			ScrollBarImageTransparency = 0.3, TopImage = "rbxassetid://0", BottomImage = "rbxassetid://0",
			AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0, 0, 0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
			Visible = isFirst, ZIndex = 2,
		})
		Inst("UIListLayout", page, {
			SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
		})
		Inst("UIPadding", page, {
			PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
			PaddingLeft = UDim.new(0, 0), PaddingRight = UDim.new(0, 0),
		})

		local btn = Inst("TextButton", TabBar, {
			Name = name, Size = UDim2.new(0, 50, 1, 0), BackgroundTransparency = 1,
			AutoButtonColor = false, ZIndex = 11, LayoutOrder = #self.Tabs + 1,
		})
		local ico = Inst("ImageLabel", btn, {
			Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0.5, -11, 0, 8),
			BackgroundTransparency = 1, Image = GetIcon(iconName),
			ImageColor3 = isFirst and C.BloodGlow or C.TextDim, ZIndex = 12,
		})
		local lbl = Inst("TextLabel", btn, {
			Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 0, 33),
			BackgroundTransparency = 1, Text = name,
			TextColor3 = isFirst and C.BloodGlow or C.TextDim,
			Font = Enum.Font.Gotham, TextSize = 11, TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 12,
		})
		local ind = Inst("Frame", btn, {
			Size = UDim2.new(0, 24, 0, 3), Position = UDim2.new(0.5, -12, 1, -5),
			BackgroundColor3 = C.BloodGlow, Visible = isFirst, ZIndex = 12,
		})
		Inst("UICorner", ind, { CornerRadius = UDim.new(1, 0) })

		local Tab = { Page = page, Icon = ico, Label = lbl, Indicator = ind, Order = 0, Library = self }

		function Tab:AddRow(height, clickable, autosize)
			self.Order = self.Order + 1
			local cls = clickable and "TextButton" or "Frame"
			local row = Inst(cls, self.Page, {
				Name = "Row", BackgroundColor3 = C.Surface,
				AutomaticSize = autosize and Enum.AutomaticSize.Y or nil,
				Size = autosize and UDim2.new(1, -24, 0, 0) or UDim2.new(1, -24, 0, height),
				LayoutOrder = self.Order, ClipsDescendants = true,
				AutoButtonColor = false, ZIndex = 2,
			})
			if clickable then
				row.MouseEnter:Connect(function() Tween(row, { BackgroundColor3 = C.Surface2 }) end)
				row.MouseLeave:Connect(function() Tween(row, { BackgroundColor3 = C.Surface }) end)
			end
			Inst("UICorner", row, { CornerRadius = UDim.new(0, 10) })
			Inst("UIStroke", row, { Color = C.Stroke, Thickness = 1, Transparency = 0.4 })
			return row
		end

		-- BUTTON
		function Tab:CreateButton(opts)
			opts = opts or {}
			local name = opts.Name or "Button"
			local cb = opts.Callback or function() end
			local row = self:AddRow(44, true)
			Inst("TextLabel", row, {
				Size = UDim2.new(1, -46, 1, 0), Position = UDim2.new(0, 12, 0, 0),
				BackgroundTransparency = 1, Text = name, TextColor3 = C.Text,
				Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
			})
			Inst("ImageLabel", row, {
				Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -30, 0.5, -9),
				BackgroundTransparency = 1, Image = GetIcon(opts.Icon or "chevron-right"),
				ImageColor3 = C.TextDim, ZIndex = 3,
			})
			row.MouseButton1Click:Connect(function() cb() end)
			return { Row = row }
		end

		-- TOGGLE
		function Tab:CreateToggle(opts)
			opts = opts or {}
			local name = opts.Name or "Toggle"
			local state = opts.Default or false
			local cb = opts.Callback or function() end
			local row = self:AddRow(46, true)
			Inst("TextLabel", row, {
				Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 12, 0, 0),
				BackgroundTransparency = 1, Text = name, TextColor3 = C.Text,
				Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
			})
			local pill = Inst("Frame", row, {
				Size = UDim2.new(0, 44, 0, 22), Position = UDim2.new(1, -16, 0.5, -11),
				BackgroundColor3 = state and C.Blood or C.BloodDark, ZIndex = 3,
			})
			Inst("UICorner", pill, { CornerRadius = UDim.new(1, 0) })
			local knob = Inst("Frame", pill, {
				Size = UDim2.new(0, 18, 0, 18),
				Position = state and UDim2.new(1, -11, 0.5, 0) or UDim2.new(0, 11, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = C.White, ZIndex = 4,
			})
			Inst("UICorner", knob, { CornerRadius = UDim.new(1, 0) })
			local function refresh()
				Tween(pill, { BackgroundColor3 = state and C.Blood or C.BloodDark })
				Tween(knob, { Position = state and UDim2.new(1, -11, 0.5, 0) or UDim2.new(0, 11, 0.5, 0) })
				pcall(cb, state)
			end
			row.MouseButton1Click:Connect(function() state = not state; refresh() end)
			refresh()
			return { Set = function(v) if v ~= state then state = v; refresh() end end, Get = function() return state end, Row = row }
		end

		-- SLIDER
		function Tab:CreateSlider(opts)
			opts = opts or {}
			local name = opts.Name or "Slider"
			local min = opts.Min or 0
			local max = opts.Max or 100
			local def = opts.Default or min
			local suffix = opts.Suffix or ""
			local cb = opts.Callback or function() end
			local row = self:AddRow(56, false)
			Inst("TextLabel", row, {
				Size = UDim2.new(1, -90, 0, 18), Position = UDim2.new(0, 12, 0, 8),
				BackgroundTransparency = 1, Text = name, TextColor3 = C.Text,
				Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
			})
			local valLbl = Inst("TextLabel", row, {
				Size = UDim2.new(0, 80, 0, 18), Position = UDim2.new(1, -12, 0, 8),
				BackgroundTransparency = 1, Text = tostring(math.floor(def + 0.5)) .. suffix,
				TextColor3 = C.BloodGlow, Font = Enum.Font.GothamBold, TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 3,
			})
			local track = Inst("Frame", row, {
				Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 1, -16),
				BackgroundColor3 = C.Stroke, ZIndex = 3,
			})
			Inst("UICorner", track, { CornerRadius = UDim.new(1, 0) })
			local fill = Inst("Frame", track, {
				Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = C.Blood, ZIndex = 4,
			})
			Inst("UICorner", fill, { CornerRadius = UDim.new(1, 0) })
			local knob = Inst("Frame", track, {
				Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = C.White, ZIndex = 5,
			})
			Inst("UICorner", knob, { CornerRadius = UDim.new(1, 0) })
			local value = def
			local function setFromX(x)
				local abs = track.AbsolutePosition.X
				local w = track.AbsoluteSize.X
				local t = math.clamp((x - abs) / w, 0, 1)
				value = min + t * (max - min)
				local v = math.floor(value + 0.5)
				fill.Size = UDim2.new(t, 0, 1, 0)
				knob.Position = UDim2.new(t, 0, 0.5, 0)
				valLbl.Text = tostring(v) .. suffix
				pcall(cb, v)
			end
			local dragging = false
			track.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
					dragging = true; setFromX(i.Position.X)
				end
			end)
			track.InputChanged:Connect(function(i)
				if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
					setFromX(i.Position.X)
				end
			end)
			track.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)
			local t0 = math.clamp((def - min) / (max - min), 0, 1)
			fill.Size = UDim2.new(t0, 0, 1, 0)
			knob.Position = UDim2.new(t0, 0, 0.5, 0)
			return { Set = function(v) value = v; local t = math.clamp((v - min) / (max - min), 0, 1); fill.Size = UDim2.new(t, 0, 1, 0); knob.Position = UDim2.new(t, 0, 0.5, 0); valLbl.Text = tostring(math.floor(v + 0.5)) .. suffix end, Get = function() return value end, Row = row }
		end

		-- DROPDOWN
		function Tab:CreateDropdown(opts)
			opts = opts or {}
			local name = opts.Name or "Dropdown"
			local options = opts.Options or {}
			local current = opts.Default or options[1] or ""
			local cb = opts.Callback or function() end
			local row = self:AddRow(44, false)
			Inst("TextLabel", row, {
				Size = UDim2.new(1, -150, 1, 0), Position = UDim2.new(0, 12, 0, 0),
				BackgroundTransparency = 1, Text = name, TextColor3 = C.Text,
				Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
			})
			local box = Inst("TextButton", row, {
				Size = UDim2.new(0, 130, 0, 28), Position = UDim2.new(1, -12, 0.5, -14),
				BackgroundColor3 = C.Surface2, AutoButtonColor = false, Text = "", ZIndex = 3,
			})
			Inst("UICorner", box, { CornerRadius = UDim.new(0, 8) })
			local val = Inst("TextLabel", box, {
				Size = UDim2.new(1, -26, 1, 0), Position = UDim2.new(0, 8, 0, 0),
				BackgroundTransparency = 1, Text = tostring(current), TextColor3 = C.Text,
				Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4,
			})
			local caret = Inst("ImageLabel", box, {
				Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -18, 0.5, -7),
				BackgroundTransparency = 1, Image = GetIcon("chevron-down"), ImageColor3 = C.TextDim, ZIndex = 4,
			})
			local popup = Inst("ScrollingFrame", self.Library.Main, {
				Size = UDim2.new(0, 140, 0, 0), Position = UDim2.new(0, 0, 0, 0),
				BackgroundColor3 = C.Surface2, BorderSizePixel = 0, ClipsDescendants = true,
				ScrollBarThickness = 4, ScrollBarImageColor3 = C.BloodDark,
				Visible = false, ZIndex = 100,
				AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0, 0, 0, 0),
			})
			Inst("UICorner", popup, { CornerRadius = UDim.new(0, 8) })
			Inst("UIStroke", popup, { Color = C.Stroke, Thickness = 1, Transparency = 0.3 })
			Inst("UIListLayout", popup, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2) })
			Inst("UIPadding", popup, {
				PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4),
				PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4),
			})
			local function closePopup()
				popup.Visible = false; caret.Image = GetIcon("chevron-down")
				self.Library.DropBackdrop.Visible = false
			end
			local function openPopup()
				for _, d in ipairs(self.Library._dropdowns) do if d ~= popup then d.Visible = false end end
				local map = box.AbsolutePosition
				local mas = box.AbsoluteSize
				local mp = self.Library.Main.AbsolutePosition
				local ms = self.Library.Main.AbsoluteSize
				local px = map.X - mp.X + mas.X - 140
				local ph = math.min(#options * 30 + 8, 170)
				local py = map.Y - mp.Y + mas.Y + 6
				if py + ph > ms.Y then py = map.Y - mp.Y - 6 - ph end
				popup.Position = UDim2.new(0, px, 0, py)
				popup.Size = UDim2.new(0, 140, 0, ph)
				popup.Visible = true; caret.Image = GetIcon("chevron-up")
				self.Library.DropBackdrop.Visible = true
			end
			box.MouseButton1Click:Connect(function()
				if popup.Visible then closePopup() else openPopup() end
			end)
			for i, opt in ipairs(options) do
				local o = Inst("TextButton", popup, {
					Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = C.Surface2,
					AutoButtonColor = false, Text = "", ZIndex = 101, LayoutOrder = i,
				})
				Inst("UICorner", o, { CornerRadius = UDim.new(0, 6) })
				Inst("TextLabel", o, {
					Size = UDim2.new(1, -12, 1, 0), Position = UDim2.new(0, 6, 0, 0),
					BackgroundTransparency = 1, Text = tostring(opt),
					TextColor3 = (opt == current) and C.BloodGlow or C.Text,
					Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 102,
				})
				o.MouseEnter:Connect(function() Tween(o, { BackgroundColor3 = C.Surface }) end)
				o.MouseLeave:Connect(function() Tween(o, { BackgroundColor3 = C.Surface2 }) end)
				o.MouseButton1Click:Connect(function()
					current = opt; val.Text = tostring(opt); closePopup(); pcall(cb, opt)
				end)
			end
			table.insert(self.Library._dropdowns, popup)
			return { Set = function(v) current = v; val.Text = tostring(v) end, Get = function() return current end, Row = row }
		end

		-- TEXTBOX
		function Tab:CreateTextbox(opts)
			opts = opts or {}
			local name = opts.Name or "Textbox"
			local ph = opts.Placeholder or "Ketik disini..."
			local cb = opts.Callback or function() end
			local row = self:AddRow(44, false)
			Inst("TextLabel", row, {
				Size = UDim2.new(1, -170, 1, 0), Position = UDim2.new(0, 12, 0, 0),
				BackgroundTransparency = 1, Text = name, TextColor3 = C.Text,
				Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
			})
			local box = Inst("TextBox", row, {
				Size = UDim2.new(0, 150, 0, 28), Position = UDim2.new(1, -12, 0.5, -14),
				BackgroundColor3 = C.Surface2, Text = opts.Default or "",
				PlaceholderText = ph, TextColor3 = C.Text, PlaceholderColor3 = C.TextDim,
				Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
				ClearTextOnFocus = false, ZIndex = 3,
			})
			Inst("UICorner", box, { CornerRadius = UDim.new(0, 8) })
			box.FocusLost:Connect(function(ep) if not ep then pcall(cb, box.Text) end end)
			return { Set = function(t) box.Text = t end, Get = function() return box.Text end, Row = row }
		end

		-- LABEL
		function Tab:CreateLabel(opts)
			opts = opts or {}
			local row = self:AddRow(0, false, true)
			Inst("UIPadding", row, {
				PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8),
				PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
			})
			local lbl = Inst("TextLabel", row, {
				Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
				Text = opts.Text or "", TextColor3 = C.TextDim, Font = Enum.Font.Gotham,
				TextSize = 13, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
			})
			return { Set = function(t) lbl.Text = t end, Row = row }
		end

		-- PARAGRAPH
		function Tab:CreateParagraph(opts)
			opts = opts or {}
			local row = self:AddRow(0, false, true)
			local inner = Inst("Frame", row, {
				Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
			})
			Inst("UIPadding", inner, {
				PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
			})
			Inst("UIListLayout", inner, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4) })
			Inst("TextLabel", inner, {
				Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1, Text = opts.Title or "", TextColor3 = C.BloodGlow,
				Font = Enum.Font.GothamBold, TextSize = 14, TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3, LayoutOrder = 1,
			})
			Inst("TextLabel", inner, {
				Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1, Text = opts.Text or "", TextColor3 = C.TextDim,
				Font = Enum.Font.Gotham, TextSize = 12, TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3, LayoutOrder = 2,
			})
			return { Row = row }
		end

		-- KEYBIND
		function Tab:CreateKeybind(opts)
			opts = opts or {}
			local name = opts.Name or "Keybind"
			local key = opts.Default or "RMB"
			local cb = opts.Callback or function() end
			local row = self:AddRow(44, true)
			Inst("TextLabel", row, {
				Size = UDim2.new(1, -110, 1, 0), Position = UDim2.new(0, 12, 0, 0),
				BackgroundTransparency = 1, Text = name, TextColor3 = C.Text,
				Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
			})
			local btn = Inst("TextButton", row, {
				Size = UDim2.new(0, 90, 0, 28), Position = UDim2.new(1, -12, 0.5, -14),
				BackgroundColor3 = C.Surface2, AutoButtonColor = false, Text = key,
				TextColor3 = C.Text, Font = Enum.Font.GothamBold, TextSize = 12, ZIndex = 3,
			})
			Inst("UICorner", btn, { CornerRadius = UDim.new(0, 8) })
			local waiting = false
			btn.MouseButton1Click:Connect(function()
				if waiting then return end
				waiting = true; btn.Text = "..."
				local conn
				conn = UIS.InputBegan:Connect(function(input, gp)
					if gp then return end
					local k
					if input.UserInputType == Enum.UserInputType.Keyboard then
						k = input.KeyCode.Name
					elseif input.UserInputType.Name:match("MouseButton") then
						k = input.UserInputType.Name
					end
					if not k or k == "Unknown" then return end
					key = k; btn.Text = k; waiting = false
					pcall(conn.Disconnect, conn); pcall(cb, k)
				end)
			end)
			return { Set = function(v) key = v; btn.Text = v end, Get = function() return key end, Row = row }
		end

		-- DIVIDER
		function Tab:CreateDivider()
			self.Order = self.Order + 1
			local d = Inst("Frame", self.Page, {
				Size = UDim2.new(1, -24, 0, 1), BackgroundColor3 = C.Stroke,
				BorderSizePixel = 0, LayoutOrder = self.Order, ZIndex = 2,
			})
			return { Row = d }
		end

		self.Tabs[#self.Tabs + 1] = Tab
		local idx = #self.Tabs
		btn.MouseButton1Click:Connect(function() self:SelectTab(idx) end)
		return Tab
	end

	-- ============================================================
	--  MINIMIZE / RESTORE / DESTROY
	-- ============================================================
	function self:Minimize()
		self.Main.Visible = false
		self.Aura.Visible = false
		self.Float.Visible = true
		self.Float.Size = UDim2.new(0, 0, 0, 0)
		Tween(self.Float, { Size = UDim2.new(0, 52, 0, 52) }, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	end
	function self:Restore()
		self.Float.Visible = false
		self.Main.Visible = true
		self.Aura.Visible = true
	end
	function self:Destroy()
		pcall(function() self.ScreenGui:Destroy() end)
	end

	-- ============================================================
	--  SHOW MAIN (entrance)
	-- ============================================================
	function self:ShowMain()
		self.Main.Visible = true
		self.Aura.Visible = true
		self.Main.Size = UDim2.new(0, 0, 0, 0)
		self.Main.BackgroundTransparency = 1
		Tween(self.Main, { BackgroundTransparency = 0 }, 0.35)
		Tween(self.Main, { Size = self.Config.Size }, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	end

	-- ============================================================
	--  KEY SYSTEM (like the reference file, BloodMoon theme)
	-- ============================================================
	local function SetStatus(lbl, msg, kind)
		if not lbl then return end
		lbl.Text = msg
		if kind == "ok" then lbl.TextColor3 = C.Success
		elseif kind == "err" then lbl.TextColor3 = C.Error
		else lbl.TextColor3 = C.BloodGlow end
		Tween(lbl, { TextTransparency = 0 }, 0.3)
	end

	local function BuildKeySystem()
		local KeyFrame = Inst("Frame", ScreenGui, {
			Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 500,
		})
		self.KeyFrame = KeyFrame

		-- particles (blood)
		local pCont = Inst("Frame", KeyFrame, { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 501 })
		task.spawn(function()
			for i = 1, 26 do
				local s = math.random(6, 16)
				local p = Inst("Frame", pCont, {
					Size = UDim2.new(0, s, 0, s), Position = UDim2.new(math.random(), 0, 1.1, 0),
					BackgroundColor3 = C.BloodGlow, BackgroundTransparency = math.random(55, 80) / 100,
					ZIndex = 502, Rotation = math.random(0, 360),
				})
				Inst("UICorner", p, { CornerRadius = UDim.new(1, 0) })
				local sp = math.random(20, 60) / 100
				task.spawn(function()
					while p.Parent and KeyFrame.Parent do
						p.Position = UDim2.new(p.Position.X.Scale, 0, p.Position.Y.Scale - sp / 100, 0)
						if p.Position.Y.Scale < -0.2 then p.Position = UDim2.new(math.random(), 0, 1.1, 0) end
						task.wait(0.03)
					end
				end)
			end
		end)

		-- card
		local Card = Inst("Frame", KeyFrame, {
			Size = UDim2.new(0, 320, 0, 420), Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = C.BG,
			BorderSizePixel = 0, ZIndex = 510,
		})
		Inst("UICorner", Card, { CornerRadius = UDim.new(0, 20) })
		Inst("UIStroke", Card, { Color = C.Stroke, Thickness = 1, Transparency = 0.3 })

		-- animated border
		local Border = Inst("Frame", Card, {
			Size = UDim2.new(1, 6, 1, 6), Position = UDim2.new(0, -3, 0, -3),
			BackgroundTransparency = 1, ZIndex = 509,
		})
		Inst("UICorner", Border, { CornerRadius = UDim.new(0, 23) })
		local BStroke = Inst("UIStroke", Border, { Color = C.BloodGlow, Thickness = 2, Transparency = 0.4 })
		local BGrad = Inst("UIGradient", BStroke, {
			Color = ColorSequence.new{ CSK(0, C.BloodGlow), CSK(0.5, C.White), CSK(1, C.BloodGlow) },
			Transparency = NumberSequence.new{ NSK(0, 0.9), NSK(0.5, 0.1), NSK(1, 0.9) },
		})
		task.spawn(function()
			while Border.Parent do
				BGrad.Rotation = (BGrad.Rotation + RunService.Heartbeat:Wait() * 40) % 360
			end
		end)

		-- icon badge (lock)
		local IcoBox = Inst("Frame", Card, {
			Size = UDim2.new(0, 56, 0, 56), Position = UDim2.new(0.5, -28, 0, 26),
			BackgroundColor3 = C.BloodDark, ZIndex = 511,
		})
		Inst("UICorner", IcoBox, { CornerRadius = UDim.new(0, 14) })
		Inst("UIGradient", IcoBox, { Color = ColorSequence.new{ CSK(0, C.Blood), CSK(1, C.BloodDark) } })
		Inst("UIStroke", IcoBox, { Color = C.BloodGlow, Thickness = 1.5, Transparency = 0.4 })
		Inst("ImageLabel", IcoBox, {
			Size = UDim2.new(0.7, 0, 0.7, 0), Position = UDim2.new(0.15, 0, 0.15, 0),
			BackgroundTransparency = 1, Image = GetIcon("lock"), ImageColor3 = C.White, ZIndex = 512,
		})

		Inst("TextLabel", Card, {
			Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, 96),
			BackgroundTransparency = 1, Text = "ACCESS KEY REQUIRED",
			TextColor3 = C.Text, Font = Enum.Font.GothamBold, TextSize = 19,
			TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 511,
		})
		Inst("TextLabel", Card, {
			Size = UDim2.new(1, -40, 0, 36), Position = UDim2.new(0, 20, 0, 128),
			BackgroundTransparency = 1, Text = "Masukkan key untuk membuka " .. self.Config.Name,
			TextColor3 = C.TextDim, Font = Enum.Font.Gotham, TextSize = 13,
			TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 511,
		})

		-- input
		local InputBox = Inst("Frame", Card, {
			Size = UDim2.new(1, -48, 0, 46), Position = UDim2.new(0, 24, 0, 180),
			BackgroundColor3 = C.Surface, ZIndex = 511,
		})
		Inst("UICorner", InputBox, { CornerRadius = UDim.new(0, 12) })
		Inst("UIStroke", InputBox, { Color = C.Stroke, Thickness = 1, Transparency = 0.3 })
		local Input = Inst("TextBox", InputBox, {
			Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1, Text = "", PlaceholderText = "Masukkan key disini...",
			TextColor3 = C.Text, PlaceholderColor3 = C.TextDim, Font = Enum.Font.Gotham,
			TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, ZIndex = 512,
		})
		local Counter = Inst("TextLabel", InputBox, {
			Size = UDim2.new(0, 60, 0, 16), Position = UDim2.new(1, -64, 1, -2),
			BackgroundTransparency = 1, Text = "0/50", TextColor3 = C.TextDim,
			Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 512,
		})
		Input:GetPropertyChangedSignal("Text"):Connect(function()
			local t = Input.Text
			if #t > 50 then Input.Text = t:sub(1, 50) end
			Counter.Text = #Input.Text .. "/50"
		end)

		-- verify button
		local Verify = Inst("TextButton", Card, {
			Size = UDim2.new(1, -48, 0, 44), Position = UDim2.new(0, 24, 0, 240),
			BackgroundColor3 = C.Blood, AutoButtonColor = false, Text = "VERIFY KEY",
			TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 15, ZIndex = 511,
		})
		Inst("UICorner", Verify, { CornerRadius = UDim.new(0, 12) })
		local Spin = Inst("Frame", Verify, {
			Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0.5, -11, 0.5, -11),
			BackgroundColor3 = C.White, Visible = false, ZIndex = 513,
		})
		Inst("UICorner", Spin, { CornerRadius = UDim.new(1, 0) })
		Inst("UIGradient", Spin, { Transparency = NumberSequence.new{ NSK(0, 0), NSK(0.8, 0.8), NSK(1, 1) } })
		local spinTween

		local Status = Inst("TextLabel", Card, {
			Size = UDim2.new(1, -40, 0, 40), Position = UDim2.new(0, 20, 0, 292),
			BackgroundTransparency = 1, Text = "", TextColor3 = C.TextDim,
			Font = Enum.Font.Gotham, TextSize = 13, TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 511,
		})

		-- getkey + discord
		local Row2 = Inst("Frame", Card, {
			Size = UDim2.new(1, -48, 0, 44), Position = UDim2.new(0, 24, 0, 338),
			BackgroundTransparency = 1, ZIndex = 511,
		})
		local GetKey = Inst("TextButton", Row2, {
			Size = UDim2.new(0.48, 0, 1, 0), BackgroundColor3 = C.Surface2,
			AutoButtonColor = false, Text = "GET KEY", TextColor3 = C.Text,
			Font = Enum.Font.GothamMedium, TextSize = 13, ZIndex = 512,
		})
		Inst("UICorner", GetKey, { CornerRadius = UDim.new(0, 10) })
		local Discord = Inst("TextButton", Row2, {
			Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0.52, 0, 0, 0),
			BackgroundColor3 = Color3.fromRGB(60, 70, 180), AutoButtonColor = false,
			Text = "DISCORD", TextColor3 = C.White, Font = Enum.Font.GothamMedium, TextSize = 13, ZIndex = 512,
		})
		Inst("UICorner", Discord, { CornerRadius = UDim.new(0, 10) })

		-- functions
		local loading = false
		local function SetLoading(v)
			loading = v
			Spin.Visible = v
			Verify.Text = v and "" or "VERIFY KEY"
			if v then
				spinTween = TweenService:Create(Spin, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), { Rotation = 360 })
				spinTween:Play()
			elseif spinTween then
				spinTween:Cancel(); Spin.Rotation = 0
			end
		end

		local function VerifyKey()
			if loading then return end
			local k = Input.Text:match("^%s*(.-)%s*$")
			if k == "" then SetStatus(Status, "Masukkan key terlebih dahulu!", "err"); return end
			SetLoading(true)
			SetStatus(Status, "Memvalidasi key...", nil)
			task.spawn(function()
				task.wait(0.7)
				local ok = false
				if type(self.Config.ValidateKey) == "function" then
					local s, r = pcall(self.Config.ValidateKey, k)
					ok = s and r
				end
				if not ok then
					for _, vk in ipairs(self.ValidKeys) do
						if vk == k then ok = true; break end
					end
				end
				SetLoading(false)
				if ok then
					SetStatus(Status, "Key valid! Membuka hub...", "ok")
					Tween(KeyFrame, { BackgroundTransparency = 1 }, 0.4)
					Tween(Card, { Size = UDim2.new(0, 0, 0, 0) }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
					task.wait(0.35)
					pcall(function() KeyFrame:Destroy() end)
					self:ShowMain()
				else
					SetStatus(Status, "Key salah! Coba lagi.", "err")
					Tween(InputBox, { BackgroundColor3 = C.Error })
					task.wait(0.2)
					Tween(InputBox, { BackgroundColor3 = C.Surface })
				end
			end)
		end

		Verify.MouseButton1Click:Connect(VerifyKey)
		Input.FocusLost:Connect(function(ep) if ep then VerifyKey() end end)
		GetKey.MouseButton1Click:Connect(function()
			local link = self.Config.GetKeyLink
			pcall(function() if setclipboard then setclipboard(link) end end)
			SetStatus(Status, "Link key disalin ke clipboard!", "ok")
		end)
		Discord.MouseButton1Click:Connect(function()
			local link = self.Config.Discord
			pcall(function() if setclipboard then setclipboard(link) end end)
			SetStatus(Status, "Link Discord disalin ke clipboard!", "ok")
		end)

		-- entrance
		Card.Size = UDim2.new(0, 0, 0, 0)
		Tween(Card, { Size = UDim2.new(0, 320, 0, 420) }, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	end

	-- // START
	if self.Config.SkipKey then
		self:ShowMain()
	else
		BuildKeySystem()
	end

	return self
end

-- ============================================================
--  CONTOH PEMAKAIAN / EXAMPLE  (edit sesukamu)
-- ============================================================
-- Ganti Key / GetKeyLink / Discord sesuai punyamu.
-- Masukkan key default di bawah ("NHHUB-BLOODMOON") untuk tes.
local Hub = NHHub.new({
	Name        = "NH HUB",
	Key         = "NHHUB-BLOODMOON",        -- key valid (bisa pakai tabel Keys = {...})
	GetKeyLink  = "https://your-link.com/getkey",
	Discord     = "https://discord.gg/yourserver",
	-- SkipKey   = true,                     -- true = langsung buka tanpa key system
})

-- // TAB 1 : HOME
local Tab1 = Hub:CreateTab({ Name = "Home", Icon = "home" })
Tab1:CreateParagraph({ Title = "NH HUB - BloodMoon", Text = "UI Library phone-style dengan tab, key system, dan icon by name." })
Tab1:CreateButton({ Name = "Fly (Demo)", Icon = "rocket", Callback = function()
	pcall(function()
		local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if h then h.PlatformStand = false end
	end)
end })
Tab1:CreateToggle({ Name = "Infinite Jump", Default = false, Callback = function(v) print("Infinite Jump:", v) end })
Tab1:CreateSlider({ Name = "Walk Speed", Min = 16, Max = 500, Default = 16, Suffix = "", Callback = function(v)
	pcall(function()
		local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed = v end
	end)
end })
Tab1:CreateKeybind({ Name = "Aim Key", Default = "RMB", Callback = function(k) print("Keybind:", k) end })

-- // TAB 2 : COMBAT
local Tab2 = Hub:CreateTab({ Name = "Combat", Icon = "sword" })
Tab2:CreateToggle({ Name = "Auto Attack", Default = true, Callback = function(v) print("Auto Attack:", v) end })
Tab2:CreateSlider({ Name = "Damage", Min = 1, Max = 100, Default = 50, Callback = function(v) print("Damage:", v) end })
Tab2:CreateDropdown({ Name = "Target Mode", Options = { "Nearest", "Lowest HP", "Cursor" }, Default = "Nearest", Callback = function(v) print("Mode:", v) end })

-- // TAB 3 : PLAYER
local Tab3 = Hub:CreateTab({ Name = "Player", Icon = "user" })
Tab3:CreateSlider({ Name = "Jump Power", Min = 50, Max = 300, Default = 50, Callback = function(v)
	pcall(function()
		local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if h then h.JumpPower = v end
	end)
end })
Tab3:CreateTextbox({ Name = "Teleport To", Placeholder = "Nama player...", Callback = function(t) print("TP:", t) end })
Tab3:CreateButton({ Name = "Reset Char", Icon = "rotate-ccw", Callback = function()
	pcall(function() LocalPlayer:LoadCharacter() end)
end })

-- // TAB 4 : SETTINGS
local Tab4 = Hub:CreateTab({ Name = "Settings", Icon = "settings" })
Tab4:CreateToggle({ Name = "BloodMoon Glow", Default = true, Callback = function(v) print("Glow:", v) end })
Tab4:CreateDropdown({ Name = "Theme Accent", Options = { "Blood", "Crimson", "Ember" }, Default = "Blood", Callback = function(v) print("Accent:", v) end })
Tab4:CreateDivider()
Tab4:CreateButton({ Name = "Copy Discord", Icon = "message-circle", Callback = function()
	pcall(function() if setclipboard then setclipboard(Hub.Config.Discord) end end)
end })
Tab4:CreateLabel({ Text = "Made with NH Hub • BloodMoon Theme" })

return NHHub
