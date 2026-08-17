--====================================================================--
--             VORTEX HUB - VIOLENCE DISTRICT (FINAL BUILD)            --
--====================================================================--

local TweenService = game:GetService("TweenService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local HWID = RbxAnalyticsService:GetClientId()
local KeyFileName = "VortexHub_Key.json"

-- База ключей
local KeyDatabase = {
    ["admin2013"] = { type = "Admin", duration = 99999999 },
    ["VTX-1D-8F92A"] = { type = "1 Day Pass", duration = 86400 },
    ["VTX-30D-92KF8"] = { type = "30 Days VIP", duration = 2592000 }
}

-- Работа с файлами
local function LoadSavedData()
    if isfile and readfile and isfile(KeyFileName) then
        local success, result = pcall(function() return HttpService:JSONDecode(readfile(KeyFileName)) end)
        if success then return result end
    end
    return nil
end

local function SaveData(key, hwid, activationTime)
    if writefile then
        pcall(function()
            writefile(KeyFileName, HttpService:JSONEncode({Key = key, HWID = hwid, ActivatedAt = activationTime}))
        end)
    end
end

-- ====================================================================--
--                       LOADING & KEY SYSTEM                         --
--===================================================================--

local function ShowLoadingScreen(onFinished)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VortexLoadingUI"
    ScreenGui.Parent = (gethui and gethui()) or CoreGui

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 360, 0, 180)
    Main.Position = UDim2.new(0.5, -180, 0.5, -90)
    Main.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(140, 50, 255)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 20)
    Title.Text = "VORTEX HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    Title.BackgroundTransparency = 1

    local Status = Instance.new("TextLabel", Main)
    Status.Size = UDim2.new(1, 0, 0, 20)
    Status.Position = UDim2.new(0, 0, 0, 85)
    Status.Text = "Starting up..."
    Status.TextColor3 = Color3.fromRGB(160, 160, 180)
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 13
    Status.BackgroundTransparency = 1

    local BarBG = Instance.new("Frame", Main)
    BarBG.Size = UDim2.new(0.8, 0, 0, 6)
    BarBG.Position = UDim2.new(0.1, 0, 0, 120)
    BarBG.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Instance.new("UICorner", BarBG).CornerRadius = UDim.new(1, 0)

    local BarFill = Instance.new("Frame", BarBG)
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(140, 50, 255)
    Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

    task.spawn(function()
        TweenService:Create(BarFill, TweenInfo.new(1, Enum.EasingStyle.Quad), {Size = UDim2.new(0.5, 0, 1, 0)}):Play()
        task.wait(1)
        
        local saved = LoadSavedData()
        local currentTime = os.time()
        local autoLogin = false
        local savedKeyType = ""

        if saved and saved.Key and saved.HWID == HWID then
            local keyInfo = KeyDatabase[saved.Key]
            if keyInfo and (currentTime - saved.ActivatedAt < keyInfo.duration) then
                autoLogin = true
                savedKeyType = keyInfo.type
            end
        end

        if autoLogin then
            Status.Text = "Valid License Found! Auto-Logging in..."
            Status.TextColor3 = Color3.fromRGB(100, 255, 120)
            TweenService:Create(BarFill, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 1, 0)}):Play()
            task.wait(0.6)
            ScreenGui:Destroy()
            onFinished(saved.Key, savedKeyType, true)
        else
            Status.Text = "Awaiting License Key..."
            TweenService:Create(BarFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 1, 0)}):Play()
            task.wait(0.4)
            ScreenGui:Destroy()
            onFinished(nil, nil, false)
        end
    end)
end

local function ShowKeySystem(onSuccess)
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "VortexKeyGui"
    KeyGui.Parent = (gethui and gethui()) or CoreGui

    local Main = Instance.new("Frame", KeyGui)
    Main.Size = UDim2.new(0, 340, 0, 210)
    Main.Position = UDim2.new(0.5, -170, 0.5, -105)
    Main.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(140, 50, 255)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 15)
    Title.Text = "LICENSE VERIFICATION"
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
    Status.Text = ""
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 12
    Status.BackgroundTransparency = 1

    SubmitBtn.MouseButton1Click:Connect(function()
        local inputKey = TextBox.Text:gsub("%s+", "")
        local keyData = KeyDatabase[inputKey]

        if keyData then
            SaveData(inputKey, HWID, os.time())
            Status.TextColor3 = Color3.fromRGB(100, 255, 120)
            Status.Text = "Access Granted! Loading..."
            task.wait(0.5)
            KeyGui:Destroy()
            onSuccess(inputKey, keyData.type)
        else
            Status.TextColor3 = Color3.fromRGB(255, 80, 80)
            Status.Text = "Invalid or Expired Key!"
        end
    end)
end

-- ====================================================================--
--                         MAIN HUB INTERFACE                         --
--===================================================================--

local function LoadMainVortexHub(usedKey, keyType)
    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    
    local Window = Fluent:CreateWindow({
        Title = "VORTEX HUB | Violence District",
        SubTitle = "License: " .. keyType,
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = false,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.RightControl
    })

    -- ==================== MODERN WATERMARK ====================
    local WatermarkGui = Instance.new("ScreenGui")
    WatermarkGui.Name = "VortexWatermarkModern"
    WatermarkGui.Parent = (gethui and gethui()) or CoreGui

    local WmFrame = Instance.new("Frame", WatermarkGui)
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

    -- ==================== COMPACT KEYBINDS UI ====================
    local KbFrame = Instance.new("Frame", WatermarkGui)
    KbFrame.Size = UDim2.new(0, 170, 0, 32) 
    KbFrame.Position = UDim2.new(0, 15, 0, 60) -- Под ватермаркой
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

    -- Драггинг для окон
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

    -- Динамическое управление биндами
    local ActiveBinds = {}

    local function FormatBindName(bind)
        local str = tostring(bind)
        return str:gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
    end

    local function UpdateKeybindList()
        local count = 0
        for _, item in pairs(ActiveBinds) do
            local bindStr = FormatBindName(item.Bind)
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
        
        -- Плавно меняем размер окна
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
        Player = Window:AddTab({ Title = "Player", Icon = "user" })
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

    -- COMBAT
    local ToggleDagger = Tabs.Combat:AddToggle("AutoDagger", {Title = "Auto Dagger / Parry", Default = false})
    ToggleDagger:OnChanged(function(Val)
        Features.AutoDagger = Val
        SetKeybindState("Auto Dagger", nil, Val)
    end)
    Tabs.Combat:AddKeybind("AutoDaggerKey", {
        Title = "Auto Dagger Key", Mode = "Toggle", Default = "NONE",
        Callback = function(Val, Bind)
            ToggleDagger:SetValue(Val)
        end,
        ChangedCallback = function(NewBind)
            SetKeybindState("Auto Dagger", NewBind, Features.AutoDagger)
        end
    })

    -- VISUALS
    local TogglePlayers = Tabs.Visuals:AddToggle("ESP_Players", {Title = "Player / Killer ESP", Default = false})
    TogglePlayers:OnChanged(function(Val)
        Features.ESP_Players = Val
        SetKeybindState("Player ESP", nil, Val)
    end)
    Tabs.Visuals:AddKeybind("ESPKey", {
        Title = "Toggle ESP Key", Mode = "Toggle", Default = "NONE",
        Callback = function(Val)
            TogglePlayers:SetValue(Val)
        end,
        ChangedCallback = function(NewBind)
            SetKeybindState("Player ESP", NewBind, Features.ESP_Players)
        end
    })

    Tabs.Visuals:AddColorpicker("KillerColor", {
        Title = "Killer ESP Color", Default = Color3.fromRGB(239, 68, 68),
        Callback = function(Val) Features.ESP_KillerColor = Val end
    })

    local ToggleHat = Tabs.Visuals:AddToggle("RiceHatToggle", {Title = "3D Chinese Hat", Default = false})
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
        Title = "Speed Key", Mode = "Toggle", Default = "NONE",
        Callback = function(Val)
            ToggleSpeed:SetValue(Val)
        end,
        ChangedCallback = function(NewBind)
            SetKeybindState("SpeedHack", NewBind, Features.SpeedHack)
        end
    })
    Tabs.Player:AddSlider("SpeedValue", {
        Title = "Speed Multiplier", Default = 16, Min = 16, Max = 40, Rounding = 1,
        Callback = function(Val) Features.SpeedValue = Val end
    })

    -- ==================== VISUALS LOGIC (HAT & CONE) ====================
    task.spawn(function()
        while task.wait(0.5) do
            -- 1. Китайская шляпа (Weld)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                local char = LocalPlayer.Character
                local head = char.Head
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
                        weld.Part0 = head
                        weld.Part1 = hat
                        weld.C0 = CFrame.new(0, 0.7, 0) -- Ровно над головой
                        
                        hat.Parent = char
                    end
                else
                    if existingHat then existingHat:Destroy() end
                end
            end

            -- 2. Мультяшный конус убийцы (ConeHandleAdornment)
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local isKiller = p.Team and p.Team.Name:lower():find("killer")
                    local head = p.Character.Head
                    local existingCone = p.Character:FindFirstChild("VortexVisionCone")

                    if Features.CartoonKillerCone and isKiller then
                        if not existingCone then
                            local cone = Instance.new("ConeHandleAdornment")
                            cone.Name = "VortexVisionCone"
                            cone.Adornee = head
                            -- Направляем конус вперед по взгляду персонажа (вдоль -Z оси головы)
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

    -- ==================== RENDER LOOP (ESP & FPS) ====================
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
                if p.Character then ClearESP(p.Character) end
            end
        end
    end)

    Window:SelectTab(1)
end

-- ====================================================================--
--                            STARTUP                                  --
--===================================================================--

ShowLoadingScreen(function(key, keyType, autoLogged)
    if autoLogged then
        LoadMainVortexHub(key, keyType)
    else
        ShowKeySystem(function(validKey, validKeyType)
            LoadMainVortexHub(validKey, validKeyType)
        end)
    end
end)
