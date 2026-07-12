--[[
    AbsoluteUI Library - Edisi Ringkas & Modern (Diperbaiki)
    Dibuat oleh: AbsoluteUI Developer Team
    Deskripsi: Pustaka UI Roblox Premium, Modern, dan Kaya Fitur yang dioptimalkan untuk PC & Mobile.
    Perbaikan: Fitur Seret (Dragging) pada Widget Perkecil kini bekerja 100% lancar di PC & Mobile.
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local MarketPlaceService = game:GetService("MarketplaceService")
local TextService = game:GetService("TextService")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer

-- ==================== ICON NAME RESOLVER ====================
-- Sumber icon: https://github.com/Orvez83/IconFinder
-- Icon dapat dipanggil dengan nama seperti "home", "lucide/home", atau "solar/palette-bold".
local IconService = {
    Cache = {},
    Custom = {},
    Order = {"Lucide", "Gravity", "Solar", "SFSymbols"},
    Sources = {
        Lucide = {
            "https://cdn.jsdelivr.net/gh/Orvez83/IconFinder@main/Icons/Lucide.lua",
            "https://raw.githubusercontent.com/Orvez83/IconFinder/refs/heads/main/Icons/Lucide.lua"
        },
        Gravity = {
            "https://cdn.jsdelivr.net/gh/Orvez83/IconFinder@main/Icons/Gravity.lua",
            "https://raw.githubusercontent.com/Orvez83/IconFinder/refs/heads/main/Icons/Gravity.lua"
        },
        Solar = {
            "https://cdn.jsdelivr.net/gh/Orvez83/IconFinder@main/Icons/Solar.lua",
            "https://raw.githubusercontent.com/Orvez83/IconFinder/refs/heads/main/Icons/Solar.lua"
        },
        SFSymbols = {
            "https://cdn.jsdelivr.net/gh/Orvez83/IconFinder@main/Icons/SFSymbols.lua",
            "https://raw.githubusercontent.com/Orvez83/IconFinder/refs/heads/main/Icons/SFSymbols.lua"
        }
    }
}

local IconPlatformAliases = {
    lucide = "Lucide",
    gravity = "Gravity",
    solar = "Solar",
    sfsymbols = "SFSymbols",
    sf = "SFSymbols"
}

function IconService:_LoadPlatform(platform)
    if self.Cache[platform] ~= nil then
        return self.Cache[platform] or nil
    end

    local urls = self.Sources[platform]
    if not urls then return nil end

    for _, url in ipairs(urls) do
        for attempt = 1, 3 do
            local success, result = pcall(function()
                local source = game:HttpGet(url, true)
                return loadstring(source)()
            end)

            if success and type(result) == "table" then
                self.Cache[platform] = result
                return result
            end

            if attempt < 3 then
                task.wait(attempt * 0.35)
            end
        end
    end

    -- false dipakai agar URL yang gagal tidak diminta berulang kali pada setiap icon.
    self.Cache[platform] = false
    warn("[AbsoluteUI] Gagal memuat icon platform: " .. tostring(platform))
    return nil
end

function IconService:Resolve(value)
    if value == nil then return nil end
    if type(value) == "table" then
        return value.Image or value.Asset or value.Id
    end

    local raw = tostring(value)
    if raw == "" then return nil end
    if raw:find("rbxasset", 1, true) then return raw end
    if raw:match("^%d+$") then return "rbxassetid://" .. raw end

    local custom = self.Custom[string.lower(raw)]
    if custom then return custom end

    local prefix, iconName = raw:match("^([^/:]+)[/:](.+)$")
    if prefix and iconName then
        local platform = IconPlatformAliases[string.lower(prefix)]
        if platform then
            local icons = self:_LoadPlatform(platform)
            if not icons then return nil end
            return icons[iconName] or icons[string.lower(iconName)]
        end
    end

    -- Nama tanpa prefix mencari Lucide terlebih dahulu, lalu platform lainnya.
    local normalized = string.lower(raw)
    for _, platform in ipairs(self.Order) do
        local icons = self:_LoadPlatform(platform)
        if icons then
            local found = icons[raw] or icons[normalized]
            if found then return found end
        end
    end
    return nil
end

function IconService:Register(name, asset)
    if type(name) ~= "string" or name == "" then return false end
    local resolved = self:Resolve(asset)
    if not resolved then return false end
    self.Custom[string.lower(name)] = resolved
    return true
end

-- Konfigurasi Efek Suara
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

local Sounds = {
    Click = 6895079853,
    Hover = 6895079632,
    ToggleOn = 8501254395,
    ToggleOff = 8501254199,
    Notification = 9114223297
}

-- Utilitas: Mendapatkan Nama Game Secara Aman
local function getPlaceName()
    local success, info = pcall(function()
        return MarketPlaceService:GetProductInfo(game.PlaceId).Name
    end)
    return success and info or "Game Tidak Dikenal"
end

-- Utilitas: Membuat Gui Dapat Digeser (Drag) Secara Lancar menggunakan Handle Khusus
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

-- Pembuatan Logo "AU" Berdasarkan Gambar (Menggunakan Objek Teks Prosedural)
local function createAULogo(parent, size, baseTextSize)
    local logoFrame = Instance.new("Frame")
    logoFrame.Name = "AU_Logo"
    logoFrame.Size = size or UDim2.new(0, 42, 0, 42)
    logoFrame.BackgroundTransparency = 1
    logoFrame.Parent = parent

    -- Lingkaran Biru Futuristik
    local ring = Instance.new("Frame")
    ring.Name = "Ring"
    ring.Size = UDim2.new(1, 0, 1, 0)
    ring.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    ring.BackgroundTransparency = 0.4
    ring.Parent = logoFrame

    local ringCorner = Instance.new("UICorner")
    ringCorner.CornerRadius = UDim.new(1, 0)
    ringCorner.Parent = ring

    local ringStroke = Instance.new("UIStroke")
    ringStroke.Color = Color3.fromRGB(41, 128, 255) -- Biru Terang
    ringStroke.Thickness = 1.6
    ringStroke.Parent = ring

    -- Huruf "A" (Perak / Abu-abu Terang)
    local labelA = Instance.new("TextLabel")
    labelA.Name = "A"
    labelA.Size = UDim2.new(0.6, 0, 0.8, 0)
    labelA.Position = UDim2.new(0.08, 0, 0.08, 0)
    labelA.BackgroundTransparency = 1
    labelA.Font = Enum.Font.GothamBlack
    labelA.Text = "A"
    labelA.TextColor3 = Color3.fromRGB(240, 240, 245)
    labelA.TextSize = baseTextSize or 20
    labelA.TextXAlignment = Enum.TextXAlignment.Center
    labelA.TextYAlignment = Enum.TextYAlignment.Center
    labelA.Parent = logoFrame

    -- Huruf "U" (Biru Elektrik)
    local labelU = Instance.new("TextLabel")
    labelU.Name = "U"
    labelU.Size = UDim2.new(0.6, 0, 0.8, 0)
    labelU.Position = UDim2.new(0.34, 0, 0.14, 0)
    labelU.BackgroundTransparency = 1
    labelU.Font = Enum.Font.GothamBlack
    labelU.Text = "U"
    labelU.TextColor3 = Color3.fromRGB(41, 128, 255)
    labelU.TextSize = baseTextSize or 20
    labelU.TextXAlignment = Enum.TextXAlignment.Center
    labelU.TextYAlignment = Enum.TextYAlignment.Center
    labelU.Parent = logoFrame

    -- Stroke Hitam Tebal untuk memberi Efek Outline/Dimensi (3D Look)
    local strokeA = Instance.new("UIStroke")
    strokeA.Color = Color3.fromRGB(5, 5, 5)
    strokeA.Thickness = 2
    strokeA.Parent = labelA

    local strokeU = Instance.new("UIStroke")
    strokeU.Color = Color3.fromRGB(5, 5, 5)
    strokeU.Thickness = 2
    strokeU.Parent = labelU

    local function adjustTextSize()
        local scaleFactor = logoFrame.AbsoluteSize.Y
        labelA.TextSize = scaleFactor * 0.52
        labelU.TextSize = scaleFactor * 0.52
    end
    logoFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(adjustTextSize)

    return logoFrame
end

-- Objek Pustaka (Library)
local Library = {}
Library.__index = Library
Library.Name = "AbsoluteUI"
Library.Version = "1.0.1-fixed"

-- Mengambil asset icon berdasarkan nama tanpa harus menulis asset ID.
function Library:GetIcon(name)
    return IconService:Resolve(name)
end

function Library:RegisterIcon(name, asset)
    return IconService:Register(name, asset)
end

-- Membuka browser IconFinder untuk mencari nama icon yang tersedia.
function Library:OpenIconFinder()
    local success, result = pcall(function()
        local source = game:HttpGet("https://raw.githubusercontent.com/Orvez83/IconFinder/refs/heads/main/IconFinder.lua", true)
        return loadstring(source)()
    end)
    if not success then
        warn("[AbsoluteUI] Gagal membuka IconFinder: " .. tostring(result))
    end
    return success
end

Library.Icons = IconService

-- ==================== SISTEM THEMES (TERINSPIRASI FLUENT) ====================
-- Setiap preset memakai nama properti yang sama agar seluruh UI dapat diganti saat runtime.
local function makeTheme(background, sidebar, element, input, control, border, accent, text, subText)
    return {
        MainBackground = background,
        LightGrayTrans = sidebar,
        Element = element,
        Input = input,
        Control = control,
        ControlHover = control:Lerp(text, 0.08),
        MainBorder = border,
        Accent = accent,
        TextPrimary = text,
        TextSecondary = subText,
        Placeholder = subText:Lerp(background, 0.25),
        Track = control:Lerp(background, 0.25),
        Knob = text,
        NotificationColor = Color3.fromRGB(255, 75, 75),
        Danger = Color3.fromRGB(200, 50, 50),
        White = Color3.fromRGB(255, 255, 255)
    }
end

local BuiltInThemes = {
    ["Default"] = makeTheme(Color3.fromRGB(15,15,15), Color3.fromRGB(40,40,40), Color3.fromRGB(20,20,20), Color3.fromRGB(30,30,30), Color3.fromRGB(35,35,35), Color3.fromRGB(45,45,45), Color3.fromRGB(41,128,255), Color3.fromRGB(240,240,240), Color3.fromRGB(150,150,150)),
    ["AMOLED"] = makeTheme(Color3.fromRGB(0,0,0), Color3.fromRGB(8,8,8), Color3.fromRGB(10,10,10), Color3.fromRGB(12,12,12), Color3.fromRGB(22,22,22), Color3.fromRGB(35,35,35), Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255), Color3.fromRGB(150,150,150)),
    ["Ash Gray"] = makeTheme(Color3.fromRGB(32,32,32), Color3.fromRGB(54,54,54), Color3.fromRGB(43,43,43), Color3.fromRGB(58,58,58), Color3.fromRGB(66,66,66), Color3.fromRGB(90,90,90), Color3.fromRGB(150,150,150), Color3.fromRGB(240,240,240), Color3.fromRGB(170,170,170)),
    ["Blood Red"] = makeTheme(Color3.fromRGB(24,5,7), Color3.fromRGB(50,9,13), Color3.fromRGB(38,7,10), Color3.fromRGB(55,10,15), Color3.fromRGB(72,11,18), Color3.fromRGB(140,15,25), Color3.fromRGB(180,10,20), Color3.fromRGB(255,230,230), Color3.fromRGB(210,175,178)),
    ["Cyanic"] = makeTheme(Color3.fromRGB(5,14,18), Color3.fromRGB(10,28,34), Color3.fromRGB(9,24,30), Color3.fromRGB(12,34,41), Color3.fromRGB(16,45,52), Color3.fromRGB(40,165,160), Color3.fromRGB(57,197,187), Color3.fromRGB(210,248,246), Color3.fromRGB(130,210,205)),
    ["Amber Glow"] = makeTheme(Color3.fromRGB(13,7,2), Color3.fromRGB(35,18,4), Color3.fromRGB(28,14,3), Color3.fromRGB(42,21,5), Color3.fromRGB(58,30,6), Color3.fromRGB(200,130,30), Color3.fromRGB(255,170,40), Color3.fromRGB(255,245,225), Color3.fromRGB(230,195,145)),
    ["Deep Violet"] = makeTheme(Color3.fromRGB(18,11,29), Color3.fromRGB(38,25,57), Color3.fromRGB(31,20,48), Color3.fromRGB(48,31,70), Color3.fromRGB(58,38,84), Color3.fromRGB(110,90,130), Color3.fromRGB(160,120,220), Color3.fromRGB(240,240,240), Color3.fromRGB(180,170,195)),
    ["Neon Cyber"] = makeTheme(Color3.fromRGB(3,8,3), Color3.fromRGB(8,20,8), Color3.fromRGB(7,16,7), Color3.fromRGB(10,24,10), Color3.fromRGB(12,31,12), Color3.fromRGB(35,160,15), Color3.fromRGB(57,255,20), Color3.fromRGB(200,255,190), Color3.fromRGB(80,200,60)),
    ["Neon Purple"] = makeTheme(Color3.fromRGB(5,0,15), Color3.fromRGB(22,2,45), Color3.fromRGB(15,1,32), Color3.fromRGB(28,2,55), Color3.fromRGB(38,3,72), Color3.fromRGB(140,0,255), Color3.fromRGB(180,0,255), Color3.fromRGB(252,245,255), Color3.fromRGB(210,185,255)),
    ["Royal Blue"] = makeTheme(Color3.fromRGB(7,17,38), Color3.fromRGB(9,35,74), Color3.fromRGB(8,28,61), Color3.fromRGB(10,41,87), Color3.fromRGB(12,52,108), Color3.fromRGB(10,65,150), Color3.fromRGB(50,120,230), Color3.fromRGB(220,235,255), Color3.fromRGB(170,190,220)),
    ["Deep Ocean"] = makeTheme(Color3.fromRGB(8,20,33), Color3.fromRGB(10,37,54), Color3.fromRGB(9,31,46), Color3.fromRGB(11,44,64), Color3.fromRGB(12,56,81), Color3.fromRGB(0,100,150), Color3.fromRGB(0,180,235), Color3.fromRGB(240,248,255), Color3.fromRGB(180,210,230)),
    ["Orange"] = makeTheme(Color3.fromRGB(5,3,0), Color3.fromRGB(29,12,2), Color3.fromRGB(21,9,2), Color3.fromRGB(34,14,2), Color3.fromRGB(49,20,3), Color3.fromRGB(200,90,10), Color3.fromRGB(255,140,30), Color3.fromRGB(255,240,220), Color3.fromRGB(220,175,130)),
    ["Charcoal"] = makeTheme(Color3.fromRGB(10,10,10), Color3.fromRGB(27,27,27), Color3.fromRGB(19,19,19), Color3.fromRGB(25,25,25), Color3.fromRGB(34,34,34), Color3.fromRGB(60,60,60), Color3.fromRGB(102,102,102), Color3.fromRGB(240,240,240), Color3.fromRGB(170,170,170)),
    ["Pearl White"] = makeTheme(Color3.fromRGB(240,240,240), Color3.fromRGB(225,225,225), Color3.fromRGB(232,232,232), Color3.fromRGB(220,220,220), Color3.fromRGB(210,210,210), Color3.fromRGB(190,190,190), Color3.fromRGB(60,160,255), Color3.fromRGB(20,20,20), Color3.fromRGB(90,90,90)),
    ["Midnight Blue"] = makeTheme(Color3.fromRGB(8,5,20), Color3.fromRGB(25,17,55), Color3.fromRGB(18,12,43), Color3.fromRGB(28,19,65), Color3.fromRGB(38,27,84), Color3.fromRGB(60,45,140), Color3.fromRGB(100,80,200), Color3.fromRGB(220,220,255), Color3.fromRGB(170,170,210)),
    ["Galaxy Purple"] = makeTheme(Color3.fromRGB(8,3,20), Color3.fromRGB(34,12,54), Color3.fromRGB(25,9,42), Color3.fromRGB(42,15,67), Color3.fromRGB(55,19,86), Color3.fromRGB(120,40,185), Color3.fromRGB(160,60,220), Color3.fromRGB(242,232,255), Color3.fromRGB(200,178,228)),
    ["Cosmic Violet"] = makeTheme(Color3.fromRGB(8,6,16), Color3.fromRGB(25,18,45), Color3.fromRGB(19,14,35), Color3.fromRGB(31,22,56), Color3.fromRGB(40,29,71), Color3.fromRGB(55,38,115), Color3.fromRGB(115,90,175), Color3.fromRGB(230,225,245), Color3.fromRGB(185,175,210)),
    ["Cotton Candy"] = makeTheme(Color3.fromRGB(255,228,248), Color3.fromRGB(245,205,235), Color3.fromRGB(250,216,240), Color3.fromRGB(242,198,229), Color3.fromRGB(232,182,222), Color3.fromRGB(228,168,213), Color3.fromRGB(255,130,190), Color3.fromRGB(75,25,55), Color3.fromRGB(145,75,115)),
    ["Arctic Frost"] = makeTheme(Color3.fromRGB(220,240,255), Color3.fromRGB(196,224,243), Color3.fromRGB(210,235,250), Color3.fromRGB(200,230,248), Color3.fromRGB(185,218,240), Color3.fromRGB(150,195,225), Color3.fromRGB(70,150,225), Color3.fromRGB(20,40,70), Color3.fromRGB(65,105,148)),
    ["RGB"] = makeTheme(Color3.fromRGB(8,8,14), Color3.fromRGB(18,18,30), Color3.fromRGB(15,15,26), Color3.fromRGB(20,20,36), Color3.fromRGB(25,25,43), Color3.fromRGB(0,180,140), Color3.fromRGB(0,255,180), Color3.fromRGB(220,255,245), Color3.fromRGB(100,220,190))
}

local ThemeNames = {
    "Default", "AMOLED", "Ash Gray", "Blood Red", "Cyanic", "Amber Glow",
    "Deep Violet", "Neon Cyber", "Neon Purple", "Royal Blue", "Deep Ocean",
    "Orange", "Charcoal", "Pearl White", "Midnight Blue", "Galaxy Purple",
    "Cosmic Violet", "Cotton Candy", "Arctic Frost", "RGB"
}

local function sameColor(a, b)
    return math.abs(a.R - b.R) < 0.002 and math.abs(a.G - b.G) < 0.002 and math.abs(a.B - b.B) < 0.002
end

-- Mendeteksi peran warna lama agar widget yang sudah ada tidak perlu ditulis ulang.
function Library:_ResolveThemeRole(propertyName, color)
    if typeof(color) ~= "Color3" then return nil end

    local propertyRoles = {
        BackgroundColor3 = {"MainBackground", "LightGrayTrans", "Element", "Input", "Control", "ControlHover", "MainBorder", "Accent", "Danger", "NotificationColor", "White"},
        TextColor3 = {"TextPrimary", "TextSecondary", "Placeholder", "Accent", "Danger", "White"},
        ImageColor3 = {"TextPrimary", "TextSecondary", "Accent", "White"},
        Color = {"MainBorder", "Accent", "Danger", "NotificationColor", "TextPrimary", "TextSecondary"},
        ScrollBarImageColor3 = {"MainBorder", "Accent", "TextSecondary"}
    }

    -- Cocokkan warna preset default/current terlebih dahulu.
    for _, role in ipairs(propertyRoles[propertyName] or {}) do
        local defaultColor = BuiltInThemes.Default[role]
        local currentColor = self.Theme and self.Theme[role]
        if (defaultColor and sameColor(color, defaultColor)) or (currentColor and sameColor(color, currentColor)) then
            return role
        end
    end

    local r = math.floor(color.R * 255 + 0.5)
    local g = math.floor(color.G * 255 + 0.5)
    local b = math.floor(color.B * 255 + 0.5)
    local key = string.format("%d,%d,%d", r, g, b)

    local fallback = {
        BackgroundColor3 = {
            ["15,15,15"]="MainBackground", ["18,18,18"]="Element", ["20,20,20"]="Element",
            ["25,25,25"]="Input", ["30,30,30"]="Input", ["35,35,35"]="Control",
            ["40,40,40"]="LightGrayTrans", ["45,45,45"]="ControlHover", ["50,50,50"]="ControlHover",
            ["55,55,55"]="MainBorder", ["60,60,60"]="MainBorder", ["200,50,50"]="Danger",
            ["41,128,255"]="Accent"
        },
        TextColor3 = {
            ["255,255,255"]="White", ["240,240,240"]="TextPrimary", ["230,230,230"]="TextPrimary",
            ["225,225,225"]="TextPrimary", ["220,220,220"]="TextPrimary", ["200,200,200"]="TextSecondary",
            ["180,180,180"]="TextSecondary", ["170,170,170"]="TextSecondary", ["160,160,160"]="TextSecondary",
            ["150,150,150"]="TextSecondary", ["140,140,140"]="TextSecondary", ["110,110,110"]="Placeholder",
            ["41,128,255"]="Accent"
        },
        ImageColor3 = {
            ["255,255,255"]="White", ["240,240,240"]="TextPrimary", ["220,220,220"]="TextPrimary",
            ["200,200,200"]="TextSecondary", ["180,180,180"]="TextSecondary", ["150,150,150"]="TextSecondary",
            ["41,128,255"]="Accent"
        },
        Color = {
            ["40,40,40"]="MainBorder", ["45,45,45"]="MainBorder", ["50,50,50"]="MainBorder",
            ["55,55,55"]="MainBorder", ["60,60,60"]="MainBorder", ["70,70,70"]="MainBorder",
            ["72,72,72"]="MainBorder", ["82,82,82"]="MainBorder", ["90,90,90"]="MainBorder",
            ["100,100,100"]="MainBorder", ["41,128,255"]="Accent"
        },
        ScrollBarImageColor3 = {
            ["45,45,45"]="MainBorder", ["55,55,55"]="MainBorder", ["60,60,60"]="MainBorder",
            ["105,105,105"]="MainBorder"
        }
    }
    return fallback[propertyName] and fallback[propertyName][key] or nil
end

function Library:_IsThemeIgnored(object)
    local current = object
    while current and current ~= self.ScreenGui do
        if current:GetAttribute("AbsoluteUIIgnoreTheme") == true then return true end
        current = current.Parent
    end
    return false
end

function Library:_BindThemeProperty(object, propertyName)
    if not object or not object.Parent or self:_IsThemeIgnored(object) then return end
    local ok, value = pcall(function() return object[propertyName] end)
    if not ok or typeof(value) ~= "Color3" then return end

    local attributeName = "AbsoluteUITheme_" .. propertyName
    local role = object:GetAttribute(attributeName) or self:_ResolveThemeRole(propertyName, value)
    if not role then return end
    object:SetAttribute(attributeName, role)

    local binding = {Object=object, Property=propertyName, Role=role, Applying=false}
    table.insert(self._ThemeBindings, binding)

    local function apply()
        if not object.Parent then return end
        local wanted = self.Theme and self.Theme[binding.Role]
        if typeof(wanted) == "Color3" then
            binding.Applying = true
            pcall(function() object[propertyName] = wanted end)
            binding.Applying = false
        end
    end
    binding.Apply = apply

    local connection = object:GetPropertyChangedSignal(propertyName):Connect(function()
        if binding.Applying or not object.Parent or self:_IsThemeIgnored(object) then return end
        local success, changedColor = pcall(function() return object[propertyName] end)
        if not success then return end
        local changedRole = self:_ResolveThemeRole(propertyName, changedColor)
        if changedRole then
            binding.Role = changedRole
            object:SetAttribute(attributeName, changedRole)
            apply()
        end
    end)
    table.insert(self._ThemeConnections, connection)
    apply()
end

function Library:_BindThemeObject(object)
    if not object or self:_IsThemeIgnored(object) then return end
    if object:IsA("GuiObject") then
        self:_BindThemeProperty(object, "BackgroundColor3")
    end
    if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
        self:_BindThemeProperty(object, "TextColor3")
    end
    if object:IsA("ImageLabel") or object:IsA("ImageButton") then
        self:_BindThemeProperty(object, "ImageColor3")
    end
    if object:IsA("UIStroke") then
        self:_BindThemeProperty(object, "Color")
    end
    if object:IsA("ScrollingFrame") then
        self:_BindThemeProperty(object, "ScrollBarImageColor3")
    end
end

function Library:_SetupThemeEngine()
    self:_BindThemeObject(self.ScreenGui)
    for _, object in ipairs(self.ScreenGui:GetDescendants()) do
        self:_BindThemeObject(object)
    end
    local connection = self.ScreenGui.DescendantAdded:Connect(function(object)
        task.defer(function()
            if object and object.Parent then self:_BindThemeObject(object) end
        end)
    end)
    table.insert(self._ThemeConnections, connection)
end

function Library:SetTheme(themeName)
    if type(themeName) ~= "string" or not self.ThemePresets[themeName] then
        warn("[AbsoluteUI] Theme tidak ditemukan: " .. tostring(themeName))
        return false
    end

    if self._RGBConnection then
        self._RGBConnection:Disconnect()
        self._RGBConnection = nil
    end

    self.ThemeName = themeName
    self.Theme = table.clone(self.ThemePresets[themeName])

    for index = #self._ThemeBindings, 1, -1 do
        local binding = self._ThemeBindings[index]
        if binding.Object and binding.Object.Parent then
            binding.Apply()
        else
            table.remove(self._ThemeBindings, index)
        end
    end

    if themeName == "RGB" then
        local hue = 0
        self._RGBConnection = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
            hue = (hue + deltaTime * 0.10) % 1
            self.Theme.Accent = Color3.fromHSV(hue, 1, 1)
            for _, binding in ipairs(self._ThemeBindings) do
                if binding.Role == "Accent" and binding.Object and binding.Object.Parent then
                    binding.Apply()
                end
            end
        end)
    end

    if self._ThemeChangedCallback then
        pcall(self._ThemeChangedCallback, themeName, self.Theme)
    end
    return true
end

function Library:GetTheme()
    return self.ThemeName, self.Theme
end

function Library:GetThemes()
    return table.clone(self.Themes)
end

function Library:OnThemeChanged(callback)
    self._ThemeChangedCallback = callback
end

function Library:RegisterTheme(name, themeData)
    if type(name) ~= "string" or name == "" or type(themeData) ~= "table" then return false end
    local newTheme = table.clone(BuiltInThemes.Default)
    for property, value in pairs(themeData) do
        if typeof(value) == "Color3" and newTheme[property] ~= nil then
            newTheme[property] = value
        end
    end
    self.ThemePresets[name] = newTheme
    if not table.find(self.Themes, name) then table.insert(self.Themes, name) end
    return true
end

Library.AddCustomTheme = Library.RegisterTheme

function Library.new(options)
    local self = setmetatable({}, Library)
    local requestedTheme = type(options) == "string" and options
        or (type(options) == "table" and options.Theme)
        or "Default"
    self.ThemePresets = {}
    for name, preset in pairs(BuiltInThemes) do
        self.ThemePresets[name] = preset
    end
    self.Themes = table.clone(ThemeNames)
    self.ThemeName = "Default"
    self.Theme = self.ThemePresets.Default
    self._ThemeBindings = {}
    self._ThemeConnections = {}
    
    -- Pembuatan Screen GUI Utama
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AbsoluteUI_ScreenGui"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    pcall(function()
        screenGui.Parent = game:GetService("CoreGui")
    end)
    if not screenGui.Parent then
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    self.ScreenGui = screenGui

    -- Container UI Utama (Lebih Ringkas & Kecil)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 480, 0, 310)
    mainFrame.Position = UDim2.new(0.5, -240, 0.5, -155)
    mainFrame.BackgroundColor3 = self.Theme.MainBackground
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    self.MainFrame = mainFrame

    -- Border Bulat & Stroke UI Utama
    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 8)
    uicorner.Parent = mainFrame

    local uistroke = Instance.new("UIStroke")
    uistroke.Color = self.Theme.MainBorder
    uistroke.Thickness = 1.2
    uistroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    uistroke.Parent = mainFrame

    makeDraggable(mainFrame)

    -- PANEL KIRI (SIDEBAR KATEGORI)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 140, 1, 0)
    sidebar.BackgroundColor3 = self.Theme.LightGrayTrans
    sidebar.BackgroundTransparency = 0.88
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame

    local sidebarBorder = Instance.new("Frame")
    sidebarBorder.Size = UDim2.new(0, 1, 1, 0)
    sidebarBorder.Position = UDim2.new(1, 0, 0, 0)
    sidebarBorder.BackgroundColor3 = Color3.fromRGB(72, 72, 72)
    sidebarBorder.BorderSizePixel = 0
    sidebarBorder.Parent = sidebar

    -- KOTAK INFO PENGGUNA (KIRI): avatar, DisplayName, username asli, dan logo AU
    local userInfo = Instance.new("Frame")
    userInfo.Name = "UserInfo"
    userInfo.Size = UDim2.new(1, -12, 0, 54)
    userInfo.Position = UDim2.new(0, 6, 0, 6)
    userInfo.BackgroundColor3 = self.Theme.LightGrayTrans
    userInfo.BackgroundTransparency = 0.72
    userInfo.BorderSizePixel = 0
    userInfo.Parent = sidebar

    local userInfoCorner = Instance.new("UICorner")
    userInfoCorner.CornerRadius = UDim.new(0, 7)
    userInfoCorner.Parent = userInfo

    local userInfoStroke = Instance.new("UIStroke")
    userInfoStroke.Color = Color3.fromRGB(72, 72, 72)
    userInfoStroke.Thickness = 1
    userInfoStroke.Transparency = 0.25
    userInfoStroke.Parent = userInfo

    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Size = UDim2.new(0, 36, 0, 36)
    avatar.Position = UDim2.new(0, 7, 0.5, -18)
    avatar.BackgroundColor3 = self.Theme.MainBackground
    avatar.BackgroundTransparency = 0.15
    avatar.BorderSizePixel = 0
    avatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    avatar.Parent = userInfo

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
    avatarCorner.Parent = avatar

    local avatarStroke = Instance.new("UIStroke")
    avatarStroke.Color = Color3.fromRGB(82, 82, 82)
    avatarStroke.Thickness = 1
    avatarStroke.Parent = avatar

    task.spawn(function()
        local success, image = pcall(function()
            return Players:GetUserThumbnailAsync(
                LocalPlayer.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )
        end)
        if success and avatar.Parent then
            avatar.Image = image
        end
    end)

    local displayNameLabel = Instance.new("TextLabel")
    displayNameLabel.Name = "DisplayName"
    displayNameLabel.Size = UDim2.new(1, -70, 0, 17)
    displayNameLabel.Position = UDim2.new(0, 49, 0, 9)
    displayNameLabel.BackgroundTransparency = 1
    displayNameLabel.Font = Enum.Font.SourceSansBold
    displayNameLabel.Text = LocalPlayer.DisplayName
    displayNameLabel.TextColor3 = self.Theme.TextPrimary
    displayNameLabel.TextSize = 11
    displayNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    displayNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    displayNameLabel.Parent = userInfo

    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Name = "Username"
    usernameLabel.Size = UDim2.new(1, -70, 0, 15)
    usernameLabel.Position = UDim2.new(0, 49, 0, 26)
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Font = Enum.Font.SourceSans
    usernameLabel.Text = "@" .. LocalPlayer.Name
    usernameLabel.TextColor3 = self.Theme.TextSecondary
    usernameLabel.TextSize = 9
    usernameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    usernameLabel.Parent = userInfo

    -- Logo lama tetap dipertahankan dalam ukuran ringkas
    local logoHolder = Instance.new("Frame")
    logoHolder.Name = "LogoHolder"
    logoHolder.Size = UDim2.new(0, 16, 0, 16)
    logoHolder.Position = UDim2.new(1, -20, 0, 4)
    logoHolder.BackgroundTransparency = 1
    logoHolder.Parent = userInfo

    createAULogo(logoHolder, UDim2.new(1, 0, 1, 0), 8)

    -- Bar Pencarian Kategori di Atas Daftar Tab
    local searchContainer = Instance.new("Frame")
    searchContainer.Name = "SearchContainer"
    searchContainer.Size = UDim2.new(0, 120, 0, 24)
    searchContainer.Position = UDim2.new(0.5, -60, 0, 68)
    searchContainer.BackgroundColor3 = self.Theme.MainBackground
    searchContainer.BackgroundTransparency = 0.3
    searchContainer.Parent = sidebar

    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 5)
    searchCorner.Parent = searchContainer

    local searchStroke = Instance.new("UIStroke")
    searchStroke.Color = self.Theme.MainBorder
    searchStroke.Thickness = 1
    searchStroke.Parent = searchContainer

    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(1, -10, 1, 0)
    searchBox.Position = UDim2.new(0, 5, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Font = Enum.Font.SourceSans
    searchBox.TextSize = 12
    searchBox.TextColor3 = self.Theme.TextPrimary
    searchBox.PlaceholderText = "Cari Kategori..."
    searchBox.PlaceholderColor3 = self.Theme.TextSecondary
    searchBox.Text = ""
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = searchContainer

    -- Area Daftar Tab (Dengan Auto-scroll & Ukuran Proporsional)
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, -10, 1, -101)
    tabContainer.Position = UDim2.new(0, 5, 0, 98)
    tabContainer.BackgroundTransparency = 1
    tabContainer.BorderSizePixel = 0
    tabContainer.ScrollBarThickness = 1.5
    tabContainer.ScrollBarImageColor3 = self.Theme.MainBorder
    tabContainer.Parent = sidebar

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.Parent = tabContainer

    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
    end)

    -- HEADER ATAS (SISI KANAN)
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, -140, 0, 66)
    header.Position = UDim2.new(0, 140, 0, 0)
    header.BackgroundTransparency = 1
    header.Parent = mainFrame

    local headerBorder = Instance.new("Frame")
    headerBorder.Size = UDim2.new(1, 0, 0, 1)
    headerBorder.Position = UDim2.new(0, 0, 1, 0)
    headerBorder.BackgroundColor3 = Color3.fromRGB(72, 72, 72)
    headerBorder.BorderSizePixel = 0
    headerBorder.Parent = header

    -- Teks Deteksi Otomatis Nama Game
    local mapLabel = Instance.new("TextLabel")
    mapLabel.Name = "MapLabel"
    mapLabel.Size = UDim2.new(1, -60, 0, 18)
    mapLabel.Position = UDim2.new(0, 10, 0, 6)
    mapLabel.BackgroundTransparency = 1
    mapLabel.Font = Enum.Font.SourceSansBold
    mapLabel.TextSize = 13
    mapLabel.TextColor3 = self.Theme.TextPrimary
    mapLabel.Text = getPlaceName()
    mapLabel.TextXAlignment = Enum.TextXAlignment.Left
    mapLabel.Parent = header

    -- Teks Pembuat Hub
    local creditLabel = Instance.new("TextLabel")
    creditLabel.Name = "CreditLabel"
    creditLabel.Size = UDim2.new(1, -60, 0, 12)
    creditLabel.Position = UDim2.new(0, 10, 0, 24)
    creditLabel.BackgroundTransparency = 1
    creditLabel.Font = Enum.Font.SourceSansItalic
    creditLabel.TextSize = 10
    creditLabel.TextColor3 = self.Theme.TextSecondary
    creditLabel.Text = "Made Absolute (NexzanHub)"
    creditLabel.TextXAlignment = Enum.TextXAlignment.Left
    creditLabel.Parent = header

    -- AREA TAG: memenuhi sisi kanan, mendukung banyak tag dan scroll horizontal
    local tagScroller = Instance.new("ScrollingFrame")
    tagScroller.Name = "TagScroller"
    tagScroller.Size = UDim2.new(1, -16, 0, 21)
    tagScroller.Position = UDim2.new(0, 8, 0, 40)
    tagScroller.BackgroundColor3 = self.Theme.LightGrayTrans
    tagScroller.BackgroundTransparency = 0.82
    tagScroller.BorderSizePixel = 0
    tagScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
    tagScroller.ScrollingDirection = Enum.ScrollingDirection.X
    tagScroller.ScrollBarThickness = 2
    tagScroller.ScrollBarImageColor3 = Color3.fromRGB(105, 105, 105)
    tagScroller.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    tagScroller.Active = true
    tagScroller.Parent = header

    local tagScrollerCorner = Instance.new("UICorner")
    tagScrollerCorner.CornerRadius = UDim.new(0, 5)
    tagScrollerCorner.Parent = tagScroller

    local tagScrollerStroke = Instance.new("UIStroke")
    tagScrollerStroke.Color = Color3.fromRGB(72, 72, 72)
    tagScrollerStroke.Thickness = 1
    tagScrollerStroke.Transparency = 0.35
    tagScrollerStroke.Parent = tagScroller

    local tagPadding = Instance.new("UIPadding")
    tagPadding.PaddingLeft = UDim.new(0, 4)
    tagPadding.PaddingRight = UDim.new(0, 4)
    tagPadding.Parent = tagScroller

    local tagLayout = Instance.new("UIListLayout")
    tagLayout.FillDirection = Enum.FillDirection.Horizontal
    tagLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    tagLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tagLayout.Padding = UDim.new(0, 5)
    tagLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tagLayout.Parent = tagScroller

    local function updateTagCanvas()
        tagScroller.CanvasSize = UDim2.new(0, tagLayout.AbsoluteContentSize.X + 8, 0, 0)
    end
    tagLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateTagCanvas)

    self.TagScroller = tagScroller
    self.Tags = {}

    -- TOMBOL KONTROL (Perkecil & Tutup)
    local controlFrame = Instance.new("Frame")
    controlFrame.Name = "ControlFrame"
    controlFrame.Size = UDim2.new(0, 50, 0, 25)
    controlFrame.Position = UDim2.new(1, -55, 0, 10)
    controlFrame.BackgroundTransparency = 1
    controlFrame.Parent = header

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeBtn"
    minimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    minimizeBtn.Position = UDim2.new(0, 0, 0, 0)
    minimizeBtn.BackgroundColor3 = self.Theme.LightGrayTrans
    minimizeBtn.BackgroundTransparency = 0.5
    minimizeBtn.Font = Enum.Font.SourceSansBold
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = self.Theme.TextPrimary
    minimizeBtn.TextSize = 14
    minimizeBtn.Parent = controlFrame

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 4)
    minCorner.Parent = minimizeBtn

    local minStroke = Instance.new("UIStroke")
    minStroke.Color = self.Theme.MainBorder
    minStroke.Thickness = 1
    minStroke.Parent = minimizeBtn

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(0, 24, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.BackgroundTransparency = 0.2
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 11
    closeBtn.Parent = controlFrame

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeBtn

    local closeStroke = Instance.new("UIStroke")
    closeStroke.Color = self.Theme.MainBorder
    closeStroke.Thickness = 1
    closeStroke.Parent = closeBtn

    -- AREA KONTEN UTAMA
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -140, 1, -66)
    contentArea.Position = UDim2.new(0, 140, 0, 66)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame

    -- WIDGET MOBILE MINIMIZE (Sesuai Desain Logo AU Baru)
    local miniWidget = Instance.new("Frame")
    miniWidget.Name = "MiniWidget"
    miniWidget.Size = UDim2.new(0, 45, 0, 45)
    miniWidget.Position = UDim2.new(0, 20, 0.5, -22)
    miniWidget.BackgroundColor3 = self.Theme.MainBackground
    miniWidget.BackgroundTransparency = 0.1
    miniWidget.Active = true -- Diperlukan agar event Input mendeteksi seretan dengan benar
    miniWidget.Visible = false
    miniWidget.Parent = screenGui

    local miniCorner = Instance.new("UICorner")
    miniCorner.CornerRadius = UDim.new(1, 0)
    miniCorner.Parent = miniWidget

    local miniStroke = Instance.new("UIStroke")
    miniStroke.Color = self.Theme.MainBorder
    miniStroke.Thickness = 1.5
    miniStroke.Parent = miniWidget

    -- Logo "AU" Interaktif
    local miniLogoHolder = Instance.new("Frame")
    miniLogoHolder.Name = "MiniLogoHolder"
    miniLogoHolder.Size = UDim2.new(1, 0, 1, 0)
    miniLogoHolder.BackgroundTransparency = 1
    miniLogoHolder.Parent = miniWidget

    createAULogo(miniLogoHolder, UDim2.new(1, 0, 1, 0), 18)

    -- Tombol klik penuh untuk membuka kembali
    local miniImageBtn = Instance.new("TextButton")
    miniImageBtn.Size = UDim2.new(1, 0, 1, 0)
    miniImageBtn.BackgroundTransparency = 1
    miniImageBtn.Text = ""
    miniImageBtn.Parent = miniWidget

    -- [PERBAIKAN UTAMA]: Menghubungkan fungsi seret ke Tombol Transparan (miniImageBtn)
    -- Ini memungkinkan tombol menelan klik untuk menyeret bingkai induknya (miniWidget).
    makeDraggable(miniWidget, miniImageBtn)

    self.Tabs = {}
    self.ActiveTab = nil

    -- Kontrol Logika Minimalkan / Buka UI
    local isMinimized = false
    local dragThreshold = 5 -- Jarak gerakan minimal sebelum dianggap sebagai seretan (bukan klik biasa)
    local startDragPos

    local function setMinimized(state)
        isMinimized = state
        if isMinimized then
            playSound(Sounds.Click, 0.4)
            mainFrame:TweenSize(UDim2.new(0, 480, 0, 0), "Out", "Quad", 0.3, true, function()
                mainFrame.Visible = false
                miniWidget.Visible = true
            end)
        else
            playSound(Sounds.Click, 0.4)
            mainFrame.Visible = true
            miniWidget.Visible = false
            mainFrame:TweenSize(UDim2.new(0, 480, 0, 310), "Out", "Quad", 0.3, true)
        end
    end

    minimizeBtn.MouseButton1Click:Connect(function()
        setMinimized(true)
    end)

    -- Logika Pencegah Auto-Klik saat widget sedang digeser
    miniImageBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            startDragPos = input.Position
        end
    end)

    miniImageBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if startDragPos then
                local dragDistance = (input.Position - startDragPos).Magnitude
                if dragDistance < dragThreshold then
                    -- Hanya buka UI jika widget tidak sedang diseret/digeser
                    setMinimized(false)
                end
            end
        end
    end)

    -- Kontrol Logika Tutup UI Permanen
    closeBtn.MouseButton1Click:Connect(function()
        playSound(Sounds.Click, 0.6)
        screenGui:Destroy()
    end)

    -- Fitur Cari Kategori Secara Real-Time
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(searchBox.Text)
        for _, tab in ipairs(self.Tabs) do
            if query == "" then
                tab.Button.Visible = true
            else
                if string.find(string.lower(tab.Name), query) then
                    tab.Button.Visible = true
                else
                    tab.Button.Visible = false
                end
            end
        end
    end)

    -- Aktifkan engine theme setelah semua komponen dasar selesai dibuat.
    self:_SetupThemeEngine()
    self:SetTheme(requestedTheme)

    return self
end

-- ==================== TAG HEADER (GAYA WINDUI) ====================
-- Contoh dari luar library:
-- local tag = Window:Tag({ Title = "v1.6.6", Icon = "badge-check", Color = Color3.fromRGB(48, 255, 106), Radius = 6 })
function Library:Tag(options)
    options = options or {}
    assert(self.TagScroller, "Tag hanya dapat dibuat setelah Library.new() dipanggil")

    local title = tostring(options.Title or options.Text or "Tag")
    local color = options.Color or Color3.fromRGB(82, 82, 82)
    local radius = math.clamp(tonumber(options.Radius) or 5, 0, 13)
    local iconValue = options.Icon

    local tag = Instance.new("Frame")
    tag.Name = "Tag_" .. string.sub(title, 1, 20)
    tag:SetAttribute("AbsoluteUIIgnoreTheme", true) -- Warna Tag tetap dikontrol melalui Tag:SetColor().
    tag.Size = UDim2.new(0, 40, 0, 15)
    tag.BackgroundColor3 = color
    tag.BackgroundTransparency = 0.78
    tag.BorderSizePixel = 0
    tag.Parent = self.TagScroller

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = tag

    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 1
    stroke.Transparency = 0.18
    stroke.Parent = tag

    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 10, 0, 10)
    icon.Position = UDim2.new(0, 4, 0.5, -5)
    icon.BackgroundTransparency = 1
    icon.ImageColor3 = Color3.fromRGB(220, 220, 220)
    icon.Visible = iconValue ~= nil and tostring(iconValue) ~= ""
    icon.Parent = tag

    local function normalizeIcon(value)
        return IconService:Resolve(value) or ""
    end
    icon.Image = normalizeIcon(iconValue)
    if icon.Image == "" then icon.Visible = false end

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -8, 1, 0)
    label.Position = UDim2.new(0, 4, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.Text = title
    label.TextColor3 = Color3.fromRGB(225, 225, 225)
    label.TextSize = 9
    label.TextTruncate = Enum.TextTruncate.None
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tag

    local function resize()
        local textWidth = TextService:GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new(10000, 15)).X
        local iconSpace = icon.Visible and 14 or 0
        label.Position = UDim2.new(0, 4 + iconSpace, 0, 0)
        label.Size = UDim2.new(1, -(8 + iconSpace), 1, 0)
        tag.Size = UDim2.new(0, math.max(28, textWidth + 10 + iconSpace), 0, 15)
    end
    resize()

    local TagAPI = {}

    function TagAPI:SetTitle(newTitle)
        title = tostring(newTitle or "Tag")
        label.Text = title
        tag.Name = "Tag_" .. string.sub(title, 1, 20)
        resize()
        return self
    end

    function TagAPI:SetColor(newColor)
        if typeof(newColor) == "Color3" then
            color = newColor
            tag.BackgroundColor3 = newColor
            stroke.Color = newColor
        end
        return self
    end

    function TagAPI:SetIcon(newIcon)
        iconValue = newIcon
        icon.Image = normalizeIcon(newIcon)
        icon.Visible = icon.Image ~= ""
        resize()
        return self
    end

    function TagAPI:SetVisible(visible)
        tag.Visible = visible == true
        return self
    end

    function TagAPI:Destroy()
        local index = table.find(self._owner.Tags, self)
        if index then table.remove(self._owner.Tags, index) end
        tag:Destroy()
    end

    TagAPI._owner = self
    TagAPI.Instance = tag
    table.insert(self.Tags, TagAPI)
    return TagAPI
end

-- Alias jika ingin memakai nama AddTag.
function Library:AddTag(options)
    return self:Tag(options)
end

-- ==================== FUNGSI BUAT TAB KATEGORI ====================
function Library:CreateTab(tabName, tabIconId)
    -- Simpan referensi Library. Di dalam method Tab:Add..., "self" adalah Tab,
    -- sehingga akses Theme harus memakai variabel library ini.
    local library = self

    local Tab = {
        Name = tabName,
        Elements = {},
        Active = false
    }

    -- Pembuatan Tombol Kategori Tab
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = tabName .. "_Btn"
    tabBtn.Size = UDim2.new(0, 125, 0, 28)
    tabBtn.BackgroundColor3 = self.Theme.LightGrayTrans
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = ""
    tabBtn.Parent = self.MainFrame.Sidebar.TabContainer

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = self.Theme.MainBorder
    btnStroke.Thickness = 0.8
    btnStroke.Transparency = 1
    btnStroke.Parent = tabBtn

    -- Icon Gambar Tab
    local tabIcon = Instance.new("ImageLabel")
    tabIcon.Name = "Icon"
    tabIcon.Size = UDim2.new(0, 16, 0, 16)
    tabIcon.Position = UDim2.new(0, 8, 0.5, -8)
    tabIcon.BackgroundTransparency = 1
    tabIcon.Image = IconService:Resolve(tabIconId) or "rbxassetid://6031075931"
    tabIcon.ImageColor3 = self.Theme.TextSecondary
    tabIcon.Parent = tabBtn

    -- Label Teks Tab
    local tabText = Instance.new("TextLabel")
    tabText.Name = "Label"
    tabText.Size = UDim2.new(1, -40, 1, 0)
    tabText.Position = UDim2.new(0, 30, 0, 0)
    tabText.BackgroundTransparency = 1
    tabText.Font = Enum.Font.SourceSans
    tabText.Text = tabName
    tabText.TextColor3 = self.Theme.TextSecondary
    tabText.TextSize = 12
    tabText.TextXAlignment = Enum.TextXAlignment.Left
    tabText.Parent = tabBtn

    -- Dot Notifikasi Tab
    local notifDot = Instance.new("Frame")
    notifDot.Name = "NotificationDot"
    notifDot.Size = UDim2.new(0, 5, 0, 5)
    notifDot.Position = UDim2.new(1, -12, 0.5, -2.5)
    notifDot.BackgroundColor3 = self.Theme.NotificationColor
    notifDot.BorderSizePixel = 0
    notifDot.Visible = false
    notifDot.Parent = tabBtn

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = notifDot

    -- Konten Halaman Tab (Daftar Scrolling Frame)
    local page = Instance.new("ScrollingFrame")
    page.Name = tabName .. "_Page"
    page.Size = UDim2.new(1, -16, 1, -16)
    page.Position = UDim2.new(0, 8, 0, 8)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = self.Theme.MainBorder
    page.Visible = false
    page.Parent = self.MainFrame.ContentArea

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 6)
    pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    pageLayout.Parent = page

    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
    end)

    Tab.Button = tabBtn
    Tab.Page = page

    -- Logika Navigasi Perpindahan Tab
    local function selectTab()
        playSound(Sounds.Hover, 0.4)
        for _, otherTab in ipairs(self.Tabs) do
            otherTab.Active = false
            otherTab.Page.Visible = false
            TweenService:Create(otherTab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            TweenService:Create(otherTab.Button.Label, TweenInfo.new(0.2), {TextColor3 = self.Theme.TextSecondary}):Play()
            TweenService:Create(otherTab.Button.Icon, TweenInfo.new(0.2), {ImageColor3 = self.Theme.TextSecondary}):Play()
            otherTab.Button.UIStroke.Transparency = 1
        end

        Tab.Active = true
        page.Visible = true
        notifDot.Visible = false

        TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.85, BackgroundColor3 = self.Theme.LightGrayTrans}):Play()
        TweenService:Create(tabText, TweenInfo.new(0.2), {TextColor3 = self.Theme.TextPrimary}):Play()
        TweenService:Create(tabIcon, TweenInfo.new(0.2), {ImageColor3 = self.Theme.Accent}):Play()
        tabBtn.UIStroke.Transparency = 0.5
    end

    tabBtn.MouseButton1Click:Connect(selectTab)

    table.insert(self.Tabs, Tab)

    if not self.ActiveTab then
        self.ActiveTab = Tab
        selectTab()
    end

    function Tab:ShowNotification()
        notifDot.Visible = true
        playSound(Sounds.Notification, 0.3)
    end

    -- ==================== WIDGET: TOMBOL (BUTTON) ====================
    function Tab:AddButton(title, desc, callback)
        callback = callback or function() end
        
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Name = "Button_" .. title
        buttonFrame.Size = UDim2.new(1, -8, 0, 38)
        buttonFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        buttonFrame.Parent = page

        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 6)
        bCorner.Parent = buttonFrame

        local bStroke = Instance.new("UIStroke")
        bStroke.Color = Color3.fromRGB(45, 45, 45)
        bStroke.Thickness = 1
        bStroke.Parent = buttonFrame

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(0.7, 0, 0, 18)
        titleLabel.Position = UDim2.new(0, 10, 0, 3)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.SourceSansBold
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
        titleLabel.TextSize = 12
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = buttonFrame

        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(0.7, 0, 0, 14)
        descLabel.Position = UDim2.new(0, 10, 0, 19)
        descLabel.BackgroundTransparency = 1
        descLabel.Font = Enum.Font.SourceSans
        descLabel.Text = desc or "Deskripsi tombol."
        descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        descLabel.TextSize = 10
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = buttonFrame

        local clickBtn = Instance.new("TextButton")
        clickBtn.Size = UDim2.new(0, 65, 0, 22)
        clickBtn.Position = UDim2.new(1, -75, 0.5, -11)
        clickBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        clickBtn.Text = "Klik"
        clickBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
        clickBtn.Font = Enum.Font.SourceSansBold
        clickBtn.TextSize = 11
        clickBtn.Parent = buttonFrame

        local clickCorner = Instance.new("UICorner")
        clickCorner.CornerRadius = UDim.new(0, 4)
        clickCorner.Parent = clickBtn

        local clickStroke = Instance.new("UIStroke")
        clickStroke.Color = Color3.fromRGB(60, 60, 60)
        clickStroke.Thickness = 1
        clickStroke.Parent = clickBtn

        clickBtn.MouseEnter:Connect(function()
            TweenService:Create(clickBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
        end)

        clickBtn.MouseLeave:Connect(function()
            TweenService:Create(clickBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        end)

        clickBtn.MouseButton1Click:Connect(function()
            playSound(Sounds.Click, 0.5)
            clickBtn.Size = UDim2.new(0, 61, 0, 20)
            clickBtn.Position = UDim2.new(1, -73, 0.5, -10)
            task.wait(0.05)
            clickBtn.Size = UDim2.new(0, 65, 0, 22)
            clickBtn.Position = UDim2.new(1, -75, 0.5, -11)
            pcall(callback)
        end)
    end

    -- ==================== WIDGET: SAKLAR (TOGGLE) ====================
    function Tab:AddToggle(title, desc, default, callback)
        callback = callback or function() end
        local state = default or false

        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "Toggle_" .. title
        toggleFrame.Size = UDim2.new(1, -8, 0, 38)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        toggleFrame.Parent = page

        local tCorner = Instance.new("UICorner")
        tCorner.CornerRadius = UDim.new(0, 6)
        tCorner.Parent = toggleFrame

        local tStroke = Instance.new("UIStroke")
        tStroke.Color = Color3.fromRGB(45, 45, 45)
        tStroke.Thickness = 1
        tStroke.Parent = toggleFrame

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(0.7, 0, 0, 18)
        titleLabel.Position = UDim2.new(0, 10, 0, 3)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.SourceSansBold
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
        titleLabel.TextSize = 12
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = toggleFrame

        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(0.7, 0, 0, 14)
        descLabel.Position = UDim2.new(0, 10, 0, 19)
        descLabel.BackgroundTransparency = 1
        descLabel.Font = Enum.Font.SourceSans
        descLabel.Text = desc or "Deskripsi saklar."
        descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        descLabel.TextSize = 10
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = toggleFrame

        local toggleSwitch = Instance.new("TextButton")
        toggleSwitch.Size = UDim2.new(0, 34, 0, 18)
        toggleSwitch.Position = UDim2.new(1, -44, 0.5, -9)
        toggleSwitch.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        toggleSwitch.Text = ""
        toggleSwitch.Parent = toggleFrame

        local tsCorner = Instance.new("UICorner")
        tsCorner.CornerRadius = UDim.new(1, 0)
        tsCorner.Parent = toggleSwitch

        local tsStroke = Instance.new("UIStroke")
        tsStroke.Color = Color3.fromRGB(60, 60, 60)
        tsStroke.Thickness = 1
        tsStroke.Parent = toggleSwitch

        local toggleIndicator = Instance.new("Frame")
        toggleIndicator.Size = UDim2.new(0, 12, 0, 12)
        toggleIndicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        toggleIndicator.Parent = toggleSwitch

        local indCorner = Instance.new("UICorner")
        indCorner.CornerRadius = UDim.new(1, 0)
        indCorner.Parent = toggleIndicator

        local function updateToggle(animate)
            local targetPos = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
            local targetBg = state and Color3.fromRGB(41, 128, 255) or Color3.fromRGB(35, 35, 35)
            
            if animate then
                TweenService:Create(toggleIndicator, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Position = targetPos}):Play()
                TweenService:Create(toggleSwitch, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundColor3 = targetBg}):Play()
                if state then
                    playSound(Sounds.ToggleOn, 0.4)
                else
                    playSound(Sounds.ToggleOff, 0.4)
                end
            else
                toggleIndicator.Position = targetPos
                toggleSwitch.BackgroundColor3 = targetBg
            end
            pcall(callback, state)
        end

        updateToggle(false)

        toggleSwitch.MouseButton1Click:Connect(function()
            state = not state
            updateToggle(true)
        end)
    end

    -- ==================== WIDGET: GESERAN (SLIDER) ====================
    function Tab:AddSlider(title, min, max, default, decimals, callback)
        callback = callback or function() end
        decimals = decimals or 0
        local value = default or min

        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = "Slider_" .. title
        sliderFrame.Size = UDim2.new(1, -8, 0, 44)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        sliderFrame.Parent = page

        local sCorner = Instance.new("UICorner")
        sCorner.CornerRadius = UDim.new(0, 6)
        sCorner.Parent = sliderFrame

        local sStroke = Instance.new("UIStroke")
        sStroke.Color = Color3.fromRGB(45, 45, 45)
        sStroke.Thickness = 1
        sStroke.Parent = sliderFrame

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(0.6, 0, 0, 18)
        titleLabel.Position = UDim2.new(0, 10, 0, 3)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.SourceSansBold
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
        titleLabel.TextSize = 12
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = sliderFrame

        local valBox = Instance.new("TextBox")
        valBox.Size = UDim2.new(0, 40, 0, 16)
        valBox.Position = UDim2.new(1, -50, 0, 4)
        valBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        valBox.Font = Enum.Font.Code
        valBox.TextSize = 10
        valBox.TextColor3 = Color3.fromRGB(240, 240, 240)
        valBox.Text = tostring(value)
        valBox.Parent = sliderFrame

        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = UDim.new(0, 4)
        boxCorner.Parent = valBox

        local boxStroke = Instance.new("UIStroke")
        boxStroke.Color = Color3.fromRGB(50, 50, 50)
        boxStroke.Parent = valBox

        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -20, 0, 4)
        track.Position = UDim2.new(0, 10, 0, 28)
        track.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        track.BorderSizePixel = 0
        track.Parent = sliderFrame

        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(1, 0)
        trackCorner.Parent = track

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((value - min)/(max - min), 0, 1, 0)
        fill.BackgroundColor3 = library.Theme.Accent
        fill.BorderSizePixel = 0
        fill.Parent = track

        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = fill

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 10, 0, 10)
        knob.Position = UDim2.new((value - min)/(max - min), -5, 0.5, -5)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.Parent = track

        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = knob

        local knobStroke = Instance.new("UIStroke")
        knobStroke.Color = Color3.fromRGB(100, 100, 100)
        knobStroke.Thickness = 1
        knobStroke.Parent = knob

        local isSliding = false

        local function updateSlider(inputPos)
            local scale = math.clamp((inputPos - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local rawVal = min + scale * (max - min)
            local mult = 10^decimals
            value = math.round(rawVal * mult) / mult
            
            fill.Size = UDim2.new(scale, 0, 1, 0)
            knob.Position = UDim2.new(scale, -5, 0.5, -5)
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

        valBox.FocusLost:Connect(function()
            local num = tonumber(valBox.Text)
            if num then
                value = math.clamp(num, min, max)
                local mult = 10^decimals
                value = math.round(value * mult) / mult
                local scale = (value - min) / (max - min)
                TweenService:Create(fill, TweenInfo.new(0.15), {Size = UDim2.new(scale, 0, 1, 0)}):Play()
                TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.new(scale, -5, 0.5, -5)}):Play()
                valBox.Text = tostring(value)
                pcall(callback, value)
            else
                valBox.Text = tostring(value)
            end
        end)
    end

    -- ==================== WIDGET: KOTAK INPUT (TEXTBOX) ====================
    function Tab:AddTextbox(title, placeholder, settings, callback)
        settings = settings or {}
        local numericOnly = settings.NumericOnly or false
        local textOnly = settings.TextOnly or false
        local isPassword = settings.Password or false
        local maxChars = settings.MaxCharacters or 999
        local clearButton = settings.ClearButton or false

        callback = callback or function() end

        local tbFrame = Instance.new("Frame")
        tbFrame.Name = "Textbox_" .. title
        tbFrame.Size = UDim2.new(1, -8, 0, 40)
        tbFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        tbFrame.Parent = page

        local tbCorner = Instance.new("UICorner")
        tbCorner.CornerRadius = UDim.new(0, 6)
        tbCorner.Parent = tbFrame

        local tbStroke = Instance.new("UIStroke")
        tbStroke.Color = Color3.fromRGB(45, 45, 45)
        tbStroke.Thickness = 1
        tbStroke.Parent = tbFrame

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(0.4, 0, 1, 0)
        titleLabel.Position = UDim2.new(0, 10, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.SourceSansBold
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
        titleLabel.TextSize = 12
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = tbFrame

        local inputContainer = Instance.new("Frame")
        inputContainer.Size = UDim2.new(0.5, 0, 0, 22)
        inputContainer.Position = UDim2.new(0.5, -5, 0.5, -11)
        inputContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        inputContainer.Parent = tbFrame

        local icCorner = Instance.new("UICorner")
        icCorner.CornerRadius = UDim.new(0, 4)
        icCorner.Parent = inputContainer

        local icStroke = Instance.new("UIStroke")
        icStroke.Color = Color3.fromRGB(55, 55, 55)
        icStroke.Thickness = 1
        icStroke.Parent = inputContainer

        local tBox = Instance.new("TextBox")
        tBox.Size = UDim2.new(1, -22, 1, 0)
        tBox.Position = UDim2.new(0, 5, 0, 0)
        tBox.BackgroundTransparency = 1
        tBox.Font = Enum.Font.SourceSans
        tBox.PlaceholderText = placeholder or "Ketik di sini..."
        tBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 110)
        tBox.TextColor3 = Color3.fromRGB(240, 240, 240)
        tBox.TextSize = 11
        tBox.Text = ""
        tBox.TextXAlignment = Enum.TextXAlignment.Left
        tBox.Parent = inputContainer

        local clearBtn
        if clearButton then
            clearBtn = Instance.new("TextButton")
            clearBtn.Size = UDim2.new(0, 14, 0, 14)
            clearBtn.Position = UDim2.new(1, -18, 0.5, -7)
            clearBtn.BackgroundTransparency = 1
            clearBtn.Font = Enum.Font.SourceSansBold
            clearBtn.Text = "x"
            clearBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
            clearBtn.TextSize = 11
            clearBtn.Visible = false
            clearBtn.Parent = inputContainer

            clearBtn.MouseButton1Click:Connect(function()
                tBox.Text = ""
                clearBtn.Visible = false
                pcall(callback, "")
            end)
        end

        local shadowText = ""

        tBox:GetPropertyChangedSignal("Text"):Connect(function()
            local text = tBox.Text

            if #text > maxChars then
                text = string.sub(text, 1, maxChars)
                tBox.Text = text
            end

            if numericOnly then
                local filtered = string.gsub(text, "[^%d%.%-]", "")
                if filtered ~= text then
                    text = filtered
                    tBox.Text = text
                end
            elseif textOnly then
                local filtered = string.gsub(text, "[^%a%s]", "")
                if filtered ~= text then
                    text = filtered
                    tBox.Text = text
                end
            end

            if clearBtn then
                clearBtn.Visible = (text ~= "")
            end

            if isPassword then
                shadowText = text
                tBox.Text = string.rep("•", #text)
            else
                shadowText = text
            end
        end)

        tBox.FocusLost:Connect(function()
            pcall(callback, isPassword and shadowText or tBox.Text)
        end)
    end

    -- ==================== WIDGET: PILIHAN (DROPDOWN) ====================
    function Tab:AddDropdown(title, items, isMulti, callback)
        callback = callback or function() end
        local dropdownActive = false
        local selectedItems = {}
        local optionButtons = {}

        local ddFrame = Instance.new("Frame")
        ddFrame.Name = "Dropdown_" .. title
        ddFrame.Size = UDim2.new(1, -8, 0, 38)
        ddFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        ddFrame.ClipsDescendants = true
        ddFrame.Parent = page

        local ddCorner = Instance.new("UICorner")
        ddCorner.CornerRadius = UDim.new(0, 6)
        ddCorner.Parent = ddFrame

        local ddStroke = Instance.new("UIStroke")
        ddStroke.Color = Color3.fromRGB(45, 45, 45)
        ddStroke.Thickness = 1
        ddStroke.Parent = ddFrame

        local mainButton = Instance.new("TextButton")
        mainButton.Size = UDim2.new(1, 0, 0, 38)
        mainButton.BackgroundTransparency = 1
        mainButton.Text = ""
        mainButton.Parent = ddFrame

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(0.5, 0, 0, 18)
        titleLabel.Position = UDim2.new(0, 10, 0, 3)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.SourceSansBold
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
        titleLabel.TextSize = 12
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = mainButton

        local selectedLabel = Instance.new("TextLabel")
        selectedLabel.Size = UDim2.new(0.5, 0, 0, 14)
        selectedLabel.Position = UDim2.new(0, 10, 0, 19)
        selectedLabel.BackgroundTransparency = 1
        selectedLabel.Font = Enum.Font.SourceSans
        selectedLabel.Text = "Tidak Ada"
        selectedLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
        selectedLabel.TextSize = 10
        selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
        selectedLabel.Parent = mainButton

        local arrow = Instance.new("ImageLabel")
        arrow.Size = UDim2.new(0, 14, 0, 14)
        arrow.Position = UDim2.new(1, -24, 0.5, -7)
        arrow.BackgroundTransparency = 1
        arrow.Image = "rbxassetid://6031094037"
        arrow.ImageColor3 = Color3.fromRGB(200, 200, 200)
        arrow.Parent = mainButton

        local optionsContainer = Instance.new("ScrollingFrame")
        optionsContainer.Size = UDim2.new(1, -10, 0, 100)
        optionsContainer.Position = UDim2.new(0, 5, 0, 40)
        optionsContainer.BackgroundTransparency = 1
        optionsContainer.BorderSizePixel = 0
        optionsContainer.ScrollBarThickness = 2
        optionsContainer.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        optionsContainer.Visible = false
        optionsContainer.Parent = ddFrame

        local containerLayout = Instance.new("UIListLayout")
        containerLayout.Padding = UDim.new(0, 3)
        containerLayout.Parent = optionsContainer

        local function updateDropdownLayout()
            optionsContainer.CanvasSize = UDim2.new(0, 0, 0, containerLayout.AbsoluteContentSize.Y)
        end
        containerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateDropdownLayout)

        local function refreshUI()
            if isMulti then
                if #selectedItems == 0 then
                    selectedLabel.Text = "Tidak Ada"
                else
                    selectedLabel.Text = table.concat(selectedItems, ", ")
                end
            else
                selectedLabel.Text = selectedItems[1] or "Tidak Ada"
            end
        end

        local function toggleItem(item)
            if isMulti then
                local idx = table.find(selectedItems, item)
                if idx then
                    table.remove(selectedItems, idx)
                else
                    table.insert(selectedItems, item)
                end
                refreshUI()
                pcall(callback, selectedItems)
            else
                selectedItems = {item}
                refreshUI()
                pcall(callback, item)
                dropdownActive = false
                TweenService:Create(ddFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, 38)}):Play()
                TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                optionsContainer.Visible = false
            end

            for oName, oBtn in pairs(optionButtons) do
                if table.find(selectedItems, oName) then
                    oBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    oBtn.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    oBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                    oBtn.Label.TextColor3 = Color3.fromRGB(180, 180, 180)
                end
            end
        end

        local function renderItems()
            for _, v in pairs(optionsContainer:GetChildren()) do
                if v:IsA("TextButton") then v:Destroy() end
            end
            table.clear(optionButtons)

            for _, item in ipairs(items) do
                local oBtn = Instance.new("TextButton")
                oBtn.Name = item
                oBtn.Size = UDim2.new(1, -5, 0, 22)
                oBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                oBtn.Text = ""
                oBtn.Parent = optionsContainer

                local oCorner = Instance.new("UICorner")
                oCorner.CornerRadius = UDim.new(0, 4)
                oCorner.Parent = oBtn

                local oLabel = Instance.new("TextLabel")
                oLabel.Name = "Label"
                oLabel.Size = UDim2.new(1, -10, 1, 0)
                oLabel.Position = UDim2.new(0, 8, 0, 0)
                oLabel.BackgroundTransparency = 1
                oLabel.Font = Enum.Font.SourceSans
                oLabel.Text = item
                oLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
                oLabel.TextSize = 11
                oLabel.TextXAlignment = Enum.TextXAlignment.Left
                oLabel.Parent = oBtn

                optionButtons[item] = oBtn

                oBtn.MouseButton1Click:Connect(function()
                    playSound(Sounds.Click, 0.3)
                    toggleItem(item)
                end)
            end
            refreshUI()
        end

        renderItems()

        mainButton.MouseButton1Click:Connect(function()
            playSound(Sounds.Hover, 0.4)
            dropdownActive = not dropdownActive
            if dropdownActive then
                optionsContainer.Visible = true
                TweenService:Create(ddFrame, TweenInfo.new(0.25), {Size = UDim2.new(1, -8, 0, 150)}):Play()
                TweenService:Create(arrow, TweenInfo.new(0.25), {Rotation = 180}):Play()
            else
                TweenService:Create(ddFrame, TweenInfo.new(0.25), {Size = UDim2.new(1, -8, 0, 38)}):Play()
                TweenService:Create(arrow, TweenInfo.new(0.25), {Rotation = 0}):Play()
                task.wait(0.25)
                if not dropdownActive then optionsContainer.Visible = false end
            end
        end)

        local DropdownAPI = {}
        function DropdownAPI:AddItem(item)
            if not table.find(items, item) then
                table.insert(items, item)
                renderItems()
            end
        end

        function DropdownAPI:RemoveItem(item)
            local idx = table.find(items, item)
            if idx then
                table.remove(items, idx)
                local selIdx = table.find(selectedItems, item)
                if selIdx then table.remove(selectedItems, selIdx) end
                renderItems()
            end
        end

        function DropdownAPI:SelectAll()
            if isMulti then
                selectedItems = {unpack(items)}
                renderItems()
                pcall(callback, selectedItems)
            end
        end

        function DropdownAPI:DeselectAll()
            selectedItems = {}
            renderItems()
            pcall(callback, isMulti and {} or "")
        end

        return DropdownAPI
    end

    -- ==================== WIDGET: PILIHAN WARNA ====================
    function Tab:AddColorPicker(title, defaultColor, callback)
        callback = callback or function() end
        local selectedColor = defaultColor or Color3.fromRGB(255, 0, 0)
        local cpActive = false

        local cpFrame = Instance.new("Frame")
        cpFrame.Name = "ColorPicker_" .. title
        cpFrame.Size = UDim2.new(1, -8, 0, 38)
        cpFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        cpFrame.ClipsDescendants = true
        cpFrame.Parent = page

        local cpCorner = Instance.new("UICorner")
        cpCorner.CornerRadius = UDim.new(0, 6)
        cpCorner.Parent = cpFrame

        local cpStroke = Instance.new("UIStroke")
        cpStroke.Color = Color3.fromRGB(45, 45, 45)
        cpStroke.Thickness = 1
        cpStroke.Parent = cpFrame

        local mainButton = Instance.new("TextButton")
        mainButton.Size = UDim2.new(1, 0, 0, 38)
        mainButton.BackgroundTransparency = 1
        mainButton.Text = ""
        mainButton.Parent = cpFrame

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
        titleLabel.Position = UDim2.new(0, 10, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.SourceSansBold
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
        titleLabel.TextSize = 12
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = mainButton

        local colorPreview = Instance.new("Frame")
        colorPreview.Size = UDim2.new(0, 22, 0, 16)
        colorPreview.Position = UDim2.new(1, -32, 0.5, -8)
        colorPreview.BackgroundColor3 = selectedColor
        colorPreview.Parent = mainButton

        local previewCorner = Instance.new("UICorner")
        previewCorner.CornerRadius = UDim.new(0, 4)
        previewCorner.Parent = colorPreview

        local pickerContainer = Instance.new("Frame")
        pickerContainer.Size = UDim2.new(1, -20, 0, 75)
        pickerContainer.Position = UDim2.new(0, 10, 0, 42)
        pickerContainer.BackgroundTransparency = 1
        pickerContainer.Visible = false
        pickerContainer.Parent = cpFrame

        local function makeRGBSlider(name, colorVal, posIndex)
            local slider = Instance.new("Frame")
            slider.Size = UDim2.new(1, 0, 0, 18)
            slider.Position = UDim2.new(0, 0, 0, (posIndex - 1) * 23)
            slider.BackgroundTransparency = 1
            slider.Parent = pickerContainer

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0, 12, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Code
            label.Text = name
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.TextSize = 10
            label.Parent = slider

            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -60, 0, 4)
            track.Position = UDim2.new(0, 18, 0.5, -2)
            track.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            track.BorderSizePixel = 0
            track.Parent = slider

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(colorVal, 0, 1, 0)
            fill.BackgroundColor3 = (name == "R" and Color3.fromRGB(220, 50, 50)) or (name == "G" and Color3.fromRGB(50, 220, 50)) or Color3.fromRGB(50, 50, 220)
            fill.Parent = track

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 8, 0, 8)
            knob.Position = UDim2.new(colorVal, -4, 0.5, -4)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.Parent = track

            local valLabel = Instance.new("TextLabel")
            valLabel.Size = UDim2.new(0, 30, 1, 0)
            valLabel.Position = UDim2.new(1, -35, 0, 0)
            valLabel.BackgroundTransparency = 1
            valLabel.Font = Enum.Font.Code
            valLabel.Text = tostring(math.round(colorVal * 255))
            valLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            valLabel.TextSize = 10
            valLabel.Parent = slider

            local activeSliding = false
            local function updateRgb(inputPos)
                local scale = math.clamp((inputPos - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                fill.Size = UDim2.new(scale, 0, 1, 0)
                knob.Position = UDim2.new(scale, -4, 0.5, -4)
                valLabel.Text = tostring(math.round(scale * 255))
                
                local r = name == "R" and scale or selectedColor.R
                local g = name == "G" and scale or selectedColor.G
                local b = name == "B" and scale or selectedColor.B
                selectedColor = Color3.new(r, g, b)
                colorPreview.BackgroundColor3 = selectedColor
                pcall(callback, selectedColor)
            end

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    activeSliding = true
                    updateRgb(input.Position.X)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if activeSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateRgb(input.Position.X)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    activeSliding = false
                end
            end)
        end

        makeRGBSlider("R", selectedColor.R, 1)
        makeRGBSlider("G", selectedColor.G, 2)
        makeRGBSlider("B", selectedColor.B, 3)

        mainButton.MouseButton1Click:Connect(function()
            playSound(Sounds.Hover, 0.3)
            cpActive = not cpActive
            if cpActive then
                pickerContainer.Visible = true
                TweenService:Create(cpFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -8, 0, 125)}):Play()
            else
                TweenService:Create(cpFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -8, 0, 38)}):Play()
                task.wait(0.2)
                if not cpActive then pickerContainer.Visible = false end
            end
        end)
    end

    -- ==================== WIDGET: TOMBOL PINTAS (KEYBIND) ====================
    function Tab:AddKeybind(title, defaultKey, callback)
        callback = callback or function() end
        local selectedKey = defaultKey or Enum.KeyCode.E
        local isListening = false

        local kbFrame = Instance.new("Frame")
        kbFrame.Name = "Keybind_" .. title
        kbFrame.Size = UDim2.new(1, -8, 0, 38)
        kbFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        kbFrame.Parent = page

        local kbCorner = Instance.new("UICorner")
        kbCorner.CornerRadius = UDim.new(0, 6)
        kbCorner.Parent = kbFrame

        local kbStroke = Instance.new("UIStroke")
        kbStroke.Color = Color3.fromRGB(45, 45, 45)
        kbStroke.Thickness = 1
        kbStroke.Parent = kbFrame

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
        titleLabel.Position = UDim2.new(0, 10, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.SourceSansBold
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
        titleLabel.TextSize = 12
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = kbFrame

        local bindBtn = Instance.new("TextButton")
        bindBtn.Size = UDim2.new(0, 65, 0, 22)
        bindBtn.Position = UDim2.new(1, -75, 0.5, -11)
        bindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        bindBtn.Font = Enum.Font.Code
        bindBtn.Text = selectedKey.Name
        bindBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
        bindBtn.TextSize = 10
        bindBtn.Parent = kbFrame

        local bindCorner = Instance.new("UICorner")
        bindCorner.CornerRadius = UDim.new(0, 4)
        bindCorner.Parent = bindBtn

        local bindStroke = Instance.new("UIStroke")
        bindStroke.Color = Color3.fromRGB(55, 55, 55)
        bindStroke.Thickness = 1
        bindStroke.Parent = bindBtn

        bindBtn.MouseButton1Click:Connect(function()
            playSound(Sounds.Click, 0.4)
            isListening = true
            bindBtn.Text = "..."
            bindBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 30)
        end)

        UserInputService.InputBegan:Connect(function(input, processed)
            if isListening and not processed then
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    selectedKey = input.KeyCode
                    isListening = false
                    bindBtn.Text = selectedKey.Name
                    bindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                end
            elseif not isListening and not processed then
                if input.KeyCode == selectedKey then
                    pcall(callback)
                end
            end
        end)
    end

    -- ==================== WIDGET: LABEL / TEKS ====================
    function Tab:AddLabel(text, richText, animated)
        local labelFrame = Instance.new("Frame")
        labelFrame.Name = "Label_" .. string.sub(text, 1, 8)
        labelFrame.Size = UDim2.new(1, -8, 0, 22)
        labelFrame.BackgroundTransparency = 1
        labelFrame.Parent = page

        local txtLabel = Instance.new("TextLabel")
        txtLabel.Size = UDim2.new(1, -10, 1, 0)
        txtLabel.Position = UDim2.new(0, 5, 0, 0)
        txtLabel.BackgroundTransparency = 1
        txtLabel.Font = Enum.Font.SourceSans
        txtLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        txtLabel.TextSize = 12
        txtLabel.TextXAlignment = Enum.TextXAlignment.Left
        txtLabel.RichText = richText or false
        txtLabel.Text = text
        txtLabel.Parent = labelFrame

        if animated then
            txtLabel.Text = ""
            task.spawn(function()
                for i = 1, #text do
                    txtLabel.Text = string.sub(text, 1, i)
                    task.wait(0.04)
                end
            end)
        end

        local LabelAPI = {}
        function LabelAPI:SetText(newText)
            txtLabel.Text = newText
        end
        return LabelAPI
    end

    -- ==================== WIDGET: PARAGRAF ====================
    function Tab:AddParagraph(title, description)
        local paraFrame = Instance.new("Frame")
        paraFrame.Name = "Paragraph_" .. title
        paraFrame.Size = UDim2.new(1, -8, 0, 48)
        paraFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        paraFrame.Parent = page

        local pCorner = Instance.new("UICorner")
        pCorner.CornerRadius = UDim.new(0, 6)
        pCorner.Parent = paraFrame

        local pStroke = Instance.new("UIStroke")
        pStroke.Color = Color3.fromRGB(40, 40, 40)
        pStroke.Thickness = 1
        pStroke.Parent = paraFrame

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -20, 0, 18)
        titleLabel.Position = UDim2.new(0, 10, 0, 4)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.SourceSansBold
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
        titleLabel.TextSize = 12
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = paraFrame

        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -20, 0, 22)
        descLabel.Position = UDim2.new(0, 10, 0, 20)
        descLabel.BackgroundTransparency = 1
        descLabel.Font = Enum.Font.SourceSans
        descLabel.Text = description
        descLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
        descLabel.TextSize = 10
        descLabel.TextWrapped = true
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.TextYAlignment = Enum.TextYAlignment.Top
        descLabel.Parent = paraFrame
    end

    return Tab
end

return Library
