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
    ["VTX-1D-4X18Q"] = { type = "1 Day Pass", duration = 86400 },
    ["VTX-1D-7Z85W"] = { type = "1 Day Pass", duration = 86400 },
    ["VTX-1D-2N63R"] = { type = "1 Day Pass", duration = 86400 },
    ["VTX-1D-5V91T"] = { type = "1 Day Pass", duration = 86400 },
    ["VTX-1D-1B47Y"] = { type = "1 Day Pass", duration = 86400 },
    ["VTX-1D-6H32U"] = { type = "1 Day Pass", duration = 86400 },
    ["VTX-1D-0J59E"] = { type = "1 Day Pass", duration = 86400 },

    -- 30 Days Keys
    ["VTX-30D-92KF8"] = { type = "30 Days VIP", duration = 2592000 },
    ["VTX-30D-17PQ3"] = { type = "30 Days VIP", duration = 2592000 },
    ["VTX-30D-84LW9"] = { type = "30 Days VIP", duration = 2592000 },
    ["VTX-30D-51XR2"] = { type = "30 Days VIP", duration = 2592000 },
    ["VTX-30D-36VT5"] = { type = "30 Days VIP", duration = 2592000 },
    ["VTX-30D-73MN1"] = { type = "30 Days VIP", duration = 2592000 },
    ["VTX-30D-28BZ4"] = { type = "30 Days VIP", duration = 2592000 },
    ["VTX-30D-69HC7"] = { type = "30 Days VIP", duration = 2592000 },
    ["VTX-30D-40UJ6"] = { type = "30 Days VIP", duration = 2592000 },
    ["VTX-30D-15GE9"] = { type = "30 Days VIP", duration = 2592000 }
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

    local UICorner = Instance.new("UICorner", MainFrame)
    UICorner.CornerRadius = UDim.new(0, 12)

    local UIStroke = Instance.new("UIStroke", MainFrame)
    UIStroke.Color = Color3.fromRGB(120, 40, 250)
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

    local BarCorner = Instance.new("UICorner", BarBackground)
    BarCorner.CornerRadius = UDim.new(1, 0)

    local BarFill = Instance.new("Frame", BarBackground)
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(140, 50, 255)
    BarFill.BorderSizePixel = 0

    local FillCorner = Instance.new("UICorner", BarFill)
    FillCorner.CornerRadius = UDim.new(1, 0)

    task.spawn(function()
        local stages = {
            { p = 0.3, t = "Bypassing Security..." },
            { p = 0.6, t = "Verifying HWID & License..." },
            { p = 0.9, t = "Injecting Modules..." },
            { p = 1.0, t = "Ready!" }
        }

        for _, stage in ipairs(stages) do
            Status.Text = stage.t
            TweenService:Create(BarFill, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Size = UDim2.new(stage.p, 0, 1, 0)}):Play()
            task.wait(0.7)
        end

        task.wait(0.3)
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
            task.wait(1)
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

    -- Blur Effect Control
    local BlurEffect = Lighting:FindFirstChild("VortexBlur") or Instance.new("BlurEffect")
    BlurEffect.Name = "VortexBlur"
    BlurEffect.Size = 18
    BlurEffect.Enabled = true
    BlurEffect.Parent = Lighting

    local Window = Fluent:CreateWindow({
        Title = "VORTEX HUB | Violence District",
        SubTitle = "License: " .. keyType,
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = false,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.RightControl
    })

    -- Toggle Blur on Window Minimize/Close
    Window:OnMinimize(function(minimized)
        BlurEffect.Enabled = not minimized
    end)

    -- ==================== DRAGGABLE WATERMARK WITH FPS ====================
    local WatermarkGui = Instance.new("ScreenGui")
    WatermarkGui.Name = "VortexWatermarkGui"
    WatermarkGui.Parent = (gethui and gethui()) or CoreGui

    local WatermarkBtn = Instance.new("TextButton", WatermarkGui)
    WatermarkBtn.Size = UDim2.new(0, 190, 0, 32)
    WatermarkBtn.Position = UDim2.new(0, 20, 0, 20)
    WatermarkBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    WatermarkBtn.BorderSizePixel = 0
    WatermarkBtn.AutoButtonColor = true
    WatermarkBtn.Text = ""

    Instance.new("UICorner", WatermarkBtn).CornerRadius = UDim.new(0, 8)
    local WmStroke = Instance.new("UIStroke", WatermarkBtn)
    WmStroke.Color = Color3.fromRGB(140, 50, 255)
    WmStroke.Thickness = 1.5

    local WatermarkText = Instance.new("TextLabel", WatermarkBtn)
    WatermarkText.Size = UDim2.new(1, 0, 1, 0)
    WatermarkText.BackgroundTransparency = 1
    WatermarkText.TextColor3 = Color3.fromRGB(255, 255, 255)
    WatermarkText.TextSize = 13
    WatermarkText.Font = Enum.Font.GothamBold
    WatermarkText.Text = "Vortex Hub | FPS: --"

    -- Draggable Feature Logic
    local dragging, dragInput, dragStart, startPos, isDragged
    local function update(input)
        local delta = input.Position - dragStart
        WatermarkBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    WatermarkBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            isDragged = false
            dragStart = input.Position
            startPos = WatermarkBtn.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    WatermarkBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            isDragged = true
            update(input)
        end
    end)

    -- Toggle Menu Click Logic
    WatermarkBtn.MouseButton1Click:Connect(function()
        if not isDragged and Window then
            Window:Minimize()
        end
    end)

    -- FPS Counter Loop
    task.spawn(function()
        local lastTime = os.clock()
        local frameCount = 0
        RunService.RenderStepped:Connect(function()
            frameCount = frameCount + 1
            local currentTime = os.clock()
            if currentTime - lastTime >= 1 then
                local fps = math.floor(frameCount / (currentTime - lastTime))
                WatermarkText.Text = "Vortex Hub | FPS: " .. tostring(fps)
                frameCount = 0
                lastTime = currentTime
            end
        end)
    end)

    -- ==================== TABS SETUP ====================
    local Tabs = {
        Combat = Window:AddTab({ Title = "Combat & Parry", Icon = "sword" }),
        Visuals = Window:AddTab({ Title = "Visuals (ESP)", Icon = "eye" }),
        Player = Window:AddTab({ Title = "Player & Mods", Icon = "user" }),
        Automation = Window:AddTab({ Title = "Automation", Icon = "bot" }),
        Settings = Window:AddTab({ Title = "Settings & Binds", Icon = "settings" })
    }

    local ESP_Storage = {}
    local Features = {
        AutoDagger = false,
        DaggerDistance = 12,
        ESP_Players = false,
        ESP_Generators = false,
        ESP_Spikes = false,
        SpeedHack = false,
        SpeedValue = 16,
        AutoSkillCheck = false,
        Fullbright = false
    }

    local function GetKiller()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Team and p.Team.Name:lower():find("killer") then
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    return p.Character
                end
            end
        end
        return nil
    end

    local function CreateHighlight(instance, color)
        if not instance or ESP_Storage[instance] then return end
        local highlight = Instance.new("Highlight")
        highlight.Name = "Vortex_ESP"
        highlight.Adornee = instance
        highlight.FillColor = color
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Parent = instance
        ESP_Storage[instance] = highlight
    end

    local function RemoveHighlight(instance)
        if ESP_Storage[instance] then
            ESP_Storage[instance]:Destroy()
            ESP_Storage[instance] = nil
        end
    end

    -- TAB: COMBAT
    local ToggleDagger = Tabs.Combat:AddToggle("AutoDagger", {Title = "Auto Dagger / Parry", Default = false})
    ToggleDagger:OnChanged(function(Value) Features.AutoDagger = Value end)

    Tabs.Combat:AddKeybind("AutoDaggerKey", {
        Title = "Auto Dagger Keybind",
        Mode = "Toggle",
        Default = "NONE",
        Callback = function(Value) ToggleDagger:SetValue(Value) end
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
        if not Value then
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character then RemoveHighlight(p.Character) end
            end
        end
    end)

    Tabs.Visuals:AddKeybind("ESPKey", {
        Title = "Toggle ESP Keybind",
        Mode = "Toggle",
        Default = "NONE",
        Callback = function(Value) TogglePlayers:SetValue(Value) end
    })

    local ToggleGens = Tabs.Visuals:AddToggle("ESP_Gens", {Title = "Generators ESP", Default = false})
    ToggleGens:OnChanged(function(Value)
        Features.ESP_Generators = Value
        if not Value then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name:lower():find("generator") then RemoveHighlight(obj) end
            end
        end
    end)

    local ToggleSpikes = Tabs.Visuals:AddToggle("ESP_Spikes", {Title = "Spikes ESP", Default = false})
    ToggleSpikes:OnChanged(function(Value)
        Features.ESP_Spikes = Value
        if not Value then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name:lower():find("spike") or obj.Name:lower():find("hook") then RemoveHighlight(obj) end
            end
        end
    end)

    local ToggleFB = Tabs.Visuals:AddToggle("Fullbright", {Title = "Fullbright (No Darkness)", Default = false})
    ToggleFB:OnChanged(function(Value)
        Features.Fullbright = Value
        if Value then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
        else
            Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        end
    end)

    -- TAB: PLAYER
    local ToggleSpeed = Tabs.Player:AddToggle("SpeedHack", {Title = "Enable Speed", Default = false})
    ToggleSpeed:OnChanged(function(Value) Features.SpeedHack = Value end)

    Tabs.Player:AddKeybind("SpeedKey", {
        Title = "Speed Keybind",
        Mode = "Toggle",
        Default = "NONE",
        Callback = function(Value) ToggleSpeed:SetValue(Value) end
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

    -- LOGIC LOOPS
    task.spawn(function()
        while task.wait(0.05) do
            if Features.AutoDagger and LocalPlayer.Character then
                local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local killerChar = GetKiller()

                if myRoot and killerChar then
                    local killerRoot = killerChar:FindFirstChild("HumanoidRootPart")
                    local killerHum = killerChar:FindFirstChildOfClass("Humanoid")

                    if killerRoot and killerHum then
                        local dist = (myRoot.Position - killerRoot.Position).Magnitude
                        if dist <= Features.DaggerDistance then
                            local isAttacking = false
                            local animator = killerHum:FindFirstChildOfClass("Animator")
                            if animator then
                                for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                                    local name = track.Name:lower()
                                    if name:find("attack") or name:find("swing") or name:find("slash") then
                                        isAttacking = true
                                        break
                                    end
                                end
                            end

                            if isAttacking then
                                local backpack = LocalPlayer:FindFirstChild("Backpack")
                                local dagger = (backpack and backpack:FindFirstChild("Dagger")) or LocalPlayer.Character:FindFirstChild("Dagger")
                                
                                if dagger then
                                    if dagger.Parent == backpack then
                                        LocalPlayer.Character.Humanoid:EquipTool(dagger)
                                    end
                                    task.wait(0.02)
                                    dagger:Activate()
                                    task.wait(0.5)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    RunService.RenderStepped:Connect(function()
        if Features.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Features.SpeedValue
        end

        if Features.ESP_Players then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local col = p.Team and p.Team.Name:lower():find("killer") and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 100)
                    CreateHighlight(p.Character, col)
                end
            end
        end

        if Features.ESP_Generators or Features.ESP_Spikes then
            for _, obj in pairs(workspace:GetDescendants()) do
                if Features.ESP_Generators and obj.Name:lower():find("generator") and obj:IsA("Model") then
                    CreateHighlight(obj, Color3.fromRGB(0, 170, 255))
                end
                if Features.ESP_Spikes and (obj.Name:lower():find("spike") or obj.Name:lower():find("hook")) and obj:IsA("Model") then
                    CreateHighlight(obj, Color3.fromRGB(255, 170, 0))
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait(0.1) do
            if Features.AutoSkillCheck then
                local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                if pGui then
                    for _, gui in pairs(pGui:GetChildren()) do
                        if gui.Name:lower():find("skill") or gui.Name:lower():find("generator") then
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                            task.wait(0.05)
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
        Title = "Vortex Hub Loaded",
        Content = "Welcome! Key: " .. usedKey .. " (" .. keyType .. ")",
        Duration = 6
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
