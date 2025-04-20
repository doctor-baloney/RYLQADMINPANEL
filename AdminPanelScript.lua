-- RYLQ'S ADMIN PANEL
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local guiOpen = true

-- GUI Creation
local adminGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
adminGui.Name = "RYLQ_Admin"
adminGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", adminGui)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
mainFrame.BorderSizePixel = 3
mainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
mainFrame.Size = UDim2.new(0, 300, 0, 300)
mainFrame.Active = true
mainFrame.Draggable = true

local title = Instance.new("TextLabel", mainFrame)
title.Text = "RYLQ'S ADMIN PANEL"
title.Font = Enum.Font.Legacy
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Position = UDim2.new(0, 0, 0, 0)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
title.TextStrokeTransparency = 0
title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

local commandBox = Instance.new("TextBox", mainFrame)
commandBox.PlaceholderText = "Type command here..."
commandBox.Font = Enum.Font.Legacy
commandBox.TextSize = 18
commandBox.Position = UDim2.new(0.05, 0, 0.8, 0)
commandBox.Size = UDim2.new(0.9, 0, 0.15, 0)
commandBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
commandBox.TextColor3 = Color3.fromRGB(0, 0, 0)

-- COMMANDS
local function fly()
	local torso = player.Character:WaitForChild("HumanoidRootPart")
	local flying = true
	local speed = 2
	local bg = Instance.new("BodyGyro", torso)
	local bv = Instance.new("BodyVelocity", torso)
	bg.P = 9e4
	bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	bg.CFrame = torso.CFrame
	bv.Velocity = Vector3.new(0, 0, 0)
	bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	
	game:GetService("RunService").RenderStepped:Connect(function()
		if flying then
			local camCF = workspace.CurrentCamera.CFrame
			bg.CFrame = camCF
			bv.Velocity = camCF.lookVector * speed
			player.Character:FindFirstChildOfClass("Humanoid").PlatformStand = true
		end
	end)

	mouse.KeyDown:Connect(function(k)
		if k == "e" then
			flying = not flying
			if not flying then
				bg:Destroy()
				bv:Destroy()
				player.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
			end
		elseif k == "z" then
			speed = speed + 1
		elseif k == "x" then
			speed = speed - 1
		end
	end)
end

local noclip = false
game:GetService("RunService").Stepped:Connect(function()
	if noclip and player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide == true then
				part.CanCollide = false
			end
		end
	end
end)

-- Command Handler
local commands = {
	fly = function() fly() end,
	noclip = function() noclip = not noclip end,
	ws = function(v) player.Character.Humanoid.WalkSpeed = tonumber(v) end,
	jp = function(v) player.Character.Humanoid.JumpPower = tonumber(v) end,
	kill = function(v)
		local target = game.Players:FindFirstChild(v)
		if target and target.Character then
			target.Character:BreakJoints()
		end
	end,
	respawn = function()
		local c = player.Character
		local pos = c:FindFirstChild("HumanoidRootPart").CFrame
		c:BreakJoints()
		wait(1)
		player.Character:MoveTo(pos.p)
	end,
	fling = function(v)
		local target = game.Players:FindFirstChild(v)
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			local body = Instance.new("BodyVelocity", target.Character.HumanoidRootPart)
			body.Velocity = Vector3.new(9999, 9999, 9999)
			body.MaxForce = Vector3.new(999999, 999999, 999999)
			wait(0.5)
			body:Destroy()
		end
	end,
	sit = function() player.Character.Humanoid.Sit = true end,
	reset = function() player:LoadCharacter() end,
	bring = function(v)
		local target = game.Players:FindFirstChild(v)
		if target and target.Character then
			target.Character:MoveTo(player.Character.HumanoidRootPart.Position + Vector3.new(3,0,0))
		end
	end,
}

commandBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local msg = commandBox.Text
		local args = string.split(msg, " ")
		local cmd = args[1]:lower()
		table.remove(args, 1)
		if commands[cmd] then
			commands[cmd](unpack(args))
		end
		commandBox.Text = ""
	end
end)

-- GUI TOGGLE
mouse.KeyDown:Connect(function(key)
	if key:lower() == "e" then
		guiOpen = not guiOpen
		adminGui.Enabled = guiOpen
	end
end)
