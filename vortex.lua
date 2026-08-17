--====================================================================--
--                  VORTEX HUB - VIOLENCE DISTRICT (V2)                --
--====================================================================--

local TweenService = game:GetService("TweenService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local HWID = RbxAnalyticsService:GetClientId()
local KeyFileName = "VortexHub_Key.json"

-- База данных ключей (Key Database)
local KeyDatabase = {
    ["admin2013"] = { type = "Admin", duration = 99999999 },
    ["VTX-1D-8F92A"] = { type = "1 Day Pass", duration = 86400 },
    ["VTX-30D-92KF8"] = { type = "30 Days VIP", duration = 2592000 }
}

-- Хранилище сохраненных данных
local function LoadSavedData()
    if isfile and readfile and isfile(KeyFileName) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(KeyFileName))
        end)
        if success then return result end
    end
    return nil
end

local function SaveData(key, hwid, activationTime)
    if writefile then
        pcall(function()
            local data = { Key = key, HWID = hwid, ActivatedAt = activationTime }
            writefile(KeyFileName, HttpService:JSONEncode(data))
        end)
    end
end

-- ====================================================================--
--                         KEY SYSTEM GUI                             --
--===================================================================--

local function VerifyKeyAccess(onSuccess)
    local savedData = LoadSavedData()
    local currentTime = os.time()

    if savedData and savedData.Key and savedData.HWID and savedData.ActivatedAt then
        if savedData.HWID == HWID then
            local keyInfo = KeyDatabase[savedData.Key]
            if keyInfo and (currentTime - savedData.ActivatedAt < keyInfo.duration) then
                onSuccess(savedData.Key, keyInfo.type)
                return
            end
        end
    end

    -- Создание аккуратного UI ключа в стиле Fluent
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "VortexKeyGui"
    KeyGui.ResetOnSpawn = false
    KeyGui.Parent = (gethui and gethui()) or CoreGui

    local Main = Instance.new("Frame", KeyGui)
    Main.Size = UDim2.new(0, 340, 0, 210)
    Main.Position = UDim2.new(0.5, -170, 0.5, -105)
    Main.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(40, 40, 55)
    Stroke.Thickness = 1

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, -30, 0, 35)
    Title.Position = UDim2.new(0, 15, 0, 10)
    Title.Text = "VORTEX HUB"
    Title.TextColor3 = Color3.fromRGB(240, 240, 245)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    local SubTitle = Instance.new("TextLabel", Main)
    SubTitle.Size = UDim2.new(1, -30, 0, 20)
    SubTitle.Position = UDim2.new(0, 15, 0, 40)
    SubTitle.Text = "Введите лицензионный ключ для доступа"
    SubTitle.TextColor3 = Color3.fromRGB(140, 140, 160)
    SubTitle.TextSize = 12
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.BackgroundTransparency = 1

    local TextBox = Instance.new("TextBox", Main)
    TextBox.Size = UDim2.new(1, -30, 0, 36)
    TextBox.Position = UDim2.new(0, 15, 0, 75)
    TextBox.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.PlaceholderText = "Вставьте ключ сюда..."
    TextBox.PlaceholderColor3 = Color3.fromRGB(90, 90, 110)
    TextBox.Text = ""
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextSize = 13
    Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)
    
    local BoxStroke = Instance.new("UIStroke", TextBox)
    BoxStroke.Color = Color3.fromRGB(45, 45, 60)
    BoxStroke.Thickness = 1

    local SubmitBtn = Instance.new("TextButton", Main)
    SubmitBtn.Size = UDim2.new(1, -30, 0, 36)
    SubmitBtn.Position = UDim2.new(0, 15, 0, 125)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 230)
    SubmitBtn.Text = "Активировать"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.TextSize = 13
    Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 6)

    local StatusLabel = Instance.new("TextLabel", Main)
    StatusLabel.Size = UDim2.new(1, -30, 0, 20)
    StatusLabel.Position = UDim2.new(0, 15, 0, 170)
    StatusLabel.Text = ""
    StatusLabel.TextSize = 11
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.BackgroundTransparency = 1

    SubmitBtn.MouseButton1Click:Connect(function()
        local inputKey = TextBox.Text:gsub("%s+", "")
        local keyData = KeyDatabase[inputKey]

        if keyData then
            SaveData(inputKey, HWID, os.time())
            StatusLabel.TextColor3 = Color3.fromRGB(100, 240, 130)
            StatusLabel.Text = "Успешно! Загрузка скрипта..."
            task.wait(0.5)
            KeyGui:Destroy()
            onSuccess(inputKey, keyData.type)
        else
            StatusLabel.TextColor3 = Color3.fromRGB(240, 80, 80)
            StatusLabel.Text = "Неверный или просроченный ключ!"
        end
    end)
end

-- ====================================================================--
--                     MAIN VORTEX HUB INTERFACE                       --
--===================================================================--

local function LoadMainVortexHub(usedKey, keyType)
    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

    local Window = Fluent:CreateWindow({
        Title = "VORTEX HUB | Violence District",
        SubTitle = "Key: " .. keyType,
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = false,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.RightControl
    })

    -- ==================== FLUENT STYLE WATERMARK ====================
    local WatermarkGui = Instance.new("ScreenGui")
    WatermarkGui.Name = "VortexWatermarkModern"
    WatermarkGui.Parent = (gethui and gethui()) or CoreGui

    local WmFrame = Instance.new("Frame", WatermarkGui)
    WmFrame.Size = UDim2.new(0, 180, 0, 30)
    WmFrame.Position = UDim2.new(0, 15, 0, 15)
    WmFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    WmFrame.BorderSizePixel = 0
    Instance.new("UICorner", WmFrame).CornerRadius = UDim.new(0, 6)

    local WmStroke = Instance.new("UIStroke", WmFrame)
    WmStroke.Color = Color3.fromRGB(40, 40, 55)
    WmStroke.Thickness = 1

    local WmText = Instance.new("TextLabel", WmFrame)
    WmText.Size = UDim2.new(1, -12, 1, 0)
    WmText.Position = UDim2.new(0, 10, 0, 0)
    WmText.BackgroundTransparency = 1
    WmText.Text = "VORTEX HUB  |  FPS: --"
    WmText.TextColor3 = Color3.fromRGB(200, 200, 215)
    WmText.Font = Enum.Font.GothamMedium
    WmText.TextSize = 12
    WmText.TextXAlignment = Enum.TextXAlignment.Left

    -- Dragging Watermark
    local dragging, dragInput, dragStart, startPos
    WmFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = WmFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            WmFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- ==================== COMPACT KEYBINDS UI ====================
    local KeybindsGui = Instance.new("ScreenGui")
    KeybindsGui.Name = "VortexKeybindsModern"
    KeybindsGui.Parent = (gethui and gethui()) or CoreGui

    local KbFrame = Instance.new("Frame", KeybindsGui)
    KbFrame.Size = UDim2.new(0, 160, 0, 32) -- Автоматически растет по высоте
    KbFrame.Position = UDim2.new(1, -175, 0.4, 0)
    KbFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    KbFrame.BorderSizePixel = 0
    KbFrame.ClipsDescendants = false
    Instance.new("UICorner", KbFrame).CornerRadius = UDim.new(0, 6)

    local KbStroke = Instance.new("UIStroke", KbFrame)
    KbStroke.Color = Color3.fromRGB(40, 40, 55)
    KbStroke.Thickness = 1

    local KbTitle = Instance.new("TextLabel", KbFrame)
    KbTitle.Size = UDim2.new(1, -12, 0, 28)
    KbTitle.Position = UDim2.new(0, 10, 0, 0)
    KbTitle.BackgroundTransparency = 1
    KbTitle.Text = "KEYBINDS"
    KbTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
    KbTitle.Font = Enum.Font.GothamBold
    KbTitle.TextSize = 11
    KbTitle.TextXAlignment = Enum.TextXAlignment.Left

    local Container = Instance.new("Frame", KbFrame)
    Container.Size = UDim2.new(1, 0, 1, -28)
    Container.Position = UDim2.new(0, 0, 0, 28)
    Container.BackgroundTransparency = 1

    local KbList = Instance.new("UIListLayout", Container)
    KbList.SortOrder = Enum.SortOrder.LayoutOrder
    KbList.Padding = UDim.new(0, 3)

    local KbPadding = Instance.new("UIPadding", Container)
    KbPadding.PaddingLeft = UDim.new(0, 10)
    KbPadding.PaddingRight = UDim.new(0, 10)
    KbPadding.PaddingBottom = UDim.new(0, 8)

    -- Dragging Keybinds Frame
    local kbDragging, kbDragStart, kbStartPos
    KbFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            kbDragging = true; kbDragStart = input.Position; kbStartPos = KbFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if kbDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - kbDragStart
            KbFrame.Position = UDim2.new(kbStartPos.X.Scale, kbStartPos.X.Offset + delta.X, kbStartPos.Y.Scale, kbStartPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then kbDragging = false end
    end)

    -- Динамический менеджер биндов
    local ActiveBinds = {}

    local function RecalculateKbHeight()
        local count = 0
        for _, item in pairs(ActiveBinds) do
            if item.Bind ~= "NONE" and item.Bind ~= "" then
                count = count + 1
            end
        end
        local newHeight = 32 + (count * 18)
        KbFrame.Size = UDim2.new(0, 160, 0, newHeight)
    end

    local function SetKeybindState(name, bindText, isActive)
        if not ActiveBinds[name] then
            local ItemFrame = Instance.new("Frame", Container)
            ItemFrame.Size = UDim2.new(1, 0, 0, 15)
            ItemFrame.BackgroundTransparency = 1

            local NameLabel = Instance.new("TextLabel", ItemFrame)
            NameLabel.Size = UDim2.new(0.7, 0, 1, 0)
            NameLabel.BackgroundTransparency = 1
            NameLabel.Text = name
            NameLabel.Font = Enum.Font.GothamMedium
            NameLabel.TextSize = 10
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left

            local BindLabel = Instance.new("TextLabel", ItemFrame)
            BindLabel.Size = UDim2.new(0.3, 0, 1, 0)
            BindLabel.Position = UDim2.new(0.7, 0, 0, 0)
            BindLabel.BackgroundTransparency = 1
            BindLabel.Font = Enum.Font.Gotham
            BindLabel.TextSize = 10
            BindLabel.TextXAlignment = Enum.TextXAlignment.Right

            ActiveBinds[name] = { Frame = ItemFrame, NameLbl = NameLabel, BindLbl = BindLabel, Bind = "NONE", Active = false }
        end

        local bindObj = ActiveBinds[name]
        if bindText then bindObj.Bind = tostring(bindText) end
        if isActive ~= nil then bindObj.Active = isActive end

        -- Если клавиша не назначена, скрываем строку
        if bindObj.Bind == "NONE" or bindObj.Bind == "Unknown" or bindObj.Bind == "" then
            bindObj.Frame.Visible = false
        else
            bindObj.Frame.Visible = true
            bindObj.BindLbl.Text = "[" .. bindObj.Bind .. "]"
            
            if bindObj.Active then
                bindObj.NameLbl.TextColor3 = Color3.fromRGB(168, 85, 247) -- Яркий фиолетовый
                bindObj.BindLbl.TextColor3 = Color3.fromRGB(220, 220, 255)
            else
                bindObj.NameLbl.TextColor3 = Color3.fromRGB(156, 163, 175) -- Нейтральный серый
                bindObj.BindLbl.TextColor3 = Color3.fromRGB(100, 100, 120)
            end
        end

        RecalculateKbHeight()
    end

    -- ==================== TABS SETUP ====================
    local Tabs = {
        Combat = Window:AddTab({ Title = "Combat & Parry", Icon = "sword" }),
        Visuals = Window:AddTab({ Title = "Visuals (ESP)", Icon = "eye" }),
        Player = Window:AddTab({ Title = "Player & Mods", Icon = "user" }),
        Automation = Window:AddTab({ Title = "Automation", Icon = "bot" }),
        Settings = Window:AddTab({ Title = "Settings & Binds", Icon = "settings" })
    }

    local Features = {
        AutoDagger = false,
        ESP_Players = false,
        ESP_KillerColor = Color3.fromRGB(239, 68, 68),
        ESP_SurvivorColor = Color3.fromRGB(34, 197, 94),
        SpeedHack = false,
        SpeedValue = 16,
        AutoSkillCheck = false,
        RiceHat = false,
        CartoonKillerCone = false
    }

    -- COMBAT
    local ToggleDagger = Tabs.Combat:AddToggle("AutoDagger", {Title = "Auto Dagger / Parry", Default = false})
    ToggleDagger:OnChanged(function(Val)
        Features.AutoDagger = Val
        SetKeybindState("Auto Dagger", nil, Val)
    end)

    Tabs.Combat:AddKeybind("AutoDaggerKey", {
        Title = "Auto Dagger Keybind",
        Mode = "Toggle",
        Default = "NONE",
        Callback = function(Val, Bind)
            ToggleDagger:SetValue(Val)
            SetKeybindState("Auto Dagger", Bind, Val)
        end
    })

    -- VISUALS
    local TogglePlayers = Tabs.Visuals:AddToggle("ESP_Players", {Title = "Player / Killer ESP", Default = false})
    TogglePlayers:OnChanged(function(Val)
        Features.ESP_Players = Val
        SetKeybindState("Player ESP", nil, Val)
    end)

    Tabs.Visuals:AddKeybind("ESPKey", {
        Title = "ESP Keybind",
        Mode = "Toggle",
        Default = "NONE",
        Callback = function(Val, Bind)
            TogglePlayers:SetValue(Val)
            SetKeybindState("Player ESP", Bind, Val)
        end
    })

    Tabs.Visuals:AddColorpicker("KillerColor", {
        Title = "Killer ESP Color",
        Default = Color3.fromRGB(239, 68, 68),
        Callback = function(Val) Features.ESP_KillerColor = Val end
    })

    Tabs.Visuals:AddColorpicker("SurvivorColor", {
        Title = "Survivor ESP Color",
        Default = Color3.fromRGB(34, 197, 94),
        Callback = function(Val) Features.ESP_SurvivorColor = Val end
    })

    local ToggleHat = Tabs.Visuals:AddToggle("RiceHatToggle", {Title = "Chinese Rice Hat (3D)", Default = false})
    ToggleHat:OnChanged(function(Val) Features.RiceHat = Val end)

    local ToggleCartoonCone = Tabs.Visuals:AddToggle("CartoonConeToggle", {Title = "Cartoon Killer Vision Lines", Default = false})
    ToggleCartoonCone:OnChanged(function(Val) Features.CartoonKillerCone = Val end)

    -- PLAYER
    local ToggleSpeed = Tabs.Player:AddToggle("SpeedHack", {Title = "SpeedHack", Default = false})
    ToggleSpeed:OnChanged(function(Val)
        Features.SpeedHack = Val
        SetKeybindState("SpeedHack", nil, Val)
    end)

    Tabs.Player:AddKeybind("SpeedKey", {
        Title = "Speed Keybind",
        Mode = "Toggle",
        Default = "NONE",
        Callback = function(Val, Bind)
            ToggleSpeed:SetValue(Val)
            SetKeybindState("SpeedHack", Bind, Val)
        end
    })

    Tabs.Player:AddSlider("SpeedValue", {
        Title = "Speed Multiplier",
        Default = 16,
        Min = 16,
        Max = 40,
        Rounding = 1,
        Callback = function(Val) Features.SpeedValue = Val end
    })

    -- AUTOMATION
    Tabs.Automation:AddToggle("AutoSkill", {
        Title = "Auto SkillCheck",
        Default = false,
        Callback = function(Val) Features.AutoSkillCheck = Val end
    })

    -- ==================== 3D RICE HAT (КИТАЙСКАЯ ШЛЯПА) ====================
    local function ManageRiceHat()
        local char = LocalPlayer.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end

        local existingHat = char:FindFirstChild("VortexRiceHat")

        if Features.RiceHat then
            if not existingHat then
                local hat = Instance.new("Part")
                hat.Name = "VortexRiceHat"
                hat.Size = Vector3.new(2.6, 0.6, 2.6)
                hat.CanCollide = false
                hat.Massless = true
                hat.Material = Enum.Material.SmoothPlastic
                hat.Color = Color3.fromRGB(140, 50, 255)

                local mesh = Instance.new("SpecialMesh", hat)
                mesh.MeshType = Enum.MeshType.Cone
                mesh.Scale = Vector3.new(2.6, 0.6, 2.6)

                local weld = Instance.new("WeldConstraint")
                hat.CFrame = head.CFrame * CFrame.new(0, 0.8, 0)
                weld.Part0 = head
                weld.Part1 = hat
                weld.Parent = hat

                hat.Parent = char
            end
        else
            if existingHat then existingHat:Destroy() end
        end
    end

    -- ==================== OPTIMIZED LOOP ====================
    local ESP_Cache = {}

    local function ApplyESP(inst, color)
        local hl = ESP_Cache[inst]
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = "Vortex_ESP"
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            hl.Parent = inst
            ESP_Cache[inst] = hl
        end
        hl.Adornee = inst
        hl.FillColor = color
        hl.Enabled = true
    end

    local function ClearESP(inst)
        if ESP_Cache[inst] then ESP_Cache[inst].Enabled = false end
    end

    local lastFpsUpdate = os.clock()
    local frames = 0

    RunService.RenderStepped:Connect(function()
        -- FPS counter
        frames = frames + 1
        local now = os.clock()
        if now - lastFpsUpdate >= 1 then
            WmText.Text = "VORTEX HUB  |  FPS: " .. tostring(frames)
            frames = 0
            lastFpsUpdate = now
        end

        -- SpeedHack
        if Features.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Features.SpeedValue
        end

        -- ESP update
        if Features.ESP_Players then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local isKiller = p.Team and p.Team.Name:lower():find("killer")
                    local col = isKiller and Features.ESP_KillerColor or Features.ESP_SurvivorColor
                    ApplyESP(p.Character, col)
                end
            end
        else
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character then ClearESP(p.Character) end
            end
        end

        -- Update Rice Hat Attachment
        ManageRiceHat()
    end)

    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)

    Window:SelectTab(1)
end

-- ====================================================================--
--                            STARTUP                                  --
--===================================================================--

VerifyKeyAccess(function(key, keyType)
    LoadMainVortexHub(key, keyType)
end)
