local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local GUIModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ahma174/Morphs/refs/heads/main/Ambush%20GUI%20Module.lua"))()

local function createAmbushMorph()
    local realCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local realHRP = realCharacter:WaitForChild("HumanoidRootPart")

    local success, assetModel = pcall(function()
        return game:GetObjects("rbxassetid://12457758496")[1]
    end)
    
    if not success or not assetModel then
        assetModel = Instance.new("Model")
        local fallback = Instance.new("Part")
        fallback.Name = "RushNew"
        fallback.Size = Vector3.new(4, 4, 0.1)
        fallback.Parent = assetModel
        local decal = Instance.new("Decal")
        decal.Texture = "rbxassetid://10651036065"
        decal.Face = Enum.NormalId.Front
        decal.Parent = fallback
    end

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

    local originalMain = assetModel:FindFirstChild("RushNew") or assetModel:FindFirstChildOfClass("BasePart")
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
    finalHumanoid.JumpPower = 75
    finalHumanoid.WalkSpeed = 80
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
            elseif part.Name == "RushNew" then
                part.Transparency = 1
                part.CanCollide = false
            else
                part.Transparency = 0
                part.CanCollide = false
            end
            part.Massless = true
        end
    end

    for _, desc in ipairs(morphClone:GetDescendants()) do
        if desc:IsA("ParticleEmitter") and (desc.Name == "Black" or desc.Name == "BlackTrail") then
            desc.Enabled = false
        end
    end

    local speedConnection
    speedConnection = RunService.Stepped:Connect(function()
        if morphClone and morphClone.Parent and finalRootPart then
            finalHumanoid.WalkSpeed = 80
            finalHumanoid.PlatformStand = false
            finalHumanoid.Sit = false
        else
            speedConnection:Disconnect()
        end
    end)

    local isVisible = true
    local isAmbiencePlaying = true
    local morphMain = morphClone:FindFirstChild("RushNew", true) or finalRootPart
    local footsteps = morphMain:FindFirstChild("Footsteps")
    local playSound = morphMain:FindFirstChild("PlaySound")

    local arrivalSound = Instance.new("Sound")
    arrivalSound.Name = "ArrivalSound"
    arrivalSound.SoundId = "rbxassetid://134020218579308"
    arrivalSound.Parent = morphMain

    local jumpscareSound = Instance.new("Sound")
    jumpscareSound.Name = "JumpscareSound"
    jumpscareSound.SoundId = "rbxassetid://104513172698892"
    jumpscareSound.Parent = morphMain

    local arrivalThread
    local jumpscareThread

    local function stopAmbience()
        if footsteps and footsteps:IsA("Sound") then footsteps:Stop() end
        if playSound and playSound:IsA("Sound") then playSound:Stop() end
    end

    local function playAmbience()
        if not isVisible then return end
        if footsteps and footsteps:IsA("Sound") then
            footsteps.Looped = true
            footsteps:Play()
        end
        if playSound and playSound:IsA("Sound") then
            playSound.Looped = true
            playSound:Play()
        end
    end

    local function cancelSpecialSounds()
        arrivalSound:Stop()
        jumpscareSound:Stop()
        if arrivalThread then task.cancel(arrivalThread) arrivalThread = nil end
        if jumpscareThread then task.cancel(jumpscareThread) jumpscareThread = nil end
    end

    playAmbience()

    _G.AmbushMorph = {
        ToggleAmbience = function()
            if not isVisible then return false end
            isAmbiencePlaying = not isAmbiencePlaying
            if isAmbiencePlaying then playAmbience() else stopAmbience() end
            return isAmbiencePlaying
        end,
        TriggerArrival = function(onComplete)
            if not isVisible then return end
            cancelSpecialSounds()
            stopAmbience()
            isAmbiencePlaying = false
            arrivalSound:Play()
            arrivalThread = task.spawn(function()
                task.wait(7)
                if isVisible then
                    playAmbience()
                    isAmbiencePlaying = true
                    if onComplete then onComplete() end
                end
            end)
        end,
        TriggerJumpscare = function(onComplete)
            if not isVisible then return end
            cancelSpecialSounds()
            stopAmbience()
            isAmbiencePlaying = false
            jumpscareSound:Play()
            jumpscareThread = task.spawn(function()
                if not jumpscareSound.IsLoaded then jumpscareSound.Loaded:Wait() end
                task.wait(jumpscareSound.TimeLength)
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
                        if desc.Name ~= "Black" and desc.Name ~= "BlackTrail" then desc.Enabled = true end
                    elseif desc:IsA("PointLight") or desc:IsA("BillboardGui") then
                        desc.Enabled = true
                    elseif desc:IsA("Beam") then desc.Enabled = false
                    elseif desc:IsA("BasePart") and desc.Name ~= "HumanoidRootPart" and desc.Name ~= "RushNew" then desc.Transparency = 0
                    elseif desc:IsA("ImageLabel") or desc:IsA("Decal") or desc:IsA("Texture") then desc.ImageTransparency = 0 end
                end
                playAmbience()
                isAmbiencePlaying = true
            else
                for _, desc in ipairs(morphClone:GetDescendants()) do
                    if desc:IsA("ParticleEmitter") or desc:IsA("PointLight") or desc:IsA("Beam") or desc:IsA("BillboardGui") then desc.Enabled = false
                    elseif desc:IsA("BasePart") then desc.Transparency = 1
                    elseif desc:IsA("ImageLabel") or desc:IsA("Decal") or desc:IsA("Texture") then desc.ImageTransparency = 1 end
                end
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

createAmbushMorph()
GUIModule()
