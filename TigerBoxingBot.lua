-- Tiger Boxing Bot - Versión Segura
-- Menos detección + sigue siendo preciso

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

print("Loaded! | Tiger Boxing Triggerbot")

-- Config más segura (menos agresiva = menos kick)
local HITBOX = 1.45
local MAX_DIST = 200
local DELAY = 0.09
local lastFire = 0

local function hasWeapon()
    local char = LocalPlayer.Character
    if not char then return false end
    return char:FindFirstChildOfClass("Tool") ~= nil
end

local function isKnife(tool)
    if not tool then return false end
    local n = string.lower(tool.Name)
    return string.find(n, "knife") or string.find(n, "cuchillo") or string.find(n, "blade")
end

local function getTarget()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    local myRoot = char.HumanoidRootPart

    -- Target directo
    local ok, target = pcall(function() return Mouse.Target end)
    if ok and target then
        local model = target.Parent
        local hum = model and model:FindFirstChildOfClass("Humanoid")
        if not hum and model and model.Parent then
            hum = model.Parent:FindFirstChildOfClass("Humanoid")
            model = model.Parent
        end
        if hum and hum.Health > 0 and model ~= char then
            local root = model:FindFirstChild("HumanoidRootPart")
            if root and (root.Position - myRoot.Position).Magnitude <= MAX_DIST then
                return true
            end
        end
    end

    -- Hitbox extra suave
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local limit = 32 * HITBOX

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local enemy = plr.Character
            local hum = enemy:FindFirstChildOfClass("Humanoid")
            local root = enemy:FindFirstChild("HumanoidRootPart")
            local head = enemy:FindFirstChild("Head")

            if hum and hum.Health > 0 and root then
                if (root.Position - myRoot.Position).Magnitude > MAX_DIST then
                    continue
                end

                local sp, on = Camera:WorldToViewportPoint(root.Position)
                if on then
                    local d = (mousePos - Vector2.new(sp.X, sp.Y)).Magnitude
                    if d < limit then
                        return true
                    end
                end

                if head then
                    local hp, hon = Camera:WorldToViewportPoint(head.Position)
                    if hon then
                        local d = (mousePos - Vector2.new(hp.X, hp.Y)).Magnitude
                        if d < (26 * HITBOX) then
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end

-- Loop suave (menos detección)
task.spawn(function()
    while true do
        task.wait(0.04)
        if not hasWeapon() then
            continue
        end
        if tick() - lastFire < DELAY then
            continue
        end

        local success, result = pcall(getTarget)
        if success and result then
            lastFire = tick()
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if isKnife(tool) then
                pcall(function()
                    keypress(0x45)
                    task.wait(0.025)
                    keyrelease(0x45)
                end)
            else
                pcall(mouse1click)
            end
        end
    end
end)
