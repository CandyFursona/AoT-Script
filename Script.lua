local AutoFarm = true
local AutoRetry = true

local obj = workspace:FindFirstChild("AUTO_FARM_DOUBLE_EXECUTE_CHECK")

if obj then
	error("ATTEMPT TO EXECUTE THIS SCRIPT 2+ TIMES")
end

print("проверка проходит дальше")

local block = Instance.new("Part", workspace)
block.Anchored = true
block.Name = "AUTO_FARM_DOUBLE_EXECUTE_CHECK"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function waitPath(root, names, timeoutPerStep)
	timeoutPerStep = timeoutPerStep or 10
	local current = root
	for _, name in ipairs(names) do
		local found = current:WaitForChild(name, timeoutPerStep)
		if not found then
			return nil
		end
		current = found
	end
	return current
end

local char, hrp
local function refreshChar()
	local chars = workspace:FindFirstChild("Characters")
	if not chars then return false end
	local list = chars:GetChildren()
	if #list == 0 then return false end
	local c = list[1]
	local h = c:FindFirstChild("HumanoidRootPart")
	if not h then return false end
	char = c
	hrp = h
	return true
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 200, 0, 130)
Frame.Position = UDim2.new(0, 300, 0, 200)

local UIText = Instance.new("TextLabel")
UIText.Parent = Frame
UIText.Text = "крутой автофарм 3000"
UIText.Size = UDim2.new(1, 0, 0.1, 0)
UIText.BackgroundColor3 = Color3.fromRGB(130, 130, 130)

local AutoFarmBtn = Instance.new("TextButton")
AutoFarmBtn.Parent = Frame
AutoFarmBtn.Text = "Auto Farm"
AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 150)
AutoFarmBtn.Size = UDim2.new(0, 150, 0, 30)
AutoFarmBtn.Position = UDim2.new(0, 10, 0, 30)

local AutoRetryBtn = Instance.new("TextButton")
AutoRetryBtn.Parent = Frame
AutoRetryBtn.Text = "Auto Retry"
AutoRetryBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 150)
AutoRetryBtn.Size = UDim2.new(0, 150, 0, 30)
AutoRetryBtn.Position = UDim2.new(0, 10, 0, 70)

local AuthorText = Instance.new("TextLabel")
AuthorText.Parent = Frame
AuthorText.Text = "github.com/CandyFursona/AoT-Script"
AuthorText.Size = UDim2.new(0.1, 0, 0.1, 0)
AuthorText.Position = UDim2.new(0.425, 0, 0.89, 0)
AuthorText.BorderSizePixel = 0

local UIDragDetector = Instance.new("UIDragDetector")
UIDragDetector.Parent = Frame

local heat, rewardsUI, RetryBtn, Gas, Blades

local function refreshUI()
	if not heat then
		heat = waitPath(playerGui, {"Interface","HUD","Main","Top","7","Blades","Inner","Bar","Gradient"}, 5)
	end
	if not rewardsUI then
		rewardsUI = waitPath(playerGui, {"Interface","Rewards"}, 5)
	end
	if rewardsUI and not RetryBtn then
		RetryBtn = waitPath(rewardsUI, {"Main","Info","Main","Buttons","Retry"}, 5)
	end
	if not Gas then
		Gas = waitPath(playerGui, {"Interface","HUD","Main","Top","7","Gas","Inner","Bar","Gradient"}, 5)
	end
	if not Blades then
		Blades = waitPath(playerGui, {"Interface","HUD","Main","Top","7","Blades","Sets"}, 5)
	end
end

local function getBladeCount()
	if not Blades or not Blades.Text then return 0 end
	local firstDigit = Blades.Text:match("%d")
	return tonumber(firstDigit) or 0
end

local Uroboros = false
local napeList = {}
local currentIndex = 1

local function modifyNape()
	local titans = workspace:FindFirstChild("Titans")
	if not titans then return end

	local newList = {}
	for _, obj in ipairs(titans:GetDescendants()) do
		if obj.Name == "Nape" and obj:IsA("BasePart") then
			table.insert(newList, obj)
		end
	end
	napeList = newList
	currentIndex = 1

	if #napeList == 0 then
		return
	end

	for _, nape in ipairs(napeList) do
		if nape and nape.Parent then
			local weld = nape:FindFirstChild("Nape")
			if weld then weld:Destroy() end
			nape.Anchored = true
			nape.Transparency = 1
			nape.Size = nape.Size * 1.5
			nape.Size = Vector3.new(nape.Size.X, nape.Size.Y * 2.5, nape.Size.Z)
		end
	end
end

local function setNextPosition()
	local targetPosition = Vector3.new(
		512.853759765625,
		172.50550842285156,
		731.1380615234375
	)
	for _, nape in ipairs(napeList) do
		if nape and nape.Parent then
			nape.Position = targetPosition
		end
	end
end

local function BackPlayer()
	if not hrp or not char then
		refreshChar()
		if not hrp then return end
	end
	hrp.Anchored = true
	char:PivotTo(CFrame.new(513.1425170898438, 173.5201873779297, 775.5360717773438))
end

UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.RightShift then
		Frame.Visible = not Frame.Visible
	end
end)

RunService.RenderStepped:Connect(function()
	if AutoFarm then
		if rewardsUI and not rewardsUI.Visible then
			Uroboros = true
		end
		AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(150, 255, 150)
	else
		Uroboros = false
		AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 150)
	end

	if AutoRetry then
		AutoRetryBtn.BackgroundColor3 = Color3.fromRGB(150, 255, 150)
	else
		AutoRetryBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 150)
	end
end)

AutoFarmBtn.MouseButton1Click:Connect(function()
	AutoFarm = not AutoFarm
end)

AutoRetryBtn.MouseButton1Click:Connect(function()
	AutoRetry = not AutoRetry
end)

local once = false
local try = false

while true do
	local ok, err = pcall(function()
		if not hrp or not hrp.Parent then
			refreshChar()
		end
		if not heat or not rewardsUI or not RetryBtn or not Gas or not Blades then
			refreshUI()
		end

		modifyNape()
		setNextPosition()

		if AutoRetry and rewardsUI and RetryBtn then
			if rewardsUI.Visible and not once then
				once = true
				Uroboros = false
				task.wait(0.1)
				RetryBtn.Parent = rewardsUI
				task.wait(0.1)
				RetryBtn.Size = UDim2.new(1, 0, 1, 0)
				task.wait(0.5)
				VIM:SendMouseButtonEvent(300, 200, 0, true, game, 1)
				VIM:SendMouseButtonEvent(200, 300, 0, false, game, 1)
			end
		elseif rewardsUI and not rewardsUI.Visible then
			once = false
		end

		if Uroboros and heat and hrp then
			if heat.Offset.X < 0 then
				BackPlayer()
				BackPlayer()
				VIM:SendKeyEvent(true, Enum.KeyCode.R, false, game, 1)
				VIM:SendKeyEvent(false, Enum.KeyCode.R, false, game, 1)
				task.wait(1.5)
			end

			if heat.Offset.X > 0 then
				BackPlayer()
				task.wait(1)
				hrp.Anchored = false

				VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game, 1)
				VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game, 1)

				VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game, 1)
				VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game, 1)

				VIM:SendMouseButtonEvent(300, 200, 0, true, game, 1)
				VIM:SendMouseButtonEvent(200, 300, 0, false, game, 1)
				task.wait(0.3)
			end
		end
	end)

	if not ok then
		warn("[AutoFarm] Ошибка в цикле: " .. tostring(err))
	end
	task.wait(0.05)
end
