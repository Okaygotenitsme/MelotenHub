if _G.__HUB_ALREADY_RUNNING then
    pcall(function() _G.__HUB_GUI:Destroy() end)
end
_G.__HUB_ALREADY_RUNNING = true

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local DarkBg = Color3.fromRGB(18, 18, 24)
local ElementBg = Color3.fromRGB(30, 30, 40)
local ElementBgHover = Color3.fromRGB(38, 38, 52)
local PurpleAccent = Color3.fromRGB(150, 80, 255)
local PurpleAccentDark = Color3.fromRGB(100, 50, 180)
local TextColor = Color3.fromRGB(255, 255, 255)
local TextColorDim = Color3.fromRGB(180, 180, 195)
local BorderColor = Color3.fromRGB(60, 55, 80)

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
		if not writefile or not makefolder or not getcustomasset or not isfolder then
			return "rbxassetid://0"
		end
		if not isfolder("MelotenCache") then makefolder("MelotenCache") end
		local fileName = "MelotenCache/img_" .. url:gsub("[^%w]", ""):sub(-24) .. ".png"
		if isfile(fileName) then
			return getcustomasset(fileName)
		end
		local ok, data = pcall(function() return game:HttpGet(url) end)
		if ok then
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
	Frame.BackgroundColor3 = DarkBg
	Frame.BorderSizePixel = 0
	Frame.ClipsDescendants = true
	Frame.Parent = NotificationContainer

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = Frame

	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = PurpleAccent
	UIStroke.Thickness = 1.5
	UIStroke.Parent = Frame

	local Accent = Instance.new("Frame")
	Accent.Size = UDim2.new(0, 3, 1, 0)
	Accent.Position = UDim2.new(0, 0, 0, 0)
	Accent.BackgroundColor3 = PurpleAccent
	Accent.BorderSizePixel = 0
	Accent.Parent = Frame
	local AccentCorner = Instance.new("UICorner")
	AccentCorner.CornerRadius = UDim.new(0, 10)
	AccentCorner.Parent = Accent

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Text = title
	TitleLabel.Size = UDim2.new(1, -20, 0, 20)
	TitleLabel.Position = UDim2.new(0, 14, 0, 6)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.TextColor3 = PurpleAccent
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 13
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = Frame

	local DescLabel = Instance.new("TextLabel")
	DescLabel.Text = text
	DescLabel.Size = UDim2.new(1, -20, 0, 30)
	DescLabel.Position = UDim2.new(0, 14, 0, 26)
	DescLabel.BackgroundTransparency = 1
	DescLabel.TextColor3 = TextColorDim
	DescLabel.Font = Enum.Font.Gotham
	DescLabel.TextSize = 12
	DescLabel.TextXAlignment = Enum.TextXAlignment.Left
	DescLabel.TextWrapped = true
	DescLabel.Parent = Frame

	TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 62)}):Play()

	task.spawn(function()
		task.wait(duration)
		local tween = TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
		tween:Play()
		TweenService:Create(TitleLabel, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
		TweenService:Create(DescLabel, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
		TweenService:Create(UIStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
		TweenService:Create(Accent, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
		tween.Completed:Wait()
		Frame:Destroy()
	end)
end

local function makeDraggable(frame)
	local dragging, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)
	frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

function Hub:CreateWindow(config)
	local self = setmetatable({}, Hub)
	self._currentTab = nil
	self._currentPage = nil

	local W = config.Size and config.Size.X or 530
	local H = config.Size and config.Size.Y or 380

	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, W, 0, H)
	MainFrame.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
	MainFrame.BackgroundColor3 = DarkBg
	MainFrame.BorderSizePixel = 0
	MainFrame.Visible = true
	MainFrame.Parent = ScreenGui
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 12)
	UICorner.Parent = MainFrame
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = BorderColor
	UIStroke.Thickness = 1.5
	UIStroke.Parent = MainFrame

	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 38)
	TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
	TopBar.BorderSizePixel = 0
	TopBar.Parent = MainFrame
	local TopBarCorner = Instance.new("UICorner")
	TopBarCorner.CornerRadius = UDim.new(0, 12)
	TopBarCorner.Parent = TopBar
	local TopBarFix = Instance.new("Frame")
	TopBarFix.Size = UDim2.new(1, 0, 0, 12)
	TopBarFix.Position = UDim2.new(0, 0, 1, -12)
	TopBarFix.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
	TopBarFix.BorderSizePixel = 0
	TopBarFix.Parent = TopBar

	local LogoFrame = Instance.new("Frame")
	LogoFrame.Size = UDim2.new(0, 24, 0, 24)
	LogoFrame.Position = UDim2.new(0, 10, 0.5, -12)
	LogoFrame.BackgroundColor3 = PurpleAccent
	LogoFrame.Parent = TopBar
	local LogoCorner = Instance.new("UICorner")
	LogoCorner.CornerRadius = UDim.new(0, 6)
	LogoCorner.Parent = LogoFrame
	local LogoGrad = Instance.new("UIGradient")
	LogoGrad.Color = ColorSequence.new(PurpleAccent, PurpleAccentDark)
	LogoGrad.Rotation = 45
	LogoGrad.Parent = LogoFrame

	if config.Icon then
		local LogoImg = Instance.new("ImageLabel")
		LogoImg.Size = UDim2.new(1, 0, 1, 0)
		LogoImg.BackgroundTransparency = 1
		LogoImg.Image = loadImageFromUrl(config.Icon)
		LogoImg.Parent = LogoFrame
	end

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Text = config.Title or "Meloten Hub"
	TitleLabel.Size = UDim2.new(1, -80, 1, 0)
	TitleLabel.Position = UDim2.new(0, 42, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.TextColor3 = TextColor
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 14
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = TopBar

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Text = "✕"
	CloseBtn.Size = UDim2.new(0, 28, 0, 28)
	CloseBtn.Position = UDim2.new(1, -34, 0.5, -14)
	CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 35, 80)
	CloseBtn.TextColor3 = Color3.fromRGB(220, 180, 255)
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 14
	CloseBtn.Parent = TopBar
	local CloseBtnCorner = Instance.new("UICorner")
	CloseBtnCorner.CornerRadius = UDim.new(0, 8)
	CloseBtnCorner.Parent = CloseBtn

	local Divider = Instance.new("Frame")
	Divider.Size = UDim2.new(1, -20, 0, 1)
	Divider.Position = UDim2.new(0, 10, 0, 38)
	Divider.BackgroundColor3 = BorderColor
	Divider.BorderSizePixel = 0
	Divider.Parent = MainFrame

	local TabContainer = Instance.new("Frame")
	TabContainer.Size = UDim2.new(1, -20, 0, 32)
	TabContainer.Position = UDim2.new(0, 10, 0, 44)
	TabContainer.BackgroundTransparency = 1
	TabContainer.Parent = MainFrame
	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.FillDirection = Enum.FillDirection.Horizontal
	TabListLayout.Padding = UDim.new(0, 6)
	TabListLayout.Parent = TabContainer

	local Divider2 = Instance.new("Frame")
	Divider2.Size = UDim2.new(1, -20, 0, 1)
	Divider2.Position = UDim2.new(0, 10, 0, 80)
	Divider2.BackgroundColor3 = BorderColor
	Divider2.BorderSizePixel = 0
	Divider2.Parent = MainFrame

	local PagesFolder = Instance.new("Folder")
	PagesFolder.Name = "Pages"
	PagesFolder.Parent = MainFrame

	if config.BackgroundImage then
		local BgImage = Instance.new("ImageLabel")
		BgImage.Size = UDim2.new(1, 0, 1, 0)
		BgImage.Position = UDim2.new(0, 0, 0, 0)
		BgImage.BackgroundTransparency = 1
		BgImage.Image = loadImageFromUrl(config.BackgroundImage)
		BgImage.ImageTransparency = config.BackgroundTransparency or 0.7
		BgImage.ScaleType = Enum.ScaleType.Crop
		BgImage.ZIndex = 0
		BgImage.Parent = MainFrame
		MainFrame.ZIndex = 1
	end

	OpenButton.Name = "OpenButton"
	OpenButton.Size = UDim2.new(0, 48, 0, 48)
	OpenButton.Position = UDim2.new(0, 20, 0.5, 0)
	OpenButton.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
	OpenButton.Visible = false
	OpenButton.Parent = ScreenGui
	if config.Icon then
		OpenButton.Image = loadImageFromUrl(config.Icon)
	end
	local OpenCorner = Instance.new("UICorner")
	OpenCorner.CornerRadius = UDim.new(0, 12)
	OpenCorner.Parent = OpenButton
	local OpenStroke = Instance.new("UIStroke")
	OpenStroke.Color = BorderColor
	OpenStroke.Thickness = 1.5
	OpenStroke.Parent = OpenButton

	makeDraggable(TopBar)
	makeDraggable(OpenButton)

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
		TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Size = UDim2.new(0, W, 0, H), Position = UDim2.new(0.5, -W/2, 0.5, -H/2)}):Play()
	end)

	self._tabContainer = TabContainer
	self._pagesFolder = PagesFolder
	self._W = W
	self._H = H

	function self:AddTab(name)
		local Page = Instance.new("ScrollingFrame")
		Page.Name = name
		Page.Size = UDim2.new(1, -20, 1, -92)
		Page.Position = UDim2.new(0, 10, 0, 88)
		Page.BackgroundTransparency = 1
		Page.ScrollBarThickness = 3
		Page.ScrollBarImageColor3 = PurpleAccent
		Page.Visible = false
		Page.CanvasSize = UDim2.new(0, 0, 0, 0)
		Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Page.Parent = PagesFolder
		local Layout = Instance.new("UIListLayout")
		Layout.Padding = UDim.new(0, 5)
		Layout.SortOrder = Enum.SortOrder.LayoutOrder
		Layout.Parent = Page
		local Padding = Instance.new("UIPadding")
		Padding.PaddingTop = UDim.new(0, 5)
		Padding.PaddingBottom = UDim.new(0, 8)
		Padding.Parent = Page

		local TabBtn = Instance.new("TextButton")
		TabBtn.Text = name
		TabBtn.Size = UDim2.new(0, 80, 1, 0)
		TabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
		TabBtn.TextColor3 = TextColorDim
		TabBtn.Font = Enum.Font.GothamBold
		TabBtn.TextSize = 12
		TabBtn.Parent = TabContainer
		local TCorner = Instance.new("UICorner")
		TCorner.CornerRadius = UDim.new(0, 8)
		TCorner.Parent = TabBtn
		local TStroke = Instance.new("UIStroke")
		TStroke.Color = BorderColor
		TStroke.Thickness = 1
		TStroke.Parent = TabBtn

		local win = self
		TabBtn.MouseButton1Click:Connect(function()
			if win._currentTab then
				TweenService:Create(win._currentTab, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 38), TextColor3 = TextColorDim}):Play()
				win._currentTab:FindFirstChildOfClass("UIStroke").Color = BorderColor
			end
			if win._currentPage then win._currentPage.Visible = false end
			win._currentTab = TabBtn
			win._currentPage = Page
			Page.Visible = true
			TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = PurpleAccent, TextColor3 = TextColor}):Play()
			TStroke.Color = PurpleAccent
		end)

		if not self._currentTab then
			self._currentTab = TabBtn
			self._currentPage = Page
			Page.Visible = true
			TabBtn.BackgroundColor3 = PurpleAccent
			TabBtn.TextColor3 = TextColor
			TStroke.Color = PurpleAccent
		end

		local tab = {}

		function tab:AddToggle(labelText, callback)
			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Size = UDim2.new(1, -4, 0, 38)
			ToggleFrame.BackgroundColor3 = ElementBg
			ToggleFrame.Parent = Page
			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 8)
			Corner.Parent = ToggleFrame
			local Stroke = Instance.new("UIStroke")
			Stroke.Color = BorderColor
			Stroke.Thickness = 1
			Stroke.Parent = ToggleFrame
			local Label = Instance.new("TextLabel")
			Label.Text = labelText
			Label.Size = UDim2.new(1, -60, 1, 0)
			Label.Position = UDim2.new(0, 12, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextColorDim
			Label.Font = Enum.Font.Gotham
			Label.TextSize = 13
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = ToggleFrame
			local Sw = Instance.new("Frame")
			Sw.Size = UDim2.new(0, 40, 0, 20)
			Sw.Position = UDim2.new(1, -50, 0.5, -10)
			Sw.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
			Sw.Parent = ToggleFrame
			local SwCorner = Instance.new("UICorner")
			SwCorner.CornerRadius = UDim.new(1, 0)
			SwCorner.Parent = Sw
			local Circ = Instance.new("Frame")
			Circ.Size = UDim2.new(0, 16, 0, 16)
			Circ.Position = UDim2.new(0, 2, 0.5, -8)
			Circ.BackgroundColor3 = Color3.fromRGB(140, 140, 160)
			Circ.Parent = Sw
			local CircCorner = Instance.new("UICorner")
			CircCorner.CornerRadius = UDim.new(1, 0)
			CircCorner.Parent = Circ
			local SwBtn = Instance.new("TextButton")
			SwBtn.Size = UDim2.new(1, 0, 1, 0)
			SwBtn.BackgroundTransparency = 1
			SwBtn.Text = ""
			SwBtn.Parent = Sw
			local state = false
			SwBtn.MouseButton1Click:Connect(function()
				state = not state
				if state then
					TweenService:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = PurpleAccent}):Play()
					TweenService:Create(Circ, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = TextColor}):Play()
					TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = TextColor}):Play()
					Stroke.Color = PurpleAccent
				else
					TweenService:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
					TweenService:Create(Circ, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(140, 140, 160)}):Play()
					TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = TextColorDim}):Play()
					Stroke.Color = BorderColor
				end
				callback(state)
			end)
		end

		function tab:AddButton(labelText, buttonText, callback)
			local Frame = Instance.new("Frame")
			Frame.Size = UDim2.new(1, -4, 0, 38)
			Frame.BackgroundColor3 = ElementBg
			Frame.Parent = Page
			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 8)
			Corner.Parent = Frame
			local Stroke = Instance.new("UIStroke")
			Stroke.Color = BorderColor
			Stroke.Thickness = 1
			Stroke.Parent = Frame
			local Label = Instance.new("TextLabel")
			Label.Text = labelText
			Label.Size = UDim2.new(1, -100, 1, 0)
			Label.Position = UDim2.new(0, 12, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextColorDim
			Label.Font = Enum.Font.Gotham
			Label.TextSize = 13
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = Frame
			local Btn = Instance.new("TextButton")
			Btn.Text = buttonText or "Run"
			Btn.Size = UDim2.new(0, 76, 0, 26)
			Btn.Position = UDim2.new(1, -86, 0.5, -13)
			Btn.BackgroundColor3 = PurpleAccent
			Btn.TextColor3 = TextColor
			Btn.Font = Enum.Font.GothamBold
			Btn.TextSize = 12
			Btn.Parent = Frame
			local BtnCorner = Instance.new("UICorner")
			BtnCorner.CornerRadius = UDim.new(0, 7)
			BtnCorner.Parent = Btn
			local BtnGrad = Instance.new("UIGradient")
			BtnGrad.Color = ColorSequence.new(PurpleAccent, PurpleAccentDark)
			BtnGrad.Rotation = 90
			BtnGrad.Parent = Btn
			Btn.MouseButton1Click:Connect(function()
				TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.3}):Play()
				task.wait(0.1)
				TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
				callback()
			end)
		end

		function tab:AddSlider(labelText, minVal, maxVal, defaultVal, callback)
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Size = UDim2.new(1, -4, 0, 52)
			SliderFrame.BackgroundColor3 = ElementBg
			SliderFrame.Parent = Page
			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 8)
			Corner.Parent = SliderFrame
			local Stroke = Instance.new("UIStroke")
			Stroke.Color = BorderColor
			Stroke.Thickness = 1
			Stroke.Parent = SliderFrame
			local Label = Instance.new("TextLabel")
			Label.Text = labelText
			Label.Size = UDim2.new(1, -70, 0, 26)
			Label.Position = UDim2.new(0, 12, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextColorDim
			Label.Font = Enum.Font.Gotham
			Label.TextSize = 13
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = SliderFrame
			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Text = tostring(defaultVal)
			ValueLabel.Size = UDim2.new(0, 60, 0, 26)
			ValueLabel.Position = UDim2.new(1, -68, 0, 0)
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.TextColor3 = PurpleAccent
			ValueLabel.Font = Enum.Font.GothamBold
			ValueLabel.TextSize = 13
			ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
			ValueLabel.Parent = SliderFrame

			local Track = Instance.new("Frame")
			Track.Size = UDim2.new(1, -24, 0, 6)
			Track.Position = UDim2.new(0, 12, 0, 34)
			Track.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
			Track.BorderSizePixel = 0
			Track.Parent = SliderFrame
			local TrackCorner = Instance.new("UICorner")
			TrackCorner.CornerRadius = UDim.new(1, 0)
			TrackCorner.Parent = Track

			local Fill = Instance.new("Frame")
			Fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
			Fill.BackgroundColor3 = PurpleAccent
			Fill.BorderSizePixel = 0
			Fill.Parent = Track
			local FillCorner = Instance.new("UICorner")
			FillCorner.CornerRadius = UDim.new(1, 0)
			FillCorner.Parent = Fill
			local FillGrad = Instance.new("UIGradient")
			FillGrad.Color = ColorSequence.new(PurpleAccent, PurpleAccentDark)
			FillGrad.Rotation = 0
			FillGrad.Parent = Fill

			local Knob = Instance.new("Frame")
			Knob.Size = UDim2.new(0, 14, 0, 14)
			Knob.AnchorPoint = Vector2.new(0.5, 0.5)
			local initRatio = (defaultVal - minVal) / (maxVal - minVal)
			Knob.Position = UDim2.new(initRatio, 0, 0.5, 0)
			Knob.BackgroundColor3 = TextColor
			Knob.Parent = Track
			local KnobCorner = Instance.new("UICorner")
			KnobCorner.CornerRadius = UDim.new(1, 0)
			KnobCorner.Parent = Knob

			local dragging = false

			local HitArea = Instance.new("TextButton")
			HitArea.Size = UDim2.new(1, 0, 0, 22)
			HitArea.Position = UDim2.new(0, 0, 0.5, -11)
			HitArea.BackgroundTransparency = 1
			HitArea.Text = ""
			HitArea.Parent = Track

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
			InputFrame.Size = UDim2.new(1, -4, 0, 40)
			InputFrame.BackgroundColor3 = ElementBg
			InputFrame.Parent = Page
			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 8)
			Corner.Parent = InputFrame
			local Stroke = Instance.new("UIStroke")
			Stroke.Color = BorderColor
			Stroke.Thickness = 1
			Stroke.Parent = InputFrame
			local Label = Instance.new("TextLabel")
			Label.Text = labelText
			Label.Size = UDim2.new(0, 170, 1, 0)
			Label.Position = UDim2.new(0, 12, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextColorDim
			Label.Font = Enum.Font.Gotham
			Label.TextSize = 13
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = InputFrame
			local TextBox = Instance.new("TextBox")
			TextBox.PlaceholderText = placeholderText or ""
			TextBox.Text = ""
			TextBox.Size = UDim2.new(0, 110, 0, 26)
			TextBox.Position = UDim2.new(1, -118, 0.5, -13)
			TextBox.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
			TextBox.TextColor3 = TextColor
			TextBox.Font = Enum.Font.Gotham
			TextBox.TextSize = 13
			TextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
			TextBox.Parent = InputFrame
			local TextCorner = Instance.new("UICorner")
			TextCorner.CornerRadius = UDim.new(0, 6)
			TextCorner.Parent = TextBox
			local TextStroke = Instance.new("UIStroke")
			TextStroke.Color = BorderColor
			TextStroke.Thickness = 1
			TextStroke.Parent = TextBox
			TextBox.Focused:Connect(function()
				TweenService:Create(TextStroke, TweenInfo.new(0.2), {Color = PurpleAccent}):Play()
			end)
			TextBox.FocusLost:Connect(function()
				TweenService:Create(TextStroke, TweenInfo.new(0.2), {Color = BorderColor}):Play()
				callback(TextBox.Text)
			end)
		end

		function tab:AddLabel(text, color)
			local LabelFrame = Instance.new("Frame")
			LabelFrame.Size = UDim2.new(1, -4, 0, 28)
			LabelFrame.BackgroundTransparency = 1
			LabelFrame.Parent = Page
			local Label = Instance.new("TextLabel")
			Label.Text = text
			Label.Size = UDim2.new(1, 0, 1, 0)
			Label.Position = UDim2.new(0, 12, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = color or PurpleAccent
			Label.Font = Enum.Font.GothamBold
			Label.TextSize = 12
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = LabelFrame
		end

		function tab:AddSection(text)
			local SectionFrame = Instance.new("Frame")
			SectionFrame.Size = UDim2.new(1, -4, 0, 26)
			SectionFrame.BackgroundColor3 = Color3.fromRGB(25, 22, 35)
			SectionFrame.Parent = Page
			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 7)
			Corner.Parent = SectionFrame
			local Accent = Instance.new("Frame")
			Accent.Size = UDim2.new(0, 3, 0, 14)
			Accent.Position = UDim2.new(0, 8, 0.5, -7)
			Accent.BackgroundColor3 = PurpleAccent
			Accent.BorderSizePixel = 0
			Accent.Parent = SectionFrame
			local AccentCorner = Instance.new("UICorner")
			AccentCorner.CornerRadius = UDim.new(1, 0)
			AccentCorner.Parent = Accent
			local Label = Instance.new("TextLabel")
			Label.Text = text
			Label.Size = UDim2.new(1, -20, 1, 0)
			Label.Position = UDim2.new(0, 18, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = PurpleAccent
			Label.Font = Enum.Font.GothamBold
			Label.TextSize = 11
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = SectionFrame
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
			HeaderLabel.Position = UDim2.new(0, 12, 0, 0)
			HeaderLabel.BackgroundTransparency = 1
			HeaderLabel.TextColor3 = TextColorDim
			HeaderLabel.Font = Enum.Font.GothamBold
			HeaderLabel.TextSize = 12
			HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
			HeaderLabel.Parent = HeaderFrame
			for _, option in ipairs(options) do
				local OptFrame = Instance.new("Frame")
				OptFrame.Size = UDim2.new(1, -4, 0, 30)
				OptFrame.BackgroundColor3 = ElementBg
				OptFrame.Parent = Page
				local OptCorner = Instance.new("UICorner")
				OptCorner.CornerRadius = UDim.new(0, 8)
				OptCorner.Parent = OptFrame
				local OptStroke = Instance.new("UIStroke")
				OptStroke.Color = BorderColor
				OptStroke.Thickness = 1
				OptStroke.Parent = OptFrame
				local OptLabel = Instance.new("TextLabel")
				OptLabel.Text = option
				OptLabel.Size = UDim2.new(1, -60, 1, 0)
				OptLabel.Position = UDim2.new(0, 12, 0, 0)
				OptLabel.BackgroundTransparency = 1
				OptLabel.TextColor3 = TextColorDim
				OptLabel.Font = Enum.Font.Gotham
				OptLabel.TextSize = 12
				OptLabel.TextXAlignment = Enum.TextXAlignment.Left
				OptLabel.Parent = OptFrame
				local Sw = Instance.new("Frame")
				Sw.Size = UDim2.new(0, 36, 0, 18)
				Sw.Position = UDim2.new(1, -46, 0.5, -9)
				Sw.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
				Sw.Parent = OptFrame
				local SwCorner = Instance.new("UICorner")
				SwCorner.CornerRadius = UDim.new(1, 0)
				SwCorner.Parent = Sw
				local Circ = Instance.new("Frame")
				Circ.Size = UDim2.new(0, 14, 0, 14)
				Circ.Position = UDim2.new(0, 2, 0.5, -7)
				Circ.BackgroundColor3 = Color3.fromRGB(140, 140, 160)
				Circ.Parent = Sw
				local CircCorner = Instance.new("UICorner")
				CircCorner.CornerRadius = UDim.new(1, 0)
				CircCorner.Parent = Circ
				local SwBtn = Instance.new("TextButton")
				SwBtn.Size = UDim2.new(1, 0, 1, 0)
				SwBtn.BackgroundTransparency = 1
				SwBtn.Text = ""
				SwBtn.Parent = Sw
				local optState = false
				local optName = option
				SwBtn.MouseButton1Click:Connect(function()
					optState = not optState
					selected[optName] = optState
					if optState then
						TweenService:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = PurpleAccent}):Play()
						TweenService:Create(Circ, TweenInfo.new(0.2), {Position = UDim2.new(1, -16, 0.5, -7), BackgroundColor3 = TextColor}):Play()
						TweenService:Create(OptLabel, TweenInfo.new(0.2), {TextColor3 = TextColor}):Play()
						OptStroke.Color = PurpleAccent
					else
						TweenService:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
						TweenService:Create(Circ, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Color3.fromRGB(140, 140, 160)}):Play()
						TweenService:Create(OptLabel, TweenInfo.new(0.2), {TextColor3 = TextColorDim}):Play()
						OptStroke.Color = BorderColor
					end
					callback(selected)
				end)
			end
		end

		return tab
	end

	return self
end

return Hub
