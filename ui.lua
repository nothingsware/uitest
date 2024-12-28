local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local vector2New, vector3New, udim2New, cframeNew = Vector2.new, Vector3.new, UDim2.new, CFrame.new
local Libraryeeeeeee = { connections = {} }
local rs = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local Mouse = LocalPlayer:GetMouse()

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local utility = {}
function utility:Connect(connection, func) -- this will help disable any connections with keybind
	local con = connection:Connect(func)
	table.insert(Libraryeeeeeee.connections, con)
	return con
end

function utility:ToRGB(color)
	return color.R * 255, color.G * 255, color.B * 255
end

local function CreateDrag(gui)
	local dragging
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		ts:Create(gui, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			),
		}):Play()
	end

	local lastEnd = 0
	--[[
    local function closeClosables()
        if os.clock() < lastEnd + 0.5 then
            return
        end
        --lastEnd = os.clock()
        for _, item in ipairs(library.thingsToClose) do
            task.spawn(function()
                if type(item) == 'table' and rawget(item, "Close") then
                    local can = true
                    if item.lastOpened and os.clock() < item.lastOpened + 0.5 then
                        can = false 
                    end
                    for _, asd in ipairs(item.MainFrames) do
                        if isHoveringOverObj(asd) then
                            can = false
                        end 
                    end
                    if can then
                        item:Close();
                    end
                end
            end)
        end 
    end
    ]]

	---we do or it wil get leaked its a custom ui wdym? needs to be obsfucated
	local lastMoved = 0
	local con
	gui.InputBegan:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
		end
	end)

	uis.InputEnded:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragging = false
			--closeClosables()
		end
	end)

	gui.InputChanged:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragInput = input
			lastMoved = os.clock()
		end
	end)

	uis.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

local Library = {}

function Library:validate(defaults, options)
	for i, v in pairs(defaults) do
		if options[i] == nil then
			options[i] = v
		end
	end
	return options
end

function Library:new(options)
	local window = { first_tab = nil }
	local tabcount = 0
	options = Library:validate({
		name = "macos remake by brennen",
	}, options or {})

	local brennen = {
		CurrentTab = nil,
	}

	local nEWGABRIEL = Instance.new("ScreenGui", game:GetService("CoreGui"))
	nEWGABRIEL.Name = options["name"]
	nEWGABRIEL.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local mainFrame = Instance.new("Frame", nEWGABRIEL)
	mainFrame.Name = "MainFrame"
	mainFrame.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
	mainFrame.BackgroundTransparency = 0.1
	mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	mainFrame.BorderSizePixel = 0
	mainFrame.Visible = false
	mainFrame.Position = UDim2.fromScale(0.0815, 0.0599)
	mainFrame.Size = UDim2.fromOffset(538, 357)
	CreateDrag(mainFrame)

	local sound = Instance.new("Sound")
	sound.Parent = mainFrame
	sound.SoundId = "rbxassetid://6958727243" -- Replace with the ID of your sound
	sound.Volume = 10
	sound.PlayOnRemove = true
	sound:Play()
	sound:Destroy()
	task.wait(0.75)
	-- Change the field of view (FOV)
	local camera = workspace.CurrentCamera
	local originalFOV = camera.FieldOfView
	if originalFOV <= 71 and originalFOV >= 70 then
		local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quint)
		local tween = game:GetService("TweenService"):Create(camera, tweenInfo, { FieldOfView = 67 })
		tween:Play()
		wait(1)
		local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quint)
		local tween = game:GetService("TweenService"):Create(camera, tweenInfo, { FieldOfView = 64 })
		tween:Play()
		tween.Completed:Connect(function()
			-- Change the FOV back t		o its original value
			local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quint)
			local tween = game:GetService("TweenService"):Create(camera, tweenInfo, { FieldOfView = originalFOV })
			tween:Play()
		end)
	end
	wait(1.3)

	-- Make the mainFrame smoothly visible
	mainFrame.BackgroundTransparency = 1 -- Start with the mainFrame being completely transparent
	mainFrame.Position = UDim2.fromScale(0.5, 0.5) -- Center the mainFrame on the screen
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5) -- Set anchor point to the center
	mainFrame.Visible = true
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) -- Reduce the duration for a faster animation
	local tween = game:GetService("TweenService"):Create(mainFrame, tweenInfo, { BackgroundTransparency = 0.1 }) -- Tween to completely opaque
	tween:Play()

	local uICorner = Instance.new("UICorner")
	uICorner.Name = "UICorner"
	uICorner.CornerRadius = UDim.new(0, 12)
	uICorner.Parent = mainFrame

	local preblur = Instance.new("Script")
	preblur.Name = "Preblur"
	preblur.Parent = mainFrame

	local tabBorder = Instance.new("Frame")
	tabBorder.Name = "TabBorder"
	tabBorder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	tabBorder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tabBorder.BorderSizePixel = 0
	tabBorder.Position = UDim2.fromScale(0.241, 0)
	tabBorder.Size = UDim2.new(0, 1, 1, 0)
	tabBorder.Parent = mainFrame

	local frame = Instance.new("Frame")
	frame.Name = "Frame"
	frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	frame.BackgroundTransparency = 1
	frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	frame.BorderSizePixel = 0
	frame.Position = UDim2.fromScale(0.633, 0.014)
	frame.Size = UDim2.fromOffset(180, 100)
	frame.Parent = mainFrame

	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Name = "ImageLabel"
	imageLabel.Image = "rbxassetid://9968344227"
	imageLabel.ImageTransparency = 0.9
	imageLabel.ScaleType = Enum.ScaleType.Tile
	imageLabel.TileSize = UDim2.fromOffset(128, 128)
	imageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	imageLabel.BackgroundTransparency = 1
	imageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	imageLabel.BorderSizePixel = 0
	imageLabel.Position = UDim2.fromScale(-1.13e-07, 0)
	imageLabel.Size = UDim2.fromScale(1, 1)

	local imageLabel33 = Instance.new("ImageLabel", mainFrame)
	imageLabel33.Name = "ImageLabel"
	imageLabel33.Image = "rbxassetid://9968344105"
	imageLabel33.ImageTransparency = 0.98
	imageLabel33.ScaleType = Enum.ScaleType.Tile
	imageLabel33.TileSize = UDim2.fromOffset(128, 128)
	imageLabel33.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	imageLabel33.BackgroundTransparency = 1
	imageLabel33.BorderColor3 = Color3.fromRGB(0, 0, 0)
	imageLabel33.BorderSizePixel = 0
	imageLabel33.Size = UDim2.fromScale(1, 1)

	local uICorner = Instance.new("UICorner")
	uICorner.Name = "UICorner"
	uICorner.CornerRadius = UDim.new(0, 12)
	uICorner.Parent = imageLabel33

	local uICorner1 = Instance.new("UICorner")
	uICorner1.Name = "UICorner"
	uICorner1.CornerRadius = UDim.new(0, 12)
	uICorner1.Parent = imageLabel

	imageLabel.Parent = mainFrame

	local sidebarHolder = Instance.new("Frame", mainFrame)
	sidebarHolder.Name = "SidebarHolder"
	sidebarHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sidebarHolder.BackgroundTransparency = 1
	sidebarHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	sidebarHolder.BorderSizePixel = 0
	sidebarHolder.Size = UDim2.fromOffset(129, 357)

	local close = Instance.new("TextButton")
	close.Name = "Close"
	close.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	close.Text = ""
	close.TextColor3 = Color3.fromRGB(0, 0, 0)
	close.TextSize = 14
	close.AutoButtonColor = false
	close.BackgroundColor3 = Color3.fromRGB(252, 95, 83)
	close.Position = UDim2.fromScale(0.09, 0.035)
	close.Size = UDim2.fromOffset(8, 8)

	local uICorner2 = Instance.new("UICorner")
	uICorner2.Name = "UICorner"
	uICorner2.CornerRadius = UDim.new(0, 50)
	uICorner2.Parent = close

	close.Parent = sidebarHolder

	local minimize = Instance.new("TextButton")
	minimize.Name = "Minimize"
	minimize.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	minimize.Text = ""
	minimize.TextColor3 = Color3.fromRGB(0, 0, 0)
	minimize.TextSize = 14
	minimize.AutoButtonColor = false
	minimize.BackgroundColor3 = Color3.fromRGB(242, 191, 60)
	minimize.Position = UDim2.fromScale(0.185, 0.035)
	minimize.Size = UDim2.fromOffset(8, 8)

	local uICorner3 = Instance.new("UICorner")
	uICorner3.Name = "UICorner"
	uICorner3.CornerRadius = UDim.new(0, 50)
	uICorner3.Parent = minimize

	minimize.Parent = sidebarHolder

	local open = Instance.new("TextButton")
	open.Name = "Open"
	open.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	open.Text = ""
	open.TextColor3 = Color3.fromRGB(0, 0, 0)
	open.TextSize = 14
	open.AutoButtonColor = false
	open.BackgroundColor3 = Color3.fromRGB(117, 166, 87)
	open.Position = UDim2.fromScale(0.276, 0.035)
	open.Size = UDim2.fromOffset(8, 8)

	local uICorner4 = Instance.new("UICorner")
	uICorner4.Name = "UICorner"
	uICorner4.CornerRadius = UDim.new(0, 50)
	uICorner4.Parent = open

	open.Parent = sidebarHolder

	local tabBorder1 = Instance.new("Frame")
	tabBorder1.Name = "TabBorder"
	tabBorder1.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	tabBorder1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tabBorder1.BorderSizePixel = 0
	tabBorder1.Position = UDim2.fromScale(0.00775, 0.0896)
	tabBorder1.Size = UDim2.new(0.998, 1, 0.0028, 0)
	tabBorder1.Parent = sidebarHolder

	local searchFrame = Instance.new("Frame")
	searchFrame.Name = "Search_Frame"
	searchFrame.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
	searchFrame.BackgroundTransparency = 0.6
	searchFrame.Position = UDim2.new(0.055, 2, 0.125, 0)
	searchFrame.Size = UDim2.fromOffset(113, 24)
	searchFrame.ZIndex = 8

	local uICorner5 = Instance.new("UICorner")
	uICorner5.Name = "UICorner"
	uICorner5.CornerRadius = UDim.new(0, 6)
	uICorner5.Parent = searchFrame

	local uIStroke = Instance.new("UIStroke")
	uIStroke.Name = "UIStroke"
	uIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uIStroke.Color = Color3.fromRGB(42, 42, 42)
	uIStroke.Parent = searchFrame

	local search = Instance.new("TextBox", searchFrame)
	search.Name = "Search"
	search.FontFace = Font.new("rbxassetid://12187365977")
	search.Text = "Search..."
	search.TextColor3 = Color3.fromRGB(101, 101, 101)
	search.TextSize = 12
	search.Active = false
	search.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	search.BackgroundTransparency = 1
	search.BorderColor3 = Color3.fromRGB(27, 42, 53)
	search.BorderSizePixel = 0
	search.Selectable = false
	search.Size = UDim2.fromScale(1, 1)
	local optionsName = options.name

	search:GetPropertyChangedSignal("Text"):Connect(function()
		local InputText = string.upper(search.Text)
		for _, page in ipairs(game:GetService("CoreGui")[optionsName].MainFrame.HoldingSections:GetChildren()) do
			if page ~= "UIListLayout" then
				for _, side in pairs(page:GetChildren()) do
					if side ~= "UIListLayout" then
						for _, Section in pairs(side:GetChildren()) do
							if Section:IsA("Frame") and Section ~= "PlaceHolder" then
								for _, Element in pairs(Section:GetChildren()) do
									if Element:IsA("Frame") and Element.Name ~= "Placeholder" then
										if
											InputText == ""
											or string.find(string.upper(Element.Name), InputText) ~= nil
										then
											Element.Visible = true
										else
											Element.Visible = false
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end)

	local search1 = Instance.new("ImageButton")
	search1.Name = "search"
	search1.Image = "rbxassetid://3926305904"
	search1.ImageColor3 = Color3.fromRGB(112, 112, 112)
	search1.ImageRectOffset = Vector2.new(964, 324)
	search1.ImageRectSize = Vector2.new(36, 36)
	search1.BackgroundTransparency = 1
	search1.Position = UDim2.fromScale(0.081, 0.22)
	search1.Size = UDim2.fromOffset(14, 14)
	search1.ZIndex = 2
	search1.Parent = searchFrame

	searchFrame.Parent = sidebarHolder

	local tabBorder2 = Instance.new("Frame")
	tabBorder2.Name = "TabBorder"
	tabBorder2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	tabBorder2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tabBorder2.BorderSizePixel = 0
	tabBorder2.Position = UDim2.fromScale(0.008, 0.225)
	tabBorder2.Size = UDim2.new(0.998, 1, 0.0028, 0)
	tabBorder2.Parent = sidebarHolder

	local tabHolder1 = Instance.new("ScrollingFrame", sidebarHolder)
	tabHolder1.Name = "TabHolder"
	tabHolder1.ScrollBarThickness = 0
	tabHolder1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tabHolder1.BackgroundTransparency = 1
	tabHolder1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tabHolder1.BorderSizePixel = 0
	tabHolder1.Position = UDim2.fromScale(0, 0.225)
	tabHolder1.Selectable = false
	tabHolder1.Size = UDim2.fromOffset(129, 226)
	tabHolder1.SelectionGroup = false

	local uIListLayout = Instance.new("UIListLayout")
	uIListLayout.Name = "UIListLayout"
	uIListLayout.Padding = UDim.new(0, 6)
	uIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uIListLayout.Parent = tabHolder1

	local uIPadding = Instance.new("UIPadding")
	uIPadding.Name = "UIPadding"
	uIPadding.PaddingTop = UDim.new(0, 12)
	uIPadding.Parent = tabHolder1

	local holdingSections = Instance.new("Frame", mainFrame)
	holdingSections.Name = "HoldingSections"
	holdingSections.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	holdingSections.BackgroundTransparency = 1
	holdingSections.BorderColor3 = Color3.fromRGB(0, 0, 0)
	holdingSections.BorderSizePixel = 0
	holdingSections.Position = UDim2.fromScale(0.242, 0)
	holdingSections.Size = UDim2.fromOffset(408, 357)

	local tabBorder3 = Instance.new("Frame")
	tabBorder3.Name = "TabBorder"
	tabBorder3.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	tabBorder3.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tabBorder3.BorderSizePixel = 0
	tabBorder3.Position = UDim2.fromScale(0.008, 0.86)
	tabBorder3.Size = UDim2.new(0.998, 1, 0.0028, 0)
	tabBorder3.Parent = sidebarHolder

	sidebarHolder.Parent = mainFrame

	local usernameFrame = Instance.new("Frame", sidebarHolder)
	usernameFrame.Name = "Username_frame"
	usernameFrame.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
	usernameFrame.BackgroundTransparency = 0.6
	usernameFrame.Position = UDim2.fromScale(0.08, 0.89)
	usernameFrame.Size = UDim2.fromOffset(110, 30)

	local uICorner8 = Instance.new("UICorner")
	uICorner8.Name = "UICorner"
	uICorner8.Parent = usernameFrame

	local imageLabel1 = Instance.new("ImageLabel")
	imageLabel1.Name = "ImageLabel"
	imageLabel1.Image = game:GetService("Players"):GetUserThumbnailAsync(
		game.Players.LocalPlayer.UserId,
		Enum.ThumbnailType.HeadShot,
		Enum.ThumbnailSize.Size420x420
	)
	imageLabel1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	imageLabel1.Position = UDim2.fromScale(0.086, 0.2)
	imageLabel1.Size = UDim2.fromOffset(17, 17)

	local uICorner9 = Instance.new("UICorner")
	uICorner9.Name = "UICorner"
	uICorner9.CornerRadius = UDim.new(0, 50)
	uICorner9.Parent = imageLabel1

	local uIStroke3 = Instance.new("UIStroke")
	uIStroke3.Name = "UIStroke"
	uIStroke3.Color = Color3.fromRGB(50, 50, 50)
	uIStroke3.Parent = imageLabel1

	imageLabel1.Parent = usernameFrame

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "TextLabel"
	textLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
	textLabel.Text = LocalPlayer.DisplayName
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextScaled = false
	textLabel.TextSize = 11
	textLabel.TextWrapped = true
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.BackgroundTransparency = 1
	textLabel.Position = UDim2.fromScale(0.241, -0.0318)
	textLabel.Size = UDim2.fromOffset(73, 30)

	local uIPadding3 = Instance.new("UIPadding")
	uIPadding3.Name = "UIPadding"
	uIPadding3.PaddingLeft = UDim.new(0, 6)
	uIPadding3.Parent = textLabel

	textLabel.Parent = usernameFrame

	local uIStroke4 = Instance.new("UIStroke")
	uIStroke4.Name = "UIStroke"
	uIStroke4.Color = Color3.fromRGB(45, 45, 45)
	uIStroke4.Parent = usernameFrame

	close.MouseButton1Click:Connect(function()
		mainFrame:Destroy()
	end)

	-- // starts of tabs

	function brennen:Tab(Info)
		local tab = {}
		local Info = Info or {}
		local Title = Info.Title or Info.title or Info.name or Info.Name or Info.text or Info.Text or "Home"
		local ImageId = Info.Image or Info.image or Info.ID or Info.id or "rbxassetid://13935306918"
		tabcount = tabcount + 1
		if tabcount == 1 then
			self.first_tab = Title
		end

		local sectionHolders = Instance.new("ScrollingFrame", holdingSections)
		sectionHolders.Name = Title
		sectionHolders.ScrollBarThickness = 0
		sectionHolders.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		sectionHolders.BackgroundTransparency = 1
		sectionHolders.BorderColor3 = Color3.fromRGB(0, 0, 0)
		sectionHolders.BorderSizePixel = 0
		sectionHolders.Selectable = false
		sectionHolders.Size = UDim2.fromScale(1, 1)
		sectionHolders.SelectionGroup = false

		local left = Instance.new("Frame", sectionHolders)
		left.Name = "Left"
		left.BackgroundColor3 = Color3.fromRGB(35, 35, 33)
		left.BackgroundTransparency = 1
		left.BorderColor3 = Color3.fromRGB(0, 0, 0)
		left.BorderSizePixel = 0
		left.Position = UDim2.fromScale(0.04, 0.022)
		left.Size = UDim2.fromOffset(180, 100)

		local right = Instance.new("Frame", sectionHolders)
		right.Name = "Right"
		right.BackgroundColor3 = Color3.fromRGB(35, 35, 33)
		right.BackgroundTransparency = 1
		right.BorderColor3 = Color3.fromRGB(0, 0, 0)
		right.BorderSizePixel = 0
		right.Position = UDim2.fromScale(0.516, 0.022)
		right.Size = UDim2.fromOffset(180, 100)

		local uIListLayout1 = Instance.new("UIListLayout")
		uIListLayout1.Name = "UIListLayout"
		uIListLayout1.Padding = UDim.new(0, 6)
		uIListLayout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
		uIListLayout1.Parent = right

		local uIListLayout3 = Instance.new("UIListLayout")
		uIListLayout3.Name = "UIListLayout"
		uIListLayout3.Padding = UDim.new(0, 6)
		uIListLayout3.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
		uIListLayout3.Parent = left

		local activeTab = Instance.new("Frame", tabHolder1)
		activeTab.Name = "Tab1"
		activeTab.BackgroundColor3 = Color3.fromRGB(35, 35, 33)
		activeTab.BackgroundTransparency = 0.65
		activeTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
		activeTab.BorderSizePixel = 0
		activeTab.Size = UDim2.fromOffset(110, 25)

		local Tab_detector = Instance.new("TextButton")
		Tab_detector.Parent = activeTab
		Tab_detector.Name = "TextButton"
		Tab_detector.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
		Tab_detector.Text = ""
		Tab_detector.TextColor3 = Color3.fromRGB(0, 0, 0)
		Tab_detector.TextSize = 14
		Tab_detector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Tab_detector.BackgroundTransparency = 1
		Tab_detector.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab_detector.BorderSizePixel = 0
		Tab_detector.Size = UDim2.fromScale(1, 1)

		local uIStroke1 = Instance.new("UIStroke")
		uIStroke1.Name = "UIStroke"
		uIStroke1.Color = Color3.fromRGB(45, 45, 45)
		uIStroke1.Parent = activeTab

		local uICorner6 = Instance.new("UICorner")
		uICorner6.Name = "UICorner"
		uICorner6.CornerRadius = UDim.new(0, 6)
		uICorner6.Parent = activeTab

		local tabactiveicon = Instance.new("ImageLabel")
		tabactiveicon.Name = "Tabactiveicon"
		tabactiveicon.Image = ImageId
		tabactiveicon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		tabactiveicon.BackgroundTransparency = 1
		tabactiveicon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		tabactiveicon.BorderSizePixel = 0
		tabactiveicon.Position = UDim2.fromScale(0.0818, 0.28)
		tabactiveicon.Size = UDim2.fromOffset(11, 11)
		tabactiveicon.Parent = activeTab

		local tabactivename = Instance.new("TextLabel")
		tabactivename.Name = "Tabactivename"
		tabactivename.FontFace = Font.new("rbxassetid://12187365977")
		tabactivename.Text = Title
		tabactivename.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabactivename.TextSize = 12
		tabactivename.TextWrapped = true
		tabactivename.TextXAlignment = Enum.TextXAlignment.Left
		tabactivename.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		tabactivename.BackgroundTransparency = 1
		tabactivename.BorderColor3 = Color3.fromRGB(0, 0, 0)
		tabactivename.BorderSizePixel = 0
		tabactivename.Position = UDim2.fromScale(0.237, 0)
		tabactivename.Size = UDim2.fromOffset(82, 25)

		local uIPadding1 = Instance.new("UIPadding")
		uIPadding1.Name = "UIPadding"
		uIPadding1.PaddingLeft = UDim.new(0, 2)
		uIPadding1.Parent = tabactivename

		tabactivename.Parent = activeTab

		-- // unactive icon = 79, 79, 79
		-- // unactive tab name /text =  115, 115, 115

		local Opened
		for i, v in pairs(holdingSections:GetChildren()) do
			if v:IsA("ScrollingFrame") then
				if v.Name == Title and self.first_tab == Title then
					v.Visible = true
					ts:Create(
						tabactiveicon,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ ImageColor3 = Color3.fromRGB(255, 255, 255) }
					):Play()
					ts:Create(
						activeTab,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ BackgroundTransparency = 0.65 }
					):Play()
					ts:Create(
						uIStroke1,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ Transparency = 0 }
					):Play()
					ts:Create(
						tabactivename,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ TextColor3 = Color3.fromRGB(255, 255, 255) }
					):Play()
				elseif v.Name == Title and self.first_tab ~= Title then
					v.Visible = false
					ts:Create(
						tabactiveicon,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ ImageColor3 = Color3.fromRGB(79, 79, 79) }
					):Play()
					ts:Create(
						tabactivename,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ TextColor3 = Color3.fromRGB(79, 79, 79) }
					):Play()
					ts:Create(
						uIStroke1,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ Transparency = 1 }
					):Play()
					ts:Create(
						activeTab,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ BackgroundTransparency = 1 }
					):Play()
				end
			end
		end

		Tab_detector.MouseButton1Click:Connect(function()
			for _, v in pairs(tabHolder1:GetChildren()) do
				if v.Name == "Tab1" then
					ts:Create(
						v.Tabactiveicon,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ ImageColor3 = Color3.fromRGB(79, 79, 79) }
					):Play()
					ts:Create(
						v.UIStroke,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ Transparency = 1 }
					):Play()
					ts:Create(
						v.Tabactivename,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ TextColor3 = Color3.fromRGB(79, 79, 79) }
					):Play()
					ts:Create(
						v,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ BackgroundTransparency = 1 }
					):Play()
				end
				ts:Create(
					tabactiveicon,
					TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
					{ ImageColor3 = Color3.fromRGB(255, 255, 255) }
				):Play()
				ts:Create(
					activeTab,
					TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
					{ BackgroundTransparency = 0.65 }
				):Play()
				ts:Create(
					uIStroke1,
					TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
					{ Transparency = 0 }
				):Play()
				ts:Create(
					tabactivename,
					TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
					{ TextColor3 = Color3.fromRGB(255, 255, 255) }
				):Play()
			end
			for _, v in pairs(holdingSections:GetChildren()) do
				if v:IsA("ScrollingFrame") then
					v.Visible = false
				end
			end
			sectionHolders.Visible = true
		end)
		Opened = false

		for _, v in pairs(tabHolder1:GetChildren()) do
			if v:IsA("Frame") then -- Check if the child is a Frame
				v.MouseEnter:Connect(function()
					if v.BackgroundTransparency ~= 0.6499999761581421 then -- Only change color if the tab is not active
						ts:Create(
							v.Tabactiveicon,
							TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
							{ ImageColor3 = Color3.fromRGB(255, 255, 255) }
						):Play()
						ts:Create(
							v.Tabactivename,
							TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
							{ TextColor3 = Color3.fromRGB(255, 255, 255) }
						):Play()
					end
				end)

				v.MouseLeave:Connect(function()
					task.wait(0.2)
					if v.BackgroundTransparency ~= 0.6499999761581421 then -- Only change color back if the tab is not active
						ts:Create(
							v.Tabactiveicon,
							TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
							{ ImageColor3 = Color3.fromRGB(79, 79, 79) }
						):Play()
						ts:Create(
							v.Tabactivename,
							TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
							{ TextColor3 = Color3.fromRGB(79, 79, 79) }
						):Play()
					end
				end)
			end
		end

		function tab:Section(Info)
			local sec = {}
			local Info = Info or {}
			local Side = Info.side or Info.Side or 1
			local Title = Info.text or Info.Text or Info.Title or Info.title or Info.Name or Info.name or "Section"
			local side = Side == 1 and left or right

			local section1 = Instance.new("Frame", side)
			section1.Name = "Section"
			section1.BackgroundColor3 = Color3.fromRGB(35, 35, 33)
			section1.BackgroundTransparency = 0.65
			section1.BorderColor3 = Color3.fromRGB(0, 0, 0)
			section1.BorderSizePixel = 0
			section1.Position = UDim2.fromScale(0, 7.63e-08)
			section1.Size = UDim2.fromOffset(180, 197)

			local uIStroke7 = Instance.new("UIStroke")
			uIStroke7.Name = "UIStroke"
			uIStroke7.Color = Color3.fromRGB(45, 45, 45)
			uIStroke7.Parent = section1

			local uICorner12 = Instance.new("UICorner")
			uICorner12.Name = "UICorner"
			uICorner12.CornerRadius = UDim.new(0, 10)
			uICorner12.Parent = section1

			local uIPadding4 = Instance.new("UIPadding")
			uIPadding4.Name = "UIPadding"
			uIPadding4.PaddingTop = UDim.new(0, 6)
			uIPadding4.Parent = section1

			local uIListLayout2 = Instance.new("UIListLayout")
			uIListLayout2.Name = "UIListLayout"
			uIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
			uIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
			uIListLayout2.Parent = section1
			uIListLayout2.Padding = UDim.new(0, 6)

			uIListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				section1.Size = UDim2.new(0, 180, 0, uIListLayout2.AbsoluteContentSize.Y + 20)
			end)

			function sec:Button(Info)
				local BUtton = {}
				Info = Info or {}
				local Button_title = Info.Title
					or Info.title
					or Info.Text
					or Info.text
					or Info.Name
					or Info.name
					or "a simple button"
				local callback = Info.Callback or Info.callback or function() end

				local elbutton = Instance.new("Frame", section1)
				elbutton.Name = Button_title
				elbutton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				elbutton.BackgroundTransparency = 0.65
				elbutton.BorderColor3 = Color3.fromRGB(0, 0, 0)
				elbutton.BorderSizePixel = 0
				elbutton.Position = UDim2.fromScale(0, 0.437)
				elbutton.Size = UDim2.fromOffset(160, 26)

				local uICorner = Instance.new("UICorner")
				uICorner.Name = "UICorner"
				uICorner.CornerRadius = UDim.new(0, 4)
				uICorner.Parent = elbutton

				local uIStroke = Instance.new("UIStroke")
				uIStroke.Name = "UIStroke"
				uIStroke.Color = Color3.fromRGB(45, 45, 45)
				uIStroke.Parent = elbutton

				local buttonn = Instance.new("TextButton")
				buttonn.Name = "buttonn"
				buttonn.FontFace = Font.new("rbxassetid://12187365977")
				buttonn.Text = Button_title
				buttonn.TextColor3 = Color3.fromRGB(115, 115, 115)
				buttonn.TextSize = 11
				buttonn.TextXAlignment = Enum.TextXAlignment.Left
				buttonn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				buttonn.BackgroundTransparency = 1
				buttonn.BorderColor3 = Color3.fromRGB(0, 0, 0)
				buttonn.BorderSizePixel = 0
				buttonn.Position = UDim2.fromScale(9.54e-08, 0)
				buttonn.Size = UDim2.fromScale(0.829, 1)

				buttonn.MouseButton1Click:Connect(function()
					callback()
					ts:Create(
						elbutton,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ BackgroundColor3 = Color3.fromRGB(61, 61, 61) }
					):Play()
					task.wait(0.25)
					ts:Create(
						elbutton,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ BackgroundColor3 = Color3.fromRGB(35, 35, 35) }
					):Play()
				end)

				local uIPadding = Instance.new("UIPadding")
				uIPadding.Name = "UIPadding"
				uIPadding.PaddingLeft = UDim.new(0, 10)
				uIPadding.Parent = buttonn

				buttonn.Parent = elbutton

				local radioimagre = Instance.new("ImageLabel")
				radioimagre.Name = "radioimagre"
				radioimagre.Image = "rbxassetid://17765861941"
				radioimagre.ImageColor3 = Color3.fromRGB(109, 109, 109)
				radioimagre.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				radioimagre.BackgroundTransparency = 1
				radioimagre.BorderColor3 = Color3.fromRGB(0, 0, 0)
				radioimagre.BorderSizePixel = 0
				radioimagre.Position = UDim2.fromScale(0.869, 0.154)
				radioimagre.Size = UDim2.fromOffset(17, 17)
				radioimagre.Parent = elbutton
				return BUtton
			end

			function sec:Label(Info)
				local Label = {}
				local Text = Info.Text
					or Info.text
					or Info.Title
					or Info.title
					or Info.Name
					or Info.name
					or "a simple label"

				local label = Instance.new("Frame", section1)
				label.Name = "Label"
				label.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				label.BackgroundTransparency = 1
				label.BorderColor3 = Color3.fromRGB(0, 0, 0)
				label.BorderSizePixel = 0
				label.Position = UDim2.fromScale(0.0278, 0.628)
				label.Size = UDim2.fromOffset(170, 25)

				local labelnameee = Instance.new("TextLabel")
				labelnameee.Name = "labelnameee"
				labelnameee.FontFace = Font.new("rbxassetid://12187365977")
				labelnameee.Text = Text
				labelnameee.TextColor3 = Color3.fromRGB(115, 115, 115)
				labelnameee.TextSize = 12
				labelnameee.TextWrapped = true
				labelnameee.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				labelnameee.BackgroundTransparency = 1
				labelnameee.BorderColor3 = Color3.fromRGB(0, 0, 0)
				labelnameee.BorderSizePixel = 0
				labelnameee.Size = UDim2.new(1, 0, 0, 26)
				labelnameee.Parent = label

				local uICorner = Instance.new("UICorner")
				uICorner.Name = "UICorner"
				uICorner.CornerRadius = UDim.new(0, 6)
				uICorner.Parent = label

				function Label:UpdateText(newtext)
					labelnameee.Text = newtext
				end

				function Label:UpdateAlignement(alignement)
					labelnameee.TextXAlignment = alignement
				end
			end

			function sec:Toggle(Info)
				local TOGGLE = {}
				local Value = Info.Default or Info.default or Info.Def or Info.def or false
				local Info = Info or {}
				local Toggle_Title = Info.Title
					or Info.title
					or Info.Text
					or Info.text
					or Info.Name
					or Info.name
					or "a simple toggle"
				local Callback = Info.callback or Info.Callback or function() end

				local toggleFrame = Instance.new("Frame", section1)
				toggleFrame.Name = Toggle_Title
				toggleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				toggleFrame.BackgroundTransparency = 1
				toggleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				toggleFrame.BorderSizePixel = 0
				toggleFrame.Position = UDim2.fromScale(0.023, 0.394)
				toggleFrame.Size = UDim2.fromOffset(175, 25)

				local toggleName = Instance.new("TextLabel")
				toggleName.Name = "Toggle_name"
				toggleName.FontFace = Font.new("rbxassetid://12187365977")
				toggleName.Text = Toggle_Title
				toggleName.TextColor3 = Color3.fromRGB(255, 249, 249)
				toggleName.TextSize = 12
				toggleName.TextWrapped = true
				toggleName.TextXAlignment = Enum.TextXAlignment.Left
				toggleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				toggleName.BackgroundTransparency = 1
				toggleName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				toggleName.BorderSizePixel = 0
				toggleName.Position = UDim2.fromScale(0.0555, 0)
				toggleName.Size = UDim2.fromOffset(125, 26)
				toggleName.Parent = toggleFrame

				local toggleSwitch = Instance.new("Frame", toggleFrame)
				toggleSwitch.Name = "Toggle_switch"
				toggleSwitch.BackgroundColor3 = Color3.fromRGB(66, 66, 66)
				toggleSwitch.BorderColor3 = Color3.fromRGB(0, 0, 0)
				toggleSwitch.BorderSizePixel = 0
				toggleSwitch.Position = UDim2.fromScale(0.77, 0.151)
				toggleSwitch.Size = UDim2.fromOffset(30, 14)

				local uICorner = Instance.new("UICorner")
				uICorner.Name = "UICorner"
				uICorner.CornerRadius = UDim.new(0, 23)
				uICorner.Parent = toggleSwitch

				local toggleOn = Instance.new("Frame")
				toggleOn.Name = "Toggle_on"
				toggleOn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				toggleOn.BorderColor3 = Color3.fromRGB(0, 0, 0)
				toggleOn.BorderSizePixel = 0
				toggleOn.Position = UDim2.new(0.52, 3, 0.6, 0)
				toggleOn.Size = UDim2.fromOffset(6, 6)

				local uICorner1 = Instance.new("UICorner")
				uICorner1.Name = "UICorner"
				uICorner1.CornerRadius = UDim.new(0, 50)
				uICorner1.Parent = toggleOn

				toggleOn.Parent = toggleSwitch

				local toggleDetector = Instance.new("TextButton")
				toggleDetector.Name = "Toggle_detector"
				toggleDetector.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
				toggleDetector.Text = ""
				toggleDetector.TextColor3 = Color3.fromRGB(0, 0, 0)
				toggleDetector.TextSize = 14
				toggleDetector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				toggleDetector.BackgroundTransparency = 1
				toggleDetector.BorderColor3 = Color3.fromRGB(0, 0, 0)
				toggleDetector.BorderSizePixel = 0
				toggleDetector.Size = UDim2.fromScale(1, 1)
				toggleDetector.Parent = toggleFrame

				function TOGGLE:ToggleSwitch(Value)
					Callback(Value)
					local ToggleIndicatorColor = Value == true and Color3.fromRGB(255, 255, 255)
						or Color3.fromRGB(107, 107, 107)
					local ToggleIndicatorPos = Value == true and udim2New(0.52, 3, 0.25, 0)
						or udim2New(0.07, 3, 0.25, 0)
					local Toggleframe_Color = Value == true and Color3.fromRGB(66, 66, 66) or Color3.fromRGB(59, 59, 59)
					local toggletextcolor = Value == true and Color3.fromRGB(255, 255, 255)
						or Color3.fromRGB(115, 115, 115)
					ts:Create(
						toggleName,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ TextColor3 = toggletextcolor }
					):Play()
					ts:Create(
						toggleOn,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ BackgroundColor3 = ToggleIndicatorColor }
					):Play()
					ts:Create(
						toggleOn,
						TweenInfo.new(0.14, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ Position = ToggleIndicatorPos }
					):Play()
					ts:Create(
						toggleSwitch,
						TweenInfo.new(0.26, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ BackgroundColor3 = Toggleframe_Color }
					):Play()
				end

				toggleDetector.MouseButton1Click:Connect(function()
					Value = not Value

					TOGGLE:ToggleSwitch(Value)
				end)

				TOGGLE:ToggleSwitch(Value)

				return TOGGLE
			end

			function sec:Slider(options)
				options = Library:validate({
					title = "baba",
					min = 0,
					max = 100,
					default = 50,
					callback = function(v)
						print(v)
					end,
				}, options or {})
				local Increment = options.Increment or options.increment or 1
				local Increment = 1 / Increment
				local slidere = {}

				local slider = Instance.new("Frame", section1)
				slider.Name = "Slider"
				slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				slider.BackgroundTransparency = 1
				slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
				slider.BorderSizePixel = 0
				slider.Position = UDim2.fromScale(0.233, 0.218)
				slider.Size = UDim2.fromOffset(175, 25)

				local uICorner17 = Instance.new("UICorner")
				uICorner17.Name = "UICorner"
				uICorner17.CornerRadius = UDim.new(0, 6)
				uICorner17.Parent = slider

				local sliderEXT = Instance.new("TextLabel")
				sliderEXT.Name = "Slider_tEXT"
				sliderEXT.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
				sliderEXT.Text = options.title
				sliderEXT.TextColor3 = Color3.fromRGB(115, 115, 115)
				sliderEXT.TextScaled = true
				sliderEXT.TextSize = 12
				sliderEXT.TextWrapped = true
				sliderEXT.TextXAlignment = Enum.TextXAlignment.Left
				sliderEXT.BackgroundColor3 = Color3.fromRGB(151, 152, 152)
				sliderEXT.BackgroundTransparency = 1
				sliderEXT.BorderColor3 = Color3.fromRGB(0, 0, 0)
				sliderEXT.BorderSizePixel = 0
				sliderEXT.Position = UDim2.fromScale(0.0521, -0.0385)
				sliderEXT.Size = UDim2.fromOffset(62, 28)
				sliderEXT.Parent = slider

				local sliderBar = Instance.new("Frame")
				sliderBar.Name = "SliderBar"
				sliderBar.BackgroundColor3 = Color3.fromRGB(92, 92, 92)
				sliderBar.BackgroundTransparency = 0.2
				sliderBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
				sliderBar.BorderSizePixel = 0
				sliderBar.Position = UDim2.fromScale(0.566, 0.465)
				sliderBar.Size = UDim2.fromOffset(65, 2)

				local uICorner18 = Instance.new("UICorner")
				uICorner18.Name = "UICorner"
				uICorner18.CornerRadius = UDim.new(0, 6)
				uICorner18.Parent = sliderBar

				local indicator = Instance.new("Frame", sliderBar)
				indicator.Name = "Indicator"
				indicator.AnchorPoint = Vector2.new(0, 0.5)
				indicator.BackgroundColor3 = Color3.fromRGB(252, 252, 252)
				indicator.BorderSizePixel = 0
				indicator.Position = UDim2.fromScale(0, 0.465)
				indicator.Size = UDim2.fromOffset(10, 10)

				local uICorner = Instance.new("UICorner")
				uICorner.Name = "UICorner"
				uICorner.CornerRadius = UDim.new(1, 0)
				uICorner.Parent = indicator

				sliderBar.Parent = slider

				local sliderNumber = Instance.new("TextBox", slider)
				sliderNumber.Name = "Slider)number"
				sliderNumber.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
				sliderNumber.Text = "50"
				sliderNumber.TextColor3 = Color3.fromRGB(140, 140, 140)
				sliderNumber.TextSize = 12
				sliderNumber.Active = false
				sliderNumber.BackgroundColor3 = Color3.fromRGB(151, 152, 152)
				sliderNumber.BackgroundTransparency = 1
				sliderNumber.BorderColor3 = Color3.fromRGB(0, 0, 0)
				sliderNumber.BorderSizePixel = 0
				sliderNumber.Position = UDim2.fromScale(0.441, -0.0385)
				sliderNumber.Selectable = false
				sliderNumber.Size = UDim2.fromOffset(21, 28)

				local textButtoneeeeeee = Instance.new("TextButton", sliderBar)
				textButtoneeeeeee.Name = "TextButton"
				textButtoneeeeeee.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
				textButtoneeeeeee.Text = ""
				textButtoneeeeeee.TextColor3 = Color3.fromRGB(0, 0, 0)
				textButtoneeeeeee.TextSize = 14
				textButtoneeeeeee.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				textButtoneeeeeee.BackgroundTransparency = 1
				textButtoneeeeeee.BorderColor3 = Color3.fromRGB(0, 0, 0)
				textButtoneeeeeee.BorderSizePixel = 0
				textButtoneeeeeee.Position = UDim2.fromOffset(-2, -12)
				textButtoneeeeeee.Size = UDim2.fromScale(1.15, 14)

				function slidere:UpdateValue(dada)
					sliderNumber.Text = dada --Slider.suf

					local percent = 1 - (options.max - dada) / (options.max - options.min)
					ts:Create(
						indicator,
						TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
						{ Position = udim2New(0, percent * sliderBar.AbsoluteSize.X, 0.5, 0) }
					):Play()
					--indicator_Slider.Position = udim2New(0, percent  * Sliderframe.AbsoluteSize.X,0.5, 0)
				end

				function slidere:SetValue(value)
					if typeof(value) ~= "number" then
						return
					end
					options.default =
						math.clamp(math.round(options.default * Increment) / Increment, options.min, options.max)
					slidere:UpdateValue(value)
					options.callback(value)
				end

				slidere:SetValue(options.default)

				-- Logic

				local Holding = false

				textButtoneeeeeee.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Holding = true
						local pos = UDim2.new(
							math.clamp(
								(input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X,
								0,
								1
							),
							-6,
							-1.30499995,
							0
						)

						local SliderV = math.floor(
							((pos.X.Scale * options.max) / options.max) * (options.max - options.min) + options.min
						)
						print(SliderV)
						slidere:SetValue(SliderV)
					end
				end)

				textButtoneeeeeee.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement and Holding == true then
						local pos = UDim2.new(
							math.clamp(
								(input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X,
								0,
								1
							),
							-6,
							-1.30499995,
							0
						)

						local SliderV = math.floor(
							((pos.X.Scale * options.max) / options.max) * (options.max - options.min) + options.min
						)
						slidere:SetValue(SliderV)
					end
				end)
				textButtoneeeeeee.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and Holding == true then
						Holding = false
						local pos = UDim2.new(
							math.clamp(
								(input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X,
								0,
								1
							),
							-6,
							-1.30499995,
							0
						)

						local SliderV = math.floor(
							((pos.X.Scale * options.max) / options.max) * (options.max - options.min) + options.min
						)
						slidere:SetValue(SliderV)
					end
				end)

				sliderNumber.FocusLost:Connect(function(enterPressed)
					if enterPressed then
						local value = tonumber(sliderNumber.Text)
						if value then
							value = math.clamp(value, options.min, options.max)
							slidere:SetValue(value)
						else
							sliderNumber.Text = tostring(options.default) -- Reset to default if input is not a number
						end
					end
				end)
				return slidere
			end

			function sec:Dropdown(Info)
				local DropDown = {}
				local Info = Info or {}
				local Dropdown_visible = false
				local list = Info.List or Info.list or Info.Table or Info.table or { "j'aime", "lorelia <3" }
				local dropdown_Title = Info.Title
					or Info.title
					or Info.text
					or Info.Text
					or Info.Name
					or Info.name
					or "LORELIA JE L'AIME"
				local Default = Info.Default or Info.default or "j'aime"
				local Multi_dropdown = Info.Multi or Info.multi or false
				local callback = Info.Callback or Info.callback or function() end

				local dropdown = Instance.new("Frame", section1)
				dropdown.Name = "Dropdown"
				dropdown.BackgroundColor3 = Color3.fromRGB(35, 0, 1)
				dropdown.BackgroundTransparency = 1
				dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
				dropdown.BorderSizePixel = 0
				dropdown.Position = UDim2.fromScale(0, 0.437)
				dropdown.Size = UDim2.fromOffset(170, 26)

				local uICorner = Instance.new("UICorner")
				uICorner.Name = "UICorner"
				uICorner.CornerRadius = UDim.new(0, 6)
				uICorner.Parent = dropdown

				local dropdownHolder = Instance.new("Frame", dropdown)
				dropdownHolder.Name = "dropdown_holder"
				dropdownHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				dropdownHolder.BackgroundTransparency = 0.65
				dropdownHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				dropdownHolder.BorderSizePixel = 0
				dropdownHolder.Position = UDim2.fromScale(0.0294, 0)
				dropdownHolder.Size = UDim2.fromOffset(160, 22)

				local uICorner1 = Instance.new("UICorner")
				uICorner1.Name = "UICorner"
				uICorner1.CornerRadius = UDim.new(0, 4)
				uICorner1.Parent = dropdownHolder

				local uIStroke = Instance.new("UIStroke")
				uIStroke.Name = "UIStroke"
				uIStroke.Color = Color3.fromRGB(45, 45, 45)
				uIStroke.Parent = dropdownHolder

				local scrollingFrame = Instance.new("ScrollingFrame", dropdownHolder)
				scrollingFrame.Name = "ScrollingFrame"
				scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
				scrollingFrame.ScrollBarThickness = 0
				scrollingFrame.Active = true
				scrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				scrollingFrame.BackgroundTransparency = 1
				scrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				scrollingFrame.Visible = false
				scrollingFrame.BorderSizePixel = 0
				scrollingFrame.Position = UDim2.fromScale(0, 0.17)
				scrollingFrame.Size = UDim2.fromOffset(160, 113)

				local uIListLayout = Instance.new("UIListLayout")
				uIListLayout.Name = "UIListLayout"
				uIListLayout.Padding = UDim.new(0, 4)
				uIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				uIListLayout.Parent = scrollingFrame

				local ddropdowntext = Instance.new("TextLabel")
				ddropdowntext.Name = "ddropdowntext"
				ddropdowntext.FontFace = Font.new("rbxassetid://12187365977")
				ddropdowntext.TextColor3 = Color3.fromRGB(115, 115, 115)
				ddropdowntext.TextSize = 12
				ddropdowntext.TextWrapped = true
				ddropdowntext.TextXAlignment = Enum.TextXAlignment.Left
				ddropdowntext.Active = true
				ddropdowntext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ddropdowntext.BackgroundTransparency = 1
				ddropdowntext.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ddropdowntext.BorderSizePixel = 0
				ddropdowntext.Position = UDim2.fromScale(0.0899, 0)
				ddropdowntext.Selectable = true
				ddropdowntext.Size = UDim2.fromOffset(130, 22)
				ddropdowntext.Parent = dropdown
				ddropdowntext.TextScaled = false

				local imageLabel = Instance.new("ImageLabel")
				imageLabel.Name = "ImageLabel"
				imageLabel.Image = "rbxassetid://16734945148"
				imageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				imageLabel.BackgroundTransparency = 1
				imageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				imageLabel.BorderSizePixel = 0
				imageLabel.Position = UDim2.new(1.006, 0, 0.219, 0) -- Set position with scale values
				imageLabel.Size = UDim2.fromOffset(12, 12)
				imageLabel.Parent = ddropdowntext -- Set the parent to the static frame

				for i, v in pairs(list) do
					if Multi_dropdown then
						ddropdowntext.Text = dropdown_Title .. " : " .. table.concat(Default, ", ")
					else
						ddropdowntext.Text = dropdown_Title .. ": " .. Default
					end
					local option1Choosed = Instance.new("Frame", scrollingFrame)
					option1Choosed.Name = tostring(v)
					option1Choosed.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					option1Choosed.BackgroundTransparency = 1
					option1Choosed.BorderColor3 = Color3.fromRGB(0, 0, 0)
					option1Choosed.BorderSizePixel = 0
					option1Choosed.Size = UDim2.new(1, 0, -0.00295, 22)

					local optionName = Instance.new("TextLabel")
					optionName.Name = "Option_name"
					optionName.FontFace = Font.new("rbxassetid://12187365977")
					optionName.Text = tostring(v)
					optionName.TextColor3 = Color3.fromRGB(115, 115, 115)
					optionName.TextSize = 12
					optionName.TextXAlignment = Enum.TextXAlignment.Left
					optionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					optionName.BackgroundTransparency = 1
					optionName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					optionName.BorderSizePixel = 0
					optionName.Position = UDim2.fromScale(0.0642, 0)
					optionName.Size = UDim2.fromOffset(130, 21)
					local uIPadding = Instance.new("UIPadding")
					uIPadding.Name = "UIPadding"
					uIPadding.PaddingTop = UDim.new(0, 2)
					uIPadding.Parent = optionName

					optionName.Parent = option1Choosed

					local thedetector = Instance.new("TextButton")
					thedetector.Name = "Dropdown_option_detector"
					thedetector.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
					thedetector.Text = ""
					thedetector.TextColor3 = Color3.fromRGB(151, 152, 152)
					thedetector.TextSize = 14
					thedetector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					thedetector.BackgroundTransparency = 1
					thedetector.BorderColor3 = Color3.fromRGB(0, 0, 0)
					thedetector.BorderSizePixel = 0
					thedetector.Size = UDim2.fromScale(1, 1)
					thedetector.Parent = option1Choosed

					if Multi_dropdown then
						if table.find(Default, v) then
							optionName.TextColor3 = Color3.fromRGB(255, 255, 255) -- Set default color to white
						else
							optionName.TextColor3 = Color3.fromRGB(115, 115, 115) -- Other options are gray
						end
					else
						if v == Default then
							optionName.TextColor3 = Color3.fromRGB(255, 255, 255) -- Set default color to white
						else
							optionName.TextColor3 = Color3.fromRGB(115, 115, 115) -- Other options are gray
						end
					end

					if Multi_dropdown then
						thedetector.MouseButton1Click:Connect(function()
							print("clicked?")
							if table.find(Default, v) then
								table.remove(Default, table.find(Default, v))
								optionName.TextColor3 = Color3.fromRGB(115, 115, 115) -- Unselected option color (gray)
								ddropdowntext.Text = dropdown_Title .. " : " .. table.concat(Default, ", ")
								callback(Default)
							else
								optionName.TextColor3 = Color3.fromRGB(255, 255, 255) -- Selected option color (white)
								table.insert(Default, v)
								ddropdowntext.Text = dropdown_Title .. " : " .. table.concat(Default, ", ")
								callback(Default)
							end
						end)
					else
						thedetector.MouseButton1Click:Connect(function()
							callback(v)
							ddropdowntext.Text = dropdown_Title .. ": " .. v
						end)
					end
				end

				local Dropdown_Detector = Instance.new("TextButton")
				Dropdown_Detector.Name = "Dropdown_detector"
				Dropdown_Detector.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
				Dropdown_Detector.Text = ""
				Dropdown_Detector.TextColor3 = Color3.fromRGB(151, 152, 152)
				Dropdown_Detector.TextSize = 14
				Dropdown_Detector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Dropdown_Detector.BackgroundTransparency = 1
				Dropdown_Detector.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Dropdown_Detector.BorderSizePixel = 0
				Dropdown_Detector.Size = UDim2.new(1, 0, -0.00295, 22)
				Dropdown_Detector.Parent = dropdown

				function DropDown:DropdownState()
					local tween1 = ts:Create(
						dropdown,
						TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{ Size = Dropdown_visible == true and UDim2.fromOffset(170, 25) or UDim2.fromOffset(170, 137) }
					)
					local tween2 = ts:Create(
						dropdownHolder,
						TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{ Size = Dropdown_visible == true and UDim2.fromOffset(160, 25) or UDim2.fromOffset(160, 137) }
					)

					tween1:Play()
					tween2:Play()

					local completedCount = 0

					local function checkCompleted()
						completedCount = completedCount + 1
						if completedCount >= 2 then
							Dropdown_visible = not Dropdown_visible
							scrollingFrame.Visible = Dropdown_visible
						end
					end

					tween1.Completed:Connect(checkCompleted)
					tween2.Completed:Connect(checkCompleted)
				end

				Dropdown_Detector.MouseButton1Click:Connect(function()
					DropDown:DropdownState()
				end)

				function DropDown:Clear()
					DropDown:DropdownState()

					local ignoreList = { ["Frame"] = true, ["UIListLayout"] = true }

					for _, child in ipairs(scrollingFrame:GetChildren()) do
						if not ignoreList[child.Name] then
							child:Destroy()
						end
					end

					ddropdowntext.Text = dropdown_Title .. ": rien lorelia ma femme"

					for k in pairs(Default) do
						Default[k] = nil
					end
				end

				function DropDown:Add(v)
					local newitem = Instance.new("Frame", scrollingFrame)
					newitem.Name = tostring(v)
					newitem.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					newitem.BackgroundTransparency = 1
					newitem.BorderColor3 = Color3.fromRGB(0, 0, 0)
					newitem.BorderSizePixel = 0
					newitem.Size = UDim2.new(1, 0, -0.00295, 22)

					local dropdownoptiontexte = Instance.new("TextLabel")
					dropdownoptiontexte.Name = "Option_name"
					dropdownoptiontexte.FontFace = Font.new("rbxassetid://12187365977")
					dropdownoptiontexte.Text = tostring(v)
					dropdownoptiontexte.TextColor3 = Color3.fromRGB(115, 115, 115)
					dropdownoptiontexte.TextSize = 12
					dropdownoptiontexte.TextXAlignment = Enum.TextXAlignment.Left
					dropdownoptiontexte.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					dropdownoptiontexte.BackgroundTransparency = 1
					dropdownoptiontexte.BorderColor3 = Color3.fromRGB(0, 0, 0)
					dropdownoptiontexte.BorderSizePixel = 0
					dropdownoptiontexte.Position = UDim2.fromScale(0.0642, 0)
					dropdownoptiontexte.Size = UDim2.fromOffset(130, 21)

					local uIPadding = Instance.new("UIPadding")
					uIPadding.Name = "UIPadding"
					uIPadding.PaddingTop = UDim.new(0, 2)
					uIPadding.Parent = dropdownoptiontexte

					dropdownoptiontexte.Parent = newitem

					local thedetector23 = Instance.new("TextButton")
					thedetector23.Name = "Dropdown_option_detector"
					thedetector23.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
					thedetector23.Text = ""
					thedetector23.TextColor3 = Color3.fromRGB(151, 152, 152)
					thedetector23.TextSize = 14
					thedetector23.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					thedetector23.BackgroundTransparency = 1
					thedetector23.BorderColor3 = Color3.fromRGB(0, 0, 0)
					thedetector23.BorderSizePixel = 0
					thedetector23.Size = UDim2.fromScale(1, 1)
					thedetector23.Parent = newitem

					if Multi_dropdown then
						thedetector23.MouseButton1Click:Connect(function()
							if table.find(Default, v) then
								table.remove(Default, table.find(Default, v))
								dropdownoptiontexte.TextColor3 = Color3.fromRGB(255, 255, 255) -- Selected option color (white)
								ddropdowntext.Text = dropdown_Title .. " : " .. table.concat(Default, ", ")
								callback(Default)
							else
								dropdownoptiontexte.TextColor3 = Color3.fromRGB(115, 115, 115) -- Unselected option color (gray)
								table.insert(Default, v)
								ddropdowntext.Text = dropdown_Title .. " : " .. table.concat(Default, ", ")
								callback(Default)
							end
						end)
					else
						thedetector23.MouseButton1Click:Connect(function()
							callback(v)
							ddropdowntext.Text = dropdown_Title .. ": " .. v
						end)
					end
				end
				return DropDown
			end
			function sec:Keybind(Info)
				local KEYBIND = {}
				local Info = Info or {}
				local Flag = Info.Flag or Info.flag or Info.Pointer or Info.pointer
				local Mode = Info.Mode or Info.mode or "Toggle"
				local keybind_default = Info.Default or Info.default or Info.Def or Info.def or Enum.KeyCode.Q
				local Keybind_Title = Info.Title
					or Info.title
					or Info.Text
					or Info.text
					or Info.Name
					or Info.name
					or "keybind"
				local callback = Info.Callback or Info.callback or function() end
				local Keybinding, Holding, keybindValue = false, false, false
				local holdmode = Mode == "Hold" and true or false
				local togglemode = Mode == "Toggle" and true or false
				local Buttonmode = Mode == "Button" and true or false
				local short_keybind_names = {
					["MouseButton1"] = "MB1",
					["MouseButton2"] = "MB2",
					["MouseButton3"] = "MB3",
					["Insert"] = "INS",
					["LeftAlt"] = "LALT",
					["LeftControl"] = "LC",
					["LeftShift"] = "LS",
					["RightAlt"] = "RALT",
					["RightControl"] = "RC",
					["RightShift"] = "RS",
					["CapsLock"] = "CAPS",
					["Return"] = "RET",
					["Backspace"] = "BSP",
					["BackSlash"] = "BS",
				}
				local WhitelistedMouse = {
					Enum.UserInputType.MouseButton1,
					Enum.UserInputType.MouseButton2,
					Enum.UserInputType.MouseButton3,
				}
				local BlacklistedKeys = {
					Enum.KeyCode.Unknown,
					Enum.KeyCode.W,
					Enum.KeyCode.A,
					Enum.KeyCode.S,
					Enum.KeyCode.D,
					Enum.KeyCode.Up,
					Enum.KeyCode.Left,
					Enum.KeyCode.Down,
					Enum.KeyCode.Right,
					Enum.KeyCode.Slash,
					Enum.KeyCode.Tab,
					Enum.KeyCode.Backspace,
					Enum.KeyCode.Escape,
				}

				local keeybind = Instance.new("Frame", section1)
				keeybind.Name = Keybind_Title
				keeybind.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				keeybind.BackgroundTransparency = 0.65
				keeybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
				keeybind.BorderSizePixel = 0
				keeybind.Position = UDim2.fromScale(0.0278, 0.558)
				keeybind.Size = UDim2.fromOffset(160, 26)

				local uICorner = Instance.new("UICorner")
				uICorner.Name = "UICorner"
				uICorner.CornerRadius = UDim.new(0, 4)
				uICorner.Parent = keeybind

				local uIStroke = Instance.new("UIStroke")
				uIStroke.Name = "UIStroke"
				uIStroke.Color = Color3.fromRGB(45, 45, 45)
				uIStroke.Parent = keeybind

				local buttonn = Instance.new("TextLabel")
				buttonn.Name = "buttonn"
				buttonn.FontFace = Font.new("rbxassetid://12187365977")
				buttonn.Text = Keybind_Title
				buttonn.TextColor3 = Color3.fromRGB(115, 115, 115)
				buttonn.TextSize = 11
				buttonn.TextXAlignment = Enum.TextXAlignment.Left
				buttonn.Active = true
				buttonn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				buttonn.BackgroundTransparency = 1
				buttonn.BorderColor3 = Color3.fromRGB(0, 0, 0)
				buttonn.BorderSizePixel = 0
				buttonn.Position = UDim2.fromScale(0.01, 0)
				buttonn.Selectable = true
				buttonn.Size = UDim2.fromScale(0.699, 1)

				local uIPadding = Instance.new("UIPadding")
				uIPadding.Name = "UIPadding"
				uIPadding.PaddingLeft = UDim.new(0, 8)
				uIPadding.Parent = buttonn

				buttonn.Parent = keeybind

				local buttonn1 = Instance.new("TextButton")
				buttonn1.Name = "buttonn"
				buttonn1.FontFace = Font.new("rbxassetid://12187365977")
				buttonn1.Text = "None"
				buttonn1.TextScaled = false
				buttonn1.TextColor3 = Color3.fromRGB(115, 115, 115)
				buttonn1.TextSize = 12
				buttonn1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				buttonn1.BackgroundTransparency = 1
				buttonn1.BorderColor3 = Color3.fromRGB(0, 0, 0)
				buttonn1.BorderSizePixel = 0
				buttonn1.Position = UDim2.fromScale(0.706, 0)
				buttonn1.Size = UDim2.fromScale(0.294, 1)
				buttonn1.Parent = keeybind

				function KEYBIND.CheckKey(self, tab, key)
					for i, v in next, tab do
						if v == key then
							return true
						end
					end
				end
				function KEYBIND:Setkey(Key)
					Keybinding = false

					local keybind_default_text = tostring(Key.Name) or tostring(keybind_default.Name)
					keybind_default = Key.Name
					buttonn1.Text = Key.Name
				end
				KEYBIND:Setkey(keybind_default)

				buttonn1.MouseButton1Click:Connect(function()
					if Keybinding ~= true then
						Keybinding = true
						buttonn1.Text = "waiting"
					end
				end)

				utility:Connect(uis.InputBegan, function(Input)
					if
						(Input.KeyCode.Name == keybind_default or Input.UserInputType.Name == keybind_default)
						and not Keybinding
					then
						if holdmode then
							Holding = true
							callback(Holding)
						elseif not Keybinding and togglemode then
							keybindValue = not keybindValue
							callback(keybindValue)
						end
					elseif Keybinding then
						local key
						pcall(function()
							if not KEYBIND:CheckKey(BlacklistedKeys, Input.KeyCode) then
								key = Input.KeyCode
							end
						end)
						pcall(function()
							if KEYBIND:CheckKey(WhitelistedMouse, Input.UserInputType) and not key then
								key = Input.UserInputType
							end
						end)
						key = key or keybind_default
						KEYBIND:Setkey(key)
					end
				end)

				utility:Connect(uis.InputEnded, function(Input)
					if Input.KeyCode.Name == keybind_default or Input.UserInputType.Name == keybind_default then
						if holdmode and Holding then
							Holding = false
							callback(Holding)
						end
					end
				end)
				utility:Connect(uis.InputEnded, function(Input)
					if Input.KeyCode.Name == keybind_default or Input.UserInputType.Name == keybind_default then
						if Buttonmode then
							callback()
						end
					end
				end)
				return KEYBIND
			end

			function sec:Textbox(Info)
				local tExtbox = {}
				local Info = Info or {}
				local Textbox_default = Info.Default or Info.default or Info.Def or Info.def or "Text"
				local Textbox_Title = Info.Title
					or Info.title
					or Info.Text
					or Info.text
					or Info.Name
					or Info.name
					or "Textbox"

				local textbox = Instance.new("Frame", section1)
				textbox.Name = Textbox_Title
				textbox.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
				textbox.BackgroundTransparency = 1
				textbox.BorderColor3 = Color3.fromRGB(0, 0, 0)
				textbox.BorderSizePixel = 0
				textbox.Position = UDim2.fromScale(0.0278, 0.558)
				textbox.Size = UDim2.fromOffset(160, 45)

				local textboxframe = Instance.new("Frame")
				textboxframe.Name = "textboxframe"
				textboxframe.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				textboxframe.BackgroundTransparency = 0.65
				textboxframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
				textboxframe.BorderSizePixel = 0
				textboxframe.Position = UDim2.fromScale(0, 0.4)
				textboxframe.Size = UDim2.fromOffset(160, 25)

				local uIStroke = Instance.new("UIStroke")
				uIStroke.Name = "UIStroke"
				uIStroke.Color = Color3.fromRGB(45, 45, 45)
				uIStroke.Parent = textboxframe

				local uICorner = Instance.new("UICorner")
				uICorner.Name = "UICorner"
				uICorner.CornerRadius = UDim.new(0, 4)
				uICorner.Parent = textboxframe

				local textbxoxx = Instance.new("TextBox")
				textbxoxx.Name = "textbxoxx"
				textbxoxx.FontFace = Font.new("rbxassetid://12187365977")
				textbxoxx.Text = Textbox_default
				textbxoxx.TextColor3 = Color3.fromRGB(115, 115, 115)
				textbxoxx.TextSize = 11
				textbxoxx.TextXAlignment = Enum.TextXAlignment.Left
				textbxoxx.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				textbxoxx.BackgroundTransparency = 1
				textbxoxx.BorderColor3 = Color3.fromRGB(0, 0, 0)
				textbxoxx.BorderSizePixel = 0
				textbxoxx.Position = UDim2.fromScale(-0.00625, 0)
				textbxoxx.Size = UDim2.fromScale(1.01, 1)

				local uIPadding = Instance.new("UIPadding")
				uIPadding.Name = "UIPadding"
				uIPadding.PaddingLeft = UDim.new(0, 8)
				uIPadding.Parent = textbxoxx

				textbxoxx.Parent = textboxframe

				textboxframe.Parent = textbox

				local textboxtitle = Instance.new("TextLabel")
				textboxtitle.Name = "textboxtitle"
				textboxtitle.FontFace = Font.new("rbxassetid://12187365977")
				textboxtitle.Text = Textbox_Title
				textboxtitle.TextColor3 = Color3.fromRGB(115, 115, 115)
				textboxtitle.TextSize = 12
				textboxtitle.TextXAlignment = Enum.TextXAlignment.Left
				textboxtitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				textboxtitle.BackgroundTransparency = 1
				textboxtitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				textboxtitle.BorderSizePixel = 0
				textboxtitle.Size = UDim2.fromOffset(160, 15)

				local uIPadding1 = Instance.new("UIPadding")
				uIPadding1.Name = "UIPadding"
				uIPadding1.PaddingLeft = UDim.new(0, 4)
				uIPadding1.Parent = textboxtitle

				textboxtitle.Parent = textbox

				textbxoxx.FocusLost:Connect(function()
					local Textbox_callback = Info.Callback or Info.callback or function() end

					local Textbox_callback = textbxoxx.Text
				end)

				return tExtbox
			end

			function sec:Colorpicker(Info)
				local Info = Info or {}
				local Val = Info.Value or Info.value or Info.Val or Info.val or Color3.fromRGB(255, 255, 255)
				local colorpicker_title = Info.Title
					or Info.title
					or Info.text
					or Info.Text
					or Info.Name
					or Info.name
					or "what a sigma"
				local CallBack = Info.Callback or Info.callback or function() end

				local colorpicker = Instance.new("Frame", section1)
				colorpicker.Name = colorpicker_title
				colorpicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				colorpicker.BackgroundTransparency = 1
				colorpicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
				colorpicker.BorderSizePixel = 0
				colorpicker.Position = UDim2.fromScale(0.0139, 0.431)
				colorpicker.Size = UDim2.fromOffset(175, 30)

				local imageButtone = Instance.new("ImageButton", colorpicker)
				imageButtone.Name = "ImageButton"
				imageButtone.Transparency = 1
				imageButtone.ImageTransparency = 1
				imageButtone.BackgroundTransparency = 1
				imageButtone.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
				imageButtone.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				imageButtone.BorderColor3 = Color3.fromRGB(0, 0, 0)
				imageButtone.BorderSizePixel = 0
				imageButtone.Position = UDim2.fromScale(0, 0)
				imageButtone.Size = UDim2.fromOffset(175, 30)

				local colorpickerName = Instance.new("TextLabel")
				colorpickerName.Name = "Colorpicker_name"
				colorpickerName.FontFace = Font.new("rbxassetid://12187365977")
				colorpickerName.Text = colorpicker_title
				colorpickerName.TextColor3 = Color3.fromRGB(115, 115, 115)
				colorpickerName.TextSize = 12
				colorpickerName.TextWrapped = true
				colorpickerName.TextXAlignment = Enum.TextXAlignment.Left
				colorpickerName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				colorpickerName.BackgroundTransparency = 1
				colorpickerName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				colorpickerName.BorderSizePixel = 0
				colorpickerName.Position = UDim2.fromScale(0.05, 0)
				colorpickerName.Size = UDim2.fromOffset(136, 26)

				local buckett = Instance.new("ImageLabel")
				buckett.Name = "buckett"
				buckett.Image = "rbxassetid://17752884237"
				buckett.BackgroundColor3 = Val
				buckett.BackgroundTransparency = 1
				buckett.BorderColor3 = Color3.fromRGB(0, 0, 0)
				buckett.ImageColor3 = Val
				buckett.BorderSizePixel = 0
				buckett.Position = UDim2.fromScale(1.02, 0.154)
				buckett.Size = UDim2.fromOffset(18, 18)
				buckett.Parent = colorpickerName

				colorpickerName.Parent = colorpicker

				local hUESelection = Instance.new("ImageButton")
				hUESelection.Name = "HUE_selection"
				hUESelection.Image = "rbxassetid://11970136481"
				hUESelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				hUESelection.BorderColor3 = Color3.fromRGB(50, 50, 50)
				hUESelection.Position = UDim2.fromScale(0.832, 0.181)
				hUESelection.Size = UDim2.fromOffset(15, 107)

				local Hslider = Instance.new("Frame")
				Hslider.Name = "Slider"
				Hslider.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
				Hslider.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Hslider.Position = UDim2.fromScale(-0.133, -0.00935)
				Hslider.Size = UDim2.fromOffset(19, 3)
				Hslider.Parent = hUESelection

				hUESelection.Parent = colorpicker

				local uhmcolorpic = Instance.new("Frame")
				uhmcolorpic.Name = "uhmcolorpic"
				uhmcolorpic.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				uhmcolorpic.BackgroundTransparency = 0.65
				uhmcolorpic.BorderColor3 = Color3.fromRGB(0, 0, 0)
				uhmcolorpic.BorderSizePixel = 0
				uhmcolorpic.Position = UDim2.fromScale(0.354, 0.828)
				uhmcolorpic.Size = UDim2.fromOffset(50, 20)
				uhmcolorpic.ZIndex = 45

				local colorpicekrvalue = Instance.new("TextLabel")
				colorpicekrvalue.Name = "colorpicekrvalue"
				colorpicekrvalue.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
				colorpicekrvalue.Text = "1,1,1"
				colorpicekrvalue.TextColor3 = Color3.fromRGB(216, 216, 216)
				colorpicekrvalue.TextSize = 12
				colorpicekrvalue.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
				colorpicekrvalue.BackgroundTransparency = 1
				colorpicekrvalue.BorderColor3 = Color3.fromRGB(0, 0, 0)
				colorpicekrvalue.BorderSizePixel = 0
				colorpicekrvalue.Size = UDim2.fromScale(1, 1)
				colorpicekrvalue.Parent = uhmcolorpic

				colorpicekrvalue:GetPropertyChangedSignal("Text"):Connect(function()
					-- Get the size of the text
					local textSize = colorpicekrvalue.TextBounds

					-- Set the size of the frame based on the size of the text
					uhmcolorpic.Size = UDim2.new(0, textSize.X + 10, 0, textSize.Y + 10) -- Add some padding
				end)

				local uICorner = Instance.new("UICorner")
				uICorner.Name = "UICorner"
				uICorner.CornerRadius = UDim.new(0, 6)
				uICorner.Parent = uhmcolorpic

				local uIStroke = Instance.new("UIStroke")
				uIStroke.Name = "UIStroke"
				uIStroke.Color = Color3.fromRGB(42, 42, 42)
				uIStroke.Parent = uhmcolorpic

				uhmcolorpic.Parent = colorpicker

				local sVSeEction = Instance.new("ImageButton")
				sVSeEction.Name = "SV_se;ection"
				sVSeEction.Image = "rbxassetid://11970108040"
				sVSeEction.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
				sVSeEction.BorderColor3 = Color3.fromRGB(50, 50, 50)
				sVSeEction.Position = UDim2.fromScale(0.052, 0.181)
				sVSeEction.Size = UDim2.fromOffset(125, 107)

				local sVSlider = Instance.new("Frame")
				sVSlider.Name = "SV_slider"
				sVSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				sVSlider.BackgroundTransparency = 1
				sVSlider.Position = UDim2.fromScale(0.961, 0.0187)
				sVSlider.Size = UDim2.fromOffset(7, 7)

				local uICorner1 = Instance.new("UICorner")
				uICorner1.Name = "UICorner"
				uICorner1.CornerRadius = UDim.new(0, 100)
				uICorner1.Parent = sVSlider

				local uIStroke1 = Instance.new("UIStroke")
				uIStroke1.Name = "UIStroke"
				uIStroke1.Color = Color3.fromRGB(255, 255, 255)
				uIStroke1.Parent = sVSlider

				uhmcolorpic.Visible = false
				hUESelection.Visible = false
				sVSeEction.Visible = false
				sVSlider.Visible = false
				sVSlider.Parent = sVSeEction

				sVSeEction.Parent = colorpicker

				local Colorpic = {}

				function Colorpic:openColorpicker()
					uhmcolorpic.Visible = true
					hUESelection.Visible = true
					sVSeEction.Visible = true
					sVSlider.Visible = true

					ts:Create(
						colorpickerName,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ TextColor3 = Color3.fromRGB(255, 255, 255) }
					):Play()
					ts:Create(
						colorpicker,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ Size = UDim2.fromOffset(175, 173) }
					):Play()
				end

				function Colorpic:Closecolorpicker()
					uhmcolorpic.Visible = false
					hUESelection.Visible = false
					sVSeEction.Visible = false
					sVSlider.Visible = false

					ts:Create(
						colorpickerName,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ TextColor3 = Color3.fromRGB(115, 115, 115) }
					):Play()
					ts:Create(
						colorpicker,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
						{ Size = UDim2.fromOffset(175, 30) }
					):Play()
				end

				imageButtone.MouseButton1Click:Connect(function()
					if uhmcolorpic.Visible == false then
						Colorpic:openColorpicker()
					else
						Colorpic:Closecolorpicker()
					end
				end)
				local ColorH = 1
					- (
						math.clamp(
							Hslider.AbsolutePosition.Y - hUESelection.AbsolutePosition.Y,
							0,
							hUESelection.AbsoluteSize.Y
						) / hUESelection.AbsoluteSize.Y
					)
				local ColorS = (
					math.clamp(
						sVSlider.AbsolutePosition.X - sVSeEction.AbsolutePosition.X,
						0,
						sVSeEction.AbsoluteSize.X
					) / sVSeEction.AbsoluteSize.X
				)
				local ColorV = 1
					- (
						math.clamp(
							sVSlider.AbsolutePosition.Y - sVSeEction.AbsolutePosition.Y,
							0,
							sVSeEction.AbsoluteSize.Y
						) / sVSeEction.AbsoluteSize.Y
					)

				function Colorpic:UpdateColorPicker()
					if uhmcolorpic.Visible == true then
						buckett.ImageColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
						local R, G, B = utility:ToRGB(buckett.ImageColor3)
						sVSeEction.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
						colorpicekrvalue.Text = tostring(math.floor(R))
							.. ","
							.. tostring(math.floor(G))
							.. ","
							.. tostring(math.floor(B))
						-- sVSeEction.BackgroundColor3 =  Color3.fromHSV(ColorH, ColorS, 1 )
						-- local R,G,B = ColorH:ToHex()
						--  local HEX = Colorpickerpreview.BackgroundColor3:ToHex()

						CallBack(buckett.ImageColor3)
					end
				end
				ColorH = 1
					- (
						math.clamp(
							Hslider.AbsolutePosition.Y - hUESelection.AbsolutePosition.Y,
							0,
							hUESelection.AbsoluteSize.Y
						) / hUESelection.AbsoluteSize.Y
					)
				ColorS = (
					math.clamp(
						sVSlider.AbsolutePosition.X - sVSeEction.AbsolutePosition.X,
						0,
						sVSeEction.AbsoluteSize.X
					) / sVSeEction.AbsoluteSize.X
				)
				ColorV = 1
					- (
						math.clamp(
							sVSlider.AbsolutePosition.Y - sVSeEction.AbsolutePosition.Y,
							0,
							sVSeEction.AbsoluteSize.Y
						) / sVSeEction.AbsoluteSize.Y
					)

				local ColorInput, HueInput

				sVSeEction.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						ColorInput = rs.RenderStepped:Connect(function()
							local ColorX = (
								math.clamp(Mouse.X - sVSeEction.AbsolutePosition.X, 0, sVSeEction.AbsoluteSize.X)
								/ sVSeEction.AbsoluteSize.X
							)
							local ColorY = (
								math.clamp(Mouse.Y - sVSeEction.AbsolutePosition.Y, 0, sVSeEction.AbsoluteSize.Y)
								/ sVSeEction.AbsoluteSize.Y
							)
							sVSlider.Position = UDim2.new(ColorX, 0, ColorY, 0)
							ColorS = ColorX
							ColorV = 1 - ColorY
							Colorpic:UpdateColorPicker()
							task.wait(0.1) -- Add a small delay
						end)
					end
				end)

				sVSeEction.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and ColorInput then
						ColorInput:Disconnect()
						ColorInput = nil
					end
				end)

				hUESelection.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						HueInput = rs.RenderStepped:Connect(function()
							local HueY = (
								math.clamp(Mouse.Y - hUESelection.AbsolutePosition.Y, 0, hUESelection.AbsoluteSize.Y)
								/ hUESelection.AbsoluteSize.Y
							)
							Hslider.Position = UDim2.new(-0.133, 0, HueY, 0)
							ColorH = HueY
							Colorpic:UpdateColorPicker()
							task.wait(0.1) -- Add a small delay
						end)
					end
				end)

				hUESelection.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and HueInput then
						HueInput:Disconnect()
						HueInput = nil
					end
				end)

				buckett.ImageColor3 = Val
				CallBack(buckett.ImageColor3)
			end

			return sec
		end
		return tab
	end

	-- // blurring dont touch

	local RunService = game:GetService("RunService")
	local camera = workspace.CurrentCamera
	local MTREL = "Glass"
	local binds = {}
	local root = Instance.new("Folder", camera)
	root.Name = "BlurSnox"

	local gTokenMH = 99999999
	local gToken = math.random(1, gTokenMH)

	local DepthOfField = Instance.new("DepthOfFieldEffect", game:GetService("Lighting"))
	DepthOfField.FarIntensity = 0
	DepthOfField.FocusDistance = 51.6
	DepthOfField.InFocusRadius = 50
	DepthOfField.NearIntensity = 1
	DepthOfField.Name = "DPT_" .. gToken

	local frame = Instance.new("Frame")
	frame.Parent = mainFrame
	frame.Size = UDim2.new(0.95, 0, 0.95, 0)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundTransparency = 1

	local GenUid
	do -- Generate unique names for RenderStepped bindings
		local id = 0
		function GenUid()
			id = id + 1
			return "neon::" .. tostring(id)
		end
	end

	do
		local function IsNotNaN(x)
			return x == x
		end
		local continue = IsNotNaN(camera:ScreenPointToRay(0, 0).Origin.x)
		while not continue do
			RunService.RenderStepped:wait()
			continue = IsNotNaN(camera:ScreenPointToRay(0, 0).Origin.x)
		end
	end

	local DrawQuad
	do
		local acos, max, pi, sqrt = math.acos, math.max, math.pi, math.sqrt
		local sz = 0.2

		function DrawTriangle(v1, v2, v3, p0, p1) -- I think Stravant wrote this function
			local s1 = (v1 - v2).magnitude
			local s2 = (v2 - v3).magnitude
			local s3 = (v3 - v1).magnitude
			local smax = max(s1, s2, s3)
			local A, B, C
			if s1 == smax then
				A, B, C = v1, v2, v3
			elseif s2 == smax then
				A, B, C = v2, v3, v1
			elseif s3 == smax then
				A, B, C = v3, v1, v2
			end

			local para = ((B - A).x * (C - A).x + (B - A).y * (C - A).y + (B - A).z * (C - A).z) / (A - B).magnitude
			local perp = sqrt((C - A).magnitude ^ 2 - para * para)
			local dif_para = (A - B).magnitude - para

			local st = CFrame.new(B, A)
			local za = CFrame.Angles(pi / 2, 0, 0)

			local cf0 = st

			local Top_Look = (cf0 * za).lookVector
			local Mid_Point = A + CFrame.new(A, B).lookVector * para
			local Needed_Look = CFrame.new(Mid_Point, C).lookVector
			local dot = Top_Look.x * Needed_Look.x + Top_Look.y * Needed_Look.y + Top_Look.z * Needed_Look.z

			local ac = CFrame.Angles(0, 0, acos(dot))

			cf0 = cf0 * ac
			if ((cf0 * za).lookVector - Needed_Look).magnitude > 0.01 then
				cf0 = cf0 * CFrame.Angles(0, 0, -2 * acos(dot))
			end
			cf0 = cf0 * CFrame.new(0, perp / 2, -(dif_para + para / 2))

			local cf1 = st * ac * CFrame.Angles(0, pi, 0)
			if ((cf1 * za).lookVector - Needed_Look).magnitude > 0.01 then
				cf1 = cf1 * CFrame.Angles(0, 0, 2 * acos(dot))
			end
			cf1 = cf1 * CFrame.new(0, perp / 2, dif_para / 2)

			if not p0 then
				p0 = Instance.new("Part")
				p0.FormFactor = "Custom"
				p0.TopSurface = 0
				p0.BottomSurface = 0
				p0.Anchored = true
				p0.CanCollide = false
				p0.CastShadow = false
				p0.Material = MTREL
				p0.Size = Vector3.new(sz, sz, sz)
				local mesh = Instance.new("SpecialMesh", p0)
				mesh.MeshType = 2
				mesh.Name = "WedgeMesh"
			end
			p0.WedgeMesh.Scale = Vector3.new(0, perp / sz, para / sz)
			p0.CFrame = cf0

			if not p1 then
				p1 = p0:clone()
			end
			p1.WedgeMesh.Scale = Vector3.new(0, perp / sz, dif_para / sz)
			p1.CFrame = cf1

			return p0, p1
		end

		function DrawQuad(v1, v2, v3, v4, parts)
			parts[1], parts[2] = DrawTriangle(v1, v2, v3, parts[1], parts[2])
			parts[3], parts[4] = DrawTriangle(v3, v2, v4, parts[3], parts[4])
		end
	end

	if binds[frame] then
		return binds[frame].parts
	end

	local uid = GenUid()
	local parts = {}
	local f = Instance.new("Folder", root)
	f.Name = frame.Name

	local parents = {}
	do
		local function add(child)
			if child:IsA("GuiObject") then
				parents[#parents + 1] = child
				add(child.Parent)
			end
		end
		add(frame)
	end

	local function UpdateOrientation(fetchProps)
		local properties = {
			Transparency = 0.98,
			BrickColor = BrickColor.new("Institutional white"),
		}
		local zIndex = 1 - 0.05 * frame.ZIndex

		local tl, br = frame.AbsolutePosition, frame.AbsolutePosition + frame.AbsoluteSize
		local tr, bl = Vector2.new(br.x, tl.y), Vector2.new(tl.x, br.y)
		do
			local rot = 0
			for _, v in ipairs(parents) do
				rot = rot + v.Rotation
			end
			if rot ~= 0 and rot % 180 ~= 0 then
				local mid = tl:lerp(br, 0.5)
				local s, c = math.sin(math.rad(rot)), math.cos(math.rad(rot))
				local vec = tl
				tl = Vector2.new(c * (tl.x - mid.x) - s * (tl.y - mid.y), s * (tl.x - mid.x) + c * (tl.y - mid.y)) + mid
				tr = Vector2.new(c * (tr.x - mid.x) - s * (tr.y - mid.y), s * (tr.x - mid.x) + c * (tr.y - mid.y)) + mid
				bl = Vector2.new(c * (bl.x - mid.x) - s * (bl.y - mid.y), s * (bl.x - mid.x) + c * (bl.y - mid.y)) + mid
				br = Vector2.new(c * (br.x - mid.x) - s * (br.y - mid.y), s * (br.x - mid.x) + c * (br.y - mid.y)) + mid
			end
		end
		DrawQuad(
			camera:ScreenPointToRay(tl.x, tl.y, zIndex).Origin,
			camera:ScreenPointToRay(tr.x, tr.y, zIndex).Origin,
			camera:ScreenPointToRay(bl.x, bl.y, zIndex).Origin,
			camera:ScreenPointToRay(br.x, br.y, zIndex).Origin,
			parts
		)
		if fetchProps then
			for _, pt in pairs(parts) do
				pt.Parent = f
			end
			for propName, propValue in pairs(properties) do
				for _, pt in pairs(parts) do
					pt[propName] = propValue
				end
			end
		end
	end

	UpdateOrientation(true)
	RunService:BindToRenderStep(uid, 2000, UpdateOrientation)
	return brennen
end
