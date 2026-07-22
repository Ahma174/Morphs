local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local function GUIModule()
    if CoreGui:FindFirstChild("AmbushMorphControl") then
        CoreGui.AmbushMorphControl:Destroy()
    end

    local CREAM_COLOR = Color3.fromRGB(255, 238, 214)
    local DARK_BG = Color3.fromRGB(18, 11, 9)
    local BUTTON_BG = Color3.fromRGB(32, 20, 16)
    local DIM_COLOR = Color3.fromRGB(140, 120, 105)

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AmbushMorphControl"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 220, 0, 246)
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
    title.Text = "Ambush"
    title.TextColor3 = CREAM_COLOR
    title.TextSize = 22
    title.Font = Enum.Font.Oswald
    title.Parent = mainFrame

    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(0.9, 0, 0, 190)
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
    local stateBtn, stateStroke = createDoorsButton("Despawn", 2)
    local arrivalBtn = createDoorsButton("Arrival", 3)
    local jumpscareBtn = createDoorsButton("Jumpscare", 4)

    local function setAmbienceState(playing)
        if playing then
            ambienceBtn.Text = "Ambience: PLAYING"
            ambienceBtn.TextColor3 = CREAM_COLOR
            ambienceStroke.Color = CREAM_COLOR
        else
            ambienceBtn.Text = "Ambience: STOPPED"
            ambienceBtn.TextColor3 = DIM_COLOR
            ambienceStroke.Color = DIM_COLOR
        end
    end

    ambienceBtn.MouseButton1Click:Connect(function()
        if _G.AmbushMorph then
            local isPlaying = _G.AmbushMorph.ToggleAmbience()
            setAmbienceState(isPlaying)
        end
    end)

    arrivalBtn.MouseButton1Click:Connect(function()
        if _G.AmbushMorph then
            setAmbienceState(false)
            _G.AmbushMorph.TriggerArrival(function()
                setAmbienceState(true)
            end)
        end
    end)

    jumpscareBtn.MouseButton1Click:Connect(function()
        if _G.AmbushMorph then
            setAmbienceState(false)
            _G.AmbushMorph.TriggerJumpscare(function()
                setAmbienceState(true)
            end)
        end
    end)

    stateBtn.MouseButton1Click:Connect(function()
        if _G.AmbushMorph then
            local visible, playing = _G.AmbushMorph.ToggleVisibility()
            if visible then
                stateBtn.Text = "Despawn"
                stateBtn.TextColor3 = CREAM_COLOR
                stateStroke.Color = CREAM_COLOR
            else
                stateBtn.Text = "Spawn"
                stateBtn.TextColor3 = DIM_COLOR
                stateStroke.Color = DIM_COLOR
            end
            setAmbienceState(playing)
        end
    end)
end

return GUIModule
