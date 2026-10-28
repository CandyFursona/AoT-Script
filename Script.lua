local obj = workspace:FindFirstChild("AUTO_FARM_DOUBLE_EXECUTE_CHECK")

if obj then
	error("ATTEMPT TO EXECUTE THIS SCRIPT 2+ TIMES")
end

print("проверка проходит дальше")

local block = Instance.new("Part", workspace)
block.Anchored = true
block.Name = "AUTO_FARM_DOUBLE_EXECUTE_CHECK"

local CoreGui = game:GetService("CoreGui")
local ScreenGui = Instance.new("ScreenGui", CoreGui)


local char = workspace.Characters:GetChildren()[1]
local hrp = char.HumanoidRootPart
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")

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

local heat = playerGui
    :WaitForChild("Interface")
    :WaitForChild("HUD")
    :WaitForChild("Main")
    :WaitForChild("Top")
    :WaitForChild("7")
    :WaitForChild("Blades")
    :WaitForChild("Inner")
    :WaitForChild("Bar")
    :WaitForChild("Gradient")

local rewardsUI = playerGui
    :WaitForChild("Interface")
	:WaitForChild("Rewards")

local RetryBtn = rewardsUI
	:WaitForChild("Main")
	:WaitForChild("Info")
	:WaitForChild("Main")
	:WaitForChild("Buttons")
	:WaitForChild("Retry")

local Gas = playerGui
    :WaitForChild("Interface")
    :WaitForChild("HUD")
    :WaitForChild("Main")
    :WaitForChild("Top")
    :WaitForChild("7")
    :WaitForChild("Gas")
    :WaitForChild("Inner")
    :WaitForChild("Bar")
    :WaitForChild("Gradient")

local Blades = playerGui
    :WaitForChild("Interface")
    :WaitForChild("HUD")
    :WaitForChild("Main")
    :WaitForChild("Top")
    :WaitForChild("7")
    :WaitForChild("Blades")
    :WaitForChild("Sets")

local VIM = game:GetService("VirtualInputManager")
local clickX, clickY = 100, 100

local Uroboros = false

local napeList = {}
local currentIndex = 1


local function getbladecount() 
	local text = Blades.Text
	local firstDigit = text:match("%d") 
	local number = tonumber(firstDigit)

	return number
end

local function modifyNape()
    local titans = workspace:FindFirstChild("Titans")
    if not titans then
        return
    end

    napeList = {}

    for _, obj in ipairs(titans:GetDescendants()) do
        if obj.Name == "Nape" and obj:IsA("BasePart") then
            table.insert(napeList, obj)
        end
    end

    currentIndex = 1

    if #napeList == 0 then
        warn("[modifyNape] Nape не найдены")
        return
    end

    for _, nape in ipairs(napeList) do
        local weld = nape:FindFirstChild("Nape")

        if weld then
            weld:Destroy()
        end

        nape.Anchored = true
        nape.Transparency = 1
        nape.Size = nape.Size * 1.5
		nape.Size = Vector3.new(
			nape.Size.X,
			nape.Size.Y * 2.5,
			nape.Size.Z
		)

    end

    print("[modifyNape] Обработано Nape:", #napeList)
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

    print("[setNextPosition] Все Nape перемещены!")
end


local function BackPlayer() 
	hrp.Anchored = true
	char:SetPrimaryPartCFrame(CFrame.new(513.1425170898438, 173.5201873779297, 775.5360717773438))
end

UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.RightShift then
		Frame.Visible = not Frame.Visible
	end
end)

RunService.RenderStepped:Connect(function()
	if AutoFarm then
		if not rewardsUI.Visible then
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
	modifyNape()
	setNextPosition()

	if AutoRetry then
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
	end

	if Uroboros then
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
	task.wait(0.05)
end
