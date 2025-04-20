-- Variables for GUI
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- black background
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 0, 0) -- red border

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "RYLQ'S ADMIN PANEL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.Font = Enum.Font.Legacy
title.TextAlign = Enum.TextAlign.Center

local buttonFly = Instance.new("TextButton")
buttonFly.Parent = frame
buttonFly.Size = UDim2.new(1, -20, 0, 50)
buttonFly.Position = UDim2.new(0, 10, 0, 60)
buttonFly.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
buttonFly.Text = "Toggle Fly"
buttonFly.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonFly.TextSize = 20
buttonFly.Font = Enum.Font.Legacy

local buttonSpeed = Instance.new("TextButton")
buttonSpeed.Parent = frame
buttonSpeed.Size = UDim2.new(1, -20, 0, 50)
buttonSpeed.Position = UDim2.new(0, 10, 0, 120)
buttonSpeed.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
buttonSpeed.Text = "Toggle Speed"
buttonSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonSpeed.TextSize = 20
buttonSpeed.Font = Enum.Font.Legacy

local buttonNoclip = Instance.new("TextButton")
buttonNoclip.Parent = frame
buttonNoclip.Size = UDim2.new(1, -20, 0, 50)
buttonNoclip.Position = UDim2.new(0, 10, 0, 180)
buttonNoclip.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
buttonNoclip.Text = "Toggle Noclip"
buttonNoclip.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonNoclip.TextSize = 20
buttonNoclip.Font = Enum.Font.Legacy

-- Variables for fly functionality
local flying = false
local speed = 0
local flySpeed = 50
local bodyGyro, bodyVelocity

-- Variables for noclip
local noclip = false

-- Fly function like Kohl's Admin
local function fly()
    local torso = player.Character:WaitForChild("HumanoidRootPart")
    local humanoid = player.Character:WaitForChild("Humanoid")
    
    if flying then
        bodyGyro = Instance.new("BodyGyro", torso)
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
        bodyGyro.CFrame = torso.CFrame
        
        bodyVelocity = Instance.new("BodyVelocity", torso)
        bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        
        repeat wait()
            humanoid.PlatformStand = true
            bodyVelocity.Velocity = torso.CFrame.lookVector * flySpeed
        until not flying
        
        bodyGyro:Destroy()
        bodyVelocity:Destroy()
        humanoid.PlatformStand = false
    end
end

-- Speed function to modify player walk speed
local function setSpeed(value)
    local humanoid = player.Character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = value
end

-- Noclip function to enable/disable noclip mode
local function toggleNoclip()
    noclip = not noclip
    local character = player.Character
    local humanoid = character:WaitForChild("Humanoid")

    if noclip then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Button actions
buttonFly.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        fly()
    end
end)

buttonSpeed.MouseButton1Click:Connect(function()
    local speedInput = tonumber(game:GetService("UserInputService"):InputBegan:Wait())
    if speedInput then
        setSpeed(speedInput)
    end
end)

buttonNoclip.MouseButton1Click:Connect(function()
    toggleNoclip()
end)

-- Toggle GUI visibility with "E" key
local guiVisible = true
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        guiVisible = not guiVisible
        screenGui.Enabled = guiVisible
    end
end)

-- Set default speed and fly state
setSpeed(16)
fly()
