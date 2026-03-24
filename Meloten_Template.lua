if _G.__HUB_ALREADY_RUNNING then
    pcall(function() _G.__HUB_GUI:Destroy() end)
end
_G.__HUB_ALREADY_RUNNING = true

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local DarkBg = Color3.fromRGB(25, 25, 25)
local ElementBg = Color3.fromRGB(40, 40, 40)
local PurpleAccent = Color3.fromRGB(170, 85, 255)
local TextColor = Color3.fromRGB(255, 255, 255)
local TextColorDim = Color3.fromRGB(200, 200, 200)

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

function Hub:Notify(title, text, duration)
	duration = duration or 3
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, 0, 0, 0)
	Frame.BackgroundColor3 = DarkBg
	Frame.BorderSizePixel = 0
	Frame.ClipsDescendants = true
	Frame.Parent = NotificationContainer
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 8)
	UICorner.Parent = Frame
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = PurpleAccent
	UIStroke.Thickness = 1.5
	UIStroke.Parent = Frame
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Text = title
	TitleLabel.Size = UDim2.new(1, -20, 0, 20)
	TitleLabel.Position = UDim2.new(0, 10, 0, 5)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.TextColor3 = PurpleAccent
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 14
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = Frame
	local DescLabel = Instance.new("TextLabel")
	DescLabel.Text = text
	DescLabel.Size = UDim2.new(1, -20, 0, 30)
	DescLabel.Position = UDim2.new(0, 10, 0, 25)
	DescLabel.BackgroundTransparency = 1
	DescLabel.TextColor3 = TextColor
	DescLabel.Font = Enum.Font.Gotham
	DescLabel.TextSize = 13
	DescLabel.TextXAlignment = Enum.TextXAlignment.Left
	DescLabel.TextWrapped = true
	DescLabel.Parent = Frame
	TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 60)}):Play()
	task.spawn(function()
		task.wait(duration)
		local tween = TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
		tween:Play()
		TweenService:Create(TitleLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
		TweenService:Create(DescLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
		TweenService:Create(UIStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
		tween.Completed:Wait()
		Frame:Destroy()
	end)
end

local function makeDraggable(frame)
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then update(input) end
	end)
end

function Hub:CreateWindow(config)
	local self = setmetatable({}, Hub)
	self._pages = {}
	self._currentTab = nil
	self._currentPage = nil

	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, config.Size and config.Size.X or 520, 0, config.Size and config.Size.Y or 370)
	MainFrame.Position = UDim2.new(0.5, -(config.Size and config.Size.X or 520)/2, 0.5, -(config.Size and config.Size.Y or 370)/2)
	MainFrame.BackgroundColor3 = DarkBg
	MainFrame.BorderSizePixel = 0
	MainFrame.Visible = true
	MainFrame.Parent = ScreenGui
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = MainFrame
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = PurpleAccent
	UIStroke.Thickness = 2
	UIStroke.Parent = MainFrame

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Text = config.Title or "Meloten Hub"
	TitleLabel.Size = UDim2.new(1, -40, 0, 30)
	TitleLabel.Position = UDim2.new(0, 15, 0, 5)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.TextColor3 = TextColor
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 14
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = MainFrame

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Text = "X"
	CloseBtn.Size = UDim2.new(0, 30, 0, 30)
	CloseBtn.Position = UDim2.new(1, -35, 0, 5)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 20
	CloseBtn.Parent = MainFrame

	local TabContainer = Instance.new("Frame")
	TabContainer.Size = UDim2.new(1, -20, 0, 35)
	TabContainer.Position = UDim2.new(0, 10, 0, 40)
	TabContainer.BackgroundTransparency = 1
	TabContainer.Parent = MainFrame
	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.FillDirection = Enum.FillDirection.Horizontal
	TabListLayout.Padding = UDim.new(0, 8)
	TabListLayout.Parent = TabContainer

	local PagesFolder = Instance.new("Folder")
	PagesFolder.Name = "Pages"
	PagesFolder.Parent = MainFrame

	if config.Icon then
		OpenButton.Image = config.Icon
	end
	OpenButton.Name = "OpenButton"
	OpenButton.Size = UDim2.new(0, 50, 0, 50)
	OpenButton.Position = UDim2.new(0, 50, 0.5, 0)
	OpenButton.BackgroundColor3 = DarkBg
	OpenButton.Visible = false
	OpenButton.Parent = ScreenGui
	local OpenCorner = Instance.new("UICorner")
	OpenCorner.CornerRadius = UDim.new(0, 12)
	OpenCorner.Parent = OpenButton
	local OpenStroke = Instance.new("UIStroke")
	OpenStroke.Color = PurpleAccent
	OpenStroke.Thickness = 2
	OpenStroke.Parent = OpenButton

	makeDraggable(MainFrame)
	makeDraggable(OpenButton)

	CloseBtn.MouseButton1Click:Connect(function()
		MainFrame.Visible = false
		OpenButton.Visible = true
	end)
	OpenButton.MouseButton1Click:Connect(function()
		OpenButton.Visible = false
		MainFrame.Visible = true
	end)

	self._tabContainer = TabContainer
	self._pagesFolder = PagesFolder

	function self:AddTab(name)
		local Page = Instance.new("ScrollingFrame")
		Page.Name = name
		Page.Size = UDim2.new(1, -20, 1, -90)
		Page.Position = UDim2.new(0, 10, 0, 85)
		Page.BackgroundTransparency = 1
		Page.ScrollBarThickness = 4
		Page.ScrollBarImageColor3 = PurpleAccent
		Page.Visible = false
		Page.CanvasSize = UDim2.new(0, 0, 0, 0)
		Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Page.Parent = PagesFolder
		local Layout = Instance.new("UIListLayout")
		Layout.Padding = UDim.new(0, 6)
		Layout.SortOrder = Enum.SortOrder.LayoutOrder
		Layout.Parent = Page
		local Padding = Instance.new("UIPadding")
		Padding.PaddingTop = UDim.new(0, 5)
		Padding.PaddingBottom = UDim.new(0, 5)
		Padding.Parent = Page

		local TabBtn = Instance.new("TextButton")
		TabBtn.Text = name
		TabBtn.Size = UDim2.new(0, 85, 1, 0)
		TabBtn.BackgroundColor3 = ElementBg
		TabBtn.TextColor3 = TextColorDim
		TabBtn.Font = Enum.Font.GothamBold
		TabBtn.TextSize = 13
		TabBtn.Parent = TabContainer
		local Corner = Instance.new("UICorner")
		Corner.CornerRadius = UDim.new(0, 8)
		Corner.Parent = TabBtn

		local win = self
		TabBtn.MouseButton1Click:Connect(function()
			if win._currentTab then
				TweenService:Create(win._currentTab, TweenInfo.new(0.2), {BackgroundColor3 = ElementBg, TextColor3 = TextColorDim}):Play()
			end
			if win._currentPage then win._currentPage.Visible = false end
			win._currentTab = TabBtn
			win._currentPage = Page
			Page.Visible = true
			TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = PurpleAccent, TextColor3 = TextColor}):Play()
		end)

		if not self._currentTab then
			self._currentTab = TabBtn
			self._currentPage = Page
			Page.Visible = true
			TabBtn.BackgroundColor3 = PurpleAccent
			TabBtn.TextColor3 = TextColor
		end

		local tab = {}

		function tab:AddToggle(labelText, callback)
			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Size = UDim2.new(1, -5, 0, 38)
			ToggleFrame.BackgroundColor3 = ElementBg
			ToggleFrame.Parent = Page
			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 6)
			Corner.Parent = ToggleFrame
			local Label = Instance.new("TextLabel")
			Label.Text = labelText
			Label.Size = UDim2.new(1, -60, 1, 0)
			Label.Position = UDim2.new(0, 15, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextColorDim
			Label.Font = Enum.Font.Gotham
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = ToggleFrame
			local Sw = Instance.new("TextButton")
			Sw.Text = ""
			Sw.Size = UDim2.new(0, 40, 0, 20)
			Sw.Position = UDim2.new(1, -50, 0.5, -10)
			Sw.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			Sw.Parent = ToggleFrame
			local SwCorner = Instance.new("UICorner")
			SwCorner.CornerRadius = UDim.new(1, 0)
			SwCorner.Parent = Sw
			local Circ = Instance.new("Frame")
			Circ.Size = UDim2.new(0, 16, 0, 16)
			Circ.Position = UDim2.new(0, 2, 0.5, -8)
			Circ.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Circ.Parent = Sw
			local CircCorner = Instance.new("UICorner")
			CircCorner.CornerRadius = UDim.new(1, 0)
			CircCorner.Parent = Circ
			local state = false
			Sw.MouseButton1Click:Connect(function()
				state = not state
				if state then
					TweenService:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = PurpleAccent}):Play()
					TweenService:Create(Circ, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
					TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = TextColor}):Play()
				else
					TweenService:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
					TweenService:Create(Circ, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
					TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = TextColorDim}):Play()
				end
				callback(state)
			end)
		end

		function tab:AddButton(labelText, buttonText, callback)
			local Frame = Instance.new("Frame")
			Frame.Size = UDim2.new(1, -5, 0, 38)
			Frame.BackgroundColor3 = ElementBg
			Frame.Parent = Page
			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 6)
			Corner.Parent = Frame
			local Label = Instance.new("TextLabel")
			Label.Text = labelText
			Label.Size = UDim2.new(1, -100, 1, 0)
			Label.Position = UDim2.new(0, 15, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextColorDim
			Label.Font = Enum.Font.Gotham
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = Frame
			local Btn = Instance.new("TextButton")
			Btn.Text = buttonText or "Run"
			Btn.Size = UDim2.new(0, 80, 0, 26)
			Btn.Position = UDim2.new(1, -90, 0.5, -13)
			Btn.BackgroundColor3 = PurpleAccent
			Btn.TextColor3 = TextColor
			Btn.Font = Enum.Font.GothamBold
			Btn.TextSize = 13
			Btn.Parent = Frame
			local BtnCorner = Instance.new("UICorner")
			BtnCorner.CornerRadius = UDim.new(0, 6)
			BtnCorner.Parent = Btn
			Btn.MouseButton1Click:Connect(callback)
		end

		function tab:AddSlider(labelText, minVal, maxVal, defaultVal, callback)
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Size = UDim2.new(1, -5, 0, 50)
			SliderFrame.BackgroundColor3 = ElementBg
			SliderFrame.Parent = Page
			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 6)
			Corner.Parent = SliderFrame
			local Label = Instance.new("TextLabel")
			Label.Text = labelText
			Label.Size = UDim2.new(1, 0, 0, 25)
			Label.Position = UDim2.new(0, 15, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextColorDim
			Label.Font = Enum.Font.Gotham
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = SliderFrame
			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Text = tostring(defaultVal)
			ValueLabel.Size = UDim2.new(0, 50, 0, 25)
			ValueLabel.Position = UDim2.new(1, -60, 0, 0)
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.TextColor3 = TextColor
			ValueLabel.Font = Enum.Font.GothamBold
			ValueLabel.TextSize = 14
			ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
			ValueLabel.Parent = SliderFrame
			local SliderBar = Instance.new("TextButton")
			SliderBar.Text = ""
			SliderBar.Size = UDim2.new(1, -30, 0, 6)
			SliderBar.Position = UDim2.new(0, 15, 0, 32)
			SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			SliderBar.AutoButtonColor = false
			SliderBar.Parent = SliderFrame
			local BarCorner = Instance.new("UICorner")
			BarCorner.CornerRadius = UDim.new(1, 0)
			BarCorner.Parent = SliderBar
			local Fill = Instance.new("Frame")
			Fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
			Fill.BackgroundColor3 = PurpleAccent
			Fill.Parent = SliderBar
			local FillCorner = Instance.new("UICorner")
			FillCorner.CornerRadius = UDim.new(1, 0)
			FillCorner.Parent = Fill
			local dragging = false
			local function update(input)
				local sizeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
				local value = math.floor(minVal + ((maxVal - minVal) * sizeX))
				TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(sizeX, 0, 1, 0)}):Play()
				ValueLabel.Text = tostring(value)
				callback(value)
			end
			SliderBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					update(input)
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					update(input)
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
			end)
		end

		function tab:AddInput(labelText, placeholderText, callback)
			local InputFrame = Instance.new("Frame")
			InputFrame.Size = UDim2.new(1, -5, 0, 40)
			InputFrame.BackgroundColor3 = ElementBg
			InputFrame.Parent = Page
			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 6)
			Corner.Parent = InputFrame
			local Label = Instance.new("TextLabel")
			Label.Text = labelText
			Label.Size = UDim2.new(0, 180, 1, 0)
			Label.Position = UDim2.new(0, 15, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextColorDim
			Label.Font = Enum.Font.Gotham
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = InputFrame
			local TextBox = Instance.new("TextBox")
			TextBox.PlaceholderText = placeholderText or ""
			TextBox.Text = ""
			TextBox.Size = UDim2.new(0, 100, 0, 26)
			TextBox.Position = UDim2.new(1, -110, 0.5, -13)
			TextBox.BackgroundColor3 = DarkBg
			TextBox.TextColor3 = TextColor
			TextBox.Font = Enum.Font.Gotham
			TextBox.TextSize = 14
			TextBox.Parent = InputFrame
			local TextCorner = Instance.new("UICorner")
			TextCorner.CornerRadius = UDim.new(0, 4)
			TextCorner.Parent = TextBox
			TextBox.FocusLost:Connect(function()
				callback(TextBox.Text)
			end)
		end

		function tab:AddLabel(text, color)
			local LabelFrame = Instance.new("Frame")
			LabelFrame.Size = UDim2.new(1, -5, 0, 28)
			LabelFrame.BackgroundTransparency = 1
			LabelFrame.Parent = Page
			local Label = Instance.new("TextLabel")
			Label.Text = text
			Label.Size = UDim2.new(1, 0, 1, 0)
			Label.Position = UDim2.new(0, 15, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = color or PurpleAccent
			Label.Font = Enum.Font.GothamBold
			Label.TextSize = 13
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = LabelFrame
		end

		function tab:AddSection(text)
			local SectionFrame = Instance.new("Frame")
			SectionFrame.Size = UDim2.new(1, -5, 0, 28)
			SectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			SectionFrame.Parent = Page
			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 6)
			Corner.Parent = SectionFrame
			local Label = Instance.new("TextLabel")
			Label.Text = "— " .. text .. " —"
			Label.Size = UDim2.new(1, 0, 1, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = PurpleAccent
			Label.Font = Enum.Font.GothamBold
			Label.TextSize = 12
			Label.Parent = SectionFrame
		end

		function tab:AddMultiToggle(labelText, options, callback)
			local selected = {}
			local HeaderFrame = Instance.new("Frame")
			HeaderFrame.Size = UDim2.new(1, -5, 0, 28)
			HeaderFrame.BackgroundTransparency = 1
			HeaderFrame.Parent = Page
			local HeaderLabel = Instance.new("TextLabel")
			HeaderLabel.Text = labelText
			HeaderLabel.Size = UDim2.new(1, 0, 1, 0)
			HeaderLabel.Position = UDim2.new(0, 15, 0, 0)
			HeaderLabel.BackgroundTransparency = 1
			HeaderLabel.TextColor3 = PurpleAccent
			HeaderLabel.Font = Enum.Font.GothamBold
			HeaderLabel.TextSize = 13
			HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
			HeaderLabel.Parent = HeaderFrame
			for _, option in ipairs(options) do
				local OptFrame = Instance.new("Frame")
				OptFrame.Size = UDim2.new(1, -5, 0, 30)
				OptFrame.BackgroundColor3 = ElementBg
				OptFrame.Parent = Page
				local OptCorner = Instance.new("UICorner")
				OptCorner.CornerRadius = UDim.new(0, 6)
				OptCorner.Parent = OptFrame
				local OptLabel = Instance.new("TextLabel")
				OptLabel.Text = option
				OptLabel.Size = UDim2.new(1, -60, 1, 0)
				OptLabel.Position = UDim2.new(0, 15, 0, 0)
				OptLabel.BackgroundTransparency = 1
				OptLabel.TextColor3 = TextColorDim
				OptLabel.Font = Enum.Font.Gotham
				OptLabel.TextSize = 13
				OptLabel.TextXAlignment = Enum.TextXAlignment.Left
				OptLabel.Parent = OptFrame
				local Sw = Instance.new("TextButton")
				Sw.Text = ""
				Sw.Size = UDim2.new(0, 40, 0, 20)
				Sw.Position = UDim2.new(1, -50, 0.5, -10)
				Sw.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				Sw.Parent = OptFrame
				local SwCorner = Instance.new("UICorner")
				SwCorner.CornerRadius = UDim.new(1, 0)
				SwCorner.Parent = Sw
				local Circ = Instance.new("Frame")
				Circ.Size = UDim2.new(0, 16, 0, 16)
				Circ.Position = UDim2.new(0, 2, 0.5, -8)
				Circ.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Circ.Parent = Sw
				local CircCorner = Instance.new("UICorner")
				CircCorner.CornerRadius = UDim.new(1, 0)
				CircCorner.Parent = Circ
				local optState = false
				local optName = option
				Sw.MouseButton1Click:Connect(function()
					optState = not optState
					selected[optName] = optState
					if optState then
						TweenService:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = PurpleAccent}):Play()
						TweenService:Create(Circ, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
						TweenService:Create(OptLabel, TweenInfo.new(0.2), {TextColor3 = TextColor}):Play()
					else
						TweenService:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
						TweenService:Create(Circ, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
						TweenService:Create(OptLabel, TweenInfo.new(0.2), {TextColor3 = TextColorDim}):Play()
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
