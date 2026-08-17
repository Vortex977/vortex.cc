--====================================================================--
--        VORTEX HUB - VIOLENCE DISTRICT (ADVANCED ULTIMATE)          --
--====================================================================--

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local KeyFileName = "VortexHub_Key.txt"

local KeyDatabase = {
    ["admin2013"] = { type = "Admin" },
    ["VTX-1D-8F92A"] = { type = "1 Day Pass" },
    ["VTX-30D-92KF8"] = { type = "30 Days VIP" }
}

local UI_PARENT
if gethui then
    UI_PARENT = gethui()
elseif CoreGui then
    UI_PARENT = CoreGui
else
    UI_PARENT = LocalPlayer:WaitForChild("PlayerGui")
end

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

-- ====================================================================--
--                       LOADING & KEY SYSTEM                         --
--===================================================================--

local function ShowKeySystem(onSuccess)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VortexKeyLoader"
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
    Status.Text = "Checking key status..."
    Status.Font = Enum.Font.Gotham
    Status.TextColor3 = Color3.fromRGB(160, 160, 180)
    Status.TextSize = 12
    Status.BackgroundTransparency = 1

    local function ValidateKey(inputKey)
        local keyClean = inputKey:gsub("%s+", "")
        local keyData = KeyDatabase[keyClean]

        if keyData then
            SaveKey(keyClean)
            Status.TextColor3 = Color3.fromRGB(100, 255, 120)
            Status.Text = "Access Granted! Loading..."
            task.wait(0.4)
            ScreenGui:Destroy()
            onSuccess(keyClean, keyData.type)
            return true
        else
            Status.TextColor3 = Color3.fromRGB(255, 80, 80)
            Status.Text = "Invalid License Key!"
            return false
        end
    end

    task.spawn(function()
        local saved = LoadSavedKey()
        if saved and ValidateKey(saved) then
        else
            Status.Text = "Enter key to continue"
        end
    end)

    SubmitBtn.MouseButton1Click:Connect(function()
        ValidateKey(TextBox.Text)
    end)
end

-- ====================================================================--
--                         MAIN HUB INTERFACE                         --
--===================================================================--

local function LoadMainVortexHub(usedKey, keyType)
    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
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

    -- ==================== CLEAN & ALIGNED OVERLAYS ====================
    local VisualsGui = Instance.new("ScreenGui")
    VisualsGui.Name = "VortexVisualsOverlay"
    VisualsGui.ResetOnSpawn = false
    VisualsGui.Parent = UI_PARENT

    -- Crosshair (Dot)
    local CrossDot = Instance.new("Frame", VisualsGui)
    CrossDot.Size = UDim2.new(0, 4, 0, 4)
    CrossDot.Position = UDim2.new(0.5, -2, 0.5, -2)
    CrossDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CrossDot.BorderSizePixel = 0
    CrossDot.Visible = false
    Instance.new("UICorner", CrossDot).CornerRadius = UDim.new(1, 0)

    -- FOV Circle UI Element
    local FOVCircleGui = Instance.new("Frame", VisualsGui)
    FOVCircleGui.BackgroundTransparency = 1
    FOVCircleGui.AnchorPoint = Vector2.new(0.5, 0.5)
    FOVCircleGui.Position = UDim2.new(0.5, 0, 0.5, 0)
    FOVCircleGui.Visible = false
    local FOVStroke = Instance.new("UIStroke", FOVCircleGui)
    FOVStroke.Color = Color3.fromRGB(140, 50, 255)
    FOVStroke.Thickness = 1.5

    -- Watermark
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

    -- Keybinds Window
    local KbFrame = Instance.new("Frame", VisualsGui)
    KbFrame.Size = UDim2.new(0, 180, 0, 32)
    KbFrame.Position = UDim2.new(0, 15, 0, 55)
    KbFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    KbFrame.BorderSizePixel = 0
    KbFrame.ClipsDescendants = true
    Instance.new("UICorner", KbFrame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", KbFrame).Color = Color3.fromRGB(45, 45, 60)

    local KbTitle = Instance.new("TextLabel", KbFrame)
    KbTitle.Size = UDim2.new(1, -20, 0, 30)
    KbTitle.Position = UDim2.new(0, 10, 0, 0)
    KbTitle.BackgroundTransparency = 1
    KbTitle.Text = "KEYBINDS"
    KbTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
    KbTitle.Font = Enum.Font.GothamBold
    KbTitle.TextSize = 11
    KbTitle.TextXAlignment = Enum.TextXAlignment.Left

    local Container = Instance.new("Frame", KbFrame)
    Container.Size = UDim2.new(1, -20, 1, -32)
    Container.Position = UDim2.new(0, 10, 0, 30)
    Container.BackgroundTransparency = 1

    local KbList = Instance.new("UIListLayout", Container)
    KbList.SortOrder = Enum.SortOrder.LayoutOrder
    KbList.Padding = UDim.new(0, 5)

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
                    item.NameLbl.TextColor3 = Color3.fromRGB(120, 120, 130)
                    item.BindLbl.TextColor3 = Color3.fromRGB(120, 120, 130)
                end
            else
                item.Frame.Visible = false
            end
        end
        local targetHeight = count > 0 and (35 + (count * 20)) or 32
        TweenService:Create(KbFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 180, 0, targetHeight)}):Play()
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

    -- ==================== TABS ====================
    local Tabs = {
        Combat = Window:AddTab({ Title = "Combat", Icon = "sword" }),
        Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
        Player = Window:AddTab({ Title = "Player", Icon = "user" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
    }

    local Features = {
        AutoDagger = false,
        Aimbot = false,
        AimbotSmooth = 5,
        AimbotFOV = 150,
        ESP_Players = false,
        ESP_Objects = false,
        ESP_KillerColor = Color3.fromRGB(239, 68, 68),
        ESP_SurvivorColor = Color3.fromRGB(34, 197, 94),
        ESP_ObjectColor = Color3.fromRGB(234, 179, 8),
        SpeedHack = false,
        SpeedValue = 16,
        RiceHat = false,
        RedStainVisual = false,
        AutoSkillCheck = false,
        FOVChanger = false,
        FOVValue = 70,
        Crosshair = false,
        Moonwalk = false,
        Spin360Left = false,
        Spin360Right = false
    }

    -- COMBAT
    local ToggleDagger = Tabs.Combat:AddToggle("AutoDagger", {Title = "Auto Dagger / Parry", Default = false})
    ToggleDagger:OnChanged(function(Val) Features.AutoDagger = Val; SetKeybindState("Auto Dagger", nil, Val) end)
    Tabs.Combat:AddKeybind("AutoDaggerKey", {
        Title = "Auto Dagger Key", Mode = "Toggle", Default = "NONE",
        Callback = function(Val) ToggleDagger:SetValue(Val) end,
        ChangedCallback = function(NewBind) SetKeybindState("Auto Dagger", NewBind, Features.AutoDagger) end
    })

    Tabs.Combat:AddDivider()

    local ToggleAimbot = Tabs.Combat:AddToggle("RevolverAimbot", {Title = "Revolver Smooth Aimbot", Default = false})
    ToggleAimbot:OnChanged(function(Val) Features.Aimbot = Val; SetKeybindState("Revolver Aimbot", nil, Val); FOVCircleGui.Visible = Val end)
    Tabs.Combat:AddKeybind("AimbotKey", {
        Title = "Aimbot Key", Mode = "Toggle", Default = "NONE",
        Callback = function(Val) ToggleAimbot:SetValue(Val) end,
        ChangedCallback = function(NewBind) SetKeybindState("Revolver Aimbot", NewBind, Features.Aimbot) end
    })
    Tabs.Combat:AddSlider("AimbotSmooth", {Title = "Aimbot Smoothness", Default = 5, Min = 1, Max = 20, Rounding = 1, Callback = function(Val) Features.AimbotSmooth = Val end})
    Tabs.Combat:AddSlider("AimbotFOV", {Title = "Aimbot FOV Radius", Default = 150, Min = 50, Max = 400, Rounding = 1, Callback = function(Val) 
        Features.AimbotFOV = Val
        FOVCircleGui.Size = UDim2.new(0, Val * 2, 0, Val * 2)
    end})

    -- VISUALS
    local TogglePlayers = Tabs.Visuals:AddToggle("ESP_Players", {Title = "Player / Killer ESP", Default = false})
    TogglePlayers:OnChanged(function(Val) Features.ESP_Players = Val; SetKeybindState("Player ESP", nil, Val) end)
    Tabs.Visuals:AddKeybind("ESPKey", {
        Title = "Toggle ESP Key", Mode = "Toggle", Default = "NONE",
        Callback = function(Val) TogglePlayers:SetValue(Val) end,
        ChangedCallback = function(NewBind) SetKeybindState("Player ESP", NewBind, Features.ESP_Players) end
    })

    local ToggleObjects = Tabs.Visuals:AddToggle("ESP_Objects", {Title = "Pallets & Windows ESP", Default = false})
    ToggleObjects:OnChanged(function(Val) Features.ESP_Objects = Val; SetKeybindState("Objects ESP", nil, Val) end)

    Tabs.Visuals:AddColorpicker("KillerColor", {Title = "Killer ESP Color", Default = Color3.fromRGB(239, 68, 68), Callback = function(Val) Features.ESP_KillerColor = Val end})
    Tabs.Visuals:AddColorpicker("SurvivorColor", {Title = "Survivor ESP Color", Default = Color3.fromRGB(34, 197, 94), Callback = function(Val) Features.ESP_SurvivorColor = Val end})
    Tabs.Visuals:AddColorpicker("ObjectColor", {Title = "Pallets/Windows Color", Default = Color3.fromRGB(234, 179, 8), Callback = function(Val) Features.ESP_ObjectColor = Val end})

    local ToggleFOV = Tabs.Visuals:AddToggle("FOVChangerToggle", {Title = "FOV Changer", Default = false})
    ToggleFOV:OnChanged(function(Val) Features.FOVChanger = Val end)
    Tabs.Visuals:AddSlider("FOVValue", {Title = "FOV Amount", Default = 70, Min = 70, Max = 120, Rounding = 1, Callback = function(Val) Features.FOVValue = Val end})

    local ToggleCross = Tabs.Visuals:AddToggle("CrosshairToggle", {Title = "Center Dot Crosshair", Default = false})
    ToggleCross:OnChanged(function(Val) Features.Crosshair = Val; CrossDot.Visible = Val end)

    local ToggleHat = Tabs.Visuals:AddToggle("RiceHatToggle", {Title = "3D Chinese Hat", Default = false})
    ToggleHat:OnChanged(function(Val) Features.RiceHat = Val end)

    local ToggleRedStain = Tabs.Visuals:AddToggle("RedStainToggle", {Title = "Killer Red Stain (Vision Light)", Default = false})
    ToggleRedStain:OnChanged(function(Val) Features.RedStainVisual = Val end)

    -- PLAYER (AI ASSISTANT: MOONWALK & 360)
    local ToggleSkillCheck = Tabs.Player:AddToggle("AutoSkillCheckToggle", {Title = "Auto Skill Checks", Default = false})
    ToggleSkillCheck:OnChanged(function(Val) Features.AutoSkillCheck = Val; SetKeybindState("Auto SkillCheck", nil, Val) end)

    local ToggleMoonwalk = Tabs.Player:AddToggle("MoonwalkToggle", {Title = "AI Assistant: Moonwalk (Auto A+D Tap)", Default = false})
    ToggleMoonwalk:OnChanged(function(Val) Features.Moonwalk = Val; SetKeybindState("AI Moonwalk", nil, Val) end)
    Tabs.Player:AddKeybind("MoonwalkKey", {
        Title = "Moonwalk Bind", Mode = "Toggle", Default = "NONE",
        Callback = function(Val) ToggleMoonwalk:SetValue(Val) end,
        ChangedCallback = function(NewBind) SetKeybindState("AI Moonwalk", NewBind, Features.Moonwalk) end
    })

    local ToggleSpinL = Tabs.Player:AddToggle("Spin360LToggle", {Title = "AI Assistant: 360 Spin Left (W+D+S+A)", Default = false})
    ToggleSpinL:OnChanged(function(Val) Features.Spin360Left = Val; SetKeybindState("360 Left", nil, Val) end)
    Tabs.Player:AddKeybind("SpinLKey", {
        Title = "360 Left Bind", Mode = "Toggle", Default = "NONE",
        Callback = function(Val) ToggleSpinL:SetValue(Val) end,
        ChangedCallback = function(NewBind) SetKeybindState("360 Left", NewBind, Features.Spin360Left) end
    })

    local ToggleSpinR = Tabs.Player:AddToggle("Spin360RToggle", {Title = "AI Assistant: 360 Spin Right (W+A+S+D)", Default = false})
    ToggleSpinR:OnChanged(function(Val) Features.Spin360Right = Val; SetKeybindState("360 Right", nil, Val) end)
    Tabs.Player:AddKeybind("SpinRKey", {
        Title = "360 Right Bind", Mode = "Toggle", Default = "NONE",
        Callback = function(Val) ToggleSpinR:SetValue(Val) end,
        ChangedCallback = function(NewBind) SetKeybindState("360 Right", NewBind, Features.Spin360Right) end
    })

    local ToggleSpeed = Tabs.Player:AddToggle("SpeedHack", {Title = "SpeedHack", Default = false})
    ToggleSpeed:OnChanged(function(Val) Features.SpeedHack = Val; SetKeybindState("SpeedHack", nil, Val) end)
    Tabs.Player:AddKeybind("SpeedKey", {
        Title = "Speed Key", Mode = "Toggle", Default = "NONE",
        Callback = function(Val) ToggleSpeed:SetValue(Val) end,
        ChangedCallback = function(NewBind) SetKeybindState("SpeedHack", NewBind, Features.SpeedHack) end
    })
    Tabs.Player:AddSlider("SpeedValue", {Title = "Speed Multiplier", Default = 16, Min = 16, Max = 40, Rounding = 1, Callback = function(Val) Features.SpeedValue = Val end})

    -- ==================== AI ASSISTANT LOGIC (MOONWALK & 360) ====================
    task.spawn(function()
        local lastTap = tick()
        local tapToggle = false
        while task.wait(0.01) do
            pcall(function()
                -- Мунволк: когда зажата W или включен бинд мунволка, персонаж повернут к камере лицом, тапаем A-D
                if Features.Moonwalk and UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        -- Разворачиваем персонажа лицом к экрану (относительно камеры)
                        local camLook = Camera.CFrame.LookVector
                        local flatLook = Vector3.new(camLook.X, 0, camLook.Z).Unit
                        char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position, char.HumanoidRootPart.Position - flatLook)
                        
                        -- Тапаем A и D для удержания траектории
                        if tick() - lastTap >= 0.08 then
                            tapToggle = not tapToggle
                            if tapToggle then
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.A, false, game)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.D, false, game)
                            else
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.D, false, game)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.A, false, game)
                            end
                            lastTap = tick()
                        end
                    end
                end

                -- 360 Spin Left (W -> D -> S -> A быстрое вращение камеры + клавиши)
                if Features.Spin360Left then
                    Camera.CFrame = Camera.CFrame * CFrame.Angles(0, math.rad(-25), 0)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.D, false, game)
                    task.wait(0.02)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.S, false, game)
                    task.wait(0.02)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.D, false, game)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.A, false, game)
                    task.wait(0.02)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.S, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.A, false, game)
                end

                -- 360 Spin Right (W -> A -> S -> D быстрое вращение камеры + клавиши)
                if Features.Spin360Right then
                    Camera.CFrame = Camera.CFrame * CFrame.Angles(0, math.rad(25), 0)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.A, false, game)
                    task.wait(0.02)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.S, false, game)
                    task.wait(0.02)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.A, false, game)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.D, false, game)
                    task.wait(0.02)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.S, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.D, false, game)
                end
            end)
        end
    end)

    -- ==================== AIMBOT (REVOLVER VISIBLE TARGET) ====================
    RunService.RenderStepped:Connect(function()
        if Features.Aimbot then
            local closestTarget = nil
            local shortestDist = Features.AimbotFOV
            local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local isKiller = (p.Team and p.Team.Name:lower():find("killer")) or (p.Character:FindFirstChild("Killer"))
                    if isKiller then
                        local head = p.Character.Head
                        local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                        if onScreen then
                            -- Проверка луча видимости (Raycast), чтобы убийца был в поле зрения без стен
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {LocalPlayer.Character, p.Character}
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            local rayResult = workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position), rayParams)

                            if not rayResult then
                                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                                if dist < shortestDist then
                                    shortestDist = dist
                                    closestTarget = head
                                end
                            end
                        end
                    end
                end
            end

            if closestTarget then
                local targetCFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / Features.AimbotSmooth)
            end
        end
    end)

    -- ==================== VISUALS THREAD (HAT & RED STAIN) ====================
    task.spawn(function()
        while task.wait(0.3) do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                local char = LocalPlayer.Character
                local head = char.Head
                local existingHat = char:FindFirstChild("VortexRiceHat")

                if Features.RiceHat then
                    if not existingHat then
                        local hat = Instance.new("Part")
                        hat.Name = "VortexRiceHat"
                        hat.Size = Vector3.new(3, 0.7, 3)
                        hat.CanCollide = false
                        hat.Massless = true
                        hat.Color = Color3.fromRGB(140, 50, 255)
                        hat.Material = Enum.Material.SmoothPlastic
                        
                        local mesh = Instance.new("SpecialMesh", hat)
                        mesh.MeshType = Enum.MeshType.Cone
                        mesh.Scale = Vector3.new(3, 0.7, 3)

                        local weld = Instance.new("WeldConstraint")
                        weld.Part0 = head
                        weld.Part1 = hat
                        hat.CFrame = head.CFrame * CFrame.new(0, 0.75, 0)
                        weld.Parent = hat
                        hat.Parent = char
                    end
                else
                    if existingHat then existingHat:Destroy() end
                end
            end

            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("Head") then
                    local isKiller = (p.Team and p.Team.Name:lower():find("killer")) or (p.Character:FindFirstChild("Killer"))
                    local existingStain = p.Character.Head:FindFirstChild("VortexRedStain")

                    if Features.RedStainVisual and isKiller then
                        if not existingStain then
                            local light = Instance.new("SpotLight")
                            light.Name = "VortexRedStain"
                            light.Color = Color3.fromRGB(255, 0, 0)
                            light.Brightness = 8
                            light.Range = 25
                            light.Angle = 60
                            light.Face = Enum.NormalId.Front
                            light.Parent = p.Character.Head
                        end
                    else
                        if existingStain then existingStain:Destroy() end
                    end
                end
            end
        end
    end)

    -- ==================== AUTO SKILL CHECK SYSTEM ====================
    task.spawn(function()
        while task.wait(0.05) do
            if Features.AutoSkillCheck then
                pcall(function()
                    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                    if pGui then
                        for _, gui in pairs(pGui:GetChildren()) do
                            if gui:IsA("ScreenGui") and gui.Enabled then
                                local skillCheckFrame = gui:FindFirstChild("SkillCheck") or gui:FindFirstChild("Check") or gui:FindFirstChild("Bar")
                                if skillCheckFrame then
                                    local pointer = skillCheckFrame:FindFirstChild("Pointer") or skillCheckFrame:FindFirstChild("Indicator")
                                    local target = skillCheckFrame:FindFirstChild("Zone") or skillCheckFrame:FindFirstChild("Success")
                                    
                                    if pointer and target then
                                        local pPos = pointer.AbsolutePosition.X
                                        local tPos = target.AbsolutePosition.X
                                        local tSize = target.AbsoluteSize.X
                                        
                                        if pPos >= tPos and pPos <= (tPos + tSize) then
                                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                                            task.wait(0.05)
                                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                                            task.wait(0.3)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    -- ==================== RENDER LOOP & ESP (PLAYERS + OBJECTS) ====================
    local ESP_Cache = {}
    local Object_ESP_Cache = {}

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

    local function ApplyObjectESP(inst, color)
        local hl = Object_ESP_Cache[inst]
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = "Vortex_ObjESP"
            hl.FillTransparency = 0.4
            hl.OutlineTransparency = 0
            hl.Parent = inst
            Object_ESP_Cache[inst] = hl
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

        if Features.FOVChanger then
            Camera.FieldOfView = Features.FOVValue
        end

        if Features.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Features.SpeedValue
        end

        -- Player ESP
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

        -- Pallets and Windows ESP (Search workspace for items)
        if Features.ESP_Objects then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") or obj:IsA("BasePart") then
                    local name = obj.Name:lower()
                    if name:find("pallet") or name:find("window") or name:find("board") or name:find("vault") then
                        ApplyObjectESP(obj, Features.ESP_ObjectColor)
                    end
                end
            end
        else
            for _, hl in pairs(Object_ESP_Cache) do
                hl.Enabled = false
            end
        end
    end)

    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)

    Window:SelectTab(1)
end

-- ====================================================================--
--                            STARTUP                                  --
--===================================================================--

ShowKeySystem(function(key, keyType)
    LoadMainVortexHub(key, keyType)
end)
