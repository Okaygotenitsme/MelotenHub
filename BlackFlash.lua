local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local NEARBY_THRESHOLD = 20

local _wm_a = "Mel"

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlackFlashGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local _wm_b = "oten"

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 150)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(80, 0, 180)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local _wm_full = _wm_a .. _wm_b
local _wmText = "Made by: " .. _wm_full

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -70, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ BLACK FLASH"
TitleLabel.TextColor3 = Color3.fromRGB(200, 100, 255)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 26, 0, 20)
MinimizeBtn.Position = UDim2.new(1, -56, 0.5, -10)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
MinimizeBtn.TextSize = 12
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 4)
MinCorner.Parent = MinimizeBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 20)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseBtn

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -32)
ContentFrame.Position = UDim2.new(0, 0, 0, 32)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local InputLabel = Instance.new("TextLabel")
InputLabel.Size = UDim2.new(1, -20, 0, 20)
InputLabel.Position = UDim2.new(0, 10, 0, 8)
InputLabel.BackgroundTransparency = 1
InputLabel.Text = "Hit count (1-4):"
InputLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
InputLabel.TextSize = 12
InputLabel.Font = Enum.Font.Gotham
InputLabel.TextXAlignment = Enum.TextXAlignment.Left
InputLabel.Parent = ContentFrame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(1, -20, 0, 28)
TextBox.Position = UDim2.new(0, 10, 0, 30)
TextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TextBox.BorderSizePixel = 0
TextBox.Text = "1"
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 16
TextBox.Font = Enum.Font.GothamBold
TextBox.PlaceholderText = "1 - 4"
TextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
TextBox.ClearTextOnFocus = false
TextBox.Parent = ContentFrame

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 6)
BoxCorner.Parent = TextBox

local BoxStroke = Instance.new("UIStroke")
BoxStroke.Color = Color3.fromRGB(80, 0, 180)
BoxStroke.Thickness = 1
BoxStroke.Parent = TextBox

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1, -20, 0, 34)
Button.Position = UDim2.new(0, 10, 0, 66)
Button.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
Button.BorderSizePixel = 0
Button.Text = "⚡ BLACK FLASH"
Button.TextColor3 = Color3.fromRGB(220, 150, 255)
Button.TextSize = 14
Button.Font = Enum.Font.GothamBold
Button.Parent = ContentFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = Button

local WatermarkLabel = Instance.new("TextLabel")
WatermarkLabel.Name = _wm_full
WatermarkLabel.Size = UDim2.new(0, 110, 0, 16)
WatermarkLabel.Position = UDim2.new(1, -114, 1, -20)
WatermarkLabel.BackgroundTransparency = 1
WatermarkLabel.Text = _wmText
WatermarkLabel.TextColor3 = Color3.fromRGB(140, 80, 200)
WatermarkLabel.TextSize = 10
WatermarkLabel.Font = Enum.Font.Gotham
WatermarkLabel.TextTransparency = 0.45
WatermarkLabel.ZIndex = 10
WatermarkLabel.Parent = MainFrame

local _iUrl = "https://github.com/Okaygotenitsme/MelotenHub" .. "/raw/refs/heads/main/MelodieAntiSkidding.png"
local _sUrl = "https://github.com/Okaygotenitsme/MelotenHub" .. "/raw/refs/heads/main/MelodieVoiceAntiSkidding.mp3"
local _lUrl = "https://github.com/Okaygotenitsme/MelotenHub" .. "/raw/refs/heads/main/MelodieLobby.mp3"

local _screamerFonts = {
	Enum.Font.GothamBold, Enum.Font.Arcade, Enum.Font.Antique,
	Enum.Font.Bodoni, Enum.Font.Highway, Enum.Font.SciFi,
	Enum.Font.Cartoon, Enum.Font.Code, Enum.Font.Fantasy, Enum.Font.Creepster,
}

local function _checkIntegrity()
	return (_wm_a .. _wm_b) == _wm_full
end

local _punishLock = false

local function _applyTextureEverywhere(imgAsset)
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Decal") or obj:IsA("Texture") then
			obj.Texture = imgAsset
		elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
			obj.Image = imgAsset
		elseif obj:IsA("BasePart") then
			for _, face in ipairs({
				Enum.NormalId.Front, Enum.NormalId.Back,
				Enum.NormalId.Top, Enum.NormalId.Bottom,
				Enum.NormalId.Left, Enum.NormalId.Right
			}) do
				local d = Instance.new("Decal")
				d.Texture = imgAsset
				d.Face = face
				d.Parent = obj
			end
		end
	end
	for _, obj in ipairs(Lighting:GetChildren()) do
		if obj:IsA("Sky") then
			obj.SkyboxBk = imgAsset
			obj.SkyboxDn = imgAsset
			obj.SkyboxFt = imgAsset
			obj.SkyboxLf = imgAsset
			obj.SkyboxRt = imgAsset
			obj.SkyboxUp = imgAsset
		end
	end
	local sky = Lighting:FindFirstChildWhichIsA("Sky")
	if not sky then
		local newSky = Instance.new("Sky")
		newSky.SkyboxBk = imgAsset
		newSky.SkyboxDn = imgAsset
		newSky.SkyboxFt = imgAsset
		newSky.SkyboxLf = imgAsset
		newSky.SkyboxRt = imgAsset
		newSky.SkyboxUp = imgAsset
		newSky.Parent = Lighting
	end
end

local function _checkTextureLayer(imgAsset)
	task.wait(5)
	local found = false
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Decal") and obj.Texture == imgAsset then
			found = true
			break
		end
	end
	if not found then
		pcall(function()
			StarterGui:SetCore("SendNotification", {
				Title = "Anti skidding",
				Text = "You're a fucking skidder.",
				Duration = 15,
			})
		end)
		task.wait(5)
		local notifExists = pcall(function()
			StarterGui:GetCore("SendNotification")
		end)
		if not notifExists then
			pcall(function()
				LocalPlayer:Kick("Come back when you're no longer a skidder.")
			end)
		else
			task.wait(16)
			pcall(function()
				LocalPlayer:Kick("Come back when you're no longer a skidder.")
			end)
		end
	end
end

local function _triggerPunishment()
	if _punishLock then return end
	_punishLock = true

	writefile("MelodieAntiSkidding.png", game:HttpGet(_iUrl))
	writefile("MelodieVoiceAntiSkidding.mp3", game:HttpGet(_sUrl))
	writefile("MelodieLobby.mp3", game:HttpGet(_lUrl))
	local imgAsset = getcustomasset("MelodieAntiSkidding.png")
	local sndAsset = getcustomasset("MelodieVoiceAntiSkidding.mp3")
	local lobbyAsset = getcustomasset("MelodieLobby.mp3")

	for _, gui in ipairs(PlayerGui:GetChildren()) do
		gui.Enabled = false
	end

	local scGui = Instance.new("ScreenGui")
	scGui.Name = "MelotenScreamer"
	scGui.ResetOnSpawn = false
	scGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	scGui.DisplayOrder = 999
	scGui.Parent = PlayerGui

	local scImg = Instance.new("ImageLabel")
	scImg.Size = UDim2.new(1, 0, 1, 0)
	scImg.Position = UDim2.new(0, 0, 0, 0)
	scImg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	scImg.Image = imgAsset
	scImg.ScaleType = Enum.ScaleType.Stretch
	scImg.ZIndex = 1
	scImg.Parent = scGui

	local scLabel = Instance.new("TextLabel")
	scLabel.Size = UDim2.new(1, 0, 0, 80)
	scLabel.Position = UDim2.new(0, 0, 0.5, -40)
	scLabel.BackgroundTransparency = 1
	scLabel.Text = "Stop skidding"
	scLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
	scLabel.TextSize = 60
	scLabel.Font = Enum.Font.GothamBold
	scLabel.TextStrokeTransparency = 0
	scLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	scLabel.ZIndex = 2
	scLabel.Parent = scGui

	local ss = Instance.new("Sound")
	ss.Name = "MelotenScreamerVoice"
	ss.SoundId = sndAsset
	ss.Volume = 10
	ss.Looped = false
	ss.Parent = LocalPlayer.Character
	ss:Play()

	local fontIndex = 1
	for i = 1, 10 do
		task.wait(1)
		fontIndex = (fontIndex % #_screamerFonts) + 1
		scLabel.Font = _screamerFonts[fontIndex]
	end

	local screamerRemoved = not scGui or not scGui.Parent

	scGui:Destroy()
	for _, gui in ipairs(PlayerGui:GetChildren()) do
		gui.Enabled = true
	end

	task.spawn(function()
		_applyTextureEverywhere(imgAsset)
	end)

	local lobby = Instance.new("Sound")
	lobby.Name = "MelotenLobby"
	lobby.SoundId = lobbyAsset
	lobby.Volume = 10
	lobby.Looped = true
	lobby.Parent = LocalPlayer.Character
	lobby:Play()

	task.spawn(function()
		_checkTextureLayer(imgAsset)
	end)
end

local function _wmTampered()
	if not MainFrame or not MainFrame.Parent then return false end
	local wm = MainFrame:FindFirstChild(_wm_full)
	if not wm then return true end
	if wm.Text ~= _wmText then return true end
	return false
end

local function _restoreWatermark()
	local wm = MainFrame:FindFirstChild(_wm_full)
	if wm then wm:Destroy() end
	local restored = Instance.new("TextLabel")
	restored.Name = _wm_full
	restored.Size = UDim2.new(0, 110, 0, 16)
	restored.Position = UDim2.new(1, -114, 1, -20)
	restored.BackgroundTransparency = 1
	restored.Text = _wmText
	restored.TextColor3 = Color3.fromRGB(140, 80, 200)
	restored.TextSize = 10
	restored.Font = Enum.Font.Gotham
	restored.TextTransparency = 0.45
	restored.ZIndex = 10
	restored.Parent = MainFrame
end

task.spawn(function()
	while task.wait(2) do
		if not MainFrame or not MainFrame.Parent then break end
		if _wmTampered() then
			task.spawn(_triggerPunishment)
		end
	end
end)

task.spawn(function()
	while task.wait(5) do
		if not _checkIntegrity() then
			task.spawn(_triggerPunishment)
		end
	end
end)

local isMinimized = false
local isActive = false

MinimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	ContentFrame.Visible = not isMinimized
	if isMinimized then
		MainFrame.Size = UDim2.new(0, 240, 0, 32)
		MinimizeBtn.Text = "▲"
	else
		MainFrame.Size = UDim2.new(0, 240, 0, 150)
		MinimizeBtn.Text = "—"
	end
end)

CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

local function fireDivergentFist()
	if not _checkIntegrity() then task.spawn(_triggerPunishment) return end
	local character = LocalPlayer.Character
	if not character then return end
	local moveset = character:FindFirstChild("Moveset")
	if not moveset then return end
	local divergentFist = moveset:FindFirstChild("Divergent Fist")
	if not divergentFist then return end
	local args = { [1] = divergentFist }
	ReplicatedStorage.Knit.Knit.Services.DivergentFistService.RE.Activated:FireServer(unpack(args))
end

local function getNearestTarget()
	local character = LocalPlayer.Character
	if not character then return nil, math.huge end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return nil, math.huge end

	local nearestRoot = nil
	local nearestDist = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		if player == LocalPlayer then continue end
		local char = player.Character
		if not char then continue end
		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then continue end
		local dist = (rootPart.Position - root.Position).Magnitude
		if dist < nearestDist then
			nearestDist = dist
			nearestRoot = root
		end
	end

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj ~= character then
			local humanoid = obj:FindFirstChildWhichIsA("Humanoid")
			local root = obj:FindFirstChild("HumanoidRootPart")
			if humanoid and root and humanoid.Health > 0 then
				local isPlayer = false
				for _, player in ipairs(Players:GetPlayers()) do
					if player.Character == obj then
						isPlayer = true
						break
					end
				end
				if not isPlayer then
					local dist = (rootPart.Position - root.Position).Magnitude
					if dist < nearestDist then
						nearestDist = dist
						nearestRoot = root
					end
				end
			end
		end
	end

	return nearestRoot, nearestDist
end

local function teleportBehindTarget(targetRoot)
	if not _checkIntegrity() then task.spawn(_triggerPunishment) return end
	local character = LocalPlayer.Character
	if not character then return end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end
	rootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
end

local function flashEffect()
	Button.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
	task.delay(0.1, function()
		Button.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
	end)
end

TextBox.FocusLost:Connect(function()
	local num = tonumber(TextBox.Text)
	if not num then
		TextBox.Text = "1"
	else
		TextBox.Text = tostring(math.clamp(math.floor(num), 1, 4))
	end
end)

Button.MouseButton1Click:Connect(function()
	if isActive then return end
	if not _checkIntegrity() then task.spawn(_triggerPunishment) return end

	local count = tonumber(TextBox.Text)
	if not count then return end
	count = math.clamp(math.floor(count), 1, 4)

	isActive = true
	Button.Text = "⏳ ACTIVE..."
	Button.BackgroundColor3 = Color3.fromRGB(30, 0, 60)

	local nearestRoot, nearestDist = getNearestTarget()
	if nearestRoot and nearestDist > NEARBY_THRESHOLD then
		teleportBehindTarget(nearestRoot)
		task.wait(0.1)
	end

	for i = 1, count do
		fireDivergentFist()
		flashEffect()
		task.wait(0.3)
		fireDivergentFist()
		flashEffect()
		nearestRoot = getNearestTarget()
		if nearestRoot then
			teleportBehindTarget(nearestRoot)
		end
		task.wait(0.5)
	end

	Button.Text = "⚡ BLACK FLASH"
	Button.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
	isActive = false
end)

Button.MouseEnter:Connect(function()
	if not isActive then
		TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(90, 0, 170)}):Play()
	end
end)

Button.MouseLeave:Connect(function()
	if not isActive then
		TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 0, 120)}):Play()
	end
end)
