local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local autoFarm = false
local autoUpgradeClick = false
local autoPrestige = false
local autoAscension = false
local autoShop = false
local autoHideNotifications = false
local minPP = 1
local sellThreshold = 0
local notificationConn

local Window = WindUI:CreateWindow({
    Title = "karotten script",
    Icon = "rbxassetid://4483362458",
    Author = "Wadim",
    Folder = "karotte"
})

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "house"
})

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

local function scanAndBuy()
    local potatoGui = LocalPlayer.PlayerGui:FindFirstChild("PotatoGameGUI")
    if not potatoGui then return end
    
    local contentArea = potatoGui.Background.ContentArea
    local shopGrid = contentArea:FindFirstChild("ShopGridWrapper", true)

    if shopGrid then
        local items = shopGrid:GetChildren()
        
        for _, item in pairs(items) do
            if item:IsA("Frame") or item:IsA("ImageLabel") or string.find(item.Name, "Item") then
                local icon = item:FindFirstChild("CurrencyIcon", true)
                local buyButton = item:FindFirstChild("BuyButton", true)
                
                if icon and icon:IsA("ImageLabel") then
                    if icon.Image == "" then 
                        task.wait(.1) 
                    end
                    
                    if allowedIcons[icon.Image] and buyButton then
                        for _, eventName in pairs({"MouseButton1Click", "Activated"}) do
                            local signal = buyButton:FindFirstChild(eventName) or buyButton[eventName]
                            if signal then
                                for _, connection in pairs(getconnections(signal)) do
                                    connection:Fire()
                                end
                            end
                        end
                        task.wait(.1)
                    end
                end
            end
        end
    end
end

MainTab:Toggle({
    Title = "Auto Click",
    Value = false,
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

MainTab:Toggle({
    Title = "Auto Buy Best Upgrades",
    Value = false,
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

MainTab:Button({
    Title = "Claim Login & AFK Rewards",
    Callback = function()
        pcall(function()
            local remotes = getRemotes()
            if not remotes then return end
            if remotes:FindFirstChild("ClaimLoginStreak") then remotes.ClaimLoginStreak:FireServer() end
            if remotes:FindFirstChild("ClaimOfflineBoostBonus") then remotes.ClaimOfflineBoostBonus:FireServer() end
            WindUI:Notify({
                Title = "Rewards Claimed!",
                Content = "Login streak and AFK earnings have been added to your wallet.",
                Duration = 4
            })
        end)
    end,
})

MainTab:Toggle({
    Title = "Autosell golden carrots",
    Value = false,
    Callback = function(Value)
        AutoSellActive = Value
        if Value then
            WindUI:Notify({
                Title = "Autosell golden carrots",
                Content = "Autosell golden carrots active",
                Duration = 2
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
            WindUI:Notify({
                Title = "AutoSell",
                Content = "AutoSell deactivated",
                Duration = 2
            })
        end
    end,
})

MainTab:Slider({
    Title = "AutoSell Delay",
    Min = 0.25,
    Max = 5,
    Step = 0.25,
    Value = 1,
    Callback = function(Value)
        AutoSellDelay = Value
    end,
})

MainTab:Toggle({
    Title = "Auto Prestige",
    Value = false,
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

MainTab:Slider({
    Title = "Minimum PP for Prestige",
    Min = 1,
    Max = 100,
    Step = 1,
    Value = 1,
    Callback = function(Value)
        minPP = Value
    end,
})

MainTab:Toggle({
    Title = "Auto Ascension",
    Value = false,
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

MainTab:Toggle({
    Title = "Auto Shop",
    Value = false,
    Callback = function(Value)
        autoShop = Value
        if Value then
            task.spawn(function()
                while autoShop do
                    pcall(function()
                        local shopTab = LocalPlayer.PlayerGui.PotatoGameGUI.Background.NavArea.TabContainer.ShopTabWrapper.ShopTab
                        if shopTab and firesignal then
                            firesignal(shopTab.Activated)
                        end
                    end)
                    
                    task.wait(1)
                    
                    for i = 1, 25 do
                        if not autoShop then break end
                        pcall(scanAndBuy)
                        if i < 25 then task.wait(.5) end
                    end
                    
                    if autoShop then
                        task.wait(120)
                    end
                end
            end)
        end
    end,
})

local SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "settings"
})

SettingsTab:Toggle({
    Title = "Auto Hide Notifications",
    Value = false,
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

SettingsTab:Button({
    Title = "Unload UI",
    Callback = function()
        autoFarm = false
        autoUpgradeClick = false
        autoPrestige = false
        autoAscension = false
        autoShop = false
        autoHideNotifications = false
        if notificationConn then notificationConn:Disconnect() end
        AutoSellActive = false
        -- WindUI doesn't have a direct Destroy method in the same way, usually it's Window:Close() or similar
        -- But since we're using a loadstring library, we'll try to find a close method
        if Window.Close then
            Window:Close()
        end
    end,
})

WindUI:Notify({
    Title = "karotten script",
    Content = "Bauchnabel geladen",
    Duration = 5
})
