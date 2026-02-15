-- Akame Menu with Watermark (toggle with Right Shift)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local aimbotEnabled = false
local AIM_BUTTON = Enum.UserInputType.MouseButton2
local TARGET_PART = "Head"
local MAX_DISTANCE = 1000
local menuVisible = true
local connection = nil
local fps = 60
local ping = 0

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AkameMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main menu frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 140)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -70)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 6)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "AKAME MENU"
title.TextColor3 = Color3.fromRGB(220, 40, 40)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = titleBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 2.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.ZIndex = 20
closeBtn.Parent = titleBar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

-- Aimbot toggle
local toggleContainer = Instance.new("Frame")
toggleContainer.Size = UDim2.new(1, -20, 0, 45)
toggleContainer.Position = UDim2.new(0, 10, 0, 45)
toggleContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
toggleContainer.BorderSizePixel = 0
toggleContainer.Parent = mainFrame
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleContainer

local toggleLabel = Instance.new("TextLabel")
toggleLabel.Size = UDim2.new(0.6, -10, 1, 0)
toggleLabel.Position = UDim2.new(0, 12, 0, 0)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Text = "AIMBOT"
toggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
toggleLabel.Font = Enum.Font.GothamSemibold
toggleLabel.TextSize = 15
toggleLabel.Parent = toggleContainer

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 28)
toggleBtn.Position = UDim2.new(1, -70, 0.5, -14)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 13
toggleBtn.Parent = toggleContainer
local toggleBtnCorner = Instance.new("UICorner")
toggleBtnCorner.CornerRadius = UDim.new(0, 4)
toggleBtnCorner.Parent = toggleBtn

local function updateToggle()
    if aimbotEnabled then
        toggleBtn.Text = "ON"
        toggleBtn.TextColor3 = Color3.fromRGB(80, 255, 80)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    else
        toggleBtn.Text = "OFF"
        toggleBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    updateToggle()
end)
updateToggle()

-- Hint
local hintLabel = Instance.new("TextLabel")
hintLabel.Size = UDim2.new(1, -20, 0, 20)
hintLabel.Position = UDim2.new(0, 10, 0, 100)
hintLabel.BackgroundTransparency = 1
hintLabel.Text = "Right Shift toggles menu"
hintLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
hintLabel.Font = Enum.Font.Gotham
hintLabel.TextSize = 11
hintLabel.TextXAlignment = Enum.TextXAlignment.Center
hintLabel.Parent = mainFrame

-- Watermark Frame (visible only when menu hidden)
local watermark = Instance.new("Frame")
watermark.Size = UDim2.new(0, 220, 0, 30)
watermark.Position = UDim2.new(1, -230, 0, 10)
watermark.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
watermark.BackgroundTransparency = 0.2
watermark.BorderSizePixel = 0
watermark.Active = false
watermark.Parent = screenGui

local watermarkCorner = Instance.new("UICorner")
watermarkCorner.CornerRadius = UDim.new(0, 6)
watermarkCorner.Parent = watermark

local watermarkTitle = Instance.new("TextLabel")
watermarkTitle.Size = UDim2.new(0.4, 0, 1, 0)
watermarkTitle.Position = UDim2.new(0, 8, 0, 0)
watermarkTitle.BackgroundTransparency = 1
watermarkTitle.Text = "AKAME"
watermarkTitle.TextColor3 = Color3.fromRGB(220, 40, 40)
watermarkTitle.TextXAlignment = Enum.TextXAlignment.Left
watermarkTitle.Font = Enum.Font.GothamBold
watermarkTitle.TextSize = 16
watermarkTitle.Parent = watermark

local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(0.3, 0, 1, 0)
pingLabel.Position = UDim2.new(0.4, 0, 0, 0)
pingLabel.BackgroundTransparency = 1
pingLabel.Text = "Ping: 0ms"
pingLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
pingLabel.TextXAlignment = Enum.TextXAlignment.Center
pingLabel.Font = Enum.Font.Gotham
pingLabel.TextSize = 13
pingLabel.Parent = watermark

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0.3, 0, 1, 0)
fpsLabel.Position = UDim2.new(0.7, 0, 0, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 60"
fpsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
fpsLabel.TextXAlignment = Enum.TextXAlignment.Center
fpsLabel.Font = Enum.Font.Gotham
fpsLabel.TextSize = 13
fpsLabel.Parent = watermark

-- Watermark visibility (start hidden because menu starts open)
watermark.Visible = false

-- FPS and Ping update
local lastTime = tick()
local frameCount = 0

local function updateStats()
    frameCount = frameCount + 1
    local currentTime = tick()
    if currentTime - lastTime >= 1 then
        fps = frameCount
        frameCount = 0
        lastTime = currentTime
    end
    ping = math.floor(LocalPlayer:GetNetworkPing() * 1000) -- ms
    pingLabel.Text = "Ping: " .. ping .. "ms"
    fpsLabel.Text = "FPS: " .. fps
end

-- Aimbot logic
local function getClosestTarget()
    local closest = nil
    local shortest = MAX_DISTANCE
    local mousePos = UIS:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(TARGET_PART) then
            local part = player.Character[TARGET_PART]
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = part
                end
            end
        end
    end
    return closest
end

connection = RunService.RenderStepped:Connect(function()
    updateStats()
    if aimbotEnabled and UIS:IsMouseButtonPressed(AIM_BUTTON) then
        local target = getClosestTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

-- Close button action
closeBtn.MouseButton1Click:Connect(function()
    if connection then
        connection:Disconnect()
    end
    screenGui:Destroy()
end)

-- Toggle menu with Right Shift (with animations)
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        menuVisible = not menuVisible
        
        -- Animate main menu
        local menuGoal = {}
        if menuVisible then
            menuGoal.Size = UDim2.new(0, 260, 0, 140)
            menuGoal.Position = UDim2.new(0.5, -130, 0.5, -70)
        else
            menuGoal.Size = UDim2.new(0, 0, 0, 0)
            menuGoal.Position = UDim2.new(0.5, 0, 0.5, 0)
        end
        local menuTween = TweenService:Create(mainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), menuGoal)
        menuTween:Play()
        
        -- Animate watermark (fade in/out)
        if menuVisible then
            -- Hide watermark
            local fadeOut = TweenService:Create(watermark, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {BackgroundTransparency = 1})
            fadeOut:Play()
            fadeOut.Completed:Connect(function()
                watermark.Visible = false
            end)
            for _, child in ipairs(watermark:GetChildren()) do
                if child:IsA("TextLabel") then
                    local fadeChild = TweenService:Create(child, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {TextTransparency = 1})
                    fadeChild:Play()
                end
            end
        else
            -- Show watermark
            watermark.Visible = true
            watermark.BackgroundTransparency = 1
            for _, child in ipairs(watermark:GetChildren()) do
                if child:IsA("TextLabel") then
                    child.TextTransparency = 1
                end
            end
            local fadeIn = TweenService:Create(watermark, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {BackgroundTransparency = 0.2})
            fadeIn:Play()
            for _, child in ipairs(watermark:GetChildren()) do
                if child:IsA("TextLabel") then
                    local fadeChild = TweenService:Create(child, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {TextTransparency = 0})
                    fadeChild:Play()
                end
            end
        end
    end
end)

-- Initial animations
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
local appear = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 260, 0, 140),
    Position = UDim2.new(0.5, -130, 0.5, -70)
})
appear:Play()