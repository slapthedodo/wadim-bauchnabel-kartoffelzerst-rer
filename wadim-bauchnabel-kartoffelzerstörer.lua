local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local autoFarm = false
local autoUpgradeClick = false
local autoSell = false
local sellThreshold = 0

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

MainTab:CreateToggle({
       Name = "Auto Upgrade Click",
       CurrentValue = false,
       Flag = "ToggleUpgrade",
       Callback = function(Value)
            autoUpgradeClick = Value
            task.spawn(function()
                while autoUpgradeClick do
                    task.wait(2)
                    pcall(function()
                        local remotes = getRemotes()
                        if remotes and remotes:FindFirstChild("PurchaseClickUpgrade") then remotes.PurchaseClickUpgrade:FireServer() end
                    end)
                end
            end)
       end,
    })

MainTab:CreateToggle({
       Name = "ð° Enable Auto Sell",
       CurrentValue = false,
       Flag = "ToggleSell",
       Callback = function(Value)
            autoSell = Value
            task.spawn(function()
                while autoSell do
                    task.wait(1)
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
               pcall(function()
                  local sellTab = game.Players.LocalPlayer.PlayerGui.PotatoGameGUI.Background.NavArea.TabContainer.SellPotatoesTabWrapper.SellTab
                  if sellTab and firesignal then
                     firesignal(sellTab.Activated)
                  end
                  
                  task.wait(0.3)
                  
                  local goldenSelector = game:GetService("Players").VayzEUx.PlayerGui.PotatoGameGUI.Background.ContentArea.ItemsScroll.ManualSellCard.ManualSellContent.SelectorContainer.GoldenSelector
                  if goldenSelector and firesignal then
                     firesignal(goldenSelector.Activated)
                  end
                  
                  task.wait(0.3)
                  

                  local sellButton = game:GetService("Players").VayzEUx.PlayerGui.PotatoGameGUI.Background.ContentArea.ItemsScroll.ManualSellCard.ManualSellContent.ButtonRow.SellAllButton
                  if sellButton and firesignal then
                     firesignal(sellButton.Activated)
                  end

                  task.wait(AutoSellDelay)
               end)
            end
         end)
      else
         Rayfield:Notify({
            Title = "AutoSell",
            Content = "AutoSell deaktiviert",
            Duration = 2,
            Image = 4483362458,
         })
      end
   end,
})

local DelaySlider = MainTab:CreateSlider({
   Name = "AutoSell Delay",
   Range = {0.5, 10},
   Increment = 0.5,
   Suffix = "s",
   CurrentValue = 1,
   Flag = "AutoSell_Delay",
   Callback = function(Value)
      AutoSellDelay = Value
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

local UnloadButton = SettingsTab:CreateButton({
   Name = "Unload UI",
   Callback = function()
      autoFarm = false
      autoUpgradeClick = false
      autoSell = false
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
