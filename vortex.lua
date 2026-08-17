--====================================================================--
--                        VORTEX HUB - VIOLENCE DISTRICT               --
--====================================================================--

local TweenService = game:GetService("TweenService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local HWID = RbxAnalyticsService:GetClientId()
local KeyFileName = "VortexHub_Key.json"

-- База данных ключей (Key Database)
local KeyDatabase = {
    ["admin2013"] = { type = "Admin", duration = 99999999 },
    
    -- 1 Day Keys
    ["VTX-1D-8F92A"] = { type = "1 Day Pass", duration = 86400 },
    ["VTX-1D-3K71P"] = { type = "1 Day Pass", duration = 86400 },
    ["VTX-1D-9M24L"] = { type = "1 Day Pass", duration = 86400 },

    -- 30 Days Keys
    ["VTX-30D-92KF8"] = { type = "30 Days VIP", duration = 2592000 },
    ["VTX-30D-17PQ3"] = { type = "30 Days VIP", duration = 2592000 }
}

-- Хранилище сохраненных данных
local HttpService = game:GetService("HttpService")
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
        local data = { Key = key, HWID = hwid, ActivatedAt = activationTime }
        writefile(KeyFileName, HttpService:JSONEncode(data))
    end
end

-- ====================================================================--
--                       LOADING SCREEN UI                            --
--===================================================================--

local function ShowLoadingScreen(callback)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VortexLoadingUI"
    ScreenGui.Parent = (gethui and gethui()) or CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 380, 0, 220)
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -110)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    local UIStroke = Instance.new("UIStroke", MainFrame)
    UIStroke.Color = Color3.fromRGB(140, 50, 255)
    UIStroke.Thickness = 2

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 20)
    Title.Text = "VORTEX HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 26
    Title.Font = Enum.Font.GothamBold
    Title.BackgroundTransparency = 1

    local SubTitle = Instance.new("TextLabel", MainFrame)
    SubTitle.Size = UDim2.new(1, 0, 0, 20)
    SubTitle.Position = UDim2.new(0, 0, 0, 55)
    SubTitle.Text = "Violence District Edition"
    SubTitle.TextColor3 = Color3.fromRGB(160, 160, 200)
    SubTitle.TextSize = 14
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.BackgroundTransparency = 1

    local Status = Instance.new("TextLabel", MainFrame)
    Status.Size = UDim2.new(1, 0, 0, 20)
    Status.Position = UDim2.new(0, 0, 0, 110)
    Status.Text = "Initializing Vortex System..."
    Status.TextColor3 = Color3.fromRGB(200, 200, 200)
    Status.TextSize = 13
    Status.Font = Enum.Font.GothamMedium
    Status.BackgroundTransparency = 1

    local BarBackground = Instance.new("Frame", MainFrame)
    BarBackground.Size = UDim2.new(0.8, 0, 0, 8)
    BarBackground.Position = UDim2.new(0.1, 0, 0, 145)
    BarBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    BarBackground.BorderSizePixel = 0

    Instance.new("UICorner", BarBackground).CornerRadius = UDim.new(1, 0)

    local BarFill = Instance.new("Frame", BarBackground)
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(140, 50, 255)
    BarFill.BorderSizePixel = 0

    Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

    task.spawn(function()
        local stages = {
            { p = 0.3, t = "Bypassing Security..." },
            { p = 0.6, t = "Verifying HWID & License..." },
            { p = 0.9, t = "Injecting Modules..." },
            { p = 1.0, t = "Ready!" }
        }

        for _, stage in ipairs(stages) do
            Status.Text = stage.t
            TweenService:Create(BarFill, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Size = UDim2.new(stage.p, 0, 1, 0)}):Play()
            task.wait(0.4)
        end

        task.wait(0.2)
        ScreenGui:Destroy()
        callback()
    end)
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
            if keyInfo then
                local elapsed = currentTime - savedData.ActivatedAt
                if elapsed < keyInfo.duration then
                    onSuccess(savedData.Key, keyInfo.type)
                    return
                end
            end
        end
    end

    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "VortexKeySystem"
    KeyGui.Parent = (gethui and gethui()) or CoreGui

    local Frame = Instance.new("Frame", KeyGui)
    Frame.Size = UDim2.new(0, 360, 0, 240)
    Frame.Position = UDim2.new(0.5, -180, 0.5, -120)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    Frame.BorderSizePixel = 0

    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = Color3.fromRGB(140, 50, 255)
    Stroke.Thickness = 1.5

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 15)
    Title.Text = "VORTEX KEY SYSTEM"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.BackgroundTransparency = 1

    local Sub = Instance.new("TextLabel", Frame)
    Sub.Size = UDim2.new(1, -40, 0, 30)
    Sub.Position = UDim2.new(0, 20, 0, 50)
    Sub.Text = "Enter your license key below to unlock Vortex Hub."
    Sub.TextColor3 = Color3.fromRGB(160, 160, 180)
    Sub.TextSize = 12
    Sub.TextWrapped = true
    Sub.Font = Enum.Font.Gotham
    Sub.BackgroundTransparency = 1

    local TextBox = Instance.new("TextBox", Frame)
    TextBox.Size = UDim2.new(0.8, 0, 0, 38)
    TextBox.Position = UDim2.new(0.1, 0, 0, 95)
    TextBox.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.PlaceholderText = "Paste Key Here..."
    TextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
    TextBox.Text = ""
    TextBox.Font = Enum.Font.GothamMedium
    TextBox.TextSize = 14
    Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)

    local SubmitBtn = Instance.new("TextButton", Frame)
    SubmitBtn.Size = UDim2.new(0.8, 0, 0, 38)
    SubmitBtn.Position = UDim2.new(0.1, 0, 0, 150)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 240)
    SubmitBtn.Text = "SUBMIT KEY"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.TextSize = 14
    Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 6)

    local StatusLabel = Instance.new("TextLabel", Frame)
    StatusLabel.Size = UDim2.new(1, 0, 0, 20)
    StatusLabel.Position = UDim2.new(0, 0, 0, 200)
    StatusLabel.Text = ""
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.BackgroundTransparency = 1

    SubmitBtn.MouseButton1Click:Connect(function()
        local inputKey = TextBox.Text:gsub("%s+", "")
        local keyData = KeyDatabase[inputKey]

        if keyData then
            SaveData(inputKey, HWID, os.time())
            StatusLabel.TextColor3 = Color3.fromRGB(50, 255, 120)
            StatusLabel.Text = "Access Granted! Loading Vortex..."
            task.wait(0.5)
            KeyGui:Destroy()
            onSuccess(inputKey, keyData.type)
        else
            StatusLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
            StatusLabel.Text = "Invalid or Expired License Key!"
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
        SubTitle = "License: " .. keyType,
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = false,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.RightControl
    })

    -- ==================== DRAGGABLE GUI WATERMARK ====================
    local WatermarkGui = Instance.new("ScreenGui")
    WatermarkGui.Name = "VortexWatermarkGui"
    WatermarkGui.Parent = (gethui and gethui()) or CoreGui

    local WmMain = Instance.new("Frame", WatermarkGui)
    WmMain.Size = UDim2.new(0, 210, 0, 36)
    WmMain.Position = UDim2.new(0, 20, 0, 20)
    WmMain.BackgroundColor3 = Color3.fromRGB(15, 15, 23)
    WmMain.BorderSizePixel = 0

    Instance.new("UICorner", WmMain).CornerRadius = UDim.new(0, 8)
    local WmStroke = Instance.new("UIStroke", WmMain)
    WmStroke.Color = Color3.fromRGB(140, 50, 255)
    WmStroke.Thickness = 1.5

    local WmTitle = Instance.new("TextLabel", WmMain)
    WmTitle.Size = UDim2.new(0, 110, 1, 0)
    WmTitle.Position = UDim2.new(0, 12, 0, 0)
    WmTitle.BackgroundTransparency = 1
    WmTitle.Text = "VORTEX HUB"
    WmTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    WmTitle.Font = Enum.Font.GothamBold
    WmTitle.TextSize = 13
    WmTitle.TextXAlignment = Enum.TextXAlignment.Left

    local WmFPS = Instance.new("TextLabel", WmMain)
    WmFPS.Size = UDim2.new(0, 70, 1, 0)
    WmFPS.Position = UDim2.new(1, -82, 0, 0)
    WmFPS.BackgroundTransparency = 1
    WmFPS.Text = "FPS: --"
    WmFPS.TextColor3 = Color3.fromRGB(160, 160, 200)
    WmFPS.Font = Enum.Font.GothamMedium
    WmFPS.TextSize = 12
    WmFPS.TextXAlignment = Enum.TextXAlignment.Right

    -- Перетаскивание Gui Ватермарки
    local dragging, dragInput, dragStart, startPos
    WmMain.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = WmMain.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    WmMain.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            WmMain.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- ==================== KEYBINDS DISPLAY UI ====================
    local KeybindsGui = Instance.new("ScreenGui")
    KeybindsGui.Name = "VortexKeybindsUI"
    KeybindsGui.Parent = (gethui and gethui()) or CoreGui

    local KbFrame = Instance.new("Frame", KeybindsGui)
    KbFrame.Size = UDim2.new(0, 170, 0, 180)
    KbFrame.Position = UDim2.new(1, -190, 0.5, -90)
    KbFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 23)
    KbFrame.BorderSizePixel = 0

    Instance.new("UICorner", KbFrame).CornerRadius = UDim.new(0, 10)
    local KbStroke = Instance.new("UIStroke", KbFrame)
    KbStroke.Color = Color3.fromRGB(140, 50, 255)
    KbStroke.Thickness = 1.5

    local KbTitle = Instance.new("TextLabel", KbFrame)
    KbTitle.Size = UDim2.new(1, 0, 0, 28)
    KbTitle.BackgroundTransparency = 1
    KbTitle.Text = "KEYBINDS"
    KbTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    KbTitle.Font = Enum.Font.GothamBold
    KbTitle.TextSize = 13

    local KbList = Instance.new("UIListLayout", KbFrame)
    KbList.SortOrder = Enum.SortOrder.LayoutOrder
    KbList.Padding = UDim.new(0, 4)

    local KbPadding = Instance.new("UIPadding", KbFrame)
    KbPadding.PaddingTop = UDim.new(0, 32)
    KbPadding.PaddingLeft = UDim.new(0, 10)
    KbPadding.PaddingRight = UDim.new(0, 10)

    -- Перетаскивание Квадратного Окна Биндов
    local kbDragging, kbDragInput, kbDragStart, kbStartPos
    KbFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            kbDragging = true
            kbDragStart = input.Position
            kbStartPos = KbFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then kbDragging = false end
            end)
        end
    end)
    KbFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            kbDragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == kbDragInput and kbDragging then
            local delta = input.Position - kbDragStart
            KbFrame.Position = UDim2.new(kbStartPos.X.Scale, kbStartPos.X.Offset + delta.X, kbStartPos.Y.Scale, kbStartPos.Y.Offset + delta.Y)
        end
    end)

    local KeybindEntries = {}
    local function AddKeybindWidget(name, bindText)
        local Label = Instance.new("TextLabel", KbFrame)
        Label.Size = UDim2.new(1, 0, 0, 18)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 11
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Text = name .. " [" .. bindText .. "]"
        Label.TextColor3 = Color3.fromRGB(90, 90, 110) -- По умолчанию тусклый
        KeybindEntries[name] = Label
    end

    local function UpdateKeybindWidget(name, active, bindText)
        if KeybindEntries[name] then
            KeybindEntries[name].Text = name .. " [" .. (bindText or "NONE") .. "]"
            if active then
                KeybindEntries[name].TextColor3 = Color3.fromRGB(220, 220, 255) -- Яркий активный
            else
                KeybindEntries[name].TextColor3 = Color3.fromRGB(90, 90, 110) -- Тусклый выключенный
            end
        end
    end

    AddKeybindWidget("Auto Dagger", "NONE")
    AddKeybindWidget("ESP Players", "NONE")
    AddKeybindWidget("SpeedHack", "NONE")

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
        DaggerDistance = 12,
        ESP_Players = false,
        ESP_KillerColor = Color3.fromRGB(255, 50, 50),
        ESP_SurvivorColor = Color3.fromRGB(50, 255, 100),
        ESP_Generators = false,
        ESP_Spikes = false,
        SpeedHack = false,
        SpeedValue = 16,
        AutoSkillCheck = false,
        Fullbright = false,
        RiceHat = false,
        CartoonKillerCone = false
    }

    -- TAB: COMBAT
    local ToggleDagger = Tabs.Combat:AddToggle("AutoDagger", {Title = "Auto Dagger / Parry", Default = false})
    ToggleDagger:OnChanged(function(Value)
        Features.AutoDagger = Value
        UpdateKeybindWidget("Auto Dagger", Value)
    end)

    Tabs.Combat:AddKeybind("AutoDaggerKey", {
        Title = "Auto Dagger Keybind",
        Mode = "Toggle",
        Default = "NONE",
        Callback = function(Value, Bind)
            ToggleDagger:SetValue(Value)
            UpdateKeybindWidget("Auto Dagger", Value, tostring(Bind))
        end
    })

    Tabs.Combat:AddSlider("DaggerDist", {
        Title = "Trigger Distance (Studs)",
        Default = 12,
        Min = 5,
        Max = 20,
        Rounding = 1,
        Callback = function(Value) Features.DaggerDistance = Value end
    })

    -- TAB: VISUALS
    local TogglePlayers = Tabs.Visuals:AddToggle("ESP_Players", {Title = "Player / Killer ESP", Default = false})
    TogglePlayers:OnChanged(function(Value)
        Features.ESP_Players = Value
        UpdateKeybindWidget("ESP Players", Value)
    end)

    Tabs.Visuals:AddKeybind("ESPKey", {
        Title = "Toggle ESP Keybind",
        Mode = "Toggle",
        Default = "NONE",
        Callback = function(Value, Bind)
            TogglePlayers:SetValue(Value)
            UpdateKeybindWidget("ESP Players", Value, tostring(Bind))
        end
    })

    local KillerColorPicker = Tabs.Visuals:AddColorpicker("KillerColor", {
        Title = "Killer ESP Color",
        Default = Color3.fromRGB(255, 50, 50)
    })
    KillerColorPicker:OnChanged(function(Value) Features.ESP_KillerColor = Value end)

    local SurvivorColorPicker = Tabs.Visuals:AddColorpicker("SurvivorColor", {
        Title = "Survivor ESP Color",
        Default = Color3.fromRGB(50, 255, 100)
    })
    SurvivorColorPicker:OnChanged(function(Value) Features.ESP_SurvivorColor = Value end)

    local ToggleHat = Tabs.Visuals:AddToggle("RiceHatToggle", {Title = "Chinese Rice Hat (3D)", Default = false})
    ToggleHat:OnChanged(function(Value) Features.RiceHat = Value end)

    local ToggleCartoonCone = Tabs.Visuals:AddToggle("CartoonConeToggle", {Title = "Cartoon Killer Vision Lines", Default = false})
    ToggleCartoonCone:OnChanged(function(Value) Features.CartoonKillerCone = Value end)

    local ToggleGens = Tabs.Visuals:AddToggle("ESP_Gens", {Title = "Generators ESP", Default = false})
    ToggleGens:OnChanged(function(Value) Features.ESP_Generators = Value end)

    local ToggleSpikes = Tabs.Visuals:AddToggle("ESP_Spikes", {Title = "Spikes ESP", Default = false})
    ToggleSpikes:OnChanged(function(Value) Features.ESP_Spikes = Value end)

    -- TAB: PLAYER
    local ToggleSpeed = Tabs.Player:AddToggle("SpeedHack", {Title = "Enable Speed", Default = false})
    ToggleSpeed:OnChanged(function(Value)
        Features.SpeedHack = Value
        UpdateKeybindWidget("SpeedHack", Value)
    end)

    Tabs.Player:AddKeybind("SpeedKey", {
        Title = "Speed Keybind",
        Mode = "Toggle",
        Default = "NONE",
        Callback = function(Value, Bind)
            ToggleSpeed:SetValue(Value)
            UpdateKeybindWidget("SpeedHack", Value, tostring(Bind))
        end
    })

    Tabs.Player:AddSlider("SpeedValue", {
        Title = "Speed Multiplier",
        Default = 16,
        Min = 16,
        Max = 40,
        Rounding = 1,
        Callback = function(Value) Features.SpeedValue = Value end
    })

    -- TAB: AUTOMATION
    local ToggleSkill = Tabs.Automation:AddToggle("AutoSkill", {Title = "Auto SkillCheck", Default = false})
    ToggleSkill:OnChanged(function(Value) Features.AutoSkillCheck = Value end)

    -- ==================== OPTIMIZED ESP & VISUAL LOGIC ====================
    local ESP_Storage = {}
    local function ApplyHighlight(inst, col)
        if not inst then return end
        local hl = ESP_Storage[inst]
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = "Vortex_ESP"
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            hl.Parent = inst
            ESP_Storage[inst] = hl
        end
        hl.Adornee = inst
        hl.FillColor = col
        hl.Enabled = true
    end

    local function ClearHighlight(inst)
        if ESP_Storage[inst] then
            ESP_Storage[inst].Enabled = false
        end
    end

    -- CHINESE RICE HAT LOGIC
    local function UpdateRiceHat()
        local char = LocalPlayer.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end

        local hat = char:FindFirstChild("VortexRiceHat")
        if Features.RiceHat then
            if not hat then
                hat = Instance.new("Part")
                hat.Name = "VortexRiceHat"
                hat.Size = Vector3.new(3, 0.7, 3)
                hat.CanCollide = false
                hat.Massless = true
                hat.Color = Color3.fromRGB(140, 50, 255)
                
                local mesh = Instance.new("SpecialMesh", hat)
                mesh.MeshType = Enum.MeshType.Cone
                mesh.Scale = Vector3.new(3, 0.7, 3)

                local weld = Instance.new("Weld", hat)
                weld.Part0 = head
                weld.Part1 = hat
                weld.C0 = CFrame.new(0, 0.85, 0)
                hat.Parent = char
            end
        else
            if hat then hat:Destroy() end
        end
    end

    -- CARTOON KILLER VISION LINES
    local CartoonRings = {}
    local function UpdateCartoonVision(killerChar)
        if not Features.CartoonKillerCone or not killerChar then
            for _, ring in pairs(CartoonRings) do ring.Visible = false end
            return
        end

        local head = killerChar:FindFirstChild("Head")
        if not head then return end

        for i = 1, 3 do
            local ring = CartoonRings[i]
            if not ring then
                ring = Instance.new("SelectionBox")
                ring.Color3 = Color3.fromRGB(255, 120, 0)
                ring.LineThickness = 0.05
                ring.Parent = workspace
                CartoonRings[i] = ring
            end
            
            ring.Adornee = head
            ring.Visible = true
        end
    end

    -- MAIN LOOP & FPS TRACKER
    local lastFpsTime = os.clock()
    local frameCount = 0

    RunService.RenderStepped:Connect(function()
        -- FPS Counter
        frameCount = frameCount + 1
        local now = os.clock()
        if now - lastFpsTime >= 1 then
            WmFPS.Text = "FPS: " .. tostring(math.floor(frameCount / (now - lastFpsTime)))
            frameCount = 0
            lastFpsTime = now
        end

        -- WalkSpeed
        if Features.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Features.SpeedValue
        end

        -- Player ESP Update
        if Features.ESP_Players then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local isKiller = p.Team and p.Team.Name:lower():find("killer")
                    local col = isKiller and Features.ESP_KillerColor or Features.ESP_SurvivorColor
                    ApplyHighlight(p.Character, col)

                    if isKiller and Features.CartoonKillerCone then
                        UpdateCartoonVision(p.Character)
                    end
                end
            end
        else
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character then ClearHighlight(p.Character) end
            end
            UpdateCartoonVision(nil)
        end

        -- Update Rice Hat Visual
        UpdateRiceHat()
    end)

    -- AUTOMATION LOOP
    task.spawn(function()
        while task.wait(0.1) do
            if Features.AutoSkillCheck then
                local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                if pGui then
                    for _, gui in pairs(pGui:GetChildren()) do
                        if gui.Name:lower():find("skill") or gui.Name:lower():find("generator") then
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                            task.wait(0.03)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                        end
                    end
                end
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
    Fluent:Notify({
        Title = "Vortex Hub Active",
        Content = "Hub Loaded Successfully!",
        Duration = 5
    })
end

-- ====================================================================--
--                            INIT VORTEX                               --
--===================================================================--

ShowLoadingScreen(function()
    VerifyKeyAccess(function(key, keyType)
        LoadMainVortexHub(key, keyType)
    end)
end)
