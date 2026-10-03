-- Tiger Boxing Bot
-- SOLO arma de fuego + SOLO enemigos
-- Cuchillo: NUNCA auto-clic

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

print("Loaded! | Tiger Boxing Triggerbot")

local HITBOX = 1.45
local MAX_DIST = 200
local DELAY = 0.1
local lastFire = 0

local function getTool()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Tool")
end

-- Solo true si es claramente un arma de fuego
local function isGun(tool)
    if not tool then return false end
    local n = string.lower(tool.Name)

    -- Cuchillo / melee → NUNCA
    if string.find(n, "knife") or string.find(n, "cuchillo") or string.find(n, "blade")
        or string.find(n, "machete") or string.find(n, "dagger") or string.find(n, "sword") then
        return false
    end

    -- Solo armas de fuego
    if string.find(n, "gun") or string.find(n, "revolver") or string.find(n, "pistol")
        or string.find(n, "rifle") or string.find(n, "shot") or string.find(n, "firearm") then
        return true
    end

    -- Por defecto NO
    return false
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

local function getTarget()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    local myRoot = char.HumanoidRootPart

    local ok, target = pcall(function() return Mouse.Target end)
    if ok and target then
        local model = target.Parent
        local hum = model and model:FindFirstChildOfClass("Humanoid")
        if not hum and model and model.Parent then
            hum = model.Parent:FindFirstChildOfClass("Humanoid")
            model = model.Parent
        end
        if hum and hum.Health > 0 and model ~= char then
            local plr = Players:GetPlayerFromCharacter(model)
            if plr and isEnemy(plr) then
                local root = model:FindFirstChild("HumanoidRootPart")
                if root and (root.Position - myRoot.Position).Magnitude <= MAX_DIST then
                    return true
                end
            end
        end
    end

    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local limit = 32 * HITBOX

    for _, plr in ipairs(Players:GetPlayers()) do
        if isEnemy(plr) and plr.Character then
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
                    if d < limit then return true end
                end

                if head then
                    local hp, hon = Camera:WorldToViewportPoint(head.Position)
                    if hon then
                        local d = (mousePos - Vector2.new(hp.X, hp.Y)).Magnitude
                        if d < (26 * HITBOX) then return true end
                    end
                end
            end
        end
    end

    return false
end

task.spawn(function()
    while true do
        task.wait(0.05)

        local tool = getTool()

        -- Solo si es arma de fuego real
        if not isGun(tool) then
            continue
        end

        if tick() - lastFire < DELAY then
            continue
        end

        local success, result = pcall(getTarget)
        if success and result then
            lastFire = tick()
            pcall(mouse1click)
        end
    end
end)
