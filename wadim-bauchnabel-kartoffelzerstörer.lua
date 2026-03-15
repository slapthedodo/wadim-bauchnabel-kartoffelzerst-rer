local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VIM = game:GetService("VirtualInputManager")

local autoFarm = false
local autoUpgradeClick = false
local autoPrestige = false
local autoAscension = false
local autoShop = false
local autoGenerator = false
local autoAntiAFK = false
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
      FileName = "WadimConfig_" .. LocalPlayer.Name
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", 
      RememberJoins = true 
   },
   KeySystem = false,
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

    local allowedIcons = {
        ["rbxassetid://102427394468064"] = "pot",
        ["rbxassetid://89085234677231"] = "cash",
        ["rbxassetid://107549977624627"] = "pp",
        ["rbxassetid://134776730454808 "] = "golden pot"
    }


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
    Name = "Auto Buy Best Upgrades",
    CurrentValue = false,
    Flag = "ToggleUpgrade",
    Callback = function(Value)
        autoUpgradeClick = Value
        
        if autoUpgradeClick then
            task.spawn(function()
                while autoUpgradeClick do
                    for _, upgradeName in ipairs(upgradeList) do
                        if not autoUpgradeClick then break end
                        
                        pcall(function()
                            local remotes = getRemotes()
                            if remotes and remotes:FindFirstChild("PurchaseClickUpgrade") then
                                remotes.PurchaseClickUpgrade:FireServer(upgradeName)
                            end
                        end)
                        
                        task.wait(.01) 
                    end
                end
            end)
        end
    end,
})

local generatorList = {
    "the_final_spud",
    "the_spudularity",
    "potato_infinite_universe",
    "infinite_omnipotato",
    "double_omnipotato",
    "omnipotato",
    "potato_nexus",
    "superfactory_number_67",
    "potato_galaxy",
    "temporal_harvester",
    "quantum_potato_generator",
    "dimensional_mirror",
    "cloning_facility",
    "agricultural_lab",
    "processing_plant",
    "greenhouse",
    "potato_farm",
    "potato_garden",
    "backyard_patch",
    "potato_seedling"
}

local function getOwnedGenerators()
    local owned = {}
    local totalCount = 0
    pcall(function()
        local gui = LocalPlayer:FindFirstChild("PlayerGui")
        local pg = gui and gui:FindFirstChild("PotatoGameGUI")
        local bg = pg and pg:FindFirstChild("Background")
        local ca = bg and bg:FindFirstChild("ContentArea")
        local is = ca and ca:FindFirstChild("ItemsScroll")
        local ogs = is and is:FindFirstChild("OwnedGeneratorsSection")
        local oc = ogs and ogs:FindFirstChild("OwnedContent")
        local grid = oc and oc:FindFirstChild("OwnedGeneratorsGrid")
        
        if grid then
            for _, child in pairs(grid:GetChildren()) do
                local baseName = child.Name:match("^(.-)_OwnedCard_%d+$")
                if baseName then
                    owned[baseName] = (owned[baseName] or 0) + 1
                    totalCount = totalCount + 1
                end
            end
        end
    end)
    return owned, totalCount
end

MainTab:CreateToggle({
    Name = "Auto Buy Best Generator",
    CurrentValue = false,
    Flag = "ToggleGenerator",
    Callback = function(Value)
        autoGenerator = Value
        
        if autoGenerator then
            task.spawn(function()
                while autoGenerator do
                    pcall(function()
                        local owned, totalCount = getOwnedGenerators()
                        local bestOwnedIdx = #generatorList + 1
                        
                        for i, name in ipairs(generatorList) do
                            if owned[name] and owned[name] > 0 then
                                if i < bestOwnedIdx then bestOwnedIdx = i end
                            end
                        end
                        
                        local remotes = getRemotes()
                        if remotes then
                            -- Deletion of low tiers (keep best and one below)
                            if bestOwnedIdx <= #generatorList then
                                for i = bestOwnedIdx + 2, #generatorList do
                                    local name = generatorList[i]
                                    if owned[name] and owned[name] > 0 then
                                        if remotes:FindFirstChild("DeleteGenerator") then
                                            for _ = 1, owned[name] do
                                                remotes.DeleteGenerator:FireServer(name)
                                                local generatorsTab = game:GetService("Players").VayzEUx.PlayerGui.PotatoGameGUI.Background.NavArea.TabContainer.GeneratorsTabWrapper.GeneratorsTab
                                                    if generatorsTab and firesignal then
                                                        firesignal(generatorsTab.Activated)
                                                    end
                                                totalCount = totalCount - 1
                                                task.wait(0.05)
                                            end
                                            owned[name] = 0
                                        end
                                    end
                                end
                            end
                            
                            -- Max 15 items limit
                            while totalCount >= 15 do
                                local worstIdx = 0
                                for i = #generatorList, 1, -1 do
                                    if owned[generatorList[i]] and owned[generatorList[i]] > 0 then
                                        worstIdx = i
                                        break
                                    end
                                end
                                if worstIdx > 0 and remotes:FindFirstChild("DeleteGenerator") then
                                    local name = generatorList[worstIdx]
                                    remotes.DeleteGenerator:FireServer(name)
                                    local generatorsTab = game:GetService("Players").VayzEUx.PlayerGui.PotatoGameGUI.Background.NavArea.TabContainer.GeneratorsTabWrapper.GeneratorsTab
                                        if generatorsTab and firesignal then
                                            firesignal(generatorsTab.Activated)
                                        end
                                    owned[name] = owned[name] - 1
                                    totalCount = totalCount - 1
                                    task.wait(0.05)
                                else
                                    break
                                end
                            end
                        end
                    end)

                    for _, genName in ipairs(generatorList) do
                        if not autoGenerator then break end
                        
                        pcall(function()
                            local remotes = getRemotes()
                            if remotes and remotes:FindFirstChild("PurchaseGenerator") then
                                local generatorsTab = game:GetService("Players").VayzEUx.PlayerGui.PotatoGameGUI.Background.NavArea.TabContainer.GeneratorsTabWrapper.GeneratorsTab
                                    if generatorsTab and firesignal then
                                        firesignal(generatorsTab.Activated)
                                    end
                                remotes.PurchaseGenerator:FireServer(genName)
                            end
                        end)
                        
                        task.wait(.01) 
                    end
                end
            end)
        end
    end,
})

MainTab:CreateButton({
       Name = "Claim Login & AFK Rewards",
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

MainTab:CreateToggle({
   Name = "Auto Ascension",
   CurrentValue = false,
   Flag = "ToggleAscension",
   Callback = function(Value)
      autoAscension = Value
      if Value then
          task.spawn(function()
              while autoAscension do
                  pcall(function()
                      local remotes = getRemotes()
                      if remotes and remotes:FindFirstChild("GetAscensionInfo") then
                          local info = remotes.GetAscensionInfo:InvokeServer()
                          if info and info.CanAscend == true then
                              if remotes:FindFirstChild("PerformAscension") then
                                  remotes.PerformAscension:FireServer("abundance")
                              end
                          end
                      end
                  end)
                  task.wait(5)
              end
          end)
      end
   end,
})

local shopItemList = {
    "galaxy_potato", "divine_potato", "eternal_potato", "watermelon_potato", "glacial_potato",
    "phoenix_potato", "void_potato", "king_potato", "quantum_potato", "bubble_potato",
    "honeycomb_potato", "leopard_potato", "kiwi_potato", "flat_potato", "diamond_potato",
    "obsidian_potato", "ghostly_potato", "mechanical_potato", "enchanted_potato", "camouflage_potato",
    "cloud_potato", "pixel_potato", "emoji_mystery_potato", "mystery_potato", "mystery_potato_3",
    "potato_eyes", "potion_drop", "potion_production", "potion_click", "potion_luck",
    "potion_golden", "potato_factory", "russet_potato", "red_potato", "yunko_gold",
    "white_potato", "fingerling_potato", "purple_majesty", "sweet_potato", "blue_potato",
    "sprouting_potato", "crystal_potato", "rainbow_potato", "frozen_potato", "volcanic_potato",
    "ancient_potato", "shy_potato", "neon_potato", "shopkeepers_stash", "spud_laboratory"
}

MainTab:CreateToggle({
   Name = "Auto Shop",
   CurrentValue = false,
   Flag = "ToggleAutoShop",
   Callback = function(Value)
      autoShop = Value
      if Value then
          task.spawn(function()
              while autoShop do
                  for _, itemName in ipairs(shopItemList) do
                      if not autoShop then break end
                      pcall(function()
                          local remotes = getRemotes()
                          if remotes and remotes:FindFirstChild("PurchaseShopPotato") then
                              remotes.PurchaseShopPotato:FireServer(itemName)
                          end
                      end)
                      task.wait(0.5)
                  end
              end
          end)
      end
   end,
})



local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Flag = "ToggleAntiAFK",
    Callback = function(Value)
        autoAntiAFK = Value
        if autoAntiAFK then
            task.spawn(function()
                while autoAntiAFK do
                    pcall(function()
                        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        task.wait(0.1)
                        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                        VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                        task.wait(0.1)
                        VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    end)
                    task.wait(300)
                end
            end)
        end
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
      autoGenerator = false
      autoAntiAFK = false
      autoPrestige = false
      autoAscension = false
      autoShop = false
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
