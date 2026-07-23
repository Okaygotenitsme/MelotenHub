if not _G.__HUB_INSTANCES then
	_G.__HUB_INSTANCES = {}
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local DarkBg = Color3.fromRGB(15, 15, 18)
local PanelBg = Color3.fromRGB(20, 20, 24)
local ElementBg = Color3.fromRGB(15, 15, 18)
local ElementBgHover = Color3.fromRGB(26, 26, 30)
local PurpleAccent = Color3.fromRGB(150, 80, 255)
local PurpleAccentDark = Color3.fromRGB(100, 50, 180)
local TextColor = Color3.fromRGB(230, 230, 235)
local TextColorDim = Color3.fromRGB(140, 140, 150)
local BorderColor = Color3.fromRGB(35, 35, 40)

local MonoFont = Enum.Font.Code
local MonoFontBold = Enum.Font.Code

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MelotenHub"
ScreenGui.ResetOnSpawn = false

if gethui then
	ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
	syn.protect_gui(ScreenGui)
	ScreenGui.Parent = CoreGui
elseif CoreGui:FindFirstChild("RobloxGui") then
	ScreenGui.Parent = CoreGui:FindFirstChild("RobloxGui")
else
	ScreenGui.Parent = CoreGui
end

local NotificationContainer = Instance.new("Frame")
NotificationContainer.Size = UDim2.new(0, 300, 1, 0)
NotificationContainer.Position = UDim2.new(1, -320, 0, -10)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = ScreenGui

local NotifyList = Instance.new("UIListLayout")
NotifyList.Padding = UDim.new(0, 10)
NotifyList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyList.SortOrder = Enum.SortOrder.LayoutOrder
NotifyList.Parent = NotificationContainer

local MainFrame = Instance.new("Frame")
local OpenButton = Instance.new("ImageButton")

local Hub = {}
Hub.__index = Hub

local function loadImageFromUrl(url)
	if not url then return "rbxassetid://0" end
	if type(url) == "number" then return "rbxassetid://" .. url end
	if url:match("^rbxassetid://") then return url end
	if url:match("^http") then
		if not (writefile and makefolder and getcustomasset and isfolder) then
			return "rbxassetid://0"
		end
		if not isfolder("MelotenCache") then
			makefolder("MelotenCache")
		end
		local key = tostring(#url) .. "_" .. url:gsub("[^%w]", ""):sub(-32)
		local fileName = "MelotenCache/" .. key .. ".png"
		if isfile(fileName) then
			return getcustomasset(fileName)
		end
		local ok, data = pcall(function()
			return game:HttpGet(url)
		end)
		if ok and data and #data > 0 then
			writefile(fileName, data)
			return getcustomasset(fileName)
		end
	end
	return "rbxassetid://0"
end

function Hub:Notify(title, text, duration)
	duration = duration or 3

	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, 0, 0, 0)
	Frame.BackgroundColor3 = PanelBg
	Frame.BorderSizePixel = 0
	Frame.ClipsDescendants = true
	Frame.Parent = NotificationContainer

	local UIStroke = Instance.new("UIStroke", Frame)
	UIStroke.Color = BorderColor
	UIStroke.Thickness = 1

	local Accent = Instance.new("Frame")
	Accent.Size = UDim2.new(0, 2, 1, 0)
	Accent.BackgroundColor3 = PurpleAccent
	Accent.BorderSizePixel = 0
	Accent.Parent = Frame

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Text = title
	TitleLabel.Size = UDim2.new(1, -20, 0, 20)
	TitleLabel.Position = UDim2.new(0, 14, 0, 6)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.TextColor3 = PurpleAccent
	TitleLabel.Font = MonoFontBold
	TitleLabel.TextSize = 14
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = Frame

	local DescLabel = Instance.new("TextLabel")
	DescLabel.Text = text
	DescLabel.Size = UDim2.new(1, -20, 0, 30)
	DescLabel.Position = UDim2.new(0, 14, 0, 26)
	DescLabel.BackgroundTransparency = 1
	DescLabel.TextColor3 = TextColorDim
	DescLabel.Font = MonoFont
	DescLabel.TextSize = 13
	DescLabel.TextXAlignment = Enum.TextXAlignment.Left
	DescLabel.TextWrapped = true
	DescLabel.Parent = Frame

	TweenService:Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 60)}):Play()

	task.spawn(function()
		task.wait(duration)
		local tween = TweenService:Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
		tween:Play()
		TweenService:Create(TitleLabel, TweenInfo.new(0.35), {TextTransparency = 1}):Play()
		TweenService:Create(DescLabel, TweenInfo.new(0.35), {TextTransparency = 1}):Play()
		TweenService:Create(UIStroke, TweenInfo.new(0.35), {Transparency = 1}):Play()
		TweenService:Create(Accent, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
		tween.Completed:Wait()
		Frame:Destroy()
	end)
end

local function makeDraggable(handle, target)
	target = target or handle
	local dragging, dragStart, startPos

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = target.Position
		end
	end)

	handle.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			target.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

function Hub:CreateWindow(config)
	local hubID = config.ID or "default"
	if _G.__HUB_INSTANCES[hubID] then
		pcall(function() _G.__HUB_INSTANCES[hubID]:Destroy() end)
	end

	local self = setmetatable({}, Hub)
	self._currentTab = nil
	self._currentPage = nil

	local W = config.Size and config.Size.X or 560
	local H = config.Size and config.Size.Y or 400

	local ShadowImage = Instance.new("ImageLabel")
	ShadowImage.Name = "Shadow"
	ShadowImage.BackgroundTransparency = 1
	ShadowImage.Image = "rbxassetid://6014261993"
	ShadowImage.ImageColor3 = Color3.new(0, 0, 0)
	ShadowImage.ImageTransparency = 0.45
	ShadowImage.ScaleType = Enum.ScaleType.Slice
	ShadowImage.SliceCenter = Rect.new(49, 49, 450, 450)
	ShadowImage.Size = UDim2.new(1, 60, 1, 60)
	ShadowImage.Position = UDim2.new(0.5, 0, 0.5, 6)
	ShadowImage.AnchorPoint = Vector2.new(0.5, 0.5)
	ShadowImage.ZIndex = 0
	ShadowImage.Parent = ScreenGui

	_G.__HUB_INSTANCES[hubID] = MainFrame

	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, W, 0, H)
	MainFrame.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
	MainFrame.BackgroundColor3 = DarkBg
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Visible = true
	MainFrame.Parent = ScreenGui

	local MainCorner = Instance.new("UICorner", MainFrame)
	MainCorner.CornerRadius = UDim.new(0, 6)

	local UIStroke = Instance.new("UIStroke", MainFrame)
	UIStroke.Color = BorderColor
	UIStroke.Thickness = 1

	local LoadingOverlay = Instance.new("Frame")
	LoadingOverlay.Name = "LoadingOverlay"
	LoadingOverlay.Size = UDim2.new(1, 0, 1, 0)
	LoadingOverlay.BackgroundColor3 = DarkBg
	LoadingOverlay.BorderSizePixel = 0
	LoadingOverlay.ZIndex = 50
	LoadingOverlay.Parent = MainFrame

	local LoadingCorner = Instance.new("UICorner", LoadingOverlay)
	LoadingCorner.CornerRadius = UDim.new(0, 6)

	local LoadingLabel = Instance.new("TextLabel")
	LoadingLabel.Text = "Loading UI..."
	LoadingLabel.Size = UDim2.new(1, 0, 0, 20)
	LoadingLabel.Position = UDim2.new(0, 0, 0.5, -20)
	LoadingLabel.BackgroundTransparency = 1
	LoadingLabel.TextColor3 = TextColor
	LoadingLabel.Font = MonoFontBold
	LoadingLabel.TextSize = 15
	LoadingLabel.ZIndex = 51
	LoadingLabel.Parent = LoadingOverlay

	local LoadingBarBg = Instance.new("Frame")
	LoadingBarBg.Size = UDim2.new(0, 160, 0, 3)
	LoadingBarBg.Position = UDim2.new(0.5, -80, 0.5, 6)
	LoadingBarBg.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	LoadingBarBg.BorderSizePixel = 0
	LoadingBarBg.ZIndex = 51
	LoadingBarBg.Parent = LoadingOverlay

	local LoadingBarFill = Instance.new("Frame")
	LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
	LoadingBarFill.BackgroundColor3 = PurpleAccent
	LoadingBarFill.BorderSizePixel = 0
	LoadingBarFill.ZIndex = 52
	LoadingBarFill.Parent = LoadingBarBg

	TweenService:Create(LoadingBarFill, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 1, 0)}):Play()

	task.spawn(function()
		task.wait(0.7)
		local fadeTween = TweenService:Create(LoadingOverlay, TweenInfo.new(0.25), {BackgroundTransparency = 1})
		TweenService:Create(LoadingLabel, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
		TweenService:Create(LoadingBarBg, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
		TweenService:Create(LoadingBarFill, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
		fadeTween:Play()
		fadeTween.Completed:Wait()
		LoadingOverlay:Destroy()
	end)

	ShadowImage.AnchorPoint = Vector2.new(0, 0)
	ShadowImage.Position = UDim2.new(0, -30, 0, -30)
	ShadowImage.Size = UDim2.new(0, W + 60, 0, H + 60)
	local function syncShadow()
		ShadowImage.Position = UDim2.new(0, MainFrame.AbsolutePosition.X - 30, 0, MainFrame.AbsolutePosition.Y - 30)
		ShadowImage.Size = UDim2.new(0, MainFrame.AbsoluteSize.X + 60, 0, MainFrame.AbsoluteSize.Y + 60)
	end
	MainFrame:GetPropertyChangedSignal("Position"):Connect(syncShadow)
	MainFrame:GetPropertyChangedSignal("Size"):Connect(syncShadow)
	MainFrame:GetPropertyChangedSignal("Visible"):Connect(function()
		ShadowImage.Visible = MainFrame.Visible
	end)
	task.defer(syncShadow)

	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 36)
	TopBar.BackgroundColor3 = PanelBg
	TopBar.BorderSizePixel = 0
	TopBar.Parent = MainFrame

	local TopBarCorner = Instance.new("UICorner", TopBar)
	TopBarCorner.CornerRadius = UDim.new(0, 6)

	local TopBarFix = Instance.new("Frame")
	TopBarFix.Size = UDim2.new(1, 0, 0, 8)
	TopBarFix.Position = UDim2.new(0, 0, 1, -8)
	TopBarFix.BackgroundColor3 = PanelBg
	TopBarFix.BorderSizePixel = 0
	TopBarFix.Parent = TopBar

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Text = config.Title or "Meloten Hub"
	TitleLabel.Size = UDim2.new(1, -110, 1, 0)
	TitleLabel.Position = UDim2.new(0, 14, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.TextColor3 = TextColor
	TitleLabel.Font = MonoFontBold
	TitleLabel.TextSize = 15
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = TopBar

	if config.Icon then
		local LogoImg = Instance.new("ImageLabel")
		LogoImg.Size = UDim2.new(0, 18, 0, 18)
		LogoImg.Position = UDim2.new(0, 14, 0.5, -9)
		LogoImg.BackgroundTransparency = 1
		LogoImg.Image = loadImageFromUrl(config.Icon)
		LogoImg.Parent = TopBar
		TitleLabel.Position = UDim2.new(0, 40, 0, 0)
	end

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Text = "×"
	CloseBtn.Size = UDim2.new(0, 28, 0, 28)
	CloseBtn.Position = UDim2.new(1, -32, 0.5, -14)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.TextColor3 = TextColorDim
	CloseBtn.Font = MonoFontBold
	CloseBtn.TextSize = 18
	CloseBtn.Parent = TopBar

	local MinimizeBtn = Instance.new("TextButton")
	MinimizeBtn.Text = "−"
	MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
	MinimizeBtn.Position = UDim2.new(1, -62, 0.5, -14)
	MinimizeBtn.BackgroundTransparency = 1
	MinimizeBtn.TextColor3 = TextColorDim
	MinimizeBtn.Font = MonoFontBold
	MinimizeBtn.TextSize = 18
	MinimizeBtn.Parent = TopBar

	CloseBtn.MouseEnter:Connect(function()
		TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(220, 80, 80)}):Play()
	end)
	CloseBtn.MouseLeave:Connect(function()
		TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = TextColorDim}):Play()
	end)

	MinimizeBtn.MouseEnter:Connect(function()
		TweenService:Create(MinimizeBtn, TweenInfo.new(0.15), {TextColor3 = TextColor}):Play()
	end)
	MinimizeBtn.MouseLeave:Connect(function()
		TweenService:Create(MinimizeBtn, TweenInfo.new(0.15), {TextColor3 = TextColorDim}):Play()
	end)

	local Divider = Instance.new("Frame")
	Divider.Size = UDim2.new(1, 0, 0, 1)
	Divider.Position = UDim2.new(0, 0, 0, 36)
	Divider.BackgroundColor3 = BorderColor
	Divider.BorderSizePixel = 0
	Divider.Parent = MainFrame

	local SidebarW = 140
	local searchEnabled = config.Search == true
	local sidebarTopOffset = 37 + (searchEnabled and 34 or 0)

	local SearchBox
	if searchEnabled then
		local SearchFrame = Instance.new("Frame")
		SearchFrame.Size = UDim2.new(0, SidebarW, 0, 34)
		SearchFrame.Position = UDim2.new(0, 0, 0, 37)
		SearchFrame.BackgroundColor3 = PanelBg
		SearchFrame.BorderSizePixel = 0
		SearchFrame.Parent = MainFrame

		SearchBox = Instance.new("TextBox")
		SearchBox.PlaceholderText = "Search..."
		SearchBox.Text = ""
		SearchBox.Size = UDim2.new(1, -20, 0, 22)
		SearchBox.Position = UDim2.new(0, 10, 0.5, -11)
		SearchBox.BackgroundColor3 = DarkBg
		SearchBox.TextColor3 = TextColor
		SearchBox.PlaceholderColor3 = TextColorDim
		SearchBox.Font = MonoFont
		SearchBox.TextSize = 12
		SearchBox.TextXAlignment = Enum.TextXAlignment.Left
		SearchBox.ClipsDescendants = true
		SearchBox.Parent = SearchFrame

		local SearchBoxPadding = Instance.new("UIPadding", SearchBox)
		SearchBoxPadding.PaddingLeft = UDim.new(0, 6)

		local SearchBoxCorner = Instance.new("UICorner", SearchBox)
		SearchBoxCorner.CornerRadius = UDim.new(0, 4)

		local SearchDivider = Instance.new("Frame")
		SearchDivider.Size = UDim2.new(1, 0, 0, 1)
		SearchDivider.Position = UDim2.new(0, 0, 1, -1)
		SearchDivider.BackgroundColor3 = BorderColor
		SearchDivider.BorderSizePixel = 0
		SearchDivider.Parent = SearchFrame
	end

	local TabContainer = Instance.new("ScrollingFrame")
	TabContainer.Size = UDim2.new(0, SidebarW, 1, -sidebarTopOffset)
	TabContainer.Position = UDim2.new(0, 0, 0, sidebarTopOffset)
	TabContainer.BackgroundColor3 = PanelBg
	TabContainer.BorderSizePixel = 0
	TabContainer.ScrollBarThickness = 2
	TabContainer.ScrollBarImageColor3 = BorderColor
	TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
	TabContainer.Parent = MainFrame

	local TabListLayout = Instance.new("UIListLayout", TabContainer)
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local TabPadding = Instance.new("UIPadding", TabContainer)
	TabPadding.PaddingTop = UDim.new(0, 8)
	TabPadding.PaddingLeft = UDim.new(0, 10)
	TabPadding.PaddingBottom = UDim.new(0, 8)

	local SidebarDivider = Instance.new("Frame")
	SidebarDivider.Size = UDim2.new(0, 1, 1, -37)
	SidebarDivider.Position = UDim2.new(0, SidebarW, 0, 37)
	SidebarDivider.BackgroundColor3 = BorderColor
	SidebarDivider.BorderSizePixel = 0
	SidebarDivider.Parent = MainFrame

	local PagesFolder = Instance.new("Folder")
	PagesFolder.Name = "Pages"
	PagesFolder.Parent = MainFrame

	if config.BackgroundImage then
		local BgImage = Instance.new("ImageLabel")
		BgImage.Size = UDim2.new(1, 0, 1, 0)
		BgImage.BackgroundTransparency = 1
		BgImage.Image = loadImageFromUrl(config.BackgroundImage)
		BgImage.ImageTransparency = config.BackgroundTransparency or 0.85
		BgImage.ScaleType = Enum.ScaleType.Crop
		BgImage.ZIndex = 0
		BgImage.Parent = MainFrame
	end

	OpenButton.Name = "OpenButton"
	OpenButton.Size = UDim2.new(0, 44, 0, 44)
	OpenButton.Position = UDim2.new(0, 20, 0.5, 0)
	OpenButton.BackgroundColor3 = PanelBg
	OpenButton.Visible = false
	OpenButton.Parent = ScreenGui
	if config.Icon then
		OpenButton.Image = loadImageFromUrl(config.Icon)
	end

	local OpenStroke = Instance.new("UIStroke", OpenButton)
	OpenStroke.Color = BorderColor
	OpenStroke.Thickness = 1

	local OpenCorner = Instance.new("UICorner", OpenButton)
	OpenCorner.CornerRadius = UDim.new(0, 8)

	makeDraggable(TopBar, MainFrame)
	makeDraggable(OpenButton, OpenButton)

	if config.KeySystem then
		local keyDuration = config.KeyDuration or 86400
		local hubID = config.ID or "default"
		local authFile = "Key_Melo_auth_" .. hubID .. ".txt"
		local authValid = false
		pcall(function()
			local data = readfile(authFile)
			local savedID, savedKey, savedTime = data:match("^(.-)|(.-)|(%-?%d+)$")
			savedTime = tonumber(savedTime)
			if savedID == hubID and savedTime and (os.time() - savedTime) < keyDuration then
				if config.ValidKeys then
					for _, k in ipairs(config.ValidKeys) do
						if k == savedKey then
							authValid = true
							break
						end
					end
				elseif config.KeyUrl then
					authValid = true
				end
			end
		end)

		if not authValid then
			MainFrame.Visible = false
			ShadowImage.Visible = false
			OpenButton.Visible = false

			local keyImgAsset = nil
			pcall(function()
				local url = "https://raw.githubusercontent.com/Okaygotenitsme/MelotenHub/main/Key.png"
				writefile("Key_Melo.png", game:HttpGet(url))
				keyImgAsset = getcustomasset("Key_Melo.png")
			end)

			local KW, KH = 340, 160
			local KeyFrame = Instance.new("Frame")
			KeyFrame.Name = "KeyFrame"
			KeyFrame.Size = UDim2.new(0, KW, 0, KH)
			KeyFrame.Position = UDim2.new(0.5, -KW/2, 0.5, -KH/2)
			KeyFrame.BackgroundColor3 = DarkBg
			KeyFrame.BorderSizePixel = 0
			KeyFrame.ZIndex = 100
			KeyFrame.Parent = ScreenGui

			Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 6)
			local KStroke = Instance.new("UIStroke", KeyFrame)
			KStroke.Color = BorderColor
			KStroke.Thickness = 1

			local KShadow = Instance.new("ImageLabel")
			KShadow.BackgroundTransparency = 1
			KShadow.Image = "rbxassetid://6014261993"
			KShadow.ImageColor3 = Color3.new(0, 0, 0)
			KShadow.ImageTransparency = 0.45
			KShadow.ScaleType = Enum.ScaleType.Slice
			KShadow.SliceCenter = Rect.new(49, 49, 450, 450)
			KShadow.Size = UDim2.new(0, KW + 60, 0, KH + 60)
			KShadow.Position = UDim2.new(0, KeyFrame.AbsolutePosition.X - 30, 0, KeyFrame.AbsolutePosition.Y - 30)
			KShadow.AnchorPoint = Vector2.new(0, 0)
			KShadow.ZIndex = 99
			KShadow.Parent = ScreenGui

			local KTopBar = Instance.new("Frame")
			KTopBar.Size = UDim2.new(1, 0, 0, 36)
			KTopBar.BackgroundColor3 = PanelBg
			KTopBar.BorderSizePixel = 0
			KTopBar.ZIndex = 101
			KTopBar.Parent = KeyFrame
			Instance.new("UICorner", KTopBar).CornerRadius = UDim.new(0, 6)

			local KTopFix = Instance.new("Frame")
			KTopFix.Size = UDim2.new(1, 0, 0, 8)
			KTopFix.Position = UDim2.new(0, 0, 1, -8)
			KTopFix.BackgroundColor3 = PanelBg
			KTopFix.BorderSizePixel = 0
			KTopFix.ZIndex = 101
			KTopFix.Parent = KTopBar

			local KIcon = Instance.new("ImageLabel")
			KIcon.BackgroundTransparency = 1
			KIcon.Size = UDim2.new(0, 18, 0, 18)
			KIcon.Position = UDim2.new(0, 12, 0.5, -9)
			KIcon.Image = keyImgAsset or ""
			KIcon.ImageColor3 = PurpleAccent
			KIcon.ZIndex = 102
			KIcon.Parent = KTopBar

			local KTitle = Instance.new("TextLabel")
			KTitle.Text = config.KeyTitle or "Key system"
			KTitle.Size = UDim2.new(1, -46, 1, 0)
			KTitle.Position = UDim2.new(0, 38, 0, 0)
			KTitle.BackgroundTransparency = 1
			KTitle.TextColor3 = TextColor
			KTitle.Font = MonoFontBold
			KTitle.TextSize = 14
			KTitle.TextXAlignment = Enum.TextXAlignment.Left
			KTitle.ZIndex = 102
			KTitle.Parent = KTopBar

			local KDivider = Instance.new("Frame")
			KDivider.Size = UDim2.new(1, 0, 0, 1)
			KDivider.Position = UDim2.new(0, 0, 0, 36)
			KDivider.BackgroundColor3 = BorderColor
			KDivider.BorderSizePixel = 0
			KDivider.ZIndex = 101
			KDivider.Parent = KeyFrame

			local KInputBox = Instance.new("TextBox")
			KInputBox.PlaceholderText = "Enter key..."
			KInputBox.Text = ""
			KInputBox.Size = UDim2.new(1, -28, 0, 28)
			KInputBox.Position = UDim2.new(0, 14, 0, 48)
			KInputBox.BackgroundColor3 = PanelBg
			KInputBox.TextColor3 = TextColor
			KInputBox.PlaceholderColor3 = TextColorDim
			KInputBox.Font = MonoFont
			KInputBox.TextSize = 13
			KInputBox.TextXAlignment = Enum.TextXAlignment.Left
			KInputBox.ClearTextOnFocus = false
			KInputBox.ZIndex = 102
			KInputBox.Parent = KeyFrame

			local KInputCorner = Instance.new("UICorner", KInputBox)
			KInputCorner.CornerRadius = UDim.new(0, 4)
			local KInputStroke = Instance.new("UIStroke", KInputBox)
			KInputStroke.Color = BorderColor
			KInputStroke.Thickness = 1
			local KInputPad = Instance.new("UIPadding", KInputBox)
			KInputPad.PaddingLeft = UDim.new(0, 8)

			KInputBox.Focused:Connect(function()
				TweenService:Create(KInputStroke, TweenInfo.new(0.15), {Color = PurpleAccent}):Play()
			end)
			KInputBox.FocusLost:Connect(function()
				TweenService:Create(KInputStroke, TweenInfo.new(0.15), {Color = BorderColor}):Play()
			end)

			local KErrorLabel = Instance.new("TextLabel")
			KErrorLabel.Text = ""
			KErrorLabel.Size = UDim2.new(1, -28, 0, 14)
			KErrorLabel.Position = UDim2.new(0, 14, 0, 80)
			KErrorLabel.BackgroundTransparency = 1
			KErrorLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
			KErrorLabel.Font = MonoFont
			KErrorLabel.TextSize = 12
			KErrorLabel.TextXAlignment = Enum.TextXAlignment.Left
			KErrorLabel.ZIndex = 102
			KErrorLabel.Parent = KeyFrame

			local BtnY = 100
			local BtnW = 120

			local KConfirmBtn = Instance.new("TextButton")
			KConfirmBtn.Text = "Activate"
			KConfirmBtn.Size = UDim2.new(0, BtnW, 0, 28)
			KConfirmBtn.Position = UDim2.new(0, 14, 0, BtnY)
			KConfirmBtn.BackgroundColor3 = PurpleAccent
			KConfirmBtn.TextColor3 = TextColor
			KConfirmBtn.Font = MonoFontBold
			KConfirmBtn.TextSize = 13
			KConfirmBtn.ZIndex = 102
			KConfirmBtn.Parent = KeyFrame
			Instance.new("UICorner", KConfirmBtn).CornerRadius = UDim.new(0, 4)

			local KGetBtn = Instance.new("TextButton")
			KGetBtn.Text = "Get Key"
			KGetBtn.Size = UDim2.new(0, BtnW, 0, 28)
			KGetBtn.Position = UDim2.new(0, 14 + BtnW + 8, 0, BtnY)
			KGetBtn.BackgroundColor3 = PanelBg
			KGetBtn.TextColor3 = TextColorDim
			KGetBtn.Font = MonoFont
			KGetBtn.TextSize = 13
			KGetBtn.ZIndex = 102
			KGetBtn.Parent = KeyFrame
			Instance.new("UICorner", KGetBtn).CornerRadius = UDim.new(0, 4)
			local KGetStroke = Instance.new("UIStroke", KGetBtn)
			KGetStroke.Color = BorderColor
			KGetStroke.Thickness = 1

			KGetBtn.MouseEnter:Connect(function()
				TweenService:Create(KGetBtn, TweenInfo.new(0.15), {TextColor3 = TextColor}):Play()
				TweenService:Create(KGetStroke, TweenInfo.new(0.15), {Color = PurpleAccent}):Play()
			end)
			KGetBtn.MouseLeave:Connect(function()
				TweenService:Create(KGetBtn, TweenInfo.new(0.15), {TextColor3 = TextColorDim}):Play()
				TweenService:Create(KGetStroke, TweenInfo.new(0.15), {Color = BorderColor}):Play()
			end)

			makeDraggable(KTopBar, KeyFrame)

			KeyFrame:GetPropertyChangedSignal("Position"):Connect(function()
				KShadow.Position = UDim2.new(0, KeyFrame.AbsolutePosition.X - 30, 0, KeyFrame.AbsolutePosition.Y - 30)
			end)

			local function checkKey(input)
				if config.KeyUrl then
					local ok = false
					pcall(function()
						local url = config.KeyUrl .. "?key=" .. input .. "&id=" .. hubID
						local response = game:HttpGet(url)
						response = response:gsub("%s+", "")
						ok = (response == "true")
					end)
					return ok
				elseif config.ValidKeys then
					for _, k in ipairs(config.ValidKeys) do
						if k == input then
							return true
						end
					end
				end
				return false
			end

			KConfirmBtn.MouseButton1Click:Connect(function()
				local input = KInputBox.Text
				local ok = checkKey(input)
				if ok then
					pcall(function()
						writefile(authFile, hubID .. "|" .. input .. "|" .. tostring(os.time()))
					end)
					local fadeTween = TweenService:Create(KeyFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1})
					TweenService:Create(KShadow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
					TweenService:Create(KTitle, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
					TweenService:Create(KIcon, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
					TweenService:Create(KInputBox, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
					TweenService:Create(KInputStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
					TweenService:Create(KConfirmBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
					TweenService:Create(KGetBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
					TweenService:Create(KDivider, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
					TweenService:Create(KTopBar, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
					TweenService:Create(KStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
					fadeTween:Play()
					fadeTween.Completed:Wait()
					KeyFrame:Destroy()
					KShadow:Destroy()
					MainFrame.Visible = true
					ShadowImage.Visible = true
					task.defer(syncShadow)
				else
					KErrorLabel.Text = "Invalid key."
					KInputStroke.Color = Color3.fromRGB(200, 60, 60)
					task.delay(2, function()
						KErrorLabel.Text = ""
						TweenService:Create(KInputStroke, TweenInfo.new(0.15), {Color = BorderColor}):Play()
					end)
				end
			end)

			KGetBtn.MouseButton1Click:Connect(function()
				if not config.KeyLink then return end
				setclipboard(config.KeyLink)
				local prev = KGetBtn.Text
				KGetBtn.Text = "Copied!"
				TweenService:Create(KGetBtn, TweenInfo.new(0.15), {TextColor3 = PurpleAccent}):Play()
				task.delay(1.5, function()
					KGetBtn.Text = prev
					TweenService:Create(KGetBtn, TweenInfo.new(0.15), {TextColor3 = TextColorDim}):Play()
				end)
			end)
		end
	end

	CloseBtn.MouseButton1Click:Connect(function()
		_G.__HUB_INSTANCES[hubID] = nil
		local fadeTween = TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, W, 0, 0), Position = UDim2.new(0.5, -W/2, 0.5, 0)})
		TweenService:Create(ShadowImage, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
		fadeTween:Play()
		fadeTween.Completed:Wait()
		ScreenGui:Destroy()
	end)

	MinimizeBtn.MouseButton1Click:Connect(function()
		TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, W, 0, 0), Position = UDim2.new(0.5, -W/2, 0.5, 0)}):Play()
		task.wait(0.2)
		MainFrame.Visible = false
		MainFrame.Size = UDim2.new(0, W, 0, H)
		MainFrame.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
		OpenButton.Visible = true
	end)

	OpenButton.MouseButton1Click:Connect(function()
		OpenButton.Visible = false
		MainFrame.Visible = true
		MainFrame.Size = UDim2.new(0, W, 0, 0)
		MainFrame.Position = UDim2.new(0.5, -W/2, 0.5, 0)
		TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, W, 0, H), Position = UDim2.new(0.5, -W/2, 0.5, -H/2)}):Play()
	end)

	self._tabContainer = TabContainer
	self._pagesFolder = PagesFolder
	self._W = W
	self._H = H
	self._searchables = {}

	if SearchBox then
		SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
			local query = SearchBox.Text:lower()
			for _, entry in ipairs(self._searchables) do
				if entry.page == self._currentPage then
					if query == "" then
						entry.frame.Visible = true
					else
						entry.frame.Visible = entry.name:lower():find(query, 1, true) ~= nil
					end
				end
			end
		end)
	end

	function self:AddTab(name, icon)
		local Page = Instance.new("ScrollingFrame")
		Page.Name = name
		Page.Size = UDim2.new(1, -SidebarW - 20, 1, -55)
		Page.Position = UDim2.new(0, SidebarW + 10, 0, 47)
		Page.BackgroundTransparency = 1
		Page.ScrollBarThickness = 2
		Page.ScrollBarImageColor3 = BorderColor
		Page.Visible = false
		Page.CanvasSize = UDim2.new(0, 0, 0, 0)
		Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Page.Parent = PagesFolder

		local Layout = Instance.new("UIListLayout", Page)
		Layout.SortOrder = Enum.SortOrder.LayoutOrder

		local Padding = Instance.new("UIPadding", Page)
		Padding.PaddingBottom = UDim.new(0, 8)

		local TabBtn = Instance.new("TextButton")
		TabBtn.Text = icon and ("        " .. name) or ("  " .. name)
		TabBtn.Size = UDim2.new(1, -10, 0, 32)
		TabBtn.BackgroundColor3 = PurpleAccent
		TabBtn.BackgroundTransparency = 1
		TabBtn.TextColor3 = TextColorDim
		TabBtn.Font = MonoFont
		TabBtn.TextSize = 14
		TabBtn.TextXAlignment = Enum.TextXAlignment.Left
		TabBtn.Parent = TabContainer

		local TabIcon
		if icon then
			TabIcon = Instance.new("ImageLabel")
			TabIcon.Size = UDim2.new(0, 16, 0, 16)
			TabIcon.Position = UDim2.new(0, 8, 0.5, -8)
			TabIcon.BackgroundTransparency = 1
			TabIcon.Image = loadImageFromUrl(icon)
			TabIcon.ImageColor3 = TextColorDim
			TabIcon.Parent = TabBtn
		end

		local win = self
		TabBtn.MouseButton1Click:Connect(function()
			if win._currentTab then
				TweenService:Create(win._currentTab, TweenInfo.new(0.15), {BackgroundTransparency = 1, TextColor3 = TextColorDim}):Play()
				local prevIcon = win._currentTab:FindFirstChildOfClass("ImageLabel")
				if prevIcon then
					TweenService:Create(prevIcon, TweenInfo.new(0.15), {ImageColor3 = TextColorDim}):Play()
				end
			end
			if win._currentPage then
				win._currentPage.Visible = false
			end
			win._currentTab = TabBtn
			win._currentPage = Page
			Page.Visible = true
			Page.Position = UDim2.new(0, SidebarW + 4, 0, 47)
			TweenService:Create(Page, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = UDim2.new(0, SidebarW + 10, 0, 47)}):Play()
			TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.85, TextColor3 = TextColor}):Play()
			if TabIcon then
				TweenService:Create(TabIcon, TweenInfo.new(0.15), {ImageColor3 = TextColor}):Play()
			end
			if SearchBox then
				SearchBox.Text = ""
				for _, entry in ipairs(win._searchables) do
					entry.frame.Visible = true
				end
			end
		end)

		if not self._currentTab then
			self._currentTab = TabBtn
			self._currentPage = Page
			Page.Visible = true
			TabBtn.BackgroundTransparency = 0.85
			TabBtn.TextColor3 = TextColor
			if TabIcon then
				TabIcon.ImageColor3 = TextColor
			end
		end

		local tab = {}

		local function registerSearchable(frame, name)
			if searchEnabled then
				table.insert(win._searchables, {frame = frame, name = name, page = Page})
			end
		end

		function tab:AddToggle(labelText, defaultState, callback)
			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Size = UDim2.new(1, -4, 0, 34)
			ToggleFrame.BackgroundTransparency = 1
			ToggleFrame.Parent = Page

			local Label = Instance.new("TextLabel")
			Label.Text = labelText
			Label.Size = UDim2.new(1, -60, 1, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextColorDim
			Label.Font = MonoFont
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = ToggleFrame

			local Sw = Instance.new("Frame")
			Sw.Size = UDim2.new(0, 34, 0, 18)
			Sw.Position = UDim2.new(1, -34, 0.5, -9)
			Sw.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			Sw.Parent = ToggleFrame
			Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)

			local Circ = Instance.new("Frame")
			Circ.Size = UDim2.new(0, 14, 0, 14)
			Circ.Position = UDim2.new(0, 2, 0.5, -7)
			Circ.BackgroundColor3 = Color3.fromRGB(130, 130, 140)
			Circ.Parent = Sw
			Instance.new("UICorner", Circ).CornerRadius = UDim.new(1, 0)

			local SwBtn = Instance.new("TextButton")
			SwBtn.Size = UDim2.new(1, 0, 1, 0)
			SwBtn.BackgroundTransparency = 1
			SwBtn.Text = ""
			SwBtn.Parent = Sw

			local BottomDivider = Instance.new("Frame")
			BottomDivider.Size = UDim2.new(1, 0, 0, 1)
			BottomDivider.Position = UDim2.new(0, 0, 1, -2)
			BottomDivider.BackgroundColor3 = BorderColor
			BottomDivider.BorderSizePixel = 0
			BottomDivider.Parent = ToggleFrame

			local state = false

			local function setState(on, silent)
				state = on
				local swColor = on and PurpleAccent or Color3.fromRGB(35, 35, 40)
				local circPos = on and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
				local circColor = on and TextColor or Color3.fromRGB(130, 130, 140)
				local labelColor = on and TextColor or TextColorDim
				TweenService:Create(Sw, TweenInfo.new(0.15), {BackgroundColor3 = swColor}):Play()
				TweenService:Create(Circ, TweenInfo.new(0.15), {Position = circPos, BackgroundColor3 = circColor}):Play()
				TweenService:Create(Label, TweenInfo.new(0.15), {TextColor3 = labelColor}):Play()
				if not silent and callback then callback(state) end
			end

			SwBtn.MouseEnter:Connect(function()
				TweenService:Create(ToggleFrame, TweenInfo.new(0.15), {BackgroundTransparency = 0.95}):Play()
			end)
			SwBtn.MouseLeave:Connect(function()
				TweenService:Create(ToggleFrame, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
			end)
			SwBtn.MouseButton1Click:Connect(function()
				setState(not state)
			end)

			ToggleFrame.BackgroundColor3 = ElementBgHover
			Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 4)

			if defaultState then
				setState(true, true)
			end

			registerSearchable(ToggleFrame, labelText)

			local api = {}
			function api:Set(val, silent) setState(val, silent) end
			function api:Get() return state end
			function api:Toggle(silent) setState(not state, silent) end
			function api:SetLabel(text) Label.Text = text end
			return api
		end

		function tab:AddButton(labelText, buttonText, callback)
			local Frame = Instance.new("Frame")
			Frame.Size = UDim2.new(1, -4, 0, 34)
			Frame.BackgroundTransparency = 1
			Frame.Parent = Page

			local Label = Instance.new("TextLabel")
			Label.Text = labelText
			Label.Size = UDim2.new(1, -100, 1, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextColorDim
			Label.Font = MonoFont
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = Frame

			local Btn = Instance.new("TextButton")
			Btn.Text = buttonText or "Run"
			Btn.Size = UDim2.new(0, 84, 0, 26)
			Btn.Position = UDim2.new(1, -84, 0.5, -13)
			Btn.BackgroundColor3 = PanelBg
			Btn.TextColor3 = TextColor
			Btn.Font = MonoFontBold
			Btn.TextSize = 13
			Btn.Parent = Frame

			local BtnStroke = Instance.new("UIStroke", Btn)
			BtnStroke.Color = BorderColor
			BtnStroke.Thickness = 1

			local BtnCorner = Instance.new("UICorner", Btn)
			BtnCorner.CornerRadius = UDim.new(0, 4)

			local BottomDivider = Instance.new("Frame")
			BottomDivider.Size = UDim2.new(1, 0, 0, 1)
			BottomDivider.Position = UDim2.new(0, 0, 1, -2)
			BottomDivider.BackgroundColor3 = BorderColor
			BottomDivider.BorderSizePixel = 0
			BottomDivider.Parent = Frame

			Frame.BackgroundColor3 = ElementBgHover
			Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)

			Btn.MouseEnter:Connect(function()
				TweenService:Create(Frame, TweenInfo.new(0.15), {BackgroundTransparency = 0.95}):Play()
				TweenService:Create(BtnStroke, TweenInfo.new(0.15), {Color = PurpleAccent}):Play()
			end)
			Btn.MouseLeave:Connect(function()
				TweenService:Create(Frame, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
				TweenService:Create(BtnStroke, TweenInfo.new(0.15), {Color = BorderColor}):Play()
			end)
			Btn.MouseButton1Click:Connect(function()
				TweenService:Create(Btn, TweenInfo.new(0.08), {BackgroundColor3 = PurpleAccent}):Play()
				task.delay(0.12, function()
					TweenService:Create(Btn, TweenInfo.new(0.12), {BackgroundColor3 = PanelBg}):Play()
				end)
				if callback then callback() end
			end)

			registerSearchable(Frame, labelText)

			local api = {}
			function api:SetLabel(text) Label.Text = text end
			function api:SetButtonText(text) Btn.Text = text end
			function api:Fire() if callback then callback() end end
			function api:SetEnabled(val)
				Btn.AutoButtonColor = val
				if val then
					Btn.TextColor3 = TextColor
					BtnStroke.Color = BorderColor
				else
					Btn.TextColor3 = TextColorDim
					BtnStroke.Color = Color3.fromRGB(25, 25, 30)
				end
			end
			return api
		end

		function tab:AddSlider(labelText, minVal, maxVal, defaultVal, callback)
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Size = UDim2.new(1, -4, 0, 48)
			SliderFrame.BackgroundTransparency = 1
			SliderFrame.Parent = Page

			local Label = Instance.new("TextLabel")
			Label.Text = labelText
			Label.Size = UDim2.new(1, -70, 0, 22)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextColorDim
			Label.Font = MonoFont
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = SliderFrame

			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Text = tostring(defaultVal)
			ValueLabel.Size = UDim2.new(0, 60, 0, 22)
			ValueLabel.Position = UDim2.new(1, -60, 0, 0)
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.TextColor3 = PurpleAccent
			ValueLabel.Font = MonoFontBold
			ValueLabel.TextSize = 14
			ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
			ValueLabel.Parent = SliderFrame

			local Track = Instance.new("Frame")
			Track.Size = UDim2.new(1, -4, 0, 4)
			Track.Position = UDim2.new(0, 0, 0, 30)
			Track.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			Track.BorderSizePixel = 0
			Track.Parent = SliderFrame

			local Fill = Instance.new("Frame")
			Fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
			Fill.BackgroundColor3 = PurpleAccent
			Fill.BorderSizePixel = 0
			Fill.Parent = Track

			local Knob = Instance.new("Frame")
			Knob.Size = UDim2.new(0, 10, 0, 10)
			Knob.AnchorPoint = Vector2.new(0.5, 0.5)
			local initRatio = (defaultVal - minVal) / (maxVal - minVal)
			Knob.Position = UDim2.new(initRatio, 0, 0.5, 0)
			Knob.BackgroundColor3 = TextColor
			Knob.Parent = Track
			Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

			local BottomDivider = Instance.new("Frame")
			BottomDivider.Size = UDim2.new(1, 0, 0, 1)
			BottomDivider.Position = UDim2.new(0, 0, 1, -2)
			BottomDivider.BackgroundColor3 = BorderColor
			BottomDivider.BorderSizePixel = 0
			BottomDivider.Parent = SliderFrame

			local dragging = false
			local currentValue = defaultVal

			local HitArea = Instance.new("TextButton")
			HitArea.Size = UDim2.new(1, 0, 0, 22)
			HitArea.Position = UDim2.new(0, 0, 0, 22)
			HitArea.BackgroundTransparency = 1
			HitArea.Text = ""
			HitArea.Parent = SliderFrame

			local function updateSlider(inputX, silent)
				local rel = math.clamp((inputX - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
				local value = math.floor(minVal + (maxVal - minVal) * rel)
				currentValue = value
				Fill.Size = UDim2.new(rel, 0, 1, 0)
				Knob.Position = UDim2.new(rel, 0, 0.5, 0)
				ValueLabel.Text = tostring(value)
				if not silent and callback then callback(value) end
			end

			local inputChangedConn
			HitArea.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					updateSlider(input.Position.X)
					inputChangedConn = UserInputService.InputChanged:Connect(function(inp)
						if not dragging then return end
						if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
							updateSlider(inp.Position.X)
						end
					end)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					if dragging then
						dragging = false
						if inputChangedConn then
							inputChangedConn:Disconnect()
							inputChangedConn = nil
						end
					end
				end
			end)

			SliderFrame.BackgroundColor3 = ElementBgHover
			Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 4)

			HitArea.MouseEnter:Connect(function()
				TweenService:Create(SliderFrame, TweenInfo.new(0.15), {BackgroundTransparency = 0.95}):Play()
				TweenService:Create(Knob, TweenInfo.new(0.15), {Size = UDim2.new(0, 13, 0, 13)}):Play()
			end)
			HitArea.MouseLeave:Connect(function()
				if not dragging then
					TweenService:Create(SliderFrame, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
					TweenService:Create(Knob, TweenInfo.new(0.15), {Size = UDim2.new(0, 10, 0, 10)}):Play()
				end
			end)

			registerSearchable(SliderFrame, labelText)

			local api = {}
			function api:Set(val, silent)
				val = math.clamp(val, minVal, maxVal)
				local ratio = (val - minVal) / (maxVal - minVal)
				currentValue = val
				Fill.Size = UDim2.new(ratio, 0, 1, 0)
				Knob.Position = UDim2.new(ratio, 0, 0.5, 0)
				ValueLabel.Text = tostring(val)
				if not silent and callback then callback(val) end
			end
			function api:Get() return currentValue end
			function api:SetLabel(text) Label.Text = text end
			function api:SetMin(val) minVal = val end
			function api:SetMax(val) maxVal = val end
			return api
		end

		function tab:AddInput(labelText, placeholderText, callback)
			local InputFrame = Instance.new("Frame")
			InputFrame.Size = UDim2.new(1, -4, 0, 36)
			InputFrame.BackgroundTransparency = 1
			InputFrame.Parent = Page

			local Label = Instance.new("TextLabel")
			Label.Text = labelText
			Label.Size = UDim2.new(0, 170, 1, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextColorDim
			Label.Font = MonoFont
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = InputFrame

			local TextBox = Instance.new("TextBox")
			TextBox.PlaceholderText = placeholderText or ""
			TextBox.Text = ""
			TextBox.Size = UDim2.new(0, 120, 0, 24)
			TextBox.Position = UDim2.new(1, -120, 0.5, -12)
			TextBox.BackgroundColor3 = PanelBg
			TextBox.TextColor3 = TextColor
			TextBox.Font = MonoFont
			TextBox.TextSize = 13
			TextBox.PlaceholderColor3 = TextColorDim
			TextBox.Parent = InputFrame

			local TextStroke = Instance.new("UIStroke", TextBox)
			TextStroke.Color = BorderColor
			TextStroke.Thickness = 1

			local TextBoxCorner = Instance.new("UICorner", TextBox)
			TextBoxCorner.CornerRadius = UDim.new(0, 4)

			local TextPad = Instance.new("UIPadding", TextBox)
			TextPad.PaddingLeft = UDim.new(0, 6)

			local BottomDivider = Instance.new("Frame")
			BottomDivider.Size = UDim2.new(1, 0, 0, 1)
			BottomDivider.Position = UDim2.new(0, 0, 1, -2)
			BottomDivider.BackgroundColor3 = BorderColor
			BottomDivider.BorderSizePixel = 0
			BottomDivider.Parent = InputFrame

			TextBox.Focused:Connect(function()
				TweenService:Create(TextStroke, TweenInfo.new(0.15), {Color = PurpleAccent}):Play()
				TweenService:Create(InputFrame, TweenInfo.new(0.15), {BackgroundTransparency = 0.92}):Play()
			end)
			TextBox.FocusLost:Connect(function()
				TweenService:Create(TextStroke, TweenInfo.new(0.15), {Color = BorderColor}):Play()
				TweenService:Create(InputFrame, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
				if callback then callback(TextBox.Text) end
			end)

			InputFrame.BackgroundColor3 = ElementBgHover
			Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 4)

			registerSearchable(InputFrame, labelText)

			local api = {}
			function api:Set(text) TextBox.Text = text end
			function api:Get() return TextBox.Text end
			function api:SetLabel(text) Label.Text = text end
			function api:SetPlaceholder(text) TextBox.PlaceholderText = text end
			function api:Clear() TextBox.Text = "" end
			return api
		end

		function tab:AddLabel(text, color)
			local LabelFrame = Instance.new("Frame")
			LabelFrame.Size = UDim2.new(1, -4, 0, 26)
			LabelFrame.BackgroundTransparency = 1
			LabelFrame.Parent = Page

			local Label = Instance.new("TextLabel")
			Label.Text = text
			Label.Size = UDim2.new(1, 0, 1, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = color or PurpleAccent
			Label.Font = MonoFontBold
			Label.TextSize = 13
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = LabelFrame

			local api = {}
			function api:Set(t) Label.Text = t end
			function api:Get() return Label.Text end
			function api:SetColor(c) Label.TextColor3 = c end
			return api
		end

		function tab:AddSection(text)
			local SectionFrame = Instance.new("Frame")
			SectionFrame.Size = UDim2.new(1, -4, 0, 30)
			SectionFrame.BackgroundTransparency = 1
			SectionFrame.Parent = Page

			local Label = Instance.new("TextLabel")
			Label.Text = text
			Label.Size = UDim2.new(1, 0, 0, 20)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextColor
			Label.Font = MonoFontBold
			Label.TextSize = 15
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = SectionFrame

			local Divider = Instance.new("Frame")
			Divider.Size = UDim2.new(1, 0, 0, 1)
			Divider.Position = UDim2.new(0, 0, 1, -4)
			Divider.BackgroundColor3 = BorderColor
			Divider.BorderSizePixel = 0
			Divider.Parent = SectionFrame

			local api = {}
			function api:Set(t) Label.Text = t end
			function api:Get() return Label.Text end
			return api
		end

		function tab:AddMultiToggle(labelText, options, callback)
			local selected = {}
			local controls = {}

			local HeaderFrame = Instance.new("Frame")
			HeaderFrame.Size = UDim2.new(1, -4, 0, 26)
			HeaderFrame.BackgroundTransparency = 1
			HeaderFrame.Parent = Page

			local HeaderLabel = Instance.new("TextLabel")
			HeaderLabel.Text = labelText
			HeaderLabel.Size = UDim2.new(1, 0, 1, 0)
			HeaderLabel.BackgroundTransparency = 1
			HeaderLabel.TextColor3 = TextColor
			HeaderLabel.Font = MonoFontBold
			HeaderLabel.TextSize = 13
			HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
			HeaderLabel.Parent = HeaderFrame

			for _, option in ipairs(options) do
				local OptFrame = Instance.new("Frame")
				OptFrame.Size = UDim2.new(1, -4, 0, 30)
				OptFrame.BackgroundTransparency = 1
				OptFrame.Parent = Page

				local OptLabel = Instance.new("TextLabel")
				OptLabel.Text = option
				OptLabel.Size = UDim2.new(1, -60, 1, 0)
				OptLabel.BackgroundTransparency = 1
				OptLabel.TextColor3 = TextColorDim
				OptLabel.Font = MonoFont
				OptLabel.TextSize = 13
				OptLabel.TextXAlignment = Enum.TextXAlignment.Left
				OptLabel.Parent = OptFrame

				local Sw = Instance.new("Frame")
				Sw.Size = UDim2.new(0, 34, 0, 18)
				Sw.Position = UDim2.new(1, -34, 0.5, -9)
				Sw.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
				Sw.Parent = OptFrame
				Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)

				local Circ = Instance.new("Frame")
				Circ.Size = UDim2.new(0, 14, 0, 14)
				Circ.Position = UDim2.new(0, 2, 0.5, -7)
				Circ.BackgroundColor3 = Color3.fromRGB(130, 130, 140)
				Circ.Parent = Sw
				Instance.new("UICorner", Circ).CornerRadius = UDim.new(1, 0)

				local SwBtn = Instance.new("TextButton")
				SwBtn.Size = UDim2.new(1, 0, 1, 0)
				SwBtn.BackgroundTransparency = 1
				SwBtn.Text = ""
				SwBtn.Parent = Sw

				local BottomDivider = Instance.new("Frame")
				BottomDivider.Size = UDim2.new(1, 0, 0, 1)
				BottomDivider.Position = UDim2.new(0, 0, 1, -2)
				BottomDivider.BackgroundColor3 = BorderColor
				BottomDivider.BorderSizePixel = 0
				BottomDivider.Parent = OptFrame

				local optState = false
				local optName = option

				local function applyVisual(state)
					local swColor = state and PurpleAccent or Color3.fromRGB(35, 35, 40)
					local circPos = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
					local circColor = state and TextColor or Color3.fromRGB(130, 130, 140)
					local labelColor = state and TextColor or TextColorDim
					TweenService:Create(Sw, TweenInfo.new(0.15), {BackgroundColor3 = swColor}):Play()
					TweenService:Create(Circ, TweenInfo.new(0.15), {Position = circPos, BackgroundColor3 = circColor}):Play()
					TweenService:Create(OptLabel, TweenInfo.new(0.15), {TextColor3 = labelColor}):Play()
				end

				controls[optName] = function(state, silent)
					optState = state
					selected[optName] = state
					applyVisual(state)
					if not silent and callback then callback(selected) end
				end

				SwBtn.MouseButton1Click:Connect(function()
					optState = not optState
					selected[optName] = optState
					applyVisual(optState)
					if callback then callback(selected) end
				end)
			end

			local api = {}
			function api:SetAll(state, silent)
				for _, setter in pairs(controls) do
					setter(state, true)
				end
				if not silent and callback then callback(selected) end
			end
			function api:Set(option, state, silent)
				if controls[option] then
					controls[option](state, silent)
				end
			end
			function api:Get() return selected end
			function api:GetOption(option) return selected[option] == true end
			return api
		end

		function tab:AddDropdown(labelText, options, callback)
			local selected = options[1]
			local open = false

			local DropFrame = Instance.new("Frame")
			DropFrame.Size = UDim2.new(1, -4, 0, 34)
			DropFrame.BackgroundTransparency = 1
			DropFrame.ClipsDescendants = false
			DropFrame.Parent = Page

			local Label = Instance.new("TextLabel")
			Label.Text = labelText
			Label.Size = UDim2.new(1, -140, 1, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextColorDim
			Label.Font = MonoFont
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = DropFrame

			local Btn = Instance.new("TextButton")
			Btn.Text = selected .. "  ▾"
			Btn.Size = UDim2.new(0, 130, 0, 26)
			Btn.Position = UDim2.new(1, -130, 0.5, -13)
			Btn.BackgroundColor3 = PanelBg
			Btn.TextColor3 = TextColor
			Btn.Font = MonoFont
			Btn.TextSize = 12
			Btn.TextTruncate = Enum.TextTruncate.AtEnd
			Btn.Parent = DropFrame

			local BtnStroke = Instance.new("UIStroke", Btn)
			BtnStroke.Color = BorderColor
			BtnStroke.Thickness = 1

			local BtnCorner = Instance.new("UICorner", Btn)
			BtnCorner.CornerRadius = UDim.new(0, 4)

			local BottomDivider = Instance.new("Frame")
			BottomDivider.Size = UDim2.new(1, 0, 0, 1)
			BottomDivider.Position = UDim2.new(0, 0, 1, -2)
			BottomDivider.BackgroundColor3 = BorderColor
			BottomDivider.BorderSizePixel = 0
			BottomDivider.Parent = DropFrame

			local Menu = Instance.new("Frame")
			Menu.Size = UDim2.new(0, 130, 0, #options * 28)
			Menu.Position = UDim2.new(1, -130, 1, 2)
			Menu.BackgroundColor3 = PanelBg
			Menu.BorderSizePixel = 0
			Menu.Visible = false
			Menu.ZIndex = 10
			Menu.Parent = DropFrame

			local MenuStroke = Instance.new("UIStroke", Menu)
			MenuStroke.Color = BorderColor
			MenuStroke.Thickness = 1

			local MenuCorner = Instance.new("UICorner", Menu)
			MenuCorner.CornerRadius = UDim.new(0, 4)

			local MenuLayout = Instance.new("UIListLayout", Menu)
			MenuLayout.SortOrder = Enum.SortOrder.LayoutOrder

			local optBtns = {}

			local function selectOption(option, silent)
				selected = option
				Btn.Text = option .. "  ▾"
				for _, child in ipairs(Menu:GetChildren()) do
					if child:IsA("TextButton") then
						child.TextColor3 = child.Text == selected and TextColor or TextColorDim
					end
				end
				Menu.Visible = false
				open = false
				TweenService:Create(BtnStroke, TweenInfo.new(0.15), {Color = BorderColor}):Play()
				if not silent and callback then callback(selected) end
			end

			for _, option in ipairs(options) do
				local OptBtn = Instance.new("TextButton")
				OptBtn.Text = option
				OptBtn.Size = UDim2.new(1, 0, 0, 28)
				OptBtn.BackgroundTransparency = 1
				OptBtn.TextColor3 = option == selected and TextColor or TextColorDim
				OptBtn.Font = MonoFont
				OptBtn.TextSize = 12
				OptBtn.TextTruncate = Enum.TextTruncate.AtEnd
				OptBtn.ZIndex = 11
				OptBtn.Parent = Menu
				optBtns[option] = OptBtn

				OptBtn.MouseEnter:Connect(function()
					TweenService:Create(OptBtn, TweenInfo.new(0.1), {TextColor3 = TextColor}):Play()
				end)
				OptBtn.MouseLeave:Connect(function()
					if OptBtn.Text ~= selected then
						TweenService:Create(OptBtn, TweenInfo.new(0.1), {TextColor3 = TextColorDim}):Play()
					end
				end)
				OptBtn.MouseButton1Click:Connect(function()
					selectOption(option)
				end)
			end

			Btn.MouseButton1Click:Connect(function()
				open = not open
				Menu.Visible = open
				TweenService:Create(BtnStroke, TweenInfo.new(0.15), {Color = open and PurpleAccent or BorderColor}):Play()
			end)

			registerSearchable(DropFrame, labelText)

			local api = {}
			function api:Set(option, silent) selectOption(option, silent) end
			function api:Get() return selected end
			function api:SetLabel(text) Label.Text = text end
			function api:SetOptions(newOptions)
				for _, child in ipairs(Menu:GetChildren()) do
					if child:IsA("TextButton") then child:Destroy() end
				end
				optBtns = {}
				options = newOptions
				selected = newOptions[1]
				Btn.Text = selected .. "  ▾"
				Menu.Size = UDim2.new(0, 130, 0, #newOptions * 28)
				for _, option in ipairs(newOptions) do
					local OptBtn = Instance.new("TextButton")
					OptBtn.Text = option
					OptBtn.Size = UDim2.new(1, 0, 0, 28)
					OptBtn.BackgroundTransparency = 1
					OptBtn.TextColor3 = option == selected and TextColor or TextColorDim
					OptBtn.Font = MonoFont
					OptBtn.TextSize = 12
					OptBtn.TextTruncate = Enum.TextTruncate.AtEnd
					OptBtn.ZIndex = 11
					OptBtn.Parent = Menu
					optBtns[option] = OptBtn
					OptBtn.MouseEnter:Connect(function()
						TweenService:Create(OptBtn, TweenInfo.new(0.1), {TextColor3 = TextColor}):Play()
					end)
					OptBtn.MouseLeave:Connect(function()
						if OptBtn.Text ~= selected then
							TweenService:Create(OptBtn, TweenInfo.new(0.1), {TextColor3 = TextColorDim}):Play()
						end
					end)
					OptBtn.MouseButton1Click:Connect(function()
						selectOption(option)
					end)
				end
			end
			return api
		end

		function tab:AddParagraph(title, text)
			local PFrame = Instance.new("Frame")
			PFrame.Size = UDim2.new(1, -4, 0, 0)
			PFrame.AutomaticSize = Enum.AutomaticSize.Y
			PFrame.BackgroundColor3 = ElementBgHover
			PFrame.BackgroundTransparency = 0.5
			PFrame.BorderSizePixel = 0
			PFrame.Parent = Page
			Instance.new("UICorner", PFrame).CornerRadius = UDim.new(0, 4)

			local PStroke = Instance.new("UIStroke", PFrame)
			PStroke.Color = BorderColor
			PStroke.Thickness = 1

			local PPad = Instance.new("UIPadding", PFrame)
			PPad.PaddingLeft = UDim.new(0, 10)
			PPad.PaddingRight = UDim.new(0, 10)
			PPad.PaddingTop = UDim.new(0, 8)
			PPad.PaddingBottom = UDim.new(0, 8)

			local PLayout = Instance.new("UIListLayout", PFrame)
			PLayout.Padding = UDim.new(0, 4)
			PLayout.SortOrder = Enum.SortOrder.LayoutOrder

			local TitleLabel = Instance.new("TextLabel")
			TitleLabel.Text = title
			TitleLabel.Size = UDim2.new(1, 0, 0, 16)
			TitleLabel.BackgroundTransparency = 1
			TitleLabel.TextColor3 = TextColor
			TitleLabel.Font = MonoFontBold
			TitleLabel.TextSize = 13
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
			TitleLabel.LayoutOrder = 1
			TitleLabel.Parent = PFrame

			local TextLabel = Instance.new("TextLabel")
			TextLabel.Text = text
			TextLabel.Size = UDim2.new(1, 0, 0, 0)
			TextLabel.AutomaticSize = Enum.AutomaticSize.Y
			TextLabel.BackgroundTransparency = 1
			TextLabel.TextColor3 = TextColorDim
			TextLabel.Font = MonoFont
			TextLabel.TextSize = 12
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.TextWrapped = true
			TextLabel.LayoutOrder = 2
			TextLabel.Parent = PFrame

			local Spacer = Instance.new("Frame")
			Spacer.Size = UDim2.new(1, 0, 0, 4)
			Spacer.BackgroundTransparency = 1
			Spacer.LayoutOrder = 3
			Spacer.Parent = PFrame

			local api = {}
			function api:SetTitle(t) TitleLabel.Text = t end
			function api:SetText(t) TextLabel.Text = t end
			function api:GetTitle() return TitleLabel.Text end
			function api:GetText() return TextLabel.Text end
			return api
		end

		function tab:AddKeybind(labelText, defaultKey, callback)
			local currentKey = defaultKey or "None"
			local listening = false

			local KFrame = Instance.new("Frame")
			KFrame.Size = UDim2.new(1, -4, 0, 34)
			KFrame.BackgroundColor3 = ElementBgHover
			KFrame.BackgroundTransparency = 1
			KFrame.BorderSizePixel = 0
			KFrame.Parent = Page
			Instance.new("UICorner", KFrame).CornerRadius = UDim.new(0, 4)

			local Label = Instance.new("TextLabel")
			Label.Text = labelText
			Label.Size = UDim2.new(1, -100, 1, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextColorDim
			Label.Font = MonoFont
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = KFrame

			local KeyBtn = Instance.new("TextButton")
			KeyBtn.Text = currentKey
			KeyBtn.Size = UDim2.new(0, 84, 0, 26)
			KeyBtn.Position = UDim2.new(1, -84, 0.5, -13)
			KeyBtn.BackgroundColor3 = PanelBg
			KeyBtn.TextColor3 = TextColor
			KeyBtn.Font = MonoFontBold
			KeyBtn.TextSize = 12
			KeyBtn.Parent = KFrame
			Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 4)

			local KeyStroke = Instance.new("UIStroke", KeyBtn)
			KeyStroke.Color = BorderColor
			KeyStroke.Thickness = 1

			local BottomDivider = Instance.new("Frame")
			BottomDivider.Size = UDim2.new(1, 0, 0, 1)
			BottomDivider.Position = UDim2.new(0, 0, 1, -2)
			BottomDivider.BackgroundColor3 = BorderColor
			BottomDivider.BorderSizePixel = 0
			BottomDivider.Parent = KFrame

			KFrame.BackgroundColor3 = ElementBgHover
			KeyBtn.MouseEnter:Connect(function()
				TweenService:Create(KFrame, TweenInfo.new(0.15), {BackgroundTransparency = 0.95}):Play()
				if not listening then
					TweenService:Create(KeyStroke, TweenInfo.new(0.15), {Color = PurpleAccent}):Play()
				end
			end)
			KeyBtn.MouseLeave:Connect(function()
				TweenService:Create(KFrame, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
				if not listening then
					TweenService:Create(KeyStroke, TweenInfo.new(0.15), {Color = BorderColor}):Play()
				end
			end)

			KeyBtn.MouseButton1Click:Connect(function()
				if listening then return end
				listening = true
				KeyBtn.Text = "..."
				TweenService:Create(KeyStroke, TweenInfo.new(0.15), {Color = PurpleAccent}):Play()

				local conn
				conn = UserInputService.InputBegan:Connect(function(input, gp)
					if gp then return end
					if input.UserInputType == Enum.UserInputType.Keyboard then
						local keyName = input.KeyCode.Name
						if keyName == "Escape" then
							currentKey = "None"
						else
							currentKey = keyName
						end
						KeyBtn.Text = currentKey
						TweenService:Create(KeyStroke, TweenInfo.new(0.15), {Color = BorderColor}):Play()
						listening = false
						conn:Disconnect()
						if callback then callback(currentKey) end
					end
				end)
			end)

			UserInputService.InputBegan:Connect(function(input, gp)
				if gp then return end
				if not listening and input.UserInputType == Enum.UserInputType.Keyboard then
					if input.KeyCode.Name == currentKey then
						if callback then callback(currentKey) end
					end
				end
			end)

			registerSearchable(KFrame, labelText)

			local api = {}
			function api:Set(k)
				currentKey = k
				KeyBtn.Text = k
			end
			function api:Get() return currentKey end
			function api:SetLabel(text) Label.Text = text end
			return api
		end

		function tab:AddColorPicker(labelText, defaultColor, callback)
			defaultColor = defaultColor or Color3.fromRGB(255, 255, 255)
			local currentColor = defaultColor
			local open = false

			local h, s, v = Color3.toHSV(defaultColor)

			local CPFrame = Instance.new("Frame")
			CPFrame.Size = UDim2.new(1, -4, 0, 34)
			CPFrame.BackgroundColor3 = ElementBgHover
			CPFrame.BackgroundTransparency = 1
			CPFrame.BorderSizePixel = 0
			CPFrame.Parent = Page
			CPFrame.ClipsDescendants = false
			Instance.new("UICorner", CPFrame).CornerRadius = UDim.new(0, 4)

			local Label = Instance.new("TextLabel")
			Label.Text = labelText
			Label.Size = UDim2.new(1, -100, 1, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextColorDim
			Label.Font = MonoFont
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = CPFrame

			local Preview = Instance.new("TextButton")
			Preview.Size = UDim2.new(0, 60, 0, 22)
			Preview.Position = UDim2.new(1, -64, 0.5, -11)
			Preview.BackgroundColor3 = currentColor
			Preview.Text = ""
			Preview.Parent = CPFrame
			Instance.new("UICorner", Preview).CornerRadius = UDim.new(0, 4)
			local PrevStroke = Instance.new("UIStroke", Preview)
			PrevStroke.Color = BorderColor
			PrevStroke.Thickness = 1

			local BottomDivider = Instance.new("Frame")
			BottomDivider.Size = UDim2.new(1, 0, 0, 1)
			BottomDivider.Position = UDim2.new(0, 0, 1, -2)
			BottomDivider.BackgroundColor3 = BorderColor
			BottomDivider.BorderSizePixel = 0
			BottomDivider.Parent = CPFrame

			local Picker = Instance.new("Frame")
			Picker.Size = UDim2.new(0, 200, 0, 160)
			Picker.Position = UDim2.new(1, -204, 1, 4)
			Picker.BackgroundColor3 = DarkBg
			Picker.BorderSizePixel = 0
			Picker.Visible = false
			Picker.ZIndex = 20
			Picker.Parent = CPFrame
			Instance.new("UICorner", Picker).CornerRadius = UDim.new(0, 6)
			local PickerStroke = Instance.new("UIStroke", Picker)
			PickerStroke.Color = BorderColor
			PickerStroke.Thickness = 1

			local SV = Instance.new("ImageLabel")
			SV.Size = UDim2.new(1, -12, 0, 100)
			SV.Position = UDim2.new(0, 6, 0, 6)
			SV.Image = "rbxassetid://698549961"
			SV.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
			SV.BorderSizePixel = 0
			SV.ZIndex = 21
			SV.Parent = Picker
			Instance.new("UICorner", SV).CornerRadius = UDim.new(0, 4)

			local SVCursor = Instance.new("Frame")
			SVCursor.Size = UDim2.new(0, 8, 0, 8)
			SVCursor.AnchorPoint = Vector2.new(0.5, 0.5)
			SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
			SVCursor.BackgroundColor3 = Color3.new(1, 1, 1)
			SVCursor.BorderSizePixel = 0
			SVCursor.ZIndex = 22
			SVCursor.Parent = SV
			Instance.new("UICorner", SVCursor).CornerRadius = UDim.new(1, 0)

			local HueBar = Instance.new("ImageLabel")
			HueBar.Size = UDim2.new(1, -12, 0, 12)
			HueBar.Position = UDim2.new(0, 6, 0, 112)
			HueBar.Image = "rbxassetid://698549981"
			HueBar.BorderSizePixel = 0
			HueBar.ZIndex = 21
			HueBar.Parent = Picker
			Instance.new("UICorner", HueBar).CornerRadius = UDim.new(1, 0)

			local HueCursor = Instance.new("Frame")
			HueCursor.Size = UDim2.new(0, 4, 1, 2)
			HueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
			HueCursor.Position = UDim2.new(h, 0, 0.5, 0)
			HueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
			HueCursor.BorderSizePixel = 0
			HueCursor.ZIndex = 22
			HueCursor.Parent = HueBar
			Instance.new("UICorner", HueCursor).CornerRadius = UDim.new(0, 2)

			local HexBox = Instance.new("TextBox")
			HexBox.Size = UDim2.new(1, -12, 0, 22)
			HexBox.Position = UDim2.new(0, 6, 0, 130)
			HexBox.BackgroundColor3 = PanelBg
			HexBox.TextColor3 = TextColor
			HexBox.Font = MonoFont
			HexBox.TextSize = 12
			HexBox.PlaceholderText = "Hex"
			HexBox.PlaceholderColor3 = TextColorDim
			HexBox.Text = "#" .. currentColor:ToHex()
			HexBox.BorderSizePixel = 0
			HexBox.ZIndex = 21
			HexBox.Parent = Picker
			Instance.new("UICorner", HexBox).CornerRadius = UDim.new(0, 4)
			local HexStroke = Instance.new("UIStroke", HexBox)
			HexStroke.Color = BorderColor
			HexStroke.Thickness = 1
			local HexPad = Instance.new("UIPadding", HexBox)
			HexPad.PaddingLeft = UDim.new(0, 6)

			local function updateColor()
				currentColor = Color3.fromHSV(h, s, v)
				Preview.BackgroundColor3 = currentColor
				SV.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
				SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
				HueCursor.Position = UDim2.new(h, 0, 0.5, 0)
				HexBox.Text = "#" .. currentColor:ToHex()
				if callback then callback(currentColor) end
			end

			local svDragging = false
			local hueDragging = false

			local svConn, hueConn

			SV.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					svDragging = true
					local rel = SV.AbsolutePosition
					local sz = SV.AbsoluteSize
					s = math.clamp((input.Position.X - rel.X) / sz.X, 0, 1)
					v = 1 - math.clamp((input.Position.Y - rel.Y) / sz.Y, 0, 1)
					updateColor()
					svConn = UserInputService.InputChanged:Connect(function(inp)
						if svDragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
							local r = SV.AbsolutePosition
							local sz2 = SV.AbsoluteSize
							s = math.clamp((inp.Position.X - r.X) / sz2.X, 0, 1)
							v = 1 - math.clamp((inp.Position.Y - r.Y) / sz2.Y, 0, 1)
							updateColor()
						end
					end)
				end
			end)

			HueBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					hueDragging = true
					local rel = HueBar.AbsolutePosition
					local sz = HueBar.AbsoluteSize
					h = math.clamp((input.Position.X - rel.X) / sz.X, 0, 1)
					updateColor()
					hueConn = UserInputService.InputChanged:Connect(function(inp)
						if hueDragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
							local r = HueBar.AbsolutePosition
							local sz2 = HueBar.AbsoluteSize
							h = math.clamp((inp.Position.X - r.X) / sz2.X, 0, 1)
							updateColor()
						end
					end)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if svDragging then
						svDragging = false
						if svConn then svConn:Disconnect() svConn = nil end
					end
					if hueDragging then
						hueDragging = false
						if hueConn then hueConn:Disconnect() hueConn = nil end
					end
				end
			end)

			HexBox.FocusLost:Connect(function(enter)
				if enter then
					local hex = HexBox.Text:gsub("#", "")
					local ok, col = pcall(Color3.fromHex, hex)
					if ok then
						h, s, v = Color3.toHSV(col)
						updateColor()
					end
				end
			end)

			Preview.MouseButton1Click:Connect(function()
				open = not open
				Picker.Visible = open
				TweenService:Create(PrevStroke, TweenInfo.new(0.15), {Color = open and PurpleAccent or BorderColor}):Play()
				TweenService:Create(CPFrame, TweenInfo.new(0.15), {BackgroundTransparency = open and 0.92 or 1}):Play()
			end)

			Preview.MouseEnter:Connect(function()
				TweenService:Create(CPFrame, TweenInfo.new(0.15), {BackgroundTransparency = 0.95}):Play()
				TweenService:Create(PrevStroke, TweenInfo.new(0.15), {Color = PurpleAccent}):Play()
			end)
			Preview.MouseLeave:Connect(function()
				if not open then
					TweenService:Create(CPFrame, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
					TweenService:Create(PrevStroke, TweenInfo.new(0.15), {Color = BorderColor}):Play()
				end
			end)

			registerSearchable(CPFrame, labelText)

			local api = {}
			function api:Set(col, silent)
				h, s, v = Color3.toHSV(col)
				currentColor = col
				Preview.BackgroundColor3 = col
				SV.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
				SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
				HueCursor.Position = UDim2.new(h, 0, 0.5, 0)
				HexBox.Text = "#" .. col:ToHex()
				if not silent and callback then callback(col) end
			end
			function api:Get() return currentColor end
			function api:SetLabel(text) Label.Text = text end
			return api
		end

		local tabApi = {}
		function tabApi:Select()
			TabBtn.MouseButton1Click:Fire()
		end
		function tabApi:GetName() return name end
		function tabApi:SetName(newName)
			local base = icon and ("        " .. newName) or ("  " .. newName)
			TabBtn.Text = base
		end

		setmetatable(tabApi, {__index = tab})

		return tabApi
	end

	local ResizeHandle = Instance.new("TextButton")
	ResizeHandle.Text = ""
	ResizeHandle.Size = UDim2.new(0, 16, 0, 16)
	ResizeHandle.Position = UDim2.new(1, -16, 1, -16)
	ResizeHandle.BackgroundTransparency = 1
	ResizeHandle.AutoButtonColor = false
	ResizeHandle.Parent = MainFrame

	local ResizeIcon = Instance.new("Frame")
	ResizeIcon.Size = UDim2.new(0, 8, 0, 8)
	ResizeIcon.Position = UDim2.new(1, -10, 1, -10)
	ResizeIcon.BackgroundTransparency = 1
	ResizeIcon.Parent = ResizeHandle

	for i = 1, 3 do
		local Dot = Instance.new("Frame")
		Dot.Size = UDim2.new(0, 2, 0, 2)
		Dot.Position = UDim2.new(1, -2 - (i - 1) * 4, 1, -2)
		Dot.BackgroundColor3 = BorderColor
		Dot.BorderSizePixel = 0
		Dot.Parent = ResizeIcon
		for j = 1, i do
			if j > 1 then
				local ExtraDot = Instance.new("Frame")
				ExtraDot.Size = UDim2.new(0, 2, 0, 2)
				ExtraDot.Position = UDim2.new(1, -2 - (i - 1) * 4, 1, -2 - (j - 1) * 4)
				ExtraDot.BackgroundColor3 = BorderColor
				ExtraDot.BorderSizePixel = 0
				ExtraDot.Parent = ResizeIcon
			end
		end
	end

	local MinW, MinH = 400, 280
	local resizing, resizeStart, sizeStart = false, nil, nil

	ResizeHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = true
			resizeStart = input.Position
			sizeStart = MainFrame.Size
		end
	end)

	local resizeConn
	ResizeHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = true
			resizeStart = input.Position
			sizeStart = MainFrame.Size
			resizeConn = UserInputService.InputChanged:Connect(function(inp)
				if not resizing then return end
				if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
					local delta = inp.Position - resizeStart
					local newW = math.max(MinW, sizeStart.X.Offset + delta.X)
					local newH = math.max(MinH, sizeStart.Y.Offset + delta.Y)
					MainFrame.Size = UDim2.new(0, newW, 0, newH)
					self._W = newW
					self._H = newH
				end
			end)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if resizing then
				resizing = false
				if resizeConn then
					resizeConn:Disconnect()
					resizeConn = nil
				end
			end
		end
	end)

	local winApi = {}
	function winApi:Close()
		_G.__HUB_INSTANCES[hubID] = nil
		local fadeTween = TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, self._W, 0, 0), Position = UDim2.new(0.5, -self._W/2, 0.5, 0)})
		TweenService:Create(ShadowImage, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
		fadeTween:Play()
		fadeTween.Completed:Wait()
		ScreenGui:Destroy()
	end
	function winApi:Minimize()
		TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, self._W, 0, 0), Position = UDim2.new(0.5, -self._W/2, 0.5, 0)}):Play()
		task.wait(0.2)
		MainFrame.Visible = false
		MainFrame.Size = UDim2.new(0, self._W, 0, self._H)
		MainFrame.Position = UDim2.new(0.5, -self._W/2, 0.5, -self._H/2)
		OpenButton.Visible = true
	end
	function winApi:Restore()
		OpenButton.Visible = false
		MainFrame.Visible = true
		MainFrame.Size = UDim2.new(0, self._W, 0, 0)
		MainFrame.Position = UDim2.new(0.5, -self._W/2, 0.5, 0)
		TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, self._W, 0, self._H), Position = UDim2.new(0.5, -self._W/2, 0.5, -self._H/2)}):Play()
	end
	function winApi:SetTitle(text) TitleLabel.Text = text end
	function winApi:GetTitle() return TitleLabel.Text end
	function winApi:IsVisible() return MainFrame.Visible end
	function winApi:Notify(title, text, duration) Hub:Notify(title, text, duration) end

	setmetatable(winApi, {__index = self})

	return winApi
end

return Hub
