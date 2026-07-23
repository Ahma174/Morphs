local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

local function notifyUser(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 5
        })
    end)
end

local function downloadFileIfNeeded(fileName, url)
    if writefile and getcustomasset then
        if not isfile or not isfile(fileName) then
            notifyUser("Files", "Downloading Blitz model and sounds...")
            local success, data = pcall(function()
                return game:HttpGet(url)
            end)
            if success and data and #data > 0 then
                writefile(fileName, data)
            end
        end
    end
end

local farSoundUrl = "https://github.com/Ahma174/Morphs/raw/refs/heads/main/Sounds/mp3/GreenBlitzFar.mp3"
local nearSoundUrl = "https://github.com/Ahma174/Morphs/raw/refs/heads/main/Sounds/mp3/GreenBlitzNear.mp3"
local jumpscareSoundUrl = "https://github.com/Ahma174/Morphs/raw/refs/heads/main/Sounds/mp3/BlitzJumpscareNew.mp3"
local modelUrl = "https://raw.githubusercontent.com/plamen6789/CustomDoorsMonsters/main/BlitzGreen.rbxm"

local pinkFarSoundUrl = "https://github.com/Ahma174/Morphs/raw/refs/heads/main/Sounds/mp3/PinkBlitzFar.mp3"
local pinkNearSoundUrl = "https://github.com/Ahma174/Morphs/raw/refs/heads/main/Sounds/mp3/PinkBlitzNear.mp3"

downloadFileIfNeeded("GreenBlitzFar.mp3", farSoundUrl)
downloadFileIfNeeded("GreenBlitzNear.mp3", nearSoundUrl)
downloadFileIfNeeded("BlitzJumpscareNew.mp3", jumpscareSoundUrl)
downloadFileIfNeeded("BlitzGreen.rbxm", modelUrl)
downloadFileIfNeeded("PinkBlitzFar.mp3", pinkFarSoundUrl)
downloadFileIfNeeded("PinkBlitzNear.mp3", pinkNearSoundUrl)

local function getCustomSoundAsset(fileName, url)
    if isfile and isfile(fileName) then
        local success, assetId = pcall(function()
            return getcustomasset(fileName)
        end)
        if success and assetId then
            return assetId
        end
    end
    return url
end

local farSoundAsset = getCustomSoundAsset("GreenBlitzFar.mp3", farSoundUrl)
local nearSoundAsset = getCustomSoundAsset("GreenBlitzNear.mp3", nearSoundUrl)
local jumpscareSoundAsset = getCustomSoundAsset("BlitzJumpscareNew.mp3", jumpscareSoundUrl)
local pinkFarSoundAsset = getCustomSoundAsset("PinkBlitzFar.mp3", pinkFarSoundUrl)
local pinkNearSoundAsset = getCustomSoundAsset("PinkBlitzNear.mp3", pinkNearSoundUrl)

local function loadBlitzGUI()
    if CoreGui:FindFirstChild("BlitzMorphControl") then
        CoreGui.BlitzMorphControl:Destroy()
    end

    local CREAM_COLOR = Color3.fromRGB(255, 238, 214)
    local DARK_BG = Color3.fromRGB(18, 11, 9)
    local BUTTON_BG = Color3.fromRGB(32, 20, 16)
    local DIM_COLOR = Color3.fromRGB(140, 120, 105)

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BlitzMorphControl"
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
    title.Text = "Blitz"
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
    local switchBtn, switchStroke = createDoorsButton("Switch: OFF", 3)
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
        if _G.BlitzMorph then
            local isPlaying = _G.BlitzMorph.ToggleAmbience()
            setAmbienceState(isPlaying)
        end
    end)

    jumpscareBtn.MouseButton1Click:Connect(function()
        if _G.BlitzMorph then
            setAmbienceState(false)
            _G.BlitzMorph.TriggerJumpscare(function()
                setAmbienceState(true)
            end)
        end
    end)

    switchBtn.MouseButton1Click:Connect(function()
        if _G.BlitzMorph then
            local isSwitched = _G.BlitzMorph.ToggleSwitch()
            if isSwitched then
                switchBtn.Text = "Switch: ON"
                switchBtn.TextColor3 = CREAM_COLOR
                switchStroke.Color = CREAM_COLOR
            else
                switchBtn.Text = "Switch: OFF"
                switchBtn.TextColor3 = DIM_COLOR
                switchStroke.Color = DIM_COLOR
            end
        end
    end)

    stateBtn.MouseButton1Click:Connect(function()
        if _G.BlitzMorph then
            local visible, playing = _G.BlitzMorph.ToggleVisibility()
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

local function getBlitzModel()
    local fileName = "BlitzGreen.rbxm"
    if isfile and isfile(fileName) and getcustomasset then
        local success, loadedModel = pcall(function()
            return game:GetObjects(getcustomasset(fileName))[1]
        end)
        if success and loadedModel then 
            return loadedModel 
        end
    end

    local model = Instance.new("Model")
    model.Name = "BackdoorRush"
    local mainPart = Instance.new("Part")
    mainPart.Name = "Main"
    mainPart.Size = Vector3.new(4, 4, 0.1)
    mainPart.Parent = model
    return model
end

local function applyAttachmentSwitchState(morphClone, enabledState)
    for _, desc in ipairs(morphClone:GetDescendants()) do
        if desc.Name == "AttachmentSwitch" then
            for _, child in ipairs(desc:GetChildren()) do
                if child:IsA("ParticleEmitter") or child:IsA("Light") or child:IsA("Beam") then
                    child.Enabled = enabledState
                end
            end
        end
    end
end

local function setAttachmentElements(morphClone, enabledState)
    for _, desc in ipairs(morphClone:GetDescendants()) do
        if desc:IsA("Attachment") and desc.Name ~= "AttachmentSwitch" then
            for _, child in ipairs(desc:GetChildren()) do
                if child:IsA("ParticleEmitter") or child:IsA("Light") or child:IsA("Beam") then
                    child.Enabled = enabledState
                end
            end
        end
    end
end

local function createBlitzMorph()
    local realCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local realHRP = realCharacter:WaitForChild("HumanoidRootPart")

    local assetModel = getBlitzModel()

    local assetControl = assetModel:FindFirstChild("AssetControl", true)
    if assetControl then assetControl:Destroy() end

    for _, obj in ipairs(assetModel:GetDescendants()) do
        if obj:IsA("LuaSourceContainer") or obj:IsA("BodyMover") or obj:IsA("Constraint") then
            obj:Destroy()
        end
    end

    for _, child in ipairs(assetModel:GetChildren()) do
        if child.Name == "Head" then child:Destroy() end
    end

    local customRoot = Instance.new("Part")
    customRoot.Name = "HumanoidRootPart"
    customRoot.Size = Vector3.new(2, 3, 1)
    customRoot.Transparency = 1
    customRoot.CanCollide = true
    customRoot.Anchored = false
    customRoot.Parent = assetModel

    local originalMain = assetModel:FindFirstChild("Main", true) or assetModel:FindFirstChildOfClass("BasePart")
    if originalMain and originalMain ~= customRoot then
        originalMain.CanCollide = false
        originalMain.Massless = true
        originalMain.CFrame = customRoot.CFrame
        
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = customRoot
        weld.Part1 = originalMain
        weld.Parent = customRoot
    end

    local morphHumanoid = assetModel:FindFirstChildOfClass("Humanoid")
    if not morphHumanoid then
        morphHumanoid = Instance.new("Humanoid")
        morphHumanoid.Parent = assetModel
    end
    
    morphHumanoid.AutomaticScalingEnabled = true
    morphHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

    assetModel.Parent = Workspace.Terrain
    local morphClone = Workspace.Terrain:FindFirstChildOfClass("Model"):Clone()
    morphClone.Parent = Workspace
    Workspace.Terrain:FindFirstChildOfClass("Model"):Destroy()

    morphClone.Name = LocalPlayer.Name
    
    local finalHumanoid = morphClone:FindFirstChildOfClass("Humanoid")
    local finalRootPart = morphClone:FindFirstChild("HumanoidRootPart")
    morphClone.PrimaryPart = finalRootPart

    for _, part in ipairs(realCharacter:GetChildren()) do
        if part:IsA("BasePart") then
            if part.Name == "HumanoidRootPart" then
                part.Transparency = 1
                part.Anchored = true
            else
                part.Transparency = 0
                part.CanCollide = true
            end
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle and handle:IsA("BasePart") then handle.Transparency = 0 end
        end
    end

    local head = morphClone:FindFirstChild("Head") or morphClone:FindFirstChild("Head", true)
    if head then head:Destroy() end

    finalHumanoid.HipHeight = 1.8 
    finalHumanoid.UseJumpPower = true
    finalHumanoid.JumpPower = 50
    finalHumanoid.WalkSpeed = 55
    finalHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    finalHumanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    finalHumanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

    local targetCFrame = realHRP.CFrame + Vector3.new(0, 2, 0)
    morphClone:PivotTo(targetCFrame)
    LocalPlayer.Character = morphClone
    Workspace.CurrentCamera.CameraSubject = finalHumanoid

    for _, part in ipairs(morphClone:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = false
            if part.Name == "HumanoidRootPart" then
                part.Transparency = 1
                part.CanCollide = true
            elseif part.Name == "Main" then
                part.Transparency = 1
                part.CanCollide = false
            else
                part.Transparency = 0
                part.CanCollide = false
            end
            part.Massless = true
        end
    end

    setAttachmentElements(morphClone, true)
    applyAttachmentSwitchState(morphClone, false)

    local speedConnection
    speedConnection = RunService.Stepped:Connect(function()
        if morphClone and morphClone.Parent and finalRootPart then
            finalHumanoid.WalkSpeed = 55
            finalHumanoid.PlatformStand = false
            finalHumanoid.Sit = false
        else
            speedConnection:Disconnect()
        end
    end)

    local isVisible = true
    local isAmbiencePlaying = true
    local isSwitchActive = false
    local morphMain = morphClone:FindFirstChild("Main", true) or finalRootPart

    local farAmbience = Instance.new("Sound")
    farAmbience.Name = "FarAmbience"
    farAmbience.SoundId = farSoundAsset
    farAmbience.Volume = 1
    farAmbience.Looped = true
    farAmbience.Parent = morphMain

    local nearAmbience = Instance.new("Sound")
    nearAmbience.Name = "NearAmbience"
    nearAmbience.SoundId = nearSoundAsset
    nearAmbience.Volume = 1
    nearAmbience.Looped = true
    nearAmbience.Parent = morphMain

    local jumpscareSound = Instance.new("Sound")
    jumpscareSound.Name = "JumpscareSound"
    jumpscareSound.SoundId = jumpscareSoundAsset
    jumpscareSound.Parent = morphMain

    local jumpscareThread

    local function stopAmbience()
        if farAmbience then farAmbience:Stop() end
        if nearAmbience then nearAmbience:Stop() end
    end

    local function updateSoundAssets()
        if isSwitchActive then
            farAmbience.SoundId = pinkFarSoundAsset
            nearAmbience.SoundId = pinkNearSoundAsset
        else
            farAmbience.SoundId = farSoundAsset
            nearAmbience.SoundId = nearSoundAsset
        end
    end

    local function playAmbience()
        if not isVisible then return end
        updateSoundAssets()
        if farAmbience then
            farAmbience.Looped = true
            farAmbience:Play()
        end
        if nearAmbience then
            nearAmbience.Looped = true
            nearAmbience:Play()
        end
    end

    local function cancelSpecialSounds()
        if jumpscareSound then 
            jumpscareSound:Stop() 
            jumpscareSound.TimePosition = 0
        end
        if jumpscareThread then task.cancel(jumpscareThread) jumpscareThread = nil end
    end

    playAmbience()

    _G.BlitzMorph = {
        ToggleAmbience = function()
            if not isVisible then return false end
            isAmbiencePlaying = not isAmbiencePlaying
            if isAmbiencePlaying then playAmbience() else stopAmbience() end
            return isAmbiencePlaying
        end,
        ToggleSwitch = function()
            isSwitchActive = not isSwitchActive
            if isVisible then
                if isSwitchActive then
                    setAttachmentElements(morphClone, false)
                    applyAttachmentSwitchState(morphClone, true)
                else
                    setAttachmentElements(morphClone, true)
                    applyAttachmentSwitchState(morphClone, false)
                end
                if isAmbiencePlaying then
                    stopAmbience()
                    playAmbience()
                end
            end
            return isSwitchActive
        end,
        TriggerJumpscare = function(onComplete)
            if not isVisible then return end
            cancelSpecialSounds()
            stopAmbience()
            isAmbiencePlaying = false
            
            jumpscareSound.TimePosition = 0
            jumpscareSound:Play()
            
            jumpscareThread = task.spawn(function()
                if not jumpscareSound.IsLoaded then jumpscareSound.Loaded:Wait() end
                
                local soundDuration = jumpscareSound.TimeLength
                if soundDuration <= 0 then soundDuration = 3 end
                
                task.wait(soundDuration)
                
                jumpscareSound:Stop()
                jumpscareSound.TimePosition = 0
                
                if isVisible then
                    playAmbience()
                    isAmbiencePlaying = true
                    if onComplete then onComplete() end
                end
            end)
        end,
        ToggleVisibility = function()
            isVisible = not isVisible
            if isVisible then
                for _, desc in ipairs(morphClone:GetDescendants()) do
                    if desc:IsA("ParticleEmitter") then
                        desc.Enabled = true
                    elseif desc:IsA("PointLight") or desc:IsA("BillboardGui") then
                        desc.Enabled = true
                    elseif desc:IsA("Beam") then desc.Enabled = false
                    elseif desc:IsA("BasePart") and desc.Name ~= "HumanoidRootPart" and desc.Name ~= "Main" then desc.Transparency = 0
                    elseif desc:IsA("ImageLabel") or desc:IsA("Decal") or desc:IsA("Texture") then desc.ImageTransparency = 0 end
                end
                if isSwitchActive then
                    setAttachmentElements(morphClone, false)
                    applyAttachmentSwitchState(morphClone, true)
                else
                    setAttachmentElements(morphClone, true)
                    applyAttachmentSwitchState(morphClone, false)
                end
                playAmbience()
                isAmbiencePlaying = true
            else
                for _, desc in ipairs(morphClone:GetDescendants()) do
                    if desc:IsA("ParticleEmitter") or desc:IsA("PointLight") or desc:IsA("Beam") or desc:IsA("BillboardGui") then desc.Enabled = false
                    elseif desc:IsA("BasePart") then desc.Transparency = 1
                    elseif desc:IsA("ImageLabel") or desc:IsA("Decal") or desc:IsA("Texture") then desc.ImageTransparency = 1 end
                end
                setAttachmentElements(morphClone, false)
                applyAttachmentSwitchState(morphClone, false)
                cancelSpecialSounds()
                stopAmbience()
                isAmbiencePlaying = false
            end
            return isVisible, isAmbiencePlaying
        end
    }

    task.spawn(function()
        while morphClone and morphClone.Parent do
            if isVisible then
                local images = {}
                for _, desc in ipairs(morphClone:GetDescendants()) do
                    if desc:IsA("ImageLabel") or desc:IsA("Decal") or desc:IsA("Texture") then
                        table.insert(images, desc)
                    end
                end
                for _, img in ipairs(images) do if isVisible then img.ImageTransparency = 0.2 end end
                task.wait(0.05)
                for _, img in ipairs(images) do if isVisible then img.ImageTransparency = 0.5 end end
                task.wait(0.05)
                for _, img in ipairs(images) do if isVisible then img.ImageTransparency = 0 end end
                task.wait(0.05)
            else
                task.wait(0.1)
            end
        end
    end)
end

createBlitzMorph()
loadBlitzGUI()
