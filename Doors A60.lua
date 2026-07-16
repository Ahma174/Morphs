local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function createA60Morph()
    local realCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local realHRP = realCharacter:WaitForChild("HumanoidRootPart")
    local realHumanoid = realCharacter:WaitForChild("Humanoid")
    
    local spawnPos = realHRP.Position

    local success, assetModel = pcall(function()
        return game:GetObjects("rbxassetid://12778057668")[1]
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
        if obj:IsA("Script") or obj:IsA("LocalScript") then
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
    finalHumanoid.JumpPower = 50
    finalHumanoid.WalkSpeed = 65
    finalHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

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

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9114223126"
    sound.Volume = 2
    sound.Looped = true
    sound.Parent = finalRootPart
    sound:Play()

    local connection
    connection = RunService.Stepped:Connect(function()
        if morphClone and morphClone.Parent and finalRootPart then
            finalHumanoid.WalkSpeed = 65
        else
            connection:Disconnect()
        end
    end)

    task.spawn(function()
        while morphClone.Parent do
            local decals = {}
            for _, descendant in ipairs(morphClone:GetDescendants()) do
                if descendant:IsA("Decal") or descendant:IsA("Texture") then
                    table.insert(decals, descendant)
                end
            end
            
            for _, d in ipairs(decals) do d.Transparency = 0.2 end
            task.wait(0.05)
            for _, d in ipairs(decals) do d.Transparency = 0.5 end
            task.wait(0.05)
            for _, d in ipairs(decals) do d.Transparency = 0 end
            task.wait(0.05)
        end
    end)
end

createA60Morph()
