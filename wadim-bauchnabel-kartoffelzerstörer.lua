local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local autoFarm = false
local autoUpgradeClick = false
local autoPrestige = false
local autoHideNotifications = false
local minPP = 1
local sellThreshold = 0
local notificationConn

local Window = Rayfield:CreateWindow({
   Name = "karotten script",
   LoadingTitle = "Bauchnabel wird geladen",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "karotte",
      FileName = "WadimConfig"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", 
      RememberJoins = true 
   },
   KeySystem = true,
   KeySettings = {
      Title = "potototo script",
      Subtitle = "Key System",
      Note = "get key from meine eier",
      FileName = "KeyPotato",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello123"}
   },
   Keybind = "None"
})

local MainTab = Window:CreateTab("Main", 4483362458)

local AutoSellActive = false
local AutoSellDelay = 1

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

    local function getCurrentPotatoes()
        local remotes = getRemotes()
        if remotes and remotes:FindFirstChild("GetPlayerData") then
            local suc, data = pcall(function() return remotes.GetPlayerData:InvokeServer() end)
            if suc and type(data) == "table" then
                if data.Potatoes then return parseNumber(data.Potatoes) end
                if data.potatoes then return parseNumber(data.potatoes) end
            end
        end
        local ls = LocalPlayer:FindFirstChild("leaderstats") or LocalPlayer:FindFirstChild("Leaderstats")
        if ls then
            for _, v in pairs(ls:GetChildren()) do
                local name = string.lower(v.Name)
                if string.find(name, "potato") or string.find(name, "patates") then
                    return tonumber(v.Value) or parseNumber(v.Value)
                end
            end
        end
        return -1
    end


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
                local lastPrices = {}

                while autoUpgradeClick do
                    local myPotatoes = getCurrentPotatoes()
                    local remotes = getRemotes()
                    
                    if remotes and remotes:FindFirstChild("GetUpgradeCost") and remotes:FindFirstChild("PurchaseClickUpgrade") then
                        
                        local bestUpgradeToBuy = nil
                        
                        for _, upgradeName in ipairs(upgradeList) do
                            if not autoUpgradeClick then break end
                            

                            if not lastPrices[upgradeName] then
                                local success, cost = pcall(function()
                                    return remotes.GetUpgradeCost:InvokeServer(upgradeName)
                                end)
                                if success and cost then
                                    lastPrices[upgradeName] = tonumber(cost) or parseNumber(tostring(cost))
                                end
                            end
                            

                            local currentPrice = lastPrices[upgradeName]
                            if currentPrice and myPotatoes >= currentPrice then

                                bestUpgradeToBuy = upgradeName
                                break
                            end
                        end
                        

                        if bestUpgradeToBuy then
                            pcall(function()
                                remotes.PurchaseClickUpgrade:FireServer(bestUpgradeToBuy)
                            end)

                            lastPrices[bestUpgradeToBuy] = nil
                            

                            task.wait(0.1)
                        end
                    end
                    
                    task.wait(0.2) 
                end
            end)
        end
    end,
})

MainTab:CreateButton({
       Name = "ð Claim Login & AFK Rewards",
       Callback = function()
            pcall(function()
                local remotes = getRemotes()
                if not remotes then return end
                if remotes:FindFirstChild("ClaimLoginStreak") then remotes.ClaimLoginStreak:FireServer() end
                if remotes:FindFirstChild("ClaimOfflineBoostBonus") then remotes.ClaimOfflineBoostBonus:FireServer() end
                Rayfield:Notify({Title = "Rewards Claimed!", Content = "Login streak and AFK earnings have been added to your wallet.", Duration = 4, Image = 4483362458})
            end)
       end,
    })

local AutoSellToggle = MainTab:CreateToggle({
   Name = "Autosell golden carrots",
   CurrentValue = false,
   Flag = "AutoSell_Toggle",
   Callback = function(Value)
      AutoSellActive = Value
      if Value then
         Rayfield:Notify({
            Title = "Autosell golden carrots",
            Content = "Autosell golden carrots active",
            Duration = 2,
            Image = 4483362458,
         })

         task.spawn(function()
                while AutoSellActive do
                    task.wait(AutoSellDelay)
                    pcall(function()
                        local shouldSell = true
                        if sellThreshold > 0 then
                            local current = getCurrentPotatoes()
                            if current ~= -1 and current < sellThreshold then
                                shouldSell = false
                            end
                        end
                        if shouldSell then
                            local remotes = getRemotes()
                            if remotes then
                                if remotes:FindFirstChild("SellAllPotatoes") then remotes.SellAllPotatoes:FireServer() end
                                if remotes:FindFirstChild("SellAllGoldenPotatoes") then remotes.SellAllGoldenPotatoes:FireServer() end
                            end
                        end
                    end)
                end
            end)
      else
         Rayfield:Notify({
            Title = "AutoSell",
            Content = "AutoSell deavtivated",
            Duration = 2,
            Image = 4483362458,
         })
      end
   end,
})

local DelaySlider = MainTab:CreateSlider({
   Name = "AutoSell Delay",
   Range = {0.25, 5},
   Increment = 0.25,
   Suffix = "s",
   CurrentValue = 1,
   Flag = "AutoSell_Delay",
   Callback = function(Value)
      AutoSellDelay = Value
   end,
})

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
                      local ppText = ""
                      if ppObj:IsA("TextLabel") or ppObj:IsA("TextBox") then
                          ppText = ppObj.Text
                      else
                          ppText = tostring(ppObj.Value or ppObj)
                      end
                      
                      local ppValue = tonumber(ppText:match("%d+"))
                      if ppValue and ppValue >= minPP then
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
   Callback = function(Value)
      minPP = Value
   end,
})



local SettingsTab = Window:CreateTab("Settings", 4483362458)

local UIToggleKeybind = SettingsTab:CreateKeybind({
   Name = "UI Toggle Hotkey",
   CurrentKeybind = "K",
   HoldToInteract = false,
   Flag = "UI_Toggle_Hotkey",
   Callback = function(Key)
      pcall(function() Rayfield:ToggleUI() end)
   end,
})

local AutoHideToggle = SettingsTab:CreateToggle({
   Name = "Auto Hide Notifications",
   CurrentValue = false,
   Flag = "AutoHide_Notifications",
   Callback = function(Value)
      autoHideNotifications = Value
      if notificationConn then notificationConn:Disconnect() notificationConn = nil end
      
      local container = LocalPlayer.PlayerGui.PotatoGameGUI.NotificationContainer
      if not container then return end

      if autoHideNotifications then
          container.Visible = false
          notificationConn = container:GetPropertyChangedSignal("Visible"):Connect(function()
              if autoHideNotifications then
                  container.Visible = false
              end
          end)
      else
          container.Visible = true
      end
   end,
})

local UnloadButton = SettingsTab:CreateButton({
   Name = "Unload UI",
   Callback = function()
      autoFarm = false
      autoUpgradeClick = false
      autoPrestige = false
      autoHideNotifications = false
      if notificationConn then notificationConn:Disconnect() end
      AutoSellActive = false
      Rayfield:Destroy()
   end,
})

Rayfield:LoadConfiguration()

Rayfield:Notify({
   Title = "karotten script",
   Content = "Bauchnabel geladen",
   Duration = 5,
   Image = 4483362458,
})
