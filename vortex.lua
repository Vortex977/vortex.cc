--====================================================================--
--             VORTEX HUB - VIOLENCE DISTRICT (FIXED BUILD)            --
--====================================================================--

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local KeyFileName = "VortexHub_Key.txt" -- Изменил формат для совместимости со всеми экзекуторами

-- База ключей
local KeyDatabase = {
    ["admin2013"] = { type = "Admin" },
    ["VTX-1D-8F92A"] = { type = "1 Day Pass" },
    ["VTX-30D-92KF8"] = { type = "30 Days VIP" }
}

-- Безопасная работа с файлами (чтобы не крашило экзекутор)
local function LoadSavedKey()
    local success, result = pcall(function()
        if isfile and isfile(KeyFileName) then
            return readfile(KeyFileName)
        end
    end)
    return success and result or nil
end

local function SaveKey(key)
    pcall(function()
        if writefile then
            writefile(KeyFileName, key)
        end
    end)
end

local UI_PARENT = (gethui and gethui()) or CoreGui
if not pcall(function() local _ = UI_PARENT.Name end) then
    UI_PARENT = LocalPlayer:WaitForChild("PlayerGui")
end

-- ====================================================================--
--                       LOADING & KEY SYSTEM                         --
--===================================================================--

local function ShowLoadingAndKeySystem(onSuccess)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VortexLoader"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = UI_PARENT

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 340, 0, 210)
    Main.Position = UDim2.new(0.5, -170, 0.5, -105)
    Main.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(140, 50, 255)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 15)
    Title.Text = "VORTEX HUB | LICENSE"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.BackgroundTransparency = 1

    local TextBox = Instance.new("TextBox", Main)
    TextBox.Size = UDim2.new(0.8, 0, 0, 36)
    TextBox.Position = UDim2.new(0.1, 0, 0, 65)
    TextBox.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.PlaceholderText = "Paste Key Here..."
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextSize = 13
    Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)

    local SubmitBtn = Instance.new("TextButton", Main)
    SubmitBtn.Size = UDim2.new(0.8, 0, 0, 36)
    SubmitBtn.Position = UDim2.new(0.1, 0, 0, 115)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(140, 50, 255)
    SubmitBtn.Text = "VERIFY KEY"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.TextSize = 13
    Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 6)

    local Status = Instance.new("TextLabel", Main)
    Status.Size = UDim2.new(1, 0, 0, 20)
    Status.Position = UDim2.new(0, 0, 0, 165)
    Status.Text = "Checking saved data..."
    Status.Font = Enum.Font.Gotham
    Status.TextColor3 = Color3.fromRGB(160, 160, 180)
    Status.TextSize = 12
    Status.BackgroundTransparency = 1

    local function Authenticate(key)
        local inputKey = key:gsub("%s+", "")
        local keyData = KeyDatabase[inputKey]

        if keyData then
            SaveKey(inputKey)
            Status.TextColor3 = Color3.fromRGB(100, 255, 120)
            Status.Text = "Access Granted! Loading..."
            task.wait(0.5)
            ScreenGui:Destroy()
            onSuccess(inputKey, keyData.type)
        else
            Status.TextColor3 = Color3.fromRGB(255, 80, 80)
            Status.Text = "Invalid Key!"
        end
    end

    -- Проверка сохраненного ключа при запуске
    task.spawn(function()
        local savedKey = LoadSavedKey()
        if savedKey and KeyDatabase[savedKey:gsub("%s+", "")] then
            Status.TextColor3 = Color3.fromRGB(100, 255, 120)
            Status.Text = "Auto-Login Successful!"
            task.wait(0.5)
            ScreenGui:Destroy()
            onSuccess(savedKey, KeyDatabase[savedKey:gsub("%s+", "")].type)
        else
            Status.Text = "Awaiting License Key..."
        end
    end)

    SubmitBtn.MouseButton1Click:Connect(function()
        Authenticate(TextBox.Text)
    end)
end

-- ====================================================================--
--                         MAIN HUB INTERFACE                         --
--===================================================================--

local function LoadMainVortexHub(usedKey, keyType)
    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    -- ВОЗВРАЩАЕМ МЕНЕДЖЕРЫ НАСТРОЕК И КОНФИГОВ
    local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
    
    local Window = Fluent:CreateWindow({
        Title = "VORTEX HUB | Violence District",
        SubTitle = "License: " .. keyType,
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = false,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.RightControl
    })

    -- ==================== MODERN WATERMARK & KEYBINDS ====================
    local VisualsGui = Instance.new("ScreenGui")
    VisualsGui.Name = "VortexVisualsUI"
    VisualsGui.Parent = UI_PARENT

    local WmFrame = Instance.new("Frame", VisualsGui)
    WmFrame.Size = UDim2.new(0, 190, 0, 30)
    WmFrame.Position = UDim2.new(0, 15, 0, 15)
    WmFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    WmFrame.BorderSizePixel = 0
    Instance.new("UICorner", WmFrame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", WmFrame).Color = Color3.fromRGB(45, 45, 60)

    local WmText = Instance.new("TextLabel", WmFrame)
    WmText.Size = UDim2.new(1, -20, 1, 0)
    WmText.Position = UDim2.new(0, 10, 0, 0)
    WmText.BackgroundTransparency = 1
    WmText.Text = "VORTEX HUB  |  FPS: --"
    WmText.TextColor3 = Color3.fromRGB(220, 220, 230)
    WmText.Font = Enum.Font.GothamMedium
    WmText.TextSize = 12
    WmText.TextXAlignment = Enum.TextXAlignment.Left

    local KbFrame = Instance.new("Frame", VisualsGui)
    KbFrame.Size = UDim2.new(0, 170, 0, 32) 
    KbFrame.Position = UDim2.new(0, 15, 0, 60)
    KbFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    KbFrame.BorderSizePixel = 0
    KbFrame.ClipsDescendants = true
    Instance.new("UICorner", KbFrame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", KbFrame).Color = Color3.fromRGB(45, 45, 60)

    local KbTitle = Instance.new("TextLabel", KbFrame)
    KbTitle.Size = UDim2.new(1, -20, 0, 32)
    KbTitle.Position = UDim2.new(0, 10, 0, 0)
    KbTitle.BackgroundTransparency = 1
    KbTitle.Text = "KEYBINDS"
    KbTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
    KbTitle.Font = Enum.Font.GothamBold
    KbTitle.TextSize = 11
    KbTitle.TextXAlignment = Enum.TextXAlignment.Left

    local Container = Instance.new("Frame", KbFrame)
    Container.Size = UDim2.new(1, 0, 1, -32)
    Container.Position = UDim2.new(0, 0, 0, 32)
    Container.BackgroundTransparency = 1

    local KbList = Instance.new("UIListLayout", Container)
    KbList.SortOrder = Enum.SortOrder.LayoutOrder
    KbList.Padding = UDim.new(0, 4)
    Instance.new("UIPadding", Container).PaddingLeft = UDim.new(0, 10)
    Instance.new("UIPadding", Container).PaddingRight = UDim.new(0, 10)

    local function MakeDraggable(gui)
        local dragging, dragStart, startPos
        gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true; dragStart = input.Position; startPos = gui.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
    end
    MakeDraggable(WmFrame)
    MakeDraggable(KbFrame)

    local ActiveBinds = {}
    local function UpdateKeybindList()
        local count = 0
        for _, item in pairs(ActiveBinds) do
            local bindStr = tostring(item.Bind):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
            if bindStr ~= "NONE" and bindStr ~= "Unknown" and bindStr ~= "" then
                item.Frame.Visible = true
                item.BindLbl.Text = "[" .. bindStr .. "]"
                count = count + 1
                if item.Active then
                    item.NameLbl.TextColor3 = Color3.fromRGB(168, 85, 247) 
                    item.BindLbl.TextColor3 = Color3.fromRGB(220, 220, 255)
                else
                    item.NameLbl.TextColor3 = Color3.fromRGB(100, 100, 110)
                    item.BindLbl.TextColor3 = Color3.fromRGB(100, 100, 110)
                end
            else
                item.Frame.Visible = false
            end
        end
        local targetHeight = count > 0 and (32 + (count * 18) + 8) or 32
        TweenService:Create(KbFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 170, 0, targetHeight)}):Play()
    end

    local function SetKeybindState(name, bindText, isActive)
        if not ActiveBinds[name] then
            local ItemFrame = Instance.new("Frame", Container)
            ItemFrame.Size = UDim2.new(1, 0, 0, 16)
            ItemFrame.BackgroundTransparency = 1
            local NameLabel = Instance.new("TextLabel", ItemFrame)
            NameLabel.Size = UDim2.new(0.65, 0, 1, 0)
            NameLabel.BackgroundTransparency = 1
            NameLabel.Text = name
            NameLabel.Font = Enum.Font.GothamMedium
            NameLabel.TextSize = 11
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left
            local BindLabel = Instance.new("TextLabel", ItemFrame)
            BindLabel.Size = UDim2.new(0.35, 0, 1, 0)
            BindLabel.Position = UDim2.new(0.65, 0, 0, 0)
            BindLabel.BackgroundTransparency = 1
            BindLabel.Font = Enum.Font.Gotham
            BindLabel.TextSize = 11
            BindLabel.TextXAlignment = Enum.TextXAlignment.Right
            ActiveBinds[name] = { Frame = ItemFrame, NameLbl = NameLabel, BindLbl = BindLabel, Bind = "NONE", Active = false }
        end
        if bindText ~= nil then ActiveBinds[name].Bind = bindText end
        if isActive ~= nil then ActiveBinds[name].Active = isActive end
        UpdateKeybindList()
    end

    -- ==================== MENU & FEATURES ====================
    local Tabs = {
        Combat = Window:AddTab({ Title = "Combat", Icon = "sword" }),
        Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
        Player = Window:AddTab({ Title = "Player", Icon = "user" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }) -- ВОТ ТВОЯ ВКЛАДКА НАСТРОЕК
    }

    local Features = {
        AutoDagger = false,
        ESP_Players = false,
        ESP_KillerColor = Color3.fromRGB(239, 68, 68),
        ESP_SurvivorColor = Color3.fromRGB(34, 197, 94),
        SpeedHack = false,
        SpeedValue = 16,
        RiceHat = false,
        CartoonKillerCone = false
    }

    local ToggleDagger = Tabs.Combat:AddToggle("AutoDagger", {Title = "Auto Dagger / Parry", Default = false})
    ToggleDagger:OnChanged(function(Val) Features.AutoDagger = Val; SetKeybindState("Auto Dagger", nil, Val) end)
    Tabs.Combat:AddKeybind("AutoDaggerKey", {Title = "Auto Dagger Key", Mode = "Toggle", Default = "NONE", Callback = function(Val) ToggleDagger:SetValue(Val) end, ChangedCallback = function(NewBind) SetKeybindState("Auto Dagger", NewBind, Features.AutoDagger) end})

    local TogglePlayers = Tabs.Visuals:AddToggle("ESP_Players", {Title = "Player / Killer ESP", Default = false})
    TogglePlayers:OnChanged(function(Val) Features.ESP_Players = Val; SetKeybindState("Player ESP", nil, Val) end)
    Tabs.Visuals:AddKeybind("ESPKey", {Title = "Toggle ESP Key", Mode = "Toggle", Default = "NONE", Callback = function(Val) TogglePlayers:SetValue(Val) end, ChangedCallback = function(NewBind) SetKeybindState("Player ESP", NewBind, Features.ESP_Players) end})

    Tabs.Visuals:AddColorpicker("KillerColor", {Title = "Killer ESP Color", Default = Color3.fromRGB(239, 68, 68), Callback = function(Val) Features.ESP_KillerColor = Val end})
    Tabs.Visuals:AddColorpicker("SurvivorColor", {Title = "Survivor ESP Color", Default = Color3.fromRGB(34, 197, 94), Callback = function(Val) Features.ESP_SurvivorColor = Val end})

    local ToggleHat = Tabs.Visuals:AddToggle("RiceHatToggle", {Title = "3D Chinese Hat", Default = false})
    ToggleHat:OnChanged(function(Val) Features.RiceHat = Val end)

    local ToggleCartoonCone = Tabs.Visuals:AddToggle("CartoonConeToggle", {Title = "Cartoon Killer Vision Lines", Default = false})
    ToggleCartoonCone:OnChanged(function(Val) Features.CartoonKillerCone = Val end)

    local ToggleSpeed = Tabs.Player:AddToggle("SpeedHack", {Title = "SpeedHack", Default = false})
    ToggleSpeed:OnChanged(function(Val) Features.SpeedHack = Val; SetKeybindState("SpeedHack", nil, Val) end)
    Tabs.Player:AddKeybind("SpeedKey", {Title = "Speed Key", Mode = "Toggle", Default = "NONE", Callback = function(Val) ToggleSpeed:SetValue(Val) end, ChangedCallback = function(NewBind) SetKeybindState("SpeedHack", NewBind, Features.SpeedHack) end})
    Tabs.Player:AddSlider("SpeedValue", {Title = "Speed Multiplier", Default = 16, Min = 16, Max = 40, Rounding = 1, Callback = function(Val) Features.SpeedValue = Val end})

    -- ==================== VISUALS LOGIC ====================
    task.spawn(function()
        while task.wait(0.5) do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                local char = LocalPlayer.Character
                local existingHat = char:FindFirstChild("VortexRiceHat")
                if Features.RiceHat then
                    if not existingHat then
                        local hat = Instance.new("Part")
                        hat.Name = "VortexRiceHat"
                        hat.Size = Vector3.new(2.5, 0.6, 2.5)
                        hat.CanCollide = false
                        hat.Massless = true
                        hat.Color = Color3.fromRGB(140, 50, 255)
                        hat.Material = Enum.Material.SmoothPlastic
                        local mesh = Instance.new("SpecialMesh", hat)
                        mesh.MeshType = Enum.MeshType.Cone
                        mesh.Scale = Vector3.new(2.5, 0.6, 2.5)
                        local weld = Instance.new("Weld", hat)
                        weld.Part0 = char.Head
                        weld.Part1 = hat
                        weld.C0 = CFrame.new(0, 0.7, 0)
                        hat.Parent = char
                    end
                else
                    if existingHat then existingHat:Destroy() end
                end
            end

            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local isKiller = p.Team and p.Team.Name:lower():find("killer")
                    local existingCone = p.Character:FindFirstChild("VortexVisionCone")
                    if Features.CartoonKillerCone and isKiller then
                        if not existingCone then
                            local cone = Instance.new("ConeHandleAdornment")
                            cone.Name = "VortexVisionCone"
                            cone.Adornee = p.Character.Head
                            cone.CFrame = CFrame.new(0, 0, -8) * CFrame.Angles(0, 0, 0)
                            cone.Radius = 4
                            cone.Height = 16
                            cone.Color3 = Color3.fromRGB(255, 50, 50)
                            cone.Transparency = 0.6
                            cone.ZIndex = 1
                            cone.Parent = p.Character
                        end
                    else
                        if existingCone then existingCone:Destroy() end
                    end
                end
            end
        end
    end)

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

    local lastTime = os.clock()
    local frames = 0
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        local now = os.clock()
        if now - lastTime >= 1 then
            WmText.Text = "VORTEX HUB  |  FPS: " .. frames
            frames = 0
            lastTime = now
        end
        if Features.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Features.SpeedValue
        end
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
                if p.Character and ESP_Cache[p.Character] then ESP_Cache[p.Character].Enabled = false end
            end
        end
    end)

    -- ==================== ИНИЦИАЛИЗАЦИЯ ВКЛАДКИ SETTINGS И КОНФИГОВ ====================
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    
    InterfaceManager:BuildInterfaceSection(Tabs.Settings) -- Добавляет смену цвета и бинд меню
    SaveManager:BuildConfigSection(Tabs.Settings) -- Добавляет систему конфигов

    Window:SelectTab(1)
end

-- ЗАПУСК
ShowLoadingAndKeySystem(function(key, keyType)
    LoadMainVortexHub(key, keyType)
end)
