local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Module = {}

function Module.CreateUI(morphClone, playAmbienceFunc, stopAmbienceFunc)
    if CoreGui:FindFirstChild("A120MorphControl") then
        CoreGui.A120MorphControl:Destroy()
    end

    local CREAM_COLOR = Color3.fromRGB(255, 238, 214)
    local DARK_BG = Color3.fromRGB(18, 11, 9)
    local BUTTON_BG = Color3.fromRGB(32, 20, 16)
    local DIM_COLOR = Color3.fromRGB(140, 120, 105)

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "A120MorphControl"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 220, 0, 150)
    mainFrame.Position = UDim2.new(0.02, 0, 0.35, 0)
    mainFrame.BackgroundColor3 = DARK_BG
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = mainFrame

    local frameStroke = Instance.new("UIStroke")
    frameStroke.Thickness = 2
    frameStroke.Color = CREAM_COLOR
    frameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    frameStroke.Parent = mainFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 36)
    title.BackgroundTransparency = 1
    title.Text = "A-60"
    title.TextColor3 = CREAM_COLOR
    title.TextSize = 22
    title.Font = Enum.Font.Oswald
    title.Parent = mainFrame

    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(0.9, 0, 0, 95)
    buttonContainer.Position = UDim2.new(0.05, 0, 0, 42)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = mainFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 10)
    listLayout.Parent = buttonContainer

    local function createDoorsButton(text, layoutOrder)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.LayoutOrder = layoutOrder
        btn.BackgroundColor3 = BUTTON_BG
        btn.Font = Enum.Font.Oswald
        btn.TextSize = 18
        btn.TextColor3 = CREAM_COLOR
        btn.Text = text
        btn.Parent = buttonContainer

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = btn

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1.5
        stroke.Color = CREAM_COLOR
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = btn

        return btn, stroke
    end

    local ambienceBtn, ambienceStroke = createDoorsButton("Ambience: PLAYING", 1)
    local isAmbiencePlaying = true

    local stateBtn, stateStroke = createDoorsButton("Despawn", 2)
    local isVisible = true

    ambienceBtn.MouseButton1Click:Connect(function()
        if not isVisible then return end

        isAmbiencePlaying = not isAmbiencePlaying
        if isAmbiencePlaying then
            playAmbienceFunc()
            ambienceBtn.Text = "Ambience: PLAYING"
            ambienceBtn.TextColor3 = CREAM_COLOR
            ambienceStroke.Color = CREAM_COLOR
        else
            stopAmbienceFunc()
            ambienceBtn.Text = "Ambience: STOPPED"
            ambienceBtn.TextColor3 = DIM_COLOR
            ambienceStroke.Color = DIM_COLOR
        end
    end)

    stateBtn.MouseButton1Click:Connect(function()
        isVisible = not isVisible

        if isVisible then
            stateBtn.Text = "Despawn"
            stateBtn.TextColor3 = CREAM_COLOR
            stateStroke.Color = CREAM_COLOR
            
            for _, desc in ipairs(morphClone:GetDescendants()) do
                if desc:IsA("ParticleEmitter") or desc:IsA("PointLight") or desc:IsA("BillboardGui") then
                    desc.Enabled = true
                elseif desc:IsA("Beam") then
                    desc.Enabled = false
                elseif desc:IsA("BasePart") and desc.Name ~= "HumanoidRootPart" and desc.Name ~= "Main" then
                    desc.Transparency = 0
                elseif desc:IsA("ImageLabel") or desc:IsA("Decal") or desc:IsA("Texture") then
                    desc.ImageTransparency = 0
                end
            end

            playAmbienceFunc()
            isAmbiencePlaying = true
            ambienceBtn.Text = "Ambience: PLAYING"
            ambienceBtn.TextColor3 = CREAM_COLOR
            ambienceStroke.Color = CREAM_COLOR
        else
            stateBtn.Text = "Spawn"
            stateBtn.TextColor3 = DIM_COLOR
            stateStroke.Color = DIM_COLOR

            for _, desc in ipairs(morphClone:GetDescendants()) do
                if desc:IsA("ParticleEmitter") or desc:IsA("PointLight") or desc:IsA("Beam") or desc:IsA("BillboardGui") then
                    desc.Enabled = false
                elseif desc:IsA("BasePart") then
                    desc.Transparency = 1
                elseif desc:IsA("ImageLabel") or desc:IsA("Decal") or desc:IsA("Texture") then
                    desc.ImageTransparency = 1
                end
            end

            stopAmbienceFunc()
            isAmbiencePlaying = false
            ambienceBtn.Text = "Ambience: STOPPED"
            ambienceBtn.TextColor3 = DIM_COLOR
            ambienceStroke.Color = DIM_COLOR
        end
    end)

    return function() return isVisible end
end

return Module
