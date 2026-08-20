--[=[ 
    Blox Fruit Hub - All Menus Fixed Version
    คัดลอกโค้ดทั้งหมดนี้ไปวางทับในสคริปต์ของคุณได้เลย
]=]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Define Colors
local PURPLE_MAIN = Color3.fromRGB(170, 0, 255)
local PURPLE_ACCENT = Color3.fromRGB(190, 80, 255)
local PURPLE_DARK_BG = Color3.fromRGB(45, 20, 60)

-- -------------------------------------------------------
-- 1. Main Window Setup
-- -------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmHub_LevelMax"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 520, 0, 310)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -155)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = false
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local mainGroup = Instance.new("CanvasGroup")
mainGroup.Name = "MainGroup"
mainGroup.Size = UDim2.new(1, 0, 1, 0)
mainGroup.BackgroundTransparency = 1
mainGroup.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = PURPLE_MAIN
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- Toggle Hub Open/Close Button
local openCloseButton = Instance.new("TextButton")
openCloseButton.Name = "OpenCloseButton"
openCloseButton.Size = UDim2.new(0, 45, 0, 45)
openCloseButton.Position = UDim2.new(0, 15, 0.5, -22)
openCloseButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
openCloseButton.TextColor3 = PURPLE_ACCENT
openCloseButton.Text = "HUB"
openCloseButton.Font = Enum.Font.GothamBold
openCloseButton.TextSize = 12
openCloseButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = openCloseButton

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = PURPLE_MAIN
toggleStroke.Thickness = 2
toggleStroke.Parent = openCloseButton

-- Top Header Bar
local topHeader = Instance.new("Frame")
topHeader.Name = "TopHeader"
topHeader.Size = UDim2.new(1, 0, 0, 32)
topHeader.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
topHeader.BorderSizePixel = 0
topHeader.Parent = mainGroup

local topHeaderCorner = Instance.new("UICorner")
topHeaderCorner.CornerRadius = UDim.new(0, 8)
topHeaderCorner.Parent = topHeader

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 320, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Blox Fruit Hub <font color=\"rgb(150,150,170)\">• Menu Fixed</font>"
titleLabel.RichText = true
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 12
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topHeader

local controlContainer = Instance.new("Frame")
controlContainer.Size = UDim2.new(0, 60, 1, 0)
controlContainer.Position = UDim2.new(1, -65, 0, 0)
controlContainer.BackgroundTransparency = 1
controlContainer.Parent = topHeader

local controlLayout = Instance.new("UIListLayout")
controlLayout.Parent = controlContainer
controlLayout.FillDirection = Enum.FillDirection.Horizontal
controlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
controlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
controlLayout.Padding = UDim.new(0, 6)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 22, 0, 22)
minBtn.BackgroundTransparency = 1
minBtn.Text = "↗↖"
minBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 12
minBtn.Parent = controlContainer

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.Parent = controlContainer

-- Drag Logic
local dragging, dragStart, startPos
topHeader.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Minimize & Restore
local isBusy = false
local originalPosition = mainFrame.Position
local originalSize = UDim2.new(0, 520, 0, 310)

local function animateMinimize()
	if isBusy or not mainFrame.Visible then return end
	isBusy = true
	originalPosition = mainFrame.Position

	local tweenStep1 = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, 520, 0, 32)})
	tweenStep1:Play()
	tweenStep1.Completed:Wait()

	local tweenStep2 = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Size = UDim2.new(0, 45, 0, 45), Position = openCloseButton.Position})
	local tweenFade = TweenService:Create(mainGroup, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 1})
	local strokeFade = TweenService:Create(mainStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1})

	tweenStep2:Play()
	tweenFade:Play()
	strokeFade:Play()
	tweenStep2.Completed:Wait()

	mainFrame.Visible = false
	mainFrame.Size = originalSize
	mainFrame.Position = originalPosition
	mainGroup.GroupTransparency = 0
	mainStroke.Transparency = 0
	isBusy = false
end

local function animateRestore()
	if isBusy or mainFrame.Visible then return end
	isBusy = true
	mainFrame.Size = UDim2.new(0, 45, 0, 45)
	mainFrame.Position = openCloseButton.Position
	mainGroup.GroupTransparency = 1
	mainStroke.Transparency = 1
	mainFrame.Visible = true

	local tweenRestore = TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = originalSize, Position = originalPosition})
	local tweenFadeIn = TweenService:Create(mainGroup, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0})
	local strokeFadeIn = TweenService:Create(mainStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})

	tweenRestore:Play()
	tweenFadeIn:Play()
	strokeFadeIn:Play()
	tweenRestore.Completed:Wait()
	isBusy = false
end

minBtn.MouseButton1Click:Connect(function() animateMinimize() end)
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)
openCloseButton.MouseButton1Click:Connect(function()
	if mainFrame.Visible then animateMinimize() else animateRestore() end
end)

-- Sidebar & Content
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 140, 1, -32)
sidebar.Position = UDim2.new(0, 0, 0, 32)
sidebar.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainGroup

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 8)
sidebarCorner.Parent = sidebar

local navList = Instance.new("UIListLayout")
navList.Parent = sidebar
navList.SortOrder = Enum.SortOrder.LayoutOrder
navList.Padding = UDim.new(0, 6)

local sidebarPadding = Instance.new("UIPadding")
sidebarPadding.PaddingTop = UDim.new(0, 12)
sidebarPadding.PaddingLeft = UDim.new(0, 8)
sidebarPadding.PaddingRight = UDim.new(0, 8)
sidebarPadding.Parent = sidebar

local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -145, 1, -37)
contentArea.Position = UDim2.new(0, 145, 0, 37)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainGroup

local headerLabel = Instance.new("TextLabel")
headerLabel.Size = UDim2.new(1, 0, 0, 25)
headerLabel.BackgroundTransparency = 1
headerLabel.Text = "Main"
headerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
headerLabel.Font = Enum.Font.GothamBold
headerLabel.TextSize = 15
headerLabel.TextXAlignment = Enum.TextXAlignment.Left
headerLabel.Parent = contentArea

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.95, 0, 0, 1)
divider.Position = UDim2.new(0, 0, 0, 28)
divider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
divider.BorderSizePixel = 0
divider.Parent = contentArea

-- -------------------------------------------------------
-- 2. Variables & State
-- -------------------------------------------------------
local isFarming = false
local bringMobEnabled = false
local killAuraEnabled = false
local showHitbox = false

local playerEspEnabled = false
local mobEspEnabled = false
local fruitEspEnabled = false
local chestEspEnabled = false

local farmHeightY = 15
local bringDistance = 150
local attackDelay = 0.1
local moveTweenSpeed = 250
local selectedWeaponType = "Melee" 

-- -------------------------------------------------------
-- 3. Level, Quest & NPC Position Database
-- -------------------------------------------------------
local QuestDatabase = {
	{minLevel = 1, maxLevel = 9, mobName = "Bandit", questName = "BanditQuest1", levelReq = 1, npcPos = CFrame.new(1059, 16, 1177)},
	{minLevel = 10, maxLevel = 14, mobName = "Monkey", questName = "JungleQuest", levelReq = 10, npcPos = CFrame.new(-1598, 36, 153)},
	{minLevel = 15, maxLevel = 29, mobName = "Gorilla", questName = "JungleQuest", levelReq = 15, npcPos = CFrame.new(-1598, 36, 153)},
	{minLevel = 30, maxLevel = 39, mobName = "Pirate", questName = "BuggyQuest", levelReq = 30, npcPos = CFrame.new(-1140, 4, 3828)},
	{minLevel = 40, maxLevel = 59, mobName = "Brute", questName = "BuggyQuest", levelReq = 40, npcPos = CFrame.new(-1140, 4, 3828)},
	{minLevel = 60, maxLevel = 74, mobName = "Desert Bandit", questName = "DesertQuest", levelReq = 60, npcPos = CFrame.new(896, 7, 4388)},
	{minLevel = 75, maxLevel = 89, mobName = "Desert Officer", questName = "DesertQuest", levelReq = 75, npcPos = CFrame.new(896, 7, 4388)},
	{minLevel = 90, maxLevel = 99, mobName = "Snow Bandit", questName = "SnowQuest", levelReq = 90, npcPos = CFrame.new(1386, 87, -1298)},
	{minLevel = 100, maxLevel = 119, mobName = "Snowman", questName = "SnowQuest", levelReq = 100, npcPos = CFrame.new(1386, 87, -1298)},
	{minLevel = 120, maxLevel = 149, mobName = "Chief Petty Officer", questName = "MarineQuest2", levelReq = 120, npcPos = CFrame.new(-5035, 29, 4324)},
	{minLevel = 150, maxLevel = 174, mobName = "Sky Bandit", questName = "SkyQuest", levelReq = 150, npcPos = CFrame.new(-4842, 718, -2623)},
	{minLevel = 175, maxLevel = 189, mobName = "Dark Master", questName = "SkyQuest", levelReq = 175, npcPos = CFrame.new(-4842, 718, -2623)},
	{minLevel = 190, maxLevel = 209, mobName = "Prisoner", questName = "PrisonQuest", levelReq = 190, npcPos = CFrame.new(4875, 5, 735)},
	{minLevel = 210, maxLevel = 249, mobName = "Dangerous Prisoner", questName = "PrisonQuest", levelReq = 210, npcPos = CFrame.new(4875, 5, 735)},
	{minLevel = 250, maxLevel = 274, mobName = "Toga Warrior", questName = "ColosseumQuest", levelReq = 250, npcPos = CFrame.new(-1580, 8, 2975)},
	{minLevel = 275, maxLevel = 299, mobName = "Gladiator", questName = "ColosseumQuest", levelReq = 275, npcPos = CFrame.new(-1580, 8, 2975)},
	{minLevel = 300, maxLevel = 324, mobName = "Military Soldier", questName = "MagmaQuest", levelReq = 300, npcPos = CFrame.new(-5315, 12, 8515)},
	{minLevel = 325, maxLevel = 374, mobName = "Military Spy", questName = "MagmaQuest", levelReq = 325, npcPos = CFrame.new(-5315, 12, 8515)},
	{minLevel = 375, maxLevel = 399, mobName = "Fishman Warrior", questName = "FishmanQuest", levelReq = 375, npcPos = CFrame.new(6112, 18, 1567)},
	{minLevel = 400, maxLevel = 449, mobName = "Fishman Commando", questName = "FishmanQuest", levelReq = 400, npcPos = CFrame.new(6112, 18, 1567)},
	{minLevel = 450, maxLevel = 474, mobName = "God's Guard", questName = "SkyExp1Quest", levelReq = 450, npcPos = CFrame.new(-4721, 845, -1955)},
	{minLevel = 475, maxLevel = 524, mobName = "Shanda", questName = "SkyExp1Quest", levelReq = 475, npcPos = CFrame.new(-7862, 5545, -381)},
	{minLevel = 525, maxLevel = 549, mobName = "Royal Squad", questName = "SkyExp2Quest", levelReq = 525, npcPos = CFrame.new(-7903, 5635, -1411)},
	{minLevel = 550, maxLevel = 624, mobName = "Royal Soldier", questName = "SkyExp2Quest", levelReq = 550, npcPos = CFrame.new(-7903, 5635, -1411)},
	{minLevel = 625, maxLevel = 649, mobName = "Galley Pirate", questName = "FountainQuest", levelReq = 625, npcPos = CFrame.new(5258, 38, 4051)},
	{minLevel = 650, maxLevel = 2800, mobName = "Galley Captain", questName = "FountainQuest", levelReq = 650, npcPos = CFrame.new(5258, 38, 4051)}
}

local function getCurrentQuestData()
	local stats = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level")
	local currentLevel = stats and stats.Value or 1

	for _, data in ipairs(QuestDatabase) do
		if currentLevel >= data.minLevel and currentLevel <= data.maxLevel then
			return data
		end
	end
	return QuestDatabase[#QuestDatabase]
end

local function hasActiveQuest()
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	local questGui = playerGui and playerGui:FindFirstChild("Main") and playerGui.Main:FindFirstChild("Quest")
	return questGui and questGui.Visible == true
end

-- -------------------------------------------------------
-- 4. Tab System Setup
-- -------------------------------------------------------
local tabs = {}
local tabButtons = {}

local function createTab(tabName)
	local tabContainer = Instance.new("ScrollingFrame")
	tabContainer.Name = tabName .. "Tab"
	tabContainer.Size = UDim2.new(1, -10, 1, -35)
	tabContainer.Position = UDim2.new(0, 0, 0, 35)
	tabContainer.BackgroundTransparency = 1
	tabContainer.ScrollBarThickness = 4
	tabContainer.ScrollBarImageColor3 = PURPLE_MAIN
	tabContainer.Visible = false
	tabContainer.Parent = contentArea

	local list = Instance.new("UIListLayout")
	list.Parent = tabContainer
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0, 8)

	local navBtn = Instance.new("TextButton")
	navBtn.Size = UDim2.new(1, 0, 0, 32)
	navBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
	navBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
	navBtn.Text = tabName
	navBtn.Font = Enum.Font.GothamMedium
	navBtn.TextSize = 12
	navBtn.Parent = sidebar

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = navBtn

	local btnStroke = Instance.new("UIStroke")
	btnStroke.Color = Color3.fromRGB(45, 45, 60)
	btnStroke.Thickness = 1
	btnStroke.Parent = navBtn

	tabs[tabName] = tabContainer
	tabButtons[tabName] = {btn = navBtn, stroke = btnStroke}

	navBtn.MouseButton1Click:Connect(function()
		for name, container in pairs(tabs) do
			container.Visible = (name == tabName)
			if name == tabName then
				tabButtons[name].btn.BackgroundColor3 = PURPLE_DARK_BG
				tabButtons[name].btn.TextColor3 = Color3.fromRGB(255, 255, 255)
				tabButtons[name].stroke.Color = PURPLE_MAIN
			else
				tabButtons[name].btn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
				tabButtons[name].btn.TextColor3 = Color3.fromRGB(180, 180, 200)
				tabButtons[name].stroke.Color = Color3.fromRGB(45, 45, 60)
			end
		end
		headerLabel.Text = tabName
	end)

	return tabContainer
end

local function createToggle(parentTab, text, defaultState, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(0.95, 0, 0, 28)
	row.BackgroundTransparency = 1
	row.Parent = parentTab

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.8, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(220, 220, 230)
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row

	local box = Instance.new("TextButton")
	box.Size = UDim2.new(0, 20, 0, 20)
	box.Position = UDim2.new(0.95, -20, 0.5, -10)
	box.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	box.Text = defaultState and "✓" or ""
	box.TextColor3 = PURPLE_ACCENT
	box.Font = Enum.Font.GothamBold
	box.TextSize = 12
	box.Parent = row

	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 4)
	boxCorner.Parent = box

	local boxStroke = Instance.new("UIStroke")
	boxStroke.Color = defaultState and PURPLE_MAIN or Color3.fromRGB(70, 70, 90)
	boxStroke.Thickness = 1
	boxStroke.Parent = box

	local state = defaultState
	box.MouseButton1Click:Connect(function()
		state = not state
		box.Text = state and "✓" or ""
		box.BackgroundColor3 = state and PURPLE_DARK_BG or Color3.fromRGB(30, 30, 40)
		boxStroke.Color = state and PURPLE_MAIN or Color3.fromRGB(70, 70, 90)
		callback(state)
	end)
end

local function createWeaponDropdown(parentTab)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0.95, 0, 0, 50)
	container.BackgroundTransparency = 1
	container.Parent = parentTab

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 20)
	label.BackgroundTransparency = 1
	label.Text = "Select Farm Weapon Type"
	label.TextColor3 = Color3.fromRGB(200, 200, 220)
	label.Font = Enum.Font.Gotham
	label.TextSize = 11
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local btnLayout = Instance.new("UIListLayout")
	btnLayout.Parent = container
	btnLayout.FillDirection = Enum.FillDirection.Horizontal
	btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.SpaceBetween
	btnLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	btnLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local weapons = {"Melee", "Fruit", "Sword"}
	local buttons = {}

	for _, wName in ipairs(weapons) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.31, 0, 0, 26)
		btn.BackgroundColor3 = (selectedWeaponType == wName) and PURPLE_DARK_BG or Color3.fromRGB(24, 24, 32)
		btn.TextColor3 = (selectedWeaponType == wName) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 180)
		btn.Text = wName
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 11
		btn.Parent = container

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 5)
		btnCorner.Parent = btn

		local btnStroke = Instance.new("UIStroke")
		btnStroke.Color = (selectedWeaponType == wName) and PURPLE_MAIN or Color3.fromRGB(50, 50, 70)
		btnStroke.Thickness = 1
		btnStroke.Parent = btn

		buttons[wName] = {btn = btn, stroke = btnStroke}

		btn.MouseButton1Click:Connect(function()
			selectedWeaponType = wName
			for name, data in pairs(buttons) do
				if name == wName then
					data.btn.BackgroundColor3 = PURPLE_DARK_BG
					data.btn.TextColor3 = Color3.fromRGB(255, 255, 255)
					data.stroke.Color = PURPLE_MAIN
				else
					data.btn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
					data.btn.TextColor3 = Color3.fromRGB(160, 160, 180)
					data.stroke.Color = Color3.fromRGB(50, 50, 70)
				end
			end
		end)
	end
end

local function createSlider(parentTab, titleText, minVal, maxVal, defaultVal, unitStr, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0.95, 0, 0, 40)
	container.BackgroundTransparency = 1
	container.Parent = parentTab

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 18)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 11
	label.TextColor3 = Color3.fromRGB(200, 200, 220)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local track = Instance.new("TextButton")
	track.Text = ""
	track.AutoButtonColor = false
	track.Size = UDim2.new(1, 0, 0, 6)
	track.Position = UDim2.new(0, 0, 0, 24)
	track.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
	track.BorderSizePixel = 0
	track.Parent = container

	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = track

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
	fill.BackgroundColor3 = PURPLE_MAIN
	fill.BorderSizePixel = 0
	fill.Parent = track

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = fill

	local function updateSlider(input)
		local posX = math.clamp(input.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
		local alpha = posX / track.AbsoluteSize.X
		fill.Size = UDim2.new(alpha, 0, 1, 0)

		local value = minVal + (maxVal - minVal) * alpha
		label.Text = string.format("%s: %.1f %s", titleText, value, unitStr)
		callback(value)
	end

	label.Text = string.format("%s: %.1f %s", titleText, defaultVal, unitStr)

	local sliderDragging = false
	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			sliderDragging = true
			updateSlider(input)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			sliderDragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider(input)
		end
	end)
end

local function tweenTeleport(targetCFrame)
	local character = LocalPlayer.Character
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local distance = (hrp.Position - targetCFrame.Position).Magnitude
	local speed = moveTweenSpeed
	local travelTime = math.clamp(distance / speed, 0.2, 15)

	local tweenInfo = TweenInfo.new(travelTime, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame + Vector3.new(0, 5, 0)})
	tween:Play()
	tween.Completed:Wait()
	hrp.CFrame = targetCFrame
end

local function createTeleportButton(parentTab, islandName, targetCFrame)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.95, 0, 0, 32)
	btn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
	btn.TextColor3 = Color3.fromRGB(230, 230, 240)
	btn.Text = "✈️ " .. islandName
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 12
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = parentTab

	local pad = Instance.new("UIPadding")
	pad.PaddingLeft = UDim.new(0, 10)
	pad.Parent = btn

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = btn

	local btnStroke = Instance.new("UIStroke")
	btnStroke.Color = Color3.fromRGB(50, 50, 70)
	btnStroke.Thickness = 1
	btnStroke.Parent = btn

	btn.MouseButton1Click:Connect(function()
		tweenTeleport(targetCFrame)
	end)
end

local function createSectionHeader(parentTab, text)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.95, 0, 0, 24)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = PURPLE_ACCENT
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 12
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = parentTab
end

-- -------------------------------------------------------
-- 5. Build Tabs Content (Fully Restored)
-- -------------------------------------------------------
local mainTab = createTab("Main")
local espTab = createTab("ESP Visual")
local tpTab = createTab("Teleport")
local superhumanTab = createTab("Superhuman")
local settingsTab = createTab("Settings")

-- Main Tab Toggles
createToggle(mainTab, "Auto Farm (1-2800)", false, function(state)
	isFarming = state
	if isFarming then startFarmingLoop() end
end)
createWeaponDropdown(mainTab)
createToggle(mainTab, "Bring Mobs", false, function(state) bringMobEnabled = state end)
createToggle(mainTab, "Kill Aura (Hit all nearby mobs)", false, function(state) killAuraEnabled = state end)
createToggle(mainTab, "Hitbox Red Visual", false, function(state) showHitbox = state end)

-- ESP Tab Toggles
createToggle(espTab, "Player ESP", false, function(state) playerEspEnabled = state end)
createToggle(espTab, "Monster ESP", false, function(state) mobEspEnabled = state end)
createToggle(espTab, "Fruit ESP", false, function(state) fruitEspEnabled = state end)
createToggle(espTab, "Chest ESP (Silver/Gold/Diamond)", false, function(state) chestEspEnabled = state end)

-- Teleport Buttons
createSectionHeader(tpTab, "--- SEA 1 ---")
createTeleportButton(tpTab, "Windmill / Starter (Marine)", CFrame.new(979, 16, 1429))
createTeleportButton(tpTab, "Pirate Starter", CFrame.new(1062, 16, 1175))
createTeleportButton(tpTab, "Jungle", CFrame.new(-1249, 12, 331))
createTeleportButton(tpTab, "Pirate Village", CFrame.new(-1141, 4, 3827))
createTeleportButton(tpTab, "Desert", CFrame.new(895, 7, 4388))
createTeleportButton(tpTab, "Snow Island", CFrame.new(1210, 14, -5110))

createSectionHeader(tpTab, "--- SEA 2 ---")
createTeleportButton(tpTab, "Kingdom of Rose", CFrame.new(-401, 73, 1805))
createTeleportButton(tpTab, "Green Zone", CFrame.new(-2449, 73, -3212))
createTeleportButton(tpTab, "Ice Castle", CFrame.new(5513, 60, -6135))

createSectionHeader(tpTab, "--- SEA 3 ---")
createTeleportButton(tpTab, "Port Town", CFrame.new(-290, 7, 5339))
createTeleportButton(tpTab, "Castle on the Sea", CFrame.new(-5043, 315, -3165))

-- Settings Sliders
createSlider(settingsTab, "Farm Height", 5, 50, farmHeightY, "Studs", function(val) farmHeightY = val end)
createSlider(settingsTab, "Bring Radius", 10, 300, bringDistance, "Studs", function(val) bringDistance = val end)
createSlider(settingsTab, "Attack Delay", 0.01, 0.5, attackDelay, "Sec", function(val) attackDelay = val end)
createSlider(settingsTab, "Move Speed (Tween)", 30, 300, moveTweenSpeed, "Studs/s", function(val) moveTweenSpeed = val end)

tabButtons["Main"].btn.BackgroundColor3 = PURPLE_DARK_BG
tabButtons["Main"].btn.TextColor3 = Color3.fromRGB(255, 255, 255)
tabButtons["Main"].stroke.Color = PURPLE_MAIN
mainTab.Visible = true

-- -------------------------------------------------------
-- 6. Master ESP Logic
-- -------------------------------------------------------
local espFolder = Instance.new("Folder")
espFolder.Name = "MasterESPFolder"
espFolder.Parent = Workspace

local function updateOrCreateESP(id, adorneePart, text, color)
	local espName = "ESP_" .. id
	local existingEsp = espFolder:FindFirstChild(espName)

	if not existingEsp then
		local bgui = Instance.new("BillboardGui")
		bgui.Name = espName
		bgui.AlwaysOnTop = true
		bgui.Size = UDim2.new(0, 200, 0, 50)
		bgui.Adornee = adorneePart
		bgui.Parent = espFolder

		local txtLabel = Instance.new("TextLabel")
		txtLabel.Name = "ESPLabel"
		txtLabel.Size = UDim2.new(1, 0, 1, 0)
		txtLabel.BackgroundTransparency = 1
		txtLabel.TextStrokeTransparency = 0
		txtLabel.Font = Enum.Font.GothamBold
		txtLabel.TextSize = 12
		txtLabel.Parent = bgui
		existingEsp = bgui
	end

	existingEsp.Adornee = adorneePart
	local label = existingEsp:FindFirstChild("ESPLabel")
	if label then
		label.Text = text
		label.TextColor3 = color
	end
end

task.spawn(function()
	while true do
		local character = LocalPlayer.Character
		local hrp = character and character:FindFirstChild("HumanoidRootPart")

		for _, child in ipairs(espFolder:GetChildren()) do
			child:SetAttribute("Keep", false)
		end

		if hrp then
			if mobEspEnabled then
				local currentQuest = getCurrentQuestData()
				for _, obj in ipairs(Workspace:GetChildren()) do
					if obj.Name == currentQuest.mobName and obj:FindFirstChild("HumanoidRootPart") then
						local hum = obj:FindFirstChildOfClass("Humanoid")
						if hum and hum.Health > 0 then
							local mHrp = obj.HumanoidRootPart
							local dist = math.floor((mHrp.Position - hrp.Position).Magnitude)
							local id = "M_" .. obj:GetDebugId()
							updateOrCreateESP(id, mHrp, string.format("👹 %s HP:%d\n[%d Studs]", obj.Name, hum.Health, dist), Color3.fromRGB(255, 82, 82))
							if espFolder:FindFirstChild("ESP_" .. id) then espFolder["ESP_" .. id]:SetAttribute("Keep", true) end
						end
					end
				end
			end
		end

		for _, child in ipairs(espFolder:GetChildren()) do
			if not child:GetAttribute("Keep") then child:Destroy() end
		end

		task.wait(0.4)
	end
end)

-- -------------------------------------------------------
-- 7. Auto Farm & Quest Logic
-- -------------------------------------------------------
local function getDesiredWeapon()
	local character = LocalPlayer.Character
	local backpack = LocalPlayer:FindFirstChild("Backpack")
	if not character or not backpack then return nil end

	for _, item in ipairs(backpack:GetChildren()) do
		if item:IsA("Tool") then
			local toolType = item:GetAttribute("ToolTip") or item.ToolTip or ""
			local nameLower = item.Name:lower()

			if selectedWeaponType == "Melee" then
				if toolType == "Melee" or nameLower:find("fighting") or nameLower:find("step") or nameLower:find("karate") or nameLower:find("claw") or nameLower:find("talon") or nameLower:find("godhuman") or nameLower:find("superhuman") then
					return item
				end
			elseif selectedWeaponType == "Sword" then
				if toolType == "Sword" or nameLower:find("blade") or nameLower:find("katana") or nameLower:find("sword") or nameLower:find("dark") or nameLower:find("rengoku") or nameLower:find("tushita") then
					return item
				end
			elseif selectedWeaponType == "Fruit" then
				if toolType == "Blox Fruit" or nameLower:find("fruit") or nameLower:find("dough") or nameLower:find("leopard") or nameLower:find("kitsune") or nameLower:find("portal") then
					return item
				end
			end
		end
	end
	return backpack:FindFirstChildOfClass("Tool")
end

function startFarmingLoop()
	task.spawn(function()
		local activeTween = nil

		while isFarming do
			local character = LocalPlayer.Character
			local hrp = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if hrp and humanoid and humanoid.Health > 0 then
				local tool = character:FindFirstChildOfClass("Tool")
				if not tool then
					local desiredTool = getDesiredWeapon()
					if desiredTool then 
						humanoid:EquipTool(desiredTool) 
						tool = desiredTool
					end
				end

				local currentQuest = getCurrentQuestData()

				if not hasActiveQuest() then
					if activeTween then activeTween:Cancel() activeTween = nil end
					tweenTeleport(currentQuest.npcPos)
					
					pcall(function()
						ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", currentQuest.questName, 1)
					end)
					task.wait(1)
				else
					local aliveMonsters = {}
					for _, v in ipairs(Workspace:GetChildren()) do
						if v.Name == currentQuest.mobName then
							local eHum = v:FindFirstChildOfClass("Humanoid")
							local eHrp = v:FindFirstChild("HumanoidRootPart")
							if eHum and eHrp and eHum.Health > 0 then
								table.insert(aliveMonsters, v)
							end
						end
					end

					if #aliveMonsters > 0 then
						local primaryTarget = aliveMonsters[1]
						local primaryHrp = primaryTarget:FindFirstChild("HumanoidRootPart")

						if primaryHrp then
							if bringMobEnabled or killAuraEnabled then
								for _, mob in ipairs(aliveMonsters) do
									local mHrp = mob:FindFirstChild("HumanoidRootPart")
									if mHrp then
										mHrp.CFrame = hrp.CFrame * CFrame.new(0, -2, -4)
										mHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
										pcall(function()
											if tool and tool:FindFirstChild("Handle") then
												firetouchinterest(mHrp, tool.Handle, 0)
												firetouchinterest(mHrp, tool.Handle, 1)
											end
										end)
									end
								end
							end

							local targetPos = Vector3.new(primaryHrp.Position.X, primaryHrp.Position.Y + farmHeightY, primaryHrp.Position.Z)
							local distanceToTarget = (hrp.Position - targetPos).Magnitude

							if not activeTween or activeTween.PlaybackState ~= Enum.PlaybackState.Playing then
								local travelTime = math.clamp(distanceToTarget / moveTweenSpeed, 0.05, 2.5)
								local tweenInfo = TweenInfo.new(travelTime, Enum.EasingStyle.Linear)
								activeTween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
								activeTween:Play()
							end

							if tool then 
								tool:Activate() 
							end
						end
					else
						if activeTween then
							activeTween:Cancel()
							activeTween = nil
						end
					end
				end
			end

			task.wait(attackDelay)
		end

		if activeTween then
			activeTween:Cancel()
		end
	end)
end
