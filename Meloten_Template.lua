if _G.__HUB_ALREADY_RUNNING then
	pcall(function() _G.__HUB_GUI:Destroy() end)
end
_G.__HUB_ALREADY_RUNNING = true

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
_G.__HUB_GUI = ScreenGui

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
	local self = setmetatable({}, Hub)
	self._currentTab = nil
	self._currentPage = nil

	local W = config.Size and config.Size.X or 560
	local H = config.Size and config.Size.Y or 400

	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, W, 0, H)
	MainFrame.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
	MainFrame.BackgroundColor3 = DarkBg
	MainFrame.BorderSizePixel = 0
	MainFrame.Visible = true
	MainFrame.Parent = ScreenGui

	local UIStroke = Instance.new("UIStroke", MainFrame)
	UIStroke.Color = BorderColor
	UIStroke.Thickness = 1

	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 36)
	TopBar.BackgroundColor3 = PanelBg
	TopBar.BorderSizePixel = 0
	TopBar.Parent = MainFrame

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Text = config.Title or "Meloten Hub"
	TitleLabel.Size = UDim2.new(1, -80, 1, 0)
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
	CloseBtn.Text = "x"
	CloseBtn.Size = UDim2.new(0, 28, 0, 28)
	CloseBtn.Position = UDim2.new(1, -32, 0.5, -14)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.TextColor3 = TextColorDim
	CloseBtn.Font = MonoFontBold
	CloseBtn.TextSize = 15
	CloseBtn.Parent = TopBar

	CloseBtn.MouseEnter:Connect(function()
		TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = TextColor}):Play()
	end)
	CloseBtn.MouseLeave:Connect(function()
		TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = TextColorDim}):Play()
	end)

	local Divider = Instance.new("Frame")
	Divider.Size = UDim2.new(1, 0, 0, 1)
	Divider.Position = UDim2.new(0, 0, 0, 36)
	Divider.BackgroundColor3 = BorderColor
	Divider.BorderSizePixel = 0
	Divider.Parent = MainFrame

	local SidebarW = 140

	local TabContainer = Instance.new("Frame")
	TabContainer.Size = UDim2.new(0, SidebarW, 1, -37)
	TabContainer.Position = UDim2.new(0, 0, 0, 37)
	TabContainer.BackgroundColor3 = PanelBg
	TabContainer.BorderSizePixel = 0
	TabContainer.Parent = MainFrame

	local TabListLayout = Instance.new("UIListLayout", TabContainer)
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local TabPadding = Instance.new("UIPadding", TabContainer)
	TabPadding.PaddingTop = UDim.new(0, 8)
	TabPadding.PaddingLeft = UDim.new(0, 10)

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

	makeDraggable(TopBar, MainFrame)
	makeDraggable(OpenButton, OpenButton)

	CloseBtn.MouseButton1Click:Connect(function()
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

	function self:AddTab(name)
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
		TabBtn.Text = "  " .. name
		TabBtn.Size = UDim2.new(1, -10, 0, 32)
		TabBtn.BackgroundColor3 = PurpleAccent
		TabBtn.BackgroundTransparency = 1
		TabBtn.TextColor3 = TextColorDim
		TabBtn.Font = MonoFont
		TabBtn.TextSize = 14
		TabBtn.TextXAlignment = Enum.TextXAlignment.Left
		TabBtn.Parent = TabContainer

		local win = self
		TabBtn.MouseButton1Click:Connect(function()
			if win._currentTab then
				TweenService:Create(win._currentTab, TweenInfo.new(0.15), {BackgroundTransparency = 1, TextColor3 = TextColorDim}):Play()
			end
			if win._currentPage then win._currentPage.Visible = false end
			win._currentTab = TabBtn
			win._currentPage = Page
			Page.Visible = true
			TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.85, TextColor3 = TextColor}):Play()
		end)

		if not self._currentTab then
			self._currentTab = TabBtn
			self._currentPage = Page
			Page.Visible = true
			TabBtn.BackgroundTransparency = 0.85
			TabBtn.TextColor3 = TextColor
		end

		local tab = {}

		function tab:AddToggle(labelText, callback)
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

			local function setState(on)
				state = on
				local swColor = on and PurpleAccent or Color3.fromRGB(35, 35, 40)
				local circPos = on and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
				local circColor = on and TextColor or Color3.fromRGB(130, 130, 140)
				local labelColor = on and TextColor or TextColorDim

				TweenService:Create(Sw, TweenInfo.new(0.15), {BackgroundColor3 = swColor}):Play()
				TweenService:Create(Circ, TweenInfo.new(0.15), {Position = circPos, BackgroundColor3 = circColor}):Play()
				TweenService:Create(Label, TweenInfo.new(0.15), {TextColor3 = labelColor}):Play()
			end

			SwBtn.MouseButton1Click:Connect(function()
				setState(not state)
				callback(state)
			end)
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

			local BottomDivider = Instance.new("Frame")
			BottomDivider.Size = UDim2.new(1, 0, 0, 1)
			BottomDivider.Position = UDim2.new(0, 0, 1, -2)
			BottomDivider.BackgroundColor3 = BorderColor
			BottomDivider.BorderSizePixel = 0
			BottomDivider.Parent = Frame

			Btn.MouseButton1Click:Connect(function()
				TweenService:Create(BtnStroke, TweenInfo.new(0.1), {Color = PurpleAccent}):Play()
				task.wait(0.1)
				TweenService:Create(BtnStroke, TweenInfo.new(0.1), {Color = BorderColor}):Play()
				callback()
			end)
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

			local HitArea = Instance.new("TextButton")
			HitArea.Size = UDim2.new(1, 0, 0, 22)
			HitArea.Position = UDim2.new(0, 0, 0, 22)
			HitArea.BackgroundTransparency = 1
			HitArea.Text = ""
			HitArea.Parent = SliderFrame

			local function updateSlider(inputX)
				local rel = math.clamp((inputX - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
				local value = math.floor(minVal + (maxVal - minVal) * rel)
				Fill.Size = UDim2.new(rel, 0, 1, 0)
				Knob.Position = UDim2.new(rel, 0, 0.5, 0)
				ValueLabel.Text = tostring(value)
				callback(value)
			end

			HitArea.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					updateSlider(input.Position.X)
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if not dragging then return end
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					updateSlider(input.Position.X)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)
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

			local BottomDivider = Instance.new("Frame")
			BottomDivider.Size = UDim2.new(1, 0, 0, 1)
			BottomDivider.Position = UDim2.new(0, 0, 1, -2)
			BottomDivider.BackgroundColor3 = BorderColor
			BottomDivider.BorderSizePixel = 0
			BottomDivider.Parent = InputFrame

			TextBox.Focused:Connect(function()
				TweenService:Create(TextStroke, TweenInfo.new(0.15), {Color = PurpleAccent}):Play()
			end)
			TextBox.FocusLost:Connect(function()
				TweenService:Create(TextStroke, TweenInfo.new(0.15), {Color = BorderColor}):Play()
				callback(TextBox.Text)
			end)
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
		end

		function tab:AddMultiToggle(labelText, options, callback)
			local selected = {}

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

				SwBtn.MouseButton1Click:Connect(function()
					optState = not optState
					selected[optName] = optState

					local swColor = optState and PurpleAccent or Color3.fromRGB(35, 35, 40)
					local circPos = optState and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
					local circColor = optState and TextColor or Color3.fromRGB(130, 130, 140)
					local labelColor = optState and TextColor or TextColorDim

					TweenService:Create(Sw, TweenInfo.new(0.15), {BackgroundColor3 = swColor}):Play()
					TweenService:Create(Circ, TweenInfo.new(0.15), {Position = circPos, BackgroundColor3 = circColor}):Play()
					TweenService:Create(OptLabel, TweenInfo.new(0.15), {TextColor3 = labelColor}):Play()

					callback(selected)
				end)
			end
		end

		return tab
	end

	return self
end

return Hub
