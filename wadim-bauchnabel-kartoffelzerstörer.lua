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
      Note = " ",
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

Rayfield:Notify({
   Title = "karotten script",
   Content = "Bauchnabel geladen",
   Duration = 5,
   Image = 4483362458,
})
