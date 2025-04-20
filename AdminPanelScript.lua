-- Admin Panel Script for Delta Executor

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "AdminPanel"
gui.ResetOnSpawn = false

-- Create the main panel
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 300, 0, 400)
panel.Position = UDim2.new(0.5, -150, 0.5, -200)
panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
panel.BorderSizePixel = 0
panel.Visible = true

-- Panel title
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "Admin Panel"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.BackgroundTransparency = 1

-- Add a UIListLayout for easy positioning
local layout = Instance.new("UIListLayout", panel)
layout.Padding = UDim.new(0, 5)
layout.FillDirection = Enum.FillDirection.Vertical

-- Function to create buttons dynamically
local function createButton(text, callback)
    local button = Instance.new("TextButton", panel)
    button.Size = UDim2.new(1, 0, 0, 50)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 18
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.BorderSizePixel = 0
    button.MouseButton1Click:Connect(callback)
end

-- Function for teleporting the player to a location
createButton("Teleport to Spawn", function()
    local spawn = game.Workspace:FindFirstChild("SpawnLocation")
    if spawn then
        player.Character:SetPrimaryPartCFrame(spawn.CFrame)
    else
        warn("SpawnLocation not found")
    end
end)

-- Function for flying
local flying = false
local speed = 50
local bodyVelocity
local bodyGyro

createButton("Toggle Fly", function()
    if flying then
        flying = false
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        player.Character.Humanoid.PlatformStand = false
    else
        flying = true
        local character = player.Character
        local torso = character:WaitForChild("HumanoidRootPart")

        bodyGyro = Instance.new("BodyGyro", torso)
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
        bodyGyro.CFrame = torso.CFrame

        bodyVelocity = Instance.new("BodyVelocity", torso)
        bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)

        bodyGyro.CFrame = torso.CFrame
        bodyVelocity.Velocity = Vector3.new(0, 1, 0) * speed

        player.Character.Humanoid.PlatformStand = true
    end
end)

-- Function to change speed
createButton("Increase Speed", function()
    speed = speed + 10
    print("Current Speed: " .. speed)
end)

-- Function to toggle noclip (no collision with parts)
local noclip = false
createButton("Toggle Noclip", function()
    noclip = not noclip
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")
    
    if noclip then
        humanoid.PlatformStand = true
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("Part") then
                part.CanCollide = false
            end
        end
    else
        humanoid.PlatformStand = false
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("Part") then
                part.CanCollide = true
            end
        end
    end
end)

-- Function to kill the player (suicide)
createButton("Kill Player", function()
    player.Character:BreakJoints()
end)

-- Function to clear player's tools
createButton("Clear Tools", function()
    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool:Destroy()
        end
    end
end)

-- Function to mute the player (stop sound)
createButton("Mute Player", function()
    local character = player.Character
    if character then
        for _, sound in pairs(character:GetDescendants()) do
            if sound:IsA("Sound") then
                sound:Stop()
            end
        end
    end
end)

-- Function to teleport to a random player
createButton("Teleport to Random Player", function()
    local allPlayers = game.Players:GetPlayers()
    local randomPlayer = allPlayers[math.random(1, #allPlayers)]
    if randomPlayer.Character then
        player.Character:SetPrimaryPartCFrame(randomPlayer.Character.HumanoidRootPart.CFrame)
    end
end)

-- Make the admin panel draggable
panel.Active = true
panel.Draggable = true

