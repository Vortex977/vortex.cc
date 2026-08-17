--====================================================================--
--                        VORTEX HUB - VIOLENCE DISTRICT               --
--====================================================================--

local TweenService = game:GetService("TweenService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local HWID = RbxAnalyticsService:GetClientId()
local KeyFileName = "VortexHub_Key.json"

local KeyDatabase = {
    ["admin2013"] = { type = "Admin", duration = 99999999 },
    ["VTX-1D-8F92A"] = { type = "1 Day Pass", duration = 86400 },
    ["VTX-30D-92KF8"] = { type = "30 Days VIP", duration = 2592000 }
}

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
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = (gethui and gethui()) or CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 360, 0, 200)
    MainFrame.Position = UDim2.new(0.5, -180, 0.5, -100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    local UIStroke = Instance.new("UIStroke", MainFrame)
    UIStroke.Color = Color3.fromRGB(130, 60, 255)
    UIStroke.Thickness = 1.5

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.Position = UDim2.new(0, 0, 0, 20)
    Title.Text = "VORTEX HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBold
    Title.BackgroundTransparency = 1

    local Status = Instance.new("TextLabel", MainFrame)
    Status.Size = UDim2.new(1, 0, 0, 20)
    Status.Position = UDim2.new(0, 0, 0, 95)
    Status.Text = "Initializing..."
    Status.TextColor3 = Color3.fromRGB(170, 170, 200)
    Status.TextSize = 12
    Status.Font = Enum.Font.GothamMedium
    Status.BackgroundTransparency = 1

    local BarBackground = Instance.new("Frame", MainFrame)
    BarBackground.Size = UDim2.new(0.8, 0, 0, 6)
    BarBackground.Position = UDim2.new(0.1, 0, 0, 130)
    BarBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    BarBackground.BorderSizePixel = 0
    Instance.new("UICorner", BarBackground).CornerRadius = UDim.new(1, 0)

    local BarFill = Instance.new("Frame", BarBackground)
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(140, 50, 255)
    BarFill.BorderSizePixel = 0
    Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

    task.spawn(function()
        local stages = {
            { p = 0.4, t = "Authenticating..." },
            { p = 0.8, t = "Loading Interface..." },
            { p = 1.0, t = "Done!" }
        }
        for _, stage in ipairs(stages) do
            Status.Text = stage.t
            TweenService:Create(BarFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(stage.p, 0, 1, 0)}):Play()
            task.wait(0.3)
        end
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
            if keyInfo and (currentTime - savedData.ActivatedAt < keyInfo.duration) then
                onSuccess(savedData.Key, keyInfo.type)
                return
            end
        end
    end

    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "VortexKeySystem"
    KeyGui.ResetOnSpawn = false
    KeyGui.Parent = (gethui and gethui()) or CoreGui

    local Frame = Instance.new("Frame", KeyGui)
    Frame.Size = UDim2.new(0, 340, 0, 220)
    Frame.Position = UDim2.new(0.5, -170, 0.5, -110)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    Frame.BackgroundTransparency = 0.1
    Frame.BorderSizePixel = 0

    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = Color3.fromRGB(130, 60, 255)
    Stroke.Thickness = 1.5

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.Position = UDim2.new(0, 0, 0, 15)
    Title.Text = "LICENSE VERIFICATION"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.BackgroundTransparency = 1

    local TextBox = Instance.new("TextBox", Frame)
    TextBox.Size = UDim2.new(0.85, 0, 0, 36)
    TextBox.Position = UDim2.new(0.075, 0, 0, 75)
    TextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.PlaceholderText = "Enter License Key..."
    TextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
    TextBox.Text = ""
    TextBox.Font = Enum.Font.GothamMedium
    TextBox.TextSize = 13
    Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)

    local SubmitBtn = Instance.new("TextButton", Frame)
    SubmitBtn.Size = UDim2.new(0.85, 0, 0, 36)
    SubmitBtn.Position = UDim2.new(0.075, 0, 0, 125)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(130, 50, 255)
    SubmitBtn.Text = "UNLOCK HUB"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.TextSize = 13
    Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 6)

    local StatusLabel = Instance.new("TextLabel", Frame)
    StatusLabel.Size = UDim2.new(1, 0, 0, 20)
    StatusLabel.Position = UDim2.new(0, 0, 0, 175)
    StatusLabel.Text = ""
    StatusLabel.TextSize = 11
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.BackgroundTransparency = 1

    SubmitBtn.MouseButton1Click:Connect(function()
        local inputKey = TextBox.Text:gsub("%s+", "")
        local keyData = KeyDatabase[inputKey]

        if keyData then
            SaveData(inputKey, HWID, os.time())
            StatusLabel.TextColor3 = Color3.fromRGB(80, 255, 140)
            StatusLabel.Text = "Success! Loading Vortex..."
            task.wait(0.5)
            KeyGui:Destroy()
            onSuccess(inputKey, keyData.type)
        else
            StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            StatusLabel.Text = "Invalid License Key!"
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

    -- Вспомогательная функция создания стильных Fluent-виджетов
    local function CreateFluentWidget(name, size, pos)
        local Gui = Instance.new("ScreenGui")
        Gui.Name = name
        Gui.ResetOnSpawn = false
        Gui.Parent = (gethui and gethui()) or CoreGui

        local Frame = Instance.new("Frame", Gui)
        Frame.Size = size
        Frame.Position = pos
        Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        Frame.BackgroundTransparency = 0.25
        Frame.BorderSizePixel = 0

        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
        local Stroke = Instance.new("UIStroke", Frame)
        Stroke.Color = Color3.fromRGB(255, 255, 255)
        Stroke.Transparency = 0.88
        Stroke.Thickness = 1

        -- Функция перетаскивания
        local dragging, dragInput, dragStart, startPos
        Frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = Frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        Frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)

        return Frame
    end

    -- ==================== FLUENT WATERMARK ====================
    local WmFrame = CreateFluentWidget("VortexWatermark", UDim2.new(0, 210, 0, 30), UDim2.new(0, 20, 0, 20))

    local WmTitle = Instance.new("TextLabel", WmFrame)
    WmTitle.Size = UDim2.new(0, 110, 1, 0)
    WmTitle.Position = UDim2.new(0, 10, 0, 0)
    WmTitle.BackgroundTransparency = 1
    WmTitle.Text = "VORTEX HUB"
    WmTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    WmTitle.Font = Enum.Font.GothamBold
    WmTitle.TextSize = 12
    WmTitle.TextXAlignment = Enum.TextXAlignment.Left

    local WmFPS = Instance.new("TextLabel", WmFrame)
    WmFPS.Size = UDim2.new(0, 80, 1, 0)
    WmFPS.Position = UDim2.new(1, -90, 0, 0)
    WmFPS.BackgroundTransparency = 1
    WmFPS.Text = "FPS: --"
    WmFPS.TextColor3 = Color3.fromRGB(150, 150, 170)
    WmFPS.Font = Enum.Font.GothamMedium
    WmFPS.TextSize = 11
    WmFPS.TextXAlignment = Enum.TextXAlignment.Right

    -- ==================== FLUENT KEYBINDS UI ====================
    local KbFrame = CreateFluentWidget("VortexKeybinds", UDim2.new(0, 180, 0, 32), UDim2.new(0, 20, 0, 60))
    KbFrame.ClipsDescendants = true

    local KbTitle = Instance.new("TextLabel", KbFrame)
    KbTitle.Size = UDim2.new(1, -10, 0, 26)
    KbTitle.Position = UDim2.new(0, 10, 0, 2)
    KbTitle.BackgroundTransparency = 1
    KbTitle.Text = "KEYBINDS"
    KbTitle.TextColor3 = Color3.fromRGB(220, 220, 255)
    KbTitle.Font = Enum.Font.GothamBold
    KbTitle.TextSize = 11
    KbTitle.TextXAlignment = Enum.TextXAlignment.Left

    local Container = Instance.new("Frame", KbFrame)
    Container.Size = UDim2.new(1, -16, 1, -30)
    Container.Position = UDim2.new(0, 8, 0, 28)
    Container.BackgroundTransparency = 1

    local KbList = Instance.new("UIListLayout", Container)
    KbList.SortOrder = Enum.SortOrder.LayoutOrder
    KbList.Padding = UDim.new(0, 4)

    local KeybindData = {} -- Хранит функции и их состояние бинда

    local function ResizeKbWindow()
        local count = 0
        for _, d in pairs(KeybindData) do
            if d.Bind and d.Bind ~= "NONE" and d.Bind ~= "Unknown" then
                count = count + 1
            end
        end

        local targetHeight = (count == 0) and 32 or (32 + (count * 22) + 6)
        TweenService:Create(KbFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 180, 0, targetHeight)}):Play()
    end

    local function SetKeybindState(name, active, bindKey)
        if not KeybindData[name] then
            local Row = Instance.new("Frame", Container)
            Row.Size = UDim2.new(1, 0, 0, 18)
            Row.BackgroundTransparency = 1

            local NameLbl = Instance.new("TextLabel", Row)
            NameLbl.Size = UDim2.new(0.65, 0, 1, 0)
            NameLbl.BackgroundTransparency = 1
            NameLbl.Font = Enum.Font.GothamMedium
            NameLbl.TextSize = 11
            NameLbl.TextXAlignment = Enum.TextXAlignment.Left
            NameLbl.Text = name

            local BindLbl = Instance.new("TextLabel", Row)
            BindLbl.Size = UDim2.new(0.35, 0, 1, 0)
            BindLbl.Position = UDim2.new(0.65, 0, 0, 0)
            BindLbl.BackgroundTransparency = 1
            BindLbl.Font = Enum.Font.GothamBold
            BindLbl.TextSize = 11
            BindLbl.TextXAlignment = Enum.TextXAlignment.Right

            KeybindData[name] = { Row = Row, NameLbl = NameLbl, BindLbl = BindLbl, Active = false, Bind = "NONE" }
        end

        local item = KeybindData[name]
        if bindKey ~= nil then item.Bind = bindKey end
        if active ~= nil then item.Active = active end

        -- Если кнопка не привязана, скрываем строку
        if item.Bind == "NONE" or item.Bind == "Unknown" or item.Bind == "" then
            item.Row.Visible = false
        else
            item.Row.Visible = true
            item.BindLbl.Text = "[" .. tostring(item.Bind) .. "]"
            
            if item.Active then
                item.NameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                item.BindLbl.TextColor3 = Color3.fromRGB(140, 80, 255)
            else
                item.NameLbl.TextColor3 = Color3.fromRGB(110, 110, 130)
                item.BindLbl.TextColor3 = Color3.fromRGB(90, 90, 110)
            end
        end

        ResizeKbWindow()
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
        ESP_KillerColor = Color3.fromRGB(255, 50, 50),
        ESP_SurvivorColor = Color3.fromRGB(50, 255, 100),
        SpeedHack = false,
        SpeedValue = 16,
        AutoSkillCheck = false,
        RiceHat = false,
        CartoonKillerCone = false
    }

    -- COMBAT
    local ToggleDagger = Tabs.Combat:AddToggle("AutoDagger", {Title = "Auto Dagger / Parry", Default = false})
    ToggleDagger:OnChanged(function(Value)
        Features.AutoDagger = Value
        SetKeybindState("Auto Dagger", Value, nil)
    end)

    Tabs.Combat:AddKeybind("AutoDaggerKey", {
        Title = "Auto Dagger Keybind",
        Mode = "Toggle",
        Default = "NONE",
        Callback = function(Value, Bind)
            ToggleDagger:SetValue(Value)
            SetKeybindState("Auto Dagger", Value, tostring(Bind))
        end
    })

    -- VISUALS
    local TogglePlayers = Tabs.Visuals:AddToggle("ESP_Players", {Title = "Player / Killer ESP", Default = false})
    TogglePlayers:OnChanged(function(Value)
        Features.ESP_Players = Value
        SetKeybindState("ESP Players", Value, nil)
    end)

    Tabs.Visuals:AddKeybind("ESPKey", {
        Title = "Toggle ESP Keybind",
        Mode = "Toggle",
        Default = "NONE",
        Callback = function(Value, Bind)
            TogglePlayers:SetValue(Value)
            SetKeybindState("ESP Players", Value, tostring(Bind))
        end
    })

    Tabs.Visuals:AddColorpicker("KillerColor", {
        Title = "Killer ESP Color",
        Default = Color3.fromRGB(255, 50, 50)
    }):OnChanged(function(Value) Features.ESP_KillerColor = Value end)

    Tabs.Visuals:AddColorpicker("SurvivorColor", {
        Title = "Survivor ESP Color",
        Default = Color3.fromRGB(50, 255, 100)
    }):OnChanged(function(Value) Features.ESP_SurvivorColor = Value end)

    Tabs.Visuals:AddToggle("RiceHatToggle", {Title = "Chinese Rice Hat (3D)", Default = false}):OnChanged(function(Value)
        Features.RiceHat = Value
    end)

    Tabs.Visuals:AddToggle("CartoonConeToggle", {Title = "Cartoon Killer Vision Lines", Default = false}):OnChanged(function(Value)
        Features.CartoonKillerCone = Value
    end)

    -- PLAYER
    local ToggleSpeed = Tabs.Player:AddToggle("SpeedHack", {Title = "Enable Speed", Default = false})
    ToggleSpeed:OnChanged(function(Value)
        Features.SpeedHack = Value
        SetKeybindState("SpeedHack", Value, nil)
    end)

    Tabs.Player:AddKeybind("SpeedKey", {
        Title = "Speed Keybind",
        Mode = "Toggle",
        Default = "NONE",
        Callback = function(Value, Bind)
            ToggleSpeed:SetValue(Value)
            SetKeybindState("SpeedHack", Value, tostring(Bind))
        end
    })

    Tabs.Player:AddSlider("SpeedValue", {
        Title = "Speed Multiplier",
        Default = 16, Min = 16, Max = 40, Rounding = 1,
        Callback = function(Value) Features.SpeedValue = Value end
    })

    -- AUTOMATION
    Tabs.Automation:AddToggle("AutoSkill", {Title = "Auto SkillCheck", Default = false}):OnChanged(function(Value)
        Features.AutoSkillCheck = Value
    end)

    -- ==================== OPTIMIZED LOGIC ====================
    
    -- 1. Исправленная Китайская Шляпа (Chinese Rice Hat)
    local function UpdateRiceHat()
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
                hat.Color = Color3.fromRGB(140, 50, 255)
                hat.Material = Enum.Material.SmoothPlastic

                local mesh = Instance.new("SpecialMesh", hat)
                mesh.MeshType = Enum.MeshType.Cone
                mesh.Scale = Vector3.new(2.6, 0.6, 2.6)

                local weld = Instance.new("Weld", hat)
                weld.Part0 = head
                weld.Part1 = hat
                weld.C0 = CFrame.new(0, 0.75, 0)
                hat.Parent = char
            end
        else
            if existingHat then existingHat:Destroy() end
        end
    end

    -- 2. ESP Highlights
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
        if ESP_Storage[inst] then ESP_Storage[inst].Enabled = false end
    end

    -- 3. Cartoon Killer Vision Lines
    local CartoonRings = {}
    local function UpdateCartoonVision(killerChar)
        if not Features.CartoonKillerCone or not killerChar then
            for _, ring in pairs(CartoonRings) do ring.Visible = false end
            return
        end
        local head = killerChar:FindFirstChild("Head")
        if not head then return end

        for i = 1, 2 do
            local ring = CartoonRings[i]
            if not ring then
                ring = Instance.new("SelectionBox")
                ring.Color3 = Color3.fromRGB(255, 120, 0)
                ring.LineThickness = 0.04
                ring.Parent = workspace
                CartoonRings[i] = ring
            end
            ring.Adornee = head
            ring.Visible = true
        end
    end

    -- Render Loop
    local lastFpsTime = os.clock()
    local frameCount = 0

    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local now = os.clock()
        if now - lastFpsTime >= 1 then
            WmFPS.Text = "FPS: " .. tostring(math.floor(frameCount / (now - lastFpsTime)))
            frameCount = 0
            lastFpsTime = now
        end

        if Features.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Features.SpeedValue
        end

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

        UpdateRiceHat()
    end)

    -- Auto SkillCheck
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
    Fluent:Notify({ Title = "Vortex Hub", Content = "Loaded Successfully!", Duration = 4 })
end

-- ====================================================================--
--                            INIT VORTEX                               --
--===================================================================--

ShowLoadingScreen(function()
    VerifyKeyAccess(function(key, keyType)
        LoadMainVortexHub(key, keyType)
    end)
end)
