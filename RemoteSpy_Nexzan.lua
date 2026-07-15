-- =============================================
--          REMOTE SPY - NEXZAN EDITION
--   Small, Beautiful, Mobile-Friendly UI
--   Draggable | Minimize | Spam | Copy Code
-- =============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ================== SETTINGS ==================
local UI_SIZE = UDim2.new(0, 260, 0, 320)  -- Kecil untuk HP
local ACCENT_COLOR = Color3.fromRGB(99, 102, 241) -- Indigo modern
local BG_COLOR = Color3.fromRGB(18, 18, 24)
local SECONDARY = Color3.fromRGB(28, 28, 36)
local TEXT_COLOR = Color3.fromRGB(240, 240, 250)
local TEXT_DARK = Color3.fromRGB(160, 160, 175)

-- ================== VARIABLES ==================
local RemotesLogged = {}
local IsLogging = true
local IsMinimized = false
local CurrentWindow

-- ================== UTILITIES ==================
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

local function GetFullPath(instance)
    local path = {}
    local current = instance
    while current and current ~= game do
        table.insert(path, 1, current.Name)
        current = current.Parent
    end
    return "game." .. table.concat(path, ".")
end

local function SafeArgsToString(args)
    local str = {}
    for i, arg in ipairs(args) do
        local t = typeof(arg)
        if t == "string" then
            table.insert(str, '"' .. arg:gsub('"', '\\"') .. '"')
        elseif t == "number" or t == "boolean" then
            table.insert(str, tostring(arg))
        elseif t == "Instance" then
            table.insert(str, GetFullPath(arg))
        elseif t == "Vector3" then
            table.insert(str, "Vector3.new(" .. tostring(arg) .. ")")
        elseif t == "CFrame" then
            table.insert(str, "CFrame.new(" .. tostring(arg) .. ")")
        else
            table.insert(str, tostring(arg))
        end
    end
    return table.concat(str, ", ")
end

local function CopyToClipboard(text)
    if setclipboard then
        setclipboard(text)
    elseif toclipboard then
        toclipboard(text)
    else
        -- Fallback: print to console
        print("[RemoteSpy] Copied to clipboard (fallback):", text)
    end
end

-- ================== HOOK REMOTES ==================
local function HookRemotes()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if IsLogging then
            if (method == "FireServer" and self:IsA("RemoteEvent")) or 
               (method == "InvokeServer" and self:IsA("RemoteFunction")) then
                
                local path = GetFullPath(self)
                local shortName = self.Name
                
                -- Store log
                local entry = {
                    Remote = self,
                    Name = shortName,
                    Path = path,
                    Method = method,
                    Args = args,
                    Time = os.date("%H:%M:%S"),
                    Count = 1
                }
                
                -- Check if already exists (update count)
                local found = false
                for i, log in ipairs(RemotesLogged) do
                    if log.Remote == self then
                        log.Args = args
                        log.Count = (log.Count or 1) + 1
                        log.Time = entry.Time
                        found = true
                        break
                    end
                end
                
                if not found then
                    table.insert(RemotesLogged, entry)
                end
                
                -- Refresh UI
                if CurrentWindow and CurrentWindow.RefreshList then
                    CurrentWindow.RefreshList()
                end
            end
        end
        
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
end

-- ================== UI CREATION ==================
local function CreateRemoteSpyUI()
    -- Destroy old if exists
    if CurrentWindow and CurrentWindow.ScreenGui then
        CurrentWindow.ScreenGui:Destroy()
    end

    local ScreenGui = Create("ScreenGui", {
        Name = "NexzanRemoteSpy",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })

    -- Main Frame (Small for HP)
    local Main = Create("Frame", {
        Name = "Main",
        Size = UI_SIZE,
        Position = UDim2.new(0.5, -130, 0.5, -160),
        BackgroundColor3 = BG_COLOR,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    local Corner = Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Main})
    local Stroke = Create("UIStroke", {
        Color = Color3.fromRGB(50, 50, 60),
        Thickness = 1.5,
        Transparency = 0.6,
        Parent = Main
    })

    -- Header
    local Header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = SECONDARY,
        BackgroundTransparency = 0.15,
        Parent = Main
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Header})
    
    -- Logo + Title
    local Title = Create("TextLabel", {
        Size = UDim2.new(0, 130, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "📡 Remote Spy",
        TextColor3 = TEXT_COLOR,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Parent = Header
    })
    
    -- Minimize Button
    local MinimizeBtn = Create("TextButton", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(1, -58, 0, 5),
        BackgroundColor3 = Color3.fromRGB(60, 60, 70),
        Text = "–",
        TextColor3 = TEXT_COLOR,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = Header
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = MinimizeBtn})

    -- Close Button
    local CloseBtn = Create("TextButton", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(1, -30, 0, 5),
        BackgroundColor3 = Color3.fromRGB(220, 60, 60),
        Text = "✕",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        Parent = Header
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = CloseBtn})

    -- Status Bar
    local StatusBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 24),
        Position = UDim2.new(0, 0, 0, 36),
        BackgroundColor3 = Color3.fromRGB(22, 22, 30),
        Parent = Main
    })
    
    local StatusLabel = Create("TextLabel", {
        Size = UDim2.new(0, 120, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = "Logging: ON  •  0 remotes",
        TextColor3 = Color3.fromRGB(100, 255, 120),
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Parent = StatusBar
    })
    
    local ClearBtn = Create("TextButton", {
        Size = UDim2.new(0, 52, 0, 18),
        Position = UDim2.new(1, -58, 0.5, -9),
        BackgroundColor3 = Color3.fromRGB(50, 50, 60),
        Text = "Clear",
        TextColor3 = TEXT_DARK,
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        Parent = StatusBar
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ClearBtn})

    -- List Container
    local ListFrame = Create("Frame", {
        Name = "ListFrame",
        Size = UDim2.new(1, -12, 1, -72),
        Position = UDim2.new(0, 6, 0, 62),
        BackgroundColor3 = Color3.fromRGB(22, 22, 30),
        BackgroundTransparency = 0.2,
        ClipsDescendants = true,
        Parent = Main
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ListFrame})

    local Scroll = Create("ScrollingFrame", {
        Name = "Scroll",
        Size = UDim2.new(1, -6, 1, -6),
        Position = UDim2.new(0, 3, 0, 3),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = ACCENT_COLOR,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = ListFrame
    })

    local Layout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = Scroll
    })

    -- Footer
    local Footer = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 22),
        Position = UDim2.new(0, 0, 1, -22),
        BackgroundColor3 = SECONDARY,
        BackgroundTransparency = 0.3,
        Parent = Main
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Footer})

    local ToggleLogBtn = Create("TextButton", {
        Size = UDim2.new(0, 70, 0, 16),
        Position = UDim2.new(0, 8, 0.5, -8),
        BackgroundColor3 = ACCENT_COLOR,
        Text = "Pause Log",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        Parent = Footer
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ToggleLogBtn})

    local InfoLabel = Create("TextLabel", {
        Size = UDim2.new(1, -90, 1, 0),
        Position = UDim2.new(0, 84, 0, 0),
        BackgroundTransparency = 1,
        Text = "Fire • Spam • Copy",
        TextColor3 = TEXT_DARK,
        TextSize = 9,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Parent = Footer
    })

    -- ================== DRAGGABLE ==================
    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- ================== FUNCTIONS ==================
    local function UpdateStatus()
        local count = #RemotesLogged
        StatusLabel.Text = string.format("Logging: %s  •  %d remotes", IsLogging and "ON" or "OFF", count)
        StatusLabel.TextColor3 = IsLogging and Color3.fromRGB(100, 255, 120) or Color3.fromRGB(255, 180, 100)
    end

    local function CreateRemoteRow(entry)
        local Row = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 42),
            BackgroundColor3 = Color3.fromRGB(32, 32, 42),
            BackgroundTransparency = 0.3,
            Parent = Scroll
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Row})

        -- Remote Name
        local NameLabel = Create("TextLabel", {
            Size = UDim2.new(1, -110, 0, 18),
            Position = UDim2.new(0, 8, 0, 3),
            BackgroundTransparency = 1,
            Text = entry.Name,
            TextColor3 = TEXT_COLOR,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = Row
        })

        -- Path
        local PathLabel = Create("TextLabel", {
            Size = UDim2.new(1, -110, 0, 14),
            Position = UDim2.new(0, 8, 0, 20),
            BackgroundTransparency = 1,
            Text = entry.Path:gsub("game%.", ""),
            TextColor3 = TEXT_DARK,
            TextSize = 9,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = Row
        })

        -- Count badge
        local CountBadge = Create("TextLabel", {
            Size = UDim2.new(0, 22, 0, 14),
            Position = UDim2.new(1, -30, 0, 4),
            BackgroundColor3 = ACCENT_COLOR,
            BackgroundTransparency = 0.3,
            Text = tostring(entry.Count),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 9,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = Row
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = CountBadge})

        -- Buttons
        local BtnContainer = Create("Frame", {
            Size = UDim2.new(0, 100, 1, 0),
            Position = UDim2.new(1, -106, 0, 0),
            BackgroundTransparency = 1,
            Parent = Row
        })

        -- Fire Button
        local FireBtn = Create("TextButton", {
            Size = UDim2.new(0, 30, 0, 22),
            Position = UDim2.new(0, 2, 0.5, -11),
            BackgroundColor3 = Color3.fromRGB(70, 140, 70),
            Text = "Fire",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 9,
            Font = Enum.Font.GothamBold,
            Parent = BtnContainer
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = FireBtn})

        -- Spam Button
        local SpamBtn = Create("TextButton", {
            Size = UDim2.new(0, 32, 0, 22),
            Position = UDim2.new(0, 35, 0.5, -11),
            BackgroundColor3 = Color3.fromRGB(200, 120, 40),
            Text = "Spam",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 9,
            Font = Enum.Font.GothamBold,
            Parent = BtnContainer
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = SpamBtn})

        -- Copy Button
        local CopyBtn = Create("TextButton", {
            Size = UDim2.new(0, 28, 0, 22),
            Position = UDim2.new(0, 70, 0.5, -11),
            BackgroundColor3 = Color3.fromRGB(60, 60, 80),
            Text = "📋",
            TextColor3 = TEXT_COLOR,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            Parent = BtnContainer
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = CopyBtn})

        -- Button Actions
        FireBtn.MouseButton1Click:Connect(function()
            if entry.Remote and entry.Remote.Parent then
                pcall(function()
                    if entry.Method == "FireServer" then
                        entry.Remote:FireServer(unpack(entry.Args))
                    else
                        entry.Remote:InvokeServer(unpack(entry.Args))
                    end
                end)
            end
        end)

        -- Spam Logic
        local isSpamming = false
        local spamConnection
        
        SpamBtn.MouseButton1Click:Connect(function()
            if not entry.Remote or not entry.Remote.Parent then return end
            
            isSpamming = not isSpamming
            
            if isSpamming then
                SpamBtn.Text = "Stop"
                SpamBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
                
                spamConnection = task.spawn(function()
                    while isSpamming and entry.Remote and entry.Remote.Parent do
                        pcall(function()
                            if entry.Method == "FireServer" then
                                entry.Remote:FireServer(unpack(entry.Args))
                            else
                                entry.Remote:InvokeServer(unpack(entry.Args))
                            end
                        end)
                        task.wait(0.08) -- Delay spam (adjustable)
                    end
                end)
            else
                SpamBtn.Text = "Spam"
                SpamBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 40)
                if spamConnection then
                    isSpamming = false
                end
            end
        end)

        CopyBtn.MouseButton1Click:Connect(function()
            local code = string.format(
                '%s:%s(%s)',
                entry.Path,
                entry.Method,
                SafeArgsToString(entry.Args)
            )
            CopyToClipboard(code)
            
            -- Visual feedback
            local oldText = CopyBtn.Text
            CopyBtn.Text = "✓"
            task.delay(0.8, function()
                if CopyBtn.Parent then CopyBtn.Text = oldText end
            end)
        end)

        return Row
    end

    -- Refresh List
    local function RefreshList()
        -- Clear existing
        for _, child in ipairs(Scroll:GetChildren()) do
            if child:IsA("Frame") and child.Name ~= "UIListLayout" then
                child:Destroy()
            end
        end

        for _, entry in ipairs(RemotesLogged) do
            CreateRemoteRow(entry)
        end

        -- Update canvas
        task.wait()
        Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
        UpdateStatus()
    end

    -- Clear List
    ClearBtn.MouseButton1Click:Connect(function()
        RemotesLogged = {}
        RefreshList()
    end)

    -- Toggle Logging
    ToggleLogBtn.MouseButton1Click:Connect(function()
        IsLogging = not IsLogging
        ToggleLogBtn.Text = IsLogging and "Pause Log" or "Resume Log"
        ToggleLogBtn.BackgroundColor3 = IsLogging and ACCENT_COLOR or Color3.fromRGB(160, 80, 80)
        UpdateStatus()
    end)

    -- Minimize
    MinimizeBtn.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        
        if IsMinimized then
            Tween(Main, {Size = UDim2.new(0, 260, 0, 36)}, 0.2)
            ListFrame.Visible = false
            StatusBar.Visible = false
            Footer.Visible = false
            MinimizeBtn.Text = "+"
        else
            Tween(Main, {Size = UI_SIZE}, 0.2)
            ListFrame.Visible = true
            StatusBar.Visible = true
            Footer.Visible = true
            MinimizeBtn.Text = "–"
        end
    end)

    -- Close
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.15)
        task.wait(0.2)
        ScreenGui:Destroy()
        CurrentWindow = nil
    end)

    -- Expose functions
    CurrentWindow = {
        ScreenGui = ScreenGui,
        Main = Main,
        RefreshList = RefreshList,
        UpdateStatus = UpdateStatus
    }

    -- Initial refresh
    RefreshList()
    
    return CurrentWindow
end

-- ================== START ==================
local function StartRemoteSpy()
    local Window = CreateRemoteSpyUI()
    
    -- Hook the remotes
    HookRemotes()
    
    -- Initial message
    task.spawn(function()
        task.wait(1.5)
        if Window and Window.Main then
            print("[RemoteSpy] Nexzan Remote Spy started. Fire any RemoteEvent/RemoteFunction to see it here.")
        end
    end)
    
    -- Auto refresh every 1.5s (in case of updates)
    task.spawn(function()
        while Window and Window.Main and Window.Main.Parent do
            if Window.RefreshList then
                Window.RefreshList()
            end
            task.wait(1.5)
        end
    end)
    
    return Window
end

-- Run
StartRemoteSpy()

-- Optional: Global access
getgenv().NexzanRemoteSpy = StartRemoteSpy

print("✅ Nexzan Remote Spy loaded successfully!")
print("   - Small UI for mobile")
print("   - Draggable + Minimize")
print("   - Spam + Fire + Copy Code")
print("   - Only shows fired remotes")
