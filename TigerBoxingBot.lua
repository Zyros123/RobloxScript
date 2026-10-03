-- Tiger Boxing Bot
-- Arma: dispara solo a enemigos
-- Cuchillo: NO auto clic

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

print("Loaded! | Tiger Boxing Triggerbot")

local HITBOX_MULT = 1.7
local MAX_DISTANCE = 300
local FIRE_DELAY = 0.05
local lastFire = 0

local function isKnife(tool)
    if not tool then return false end
    local name = string.lower(tool.Name)
    return string.find(name, "knife") or string.find(name, "cuchillo") or string.find(name, "blade") or string.find(name, "machete")
end

local function isEnemy(player)
    if not player or player == LocalPlayer then return false end
    if LocalPlayer.Team and player.Team then
        return player.Team ~= LocalPlayer.Team
    end
    if LocalPlayer.TeamColor and player.TeamColor then
        return player.TeamColor ~= LocalPlayer.TeamColor
    end
    return true
end

local function getEnemyUnderCrosshair()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    local myRoot = char.HumanoidRootPart

    local target = Mouse.Target
    if target then
        local model = target.Parent
        local humanoid = model and model:FindFirstChildOfClass("Humanoid")
        if not humanoid and model and model.Parent then
            humanoid = model.Parent:FindFirstChildOfClass("Humanoid")
            model = model.Parent
        end
        if humanoid and humanoid.Health > 0 and model ~= char then
            local plr = Players:GetPlayerFromCharacter(model)
            if plr and isEnemy(plr) then
                local root = model:FindFirstChild("HumanoidRootPart")
                if root and (root.Position - myRoot.Position).Magnitude <= MAX_DISTANCE then
                    return true
                end
            end
        end
    end

    local mouseScreen = Vector2.new(Mouse.X, Mouse.Y)
    local bestDist = 38 * HITBOX_MULT

    for _, player in pairs(Players:GetPlayers()) do
        if isEnemy(player) and player.Character then
            local enemy = player.Character
            local humanoid = enemy:FindFirstChildOfClass("Humanoid")
            local root = enemy:FindFirstChild("HumanoidRootPart")
            local head = enemy:FindFirstChild("Head")

            if humanoid and humanoid.Health > 0 and root then
                local distToMe = (root.Position - myRoot.Position).Magnitude
                if distToMe <= MAX_DISTANCE then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    if onScreen then
                        local d = (mouseScreen - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                        if d < bestDist then
                            return true
                        end
                    end
                    if head then
                        local headPos, headOn = Camera:WorldToViewportPoint(head.Position)
                        if headOn then
                            local d = (mouseScreen - Vector2.new(headPos.X, headPos.Y)).Magnitude
                            if d < (32 * HITBOX_MULT) then
                                return true
                            end
                        end
                    end
                end
            end
        end
    end

    return false
end

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end

    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end

    -- Si es cuchillo → NO hacer nada
    if isKnife(tool) then return end

    if tick() - lastFire < FIRE_DELAY then return end

    if getEnemyUnderCrosshair() then
        lastFire = tick()
        pcall(mouse1click)
    end
end)
