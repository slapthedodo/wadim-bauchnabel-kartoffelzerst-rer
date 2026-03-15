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
   Keybind = nil
})

local MainTab = Window:CreateTab("Main", 4483362458)

local AutoSellActive = false
local AutoSellDelay = 1

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
      Rayfield:Destroy()
   end,
})

Rayfield:Notify({
   Title = "karotten script",
   Content = "Bauchnabel geladen",
   Duration = 5,
   Image = 4483362458,
})
