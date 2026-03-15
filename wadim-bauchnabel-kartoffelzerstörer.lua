local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variablen für die Logik
local autoFarm = false
local autoUpgradeClick = false
local autoPrestige = false
local autoHideNotifications = false
local minPP = 1
local sellThreshold = 0
local notificationConn
local AutoSellActive = false
local AutoSellDelay = 1

-- Hilfsfunktionen
local function getRemotes()
    return ReplicatedStorage:FindFirstChild("Remotes")
end

local function parseNumber(str)
    str = string.lower(tostring(str)):gsub(",", ""):gsub(" ", "")
    local numStr, suffix = string.match(str, "^([%d%.]+)([a-z]*)$")
    local num = tonumber(numStr)
    if not num then return 0 end
    
    local multipliers = { k = 1e3, m = 1e6, b = 1e9, t = 1e12, qa = 1e15, qi = 1e18 }
    if suffix and suffix ~= "" and multipliers[suffix] then num = num * multipliers[suffix] end
    return num
end

-- Optimierte Kartoffel-Abfrage über deinen korrigierten GUI-Pfad
local function getCurrentPotatoes()
    local success, result = pcall(function()
        local path = LocalPlayer.PlayerGui.PotatoGameGUI.Background.StatsArea.StatsScrollFrame.StatsContainer.SectionCard_Balances.SB_Potatoes.Value
        return parseNumber(path.Text)
    end)
    return success and result or 0
end

local Window = Rayfield:CreateWindow({
   Name = "karotten script",
   LoadingTitle = "Bauchnabel wird geladen",
   ConfigurationSaving = { Enabled = true, FolderName = "karotte", FileName = "WadimConfig" },
   KeySystem = true,
   KeySettings = {
      Title = "potototo script",
      Subtitle = "Key System",
      Note = "get key from meine eier",
      FileName = "KeyPotato",
      SaveKey = true,
      Key = {"Hello123"}
   }
})

local MainTab = Window:CreateTab("Main", 4483362458)

-- Auto Clicker
MainTab:CreateToggle({
   Name = "Auto Click",
   CurrentValue = false,
   Flag = "ToggleFarm", 
   Callback = function(Value)
        autoFarm = Value
        task.spawn(function()
            while autoFarm do
                task.wait(0.01)
                pcall(function()
                    local remotes = getRemotes()
                    if remotes and remotes:FindFirstChild("PerformClick") then remotes.PerformClick:FireServer() end
                end)
            end
        end)
   end,
})

-- Smart Auto Upgrade (Kauft immer das teuerste verfügbare)
local upgradeList = {
    "finger_of_god", "singularity_tap", "omniversal_click",
    "infinite_potato_mastery", "universal_potato_power", "galactic_harvest",
    "transcendent_harvest", "omnipotato_blessing", "infinite_energy",
    "dimensional_reach", "lunar_planting", "grandfathers_wisdom",
    "advanced_techniques", "farmers_instinct", "golden_trowel",
    "steel_trowel", "padded_gloves", "stronger_hands"
}

MainTab:CreateToggle({
    Name = "Auto Buy Best Upgrade",
    CurrentValue = false,
    Flag = "ToggleUpgrade",
    Callback = function(Value)
        autoUpgradeClick = Value
        if autoUpgradeClick then
            task.spawn(function()
                while autoUpgradeClick do
                    local myPotatoes = getCurrentPotatoes()
                    local remotes = getRemotes()
                    
                    if remotes and remotes:FindFirstChild("GetUpgradeCost") then
                        -- Liste von oben (teuerste) nach unten durchgehen
                        for _, upgradeName in ipairs(upgradeList) do
                            if not autoUpgradeClick then break end
                            
                            local success, cost = pcall(function()
                                return remotes.GetUpgradeCost:InvokeServer(upgradeName)
                            end)
                            
                            if success and cost then
                                local numericCost = tonumber(cost) or parseNumber(tostring(cost))
                                
                                if myPotatoes >= numericCost then
                                    -- Kaufen!
                                    pcall(function()
                                        remotes.PurchaseClickUpgrade:FireServer(upgradeName)
                                    end)
                                    -- Da wir das teuerste gekauft haben, brechen wir diesen Durchlauf ab
                                    break 
                                end
                            end
                        end
                    end
                    task.wait(1) -- Jede Sekunde prüfen
                end
            end)
        end
    end,
})

-- Claim Rewards
MainTab:CreateButton({
   Name = "📅 Claim Login & AFK Rewards",
   Callback = function()
        pcall(function()
            local remotes = getRemotes()
            if not remotes then return end
            if remotes:FindFirstChild("ClaimLoginStreak") then remotes.ClaimLoginStreak:FireServer() end
            if remotes:FindFirstChild("ClaimOfflineBoostBonus") then remotes.ClaimOfflineBoostBonus:FireServer() end
            Rayfield:Notify({Title = "Rewards Claimed!", Content = "Login streak and AFK earnings added.", Duration = 4})
        end)
   end,
})

-- Autosell Logic
local AutoSellToggle = MainTab:CreateToggle({
   Name = "Autosell golden carrots",
   CurrentValue = false,
   Flag = "AutoSell_Toggle",
   Callback = function(Value)
      AutoSellActive = Value
      if Value then
         task.spawn(function()
                while AutoSellActive do
                    task.wait(AutoSellDelay)
                    pcall(function()
                        local remotes = getRemotes()
                        if remotes then
                            if remotes:FindFirstChild("SellAllPotatoes") then remotes.SellAllPotatoes:FireServer() end
                            if remotes:FindFirstChild("SellAllGoldenPotatoes") then remotes.SellAllGoldenPotatoes:FireServer() end
                        end
                    end)
                end
            end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "AutoSell Delay",
   Range = {0.25, 5},
   Increment = 0.25,
   Suffix = "s",
   CurrentValue = 1,
   Flag = "AutoSell_Delay",
   Callback = function(Value) AutoSellDelay = Value end,
})

-- Auto Prestige
MainTab:CreateToggle({
   Name = "Auto Prestige",
   CurrentValue = false,
   Flag = "TogglePrestige",
   Callback = function(Value)
      autoPrestige = Value
      if Value then
          task.spawn(function()
              while autoPrestige do
                  task.wait(.5)
                  pcall(function()
                      local ppObj = LocalPlayer.PlayerGui.PotatoGameGUI.Background.StatsArea.StatsScrollFrame.StatsContainer.SectionCard_Progress.PotentialPoints.Value
                      local ppValue = parseNumber(ppObj.Text)
                      
                      if ppValue >= minPP then
                          local remotes = getRemotes()
                          if remotes and remotes:FindFirstChild("PerformPrestige") then
                              remotes.PerformPrestige:FireServer()
                          end
                      end
                  end)
              end
          end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Minimum PP for Prestige",
   Range = {1, 100},
   Increment = 1,
   Suffix = "PP",
   CurrentValue = 1,
   Flag = "MinPP_Slider",
   Callback = function(Value) minPP = Value end,
})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateKeybind({
   Name = "UI Toggle Hotkey",
   CurrentKeybind = "K",
   Flag = "UI_Toggle_Hotkey",
   Callback = function(Key) pcall(function() Rayfield:ToggleUI() end) end,
})

SettingsTab:CreateButton({
   Name = "Unload UI",
   Callback = function()
      autoFarm = false
      autoUpgradeClick = false
      autoPrestige = false
      AutoSellActive = false
      Rayfield:Destroy()
   end,
})

Rayfield:LoadConfiguration()