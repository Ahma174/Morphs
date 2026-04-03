function oof()
    game:GetObjects("rbxassetid://10355443441")[1].Parent = game.Workspace.Terrain
    local c = game.Workspace.Terrain:FindFirstChildOfClass("Model"):Clone()
    c.Parent = game.Workspace
    c:MoveTo(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
    game.Workspace.Terrain:FindFirstChildOfClass("Model"):remove()
    c.Name = game.Players.LocalPlayer.Name
    game.Players.LocalPlayer.Character = c
    game.Workspace.CurrentCamera.CameraSubject = c:FindFirstChild("Zombie")

    local Figure = c
    local Humanoid = Figure:WaitForChild("Zombie")
    local SwingAnimObj = Figure:WaitForChild("Swing")
    local CanAttack = true

    local SwingSound = Instance.new("Sound")
    SwingSound.SoundId = "rbxassetid://566593606"
    SwingSound.Parent = Figure:WaitForChild("Torso")

    for _, v in pairs(Figure:GetChildren()) do
        if v:IsA("LocalScript") or v:IsA("Script") then
            v.Disabled = true
        end
    end

    game:GetService("RunService").Stepped:Connect(function()
        if Figure and Figure.Parent then
            Humanoid.WalkSpeed = 25
        end
    end)

    local animTable = {}
    local animNames = {
        idle = "rbxassetid://180435571",
        walk = "rbxassetid://180426354",
        run = "rbxassetid://252557606",
        jump = "rbxassetid://125750702",
        fall = "rbxassetid://180436148",
        toolnone = "rbxassetid://182393478"
    }

    for name, id in pairs(animNames) do
        local a = Instance.new("Animation")
        a.AnimationId = id
        animTable[name] = a
    end

    local currentAnim = ""
    local currentAnimTrack = nil
    local toolTrack = nil

    local function playAnimation(name, transition)
        if currentAnim ~= name then
            if currentAnimTrack then
                currentAnimTrack:Stop(transition)
                currentAnimTrack:Destroy()
            end
            local animObj = animTable[name]
            if animObj then
                currentAnimTrack = Humanoid:LoadAnimation(animObj)
                currentAnimTrack.Priority = Enum.AnimationPriority.Movement
                currentAnimTrack:Play(transition)
                currentAnim = name
            end
        end
    end

    local function dealDamage(hit)
        if not CanAttack then return end
        local character = hit.Parent
        local targetHumanoid = character:FindFirstChildOfClass("Humanoid")
        
        if targetHumanoid and character ~= Figure and not character:IsAncestorOf(Figure) then
            CanAttack = false
            local swingTrack = Humanoid:LoadAnimation(SwingAnimObj)
            swingTrack.Priority = Enum.AnimationPriority.Action
            swingTrack:Play()
            SwingSound:Play()
            targetHumanoid:TakeDamage(20)
            task.wait(0.8)
            CanAttack = true
        end
    end

    for _, part in pairs(Figure:GetChildren()) do
        if part:IsA("BasePart") then
            part.Touched:Connect(dealDamage)
        end
    end

    Humanoid.Running:Connect(function(speed)
        if speed > 0.1 then
            if speed > 17 then playAnimation("run", 0.1) else playAnimation("walk", 0.1) end
        else
            playAnimation("idle", 0.1)
        end
    end)

    Humanoid.Jumping:Connect(function() playAnimation("jump", 0.1) end)
    Humanoid.FreeFalling:Connect(function() playAnimation("fall", 0.2) end)

    Figure.ChildAdded:Connect(function(tool)
        if tool:IsA("Tool") then
            if toolTrack then toolTrack:Stop() toolTrack:Destroy() end
            toolTrack = Humanoid:LoadAnimation(animTable["toolnone"])
            toolTrack.Priority = Enum.AnimationPriority.Action
            toolTrack:Play(0.1)
        end
    end)

    Figure.ChildRemoved:Connect(function(tool)
        if tool:IsA("Tool") and toolTrack then
            toolTrack:Stop(0.1)
            toolTrack:Destroy()
            toolTrack = nil
        end
    end)

    task.spawn(function()
        while not Figure:IsDescendantOf(game.Workspace) do task.wait() end
        playAnimation("idle", 0.1)
    end)
end

oof()
