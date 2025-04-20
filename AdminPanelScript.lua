-- RYLQ's Admin Panel by ChatGPT
-- Works in Delta Executor (R6 only)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local human = char:WaitForChild("Humanoid")
local mouse = player:GetMouse()

-- MAIN GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "RYLQAdmin"
gui.ResetOnSpawn = false

-- PANEL FRAME
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 300, 0, 350)
panel.Position = UDim2.new(0.02, 0, 0.3, 0)
panel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
panel.BorderColor3 = Color3.fromRGB(255, 0, 0)
panel.BorderSizePixel = 3
panel.Draggable = true
panel.Active = true

-- TITLE
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "RYLQ'S ADMIN PANEL"
title.Font = Enum.Font.Legacy
title.TextSize = 20
title.TextColor3 = Color3.new(1, 1, 1)
title.TextStrokeTransparency = 0
title.TextStrokeColor3 = Color3.new(0, 0, 0)

-- SCROLLING COMMAND LIST
local scroll = Instance.new("ScrollingFrame", panel)
scroll.Position = UDim2.new(0, 10, 0, 40)
scroll.Size = UDim2.new(1, -20, 0, 200)
scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
scroll.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
scroll.BorderSizePixel = 0

-- Command TextBox
local input = Instance.new("TextBox", panel)
input.Size = UDim2.new(1, -20, 0, 30)
input.Position = UDim2.new(0, 10, 1, -40)
input.PlaceholderText = "Enter command..."
input.Font = Enum.Font.Legacy
input.TextColor3 = Color3.new(1, 1, 1)
input.TextStrokeTransparency = 0
input.TextStrokeColor3 = Color3.new(0, 0, 0)
input.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
input.ClearTextOnFocus = false

-- Hide Toggle
local visible = true
UIS.InputBegan:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.E then
		visible = not visible
		gui.Enabled = visible
	end
end)

-- Add command entries
local function addCmdLabel(text)
	local lbl = Instance.new("TextLabel", scroll)
	lbl.Size = UDim2.new(1, -10, 0, 20)
	lbl.Text = text
	lbl.Font = Enum.Font.Legacy
	lbl.TextColor3 = Color3.new(0, 0, 0)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.BackgroundTransparency = 1
end

-- Add commands to scroll panel
local commands = {
	"fly", "unfly", "noclip", "clip", "speed [num]", "jump [num]",
	"kill", "reset", "god", "ungod", "bring [player]", "tp [player]",
	"cmds", "clear", "walkspeed [num]"
}

for _,cmd in ipairs(commands) do
	addCmdLabel("> "..cmd)
end

-- COMMANDS

local flying = false
local noclip = false
local speed = 16

local function toggleFly()
	if flying then return end
	flying = true
	local bg = Instance.new("BodyGyro", char:FindFirstChild("HumanoidRootPart"))
	bg.P = 9e4
	bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	bg.CFrame = char.HumanoidRootPart.CFrame

	local bv = Instance.new("BodyVelocity", char:FindFirstChild("HumanoidRootPart"))
	bv.Velocity = Vector3.new(0,0.1,0)
	bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

	local ctrl = {f = 0, b = 0, l = 0, r = 0}
	local speed = 5

	local function onInput(input, gpe)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			local k = input.KeyCode
			if k == Enum.KeyCode.W then ctrl.f = 1 end
			if k == Enum.KeyCode.S then ctrl.b = -1 end
			if k == Enum.KeyCode.A then
