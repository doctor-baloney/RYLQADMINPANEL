loadstring([[
-- Admin Panel Script

local Players, UIS, TweenService = game:GetService("Players"), game:GetService("UserInputService"), game:GetService("TweenService")
local lp = Players.LocalPlayer
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name, gui.ResetOnSpawn = "RYLQAdminPanel", false

local function createUICorner(parent, rad) 
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, rad or 10) 
end

local frame = Instance.new("Frame", gui)
frame.Size, frame.Position, frame.BackgroundColor3, frame.Active, frame.Draggable = UDim2.fromOffset(320, 460), UDim2.new(0, 50, 0.5, -230), Color3.new(), true, true

local title = Instance.new("TextLabel", frame)
title.Size, title.Text, title.TextColor3, title.Font, title.TextSize, title.BackgroundColor3 = UDim2.new(1, 0, 0, 40), "RYLQ'S ADMIN PANEL", Color3.new(1,1,1), Enum.Font.Legacy, 20, Color3.fromRGB(30,30,30)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size, scroll.Position, scroll.CanvasSize, scroll.ScrollBarThickness, scroll.BackgroundTransparency = UDim2.new(1, 0, 1, -100), UDim2.new(0, 0, 0, 40), UDim2.new(), 6, 1
local layout = Instance.new("UIListLayout", scroll)
layout.Padding, layout.SortOrder = UDim.new(0, 4), Enum.SortOrder.LayoutOrder

local commands = {
    ["Speed"] = function(v) lp.Character.Humanoid.WalkSpeed = tonumber(v) or 50 end,
    ["JumpPower"] = function(v) lp.Character.Humanoid.JumpPower = tonumber(v) or 150 end,
    ["Reset Speed"] = function() lp.Character.Humanoid.WalkSpeed = 16 end,
    ["Reset Jump"] = function() lp.Character.Humanoid.JumpPower = 50 end,
    ["Fly (Simple)"] = function()
        local bv = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart)
        bv.Velocity, bv.MaxForce = Vector3.new(0, 50, 0), Vector3.new(0, math.huge, 0)
        game.Debris:AddItem(bv, 2)
    end,
    ["God Mode"] = function()
        lp.Character.Humanoid.Health = math.huge
        lp.Character.Humanoid.HealthChanged:Connect(function() lp.Character.Humanoid.Health = math.huge end)
    end,
    ["Noclip"] = function()
        local function noclip()
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                lp.Character.HumanoidRootPart.CanCollide = false
                for _, part in pairs(lp.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
        noclip()
    end,
    ["Kill Me"] = function() lp.Character:BreakJoints() end,
    ["Invisible"] = function()
        if lp.Character and lp.Character:FindFirstChild("Head") then
            lp.Character.Head.Transparency = 1
            for _, part in pairs(lp.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                end
            end
        end
    end,
    ["Uninvisible"] = function()
        if lp.Character and lp.Character:FindFirstChild("Head") then
            lp.Character.Head.Transparency = 0
            for _, part in pairs(lp.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end
        end
    end,
    ["Fly (Smooth)"] = function()
        local mouse = game.Players.LocalPlayer:GetMouse()
        local flying = false
        local bodyGyro, bodyVelocity
        local speed = 0
        local maxSpeed = 50
        local control = {f = 0, b = 0, l = 0, r = 0}
        local lastControl = {f = 0, b = 0, l = 0, r = 0}
        local humanoidRootPart = lp.Character:WaitForChild("HumanoidRootPart")
        local humanoid = lp.Character:WaitForChild("Humanoid")

        function startFlying()
            bodyGyro = Instance.new("BodyGyro", humanoidRootPart)
            bodyGyro.P = 9e4
            bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyGyro.cframe = humanoidRootPart.CFrame

            bodyVelocity = Instance.new("BodyVelocity", humanoidRootPart)
            bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyVelocity.Velocity = Vector3.new(0, 50, 0)

            while flying do
                if control.f + control.b ~= 0 or control.l + control.r ~= 0 then
                    speed = speed + 0.5 + (speed / maxSpeed)
                    if speed > maxSpeed then
                        speed = maxSpeed
                    end
                else
                    if speed > 0 then
                        speed = speed - 1
                    end
                end

                bodyVelocity.Velocity = (game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (control.f + control.b) + 
                    (game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(control.l + control.r, (control.f + control.b) * 0.2, 0).p) - 
                    game.Workspace.CurrentCamera.CoordinateFrame.p) * speed

                bodyGyro.cframe = game.Workspace.CurrentCamera.CoordinateFrame * 
                    CFrame.Angles(-math.rad((control.f + control.b) * 50 * speed / maxSpeed), 0, 0)
                wait()
            end
            bodyGyro:Destroy()
            bodyVelocity:Destroy()
            humanoid.PlatformStand = false
        end

        function stopFlying()
            flying = false
            humanoid.PlatformStand = false
        end

        mouse.KeyDown:Connect(function(key)
            if key:lower() == "e" then
                flying = not flying
                if flying then
                    startFlying()
                else
                    stopFlying()
                end
            elseif key:lower() == "w" then
                control.f = 1
            elseif key:lower() == "s" then
                control.b = -1
            elseif key:lower() == "a" then
                control.l = -1
            elseif key:lower() == "d" then
                control.r = 1
            end
        end)

        mouse.KeyUp:Connect(function(key)
            if key:lower() == "w" then
                control.f = 0
            elseif key:lower() == "s" then
                control.b = 0
            elseif key:lower() == "a" then
                control.l = 0
            elseif key:lower() == "d" then
                control.r = 0
            end
        end)
    end
}

for name, func in pairs(commands) do
    local btn = Instance.new("TextButton", scroll)
    btn.Size, btn.Text, btn.TextColor3, btn.Font, btn.TextSize = UDim2.new(1, -10, 0, 40), name, Color3.new(1,1,1), Enum.Font.Legacy, 18
    btn.Position, btn.BackgroundColor3, btn.AutoButtonColor = UDim2.new(0, 5, 0, 0), Color3.fromRGB(200,0,0), false
    createUICorner(btn)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 30, 30)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 0, 0)}):Play()
    end)
    btn.MouseButton1Click:Connect(function() pcall(func) end)
end

scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end)

local input = Instance.new("TextBox", frame)
input.Size, input.Position, input.PlaceholderText = UDim2.new(1, -20, 0, 40), UDim2.new(0, 10, 1, -50), "Type command (e.g. :speed 100)"
input.Font, input.TextSize, input.TextColor3, input.BackgroundColor3 = Enum.Font.Legacy, 18, Color3.new(1,1,1), Color3.fromRGB(20, 20, 20)
input.BorderSizePixel, input.ClearTextOnFocus = 0, false
createUICorner(input, 8)

input.FocusLost:Connect(function(enter)
    if not enter then return end
    local args = input.Text:split(" ")
    local cmd, val = args[1]:gsub(":", ""):lower(), args[2]
    for k, f in pairs(commands) do
        if cmd == k:lower():gsub(" ", "") then
            pcall(f, val)
        end
    end
    input.Text = ""
end)

UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.F then
        frame.Visible = not frame.Visible
    end
end)
]]))()
