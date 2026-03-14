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
   Name = "Auto Sell",
   CurrentValue = false,
   Flag = "AutoSell_Toggle",
   Callback = function(Value)
      autoSell = Value
      task.spawn(function()
         while autoSell do
            task.wait(autoSellDelay)
            pcall(function()
               local remotes = getRemotes()
               if remotes then
                  if remotes:FindFirstChild("SellAllPotatoes") then
                     remotes.SellAllPotatoes:FireServer()
                  end
                  if remotes:FindFirstChild("SellAllGoldenPotatoes") then
                     remotes.SellAllGoldenPotatoes:FireServer()
                  end
               end
            end)
         end
      end)
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

