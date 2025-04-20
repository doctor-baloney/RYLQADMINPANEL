-- Admin Panel GUI Setup
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = PlayerGui
ScreenGui.Name = "RYLQ_AdminPanel"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Black Background
Frame.BorderSizePixel = 0
Frame.Size = UDim2.new(0, 300, 0, 500)
Frame.Position = UDim2.new(0, 20, 0, 100)

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Text = "RYLQ'S ADMIN PANEL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White Text
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Legacy
Title.TextSize = 24
Title.Size = UDim2.new(1, 0, 0, 50)
Title.TextAlign = Enum.TextXAlignment.Center

local FlyButton = Instance.new("TextButton")
FlyButton.Parent = Frame
FlyButton.Text = "Fly"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Button background black
FlyButton.BorderColor3 = Color3.fromRGB(255, 0, 0)  -- Red Border
FlyButton.Size = UDim2.new(0, 200, 0, 50)
FlyButton.Position = UDim2.new(0, 50, 0, 100)
FlyButton.Font = Enum.Font.Legacy
FlyButton.TextSize = 18

local SpeedButton = Instance.new("TextButton")
SpeedButton.Parent = Frame
SpeedButton.Text = "Speed"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Button background black
SpeedButton.BorderColor3 = Color3.fromRGB(255, 0, 0)  -- Red Border
SpeedButton.Size = UDim2.new(0, 200, 0, 50)
SpeedButton.Position = UDim2.new(0, 50, 0, 160)
SpeedButton.Font = Enum.Font.Legacy
SpeedButton.TextSize = 18

-- Fly Functionality
local flying = false
local bodyGyro, bodyVelocity
local speed = 50
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastCtrl = {f = 0, b = 0, l = 0, r = 0}

local function Fly()
    local character = Player.Character
    local humanoid = character and character:FindFirstChild("Humanoid")
    local torso = character and character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not torso then return end

    bodyGyro = Instance.new("BodyGyro", torso)
    bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    bodyGyro.P = 10000
    bodyGyro.CFrame = torso.CFrame

    bodyVelocity = Instance.new("BodyVelocity", torso)
    bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    bodyVelocity.Velocity = Vector3.new(0, 0.1, 0)

    humanoid.PlatformStand = true

    while flying do
        wait(0.1)
        local lookVector = game.Workspace.CurrentCamera.CFrame.lookVector
        local moveVector = (lookVector * (ctrl.f + ctrl.b)) + ((game.Workspace.CurrentCamera.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).p) - game.Workspace.CurrentCamera.CFrame.p)
        bodyVelocity.Velocity = moveVector * speed

        if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
            speed = math.min(speed + 0.5 + (speed / 50), 100)
        elseif ctrl.l + ctrl.r == 0 and ctrl.f + ctrl.b == 0 then
            speed = math.max(speed - 1, 0)
        end

        bodyGyro.CFrame = game.Workspace.CurrentCamera.CFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / 100), 0, 0)
    end

    bodyGyro:Destroy()
    bodyVelocity:Destroy()
    humanoid.PlatformStand = false
end

FlyButton.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        Fly()
    end
end)

SpeedButton.MouseButton1Click:Connect(function()
    speed = speed == 50 and 100 or 50  -- Toggle speed between 50 and 100
end)

-- GUI Toggle with E key
local guiVisible = true
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        guiVisible = not guiVisible
        ScreenGui.Enabled = guiVisible
    end
end)

-- Add more commands if needed
