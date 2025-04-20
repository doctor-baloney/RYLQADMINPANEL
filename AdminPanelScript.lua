-- RYLQ'S ADMIN PANEL (Custom Infinite Yield Style)
if game.CoreGui:FindFirstChild("RYLQsAdmin") then
    game.CoreGui:FindFirstChild("RYLQsAdmin"):Destroy()
end

-- UI Setup
local RYLQAdmin = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CmdBox = Instance.new("TextBox")
local Output = Instance.new("TextLabel")

RYLQAdmin.Name = "RYLQsAdmin"
RYLQAdmin.ResetOnSpawn = false
RYLQAdmin.Parent = game.CoreGui

Frame.Name = "Main"
Frame.Parent = RYLQAdmin
Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- RED theme
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.25, 0, 0.25, 0)
Frame.Size = UDim2.new(0, 400, 0, 250)
Frame.Active = true
Frame.Draggable = true

Title.Name = "Title"
Title.Parent = Frame
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White bar
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.Legacy
Title.Text = "RYLQ'S ADMIN PANEL"
Title.TextColor3 = Color3.fromRGB(0, 0, 0) -- Black text
Title.TextStrokeTransparency = 0
Title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Title.TextScaled = true

CmdBox.Name = "CmdBox"
CmdBox.Parent = Frame
CmdBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CmdBox.Position = UDim2.new(0.05, 0, 0.25, 0)
CmdBox.Size = UDim2.new(0.9, 0, 0, 40)
CmdBox.Font = Enum.Font.Legacy
CmdBox.PlaceholderText = "Enter a command..."
CmdBox.Text = ""
CmdBox.TextColor3 = Color3.fromRGB(0, 0, 0)
CmdBox.TextStrokeTransparency = 0
CmdBox.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
CmdBox.TextScaled = true

Output.Name = "Output"
Output.Parent = Frame
Output.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Output.Position = UDim2.new(0.05, 0, 0.5, 0)
Output.Size = UDim2.new(0.9, 0, 0.4, 0)
Output.Font = Enum.Font.Legacy
Output.Text = "Welcome to RYLQ's Admin!"
Output.TextColor3 = Color3.fromRGB(0, 0, 0)
Output.TextStrokeTransparency = 0
Output.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Output.TextScaled = true
Output.TextWrapped = true

-- Command list
local commands = {
    fly = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/1fg-dev/fe-fly-gui/main/source.lua"))()
    end,
    noclip = function()
        local plr = game.Players.LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()
        game:GetService("RunService").Stepped:Connect(function()
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.Humanoid:ChangeState(11)
            end
        end)
    end,
    speed = function()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
    end,
    jump = function()
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 120
    end,
    rejoin = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end,
    reset = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end,
    sit = function()
        game.Players.LocalPlayer.Character.Humanoid.Sit = true
    end,
    bring = function()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer then
                v.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end,
    kill = function()
        local char = game.Players.LocalPlayer.Character
        char:BreakJoints()
    end,
    tools = function()
        for _, v in pairs(game:GetService("Lighting"):GetChildren()) do
            if v:IsA("Tool") then
                v.Parent = game.Players.LocalPlayer.Backpack
            end
        end
    end
}

-- Command handler
CmdBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local input = CmdBox.Text:lower()
        if commands[input] then
            Output.Text = "Running command: " .. input
            commands[input]()
        else
            Output.Text = "Unknown command: " .. input
        end
        CmdBox.Text = ""
    end
end)
