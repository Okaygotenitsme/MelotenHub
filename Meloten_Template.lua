if _G.__HUB_ALREADY_RUNNING then
	pcall(function() _G.__HUB_GUI:Destroy() end)
end
_G.__HUB_ALREADY_RUNNING = true

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local BG = Color3.fromRGB(8, 10, 8)
local BG2 = Color3.fromRGB(12, 16, 12)
local Panel = Color3.fromRGB(15, 20, 15)
local PanelHover = Color3.fromRGB(20, 28, 20)
local Green = Color3.fromRGB(0, 230, 80)
local GreenDim = Color3.fromRGB(0, 140, 48)
local GreenDark = Color3.fromRGB(0, 60, 20)
local TextWhite = Color3.fromRGB(210, 255, 215)
local TextDim = Color3.fromRGB(100, 160, 110)
local Border = Color3.fromRGB(0, 80, 30)
local BorderActive = Color3.fromRGB(0, 200, 70)
local Red = Color3.fromRGB(220, 50, 50)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TermHub"
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
NotificationContainer.Size = UDim2.new(0, 280, 1, 0)
NotificationContainer.Position = UDim2.new(1, -298, 0, -10)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = ScreenGui
local NotifyList = Instance.new("UIListLayout")
NotifyList.Padding = UDim.new(0, 8)
NotifyList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyList.SortOrder = Enum.SortOrder.LayoutOrder
NotifyList.Parent = NotificationContainer

local MainFrame = Instance.new("Frame")
local OpenButton = Instance.new("TextButton")

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
		if not isfolder("TermHubCache") then makefolder("TermHubCache") end
		local key = tostring(#url) .. "_" .. url:gsub("[^%w]", ""):sub(-32)
		local fileName = "TermHubCache/" .. key .. ".png"
		if isfile(fileName) then return getcustomasset(fileName) end
		local ok, data = pcall(function() return game:HttpGet(url) end)
		if ok and data and #data > 0 then
			writefile(fileName, data)
			return getcustomasset(fileName)
		end
	end
	return "rbxassetid://0"
end

local function scanline(parent)
	local s = Instance.new("Frame")
	s.Size = UDim2.new(1, 0, 1, 0)
	s.BackgroundTransparency = 1
	s.BorderSizePixel = 0
	s.ZIndex = parent.ZIndex + 10
	s.Parent = parent
	for i = 0, 30 do
		local line = Instance.new("Frame")
		line.Size = UDim2.new(1, 0, 0, 1)
		line.Position = UDim2.new(0, 0, 0, i * 14)
		line.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		line.BackgroundTransparency = 0.93
		line.BorderSizePixel = 0
		line.Parent = s
	end
end

function Hub:Notify(title, text, duration)
	duration = duration or 3
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, 0, 0, 0)
	Frame.BackgroundColor3 = BG
	Frame.BorderSizePixel = 0
	Frame.ClipsDescendants = true
	Frame.Parent = NotificationContainer

	local LeftBar = Instance.new("Frame")
	LeftBar.Size = UDim2.new(0, 2, 1, 0)
	LeftBar.BackgroundColor3 = Green
	LeftBar.BorderSizePixel = 0
	LeftBar.Parent = Frame

	local TopLine = Instance.new("Frame")
	TopLine.Size = UDim2.new(1, 0, 0, 1)
	TopLine.BackgroundColor3 = Green
	TopLine.BackgroundTransparency = 0.5
	TopLine.BorderSizePixel = 0
	TopLine.Parent = Frame

	local BottomLine = Instance.new("Frame")
	BottomLine.Size = UDim2.new(1, 0, 0, 1)
	BottomLine.Position = UDim2.new(0, 0, 1, -1)
	BottomLine.BackgroundColor3 = Green
	BottomLine.BackgroundTransparency = 0.5
	BottomLine.BorderSizePixel = 0
	BottomLine.Parent = Frame

	local Prefix = Instance.new("TextLabel")
	Prefix.Text = ">> "
	Prefix.Size = UDim2.new(0, 30, 0, 20)
	Prefix.Position = UDim2.new(0, 10, 0, 6)
	Prefix.BackgroundTransparency = 1
	Prefix.TextColor3 = GreenDim
	Prefix.Font = Enum.Font.Code
	Prefix.TextSize = 12
	Prefix.TextXAlignment = Enum.TextXAlignment.Left
	Prefix.Parent = Frame

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Text = title:upper()
	TitleLabel.Size = UDim2.new(1, -50, 0, 20)
	TitleLabel.Position = UDim2.new(0, 38, 0, 6)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.TextColor3 = Green
	TitleLabel.Font = Enum.Font.Code
	TitleLabel.TextSize = 12
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = Frame

	local DescLabel = Instance.new("TextLabel")
	DescLabel.Text = text
	DescLabel.Size = UDim2.new(1, -20, 0, 28)
	DescLabel.Position = UDim2.new(0, 10, 0, 26)
	DescLabel.BackgroundTransparency = 1
	DescLabel.TextColor3 = TextDim
	DescLabel.Font = Enum.Font.Code
	DescLabel.TextSize = 11
	DescLabel.TextXAlignment = Enum.TextXAlignment.Left
	DescLabel.TextWrapped = true
	DescLabel.Parent = Frame

	TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 0, 58)}):Play()

	task.spawn(function()
		task.wait(duration)
		local tw = TweenService:Create(Frame, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 0, 0)})
		tw:Play()
		TweenService:Create(TitleLabel, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
		TweenService:Create(DescLabel, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
		TweenService:Create(LeftBar, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
		tw.Completed:Wait()
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
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

function Hub:CreateWindow(config)
	local self = setmetatable({}, Hub)
	self._currentTab = nil
	self._currentPage = nil

	local W = config.Size and config.Size.X or 540
	local H = config.Size and config.Size.Y or 370

	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, W, 0, H)
	MainFrame.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
	MainFrame.BackgroundColor3 = BG
	MainFrame.BorderSizePixel = 0
	MainFrame.Visible = true
	MainFrame.Parent = ScreenGui

	local OuterStroke = Instance.new("UIStroke")
	OuterStroke.Color = Border
	OuterStroke.Thickness = 1
	OuterStroke.Parent = MainFrame

	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 36)
	TopBar.BackgroundColor3 = BG2
	TopBar.BorderSizePixel = 0
	TopBar.Parent = MainFrame

	local TopBorder = Instance.new("Frame")
	TopBorder.Size = UDim2.new(1, 0, 0, 1)
	TopBorder.Position = UDim2.new(0, 0, 1, -1)
	TopBorder.BackgroundColor3 = Border
	TopBorder.BorderSizePixel = 0
	TopBorder.Parent = TopBar

	local CornerDecorTL = Instance.new("Frame")
	CornerDecorTL.Size = UDim2.new(0, 8, 0, 1)
	CornerDecorTL.Position = UDim2.new(0, 0, 0, 0)
	CornerDecorTL.BackgroundColor3 = Green
	CornerDecorTL.BorderSizePixel = 0
	CornerDecorTL.Parent = MainFrame

	local CornerDecorTL2 = Instance.new("Frame")
	CornerDecorTL2.Size = UDim2.new(0, 1, 0, 8)
	CornerDecorTL2.Position = UDim2.new(0, 0, 0, 0)
	CornerDecorTL2.BackgroundColor3 = Green
	CornerDecorTL2.BorderSizePixel = 0
	CornerDecorTL2.Parent = MainFrame

	local CornerDecorBR = Instance.new("Frame")
	CornerDecorBR.Size = UDim2.new(0, 8, 0, 1)
	CornerDecorBR.Position = UDim2.new(1, -8, 1, -1)
	CornerDecorBR.BackgroundColor3 = Green
	CornerDecorBR.BorderSizePixel = 0
	CornerDecorBR.Parent = MainFrame

	local CornerDecorBR2 = Instance.new("Frame")
	CornerDecorBR2.Size = UDim2.new(0, 1, 0, 8)
	CornerDecorBR2.Position = UDim2.new(1, -1, 1, -8)
	CornerDecorBR2.BackgroundColor3 = Green
	CornerDecorBR2.BorderSizePixel = 0
	CornerDecorBR2.Parent = MainFrame

	local StatusDot = Instance.new("Frame")
	StatusDot.Size = UDim2.new(0, 6, 0, 6)
	StatusDot.Position = UDim2.new(0, 10, 0.5, -3)
	StatusDot.BackgroundColor3 = Green
	StatusDot.BorderSizePixel = 0
	StatusDot.Parent = TopBar
	local StatusCorner = Instance.new("UICorner")
	StatusCorner.CornerRadius = UDim.new(1, 0)
	StatusCorner.Parent = StatusDot

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Text = (config.Title or "TERM_HUB"):upper()
	TitleLabel.Size = UDim2.new(1, -90, 1, 0)
	TitleLabel.Position = UDim2.new(0, 24, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.TextColor3 = Green
	TitleLabel.Font = Enum.Font.Code
	TitleLabel.TextSize = 13
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = TopBar

	local VerLabel = Instance.new("TextLabel")
	VerLabel.Text = "v1.0"
	VerLabel.Size = UDim2.new(0, 40, 1, 0)
	VerLabel.Position = UDim2.new(1, -110, 0, 0)
	VerLabel.BackgroundTransparency = 1
	VerLabel.TextColor3 = TextDim
	VerLabel.Font = Enum.Font.Code
	VerLabel.TextSize = 10
	VerLabel.TextXAlignment = Enum.TextXAlignment.Right
	VerLabel.Parent = TopBar

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Text = "[X]"
	CloseBtn.Size = UDim2.new(0, 38, 0, 22)
	CloseBtn.Position = UDim2.new(1, -44, 0.5, -11)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.TextColor3 = Red
	CloseBtn.Font = Enum.Font.Code
	CloseBtn.TextSize = 12
	CloseBtn.Parent = TopBar

	local TabContainer = Instance.new("Frame")
	TabContainer.Size = UDim2.new(1, 0, 0, 28)
	TabContainer.Position = UDim2.new(0, 0, 0, 36)
	TabContainer.BackgroundColor3 = BG2
	TabContainer.BorderSizePixel = 0
	TabContainer.ClipsDescendants = true
	TabContainer.Parent = MainFrame

	local TabBorder = Instance.new("Frame")
	TabBorder.Size = UDim2.new(1, 0, 0, 1)
	TabBorder.Position = UDim2.new(0, 0, 1, -1)
	TabBorder.BackgroundColor3 = Border
	TabBorder.BorderSizePixel = 0
	TabBorder.Parent = TabContainer

	local TabPad = Instance.new("UIPadding")
	TabPad.PaddingLeft = UDim.new(0, 6)
	TabPad.Parent = TabContainer

	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.FillDirection = Enum.FillDirection.Horizontal
	TabListLayout.Padding = UDim.new(0, 0)
	TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	TabListLayout.Parent = TabContainer

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
	OpenButton.Size = UDim2.new(0, 60, 0, 22)
	OpenButton.Position = UDim2.new(0, 14, 0.5, 0)
	OpenButton.BackgroundColor3 = BG2
	OpenButton.TextColor3 = Green
	OpenButton.Font = Enum.Font.Code
	OpenButton.TextSize = 11
	OpenButton.Text = "[OPEN]"
	OpenButton.BorderSizePixel = 0
	OpenButton.Visible = false
	OpenButton.Parent = ScreenGui

	local OpenStroke = Instance.new("UIStroke")
	OpenStroke.Color = Border
	OpenStroke.Thickness = 1
	OpenStroke.Parent = OpenButton

	makeDraggable(TopBar, MainFrame)
	makeDraggable(OpenButton, OpenButton)

	CloseBtn.MouseButton1Click:Connect(function()
		TweenService:Create(MainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {Size = UDim2.new(0, W, 0, 0), Position = UDim2.new(0.5, -W/2, 0.5, 0)}):Play()
		task.wait(0.15)
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
		TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {Size = UDim2.new(0, W, 0, H), Position = UDim2.new(0.5, -W/2, 0.5, -H/2)}):Play()
	end)

	self._tabContainer = TabContainer
	self._pagesFolder = PagesFolder
	self._W = W
	self._H = H

	function self:AddTab(name)
		local Page = Instance.new("ScrollingFrame")
		Page.Name = name
		Page.Size = UDim2.new(1, -16, 1, -72)
		Page.Position = UDim2.new(0, 8, 0, 68)
		Page.BackgroundTransparency = 1
		Page.ScrollBarThickness = 2
		Page.ScrollBarImageColor3 = GreenDim
		Page.Visible = false
		Page.CanvasSize = UDim2.new(0, 0, 0, 0)
		Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Page.BorderSizePixel = 0
		Page.Parent = PagesFolder

		local Layout = Instance.new("UIListLayout")
		Layout.Padding = UDim.new(0, 3)
		Layout.SortOrder = Enum.SortOrder.LayoutOrder
		Layout.Parent = Page

		local Padding = Instance.new("UIPadding")
		Padding.PaddingTop = UDim.new(0, 4)
		Padding.PaddingBottom = UDim.new(0, 6)
		Padding.Parent = Page

		local TabBtn = Instance.new("TextButton")
		TabBtn.Text = name:upper()
		TabBtn.Size = UDim2.new(0, #name * 9 + 24, 1, 0)
		TabBtn.BackgroundTransparency = 1
		TabBtn.TextColor3 = TextDim
		TabBtn.Font = Enum.Font.Code
		TabBtn.TextSize = 11
		TabBtn.BorderSizePixel = 0
		TabBtn.Parent = TabContainer

		local ActiveBar = Instance.new("Frame")
		ActiveBar.Size = UDim2.new(1, 0, 0, 1)
		ActiveBar.Position = UDim2.new(0, 0, 1, -1)
		ActiveBar.BackgroundColor3 = Green
		ActiveBar.BorderSizePixel = 0
		ActiveBar.Visible = false
		ActiveBar.Parent = TabBtn

		local win = self
		TabBtn.MouseButton1Click:Connect(function()
			if win._currentTab then
				TweenService:Create(win._currentTab, TweenInfo.new(0.15), {TextColor3 = TextDim}):Play()
				local bar = win._currentTab:FindFirstChild("Frame")
				if bar then bar.Visible = false end
			end
			if win._currentPage then win._currentPage.Visible = false end
			win._currentTab = TabBtn
			win._currentPage = Page
			Page.Visible = true
			TweenService:Create(TabBtn, TweenInfo.new(0.15), {TextColor3 = Green}):Play()
			ActiveBar.Visible = true
		end)

		if not self._currentTab then
			self._currentTab = TabBtn
			self._currentPage = Page
			Page.Visible = true
			TabBtn.TextColor3 = Green
			ActiveBar.Visible = true
		end

		local tab = {}

		function tab:AddToggle(labelText, callback)
			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Size = UDim2.new(1, -4, 0, 34)
			ToggleFrame.BackgroundColor3 = Panel
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.Parent = Page

			local LeftAccent = Instance.new("Frame")
			LeftAccent.Size = UDim2.new(0, 1, 1, 0)
			LeftAccent.BackgroundColor3 = Border
			LeftAccent.BorderSizePixel = 0
			LeftAccent.Parent = ToggleFrame

			local Stroke = Instance.new("UIStroke")
			Stroke.Color = Border
			Stroke.Thickness = 1
			Stroke.Parent = ToggleFrame

			local Prefix = Instance.new("TextLabel")
			Prefix.Text = "$ "
			Prefix.Size = UDim2.new(0, 18, 1, 0)
			Prefix.Position = UDim2.new(0, 8, 0, 0)
			Prefix.BackgroundTransparency = 1
			Prefix.TextColor3 = GreenDim
			Prefix.Font = Enum.Font.Code
			Prefix.TextSize = 12
			Prefix.TextXAlignment = Enum.TextXAlignment.Left
			Prefix.Parent = ToggleFrame

			local Label = Instance.new("TextLabel")
			Label.Text = labelText
			Label.Size = UDim2.new(1, -90, 1, 0)
			Label.Position = UDim2.new(0, 26, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextDim
			Label.Font = Enum.Font.Code
			Label.TextSize = 12
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = ToggleFrame

			local StatusText = Instance.new("TextLabel")
			StatusText.Text = "OFF"
			StatusText.Size = UDim2.new(0, 34, 1, 0)
			StatusText.Position = UDim2.new(1, -80, 0, 0)
			StatusText.BackgroundTransparency = 1
			StatusText.TextColor3 = TextDim
			StatusText.Font = Enum.Font.Code
			StatusText.TextSize = 11
			StatusText.TextXAlignment = Enum.TextXAlignment.Right
			StatusText.Parent = ToggleFrame

			local SwBg = Instance.new("Frame")
			SwBg.Size = UDim2.new(0, 36, 0, 14)
			SwBg.Position = UDim2.new(1, -42, 0.5, -7)
			SwBg.BackgroundColor3 = GreenDark
			SwBg.BorderSizePixel = 0
			SwBg.Parent = ToggleFrame

			local SwStroke = Instance.new("UIStroke")
			SwStroke.Color = Border
			SwStroke.Thickness = 1
			SwStroke.Parent = SwBg

			local Circ = Instance.new("Frame")
			Circ.Size = UDim2.new(0, 10, 0, 10)
			Circ.Position = UDim2.new(0, 2, 0.5, -5)
			Circ.BackgroundColor3 = TextDim
			Circ.BorderSizePixel = 0
			Circ.Parent = SwBg

			local SwBtn = Instance.new("TextButton")
			SwBtn.Size = UDim2.new(1, 0, 1, 0)
			SwBtn.BackgroundTransparency = 1
			SwBtn.Text = ""
			SwBtn.Parent = ToggleFrame

			local state = false
			SwBtn.MouseButton1Click:Connect(function()
				state = not state
				if state then
					TweenService:Create(SwBg, TweenInfo.new(0.15), {BackgroundColor3 = GreenDark}):Play()
					TweenService:Create(Circ, TweenInfo.new(0.15), {Position = UDim2.new(1, -12, 0.5, -5), BackgroundColor3 = Green}):Play()
					TweenService:Create(Label, TweenInfo.new(0.15), {TextColor3 = TextWhite}):Play()
					TweenService:Create(StatusText, TweenInfo.new(0.15), {TextColor3 = Green}):Play()
					StatusText.Text = "ON"
					SwStroke.Color = Green
					LeftAccent.BackgroundColor3 = Green
					Stroke.Color = Border
				else
					TweenService:Create(SwBg, TweenInfo.new(0.15), {BackgroundColor3 = GreenDark}):Play()
					TweenService:Create(Circ, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0.5, -5), BackgroundColor3 = TextDim}):Play()
					TweenService:Create(Label, TweenInfo.new(0.15), {TextColor3 = TextDim}):Play()
					TweenService:Create(StatusText, TweenInfo.new(0.15), {TextColor3 = TextDim}):Play()
					StatusText.Text = "OFF"
					SwStroke.Color = Border
					LeftAccent.BackgroundColor3 = Border
				end
				callback(state)
			end)
		end

		function tab:AddButton(labelText, buttonText, callback)
			local Frame = Instance.new("Frame")
			Frame.Size = UDim2.new(1, -4, 0, 34)
			Frame.BackgroundColor3 = Panel
			Frame.BorderSizePixel = 0
			Frame.Parent = Page

			local Stroke = Instance.new("UIStroke")
			Stroke.Color = Border
			Stroke.Thickness = 1
			Stroke.Parent = Frame

			local Prefix = Instance.new("TextLabel")
			Prefix.Text = "# "
			Prefix.Size = UDim2.new(0, 18, 1, 0)
			Prefix.Position = UDim2.new(0, 8, 0, 0)
			Prefix.BackgroundTransparency = 1
			Prefix.TextColor3 = GreenDim
			Prefix.Font = Enum.Font.Code
			Prefix.TextSize = 12
			Prefix.TextXAlignment = Enum.TextXAlignment.Left
			Prefix.Parent = Frame

			local Label = Instance.new("TextLabel")
			Label.Text = labelText
			Label.Size = UDim2.new(1, -100, 1, 0)
			Label.Position = UDim2.new(0, 26, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextDim
			Label.Font = Enum.Font.Code
			Label.TextSize = 12
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = Frame

			local Btn = Instance.new("TextButton")
			Btn.Text = "[" .. (buttonText or "RUN") .. "]"
			Btn.Size = UDim2.new(0, 72, 0, 22)
			Btn.Position = UDim2.new(1, -78, 0.5, -11)
			Btn.BackgroundTransparency = 1
			Btn.TextColor3 = Green
			Btn.Font = Enum.Font.Code
			Btn.TextSize = 11
			Btn.BorderSizePixel = 0
			Btn.Parent = Frame

			local BtnStroke = Instance.new("UIStroke")
			BtnStroke.Color = GreenDim
			BtnStroke.Thickness = 1
			BtnStroke.Parent = Btn

			Btn.MouseEnter:Connect(function()
				TweenService:Create(BtnStroke, TweenInfo.new(0.1), {Color = Green}):Play()
				TweenService:Create(Btn, TweenInfo.new(0.1), {TextColor3 = TextWhite}):Play()
			end)
			Btn.MouseLeave:Connect(function()
				TweenService:Create(BtnStroke, TweenInfo.new(0.1), {Color = GreenDim}):Play()
				TweenService:Create(Btn, TweenInfo.new(0.1), {TextColor3 = Green}):Play()
			end)
			Btn.MouseButton1Click:Connect(function()
				TweenService:Create(Btn, TweenInfo.new(0.08), {TextColor3 = GreenDark}):Play()
				task.wait(0.08)
				TweenService:Create(Btn, TweenInfo.new(0.08), {TextColor3 = Green}):Play()
				callback()
			end)
		end

		function tab:AddSlider(labelText, minVal, maxVal, defaultVal, callback)
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Size = UDim2.new(1, -4, 0, 46)
			SliderFrame.BackgroundColor3 = Panel
			SliderFrame.BorderSizePixel = 0
			SliderFrame.Parent = Page

			local Stroke = Instance.new("UIStroke")
			Stroke.Color = Border
			Stroke.Thickness = 1
			Stroke.Parent = SliderFrame

			local Prefix = Instance.new("TextLabel")
			Prefix.Text = "~ "
			Prefix.Size = UDim2.new(0, 18, 0, 22)
			Prefix.Position = UDim2.new(0, 8, 0, 0)
			Prefix.BackgroundTransparency = 1
			Prefix.TextColor3 = GreenDim
			Prefix.Font = Enum.Font.Code
			Prefix.TextSize = 12
			Prefix.TextXAlignment = Enum.TextXAlignment.Left
			Prefix.Parent = SliderFrame

			local Label = Instance.new("TextLabel")
			Label.Text = labelText
			Label.Size = UDim2.new(1, -70, 0, 22)
			Label.Position = UDim2.new(0, 26, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextDim
			Label.Font = Enum.Font.Code
			Label.TextSize = 12
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = SliderFrame

			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Text = tostring(defaultVal)
			ValueLabel.Size = UDim2.new(0, 60, 0, 22)
			ValueLabel.Position = UDim2.new(1, -64, 0, 0)
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.TextColor3 = Green
			ValueLabel.Font = Enum.Font.Code
			ValueLabel.TextSize = 12
			ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
			ValueLabel.Parent = SliderFrame

			local Track = Instance.new("Frame")
			Track.Size = UDim2.new(1, -24, 0, 4)
			Track.Position = UDim2.new(0, 12, 0, 32)
			Track.BackgroundColor3 = GreenDark
			Track.BorderSizePixel = 0
			Track.Parent = SliderFrame

			local TrackStroke = Instance.new("UIStroke")
			TrackStroke.Color = Border
			TrackStroke.Thickness = 1
			TrackStroke.Parent = Track

			local Fill = Instance.new("Frame")
			Fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
			Fill.BackgroundColor3 = Green
			Fill.BorderSizePixel = 0
			Fill.Parent = Track

			local Knob = Instance.new("Frame")
			Knob.Size = UDim2.new(0, 8, 0, 12)
			Knob.AnchorPoint = Vector2.new(0.5, 0.5)
			local initRatio = (defaultVal - minVal) / (maxVal - minVal)
			Knob.Position = UDim2.new(initRatio, 0, 0.5, 0)
			Knob.BackgroundColor3 = TextWhite
			Knob.BorderSizePixel = 0
			Knob.Parent = Track

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
			InputFrame.Size = UDim2.new(1, -4, 0, 34)
			InputFrame.BackgroundColor3 = Panel
			InputFrame.BorderSizePixel = 0
			InputFrame.Parent = Page

			local Stroke = Instance.new("UIStroke")
			Stroke.Color = Border
			Stroke.Thickness = 1
			Stroke.Parent = InputFrame

			local Prefix = Instance.new("TextLabel")
			Prefix.Text = "> "
			Prefix.Size = UDim2.new(0, 18, 1, 0)
			Prefix.Position = UDim2.new(0, 8, 0, 0)
			Prefix.BackgroundTransparency = 1
			Prefix.TextColor3 = GreenDim
			Prefix.Font = Enum.Font.Code
			Prefix.TextSize = 12
			Prefix.TextXAlignment = Enum.TextXAlignment.Left
			Prefix.Parent = InputFrame

			local Label = Instance.new("TextLabel")
			Label.Text = labelText
			Label.Size = UDim2.new(0, 140, 1, 0)
			Label.Position = UDim2.new(0, 26, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = TextDim
			Label.Font = Enum.Font.Code
			Label.TextSize = 12
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = InputFrame

			local TextBox = Instance.new("TextBox")
			TextBox.PlaceholderText = placeholderText or ""
			TextBox.Text = ""
			TextBox.Size = UDim2.new(0, 120, 0, 22)
			TextBox.Position = UDim2.new(1, -126, 0.5, -11)
			TextBox.BackgroundColor3 = BG
			TextBox.TextColor3 = Green
			TextBox.Font = Enum.Font.Code
			TextBox.TextSize = 11
			TextBox.PlaceholderColor3 = GreenDim
			TextBox.BorderSizePixel = 0
			TextBox.Parent = InputFrame

			local TextStroke = Instance.new("UIStroke")
			TextStroke.Color = Border
			TextStroke.Thickness = 1
			TextStroke.Parent = TextBox

			TextBox.Focused:Connect(function()
				TweenService:Create(TextStroke, TweenInfo.new(0.15), {Color = Green}):Play()
			end)
			TextBox.FocusLost:Connect(function()
				TweenService:Create(TextStroke, TweenInfo.new(0.15), {Color = Border}):Play()
				callback(TextBox.Text)
			end)
		end

		function tab:AddLabel(text, color)
			local LabelFrame = Instance.new("Frame")
			LabelFrame.Size = UDim2.new(1, -4, 0, 22)
			LabelFrame.BackgroundTransparency = 1
			LabelFrame.Parent = Page

			local Label = Instance.new("TextLabel")
			Label.Text = "// " .. text
			Label.Size = UDim2.new(1, 0, 1, 0)
			Label.Position = UDim2.new(0, 10, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = color or GreenDim
			Label.Font = Enum.Font.Code
			Label.TextSize = 11
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = LabelFrame
		end

		function tab:AddSection(text)
			local SectionFrame = Instance.new("Frame")
			SectionFrame.Size = UDim2.new(1, -4, 0, 22)
			SectionFrame.BackgroundColor3 = GreenDark
			SectionFrame.BorderSizePixel = 0
			SectionFrame.Parent = Page

			local Stroke = Instance.new("UIStroke")
			Stroke.Color = Green
			Stroke.Thickness = 1
			Stroke.Parent = SectionFrame

			local Label = Instance.new("TextLabel")
			Label.Text = "--- " .. text:upper() .. " ---"
			Label.Size = UDim2.new(1, -16, 1, 0)
			Label.Position = UDim2.new(0, 8, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = Green
			Label.Font = Enum.Font.Code
			Label.TextSize = 11
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = SectionFrame
		end

		function tab:AddMultiToggle(labelText, options, callback)
			local selected = {}

			local HeaderFrame = Instance.new("Frame")
			HeaderFrame.Size = UDim2.new(1, -4, 0, 20)
			HeaderFrame.BackgroundTransparency = 1
			HeaderFrame.Parent = Page

			local HeaderLabel = Instance.new("TextLabel")
			HeaderLabel.Text = "// " .. labelText
			HeaderLabel.Size = UDim2.new(1, 0, 1, 0)
			HeaderLabel.Position = UDim2.new(0, 10, 0, 0)
			HeaderLabel.BackgroundTransparency = 1
			HeaderLabel.TextColor3 = GreenDim
			HeaderLabel.Font = Enum.Font.Code
			HeaderLabel.TextSize = 11
			HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
			HeaderLabel.Parent = HeaderFrame

			for _, option in ipairs(options) do
				local OptFrame = Instance.new("Frame")
				OptFrame.Size = UDim2.new(1, -4, 0, 28)
				OptFrame.BackgroundColor3 = Panel
				OptFrame.BorderSizePixel = 0
				OptFrame.Parent = Page

				local OptStroke = Instance.new("UIStroke")
				OptStroke.Color = Border
				OptStroke.Thickness = 1
				OptStroke.Parent = OptFrame

				local OptPrefix = Instance.new("TextLabel")
				OptPrefix.Text = "  "
				OptPrefix.Size = UDim2.new(0, 16, 1, 0)
				OptPrefix.Position = UDim2.new(0, 8, 0, 0)
				OptPrefix.BackgroundTransparency = 1
				OptPrefix.TextColor3 = GreenDim
				OptPrefix.Font = Enum.Font.Code
				OptPrefix.TextSize = 11
				OptPrefix.TextXAlignment = Enum.TextXAlignment.Left
				OptPrefix.Parent = OptFrame

				local OptLabel = Instance.new("TextLabel")
				OptLabel.Text = option
				OptLabel.Size = UDim2.new(1, -80, 1, 0)
				OptLabel.Position = UDim2.new(0, 24, 0, 0)
				OptLabel.BackgroundTransparency = 1
				OptLabel.TextColor3 = TextDim
				OptLabel.Font = Enum.Font.Code
				OptLabel.TextSize = 11
				OptLabel.TextXAlignment = Enum.TextXAlignment.Left
				OptLabel.Parent = OptFrame

				local SwBg = Instance.new("Frame")
				SwBg.Size = UDim2.new(0, 32, 0, 12)
				SwBg.Position = UDim2.new(1, -38, 0.5, -6)
				SwBg.BackgroundColor3 = GreenDark
				SwBg.BorderSizePixel = 0
				SwBg.Parent = OptFrame

				local SwStroke = Instance.new("UIStroke")
				SwStroke.Color = Border
				SwStroke.Thickness = 1
				SwStroke.Parent = SwBg

				local Circ = Instance.new("Frame")
				Circ.Size = UDim2.new(0, 8, 0, 8)
				Circ.Position = UDim2.new(0, 2, 0.5, -4)
				Circ.BackgroundColor3 = TextDim
				Circ.BorderSizePixel = 0
				Circ.Parent = SwBg

				local SwBtn = Instance.new("TextButton")
				SwBtn.Size = UDim2.new(1, 0, 1, 0)
				SwBtn.BackgroundTransparency = 1
				SwBtn.Text = ""
				SwBtn.Parent = OptFrame

				local optState = false
				local optName = option
				SwBtn.MouseButton1Click:Connect(function()
					optState = not optState
					selected[optName] = optState
					if optState then
						TweenService:Create(Circ, TweenInfo.new(0.15), {Position = UDim2.new(1, -10, 0.5, -4), BackgroundColor3 = Green}):Play()
						TweenService:Create(OptLabel, TweenInfo.new(0.15), {TextColor3 = TextWhite}):Play()
						OptPrefix.Text = "> "
						SwStroke.Color = Green
						OptStroke.Color = GreenDim
					else
						TweenService:Create(Circ, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0.5, -4), BackgroundColor3 = TextDim}):Play()
						TweenService:Create(OptLabel, TweenInfo.new(0.15), {TextColor3 = TextDim}):Play()
						OptPrefix.Text = "  "
						SwStroke.Color = Border
						OptStroke.Color = Border
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
