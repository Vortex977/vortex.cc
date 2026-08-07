--[[
    Vortex Hub // Region of Violence (VD) - Premium HWID & Cyberpunk Edition
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

-- Получение уникального HWID текущего ПК
local HWID = "UNKNOWN-PC"
pcall(function()
    HWID = AnalyticsService:GetClientId()
end)

-- Функция получения точного сетевого времени (защита от перемотки часов)
local function GetNetworkTime()
    local success, result = pcall(function()
        local response = game:HttpGet("http://worldtimeapi.org/api/timezone/Etc/UTC")
        local data = HttpService:JSONDecode(response)
        return data.unixtime
    end)
    if success and result then return result else return os.time() end
end

-- Полный список твоих ключей (с защитой HWID и привязкой по времени)
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

-- Preset Themes
local PresetThemes = {
    Purple = Color3.fromRGB(170, 0, 255),
    Cyan = Color3.fromRGB(0, 225, 255),
    Green = Color3.fromRGB(0, 255, 120),
    Red = Color3.fromRGB(255, 50, 50),
    Orange = Color3.fromRGB(255, 150, 0),
    Pink = Color3.fromRGB(255, 100, 200)
}
local AccentColor = PresetThemes.Purple

local BgDark = Color3.fromRGB(12, 13, 17)
local SidebarDark = Color3.fromRGB(17, 19, 24)
local CardDark = Color3.fromRGB(22, 24, 31)
local TextMain = Color3.fromRGB(240, 240, 245)
local TextMuted = Color3.fromRGB(110, 115, 125)

-- UI Parent Screen
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VortexHubUltra"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- 1. КРАСИВОЕ КИБЕРПАНКОВОЕ ОКНО ЗАГРУЗКИ
local LoadingFrame = Instance.new("Frame", ScreenGui)
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = BgDark
LoadingFrame.BorderSizePixel = 0
LoadingFrame.ZIndex = 1000

local LoadingBox = Instance.new("Frame", LoadingFrame)
LoadingBox.Size = UDim2.new(0, 440, 0, 180)
LoadingBox.Position = UDim2.new(0.5, -220, 0.5, -90)
LoadingBox.BackgroundColor3 = SidebarDark
LoadingBox.BorderSizePixel = 0
Instance.new("UICorner", LoadingBox).CornerRadius = UDim.new(0, 12)

local BoxStroke = Instance.new("UIStroke", LoadingBox)
BoxStroke.Color = AccentColor
BoxStroke.Thickness = 1.5
BoxStroke.Transparency = 0.2

local LoadingTitle = Instance.new("TextLabel", LoadingBox)
LoadingTitle.Size = UDim2.new(1, 0, 0, 30)
LoadingTitle.Position = UDim2.new(0, 0, 0, 25)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Font = Enum.Font.GothamBold
LoadingTitle.Text = "VORTEX ENGINE // SECURE LOADER"
LoadingTitle.TextColor3 = AccentColor
LoadingTitle.TextSize = 13

local LoadingSub = Instance.new("TextLabel", LoadingBox)
LoadingSub.Size = UDim2.new(1, 0, 0, 20)
LoadingSub.Position = UDim2.new(0, 0, 0, 55)
LoadingSub.BackgroundTransparency = 1
LoadingSub.Font = Enum.Font.Code
LoadingSub.Text = "INITIALIZING HARDWARE ENCRYPTION..."
LoadingSub.TextColor3 = TextMuted
LoadingSub.TextSize = 10

local BarBg = Instance.new("Frame", LoadingBox)
BarBg.Size = UDim2.new(0, 360, 0, 6)
BarBg.Position = UDim2.new(0.5, -180, 0.75, 0)
BarBg.BackgroundColor3 = CardDark
BarBg.BorderSizePixel = 0
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

local BarFill = Instance.new("Frame", BarBg)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = AccentColor
BarFill.BorderSizePixel = 0
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

TweenService:Create(BarFill, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
task.wait(1.6)
LoadingFrame:Destroy()

-- 2. СТИЛЬНОЕ ОКНО СИСТЕМЫ КЛЮЧЕЙ
local KeyAuthGranted = false
local KeyGui = Instance.new("Frame", ScreenGui)
KeyGui.Size = UDim2.new(0, 400, 0, 240)
KeyGui.Position = UDim2.new(0.5, -200, 0.5, -120)
KeyGui.BackgroundColor3 = SidebarDark
KeyGui.BorderSizePixel = 0
KeyGui.ZIndex = 500
Instance.new("UICorner", KeyGui).CornerRadius = UDim.new(0, 12)

local KeyStroke = Instance.new("UIStroke", KeyGui)
KeyStroke.Color = AccentColor
KeyStroke.Thickness = 1.5

local KeyTitle = Instance.new("TextLabel", KeyGui)
KeyTitle.Size = UDim2.new(1, 0, 0, 35)
KeyTitle.Position = UDim2.new(0, 0, 0, 18)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Text = "LICENSE VERIFICATION"
KeyTitle.TextColor3 = AccentColor
KeyTitle.TextSize = 14

local KeySub = Instance.new("TextLabel", KeyGui)
KeySub.Size = UDim2.new(1, 0, 0, 20)
KeySub.Position = UDim2.new(0, 0, 0, 48)
KeySub.BackgroundTransparency = 1
KeySub.Font = Enum.Font.Gotham
KeySub.Text = "Hardware-locked access protection active"
KeySub.TextColor3 = TextMuted
KeySub.TextSize = 10

local KeyBox = Instance.new("TextBox", KeyGui)
KeyBox.Size = UDim2.new(0, 340, 0, 42)
KeyBox.Position = UDim2.new(0.5, -170, 0, 85)
KeyBox.BackgroundColor3 = CardDark
KeyBox.BorderSizePixel = 0
KeyBox.PlaceholderText = "Paste your license key here..."
KeyBox.Text = ""
KeyBox.TextColor3 = TextMain
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 12
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

local SubmitBtn = Instance.new("TextButton", KeyGui)
SubmitBtn.Size = UDim2.new(0, 340, 0, 42)
SubmitBtn.Position = UDim2.new(0.5, -170, 0, 138)
SubmitBtn.BackgroundColor3 = AccentColor
SubmitBtn.BorderSizePixel = 0
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.Text = "VERIFY & LAUNCH"
SubmitBtn.TextColor3 = TextMain
SubmitBtn.TextSize = 12
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 8)

local KeyStatus = Instance.new("TextLabel", KeyGui)
KeyStatus.Size = UDim2.new(1, 0, 0, 20)
KeyStatus.Position = UDim2.new(0, 0, 0, 192)
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
        task.wait(0.6)
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
    KillerESPColor = Color3.fromRGB(255, 50, 50),
    PalletESPColor = Color3.fromRGB(255, 180, 0)
}

local Cache = { Generators = {}, Pallets = {}, ClosestKiller = nil, SafeDistance = 8.5 }

-- Watermark
local Watermark = Instance.new("TextButton", ScreenGui)
Watermark.Name = "Watermark"
Watermark.Size = UDim2.new(0, 160, 0, 28)
Watermark.Position = UDim2.new(0.02, 0, 0.02, 0)
Watermark.BackgroundColor3 = SidebarDark
Watermark.BorderSizePixel = 0
Watermark.Font = Enum.Font.GothamBold
Watermark.Text = "  vortex.cc  |  60 FPS"
Watermark.TextColor3 = AccentColor
Watermark.TextSize = 11
Watermark.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Watermark).CornerRadius = UDim.new(0, 6)

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
MenuStroke.Color = Color3.fromRGB(35, 38, 45) MenuStroke.Thickness = 1

Watermark.MouseButton1Click:Connect(function() MainMenu.Visible = not MainMenu.Visible end)

local Sidebar = Instance.new("Frame", MainMenu)
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = SidebarDark
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, -20, 0, 40)
Logo.Position = UDim2.new(0, 15, 0, 10)
Logo.BackgroundTransparency = 1
Logo.Font = Enum.Font.GothamBold
Logo.Text = "• vortex.cc 1.0"
Logo.TextColor3 = AccentColor
Logo.TextSize = 13
Logo.TextXAlignment = Enum.TextXAlignment.Left

local TabContainer = Instance.new("Frame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -120)
TabContainer.Position = UDim2.new(0, 0, 0, 55)
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
UserRole.Text = "Member"
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
GreetingSub.Position = UDim2.new(0, 10, 0, 30)
GreetingSub.BackgroundTransparency = 1
GreetingSub.Font = Enum.Font.Gotham
GreetingSub.Text = "Welcome Back!"
GreetingSub.TextColor3 = TextMuted
GreetingSub.TextSize = 10
GreetingSub.TextXAlignment = Enum.TextXAlignment.Left

local ContentArea = Instance.new("Frame", MainMenu)
ContentArea.Size = UDim2.new(1, -165, 1, -60)
ContentArea.Position = UDim2.new(0, 155, 0, 55)
ContentArea.BackgroundTransparency = 1

local ThemeObjects = {}
local function RegisterThemeObject(obj, prop)
    table.insert(ThemeObjects, {Object = obj, Property = prop}) obj[prop] = AccentColor
end

local ActiveTabButton = nil
local function ApplyTheme(newColor)
    AccentColor = newColor Config.RingColor = newColor BoxStroke.Color = newColor LoadingTitle.TextColor3 = newColor BarFill.BackgroundColor3 = newColor KeyStroke.Color = newColor KeyTitle.TextColor3 = newColor SubmitBtn.BackgroundColor3 = newColor WmStroke.Color = newColor Watermark.TextColor3 = newColor Logo.TextColor3 = newColor
    if ActiveTabButton then ActiveTabButton.BackgroundColor3 = newColor end
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
        TabBtn.TextColor3 = TextMain TabBtn.BackgroundColor3 = AccentColor ActiveTabButton = TabBtn Page.Visible = true
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

local function CreateToggle(card, text, default, callback)
    local Toggle = Instance.new("Frame", card) Toggle.Size = UDim2.new(1, 0, 0, 22) Toggle.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel", Toggle)
    Label.Size = UDim2.new(0.7, 0, 1, 0) Label.BackgroundTransparency = 1 Label.Font = Enum.Font.Gotham
    Label.Text = text Label.TextColor3 = TextMuted Label.TextSize = 10 Label.TextXAlignment = Enum.TextXAlignment.Left
    local Switch = Instance.new("TextButton", Toggle)
    Switch.Size = UDim2.new(0, 14, 0, 14) Switch.Position = UDim2.new(1, -14, 0.5, -7)
    Switch.BackgroundColor3 = default and AccentColor or Color3.fromRGB(40, 44, 52) Switch.BorderSizePixel = 0 Switch.Text = ""
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(0, 3)
    if default then RegisterThemeObject(Switch, "BackgroundColor3") end
    local state = default
    Switch.MouseButton1Click:Connect(function()
        state = not state
        Switch.BackgroundColor3 = state and AccentColor or Color3.fromRGB(40, 44, 52)
        if state then RegisterThemeObject(Switch, "BackgroundColor3") end
        callback(state)
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
    SliderBg.Size = UDim2.new(1, 0, 0, 4) SliderBg.Position = UDim2.new(0, 0, 0, 20) SliderBg.BackgroundColor3 = Color3.fromRGB(40, 44, 52) SliderBg.BorderSizePixel = 0
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
    Btn.Size = UDim2.new(1, 0, 0, 28) Btn.BackgroundColor3 = Color3.fromRGB(35, 38, 48) Btn.BorderSizePixel = 0
    Btn.Font = Enum.Font.GothamBold Btn.Text = text Btn.TextColor3 = TextMain Btn.TextSize = 10
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
    Btn.MouseButton1Click:Connect(callback)
end

local MainL, MainR, MainTabBtn = CreateTab("Main", 1)
local VisualsL, VisualsR, VisualsTabBtn = CreateTab("Visuals", 2)
local ThemesL, ThemesR, ThemesTabBtn = CreateTab("Themes", 3)

local SurvivorCard = CreateCard(MainL, "Survivor Side")
CreateToggle(SurvivorCard, "Auto Skill-Check (High Precision)", true, function(v) Config.AutoSkillCheck = v end)
CreateToggle(SurvivorCard, "Noclip", false, function(v) Config.NoClip = v end)
CreateToggle(SurvivorCard, "God Revolver", false, function(v) Config.GodRevolver = v end)
CreateToggle(SurvivorCard, "Speedhack", false, function(v) Config.SpeedHack = v end)
CreateSlider(SurvivorCard, "Speed Value", 16, 100, 16, function(v) Config.SpeedValue = v end)
CreateToggle(SurvivorCard, "Fast Repair / Interactions", false, function(v) Config.FastRepair = v end)
CreateToggle(SurvivorCard, "Auto Dagger Counter Stun", false, function(v) Config.AutoStunDagger = v end)

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

local ThemePresetCardL = CreateCard(ThemesL, "Presets Side A")
CreateButton(ThemePresetCardL, "Theme: Purple (Default)", function() ApplyTheme(PresetThemes.Purple) end)
CreateButton(ThemePresetCardL, "Theme: Cyan Neon", function() ApplyTheme(PresetThemes.Cyan) end)
CreateButton(ThemePresetCardL, "Theme: Emerald Green", function() ApplyTheme(PresetThemes.Green) end)

local ThemePresetCardR = CreateCard(ThemesR, "Presets Side B")
CreateButton(ThemePresetCardR, "Theme: Crimson Red", function() ApplyTheme(PresetThemes.Red) end)
CreateButton(ThemePresetCardR, "Theme: Sunset Orange", function() ApplyTheme(PresetThemes.Orange) end)
CreateButton(ThemePresetCardR, "Theme: Hot Pink", function() ApplyTheme(PresetThemes.Pink) end)

MainTabBtn.TextColor3 = TextMain MainTabBtn.BackgroundColor3 = AccentColor ActiveTabButton = MainTabBtn Pages[1].Visible = true

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

local function IsVisible(targetPart)
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("Head") then return false end
    local rayParams = RaycastParams.new()
    rayParams.FilterType = RaycastType.Exclude
    rayParams.FilterDescendantsInstances = {myChar, Camera}
    rayParams.IgnoreWater = true
    local result = Workspace:Raycast(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position, rayParams)
    if result then return result.Instance:IsDescendantOf(targetPart.Parent) end
    return true
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

local TracersFolder = Instance.new("Folder", ScreenGui) TracersFolder.Name = "VortexTracers"
local function DrawWhiteTracer(targetPos)
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
    if onScreen then
        local line = Instance.new("Frame", TracersFolder)
        line.BorderSizePixel = 0
        line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        local startPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        local endPos = Vector2.new(screenPos.X, screenPos.Y)
        local distance = (endPos - startPos).Magnitude
        line.Size = UDim2.new(0, distance, 0, 1)
        line.Position = UDim2.new(0, startPos.X, 0, startPos.Y)
        line.Rotation = math.deg(math.atan2(endPos.Y - startPos.Y, endPos.X - startPos.X))
        line.AnchorPoint = Vector2.new(0, 0.5)
    end
end

local CrosshairGui = Instance.new("Frame", ScreenGui)
CrosshairGui.Name = "VortexCrosshair" CrosshairGui.Size = UDim2.new(0, 10, 0, 10) CrosshairGui.Position = UDim2.new(0.5, -5, 0.5, -5) CrosshairGui.BackgroundTransparency = 1 CrosshairGui.Visible = false
local c1 = Instance.new("Frame", CrosshairGui) c1.Size = UDim2.new(0, 4, 0, 2) c1.Position = UDim2.new(0, 3, 0, 4) c1.BackgroundColor3 = AccentColor c1.BorderSizePixel = 0 RegisterThemeObject(c1, "BackgroundColor3")
local c2 = Instance.new("Frame", CrosshairGui) c2.Size = UDim2.new(0, 2, 0, 4) c2.Position = UDim2.new(0, 4, 0, 3) c2.BackgroundColor3 = AccentColor c2.BorderSizePixel = 0 RegisterThemeObject(c2, "BackgroundColor3")

task.spawn(function()
    while task.wait(4) do
        local tempGens, tempPallets = {}, {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local name = string.lower(obj.Name)
                if string.find(name, "generator") then table.insert(tempGens, obj)
                elseif string.find(name, "pallet") then table.insert(tempPallets, obj) end
            end
        end
        Cache.Generators, Cache.Pallets = tempGens, tempPallets
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        local closest, shortest = nil, math.huge
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myPos = LocalPlayer.Character.HumanoidRootPart.Position
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local char = p.Character
                    local isKiller = string.find(string.lower(p.Name), "killer") or char:FindFirstChild("Weapon") or char:FindFirstChild("Bat")
                    if isKiller then
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if root then
                            local dist = (root.Position - myPos).Magnitude
                            if dist < shortest then shortest = dist closest = root end
                        end
                    end
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

    TracersFolder:ClearAllChildren()

    if throttleTimer >= 0.15 then
        throttleTimer = 0
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local char = p.Character
                local isKiller = string.find(string.lower(p.Name), "killer") or char:FindFirstChild("Weapon") or char:FindFirstChild("Bat")
                
                local hl = char:FindFirstChild("VDHighlight")
                if (Config.KillerESP and isKiller) or (Config.PlayerESP and not isKiller) then
                    if not hl then hl = Instance.new("Highlight", char) hl.Name = "VDHighlight" end
                    hl.Adornee = char
                    if isKiller then
                        hl.FillColor = Config.KillerESPColor hl.OutlineColor = Color3.fromRGB(255, 255, 255) hl.OutlineTransparency = 0.1
                    else
                        hl.FillColor = AccentColor hl.OutlineColor = AccentColor hl.OutlineTransparency = 1
                    end
                    hl.FillTransparency = 0.35
                else
                    if hl then hl:Destroy() end
                end

                if isKiller and Config.TracersKiller then
                    DrawWhiteTracer(char.HumanoidRootPart.Position)
                    ListenToKillerAttacks(char)
                elseif (not isKiller) and Config.TracersPlayers then
                    DrawWhiteTracer(char.HumanoidRootPart.Position)
                end
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
                if not pal:FindFirstChild("PalletHL") then
                    local hl = Instance.new("Highlight", pal) hl.Name = "PalletHL" hl.Adornee = pal
                    hl.FillColor = Config.PalletESPColor hl.OutlineColor = Color3.fromRGB(255, 255, 255) hl.FillTransparency = 0.4
                end
            end
        else
            for _, pal in ipairs(Cache.Pallets) do local hl = pal:FindFirstChild("PalletHL") if hl then hl:Destroy() end end
        end
    end
end)
