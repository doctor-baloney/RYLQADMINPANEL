-- Admin Panel Script
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.Name = "AdminPanel"
gui.ResetOnSpawn = false

local function createButton(parent, text, position, size, func)
    local button = Instance.new("TextButton", parent)
    button.Text = text
    button.Position = position
    button.Size = size
    button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 18
    button.MouseButton1Click:Connect(func)
    return button
end

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 400)
frame.Position = UDim2.new(0, 50, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = gui

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
title.Text = "Admin Panel"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

-- Fly Command
createButton(frame, "Fly", UDim2.new(0, 0, 0, 60), UDim2.new(1, 0, 0, 40), function()
    local flying = false
    local bodyGyro, bodyVelocity
    local function startFlying()
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
        bodyGyro.CFrame = player.Character.HumanoidRootPart.CFrame
        bodyGyro.Parent = player.Character.HumanoidRootPart

        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
        bodyVelocity.Velocity = Vector3.new(0, 50, 0)
        bodyVelocity.Parent = player.Character.HumanoidRootPart
        flying = true
    end

    local function stopFlying()
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
        flying = false
    end

    if flying then
        stopFlying()
    else
        startFlying()
    end
end)

-- Speed Command
createButton(frame, "Speed", UDim2.new(0, 0, 0, 110), UDim2.new(1, 0, 0, 40), function()
    local humanoid = player.Character.Humanoid
    humanoid.WalkSpeed = 200
end)

-- Godmode Command
createButton(frame, "Godmode", UDim2.new(0, 0, 0, 160), UDim2.new(1, 0, 0, 40), function()
    local humanoid = player.Character.Humanoid
    humanoid.Health = humanoid.Health
    humanoid.MaxHealth = math.huge
end)

-- Kick Command
createButton(frame, "Kick", UDim2.new(0, 0, 0, 210), UDim2.new(1, 0, 0, 40), function()
    local targetPlayerName = "PlayerName" -- Replace this with the target player name
    local targetPlayer = game.Players:FindFirstChild(targetPlayerName)
    if targetPlayer then
        targetPlayer:Kick("You have been kicked by the admin!")
    else
        print("Player not found!")
    end
end)

-- Teleport Command
createButton(frame, "Teleport", UDim2.new(0, 0, 0, 260), UDim2.new(1, 0, 0, 40), function()
    local targetPlayerName = "PlayerName" -- Replace this with the target player name
    local targetPlayer = game.Players:FindFirstChild(targetPlayerName)
    if targetPlayer then
        player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
    else
        print("Player not found!")
    end
end)

-- Change Weather Command
createButton(frame, "Change Weather", UDim2.new(0, 0, 0, 310), UDim2.new(1, 0, 0, 40), function()
    game.Lighting.TimeOfDay = "14:00:00"  -- Change to noon
    game.Lighting.FogEnd = 100000  -- Clear skies
end)

-- Announce Command
createButton(frame, "Announce", UDim2.new(0, 0, 0, 360), UDim2.new(1, 0, 0, 40), function()
    local message = "This is an announcement!"
    game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents").SayMessageRequest:FireServer(message, "All")
end)

-- Clear Inventory Command
createButton(frame, "Clear Inventory", UDim2.new(0, 0, 0, 410), UDim2.new(1, 0, 0, 40), function()
    local backpack = player.Backpack
    for _, item in pairs(backpack:GetChildren()) do
        item:Destroy()
    end
end)

-- Teleport to Spawn Command
createButton(frame, "TP to Spawn", UDim2.new(0, 0, 0, 460), UDim2.new(1, 0, 0, 40), function()
    local spawnLocation = game.Workspace:WaitForChild("SpawnLocation")
    player.Character.HumanoidRootPart.CFrame = spawnLocation.CFrame
end)

-- Reset Character Command
createButton(frame, "Reset Character", UDim2.new(0, 0, 0, 510), UDim2.new(1, 0, 0, 40), function()
    player.Character:BreakJoints()
end)

-- Close Admin Panel
createButton(frame, "Close Panel", UDim2.new(0, 0, 0, 560), UDim2.new(1, 0, 0, 40), function()
    gui:Destroy()
end)
]]):Invoke()
