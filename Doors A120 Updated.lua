local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local GUIModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ahma174/Morphs/refs/heads/main/A120%20GUI%20Module.lua"))()

local function createA120Morph()
    local realCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local realHRP = realCharacter:WaitForChild("HumanoidRootPart")

    local success, assetModel = pcall(function()
        return game:GetObjects("rbxassetid://12457887111")[1]
    end)
    
    if not success or not assetModel then
        assetModel = Instance.new("Model")
        local fallback = Instance.new("Part")
        fallback.Name = "Main"
        fallback.Size = Vector3.new(4, 4, 0.1)
        fallback.Parent = assetModel
        local decal = Instance.new("Decal")
        decal.Texture = "rbxassetid://10651036065"
        decal.Face = Enum.NormalId.Front
        decal.Parent = fallback
    end

    local assetControl = assetModel:FindFirstChild("AssetControl", true)
    if assetControl then
        assetControl:Destroy()
    end

    for _, obj in ipairs(assetModel:GetDescendants()) do
        if obj:IsA("LuaSourceContainer") or obj:IsA("BodyMover") or obj:IsA("Constraint") then
            obj:Destroy()
        end
    end

    for _, child in ipairs(assetModel:GetChildren()) do
        if child.Name == "Head" then
            child:Destroy()
        end
    end

    local customRoot = Instance.new("Part")
    customRoot.Name = "HumanoidRootPart"
    customRoot.Size = Vector3.new(2, 3, 1)
    customRoot.Transparency = 1
    customRoot.CanCollide = true
    customRoot.Anchored = false
    customRoot.Parent = assetModel

    local originalMain = assetModel:FindFirstChild("Main") or assetModel:FindFirstChildOfClass("BasePart")
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
            if handle and handle:IsA("BasePart") then
                handle.Transparency = 0
            end
        end
    end

    local head = morphClone:FindFirstChild("Head") or morphClone:FindFirstChild("Head", true)
    if head then
        head:Destroy()
    end

    finalHumanoid.HipHeight = 1.8 
    finalHumanoid.UseJumpPower = true
    finalHumanoid.JumpPower = 75
    finalHumanoid.WalkSpeed = 55
    finalHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

    finalHumanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    finalHumanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

    local animator = finalHumanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = finalHumanoid
    end

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

    local speedConnection
    speedConnection = RunService.Stepped:Connect(function()
        if morphClone and morphClone.Parent and finalRootPart then
            finalHumanoid.WalkSpeed = 65
            finalHumanoid.PlatformStand = false
            finalHumanoid.Sit = false
        else
            speedConnection:Disconnect()
        end
    end)

    local morphMain = morphClone:FindFirstChild("Main", true) or finalRootPart
    local footsteps = morphMain:FindFirstChild("Footsteps")
    local playSound = morphMain:FindFirstChild("PlaySound")

    local function playAmbience()
        if footsteps and footsteps:IsA("Sound") then
            footsteps.Looped = true
            footsteps:Play()
        end
        if playSound and playSound:IsA("Sound") then
            playSound.Looped = true
            playSound:Play()
        end
    end

    local function stopAmbience()
        if footsteps and footsteps:IsA("Sound") then footsteps:Stop() end
        if playSound and playSound:IsA("Sound") then playSound:Stop() end
    end

    local getVisibilityState = GUIModule.CreateUI(morphClone, playAmbience, stopAmbience)
    playAmbience()

    task.spawn(function()
        while morphClone and morphClone.Parent do
            if getVisibilityState() then
                local images = {}
                for _, desc in ipairs(morphClone:GetDescendants()) do
                    if desc:IsA("ImageLabel") or desc:IsA("Decal") or desc:IsA("Texture") then
                        table.insert(images, desc)
                    end
                end

                for _, img in ipairs(images) do if getVisibilityState() then img.ImageTransparency = 0.2 end end
                task.wait(0.05)
                for _, img in ipairs(images) do if getVisibilityState() then img.ImageTransparency = 0.5 end end
                task.wait(0.05)
                for _, img in ipairs(images) do if getVisibilityState() then img.ImageTransparency = 0 end end
                task.wait(0.05)
            else
                task.wait(0.1)
            end
        end
    end)
end


createA120Morph()
