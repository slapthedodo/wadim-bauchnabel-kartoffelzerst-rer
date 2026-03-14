local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "karotten script",
   LoadingTitle = "Bauchnabel wird geladen",
   LoadingSubtitle = " ",
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
    }
})

local MainTab = Window:CreateTab("Main", 4483362458)

local Button = MainTab:CreateButton({
   Name = "test",
   Callback = function()
      print("niga")
      local success, err = pcall(function()
          local sellButton = game:GetService("Players").VayzEUx.PlayerGui.PotatoGameGUI.Background.ContentArea.ItemsScroll.ManualSellCard.ManualSellContent.ButtonRow.SellAllButton
          
          if sellButton then
              if sellButton:IsA("GuiButton") then
                  sellButton:Activate()
              elseif firesignal then

                  firesignal(sellButton.MouseButton1Click)
                  print("signal fired")
              end
          end
      end)
   end,
})

local Button2 = MainTab:CreateButton({
   Name = "niga",
   Callback = function()
      local success, err = pcall(function()
          local tabButton = game:GetService("Players").VayzEUx.PlayerGui.PotatoGameGUI.Background.NavArea.TabContainer.SellPotatoesTabWrapper.SellTab
          
          if tabButton then
              if tabButton:IsA("GuiButton") then
                  tabButton:Activate()
                  print("active")
              elseif firesignal then
                  firesignal(tabButton.MouseButton1Click)
                  print("MouseButton1Click")
              else
                  if firesignal then
                      firesignal(tabButton.MouseButton1Down)
                      firesignal(tabButton.MouseButton1Up)
                  end
                  print("wrapper fallback")
              end
          end
      end)
      if not success then warn(err) end
   end,
})

-- SETTINGS TAB
local SettingsTab = Window:CreateTab("Settings", 4483362458)

local UnloadButton = SettingsTab:CreateButton({
   Name = "Unload UI",
   Callback = function()
      Rayfield:Destroy()
   end,
})

local HideButton = SettingsTab:CreateButton({
   Name = "Hide Menu",
   Callback = function()
      Rayfield:Notify({
         Title = "Info",
         Content = "Use 'Right Control' to hide the menu",
         Duration = 5,
         Image = 4483362458,
      })
   end,
})


Rayfield:Notify({
   Title = "karotten script",
   Content = "Bauchnabel geladen",
   Duration = 5,
   Image = 4483362458,
})

