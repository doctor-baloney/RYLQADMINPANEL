-- Instances
local FlyScript = Instance.new("ScreenGui")
local Gradient = Instance.new("Frame")
local UIGradient = Instance.new("UIGradient")
local UICorner = Instance.new("UICorner")
local Button = Instance.new("TextButton")
local Shadow = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")

-- Properties
FlyScript.Name = "FlyScript"
FlyScript.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
FlyScript.ResetOnSpawn = false

Gradient.Name = "Gradient"
Gradient.Parent = FlyScript
Gradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Gradient.BorderColor3 = Color3.fromRGB(27, 42, 53)
Gradient.BorderSizePixel = 0
Gradient.Position = UDim2.new(0.0199062824, 0, 0.781767964, 0)
Gradient.Size = UDim2.new(0, 231, 0, 81)

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(57, 104, 252)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(51, 68, 175))}
UIGradient.Parent = Gradient

UICorner.CornerRadius = UDim.new(0.0399999991, 0)
UICorner.Parent = Gradient

Button.Name = "Button"
Button.Parent = Gradient
Button.BackgroundColor3 = Color3.fromRGB(77, 100, 150)
Button.BorderSizePixel = 0
Button.Position = UDim2.new(0.0921155736, 0, 0.238353431, 0)
Button.Size = UDim2.new(0, 187, 0, 41)
Button.ZIndex = 2
Button.Font = Enum.Font.GothamSemibold
Button.Text = ""
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextScaled = true
Button.TextSize = 14.000
Button.TextWrapped = true

Shadow.Name = "Shadow"
Shadow.Parent = Button
Shadow.BackgroundColor3 = Color3.fromRGB(53, 69, 103)
Shadow.BorderSizePixel = 0
Shadow.Size = UDim2.new(1, 0, 1, 4)

TextLabel.Parent = Gradient
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(27, 42, 53)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.487012982, 0, 0.5, 0)
TextLabel.Size = UDim2.new(0.878787875, -20, 0.728395045, -20)
TextLabel.ZIndex = 2
TextLabel.Font = Enum.Font.GothamBold
TextLabel.Text = "Fly"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

Button.MouseButton1Down:connect(function()
    -- Wait until player and necessary components are loaded
    repeat wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:findFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:findFirstChild("Humanoid")
    local mouse = game.Players.LocalPlayer:GetMouse()

    -- Flying variables
    local plr = game.Players.LocalPlayer
    local torso = plr.Character.HumanoidRootPart
    local flying = false
    local speed = 0
    local maxSpeed = 100
    local acceleration = 5
    local deceleration = 5
    local hoverHeight = 5
    local bg = nil
    local bv = nil
    local ctrl = {f = 0, b = 0, l = 0, r = 0}

    -- Start the flying function
    local function startFlying()
        -- Create BodyGyro and BodyVelocity
        bg = Instance.new("BodyGyro", torso)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = torso.CFrame

        bv = Instance.new("BodyVelocity", torso)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.velocity = Vector3.new(0, 0.1, 0)  -- Starting velocity

        -- Keep flying
        game:GetService("RunService").Heartbeat:Connect(function()
            if flying then
                -- Control speed and movement
                local moveDirection = (game.Workspace.CurrentCamera.CoordinateFrame.LookVector * (ctrl.f + ctrl.b)) +
                                      (game.Workspace.CurrentCamera.CoordinateFrame.RightVector * (ctrl.l + ctrl.r))
                bv.velocity = moveDirection * speed + Vector3.new(0, hoverHeight, 0)

                -- Smooth acceleration and deceleration
                if ctrl.f + ctrl.b ~= 0 or ctrl.l + ctrl.r ~= 0 then
                    speed = math.min(speed + acceleration, maxSpeed)  -- Gradual speed increase
                elseif speed > 0 then
                    speed = math.max(speed - deceleration, 0)  -- Gradual speed decrease
                end

                -- Update BodyGyro's CFrame
                bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 5), 0, 0)
            else
                -- If not flying, reset speed and remove BodyGyro/BodyVelocity
                speed = 0
                if bg then bg:Destroy() end
                if bv then bv:Destroy() end
            end
        end)
    end

    -- Handle input controls for flying
    local function handleControls()
        -- KeyPress event for moving the player while flying
        mouse.KeyDown:Connect(function(key)
            if key:lower() == "e" then
                -- Toggle flying
                flying = not flying
                if flying then
                    startFlying()
                else
                    if bg then bg:Destroy() end
                    if bv then bv:Destroy() end
                end
            elseif key:lower() == "w" then
                ctrl.f = 1  -- Move forward
            elseif key:lower() == "s" then
                ctrl.b = -1  -- Move backward
            elseif key:lower() == "a" then
                ctrl.l = -1  -- Move left
            elseif key:lower() == "d" then
                ctrl.r = 1  -- Move right
            end
        end)

        -- KeyRelease event to stop movement
        mouse.KeyUp:Connect(function(key)
            if key:lower() == "w" then
                ctrl.f = 0
            elseif key:lower() == "s" then
                ctrl.b = 0
            elseif key:lower() == "a" then
                ctrl.l = 0
            elseif key:lower() == "d" then
                ctrl.r = 0
            end
        end)
    end

    -- Initialize the flying control
    handleControls()
end)
