local lp, UIS, TweenService = game:GetService("Players").LocalPlayer, game:GetService("UserInputService"), game:GetService("TweenService")
local gui = Instance.new("ScreenGui", lp.PlayerGui)
gui.Name, gui.ResetOnSpawn = "RYLQAdminPanel", false

-- Admin check
local admins = {"YourUsername"} -- Add usernames of admins here
if not table.find(admins, lp.Name) then return end -- If not an admin, don't show the panel

-- Create a sound effect
local sound = Instance.new("Sound", lp.Character)
sound.SoundId = "rbxassetid://183681313" -- Add any sound ID you like

local frame = Instance.new("Frame", gui)
frame.Size, frame.Position, frame.BackgroundColor3, frame.Active, frame.Draggable = UDim2.fromOffset(320, 460), UDim2.new(0, 50, 0.5, -230), Color3.new(), true, true

local title = Instance.new("TextLabel", frame)
title.Size, title.Text, title.TextColor3, title.Font, title.TextSize, title.BackgroundColor3 = UDim2.new(1, 0, 0, 40), "RYLQ'S ADMIN PANEL", Color3.new(1,1,1), Enum.Font.Legacy, 20, Color3.fromRGB(30,30,30)

local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size, toggleButton.Text, toggleButton.TextColor3, toggleButton.Font, toggleButton.TextSize, toggleButton.BackgroundColor3 = UDim2.new(0, 100, 0, 40), "Toggle", Color3.new(1,1,1), Enum.Font.Legacy, 18, Color3.fromRGB(200,0,0)
toggleButton.Position = UDim2.new(0, 5, 0, 40)
local toggle = false
toggleButton.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size, scroll.Position, scroll.ScrollBarThickness, scroll.BackgroundTransparency = UDim2.new(1, 0, 1, -100), UDim2.new(0, 0, 0, 80), 6, 1
local layout = Instance.new("UIListLayout", scroll)
layout.Padding, layout.SortOrder = UDim.new(0, 4), Enum.SortOrder.LayoutOrder

local commands = {
	["Speed"] = function(v) 
		lp.Character.Humanoid.WalkSpeed = tonumber(v) or 50
		sound:Play() 
	end,
	["JumpPower"] = function(v) 
		lp.Character.Humanoid.JumpPower = tonumber(v) or 150
		sound:Play() 
	end,
	["Reset Speed"] = function() 
		lp.Character.Humanoid.WalkSpeed = 16
		sound:Play() 
	end,
	["Reset Jump"] = function() 
		lp.Character.Humanoid.JumpPower = 50
		sound:Play() 
	end,
	["Fly"] = function() 
		local bv = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart)
		bv.Velocity, bv.MaxForce = Vector3.new(0, 50, 0), Vector3.new(0, math.huge, 0)
		game.Debris:AddItem(bv, 2)
		sound:Play() 
	end
}

for name, func in pairs(commands) do
	local btn = Instance.new("TextButton", scroll)
	btn.Size, btn.Text, btn.TextColor3, btn.Font, btn.TextSize, btn.BackgroundColor3 = UDim2.new(1, -10, 0, 40), name, Color3.new(1,1,1), Enum.Font.Legacy, 18, Color3.fromRGB(200,0,0)
	btn.Position, btn.AutoButtonColor = UDim2.new(0, 5, 0, 0), false
	local corner = Instance.new("UICorner", btn) corner.CornerRadius = UDim.new(0, 10)
	btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 30, 30)}):Play() end)
	btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 0, 0)}):Play() end)
	btn.MouseButton1Click:Connect(function() pcall(func) end)
end

scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y) end)

local input = Instance.new("TextBox", frame)
input.Size, input.Position, input.PlaceholderText = UDim2.new(1, -20, 0, 40), UDim2.new(0, 10, 1, -50), ":speed 100"
input.Font, input.TextSize, input.TextColor3, input.BackgroundColor3, input.BorderSizePixel = Enum.Font.Legacy, 18, Color3.new(1,1,1), Color3.fromRGB(20, 20, 20), 0
local corner = Instance.new("UICorner", input) corner.CornerRadius = UDim.new(0, 8)

local clearButton = Instance.new("TextButton", frame)
clearButton.Size, clearButton.Text, clearButton.TextColor3, clearButton.Font, clearButton.TextSize, clearButton.BackgroundColor3 = UDim2.new(0, 100, 0, 40), "Clear", Color3.new(1,1,1), Enum.Font.Legacy, 18, Color3.fromRGB(200,0,0)
clearButton.Position = UDim2.new(0, 5, 0, 80)
clearButton.MouseButton1Click:Connect(function()
	input.Text = ""
end)

input.FocusLost:Connect(function(enter)
	if enter then
		local args = input.Text:split(" ")
		local cmd, val = args[1]:gsub(":", ""):lower(), args[2]
		for k, f in pairs(commands) do
			if cmd == k:lower():gsub(" ", "") then
				pcall(f, val)
			else
				-- Display error message if command doesn't exist
				print("Error: Command not found.")
			end
		end
		input.Text = ""
	end
end)

UIS.InputBegan:Connect(function(i, g) 
	if not g and i.KeyCode == Enum.KeyCode.F then frame.Visible = not frame.Visible end
end)
