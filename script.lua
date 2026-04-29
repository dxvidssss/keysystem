--[[
    ================================================================
    [ SCRIPT INFORMATION ]
    Project: Custom Script
    Author: OYB
    YouTube: https://www.youtube.com/channel/UCAlXXV1Hbvf7WbfXARuVtiQ
    
    [ TERMS AND CONDITIONS ]
    - You ARE allowed to use and modify this script for your own games.
    - You ARE NOT allowed to re-upload, redistribute, or claim 
      ownership of this script.
    - Removing or altering these credits is strictly prohibited.
    
    Copyright (c) 2026 OYB. All rights reserved.
    ================================================================
]]

-- ⚠️ IMPORTANT: Put this code at the VERY TOP of your Main Script (before obfuscating) ⚠️

local ProtectionConfig = {
    -- 🔴 CRITICAL: This MUST exactly match the 'Secret' value in your Key System's Config!
    -- If your Key System has: Secret = "Test"
    -- Then this must also be: SecretKey = "Test"
    SecretKey = "19451945",
    
    -- The name of your Hub (shown in the kick message if they try to bypass)
    HubName = "_zqyr.lua"
}

-- Anti-Bypass Logic: Checks if the Key System successfully set the global variable
if not _G[ProtectionConfig.SecretKey] then
    local player = game:GetService("Players").LocalPlayer
    if player then
        player:Kick("\n🛡️ Unauthorized Execution 🛡️\n\nPlease use the official Key System to run " .. ProtectionConfig.HubName)
    end
    return -- Stops the rest of the script from loading!
end

-------------------------------------------------------------------------------
-- 👇 YOUR MAIN SCRIPT CODE STARTS HERE 👇
-------------------------------------------------------------------------------
print(ProtectionConfig.HubName .. " Loaded Successfully!")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "OIL EMPIRE",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "",
   LoadingSubtitle = "by _zqyr",
   ShowText = "Rayfield", -- for mobile users to unhide Rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from emitting warnings when the script has a version mismatch with the interface.

   -- ScriptID = "sid_xxxxxxxxxxxx", -- Your Script ID from developer.sirius.menu — enables analytics, managed keys, and script hosting

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include Discord.gg/. E.g. Discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the Discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique, as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that the system will accept, can be RAW file links (pastebin, github, etc.) or simple strings ("hello", "key22")
   }
})

local autoSellEnabled = false 
local sogliaPrezzo = 10 
local velocitaVendita = 5 
local FarmTab = Window:CreateTab("FARM💲", 0)
local FarmSection = FarmTab:CreateSection("Money Farm")

local AutoSellToggle = FarmTab:CreateToggle({
   Name = "Auto Sell💱",
   CurrentValue = false,
   Flag = "ToggleAutoSell",
   Callback = function(Value)
      autoSellEnabled = Value

      if autoSellEnabled then
         task.spawn(function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local GasPriceValue = ReplicatedStorage:WaitForChild("GasPrice")
            local SellGasEvent = ReplicatedStorage:WaitForChild("Packages").Knit.Services.BaseService.RE.SellGas

            while autoSellEnabled do
               if GasPriceValue.Value >= sogliaPrezzo then
                  SellGasEvent:FireServer()
                  task.wait(velocitaVendita)
               else
                  task.wait(1) 
               end
            end
         end)
      end
   end,
})

FarmTab:CreateSlider({
   Name = "AS Price",
   Range = {1, 15},
   Increment = 1,
   Suffix = "$",
   CurrentValue = 10,
   Flag = "SliderPrice",
   Callback = function(Value)
      sogliaPrezzo = Value 
   end,
})

FarmTab:CreateSlider({
   Name = "AS Time (Seconds)",
   Range = {1, 60}, 
   Increment = 1,
   Suffix = " sec",
   CurrentValue = 5,
   Flag = "SliderTime",
   Callback = function(Value)
      velocitaVendita = Value 
   end,
})

local Button = FarmTab:CreateButton({
   Name = "DISPLAY CURRENT PRICE",
   Callback = function()
   loadstring(game:HttpGet('https://pastebin.com/raw/8zuexNNS'))()
   end,
})

local autoTouchEnabled = false

local function getMyBuildingsFolder()
    local lp = game.Players.LocalPlayer
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end

    for i = 1, 6 do
        local plot = plots:FindFirstChild("Plot" .. i)
        if plot and plot:FindFirstChild("Buildings") then
            local first = plot.Buildings:FindFirstChildOfClass("Model")
            if first then
                local ownerAttr = first:GetAttribute("Owner")
                local ownerObj = first:FindFirstChild("Owner")
                local ownerValue = ""

                if ownerAttr then 
                    ownerValue = tostring(ownerAttr)
                elseif ownerObj then
                    ownerValue = tostring(ownerObj.Value or ownerObj)
                end
                
                if ownerValue == lp.Name or ownerValue == lp.DisplayName or ownerObj == lp then
                    return plot.Buildings
                end
            end
        end
    end
    return nil
end

local function doSmartCollect()
    local lp = game.Players.LocalPlayer
    local character = lp.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local myBuildings = getMyBuildingsFolder()
    if not myBuildings then return end

    for _, model in pairs(myBuildings:GetChildren()) do
        local typeAttr = model:GetAttribute("Type")
        local typeObj = model:FindFirstChild("Type")
        local isRefinery = (typeAttr == "Refinery") or (typeObj and tostring(typeObj.Value) == "Refinery")
        
        if isRefinery then
            local currentStorage = model:GetAttribute("Storage") or (model:FindFirstChild("Storage") and model.Storage.Value) or 0
            local maxStorage = model:GetAttribute("MaxStorage") or (model:FindFirstChild("MaxStorage") and model.MaxStorage.Value) or 1 -- 1 per evitare divisioni per zero
            
            if tonumber(currentStorage) >= tonumber(maxStorage) then
                for _, descendant in pairs(model:GetDescendants()) do
                    if descendant:IsA("TouchTransmitter") then
                        local targetPart = descendant.Parent
                        if targetPart and targetPart:IsA("BasePart") then
                            -- Simula il tocco invisibile
                            firetouchinterest(hrp, targetPart, 0)
                            task.wait()
                            firetouchinterest(hrp, targetPart, 1)
                        end
                    end
                end
            end
        end
    end
end

local FarmSection = FarmTab:CreateSection("Auto Collect")
FarmTab:CreateToggle({
    Name = "Auto Collect Oil🛢",
    CurrentValue = false,
    Flag = "SmartSilent",
    Callback = function(Value)
        autoTouchEnabled = Value
        if autoTouchEnabled then
            task.spawn(function()
                while autoTouchEnabled do
                    doSmartCollect()
                    task.wait(1)
                end
            end)
        end
    end,
})

local MiscTab = Window:CreateTab("MISC", 0)

local Button = MiscTab:CreateButton({
   Name = "Anti AFK",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/evxncodes/mainroblox/main/anti-afk", true))()
   end,
})

