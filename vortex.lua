--[[
    Vortex Hub // Region of Violence (VD) - Complete Edition with Fixed Keybinds Display
    Author: TWKS
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local AnalyticsService = game:GetService("RbxAnalyticsService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local HWID = "UNKNOWN-PC"
pcall(function() HWID = AnalyticsService:GetClientId() end)

local function GetNetworkTime()
    local success, result = pcall(function()
        local response = game:HttpGet("http://worldtimeapi.org/api/timezone/Etc/UTC")
        local data = HttpService:JSONDecode(response)
        return data.unixtime
    end)
    if success and result then return result else return os.time() end
end

local ValidKeys = {
    ["VORTEX-1D-01A9"] = { Duration = 86400, BoundHWID = nil },
    ["VORTEX-1D-02B4"] = { Duration = 86400, BoundHWID = nil },
    ["VORTEX-1D-03C7"] = { Duration = 86400, BoundHWID = nil },
    ["VORTEX-1D-04D2"] = { Duration = 86400, BoundHWID = nil },
    ["VORTEX-1D-05E8"] = { Duration = 86400, BoundHWID = nil },
    ["VORTEX-1D-06F1"] = { Duration = 86400, BoundHWID = nil },
    ["VORTEX-1D-07G5"] = { Duration = 86400, BoundHWID = nil },
    ["VORTEX-1D-08H9"] = { Duration = 86400, BoundHWID = nil },
    ["VORTEX-1D-09J3"] = { Duration = 86400, BoundHWID = nil },
    ["VORTEX-1D-10K6"] = { Duration = 86400, BoundHWID = nil },
    ["VORTEX-30D-A101"] = { Duration = 2592000, BoundHWID = nil },
    ["VORTEX-30D-B202"] = { Duration = 2592000, BoundHWID = nil },
    ["VORTEX-30D-C303"] = { Duration = 2592000, BoundHWID = nil },
    ["VORTEX-30D-D404"] = { Duration = 2592000, BoundHWID = nil },
    ["VORTEX-30D-E505"] = { Duration = 2592000, BoundHWID = nil },
    ["VORTEX-30D-F606"] = { Duration = 2592000, BoundHWID = nil },
    ["VORTEX-30D-G707"] = { Duration = 2592000, BoundHWID = nil },
    ["VORTEX-30D-H808"] = { Duration = 2592000, BoundHWID = nil },
    ["VORTEX-30D-J909"] = { Duration = 2592000, BoundHWID = nil },
    ["VORTEX-30D-K010"] = { Duration = 2592000, BoundHWID = nil },
    ["admin2013"] = { Duration = 999999999, BoundHWID = nil }
}

local PresetThemes = {
    White = Color3.fromRGB(255, 255, 255),
    Purple = Color3.fromRGB(170, 0, 255),
    Cyan = Color3.fromRGB(0, 225, 255),
    Green = Color3.fromRGB(0, 255, 120),
    Red = Color3.fromRGB(255, 50, 50),
    Orange = Color3.fromRGB(255, 150, 0),
    Pink = Color3.fromRGB(255, 100, 200)
}
local AccentColor = PresetThemes.White

local BgDark = Color3.fromRGB(15, 15, 18)
local SidebarDark = Color3.fromRGB(22, 22, 26)
local CardDark = Color3.fromRGB(28, 28, 34)
local TextMain = Color3.fromRGB(255, 255, 255)
local TextMuted = Color3.fromRGB(160, 160, 170)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VortexHubComplete"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- LOADING SCREEN
local LoadingFrame = Instance.new("Frame", ScreenGui)
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = BgDark
LoadingFrame.BorderSizePixel = 0
LoadingFrame.ZIndex = 1000

local LoadingBox = Instance.new("Frame", LoadingFrame)
LoadingBox.Size = UDim2.new(0, 460, 0, 190)
LoadingBox.Position = UDim2.new(0.5, -230, 0.5, -95)
LoadingBox.BackgroundColor3 = SidebarDark
LoadingBox.BorderSizePixel = 0
Instance.new("UICorner", LoadingBox).CornerRadius = UDim.new(0, 10)

local BoxGlow = Instance.new("UIStroke", LoadingBox)
BoxGlow.Color = AccentColor
BoxGlow.Thickness = 1.2
BoxGlow.Transparency = 0.5

local LoadingTitle = Instance.new("TextLabel", LoadingBox)
LoadingTitle.Size = UDim2.new(1, 0, 0, 30)
LoadingTitle.Position = UDim2.new(0, 0, 0, 28)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Font = Enum.Font.GothamBold
LoadingTitle.Text = "VORTEX ENGINE // COMPLETE"
LoadingTitle.TextColor3 = AccentColor
LoadingTitle.TextSize = 14

local LoadingSub = Instance.new("TextLabel", LoadingBox)
LoadingSub.Size = UDim2.new(1, 0, 0, 20)
LoadingSub.Position = UDim2.new(0, 0, 0, 58)
LoadingSub.BackgroundTransparency = 1
LoadingSub.Font = Enum.Font.Code
LoadingSub.Text = "INITIALIZING ALL FEATURES..."
LoadingSub.TextColor3 = TextMuted
LoadingSub.TextSize = 10

local BarBg = Instance.new("Frame", LoadingBox)
BarBg.Size = UDim2.new(0, 380, 0, 4)
BarBg.Position = UDim2.new(0.5, -190, 0.78, 0)
BarBg.BackgroundColor3 = CardDark
BarBg.BorderSizePixel = 0
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

local BarFill = Instance.new("Frame", BarBg)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = AccentColor
BarFill.BorderSizePixel = 0
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

TweenService:Create(BarFill, TweenInfo.new(1.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
task.wait(1.3)
LoadingFrame:Destroy()

-- KEY AUTHENTICATION WINDOW
local KeyAuthGranted = false
local KeyGui = Instance.new("Frame", ScreenGui)
KeyGui.Size = UDim2.new(0, 420, 0, 250)
KeyGui.Position = UDim2.new(0.5, -210, 0.5, -125)
KeyGui.BackgroundColor3 = SidebarDark
KeyGui.BorderSizePixel = 0
KeyGui.ZIndex = 500
Instance.new("UICorner", KeyGui).CornerRadius = UDim.new(0, 10)

local KeyGlow = Instance.new("UIStroke", KeyGui)
KeyGlow.Color = AccentColor
KeyGlow.Thickness = 1.2
KeyGlow.Transparency = 0.5

local KeyTitle = Instance.new("TextLabel", KeyGui)
KeyTitle.Size = UDim2.new(1, 0, 0, 35)
KeyTitle.Position = UDim2.new(0, 0, 0, 20)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Text = "VORTEX LICENSE SYSTEM"
KeyTitle.TextColor3 = AccentColor
KeyTitle.TextSize = 15

local KeySub = Instance.new("TextLabel", KeyGui)
KeySub.Size = UDim2.new(1, 0, 0, 20)
KeySub.Position = UDim2.new(0, 0, 0, 52)
KeySub.BackgroundTransparency = 1
KeySub.Font = Enum.Font.Gotham
KeySub.Text = "Hardware-locked security active on this PC"
KeySub.TextColor3 = TextMuted
KeySub.TextSize = 10

local KeyBox = Instance.new("TextBox", KeyGui)
KeyBox.Size = UDim2.new(0, 360, 0, 40)
KeyBox.Position = UDim2.new(0.5, -180, 0, 90)
KeyBox.BackgroundColor3 = CardDark
KeyBox.BorderSizePixel = 0
KeyBox.PlaceholderText = "Paste your license key here..."
KeyBox.Text = ""
KeyBox.TextColor3 = TextMain
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 12
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 6)

local SubmitBtn = Instance.new("TextButton", KeyGui)
SubmitBtn.Size = UDim2.new(0, 360, 0, 40)
SubmitBtn.Position = UDim2.new(0.5, -180, 0, 142)
SubmitBtn.BackgroundColor3 = AccentColor
SubmitBtn.BorderSizePixel = 0
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.Text = "VERIFY & LAUNCH"
SubmitBtn.TextColor3 = Color3.fromRGB(15, 15, 18)
SubmitBtn.TextSize = 12
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 6)

local KeyStatus = Instance.new("TextLabel", KeyGui)
KeyStatus.Size = UDim2.new(1, 0, 0, 20)
KeyStatus.Position = UDim2.new(0, 0, 0, 195)
KeyStatus.BackgroundTransparency = 1
KeyStatus.Font = Enum.Font.Gotham
KeyStatus.Text = "Status: Waiting for license input..."
KeyStatus.TextColor3 = TextMuted
KeyStatus.TextSize = 10

SubmitBtn.MouseButton1Click:Connect(function()
    local inputKey = string.gsub(KeyBox.Text, "%s+", "")
    local keyData = ValidKeys[inputKey]
    
    if keyData then
        local currentNetworkTime = GetNetworkTime()
        if keyData.BoundHWID == nil then
            keyData.BoundHWID = HWID
            keyData.ExpiresAt = currentNetworkTime + keyData.Duration
        end
        if keyData.BoundHWID ~= HWID then
            KeyStatus.TextColor3 = Color3.fromRGB(255, 60, 60)
            KeyStatus.Text = "ACCESS DENIED: KEY BOUND TO ANOTHER PC"
            return
        end
        if currentNetworkTime > keyData.ExpiresAt then
            KeyStatus.TextColor3 = Color3.fromRGB(255, 60, 60)
            KeyStatus.Text = "ACCESS DENIED: LICENSE EXPIRED"
            return
        end

        KeyAuthGranted = true
        KeyStatus.TextColor3 = Color3.fromRGB(0, 255, 120)
        KeyStatus.Text = "AUTHENTICATION SUCCESSFUL!"
        task.wait(0.4)
        KeyGui:Destroy()
    else
        KeyStatus.TextColor3 = Color3.fromRGB(255, 60, 60)
        KeyStatus.Text = "ACCESS DENIED: INVALID LICENSE KEY"
    end
end)

repeat task.wait(0.1) until KeyAuthGranted == true

-- Config
local Config = {
    AutoSkillCheck = true,
    NoClip = false,
    GodRevolver = false,
    SpeedHack = false,
    SpeedValue = 16,
    FastRepair = false,
    KillerAimbot = false,
    AutoStunDagger = false,
    FakeDagger = false,
    Flowstate = false,
    InfiniteFlashlight = false,

    FullBright = false,
    NoFog = false,
    CustomTime = false,
    TimeOfDay = 14,
    CustomFOVEnabled = false,
    FOVValue = 90,
    PlayerESP = false,
    KillerESP = false,
    PalletESP = false,
    GeneratorESP = false,
    TracersPlayers = false,
    TracersKiller = false,
    TriangleRingEnabled = false,
    RingSize = 15,
    RingColor = AccentColor,
    VisualSpin = false,
    SpinSpeed = 50,
    Crosshair = false,
    KillerESPColor = Color3.fromRGB(255, 255, 255),
    PalletESPColor = Color3.fromRGB(200, 200, 200)
}

local Cache = { Generators = {}, Pallets = {}, ClosestKiller = nil, KillersList = {}, PlayersList = {} }
local ActiveBindsUI = {}

local function TriggerFakeDagger()
    if not LocalPlayer.Character then return end
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if not tool then
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, t in pairs(backpack:GetChildren()) do
                if t:IsA("Tool") and (string.find(string.lower(t.Name), "dagger") or string.find(string.lower(t.Name), "knife")) then
                    tool = t
                    break
                end
            end
        end
    end
    if tool then
        if tool.Parent ~= LocalPlayer.Character then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):EquipTool(tool)
        end
        pcall(function() tool:Activate() end)
    end
end

local function ProcessFlowstate()
    if not Config.Flowstate then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (string.find(string.lower(obj.Name), "window") or string.find(string.lower(obj.Name), "glass")) then
            local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                local dist = (part.Position - char.HumanoidRootPart.Position).Magnitude
                if dist <= 8 then
                    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (char.HumanoidRootPart.CFrame.LookVector * 4)
                end
            end
        end
    end
end

local function ProcessInfiniteFlashlight()
    if not Config.InfiniteFlashlight then return end
    local char = LocalPlayer.Character
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and string.find(string.lower(item.Name), "flashlight") then
                local battery = item:FindFirstChild("Battery") or item:FindFirstChild("Charge") or item:FindFirstChild("Energy")
                if battery then battery.Value = 100 end
            end
        end
    end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, item in ipairs(bp:GetChildren()) do
            if item:IsA("Tool") and string.find(string.lower(item.Name), "flashlight") then
                local battery = item:FindFirstChild("Battery") or item:FindFirstChild("Charge") or item:FindFirstChild("Energy")
                if battery then battery.Value = 100 end
            end
        end
    end
end

-- Watermark
local Watermark = Instance.new("TextButton", ScreenGui)
Watermark.Name = "Watermark"
Watermark.Size = UDim2.new(0, 160, 0, 26)
Watermark.Position = UDim2.new(0.02, 0, 0.02, 0)
Watermark.BackgroundColor3 = SidebarDark
Watermark.BorderSizePixel = 0
Watermark.Font = Enum.Font.GothamBold
Watermark.Text = "  vortex.cc  |  60 FPS"
Watermark.TextColor3 = AccentColor
Watermark.TextSize = 11
Watermark.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Watermark).CornerRadius = UDim.new(0, 4)

local WmStroke = Instance.new("UIStroke", Watermark)
WmStroke.Color = AccentColor
WmStroke.Thickness = 1
WmStroke.Transparency = 0.5

local dragging, dragStart, startPos
Watermark.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = Watermark.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Watermark.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local fpsCount, lastUpdate = 0, tick()
RunService.RenderStepped:Connect(function()
    fpsCount = fpsCount + 1
    if tick() - lastUpdate >= 1 then
        Watermark.Text = "  vortex.cc  |  " .. tostring(fpsCount) .. " FPS"
        fpsCount = 0 lastUpdate = tick()
    end
end)

-- Main Interface Framework
local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Name = "MainMenu"
MainMenu.Size = UDim2.new(0, 680, 0, 420)
MainMenu.Position = UDim2.new(0.5, -340, 0.5, -210)
MainMenu.BackgroundColor3 = BgDark
MainMenu.BorderSizePixel = 0
MainMenu.Visible = false

Instance.new("UICorner", MainMenu).CornerRadius = UDim.new(0, 8)
local MenuStroke = Instance.new("UIStroke", MainMenu)
MenuStroke.Color = Color3.fromRGB(50, 50, 60) MenuStroke.Thickness = 1

Watermark.MouseButton1Click:Connect(function() MainMenu.Visible = not MainMenu.Visible end)

local Sidebar = Instance.new("Frame", MainMenu)
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = SidebarDark
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, -20, 0, 40)
Logo.Position = UDim2.new(0, 15, 0, 12)
Logo.BackgroundTransparency = 1
Logo.Font = Enum.Font.GothamBold
Logo.Text = "• vortex.cc"
Logo.TextColor3 = AccentColor
Logo.TextSize = 14
Logo.TextXAlignment = Enum.TextXAlignment.Left

local TabContainer = Instance.new("Frame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -120)
TabContainer.Position = UDim2.new(0, 0, 0, 60)
TabContainer.BackgroundTransparency = 1

local TabListLayout = Instance.new("UIListLayout", TabContainer)
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 4)

local UserProfile = Instance.new("Frame", Sidebar)
UserProfile.Size = UDim2.new(1, -16, 0, 45)
UserProfile.Position = UDim2.new(0, 8, 1, -55)
UserProfile.BackgroundColor3 = CardDark
UserProfile.BorderSizePixel = 0
Instance.new("UICorner", UserProfile).CornerRadius = UDim.new(0, 6)

local UserAvatar = Instance.new("ImageLabel", UserProfile)
UserAvatar.Size = UDim2.new(0, 30, 0, 30)
UserAvatar.Position = UDim2.new(0, 8, 0.5, -15)
UserAvatar.BackgroundColor3 = SidebarDark
pcall(function() UserAvatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)
Instance.new("UICorner", UserAvatar).CornerRadius = UDim.new(1, 0)

local UserName = Instance.new("TextLabel", UserProfile)
UserName.Size = UDim2.new(1, -50, 0, 16)
UserName.Position = UDim2.new(0, 44, 0, 7)
UserName.BackgroundTransparency = 1
UserName.Font = Enum.Font.GothamBold
UserName.Text = LocalPlayer.Name
UserName.TextColor3 = TextMain
UserName.TextSize = 11
UserName.TextXAlignment = Enum.TextXAlignment.Left

local UserRole = Instance.new("TextLabel", UserProfile)
UserRole.Size = UDim2.new(1, -50, 0, 14)
UserRole.Position = UDim2.new(0, 44, 0, 22)
UserRole.BackgroundTransparency = 1
UserRole.Font = Enum.Font.Gotham
UserRole.Text = "VIP Member"
UserRole.TextColor3 = TextMuted
UserRole.TextSize = 9
UserRole.TextXAlignment = Enum.TextXAlignment.Left

local Header = Instance.new("Frame", MainMenu)
Header.Size = UDim2.new(1, -160, 0, 50)
Header.Position = UDim2.new(0, 155, 0, 0)
Header.BackgroundTransparency = 1

local GreetingTitle = Instance.new("TextLabel", Header)
GreetingTitle.Size = UDim2.new(0, 250, 0, 20)
GreetingTitle.Position = UDim2.new(0, 10, 0, 12)
GreetingTitle.BackgroundTransparency = 1
GreetingTitle.Font = Enum.Font.GothamBold
GreetingTitle.Text = "Hello, " .. LocalPlayer.Name
GreetingTitle.TextColor3 = TextMain
GreetingTitle.TextSize = 14
GreetingTitle.TextXAlignment = Enum.TextXAlignment.Left

local GreetingSub = Instance.new("TextLabel", Header)
GreetingSub.Size = UDim2.new(0, 200, 0, 14)
GreetingSub.Position = UDim2.new(0, 10, 0, 32)
GreetingSub.BackgroundTransparency = 1
GreetingSub.Font = Enum.Font.Gotham
GreetingSub.Text = "Region of Violence Hub"
GreetingSub.TextColor3 = TextMuted
GreetingSub.TextSize = 10
GreetingSub.TextXAlignment = Enum.TextXAlignment.Left

local ContentArea = Instance.new("Frame", MainMenu)
ContentArea.Size = UDim2.new(1, -165, 1, -60)
ContentArea.Position = UDim2.new(0, 155, 0, 55)
ContentArea.BackgroundTransparency = 1

-- ОТОБРАЖАТЕЛЬ БИНДОВ НА ЭКРАНЕ
local KeybindsDisplay = Instance.new("Frame", ScreenGui)
KeybindsDisplay.Name = "VortexKeybindsList"
KeybindsDisplay.Size = UDim2.new(0, 160, 0, 150)
KeybindsDisplay.Position = UDim2.new(0.02, 0, 0.25, 0)
KeybindsDisplay.BackgroundColor3 = SidebarDark
KeybindsDisplay.BorderSizePixel = 0
KeybindsDisplay.Visible = false
Instance.new("UICorner", KeybindsDisplay).CornerRadius = UDim.new(0, 6)

local KbStroke = Instance.new("UIStroke", KeybindsDisplay)
KbStroke.Color = AccentColor
KbStroke.Thickness = 1
KbStroke.Transparency = 0.5

local KbHeader = Instance.new("TextLabel", KeybindsDisplay)
KbHeader.Size = UDim2.new(1, 0, 0, 25)
KbHeader.BackgroundTransparency = 1
KbHeader.Font = Enum.Font.GothamBold
KbHeader.Text = "  Keybinds"
KbHeader.TextColor3 = AccentColor
KbHeader.TextSize = 11
KbHeader.TextXAlignment = Enum.TextXAlignment.Left

local KbContainer = Instance.new("Frame", KeybindsDisplay)
KbContainer.Size = UDim2.new(1, 0, 1, -25)
KbContainer.Position = UDim2.new(0, 0, 0, 25)
KbContainer.BackgroundTransparency = 1
local KbLayout = Instance.new("UIListLayout", KbContainer)
KbLayout.SortOrder = Enum.SortOrder.LayoutOrder

local draggingKb, dragStartKb, startPosKb
KeybindsDisplay.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingKb = true dragStartKb = input.Position startPosKb = KeybindsDisplay.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingKb and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartKb
        KeybindsDisplay.Position = UDim2.new(startPosKb.X.Scale, startPosKb.X.Offset + delta.X, startPosKb.Y.Scale, startPosKb.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingKb = false end
end)

-- Обновление окошка биндов: отображает забиндженные функции приглушенным цветом (независимо от того, включены они или нет)
local function UpdateKeybindsUI(name, keyName, hasKey)
    local label = ActiveBindsUI[name]
    if hasKey and keyName ~= "" then
        if not label then
            label = Instance.new("TextLabel", KbContainer)
            label.Size = UDim2.new(1, 0, 0, 18)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.TextColor3 = TextMuted -- Сделали приглушенным неярким цветом
            label.TextSize = 10
            label.TextXAlignment = Enum.TextXAlignment.Left
            ActiveBindsUI[name] = label
        end
        label.Text = "  [ " .. keyName .. " ] " .. name
    else
        if label then
            label:Destroy()
            ActiveBindsUI[name] = nil
        end
    end
end

local ThemeObjects = {}
local function RegisterThemeObject(obj, prop)
    table.insert(ThemeObjects, {Object = obj, Property = prop}) obj[prop] = AccentColor
end

local ActiveTabButton = nil
local function ApplyTheme(newColor)
    AccentColor = newColor
    Config.RingColor = newColor
    BoxGlow.Color = newColor
    LoadingTitle.TextColor3 = newColor
    BarFill.BackgroundColor3 = newColor
    KeyGlow.Color = newColor
    KeyTitle.TextColor3 = newColor
    SubmitBtn.BackgroundColor3 = newColor
    SubmitBtn.TextColor3 = (newColor == Color3.fromRGB(255, 255, 255)) and Color3.fromRGB(15, 15, 18) or Color3.fromRGB(255, 255, 255)
    WmStroke.Color = newColor
    Watermark.TextColor3 = newColor
    Logo.TextColor3 = newColor
    KbStroke.Color = newColor
    KbHeader.TextColor3 = newColor
    if ActiveTabButton then
        ActiveTabButton.BackgroundColor3 = newColor
        ActiveTabButton.TextColor3 = (newColor == Color3.fromRGB(255, 255, 255)) and Color3.fromRGB(15, 15, 18) or TextMain
    end
    for _, item in ipairs(ThemeObjects) do
        if item.Object and item.Object.Parent then item.Object[item.Property] = newColor end
    end
end

local Tabs, Pages = {}, {}
local function CreateTab(name, layoutOrder)
    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(1, -16, 0, 32)
    TabBtn.Position = UDim2.new(0, 8, 0, 0)
    TabBtn.BackgroundColor3 = SidebarDark
    TabBtn.BorderSizePixel = 0
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.Text = "  " .. name
    TabBtn.TextColor3 = TextMuted
    TabBtn.TextSize = 11
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.LayoutOrder = layoutOrder
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local Page = Instance.new("Frame", ContentArea)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false

    local LeftColumn = Instance.new("ScrollingFrame", Page)
    LeftColumn.Name = "LeftColumn" LeftColumn.Size = UDim2.new(0.49, 0, 1, 0)
    LeftColumn.BackgroundTransparency = 1 LeftColumn.ScrollBarThickness = 0
    local LList = Instance.new("UIListLayout", LeftColumn) LList.Padding = UDim.new(0, 10) LList.SortOrder = Enum.SortOrder.LayoutOrder

    local RightColumn = Instance.new("ScrollingFrame", Page)
    RightColumn.Name = "RightColumn" RightColumn.Size = UDim2.new(0.49, 0, 1, 0)
    RightColumn.Position = UDim2.new(0.51, 0, 0, 0) RightColumn.BackgroundTransparency = 1 RightColumn.ScrollBarThickness = 0
    local RList = Instance.new("UIListLayout", RightColumn) RList.Padding = UDim.new(0, 10) RList.SortOrder = Enum.SortOrder.LayoutOrder

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(Tabs) do b.TextColor3 = TextMuted b.BackgroundColor3 = SidebarDark end
        TabBtn.TextColor3 = (AccentColor == Color3.fromRGB(255, 255, 255)) and Color3.fromRGB(15, 15, 18) or TextMain
        TabBtn.BackgroundColor3 = AccentColor
        ActiveTabButton = TabBtn
        Page.Visible = true
    end)

    table.insert(Tabs, TabBtn) table.insert(Pages, Page)
    return LeftColumn, RightColumn, TabBtn
end

local function CreateCard(parent, title)
    local Card = Instance.new("Frame", parent)
    Card.Size = UDim2.new(1, -5, 0, 30) Card.BackgroundColor3 = CardDark Card.BorderSizePixel = 0
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 6)
    local CardList = Instance.new("UIListLayout", Card) CardList.SortOrder = Enum.SortOrder.LayoutOrder CardList.Padding = UDim.new(0, 6)
    local Header = Instance.new("TextLabel", Card)
    Header.Size = UDim2.new(1, -20, 0, 25) Header.Position = UDim2.new(0, 10, 0, 0) Header.BackgroundTransparency = 1
    Header.Font = Enum.Font.GothamBold Header.Text = title Header.TextColor3 = TextMain Header.TextSize = 11 Header.TextXAlignment = Enum.TextXAlignment.Left
    local Padding = Instance.new("UIPadding", Card)
    Padding.PaddingTop = UDim.new(0, 10) Padding.PaddingBottom = UDim.new(0, 10) Padding.PaddingLeft = UDim.new(0, 10) Padding.PaddingRight = UDim.new(0, 10)
    CardList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Card.Size = UDim2.new(1, -5, 0, CardList.AbsoluteContentSize.Y + 20)
    end)
    return Card
end

-- СИСТЕМА TOGGLE С БИНДОМ ЧЕРЕЗ КЛИК КОЛЕСИКОМ МЫШИ (MouseButton3)
local function CreateToggle(card, text, default, callback)
    local Toggle = Instance.new("Frame", card) Toggle.Size = UDim2.new(1, 0, 0, 22) Toggle.BackgroundTransparency = 1
    
    local ClickZone = Instance.new("TextButton", Toggle)
    ClickZone.Size = UDim2.new(1, 0, 1, 0) ClickZone.BackgroundTransparency = 1 ClickZone.Text = "" ClickZone.ZIndex = 2

    local Label = Instance.new("TextLabel", Toggle)
    Label.Size = UDim2.new(0.65, 0, 1, 0) Label.BackgroundTransparency = 1 Label.Font = Enum.Font.Gotham
    Label.Text = text Label.TextColor3 = TextMuted Label.TextSize = 10 Label.TextXAlignment = Enum.TextXAlignment.Left

    local BindLabel = Instance.new("TextLabel", Toggle)
    BindLabel.Size = UDim2.new(0, 50, 1, 0) BindLabel.Position = UDim2.new(1, -70, 0, 0)
    BindLabel.BackgroundTransparency = 1 BindLabel.Font = Enum.Font.Gotham
    BindLabel.Text = "[None]" BindLabel.TextColor3 = TextMuted BindLabel.TextTransparency = 0.5
    BindLabel.TextSize = 10 BindLabel.TextXAlignment = Enum.TextXAlignment.Right

    local Switch = Instance.new("Frame", Toggle)
    Switch.Size = UDim2.new(0, 14, 0, 14) Switch.Position = UDim2.new(1, -14, 0.5, -7)
    Switch.BackgroundColor3 = default and AccentColor or Color3.fromRGB(45, 45, 55) Switch.BorderSizePixel = 0
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(0, 3)

    if default then RegisterThemeObject(Switch, "BackgroundColor3") end

    local state = default
    local assignedKey = nil
    local isBinding = false

    local function ApplyState(newState)
        if state == newState then return end
        state = newState
        Switch.BackgroundColor3 = state and AccentColor or Color3.fromRGB(45, 45, 55)
        if state then RegisterThemeObject(Switch, "BackgroundColor3") end
        callback(state)
    end

    ClickZone.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if not isBinding then
                ApplyState(not state)
            end
        elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
            isBinding = true
            BindLabel.Text = "[...]"
            
            local connection
            connection = UserInputService.InputBegan:Connect(function(keyInput)
                if keyInput.UserInputType == Enum.UserInputType.Keyboard then
                    local key = keyInput.KeyCode
                    if key == Enum.KeyCode.Backspace or key == Enum.KeyCode.Escape then
                        assignedKey = nil
                        BindLabel.Text = "[None]"
                        UpdateKeybindsUI(text, "", false)
                    else
                        assignedKey = key
                        BindLabel.Text = "[" .. key.Name .. "]"
                        UpdateKeybindsUI(text, key.Name, true)
                    end
                    isBinding = false
                    connection:Disconnect()
                end
            end)
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe or not assignedKey or isBinding then return end
        if input.KeyCode == assignedKey then
            ApplyState(not state)
        end
    end)
end

local function CreateSlider(card, text, min, max, default, callback)
    local Slider = Instance.new("Frame", card) Slider.Size = UDim2.new(1, 0, 0, 30) Slider.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel", Slider)
    Label.Size = UDim2.new(0.6, 0, 0, 14) Label.BackgroundTransparency = 1 Label.Font = Enum.Font.Gotham
    Label.Text = text Label.TextColor3 = TextMuted Label.TextSize = 10 Label.TextXAlignment = Enum.TextXAlignment.Left
    local ValLabel = Instance.new("TextLabel", Slider)
    ValLabel.Size = UDim2.new(0.4, 0, 0, 14) ValLabel.Position = UDim2.new(0.6, 0, 0, 0) ValLabel.BackgroundTransparency = 1
    ValLabel.Font = Enum.Font.GothamBold ValLabel.Text = tostring(default) ValLabel.TextColor3 = AccentColor ValLabel.TextSize = 10 ValLabel.TextXAlignment = Enum.TextXAlignment.Right
    RegisterThemeObject(ValLabel, "TextColor3")
    local SliderBg = Instance.new("Frame", Slider)
    SliderBg.Size = UDim2.new(1, 0, 0, 4) SliderBg.Position = UDim2.new(0, 0, 0, 20) SliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 55) SliderBg.BorderSizePixel = 0
    Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)
    local SliderFill = Instance.new("Frame", SliderBg)
    SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0) SliderFill.BackgroundColor3 = AccentColor SliderFill.BorderSizePixel = 0
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)
    RegisterThemeObject(SliderFill, "BackgroundColor3")
    local draggingSlider = false
    SliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSlider = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSlider = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + ((max - min) * pos))
            SliderFill.Size = UDim2.new(pos, 0, 1, 0) ValLabel.Text = tostring(value) callback(value)
        end
    end)
end

local function CreateButton(card, text, callback)
    local Btn = Instance.new("TextButton", card)
    Btn.Size = UDim2.new(1, 0, 0, 28) Btn.BackgroundColor3 = Color3.fromRGB(35, 40, 50) Btn.BorderSizePixel = 0
    Btn.Font = Enum.Font.GothamBold Btn.Text = text Btn.TextColor3 = TextMain Btn.TextSize = 10
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
    Btn.MouseButton1Click:Connect(callback)
end

local MainL, MainR, MainTabBtn = CreateTab("Main", 1)
local VisualsL, VisualsR, VisualsTabBtn = CreateTab("Visuals", 2)
local BindsL, BindsR, BindsTabBtn = CreateTab("Binds", 3)
local ThemesL, ThemesR, ThemesTabBtn = CreateTab("Themes", 4)

local SurvivorCard = CreateCard(MainL, "Survivor Side")
CreateToggle(SurvivorCard, "Auto Skill-Check (High Precision)", true, function(v) Config.AutoSkillCheck = v end)
CreateToggle(SurvivorCard, "Noclip", false, function(v) Config.NoClip = v end)
CreateToggle(SurvivorCard, "God Revolver", false, function(v) Config.GodRevolver = v end)
CreateToggle(SurvivorCard, "Speedhack", false, function(v) Config.SpeedHack = v end)
CreateSlider(SurvivorCard, "Speed Value", 16, 100, 16, function(v) Config.SpeedValue = v end)
CreateToggle(SurvivorCard, "Fast Repair / Interactions", false, function(v) Config.FastRepair = v end)
CreateToggle(SurvivorCard, "Flowstate (Fast Windows)", false, function(v) Config.Flowstate = v end)
CreateToggle(SurvivorCard, "Infinite Flashlight", false, function(v) Config.InfiniteFlashlight = v end)
CreateToggle(SurvivorCard, "Auto Dagger Counter Stun", false, function(v) Config.AutoStunDagger = v end)
CreateToggle(SurvivorCard, "Fake Dagger", false, function(v) Config.FakeDagger = v end)

local KillerCard = CreateCard(MainR, "Killer Side")
CreateToggle(KillerCard, "Killer Aimbot (Visible Only)", false, function(v) Config.KillerAimbot = v end)

local EnvironmentCard = CreateCard(VisualsL, "World Visuals")
CreateToggle(EnvironmentCard, "FullBright", false, function(v) Config.FullBright = v end)
CreateToggle(EnvironmentCard, "Remove Fog", false, function(v) Config.NoFog = v end)
CreateToggle(EnvironmentCard, "Custom Time Of Day", false, function(v) Config.CustomTime = v end)
CreateSlider(EnvironmentCard, "Clock Time", 0, 24, 14, function(v) Config.TimeOfDay = v end)
CreateToggle(EnvironmentCard, "Custom FOV", false, function(v) Config.CustomFOVEnabled = v end)
CreateSlider(EnvironmentCard, "FOV Value", 70, 120, 90, function(v) Config.FOVValue = v end)

local ESPCard = CreateCard(VisualsR, "ESP & Tracers")
CreateToggle(ESPCard, "Player ESP", false, function(v) Config.PlayerESP = v end)
CreateToggle(ESPCard, "Killer ESP", false, function(v) Config.KillerESP = v end)
CreateToggle(ESPCard, "White Tracers: Players", false, function(v) Config.TracersPlayers = v end)
CreateToggle(ESPCard, "White Tracers: Killer", false, function(v) Config.TracersKiller = v end)
CreateToggle(ESPCard, "Generator ESP", false, function(v) Config.GeneratorESP = v end)
CreateToggle(ESPCard, "Pallet ESP", false, function(v) Config.PalletESP = v end)
CreateToggle(ESPCard, "Feet Triangle Ring", false, function(v) Config.TriangleRingEnabled = v end)
CreateSlider(ESPCard, "Ring Size", 5, 40, 15, function(v) Config.RingSize = v end)
CreateToggle(ESPCard, "Visual Model Spin", false, function(v) Config.VisualSpin = v end)
CreateSlider(ESPCard, "Spin Speed", 10, 150, 50, function(v) Config.SpinSpeed = v end)
CreateToggle(ESPCard, "Custom Crosshair", false, function(v) Config.Crosshair = v end)

local BindMenuCard = CreateCard(BindsL, "Keybinds UI Display")
CreateToggle(BindMenuCard, "Show Keybinds List", false, function(v)
    KeybindsDisplay.Visible = v
end)

local ThemePresetCardL = CreateCard(ThemesL, "Presets Side A")
CreateButton(ThemePresetCardL, "Theme: Pure White (Default)", function() ApplyTheme(PresetThemes.White) end)
CreateButton(ThemePresetCardL, "Theme: Purple Neon", function() ApplyTheme(PresetThemes.Purple) end)
CreateButton(ThemePresetCardL, "Theme: Cyan Neon", function() ApplyTheme(PresetThemes.Cyan) end)

local ThemePresetCardR = CreateCard(ThemesR, "Presets Side B")
CreateButton(ThemePresetCardR, "Theme: Emerald Green", function() ApplyTheme(PresetThemes.Green) end)
CreateButton(ThemePresetCardR, "Theme: Crimson Red", function() ApplyTheme(PresetThemes.Red) end)
CreateButton(ThemePresetCardR, "Theme: Hot Pink", function() ApplyTheme(PresetThemes.Pink) end)

MainTabBtn.TextColor3 = Color3.fromRGB(15, 15, 18) MainTabBtn.BackgroundColor3 = AccentColor ActiveTabButton = MainTabBtn Pages[1].Visible = true

local RingFolder = Instance.new("Folder", Workspace) RingFolder.Name = "VortexTriangleRing"
local triangleParts = {}
local function updateTriangleRing(enabled, count, radius, color)
    if not enabled then RingFolder:ClearAllChildren() triangleParts = {} return end
    if #triangleParts ~= count then
        RingFolder:ClearAllChildren() triangleParts = {}
        for i = 1, count do
            local wedge = Instance.new("WedgePart") wedge.Name = "TriangleSegment" wedge.Size = Vector3.new(0.4, 0.4, 2)
            wedge.Anchored = true wedge.CanCollide = false wedge.Material = Enum.Material.Neon wedge.Transparency = 0.1 wedge.Parent = RingFolder
            table.insert(triangleParts, wedge)
        end
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPos = LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0, 2.5, 0)
        local angleStep = (math.pi * 2) / count
        for i, wedge in ipairs(triangleParts) do
            wedge.Color = color
            local theta = i * angleStep + (tick() * 3)
            local x = rootPos.X + math.cos(theta) * radius local z = rootPos.Z + math.sin(theta) * radius
            local targetPos = Vector3.new(x, rootPos.Y, z)
            wedge.CFrame = CFrame.new(targetPos, rootPos + Vector3.new(math.cos(theta + 0.1)*radius, 0, math.sin(theta + 0.1)*radius)) * CFrame.Angles(0, math.pi/2, 0)
        end
    end
end

local function HasDaggerEquipped()
    if not LocalPlayer.Character then return nil end
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool and (string.find(string.lower(tool.Name), "dagger") or string.find(string.lower(tool.Name), "knife")) then return tool end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, t in pairs(backpack:GetChildren()) do
            if t:IsA("Tool") and (string.find(string.lower(t.Name), "dagger") or string.find(string.lower(t.Name), "knife")) then return t end
        end
    end
    return nil
end

local function ListenToKillerAttacks(killerChar)
    local hum = killerChar:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum.AnimationPlayed:Connect(function(track)
        if Config.AutoStunDagger and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myPos = LocalPlayer.Character.HumanoidRootPart.Position
            local kPos = killerChar.HumanoidRootPart.Position
            if (myPos - kPos).Magnitude <= 12 then
                local dagger = HasDaggerEquipped()
                if dagger then
                    if dagger.Parent ~= LocalPlayer.Character then
                        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):EquipTool(dagger)
                    end
                    task.wait(0.05)
                    dagger:Activate()
                end
            end
        end
    end)
end

-- ИСПРАВЛЕННЫЕ РОВНЫЕ ТРАЙСЕРЫ
local TracersFolder = Instance.new("Folder", ScreenGui) 
TracersFolder.Name = "VortexTracers"
local tracerLines = {}

local function DrawWhiteTracer(targetPos, index)
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
    local line = tracerLines[index]
    
    if onScreen then
        if not line then
            line = Instance.new("Frame", TracersFolder)
            line.BorderSizePixel = 0
            line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            line.BackgroundTransparency = 0.2
            tracerLines[index] = line
        end
        line.Visible = true
        
        local startPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        local endPos = Vector2.new(screenPos.X, screenPos.Y)
        local distance = (endPos - startPos).Magnitude
        
        line.Size = UDim2.new(0, distance, 0, 1)
        line.Position = UDim2.new(0, startPos.X, 0, startPos.Y)
        line.Rotation = math.deg(math.atan2(endPos.Y - startPos.Y, endPos.X - startPos.X))
        line.AnchorPoint = Vector2.new(0, 0.5)
    else
        if line then line.Visible = false end
    end
end

local CrosshairGui = Instance.new("Frame", ScreenGui)
CrosshairGui.Name = "VortexCrosshair" CrosshairGui.Size = UDim2.new(0, 10, 0, 10) CrosshairGui.Position = UDim2.new(0.5, -5, 0.5, -5) CrosshairGui.BackgroundTransparency = 1 CrosshairGui.Visible = false
local c1 = Instance.new("Frame", CrosshairGui) c1.Size = UDim2.new(0, 4, 0, 2) c1.Position = UDim2.new(0, 3, 0, 4) c1.BackgroundColor3 = AccentColor c1.BorderSizePixel = 0 RegisterThemeObject(c1, "BackgroundColor3")
local c2 = Instance.new("Frame", CrosshairGui) c2.Size = UDim2.new(0, 2, 0, 4) c2.Position = UDim2.new(0, 4, 0, 3) c2.BackgroundColor3 = AccentColor c2.BorderSizePixel = 0 RegisterThemeObject(c2, "BackgroundColor3")

task.spawn(function()
    while task.wait(3) do
        local tempGens, tempPallets, tempKillers, tempPlayers = {}, {}, {}, {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local name = string.lower(obj.Name)
                if string.find(name, "generator") then table.insert(tempGens, obj)
                elseif string.find(name, "pallet") then table.insert(tempPallets, obj) end
            end
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local char = p.Character
                local isKiller = string.find(string.lower(p.Name), "killer") or char:FindFirstChild("Weapon") or char:FindFirstChild("Bat")
                if isKiller then table.insert(tempKillers, char) else table.insert(tempPlayers, char) end
            end
        end
        Cache.Generators, Cache.Pallets, Cache.KillersList, Cache.PlayersList = tempGens, tempPallets, tempKillers, tempPlayers
    end
end)

task.spawn(function()
    while task.wait(0.15) do
        local closest, shortest = nil, math.huge
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myPos = LocalPlayer.Character.HumanoidRootPart.Position
            for _, char in ipairs(Cache.KillersList) do
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    local dist = (root.Position - myPos).Magnitude
                    if dist < shortest then shortest = dist closest = root end
                end
            end
        end
        Cache.ClosestKiller = closest
    end
end)

local function ProcessSkillCheckFast()
    if not Config.AutoSkillCheck then return end
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not pGui then return end

    for _, screen in ipairs(pGui:GetChildren()) do
        if screen:IsA("ScreenGui") and screen.Enabled then
            local needle = screen:FindFirstChild("Needle", true) or screen:FindFirstChild("Pointer", true)
            local zone = screen:FindFirstChild("SuccessZone", true) or screen:FindFirstChild("GreatZone", true)
            
            if needle and zone and needle.Visible and zone.Visible then
                local needleRot = needle.Rotation % 360
                local zoneRot = zone.Rotation % 360
                local zoneWidth = zone.Size.X.Scale * 180
                
                if math.abs(needleRot - zoneRot) <= (zoneWidth + 2) then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    task.wait(0.01)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    task.wait(0.3)
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    ProcessSkillCheckFast()
    ProcessFlowstate()
    ProcessInfiniteFlashlight()

    if Config.FakeDagger then
        TriggerFakeDagger()
        Config.FakeDagger = false
    end

    if Config.SpeedHack and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = Config.SpeedValue end
    end
    if Config.GodRevolver and LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and (string.find(string.lower(tool.Name), "revolver") or string.find(string.lower(tool.Name), "gun")) then
            local ammo = tool:FindFirstChild("Ammo") if ammo then ammo.Value = 999 end
        end
    end
end)

local throttleTimer = 0
RunService.RenderStepped:Connect(function(dt)
    throttleTimer = throttleTimer + dt

    if Config.FullBright then Lighting.Brightness = 2 Lighting.ClockTime = 14 Lighting.GlobalShadows = false end
    if Config.NoFog then Lighting.FogEnd = 999999 Lighting.FogStart = 999999 end
    if Config.CustomTime then Lighting.ClockTime = Config.TimeOfDay end
    if Config.CustomFOVEnabled then Camera.FieldOfView = Config.FOVValue end

    if Config.TriangleRingEnabled then updateTriangleRing(true, 14, Config.RingSize, AccentColor) else updateTriangleRing(false, 0, 0, Color3.new()) end

    if Config.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
    end

    if Config.VisualSpin and LocalPlayer.Character then
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(dt * Config.SpinSpeed), 0) end
    end

    CrosshairGui.Visible = Config.Crosshair

    if Config.KillerAimbot and Cache.ClosestKiller then
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Cache.ClosestKiller.Position), 0.35)
    end

    local tracerIndex = 1
    if Config.TracersKiller then
        for _, char in ipairs(Cache.KillersList) do
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then DrawWhiteTracer(root.Position, tracerIndex) tracerIndex = tracerIndex + 1 end
        end
    end
    if Config.TracersPlayers then
        for _, char in ipairs(Cache.PlayersList) do
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then DrawWhiteTracer(root.Position, tracerIndex) tracerIndex = tracerIndex + 1 end
        end
    end
    for i = tracerIndex, #tracerLines do
        if tracerLines[i] then tracerLines[i].Visible = false end
    end

    if throttleTimer >= 0.15 then
        throttleTimer = 0

        for _, char in ipairs(Cache.KillersList) do
            local hl = char:FindFirstChild("VDHighlight")
            if Config.KillerESP then
                if not hl then hl = Instance.new("Highlight", char) hl.Name = "VDHighlight" end
                hl.Adornee = char hl.FillColor = Config.KillerESPColor hl.OutlineColor = Color3.fromRGB(255, 255, 255) hl.OutlineTransparency = 0.1 hl.FillTransparency = 0.35
            else
                if hl then hl:Destroy() end
            end
            ListenToKillerAttacks(char)
        end

        for _, char in ipairs(Cache.PlayersList) do
            local hl = char:FindFirstChild("VDHighlight")
            if Config.PlayerESP then
                if not hl then hl = Instance.new("Highlight", char) hl.Name = "VDHighlight" end
                hl.Adornee = char hl.FillColor = AccentColor hl.OutlineColor = AccentColor hl.OutlineTransparency = 1 hl.FillTransparency = 0.35
            else
                if hl then hl:Destroy() end
            end
        end

        if Config.GeneratorESP then
            for _, gen in ipairs(Cache.Generators) do
                if not gen:FindFirstChild("GenHL") then
                    local hl = Instance.new("Highlight", gen) hl.Name = "GenHL" hl.Adornee = gen
                    hl.FillColor = AccentColor hl.OutlineColor = Color3.fromRGB(255, 255, 255) hl.FillTransparency = 0.4
                end
            end
        else
            for _, gen in ipairs(Cache.Generators) do local hl = gen:FindFirstChild("GenHL") if hl then hl:Destroy() end end
        end

        if Config.PalletESP then
            for _, pal in ipairs(Cache.Pallets) do
                if not pal:FindFirstChild("PalletHL") then,
                    local hl = Instance.new("Highlight", pal) hl.Name = "PalletHL" hl.Adornee = pal
                    hl.FillColor = Config.PalletESPColor hl.OutlineColor = Color3.fromRGB(255, 255, 255) hl.FillTransparency = 0.4
                end
            end
        else
            for _, pal in ipairs(Cache.Pallets) do local hl = pal:FindFirstChild("PalletHL") if hl then hl:Destroy() end end
        end
    end
end)
