local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

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
   Keybind = "K"
})

local MainTab = Window:CreateTab("Main", 4483362458)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local autoSell = false
local autoClick = false
local autoSellDelay = 1

local function getRemotes()
   return ReplicatedStorage:FindFirstChild("Remotes")
end


local AutoSellToggle = MainTab:CreateToggle({
   Name = "Auto Sell (Golden)",
   CurrentValue = false,
   Flag = "AutoSell_Toggle",
   Callback = function(Value)
      autoSell = Value
      if Value then
         Rayfield:Notify({
            Title = "Auto Sell",
            Content = "Auto Sell Activated",
            Duration = 2,
            Image = 4483362458,
         })
         task.spawn(function()
            while autoSell do
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

                  task.wait(autoSellDelay)
               end)
            end
         end)
      else
         Rayfield:Notify({
            Title = "Auto Sell",
            Content = "Auto Sell Deactivated",
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
      autoSellDelay = Value
   end,
})

local AutoClickToggle = MainTab:CreateToggle({
   Name = "Auto Click",
   CurrentValue = false,
   Flag = "AutoClick_Toggle",
   Callback = function(Value)
      autoClick = Value
      task.spawn(function()
         while autoClick do
            task.wait(0.01)
            pcall(function()
               local remotes = getRemotes()
               if remotes and remotes:FindFirstChild("PerformClick") then
                  remotes.PerformClick:FireServer()
               end
            end)
         end
      end)
   end,
})

MainTab:CreateButton({
   Name = " Claim Login & AFK Rewards",
   Callback = function()
      pcall(function()
         local remotes = getRemotes()
         if not remotes then return end
         if remotes:FindFirstChild("ClaimLoginStreak") then remotes.ClaimLoginStreak:FireServer() end
         if remotes:FindFirstChild("ClaimOfflineBoostBonus") then remotes.ClaimOfflineBoostBonus:FireServer() end
         Rayfield:Notify({Title = "Rewards Claimed!", Content = "Login streak and AFK earnings gelegt.", Duration = 4, Image = 4483362458})
      end)
   end,
})

MainTab:CreateButton({
   Name = " Get Key",
   Callback = function()
      pcall(function()
         if setclipboard then
            setclipboard("test")
            Rayfield:Notify({Title = "Copied!", Content = "Link copied to clipboard.", Duration = 4, Image = 4483362458})
         else
            Rayfield:Notify({Title = "Link", Content = "test", Duration = 6, Image = 4483362458})
         end
      end)
   end,
})

MainTab:CreateButton({
   Name = " Test Prestige Points",
   Callback = function()
      pcall(function()
         local ppText = game:GetService("Players").VayzEUx.PlayerGui.PotatoGameGUI.Background.ContentArea.ItemsScroll.PrestigeCard.SummaryBlock.SummaryStats.PPBlock.Gain.Text
         Rayfield:Notify({Title = "Prestige Punkte", Content = ppText or "Konnte nicht gelesen werden", Duration = 4, Image = 4483362458})
      end)
   end,
})

local SettingsTab = Window:CreateTab("Settings", 4483362458)

local UIToggleKeybind = SettingsTab:CreateKeybind({
   Name = "UI Toggle Hotkey",
   CurrentKeybind = "K",
   HoldToInteract = false,
   Flag = "UI_Toggle_Hotkey",
   Callback = function(Key)
      Window:Toggle()
   end,
})

local UnloadButton = SettingsTab:CreateButton({
   Name = "Unload UI",
   Callback = function()
      Rayfield:Destroy()
   end,
})

Rayfield:Notify({
   Title = "karotten script",
   Content = "Bauchnabel geladen",
   Duration = 5,
   Image = 4483362458,
})


-- // meÄ±ster | Custom Key System by Rayfield UI //

local ValidKey = "X8L9-QW2P"
local KeyLink = "https://link-hub.net/4009537/EkpFXNDutuwt"

-- ===========================================
-- =           MAIN SCRIPT CODES             =
-- ===========================================
local function LoadMainScript()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    
    local Window = Rayfield:CreateWindow({
       Name = "ð¥ Idle Potato",
       LoadingTitle = "meÄ±ster Loading...",
       LoadingSubtitle = "by meÄ±ster",
       ConfigurationSaving = {
          Enabled = true,
          FolderName = "MeisterHub",
          FileName = "IdlePotatoHub"
       },
       Discord = {
          Enabled = false,
          Invite = "", 
          RememberJoins = true 
       },
       KeySystem = false -- Disabled because we use our custom key system frame
    })

    local MainTab = Window:CreateTab("Main Menu", 4483362458)
    MainTab:CreateParagraph({Title = "Welcome to meÄ±ster", Content = "You can use the 'Right CTRL' key on your keyboard to hide the menu."})

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local autoFarm = false
    local autoUpgradeClick = false
    local autoPotion = false
    local autoSell = false
    local sellThreshold = 0

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
       Name = "ð¥ Fast Click (Auto Farm)",
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
       Name = "â¬ï¸ Auto Upgrade Click",
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
       Name = "ð§ª Auto Use Potions (All)",
       CurrentValue = false,
       Flag = "TogglePotion",
       Callback = function(Value)
            autoPotion = Value
            task.spawn(function()
                while autoPotion do
                    task.wait(5)
                    pcall(function()
                        local remotes = getRemotes()
                        if remotes and remotes:FindFirstChild("UsePotion") then
                            remotes.UsePotion:FireServer("Speed")
                            remotes.UsePotion:FireServer("Luck")
                            remotes.UsePotion:FireServer("Click")
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

    MainTab:CreateSection("ð° Smart Auto Sell")
    MainTab:CreateInput({
       Name = "Sell Threshold Limit",
       PlaceholderText = "Ex: 10M",
       RemoveTextAfterFocusLost = false,
       Callback = function(Text)
            sellThreshold = parseNumber(Text)
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

    Rayfield:Notify({
       Title = "Loading Complete",
       Content = "The script has been fully loaded.",
       Duration = 5,
       Image = 4483362458,
    })
end

-- ===========================================
-- =               KEY SYSTEM                =
-- ===========================================
local function LoadKeySystem()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    
    local Window = Rayfield:CreateWindow({
       Name = "ð Key System",
       LoadingTitle = "Checking Status...",
       LoadingSubtitle = "by meÄ±ster",
       ConfigurationSaving = { Enabled = false },
       KeySystem = false
    })

    local KeyTab = Window:CreateTab("Login", 4483362458)
    
    KeyTab:CreateParagraph({
        Title = "Welcome to meÄ±ster",
        Content = "Please verify your access key below to load the main script. If you don't have a key, click 'Get Key'."
    })

    local KeyInputVal = ""
    KeyTab:CreateInput({
       Name = "Key",
       PlaceholderText = "Paste your key here...",
       RemoveTextAfterFocusLost = false,
       Callback = function(Text)
            KeyInputVal = Text:match("^%s*(.-)%s*$") or ""
       end,
    })
    
    KeyTab:CreateButton({
       Name = "â Verify Key",
       Callback = function()
            if KeyInputVal == ValidKey then
                Rayfield:Notify({Title = "Success!", Content = "Key Verified. Loading...", Duration = 2, Image = 4483362458})
                task.wait(1)
                Rayfield:Destroy() -- Close Key UI
                task.wait(0.5)
                LoadMainScript()   -- Load the main script
            else
                Rayfield:Notify({Title = "Invalid Key!", Content = "Please get a valid key and try again.", Duration = 4, Image = 4483362458})
            end
       end,
    })
    
    KeyTab:CreateButton({
       Name = "ð Get Key",
       Callback = function()
            pcall(function()
                if setclipboard then
                    setclipboard(KeyLink)
                    Rayfield:Notify({Title = "Copied!", Content = "Link copied to clipboard. Paste it in your browser.", Duration = 4, Image = 4483362458})
                else
                    Rayfield:Notify({Title = "Link", Content = KeyLink, Duration = 6, Image = 4483362458})
                end
            end)
       end,
    })
end

LoadKeySystem()