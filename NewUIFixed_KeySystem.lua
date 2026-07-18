--[[
    Nexzan Hub UI Library - Edisi Ringkas & Modern (Diperbaiki)
    Dibuat oleh: Nexzan Hub Developer Team
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

-- ==================== ICON FINDER (NAMA ICON) ====================
-- Mengambil mapping Lucide dari IconFinder. Pemanggilan tab cukup memakai
-- nama icon, misalnya "home", "settings", atau "shield-check".
local NamedIconMap = {}
local NamedIconMapLoaded = false
local NamedIconFallback = "rbxassetid://6031075931"
local NamedIconURLs = {
    "https://cdn.jsdelivr.net/gh/Orvez83/IconFinder@main/Icons/Lucide.lua",
    "https://raw.githubusercontent.com/Orvez83/IconFinder/refs/heads/main/Icons/Lucide.lua"
}

local function normalizeIconName(name)
    return string.lower(tostring(name or ""))
        :gsub("%s+", "-")
        :gsub("_", "-")
end

local function loadNamedIconMap()
    if NamedIconMapLoaded then
        return NamedIconMap
    end

    NamedIconMapLoaded = true

    for _, url in ipairs(NamedIconURLs) do
        local success, rawData = pcall(function()
            return game:HttpGet(url)
        end)

        if success and type(rawData) == "string" then
            local parsed, iconTable = pcall(function()
                local loader = loadstring(rawData)
                if type(loader) ~= "function" then
                    error("Icon map tidak bisa di-load")
                end
                return loader()
            end)

            if parsed and type(iconTable) == "table" then
                NamedIconMap = iconTable
                break
            end
        end
    end

    return NamedIconMap
end

local function resolveNamedIcon(iconName)
    if iconName == nil or iconName == "" then
        return NamedIconFallback
    end

    local rawName = tostring(iconName)

    -- Asset ID lama tetap didukung agar source sebelumnya tidak rusak.
    if string.find(rawName, "rbxassetid://", 1, true) then
        return rawName
    end

    if tonumber(rawName) then
        return "rbxassetid://" .. rawName
    end

    local normalizedName = normalizeIconName(rawName)
    local iconTable = loadNamedIconMap()
    local iconId = iconTable[normalizedName] or iconTable[rawName]

    if iconId then
        iconId = tostring(iconId)
        if not string.find(iconId, "rbxassetid://", 1, true) then
            iconId = "rbxassetid://" .. iconId
        end
        return iconId
    end

    return NamedIconFallback
end

-- Pembuatan Logo "NH" Berdasarkan Gambar (Menggunakan Objek Teks Prosedural)
local function createNHLogo(parent, size, baseTextSize)
    local logoFrame = Instance.new("Frame")
    logoFrame.Name = "NH_Logo"
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

    -- Huruf "N" (Perak / Abu-abu Terang)
    local labelN = Instance.new("TextLabel")
    labelN.Name = "N"
    labelN.Size = UDim2.new(0.6, 0, 0.8, 0)
    labelN.Position = UDim2.new(0.08, 0, 0.08, 0)
    labelN.BackgroundTransparency = 1
    labelN.Font = Enum.Font.GothamBlack
    labelN.Text = "N"
    labelN.TextColor3 = Color3.fromRGB(240, 240, 245)
    labelN.TextSize = baseTextSize or 20
    labelN.TextXAlignment = Enum.TextXAlignment.Center
    labelN.TextYAlignment = Enum.TextYAlignment.Center
    labelN.Parent = logoFrame

    -- Huruf "H" (Biru Elektrik)
    local labelH = Instance.new("TextLabel")
    labelH.Name = "H"
    labelH.Size = UDim2.new(0.6, 0, 0.8, 0)
    labelH.Position = UDim2.new(0.34, 0, 0.14, 0)
    labelH.BackgroundTransparency = 1
    labelH.Font = Enum.Font.GothamBlack
    labelH.Text = "H"
    labelH.TextColor3 = Color3.fromRGB(41, 128, 255)
    labelH.TextSize = baseTextSize or 20
    labelH.TextXAlignment = Enum.TextXAlignment.Center
    labelH.TextYAlignment = Enum.TextYAlignment.Center
    labelH.Parent = logoFrame

    -- Stroke Hitam Tebal untuk memberi Efek Outline/Dimensi (3D Look)
    local strokeN = Instance.new("UIStroke")
    strokeN.Color = Color3.fromRGB(5, 5, 5)
    strokeN.Thickness = 2
    strokeN.Parent = labelN

    local strokeH = Instance.new("UIStroke")
    strokeH.Color = Color3.fromRGB(5, 5, 5)
    strokeH.Thickness = 2
    strokeH.Parent = labelH

    local function adjustTextSize()
        local scaleFactor = logoFrame.AbsoluteSize.Y
        labelN.TextSize = scaleFactor * 0.52
        labelH.TextSize = scaleFactor * 0.52
    end
    logoFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(adjustTextSize)

    return logoFrame
end

-- Objek Pustaka (Library)
local Library = {}
Library.__index = Library

function Library.new(config)
    local self = setmetatable({}, Library)

    if type(config) == "string" then
        config = {Theme = config}
    elseif type(config) ~= "table" then
        config = {}
    end

    -- Konfigurasi System Key. Default ini dipakai untuk testing.
    local expectedKey = tostring(config.Key or "NEXZAN-KEY")
    local getKeyURL = tostring(config.GetKeyURL or "https://discord.gg/your-server")
    local customValidateKey = config.ValidateKey
    local customOpenGetKey = config.OpenGetKey

    -- Tema dapat dipilih saat pemanggilan: Blue, Blood, Purple, Emerald, Gold, Cyan.
    local ThemePresets = {
        Blue = {
            MainBackground = Color3.fromRGB(8, 15, 29),
            PanelBackground = Color3.fromRGB(8, 15, 29),
            OverlayBackground = Color3.fromRGB(3, 8, 18),
            InputBackground = Color3.fromRGB(9, 14, 25),
            Surface = Color3.fromRGB(25, 34, 52),
            TrackBackground = Color3.fromRGB(44, 57, 78),
            MainBorder = Color3.fromRGB(45, 100, 180),
            BorderSoft = Color3.fromRGB(85, 112, 155),
            Accent = Color3.fromRGB(41, 128, 255),
            AccentLight = Color3.fromRGB(150, 202, 255),
            LightGrayTrans = Color3.fromRGB(28, 46, 75),
            TextPrimary = Color3.fromRGB(240, 245, 255),
            TextSecondary = Color3.fromRGB(160, 175, 200),
            NotificationColor = Color3.fromRGB(255, 75, 75)
        },
        Blood = {
            MainBackground = Color3.fromRGB(28, 7, 13),
            PanelBackground = Color3.fromRGB(30, 8, 15),
            OverlayBackground = Color3.fromRGB(16, 3, 8),
            InputBackground = Color3.fromRGB(25, 7, 13),
            Surface = Color3.fromRGB(62, 18, 29),
            TrackBackground = Color3.fromRGB(82, 25, 38),
            MainBorder = Color3.fromRGB(150, 35, 52),
            BorderSoft = Color3.fromRGB(145, 70, 84),
            Accent = Color3.fromRGB(225, 45, 68),
            AccentLight = Color3.fromRGB(255, 145, 155),
            LightGrayTrans = Color3.fromRGB(76, 20, 32),
            TextPrimary = Color3.fromRGB(255, 240, 243),
            TextSecondary = Color3.fromRGB(205, 155, 165),
            NotificationColor = Color3.fromRGB(255, 90, 90)
        },
        Purple = {
            MainBackground = Color3.fromRGB(17, 10, 32),
            PanelBackground = Color3.fromRGB(20, 11, 38),
            OverlayBackground = Color3.fromRGB(8, 4, 18),
            InputBackground = Color3.fromRGB(16, 8, 30),
            Surface = Color3.fromRGB(52, 27, 82),
            TrackBackground = Color3.fromRGB(68, 38, 102),
            MainBorder = Color3.fromRGB(111, 70, 188),
            BorderSoft = Color3.fromRGB(125, 92, 170),
            Accent = Color3.fromRGB(157, 91, 255),
            AccentLight = Color3.fromRGB(210, 175, 255),
            LightGrayTrans = Color3.fromRGB(48, 26, 80),
            TextPrimary = Color3.fromRGB(246, 240, 255),
            TextSecondary = Color3.fromRGB(180, 160, 205),
            NotificationColor = Color3.fromRGB(255, 90, 150)
        },
        Emerald = {
            MainBackground = Color3.fromRGB(6, 25, 22),
            PanelBackground = Color3.fromRGB(7, 29, 25),
            OverlayBackground = Color3.fromRGB(2, 12, 11),
            InputBackground = Color3.fromRGB(5, 22, 19),
            Surface = Color3.fromRGB(18, 66, 57),
            TrackBackground = Color3.fromRGB(25, 86, 73),
            MainBorder = Color3.fromRGB(35, 137, 111),
            BorderSoft = Color3.fromRGB(72, 145, 128),
            Accent = Color3.fromRGB(38, 194, 144),
            AccentLight = Color3.fromRGB(150, 255, 218),
            LightGrayTrans = Color3.fromRGB(17, 66, 56),
            TextPrimary = Color3.fromRGB(235, 255, 249),
            TextSecondary = Color3.fromRGB(153, 198, 185),
            NotificationColor = Color3.fromRGB(255, 95, 95)
        },
        Gold = {
            MainBackground = Color3.fromRGB(28, 21, 7),
            PanelBackground = Color3.fromRGB(33, 24, 7),
            OverlayBackground = Color3.fromRGB(15, 11, 3),
            InputBackground = Color3.fromRGB(25, 18, 5),
            Surface = Color3.fromRGB(76, 57, 18),
            TrackBackground = Color3.fromRGB(94, 70, 22),
            MainBorder = Color3.fromRGB(170, 122, 35),
            BorderSoft = Color3.fromRGB(160, 130, 75),
            Accent = Color3.fromRGB(238, 174, 52),
            AccentLight = Color3.fromRGB(255, 224, 140),
            LightGrayTrans = Color3.fromRGB(76, 56, 16),
            TextPrimary = Color3.fromRGB(255, 249, 228),
            TextSecondary = Color3.fromRGB(207, 184, 126),
            NotificationColor = Color3.fromRGB(255, 90, 70)
        },
        Cyan = {
            MainBackground = Color3.fromRGB(5, 22, 30),
            PanelBackground = Color3.fromRGB(5, 27, 37),
            OverlayBackground = Color3.fromRGB(2, 12, 17),
            InputBackground = Color3.fromRGB(4, 20, 28),
            Surface = Color3.fromRGB(14, 64, 79),
            TrackBackground = Color3.fromRGB(19, 84, 100),
            MainBorder = Color3.fromRGB(29, 147, 172),
            BorderSoft = Color3.fromRGB(73, 148, 166),
            Accent = Color3.fromRGB(33, 194, 231),
            AccentLight = Color3.fromRGB(150, 241, 255),
            LightGrayTrans = Color3.fromRGB(15, 65, 80),
            TextPrimary = Color3.fromRGB(235, 253, 255),
            TextSecondary = Color3.fromRGB(151, 199, 210),
            NotificationColor = Color3.fromRGB(255, 95, 95)
        }
    }

    local themeAliases = {
        blue = "Blue",
        blood = "Blood",
        purple = "Purple",
        emerald = "Emerald",
        gold = "Gold",
        cyan = "Cyan"
    }
    local requestedTheme = string.lower(tostring(config.Theme or config.theme or config.ThemeName or "Blue"))
    local selectedThemeName = themeAliases[requestedTheme] or "Blue"
    local palette = ThemePresets[selectedThemeName]

    self.ThemeName = selectedThemeName
    self.AvailableThemes = {"Blue", "Blood", "Purple", "Emerald", "Gold", "Cyan"}
    self.Theme = palette
    
    -- Pembuatan Screen GUI Utama
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NexzanHub_ScreenGui"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    -- Pastikan halaman System Key selalu berada di atas UI lain.
    screenGui.DisplayOrder = 100
    
    pcall(function()
        screenGui.Parent = game:GetService("CoreGui")
    end)
    if not screenGui.Parent then
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    self.ScreenGui = screenGui

    -- Layer khusus popup dropdown agar tidak terpotong oleh MainFrame/ScrollingFrame.
    local dropdownLayer = Instance.new("Frame")
    dropdownLayer.Name = "DropdownLayer"
    dropdownLayer.Size = UDim2.new(1, 0, 1, 0)
    dropdownLayer.Position = UDim2.new(0, 0, 0, 0)
    dropdownLayer.BackgroundTransparency = 1
    dropdownLayer.BorderSizePixel = 0
    dropdownLayer.ClipsDescendants = false
    dropdownLayer.Active = false
    dropdownLayer.ZIndex = 200
    dropdownLayer.Parent = screenGui
    self.DropdownLayer = dropdownLayer

    -- Container UI Utama (Lebih Ringkas & Kecil)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 480, 0, 310)
    mainFrame.Position = UDim2.new(0.5, -240, 0.5, -155)
    mainFrame.BackgroundColor3 = self.Theme.MainBackground
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    -- UI utama baru ditampilkan setelah System Key selesai selama 5 detik.
    mainFrame.Visible = false
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
    sidebarBorder.BackgroundColor3 = self.Theme.MainBorder
    sidebarBorder.BorderSizePixel = 0
    sidebarBorder.Parent = sidebar

    -- Wadah Logo Prosedural "NH" di Atas Sidebar
    local logoHolder = Instance.new("Frame")
    logoHolder.Name = "LogoHolder"
    logoHolder.Size = UDim2.new(0, 42, 0, 42)
    logoHolder.Position = UDim2.new(0.5, -21, 0, 12)
    logoHolder.BackgroundTransparency = 1
    logoHolder.Parent = sidebar

    createNHLogo(logoHolder, UDim2.new(1, 0, 1, 0), 20)

    -- Bar Pencarian Kategori di Atas Daftar Tab
    local searchContainer = Instance.new("Frame")
    searchContainer.Name = "SearchContainer"
    searchContainer.Size = UDim2.new(0, 120, 0, 24)
    searchContainer.Position = UDim2.new(0.5, -60, 0, 62)
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
    tabContainer.Size = UDim2.new(1, -10, 1, -95)
    tabContainer.Position = UDim2.new(0, 5, 0, 92)
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
    header.Size = UDim2.new(1, -140, 0, 45)
    header.Position = UDim2.new(0, 140, 0, 0)
    header.BackgroundTransparency = 1
    header.Parent = mainFrame

    local headerBorder = Instance.new("Frame")
    headerBorder.Size = UDim2.new(1, 0, 0, 1)
    headerBorder.Position = UDim2.new(0, 0, 1, 0)
    headerBorder.BackgroundColor3 = self.Theme.MainBorder
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
    creditLabel.Text = "Dibuat oleh Nexzan Hub"
    creditLabel.TextXAlignment = Enum.TextXAlignment.Left
    creditLabel.Parent = header

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
    contentArea.Size = UDim2.new(1, -140, 1, -45)
    contentArea.Position = UDim2.new(0, 140, 0, 45)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame

    -- WIDGET MOBILE MINIMIZE (Sesuai Desain Logo NH Baru)
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

    -- Logo "NH" Interaktif
    local miniLogoHolder = Instance.new("Frame")
    miniLogoHolder.Name = "MiniLogoHolder"
    miniLogoHolder.Size = UDim2.new(1, 0, 1, 0)
    miniLogoHolder.BackgroundTransparency = 1
    miniLogoHolder.Parent = miniWidget

    createNHLogo(miniLogoHolder, UDim2.new(1, 0, 1, 0), 18)

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

    -- ==================== SYSTEM KEY: KEY -> SOURCE -> UI UTAMA ====================
    -- Key screen dan Source screen memakai warna/background yang sama.
    -- Bulan/gambar eksternal tidak digunakan agar source tetap ringan.
    local keyOverlay = Instance.new("Frame")
    keyOverlay.Name = "KeySystem"
    keyOverlay.Size = UDim2.new(1, 0, 1, 0)
    keyOverlay.Position = UDim2.new(0, 0, 0, 0)
    keyOverlay.BackgroundColor3 = self.Theme.OverlayBackground
    keyOverlay.BackgroundTransparency = 0.28
    keyOverlay.BorderSizePixel = 0
    keyOverlay.Active = true
    keyOverlay.ZIndex = 50
    keyOverlay.Parent = screenGui

    local function createSystemPanel(name)
        local panel = Instance.new("Frame")
        panel.Name = name
        panel.AnchorPoint = Vector2.new(0.5, 0.5)
        panel.Size = UDim2.new(0.82, 0, 0, 235)
        panel.Position = UDim2.new(0.5, 0, 0.5, 0)
        panel.BackgroundColor3 = self.Theme.PanelBackground
        panel.BackgroundTransparency = 0.08
        panel.BorderSizePixel = 0
        panel.ZIndex = 51
        panel.Parent = keyOverlay

        local sizeConstraint = Instance.new("UISizeConstraint")
        sizeConstraint.MinSize = Vector2.new(280, 220)
        sizeConstraint.MaxSize = Vector2.new(460, 235)
        sizeConstraint.Parent = panel

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = panel

        local stroke = Instance.new("UIStroke")
        stroke.Name = "BlueBorder"
        stroke.Color = self.Theme.Accent
        stroke.Thickness = 1.6
        stroke.Transparency = 0.08
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = panel

        return panel
    end

    local function addTopHeader(panel, titleText, subtitleText, showClose)
        -- Area khusus untuk drag agar tidak mengganggu TextBox dan tombol.
        local dragHandle = Instance.new("Frame")
        dragHandle.Name = "DragHandle"
        dragHandle.Size = UDim2.new(1, -60, 0, 48)
        dragHandle.Position = UDim2.new(0, 0, 0, 0)
        dragHandle.BackgroundTransparency = 1
        dragHandle.BorderSizePixel = 0
        dragHandle.Active = true
        dragHandle.ZIndex = 51
        dragHandle.Parent = panel

        local hubLabel = Instance.new("TextLabel")
        hubLabel.Name = "HubLabel"
        hubLabel.Size = UDim2.new(0.58, 0, 0, 25)
        hubLabel.Position = UDim2.new(0, 20, 0, 15)
        hubLabel.BackgroundTransparency = 1
        hubLabel.Font = Enum.Font.GothamBold
        hubLabel.Text = "Nexzan Hub"
        hubLabel.TextColor3 = self.Theme.TextPrimary
        hubLabel.TextSize = 17
        hubLabel.TextXAlignment = Enum.TextXAlignment.Left
        hubLabel.ZIndex = 52
        hubLabel.Parent = panel

        local sourceLabel = Instance.new("TextLabel")
        sourceLabel.Name = "SourceLabel"
        sourceLabel.Size = UDim2.new(0.28, 0, 0, 25)
        sourceLabel.Position = UDim2.new(0.72, -20, 0, 15)
        sourceLabel.BackgroundTransparency = 1
        sourceLabel.Font = Enum.Font.GothamSemibold
        sourceLabel.Text = "Source"
        sourceLabel.TextColor3 = self.Theme.Accent
        sourceLabel.TextSize = 14
        sourceLabel.TextXAlignment = Enum.TextXAlignment.Right
        sourceLabel.ZIndex = 52
        sourceLabel.Parent = panel

        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Size = UDim2.new(1, -40, 0, 28)
        title.Position = UDim2.new(0, 20, 0, 54)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.Text = titleText
        title.TextColor3 = self.Theme.TextPrimary
        title.TextSize = 21
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 52
        title.Parent = panel

        local subtitle = Instance.new("TextLabel")
        subtitle.Name = "Subtitle"
        subtitle.Size = UDim2.new(1, -40, 0, 22)
        subtitle.Position = UDim2.new(0, 20, 0, 82)
        subtitle.BackgroundTransparency = 1
        subtitle.Font = Enum.Font.SourceSans
        subtitle.Text = subtitleText
        subtitle.TextColor3 = self.Theme.TextSecondary
        subtitle.TextSize = 13
        subtitle.TextXAlignment = Enum.TextXAlignment.Left
        subtitle.ZIndex = 52
        subtitle.Parent = panel

        local divider = Instance.new("Frame")
        divider.Name = "Divider"
        divider.Size = UDim2.new(1, -40, 0, 1)
        divider.Position = UDim2.new(0, 20, 0, 112)
        divider.BackgroundColor3 = self.Theme.Accent
        divider.BackgroundTransparency = 0.48
        divider.BorderSizePixel = 0
        divider.ZIndex = 52
        divider.Parent = panel

        local closeButton
        if showClose then
            closeButton = Instance.new("TextButton")
            closeButton.Name = "CloseButton"
            closeButton.Size = UDim2.new(0, 28, 0, 28)
            closeButton.Position = UDim2.new(1, -42, 0, 13)
            closeButton.BackgroundTransparency = 1
            closeButton.Font = Enum.Font.Gotham
            closeButton.Text = "×"
            closeButton.TextColor3 = self.Theme.AccentLight
            closeButton.TextSize = 28
            closeButton.ZIndex = 53
            closeButton.Parent = panel

            closeButton.MouseButton1Click:Connect(function()
                if screenGui.Parent then
                    screenGui:Destroy()
                end
            end)
        end

        return closeButton, dragHandle
    end

    -- ==================== TAMPILAN MASUKKAN KEY ====================
    local keyPanel = createSystemPanel("KeyPanel")
    local _, keyDragHandle = addTopHeader(keyPanel, "Key-System [Nex]", "Key Di Discord", true)
    makeDraggable(keyPanel, keyDragHandle)

    local keyBox = Instance.new("TextBox")
    keyBox.Name = "KeyInput"
    keyBox.Size = UDim2.new(1, -44, 0, 38)
    keyBox.Position = UDim2.new(0, 22, 0, 108)
    keyBox.BackgroundColor3 = self.Theme.InputBackground
    keyBox.BackgroundTransparency = 0.1
    keyBox.BorderSizePixel = 0
    keyBox.ClearTextOnFocus = false
    keyBox.Font = Enum.Font.SourceSans
    keyBox.PlaceholderText = "Masukkan Key Anda..."
    keyBox.PlaceholderColor3 = self.Theme.TextSecondary
    keyBox.Text = ""
    keyBox.TextColor3 = self.Theme.TextPrimary
    keyBox.TextSize = 14
    keyBox.TextXAlignment = Enum.TextXAlignment.Left
    keyBox.ZIndex = 52
    keyBox.Parent = keyPanel

    local keyBoxPadding = Instance.new("UIPadding")
    keyBoxPadding.PaddingLeft = UDim.new(0, 14)
    keyBoxPadding.PaddingRight = UDim.new(0, 42)
    keyBoxPadding.Parent = keyBox

    local keyBoxCorner = Instance.new("UICorner")
    keyBoxCorner.CornerRadius = UDim.new(0, 8)
    keyBoxCorner.Parent = keyBox

    local keyBoxStroke = Instance.new("UIStroke")
    keyBoxStroke.Color = self.Theme.Accent
    keyBoxStroke.Thickness = 1.3
    keyBoxStroke.Transparency = 0.05
    keyBoxStroke.Parent = keyBox

    local keyIcon = Instance.new("TextLabel")
    keyIcon.Name = "KeyIcon"
    keyIcon.Size = UDim2.new(0, 30, 0, 30)
    keyIcon.Position = UDim2.new(1, -42, 0.5, -15)
    keyIcon.BackgroundTransparency = 1
    keyIcon.Font = Enum.Font.GothamBold
    keyIcon.Text = "KEY"
    keyIcon.TextColor3 = self.Theme.AccentLight
    keyIcon.TextSize = 9
    keyIcon.TextXAlignment = Enum.TextXAlignment.Center
    keyIcon.ZIndex = 53
    keyIcon.Parent = keyBox

    local getKeyButton = Instance.new("TextButton")
    getKeyButton.Name = "GetKey"
    getKeyButton.Size = UDim2.new(0.34, -3, 0, 38)
    getKeyButton.Position = UDim2.new(0, 22, 0, 155)
    getKeyButton.BackgroundColor3 = self.Theme.Surface
    getKeyButton.BackgroundTransparency = 0.08
    getKeyButton.BorderSizePixel = 0
    getKeyButton.Font = Enum.Font.GothamSemibold
    getKeyButton.Text = "GetKey"
    getKeyButton.TextColor3 = self.Theme.TextPrimary
    getKeyButton.TextSize = 13
    getKeyButton.ZIndex = 52
    getKeyButton.Parent = keyPanel

    local getKeyCorner = Instance.new("UICorner")
    getKeyCorner.CornerRadius = UDim.new(0, 8)
    getKeyCorner.Parent = getKeyButton

    local getKeyStroke = Instance.new("UIStroke")
    getKeyStroke.Color = self.Theme.BorderSoft
    getKeyStroke.Thickness = 1
    getKeyStroke.Transparency = 0.25
    getKeyStroke.Parent = getKeyButton

    local checkKeyButton = Instance.new("TextButton")
    checkKeyButton.Name = "CheckKey"
    checkKeyButton.Size = UDim2.new(0.54, -3, 0, 38)
    checkKeyButton.Position = UDim2.new(0.46, 0, 0, 155)
    checkKeyButton.BackgroundColor3 = self.Theme.Accent
    checkKeyButton.BackgroundTransparency = 0.08
    checkKeyButton.BorderSizePixel = 0
    checkKeyButton.Font = Enum.Font.GothamSemibold
    checkKeyButton.Text = "✓  Check Key"
    checkKeyButton.TextColor3 = self.Theme.TextPrimary
    checkKeyButton.TextSize = 13
    checkKeyButton.ZIndex = 52
    checkKeyButton.Parent = keyPanel

    local checkKeyCorner = Instance.new("UICorner")
    checkKeyCorner.CornerRadius = UDim.new(0, 8)
    checkKeyCorner.Parent = checkKeyButton

    local checkKeyStroke = Instance.new("UIStroke")
    checkKeyStroke.Color = self.Theme.AccentLight
    checkKeyStroke.Thickness = 1
    checkKeyStroke.Transparency = 0.18
    checkKeyStroke.Parent = checkKeyButton

    local keyStatusBox = Instance.new("Frame")
    keyStatusBox.Name = "KeyStatus"
    keyStatusBox.Size = UDim2.new(1, -44, 0, 28)
    keyStatusBox.Position = UDim2.new(0, 22, 0, 201)
    keyStatusBox.BackgroundColor3 = self.Theme.Surface
    keyStatusBox.BackgroundTransparency = 0.1
    keyStatusBox.BorderSizePixel = 0
    keyStatusBox.ZIndex = 52
    keyStatusBox.Parent = keyPanel

    local keyStatusCorner = Instance.new("UICorner")
    keyStatusCorner.CornerRadius = UDim.new(0, 8)
    keyStatusCorner.Parent = keyStatusBox

    local keyStatusStroke = Instance.new("UIStroke")
    keyStatusStroke.Color = self.Theme.BorderSoft
    keyStatusStroke.Thickness = 1
    keyStatusStroke.Transparency = 0.28
    keyStatusStroke.Parent = keyStatusBox

    local keyStatusLabel = Instance.new("TextLabel")
    keyStatusLabel.Name = "StatusLabel"
    keyStatusLabel.Size = UDim2.new(1, -20, 1, 0)
    keyStatusLabel.Position = UDim2.new(0, 10, 0, 0)
    keyStatusLabel.BackgroundTransparency = 1
    keyStatusLabel.Font = Enum.Font.SourceSans
    keyStatusLabel.Text = "Status: -"
    keyStatusLabel.TextColor3 = self.Theme.TextSecondary
    keyStatusLabel.TextSize = 11
    keyStatusLabel.TextXAlignment = Enum.TextXAlignment.Center
    keyStatusLabel.ZIndex = 53
    keyStatusLabel.Parent = keyStatusBox

    -- ==================== TAMPILAN SOURCE / LOADING 5 DETIK ====================
    local sourcePanel = createSystemPanel("SourcePanel")
    sourcePanel.Visible = false
    local _, sourceDragHandle = addTopHeader(sourcePanel, "Source", "Menyiapkan Nexzan Hub...", false)
    makeDraggable(sourcePanel, sourceDragHandle)

    local sourcePercent = Instance.new("TextLabel")
    sourcePercent.Name = "Percent"
    sourcePercent.Size = UDim2.new(1, -40, 0, 36)
    sourcePercent.Position = UDim2.new(0, 20, 0, 108)
    sourcePercent.BackgroundTransparency = 1
    sourcePercent.Font = Enum.Font.GothamBold
    sourcePercent.Text = "0%"
    sourcePercent.TextColor3 = self.Theme.TextPrimary
    sourcePercent.TextSize = 24
    sourcePercent.TextXAlignment = Enum.TextXAlignment.Center
    sourcePercent.TextYAlignment = Enum.TextYAlignment.Center
    sourcePercent.ZIndex = 52
    sourcePercent.Parent = sourcePanel

    local progressTrack = Instance.new("Frame")
    progressTrack.Name = "ProgressTrack"
    progressTrack.Size = UDim2.new(1, -44, 0, 8)
    progressTrack.Position = UDim2.new(0, 22, 0, 155)
    progressTrack.BackgroundColor3 = self.Theme.TrackBackground
    progressTrack.BackgroundTransparency = 0.14
    progressTrack.BorderSizePixel = 0
    progressTrack.ClipsDescendants = true
    progressTrack.ZIndex = 52
    progressTrack.Parent = sourcePanel

    local progressTrackCorner = Instance.new("UICorner")
    progressTrackCorner.CornerRadius = UDim.new(1, 0)
    progressTrackCorner.Parent = progressTrack

    local progressFill = Instance.new("Frame")
    progressFill.Name = "ProgressBar"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = self.Theme.Accent
    progressFill.BackgroundTransparency = 0
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 53
    progressFill.Parent = progressTrack

    local progressFillCorner = Instance.new("UICorner")
    progressFillCorner.CornerRadius = UDim.new(1, 0)
    progressFillCorner.Parent = progressFill

    local sourceStatus = Instance.new("TextLabel")
    sourceStatus.Name = "Status"
    sourceStatus.Size = UDim2.new(1, -40, 0, 20)
    sourceStatus.Position = UDim2.new(0, 20, 0, 177)
    sourceStatus.BackgroundTransparency = 1
    sourceStatus.Font = Enum.Font.SourceSans
    sourceStatus.Text = "Loading source..."
    sourceStatus.TextColor3 = self.Theme.TextSecondary
    sourceStatus.TextSize = 11
    sourceStatus.TextXAlignment = Enum.TextXAlignment.Center
    sourceStatus.ZIndex = 52
    sourceStatus.Parent = sourcePanel

    local function setKeyStatus(text, color)
        keyStatusLabel.Text = text
        keyStatusLabel.TextColor3 = color or Color3.fromRGB(192, 202, 220)
    end

    local function copyGetKeyURL()
        if type(customOpenGetKey) == "function" then
            local ok = pcall(customOpenGetKey, getKeyURL)
            return ok, "URL GetKey dibuka."
        end

        local copied = false
        pcall(function()
            if type(setclipboard) == "function" then
                setclipboard(getKeyURL)
                copied = true
            elseif type(toclipboard) == "function" then
                toclipboard(getKeyURL)
                copied = true
            end
        end)

        if copied then
            return true, "URL GetKey disalin ke clipboard."
        end
        return false, "URL GetKey: " .. getKeyURL
    end

    local function validateEnteredKey(enteredKey)
        if type(customValidateKey) == "function" then
            local ok, result = pcall(customValidateKey, enteredKey)
            return ok and result == true
        end
        return enteredKey == expectedKey
    end

    getKeyButton.MouseButton1Click:Connect(function()
        playSound(Sounds.Click, 0.4)
        local _, message = copyGetKeyURL()
        setKeyStatus(message, Color3.fromRGB(131, 190, 255))
    end)

    local sourceStarted = false
    local openSourceScreen
    openSourceScreen = function()
        if sourceStarted then
            return
        end
        sourceStarted = true
        keyPanel.Visible = false
        sourcePanel.Visible = true

        local duration = 5
        local startedAt = os.clock()
        TweenService:Create(
            progressFill,
            TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
            {Size = UDim2.new(1, 0, 1, 0)}
        ):Play()

        task.spawn(function()
            while screenGui.Parent and sourcePanel.Parent do
                local progress = math.clamp((os.clock() - startedAt) / duration, 0, 1)
                sourcePercent.Text = string.format("%d%%", math.floor(progress * 100 + 0.5))

                if progress >= 1 then
                    break
                end
                task.wait(0.05)
            end

            if screenGui.Parent and sourcePanel.Parent then
                sourcePercent.Text = "100%"
                progressFill.Size = UDim2.new(1, 0, 1, 0)
                sourceStatus.Text = "Selesai"
                keyOverlay:Destroy()
                mainFrame.Visible = true
            end
        end)
    end

    checkKeyButton.MouseButton1Click:Connect(function()
        playSound(Sounds.Click, 0.4)
        local enteredKey = string.gsub(keyBox.Text, "^%s*(.-)%s*$", "%1")

        if enteredKey == "" then
            setKeyStatus("Status: Masukkan key terlebih dahulu.", Color3.fromRGB(255, 166, 166))
            return
        end

        if validateEnteredKey(enteredKey) then
            setKeyStatus("Status: Key benar. Membuka Source...", Color3.fromRGB(108, 231, 130))
            checkKeyButton.Text = "✓  Key Benar"
            checkKeyButton.Active = false
            keyBox.Active = false
            task.wait(0.25)
            openSourceScreen()
        else
            setKeyStatus("Status: Key salah.", Color3.fromRGB(255, 108, 108))
            checkKeyButton.Text = "✕  Key Salah"
            task.delay(1.2, function()
                if checkKeyButton.Parent then
                    checkKeyButton.Text = "✓  Check Key"
                end
            end)
        end
    end)

    self.KeySystem = {
        Screen = keyOverlay,
        KeyPanel = keyPanel,
        SourcePanel = sourcePanel,
        KeyInput = keyBox,
        GetKeyButton = getKeyButton,
        CheckKeyButton = checkKeyButton,
        ProgressBar = progressFill,
        PercentLabel = sourcePercent,
        Duration = 5,
        ExpectedKey = expectedKey
    }

    -- Bisa dipanggil setelah UI dibuat: UI:SetTheme("Blood")
    function self:SetTheme(themeName)
        local requested = string.lower(tostring(themeName or ""))
        local canonical = themeAliases[requested]
        if not canonical then
            return false, "Theme tidak ditemukan"
        end

        local oldPalette = self.Theme
        local newPalette = ThemePresets[canonical]
        self.ThemeName = canonical
        self.Theme = newPalette

        local function remapColor(color)
            if color == oldPalette.MainBackground then return newPalette.MainBackground end
            if color == oldPalette.PanelBackground then return newPalette.PanelBackground end
            if color == oldPalette.OverlayBackground then return newPalette.OverlayBackground end
            if color == oldPalette.InputBackground then return newPalette.InputBackground end
            if color == oldPalette.Surface then return newPalette.Surface end
            if color == oldPalette.TrackBackground then return newPalette.TrackBackground end
            if color == oldPalette.MainBorder then return newPalette.MainBorder end
            if color == oldPalette.BorderSoft then return newPalette.BorderSoft end
            if color == oldPalette.Accent then return newPalette.Accent end
            if color == oldPalette.AccentLight then return newPalette.AccentLight end
            if color == oldPalette.LightGrayTrans then return newPalette.LightGrayTrans end
            if color == oldPalette.TextPrimary then return newPalette.TextPrimary end
            if color == oldPalette.TextSecondary then return newPalette.TextSecondary end
            return nil
        end

        if screenGui and screenGui.Parent then
            for _, object in ipairs(screenGui:GetDescendants()) do
                if object:IsA("GuiObject") then
                    local mappedBackground = remapColor(object.BackgroundColor3)
                    if mappedBackground then
                        object.BackgroundColor3 = mappedBackground
                    end
                end

                if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                    local mappedText = remapColor(object.TextColor3)
                    if mappedText then
                        object.TextColor3 = mappedText
                    end
                end

                if object:IsA("ImageLabel") or object:IsA("ImageButton") then
                    local mappedImage = remapColor(object.ImageColor3)
                    if mappedImage then
                        object.ImageColor3 = mappedImage
                    end
                end

                if object:IsA("UIStroke") then
                    local mappedStroke = remapColor(object.Color)
                    if mappedStroke then
                        object.Color = mappedStroke
                    end
                end
            end
        end

        return true, canonical
    end

    return self
end

-- Mendapatkan icon memakai nama, tanpa perlu menulis asset ID.
function Library:GetIcon(iconName)
    return resolveNamedIcon(iconName)
end

-- ==================== FUNGSI BUAT TAB KATEGORI ====================
function Library:CreateTab(tabName, tabIconId)
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
    tabIcon.Image = resolveNamedIcon(tabIconId or "layout-dashboard")
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
        fill.BackgroundColor3 = self.Theme.Accent
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
        local sourceItems = items or {}
        items = {}
        for _, item in ipairs(sourceItems) do
            table.insert(items, tostring(item))
        end
        isMulti = isMulti == true
        callback = callback or function() end

        local dropdownActive = false
        local selectedItems = {}
        local optionButtons = {}

        local ddFrame = Instance.new("Frame")
        ddFrame.Name = "Dropdown_" .. title
        ddFrame.Size = UDim2.new(1, -8, 0, 38)
        ddFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        ddFrame.ClipsDescendants = false
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
        selectedLabel.TextTruncate = Enum.TextTruncate.AtEnd
        selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
        selectedLabel.Parent = mainButton

        local arrow = Instance.new("TextLabel")
        arrow.Size = UDim2.new(0, 18, 0, 18)
        arrow.Position = UDim2.new(1, -26, 0.5, -9)
        arrow.BackgroundTransparency = 1
        arrow.Font = Enum.Font.GothamBold
        arrow.Text = ">"
        arrow.TextColor3 = self.Theme.TextSecondary
        arrow.TextSize = 15
        arrow.TextXAlignment = Enum.TextXAlignment.Center
        arrow.Parent = mainButton

        -- Popup dibuat sebagai child MainFrame agar muncul di samping,
        -- bukan menambah tinggi frame dropdown ke bawah.
        local optionsContainer = Instance.new("ScrollingFrame")
        optionsContainer.Name = "OptionsPopup"
        optionsContainer.Size = UDim2.new(0, 160, 0, 38)
        optionsContainer.Position = UDim2.new(0, 0, 0, 0)
        optionsContainer.BackgroundColor3 = self.Theme.PanelBackground
        optionsContainer.BackgroundTransparency = 0.02
        optionsContainer.BorderSizePixel = 0
        optionsContainer.Active = true
        optionsContainer.ScrollBarThickness = 0
        optionsContainer.ScrollBarImageColor3 = self.Theme.Accent
        optionsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        optionsContainer.Visible = false
        optionsContainer.ZIndex = 201
        optionsContainer.Parent = self.DropdownLayer

        local popupCorner = Instance.new("UICorner")
        popupCorner.CornerRadius = UDim.new(0, 7)
        popupCorner.Parent = optionsContainer

        local popupStroke = Instance.new("UIStroke")
        popupStroke.Color = self.Theme.Accent
        popupStroke.Thickness = 1
        popupStroke.Transparency = 0.25
        popupStroke.Parent = optionsContainer

        local containerPadding = Instance.new("UIPadding")
        containerPadding.PaddingTop = UDim.new(0, 5)
        containerPadding.PaddingBottom = UDim.new(0, 5)
        containerPadding.PaddingLeft = UDim.new(0, 5)
        containerPadding.PaddingRight = UDim.new(0, 5)
        containerPadding.Parent = optionsContainer

        local containerLayout = Instance.new("UIListLayout")
        containerLayout.Padding = UDim.new(0, 3)
        containerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        containerLayout.Parent = optionsContainer

        local function updateDropdownPosition()
            if not optionsContainer.Parent then
                return
            end

            local buttonPos = mainButton.AbsolutePosition
            local buttonSize = mainButton.AbsoluteSize
            local popupSize = optionsContainer.AbsoluteSize
            local camera = workspace.CurrentCamera
            local viewport = camera and camera.ViewportSize or Vector2.new(1920, 1080)

            local x = buttonPos.X + buttonSize.X + 6
            local y = buttonPos.Y

            -- Jika sisi kanan layar penuh, popup pindah ke sisi kiri dropdown.
            if x + popupSize.X > viewport.X - 4 then
                x = buttonPos.X - popupSize.X - 6
            end

            -- Pastikan popup selalu tetap berada di dalam layar.
            x = math.clamp(x, 4, math.max(4, viewport.X - popupSize.X - 4))
            y = math.clamp(y, 4, math.max(4, viewport.Y - popupSize.Y - 4))
            optionsContainer.Position = UDim2.new(0, x, 0, y)
        end

        local function updateDropdownLayout()
            local rowHeight = 24
            local contentHeight = math.max(containerLayout.AbsoluteContentSize.Y + 10, rowHeight + 10)
            local visibleRows = math.min(math.max(#items, 1), 4)
            local popupHeight = visibleRows * rowHeight + 10

            optionsContainer.Size = UDim2.new(0, 160, 0, popupHeight)
            optionsContainer.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
            optionsContainer.ScrollBarThickness = (#items > 4) and 3 or 0

            if dropdownActive then
                task.defer(updateDropdownPosition)
            end
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

        local function refreshOptionColors()
            for optionName, optionButton in pairs(optionButtons) do
                local isSelected = table.find(selectedItems, optionName) ~= nil
                if isSelected then
                    optionButton.BackgroundColor3 = self.Theme.Surface
                    optionButton.Label.TextColor3 = self.Theme.TextPrimary
                    optionButton.Label.Text = (isMulti and "✓  " or "") .. optionName
                else
                    optionButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                    optionButton.Label.TextColor3 = Color3.fromRGB(180, 180, 180)
                    optionButton.Label.Text = (isMulti and "□  " or "") .. optionName
                end
            end
        end

        local function closeDropdown()
            dropdownActive = false
            optionsContainer.Visible = false
            arrow.Text = ">"
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
                refreshOptionColors()
                pcall(callback, selectedItems)
            else
                selectedItems = {item}
                refreshUI()
                refreshOptionColors()
                pcall(callback, item)
                closeDropdown()
            end
        end

        local function renderItems()
            for _, child in ipairs(optionsContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            table.clear(optionButtons)

            for index, item in ipairs(items) do
                local itemText = tostring(item)
                local optionButton = Instance.new("TextButton")
                optionButton.Name = itemText
                optionButton.LayoutOrder = index
                optionButton.Size = UDim2.new(1, -10, 0, 21)
                optionButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                optionButton.BorderSizePixel = 0
                optionButton.Active = true
                optionButton.Text = ""
                optionButton.ZIndex = 41
                optionButton.Parent = optionsContainer

                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = UDim.new(0, 4)
                optionCorner.Parent = optionButton

                local optionLabel = Instance.new("TextLabel")
                optionLabel.Name = "Label"
                optionLabel.Size = UDim2.new(1, -12, 1, 0)
                optionLabel.Position = UDim2.new(0, 8, 0, 0)
                optionLabel.BackgroundTransparency = 1
                optionLabel.Font = Enum.Font.SourceSans
                optionLabel.Text = (isMulti and "□  " or "") .. itemText
                optionLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
                optionLabel.TextSize = 11
                optionLabel.TextTruncate = Enum.TextTruncate.AtEnd
                optionLabel.TextXAlignment = Enum.TextXAlignment.Left
                optionLabel.ZIndex = 42
                optionLabel.Parent = optionButton

                optionButtons[itemText] = optionButton
                optionButton.MouseButton1Click:Connect(function()
                    playSound(Sounds.Click, 0.3)
                    toggleItem(itemText)
                end)
            end

            refreshUI()
            refreshOptionColors()
            task.defer(updateDropdownLayout)
        end

        renderItems()

        mainButton.MouseButton1Click:Connect(function()
            playSound(Sounds.Hover, 0.4)
            dropdownActive = not dropdownActive

            if dropdownActive then
                updateDropdownLayout()
                optionsContainer.Visible = true
                arrow.Text = "<"
                task.defer(updateDropdownPosition)
            else
                closeDropdown()
            end
        end)

        local DropdownAPI = {}

        function DropdownAPI:AddItem(item)
            local itemText = tostring(item)
            if not table.find(items, itemText) then
                table.insert(items, itemText)
                renderItems()
            end
        end

        function DropdownAPI:RemoveItem(item)
            local itemText = tostring(item)
            local idx = table.find(items, itemText)
            if idx then
                table.remove(items, idx)
                local selectedIndex = table.find(selectedItems, itemText)
                if selectedIndex then
                    table.remove(selectedItems, selectedIndex)
                end
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

        function DropdownAPI:IsMultiSelect()
            return isMulti
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
