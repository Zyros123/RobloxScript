-- Tiger Boxing Bot - Triggerbot Mejorado
-- Más preciso + un poco más de hitbox
-- Solo funciona en ronda (con arma o cuchillo)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera
local Vim = game:GetService("VirtualInputManager")

print("Loaded! | Tiger Boxing Triggerbot (Preciso)")

-- Config
local HITBOX_MULT = 1.7       -- un poco más de hitbox (no exagerado)
local MAX_DISTANCE = 300
local FIRE_DELAY = 0.035      -- más rápido = más preciso
local lastFire = 0

local function hasWeapon()
    local char = LocalPlayer.Character
    if not char then return false end
    return char:FindFirstChildOfClass("Tool") ~= nil
end

local function isKnife(tool)
    if not tool then return false end
    local name = tool.Name:lower()
    return name:find("knife") or name:find("cuchillo") or name:find("blade") or name:find("machete")
end

local function throwKnife()
    Vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.03)
    Vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

-- Detecta enemigo bajo el crosshair con hitbox un poco más grande
local function getEnemyUnderCrosshair()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myRoot = char.HumanoidRootPart

    -- 1. Target directo del mouse
    local target = Mouse.Target
    if target then
        local model = target.Parent
        local humanoid = model and model:FindFirstChildOfClass("Humanoid")
        if not humanoid and model and model.Parent then
            humanoid = model.Parent:FindFirstChildOfClass("Humanoid")
            model = model.Parent
        end
        if humanoid and humanoid.Health > 0 and model ~= char then
            local root = model:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = (root.Position - myRoot.Position).Magnitude
                if dist <= MAX_DISTANCE then
                    return true
                end
            end
        end
    end

    -- 2. Búsqueda por cercanía al crosshair (hitbox extra)
    local mouseScreen = Vector2.new(Mouse.X, Mouse.Y)
    local bestDist = 38 * HITBOX_MULT  -- pixeles de tolerancia

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local enemy = player.Character
            local humanoid = enemy:FindFirstChildOfClass("Humanoid")
            local root = enemy:FindFirstChild("HumanoidRootPart")
            local head = enemy:FindFirstChild("Head")

            if humanoid and humanoid.Health > 0 and root then
                local distToMe = (root.Position - myRoot.Position).Magnitude
                if distToMe <= MAX_DISTANCE then
                    -- Revisa torso
                    local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    if onScreen then
                        local enemyScreen = Vector2.new(screenPos.X, screenPos.Y)
                        local d = (mouseScreen - enemyScreen).Magnitude
                        if d < bestDist then
                            return true
                        end
                    end
                    -- Revisa cabeza (más preciso)
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

-- Bucle principal rápido y preciso
RunService.RenderStepped:Connect(function()
    if not hasWeapon() then return end
    if tick() - lastFire < FIRE_DELAY then return end

    if getEnemyUnderCrosshair() then
        lastFire = tick()
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if isKnife(tool) then
            throwKnife()
        else
            mouse1click()
        end
    end
end)
