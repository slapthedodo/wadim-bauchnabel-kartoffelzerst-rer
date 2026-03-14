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

local Button = MainTab:CreateButton({
   Name = "test",
   Callback = function()
      pcall(function()
          local sellButton = game:GetService("Players").VayzEUx.PlayerGui.PotatoGameGUI.Background.ContentArea.ItemsScroll.ManualSellCard.ManualSellContent.ButtonRow.SellAllButton
          if sellButton and firesignal then
              firesignal(sellButton.MouseButton1Click)
          end
      end)
   end,
})

local Button2 = MainTab:CreateButton({
   Name = "niga",
   Callback = function()
      pcall(function()
          local tabButton = game:GetService("Players").VayzEUx.PlayerGui.PotatoGameGUI.Background.NavArea.TabContainer.SellPotatoesTabWrapper.SellTab
          if tabButton and firesignal then
              firesignal(tabButton.MouseButton1Click)
          end
      end)
   end,
})

local SettingsTab = Window:CreateTab("Settings", 4483362458)

local UnloadButton = SettingsTab:CreateButton({
   Name = "Unload UI",
   Callback = function()
      Rayfield:Destroy()
   end,
})

local Keybind = SettingsTab:CreateKeybind({
   Name = "UI Toggle",
   CurrentKeybind = "K",
   HoldToInteract = false,
   Flag = "UI_Toggle_Key",
   Callback = function(Key)
   end,
})

Rayfield:Notify({
   Title = "karotten script",
   Content = "Bauchnabel geladen",
   Duration = 5,
   Image = 4483362458,
})
