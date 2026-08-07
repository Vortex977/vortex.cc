--[[
    Vortex Hub // Region of Violence (VD) - Ultimate Fixed Edition
    Author: TWKS
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

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

-- Безопасное создание интерфейса в PlayerGui
local oldGui = PlayerGui:FindFirstChild("VortexHubComplete")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VortexHubComplete"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

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
    WindowESP = false,
    TracersPlayers = false,
    TracersKiller = false,
    TriangleRingEnabled = false,
    RingSize = 15,
    RingColor = AccentColor,
    VisualSpin = false,
    SpinSpeed = 50,
    Crosshair = false,
    
    PortalTeleport = false,
    PortalKey = nil,
    
    KillerESPColor = Color3.fromRGB(180, 60, 60),
    PlayerESPColor = Color3.fromRGB(255, 255, 255),
    GeneratorESPColor = Color3.fromRGB(255, 255, 255),
    PalletESPColor = Color3.fromRGB(200, 200, 200),
    WindowESPColor = Color3.fromRGB(100, 200, 255)
}

local Cache = { Generators = {}, Pallets = {}, Windows = {}, ClosestKiller = nil, KillersList = {}, PlayersList = {} }
local ActiveBindsUI = {}

-- Watermark (Кнопка открытия меню)
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
MainMenu.Visible = true -- Сразу делаем видимым, чтобы не зависать

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

local UserName = Instance.new("TextLabel", UserProfile)
UserName.Size = UDim2.new(1, -12, 0, 16)
UserName.Position = UDim2.new(0, 8, 0, 7)
UserName.BackgroundTransparency = 1
UserName.Font = Enum.Font.GothamBold
UserName.Text = LocalPlayer.Name
UserName.TextColor3 = TextMain
UserName.TextSize = 11
UserName.TextXAlignment = Enum.TextXAlignment.Left

local UserRole = Instance.new("TextLabel", UserProfile)
UserRole.Size = UDim2.new(1, -12, 0, 14)
UserRole.Position = UDim2.new(0, 8, 0, 22)
UserRole.BackgroundTransparency = 1
UserRole.Font = Enum.Font.Gotham
UserRole.Text = "VIP Member"
UserRole.TextColor3 = TextMuted
UserRole.TextSize = 9
UserRole.TextXAlignment = Enum.TextXAlignment.Left

local ContentArea = Instance.new("Frame", MainMenu)
ContentArea.Size = UDim2.new(1, -165, 1, -15)
ContentArea.Position = UDim2.new(0, 155, 0, 10)
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

local function UpdateKeybindsUI(name, keyName, hasKey)
    local label = ActiveBindsUI[name]
    if hasKey and keyName ~= "" then
        if not label then
            label = Instance.new("TextLabel", KbContainer)
            label.Size = UDim2.new(1, 0, 0, 18)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.TextColor3 = Color3.fromRGB(130, 130, 140)
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
                        if text == "Portal Teleport" then Config.PortalKey = nil end
                    else
                        assignedKey = key
                        BindLabel.Text = "[" .. key.Name .. "]"
                        UpdateKeybindsUI(text, key.Name, true)
                        if text == "Portal Teleport" then Config.PortalKey = key end
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

local function CreateColorPicker(card, text, currentColor, callback)
    local CpFrame = Instance.new("Frame", card) CpFrame.Size = UDim2.new(1, 0, 0, 22) CpFrame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel", CpFrame)
    Label.Size = UDim2.new(0.7, 0, 1, 0) Label.BackgroundTransparency = 1 Label.Font = Enum.Font.Gotham
    Label.Text = text Label.TextColor3 = TextMuted Label.TextSize = 10 Label.TextXAlignment = Enum.TextXAlignment.Left

    local ColorBtn = Instance.new("TextButton", CpFrame)
    ColorBtn.Size = UDim2.new(0, 30, 0, 14) ColorBtn.Position = UDim2.new(1, -30, 0.5, -7)
    ColorBtn.BackgroundColor3 = currentColor ColorBtn.BorderSizePixel = 0 ColorBtn.Text = ""
    Instance.new("UICorner", ColorBtn).CornerRadius = UDim.new(0, 3)

    local PickerPopup = Instance.new("Frame", ScreenGui)
    PickerPopup.Size = UDim2.new(0, 130, 0, 95)
    PickerPopup.BackgroundColor3 = SidebarDark
    PickerPopup.BorderSizePixel = 0
    PickerPopup.Visible = false
    PickerPopup.ZIndex = 600
    Instance.new("UICorner", PickerPopup).CornerRadius = UDim.new(0, 6)
    local PopStroke = Instance.new("UIStroke", PickerPopup) PopStroke.Color = AccentColor PopStroke.Thickness = 1

    local pLayout = Instance.new("UIGridLayout", PickerPopup)
    pLayout.CellSize = UDim2.new(0, 34, 0, 20) pLayout.CellPadding = UDim2.new(0, 6, 0, 6)
    pLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local pPadding = Instance.new("UIPadding", PickerPopup)
    pPadding.PaddingTop = UDim.new(0, 10) pPadding.PaddingLeft = UDim.new(0, 10)

    local colors = {
        Color3.fromRGB(255, 50, 50),
        Color3.fromRGB(0, 255, 120),
        Color3.fromRGB(0, 225, 255),
        Color3.fromRGB(170, 0, 255),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 150, 0)
    }

    for _, col in ipairs(colors) do
        local cBtn = Instance.new("TextButton", PickerPopup)
        cBtn.BackgroundColor3 = col cBtn.BorderSizePixel = 0 cBtn.Text = ""
        Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 4)
        cBtn.MouseButton1Click:Connect(function()
            ColorBtn.BackgroundColor3 = col
            PickerPopup.Visible = false
            callback(col)
        end)
    end

    ColorBtn.MouseButton1Click:Connect(function()
        PickerPopup.Position = UDim2.new(0, ColorBtn.AbsolutePosition.X - 50, 0, ColorBtn.AbsolutePosition.Y + 20)
        PickerPopup.Visible = not PickerPopup.Visible
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

local KillerCard = CreateCard(MainR, "Killer Side")
CreateToggle(KillerCard, "Killer Aimbot (Visible Only)", false, function(v) Config.KillerAimbot = v end)

local PortalCard = CreateCard(MainR, "Portal Teleport System")
CreateToggle(PortalCard, "Portal Teleport", false, function(v) Config.PortalTeleport = v end)

local EnvironmentCard = CreateCard(VisualsL, "World Visuals")
CreateToggle(EnvironmentCard, "FullBright", false, function(v) Config.FullBright = v end)
CreateToggle(EnvironmentCard, "Remove Fog", false, function(v) Config.NoFog = v end)
CreateToggle(EnvironmentCard, "Custom Time Of Day", false, function(v) Config.CustomTime = v end)
CreateSlider(EnvironmentCard, "Clock Time", 0, 24, 14, function(v) Config.TimeOfDay = v end)
CreateToggle(EnvironmentCard, "Custom FOV", false, function(v) Config.CustomFOVEnabled = v end)
CreateSlider(EnvironmentCard, "FOV Value", 70, 120, 90, function(v) Config.FOVValue = v end)

local ESPCard = CreateCard(VisualsR, "ESP & Tracers")
CreateToggle(ESPCard, "Player ESP", false, function(v) Config.PlayerESP = v end)
CreateColorPicker(ESPCard, "Player ESP Color", Config.PlayerESPColor, function(c) Config.PlayerESPColor = c end)

CreateToggle(ESPCard, "Killer ESP", false, function(v) Config.KillerESP = v end)
CreateColorPicker(ESPCard, "Killer ESP Color", Config.KillerESPColor, function(c) Config.KillerESPColor = c end)

CreateToggle(ESPCard, "Generator ESP", false, function(v) Config.GeneratorESP = v end)
CreateColorPicker(ESPCard, "Generator Color", Config.GeneratorESPColor, function(c) Config.GeneratorESPColor = c end)

CreateToggle(ESPCard, "Pallet ESP", false, function(v) Config.PalletESP = v end)
CreateColorPicker(ESPCard, "Pallet Color", Config.PalletESPColor, function(c) Config.PalletESPColor = c end)

CreateToggle(ESPCard, "Window / Door ESP", false, function(v) Config.WindowESP = v end)
CreateColorPicker(ESPCard, "Window Color", Config.WindowESPColor, function(c) Config.WindowESPColor = c end)

CreateToggle(ESPCard, "White Tracers: Players", false, function(v) Config.TracersPlayers = v end)
CreateToggle(ESPCard, "White Tracers: Killer", false, function(v) Config.TracersKiller = v end)
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

-- ПОРТАЛ-ТЕЛЕПОРТ
local PortalPart = Instance.new("Part")
PortalPart.Name = "VortexPortal"
PortalPart.Size = Vector3.new(4, 7, 1)
PortalPart.Anchored = true
PortalPart.CanCollide = false
PortalPart.Material = Enum.Material.Neon
PortalPart.Color = AccentColor
PortalPart.Transparency = 0.3
PortalPart.Parent = Workspace
PortalPart.Visible = false

local PortalLight = Instance.new("PointLight", PortalPart)
PortalLight.Color = AccentColor
PortalLight.Range = 12
PortalLight.Brightness = 3

local function GetRandomMapPosition()
    local mapParts = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Anchored and not obj.Parent:FindFirstChild("Humanoid") then
            local name = string.lower(obj.Name)
            local parentName = string.lower(obj.Parent.Name)
            if not string.find(name, "spawn") and not string.find(parentName, "spawn") and not string.find(name, "lobby") then
                table.insert(mapParts, obj)
            end
        end
    end
    if #mapParts > 0 then
        local randomPart = mapParts[math.random(1, #mapParts)]
        return randomPart.Position + Vector3.new(math.random(-15, 15), 4, math.random(-15, 15))
    end
    return Vector3.new(math.random(-150, 150), 10, math.random(-150, 150))
end

local function SpawnPortal()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = LocalPlayer.Character.HumanoidRootPart
    local spawnPos = root.Position + (root.CFrame.LookVector * 6) + Vector3.new(0, 2, 0)
    PortalPart.Position = spawnPos
    PortalPart.CFrame = CFrame.new(spawnPos, root.Position)
    PortalPart.Visible = true
    
    task.spawn(function()
        task.wait(0.3)
        local destPos = GetRandomMapPosition()
        root.CFrame = CFrame.new(destPos)
        task.wait(0.5)
        PortalPart.Visible = false
    end)
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe or not Config.PortalTeleport or not Config.PortalKey then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Config.PortalKey then
        SpawnPortal()
    end
end)

-- AUTO DAGGER
local function ListenToKillerAttacks(killerChar)
    local hum = killerChar:FindFirstChildOfClass("Humanoid")
    if not hum or hum:GetAttribute("VortexHooked") then return end
    hum:SetAttribute("VortexHooked", true)

    hum.AnimationPlayed:Connect(function(track)
        if not Config.AutoStunDagger then return end
        local animName = string.lower(track.Animation.AnimationId)
        if string.find(animName, "attack") or string.find(animName, "strike") or string.find(animName, "hit") or string.find(animName, "swing") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local myPos = LocalPlayer.Character.HumanoidRootPart.Position
                local kPos = killerChar.HumanoidRootPart.Position
                if (myPos - kPos).Magnitude <= 12 then
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
                    task.wait(0.02)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
                end
            end
        end
    end)
end

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
        local tempGens, tempPallets, tempWindows, tempKillers, tempPlayers = {}, {}, {}, {}, {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local name = string.lower(obj.Name)
                if string.find(name, "generator") then table.insert(tempGens, obj)
                elseif string.find(name, "pallet") then table.insert(tempPallets, obj)
                elseif string.find(name, "window") or string.find(name, "door") then table.insert(tempWindows, obj) end
            end
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local char = p.Character
                local isKiller = string.find(string.lower(p.Name), "killer") or char:FindFirstChild("Weapon") or char:FindFirstChild("Bat")
                if isKiller then table.insert(tempKillers, char) else table.insert(tempPlayers, char) end
            end
        end
        Cache.Generators, Cache.Pallets, Cache.Windows, Cache.KillersList, Cache.PlayersList = tempGens, tempPallets, tempWindows, tempKillers, tempPlayers
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
    if Config.SpeedHack and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = Config.SpeedValue end
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
    CrosshairGui.Visible = Config.Crosshair
    if Config.KillerAimbot and Cache.ClosestKiller then
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Cache.ClosestKiller.Position), 0.35)
    end

    if throttleTimer >= 0.15 then
        throttleTimer = 0
        for _, char in ipairs(Cache.KillersList) do
            local hl = char:FindFirstChild("VDHighlight")
            if Config.KillerESP then
                if not hl then hl = Instance.new("Highlight", char) hl.Name = "VDHighlight" end
                hl.Adornee = char hl.FillColor = Config.KillerESPColor hl.OutlineColor = Color3.fromRGB(255, 255, 255) hl.OutlineTransparency = 0.2 hl.FillTransparency = 0.6
            else
                if hl then hl:Destroy() end
            end
            ListenToKillerAttacks(char)
        end
        for _, char in ipairs(Cache.PlayersList) do
            local hl = char:FindFirstChild("VDHighlight")
            if Config.PlayerESP then
                if not hl then hl = Instance.new("Highlight", char) hl.Name = "VDHighlight" end
                hl.Adornee = char hl.FillColor = Config.PlayerESPColor hl.OutlineColor = Config.PlayerESPColor hl.OutlineTransparency = 1 hl.FillTransparency = 0.35
            else
                if hl then hl:Destroy() end
            end
        end
        if Config.GeneratorESP then
            for _, gen in ipairs(Cache.Generators) do
                if not gen:FindFirstChild("GenHL") then
                    local hl = Instance.new("Highlight", gen) hl.Name = "GenHL" hl.Adornee = gen
                    hl.FillColor = Config.GeneratorESPColor hl.OutlineColor = Color3.fromRGB(255, 255, 255) hl.FillTransparency = 0.4
                else
                    gen.GenHL.FillColor = Config.GeneratorESPColor
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
                else
                    pal.PalletHL.FillColor = Config.PalletESPColor
                end
            end
        else
            for _, pal in ipairs(Cache.Pallets) do local hl = pal:FindFirstChild("PalletHL") if hl then hl:Destroy() end end
        end
        if Config.WindowESP then
            for _, win in ipairs(Cache.Windows) do
                if not win:FindFirstChild("WinHL") then
                    local hl = Instance.new("Highlight", win) hl.Name = "WinHL" hl.Adornee = win
                    hl.FillColor = Config.WindowESPColor hl.OutlineColor = Color3.fromRGB(255, 255, 255) hl.FillTransparency = 0.4
                else
                    win.WinHL.FillColor = Config.WindowESPColor
                end
            end
        else
            for _, win in ipairs(Cache.Windows) do local hl = win:FindFirstChild("WinHL") if hl then hl:Destroy() end end
        end
    end
end)
