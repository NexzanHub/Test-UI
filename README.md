# ⚡ AbsoluteUI Library v1.0.1-Fixed

<div align="center">

![AbsoluteUI Banner](https://img.shields.io/badge/AbsoluteUI-Modern%20Roblox%20UI%20Library-2980ff?style=for-the-badge&logo=roblox&logoColor=white)
![Version](https://img.shields.io/badge/Version-1.0.1--fixed-success?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-PC%20%26%20Mobile%20Ready-blueviolet?style=for-the-badge)
![Themes](https://img.shields.io/badge/Themes-20%20Built--in%20%2B%20RGB-ff69b4?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-orange?style=for-the-badge)

**Pustaka UI Roblox Premium, Ringkas, Elegan, dan Kaya Fitur yang Dioptimalkan untuk PC & Mobile.**  
*Dilengkapi dengan sistem Thema Dinamis (20+ Presets), IconFinder Resolving, Tag WindUI-Style, dan Perbaikan Seret (Smooth Dragging) 100%!*

[🌐 Kunjungi Website Dokumentasi](#) • [📥 Unduh File Lua](https://github.com/NexzanHub/Test-UI/releases/download/AbsoluteUI/AbsoluteUI_Fixed.lua) • [💬 Laporkan Bug / Fitur](#)

</div>

---

## 🌟 Mengapa AbsoluteUI?

**AbsoluteUI** dirancang untuk memberikan pengalaman antarmuka pengguna (UI) terbaik bagi pengembang script Roblox maupun pengguna akhir. Berbeda dengan UI library konvensional yang berat dan memakan banyak layar, AbsoluteUI menghadirkan desain **Kompak (480x310)** dengan **Estetika Futuristik / Glassmorphism** yang bekerja sempurna tanpa cacat di perangkat PC maupun Smartphone (Mobile Touch).

### ✨ Fitur Unggulan Utama:
- 📱 **Sempurna untuk PC & Mobile (Touch Friendly):** Sistem *Dragging* (Seret) yang telah diperbaiki total (`makeDraggable` fix). UI dapat diseret dengan lancar menggunakan Mouse maupun sentuhan jari di HP.
- 🗜️ **Widget Perkecil (MiniWidget) Interaktif:** Tombol `-` meminimalkan UI ke logo bulatan kompak ("AU Logo") yang dapat digeser bebas di layar tanpa memicu *auto-click* / buka tidak sengaja berkat deteksi *Drag Threshold*.
- 🎨 **20 Tema Bawaan + Chroma RGB:** Ganti tema secara *real-time* kapan saja! Mendukung tema seperti *AMOLED*, *Cyanic*, *Blood Red*, *Neon Cyber*, hingga animasi **RGB Rainbow** yang mulus.
- 🖼️ **Multi-Platform Icon Service:** Dukungan langsung untuk ribuan ikon dari **Lucide**, **Gravity**, **Solar**, dan **SFSymbols** (misal: `"lucide/home"`, `"solar/palette-bold"`).
- 🏷️ **Header Tags ala WindUI:** Tambahkan lencana/tag dinamis di header jendela dengan warna kustom, ikon, dan metode pemrograman penuh (`SetTitle`, `SetColor`, `SetIcon`).
- 🔍 **Live Category Search:** Bar pencarian internal untuk menyaring ratusan tab kategori secara instan.
- ⚙️ **9 Komponen / Widget Lengkap & Interaktif:** Button, Toggle (dengan animasi geser & warna), Slider (dengan kotak input nilai numerik), Textbox (NumericOnly/TextOnly/Password), Dropdown (Single & Multi-Select), ColorPicker (RGB Sliders), Keybind, Label (RichText & Typewriter Animation), dan Paragraph.

---

## 📥 Instalasi & Quick Start

Gunakan *script loader* di bawah ini pada *Executor* Anda (seperti Synapse Z, Wave, Solara, Delta, Fluxus, Arcen, dll.) atau di dalam skrip pengembangan Anda:

```lua
local AbsoluteUI = loadstring(game:HttpGet("https://github.com/NexzanHub/Test-UI/releases/download/AbsoluteUI/AbsoluteUI_Fixed.lua"))()

-- 1. Buat Jendela Utama (Window)
local Window = AbsoluteUI.new({
    Theme = "Cyanic" -- Pilihan: "Default", "AMOLED", "Cyanic", "Blood Red", "Neon Cyber", "RGB", dll.
})

-- 2. Tambahkan Tag Header (Opsional, ala WindUI)
local VersionTag = Window:Tag({
    Title = "v1.0.1 PRO",
    Icon = "lucide/shield-check",
    Color = Color3.fromRGB(41, 190, 255),
    Radius = 6
})

-- 3. Buat Tab Kategori
local MainTab = Window:CreateTab("Utama", "lucide/home")
local PlayerTab = Window:CreateTab("Karakter", "lucide/user")
local SettingsTab = Window:CreateTab("Pengaturan", "lucide/settings")

-- 4. Tambahkan Komponen ke Tab
MainTab:AddButton("Aktifkan Kecepatan Super", "Meningkatkan WalkSpeed karakter menjadi 100", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
    MainTab:ShowNotification() -- Menampilkan titik notifikasi pada tab
end)

MainTab:AddToggle("Mode Kebal (God Mode)", "Menahan HP agar selalu penuh", false, function(state)
    print("God Mode Status:", state)
end)
```

---

## 📖 Dokumentasi Lengkap API (API Reference)

### 1. Inisialisasi Library (`AbsoluteUI.new`)
Membuat dan menampilkan jendela UI baru.

```lua
local Window = AbsoluteUI.new(options)
```
| Parameter | Tipe Data | Deskripsi | Default |
| :--- | :--- | :--- | :--- |
| `options` | `table / string` | Nama tema (`string`) atau tabel konfigurasi (`{Theme = "NamaTema"}`) | `"Default"` |

---

### 2. Header Tag (`Window:Tag` / `Window:AddTag`)
Menambahkan tag lencana informasi di bagian atas jendela.

```lua
local TagAPI = Window:Tag({
    Title = "Status: Undetected",
    Icon = "lucide/check-circle",
    Color = Color3.fromRGB(46, 204, 113),
    Radius = 5
})

-- Metode yang tersedia pada TagAPI:
TagAPI:SetTitle("Status: Updated")
TagAPI:SetColor(Color3.fromRGB(241, 196, 15))
TagAPI:SetIcon("lucide/alert-triangle")
TagAPI:SetVisible(true)
TagAPI:Destroy()
```

---

### 3. Pembuatan Tab Kategori (`Window:CreateTab`)
Membuat halaman tab baru di sidebar kiri.

```lua
local Tab = Window:CreateTab(tabName, tabIconId)
```
- **`tabName`** (*string*): Nama kategori tab.
- **`tabIconId`** (*string*): Nama ikon dari `IconFinder` (contoh: `"lucide/swords"`, `"gravity/gear"`).
- **`Tab:ShowNotification()`**: Memunculkan indikator titik merah (*Notification Dot*) dan suara notifikasi pada tombol tab.

---

### 4. Daftar Widget / Komponen (`Tab:Add...`)

#### 🔘 Button (Tombol Klik)
```lua
Tab:AddButton("Nama Tombol", "Deskripsi singkat tentang tombol", function()
    print("Tombol berhasil diklik!")
end)
```

#### 🔄 Toggle (Saklar Nyala/Mati)
```lua
Tab:AddToggle("Auto Farm", "Mengaktifkan pertarungan otomatis", false, function(state)
    print("Auto Farm kini:", state ? "Aktif" : "Nonaktif")
end)
```

#### 🎚️ Slider (Pengatur Angka & Geseran)
Dilengkapi dengan kotak teks numerik untuk mengetik nilai secara langsung.
```lua
-- AddSlider(Title, Min, Max, Default, Decimals, Callback)
Tab:AddSlider("Jump Power", 50, 500, 100, 0, function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end)
```

#### ✍️ Textbox (Input Teks / Angka)
Mendukung validasi input khusus dan penyembunyian kata sandi (*Password masking*).
```lua
Tab:AddTextbox("Target Player", "Ketik nama pemain...", {
    NumericOnly = false,  -- Hanya angka jika true
    TextOnly = false,     -- Hanya huruf jika true
    Password = false,     -- Sembunyikan karakter menjadi '*'
    MaxCharacters = 20,   -- Batas maksimal karakter
    ClearButton = true    -- Tombol hapus cepat
}, function(text)
    print("Input dikonfirmasi:", text)
end)
```

#### 📑 Dropdown (Menu Pilihan / Multi-Select)
Mendukung pencarian internal (*Live Filter*), Single Select, maupun Multi Select.
```lua
local Dropdown = Tab:AddDropdown("Pilih Senjata", {"Sword", "Bow", "Staff", "Dagger"}, false, function(selected)
    print("Pilihan terpilih:", selected)
end)

-- Metode Penuh DropdownAPI:
Dropdown:AddItem("Shield")
Dropdown:RemoveItem("Bow")
Dropdown:SelectAll()   -- Khusus Multi-Select
Dropdown:DeselectAll() -- Khusus Multi-Select
```

#### 🎨 ColorPicker (Pemilih Warna RGB)
Memunculkan panel geser R, G, B dan kotak pratinjau warna langsung.
```lua
Tab:AddColorPicker("Warna ESP / Glow", Color3.fromRGB(0, 255, 180), function(color)
    print("RGB Warna Baru:", color.R, color.G, color.B)
end)
```

#### ⌨️ Keybind (Tombol Pintas / Hotkey)
Mendengarkan input keyboard dari pengguna untuk memicu aksi cepat.
```lua
Tab:AddKeybind("Buka Menu Cepat", Enum.KeyCode.RightShift, function()
    print("RightShift ditekan!")
end)
```

#### 🏷️ Label (Teks Info & Animasi Typewriter)
Mendukung format Roblox *RichText* (`<b>`, `<i>`, `<font color=...>`) dan efek ketik animasi.
```lua
local LabelAPI = Tab:AddLabel("<b>[INFO]</b> Selamat datang di Script!", true, true) -- Arg ke-3 = Animasi Ketik

-- Mengubah teks label sewaktu-waktu:
LabelAPI:SetText("<b>[UPDATE]</b> Script telah diperbarui ke v1.0.1!")
```

#### 📋 Paragraph (Kotak Penjelasan Detail)
Menampilkan judul tebal dengan deskripsi panjang dalam bingkai berbingkai elegan.
```lua
Tab:AddParagraph("Catatan Penting", "Gunakan fitur ini dengan bijak. Beberapa fitur mungkin memerlukan akses khusus atau restart karakter Anda agar berfungsi maksimal.")
```

---

## 🎨 Sistem Tema & Kustomisasi (Theme Engine)

AbsoluteUI memiliki mesin tema dinamis yang memantau dan mengubah warna seluruh komponen antarmuka saat *runtime*.

### Mengubah Tema Secara Runtime
```lua
-- Mengubah ke tema bawaan:
AbsoluteUI:SetTheme("AMOLED")
AbsoluteUI:SetTheme("RGB") -- Mengaktifkan efek Rainbow Chroma dinamis

-- Mengambil informasi tema saat ini:
local name, themeData = AbsoluteUI:GetTheme()
print("Tema aktif:", name)
```

### 📋 Daftar 20 Tema Bawaan
| Nama Tema | Nuansa Utama | Nama Tema | Nuansa Utama |
| :--- | :--- | :--- | :--- |
| **`Default`** | Dark Gray & Electric Blue (`#2980ff`) | **`Deep Ocean`** | Navy Blue & Cyan Water (`#00b4eb`) |
| **`AMOLED`** | Pure Black (`#000000`) & White | **`Orange`** | Dark Warm & Sunset Orange (`#ff8c1e`) |
| **`Ash Gray`** | Industrial Gray & Slate | **`Charcoal`** | Deep Carbon & Metallic |
| **`Blood Red`** | Dark Crimson & Red Velvet (`#b40a14`) | **`Pearl White`** | Light Mode, Clean Silver & Blue (`#3ca0ff`) |
| **`Cyanic`** | Deep Teal & Aquamarine (`#39c5bb`) | **`Midnight Blue`** | Dark Sapphire & Indigo (`#6450c8`) |
| **`Amber Glow`** | Obsidian Brown & Golden Amber (`#ffaa28`)| **`Galaxy Purple`**| Deep Space & Electric Purple (`#a03cdc`) |
| **`Deep Violet`** | Royal Violet & Lavender (`#a078dc`) | **`Cosmic Violet`** | Soft Lavender & Pastel Violet |
| **`Neon Cyber`** | Matrix Green & Cyber Lime (`#39ff14`) | **`Cotton Candy`** | Pastel Pink & Sweet Magenta (`#ff82be`) |
| **`Neon Purple`** | Cyberpunk Magenta & Ultraviolet (`#b400ff`)| **`Arctic Frost`** | Frosty Blue & Ice White (`#4696e1`) |
| **`Royal Blue`** | Classic Royal Blue & Sky (`#3278e6`) | **`RGB`** | **[ANIMATED]** Rainbow Chroma Effect |

### Membuat Tema Kustom Anda Sendiri
Anda dapat mendaftarkan tema baru dengan kombinasi warna sesuka hati:

```lua
AbsoluteUI:RegisterTheme("MatrixGold", {
    MainBackground = Color3.fromRGB(15, 12, 5),
    LightGrayTrans = Color3.fromRGB(35, 28, 12),
    Element = Color3.fromRGB(22, 18, 8),
    Input = Color3.fromRGB(30, 25, 10),
    Control = Color3.fromRGB(40, 33, 14),
    MainBorder = Color3.fromRGB(80, 65, 25),
    Accent = Color3.fromRGB(255, 215, 0),        -- Warna utama / highlight (Emas)
    TextPrimary = Color3.fromRGB(255, 245, 220), -- Teks utama
    TextSecondary = Color3.fromRGB(180, 160, 120) -- Teks sekunder
})

AbsoluteUI:SetTheme("MatrixGold")
```

---

## 🧩 IconService / IconFinder

AbsoluteUI terintegrasi secara modular dengan sumber ikon dari **Lucide**, **Gravity**, **Solar**, dan **SFSymbols**.  
Anda cukup menulis prefix dan nama ikon saat membuat tab atau tag:

```lua
-- Contoh panggilan ikon dari berbagai platform:
Window:CreateTab("Beranda", "lucide/home")
Window:CreateTab("Pertarungan", "solar/swords-bold")
Window:CreateTab("Alat", "gravity/wrench")
Window:CreateTab("Pengaturan", "sf/gearshape.fill")

-- Membuka eksplorasi IconFinder secara live di dalam game:
AbsoluteUI:OpenIconFinder()
```

---

## 🛠️ Perbaikan Khusus (Changelog v1.0.1-Fixed)

1. **Bugfix Dragging pada MiniWidget & MainFrame:**  
   Pada versi sebelumnya, ketika tombol `-` ditekan, *widget* bulatan kecil terkadang sulit diseret atau langsung terbuka ketika jari/mouse digeser pada perangkat Mobile. Kini telah diimplementasikan `dragThreshold = 5` pixels dan logika *event forwarding* dari tombol transparan ke `makeDraggable`. Hasilnya: seretan (*drag*) 100% mulus di PC dan Mobile tanpa memicu klik buka yang tidak disengaja!
2. **Kestabilan ZIndex & CoreGui Injection:**  
   UI secara otomatis mencoba menginjeksi ke `game:GetService("CoreGui")` agar terlindung dari deteksi game biasa, dan otomatis bersandar ke `LocalPlayer.PlayerGui` jika dijalankan di lingkungan standar/Studio.
3. **Penyempurnaan Theme Engine:**  
   Penambahan `AbsoluteUIIgnoreTheme` pada Tag khusus dan penanganan `Lerp` pada warna kontrol agar transisi tema berlangsung super halus.

---

## 📄 Lisensi & Kontributor

Dibuat dengan ❤️ oleh **AbsoluteUI Developer Team (`Made Absolute / NexzanHub`)**.  
Pustaka ini didistribusikan di bawah lisensi terbuka untuk komunitas pengembang Roblox.

> **Tips Eksekusi:** Selalu pastikan executor Anda mendukung `loadstring` dan `game:HttpGet` standar Roblox. Untuk penggunaan di Roblox Studio lokal, Anda dapat menyalin isi file `AbsoluteUI_Fixed.lua` ke dalam `ModuleScript`.
