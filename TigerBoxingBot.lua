loadstring([[
-- Tiger Bot Duels (rapido + preciso, anti-kick)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local DELAY = 0.09
local lastFire = 0
local FOV = 28 -- un poco de ayuda cerca de la mira (preciso, no exagerado)

print("Loaded! | Tiger Bot")

local function isEnemy(plr)
    if not plr or plr == LocalPlayer then return false end
    if LocalPlayer.Team and plr.Team and LocalPlayer.Team == plr.Team then
        return false
    end
    return true
end

local function isKnife(tool)
    if not tool then return false end
    local n = string.lower(tool.Name)
    return string.find(n, "knife") or string.find(n, "cuchillo") or string.find(n, "blade")
end

local function getTarget()
    -- 1) Target directo del mouse (mas preciso)
    local ok, target = pcall(function() return Mouse.Target end)
    if ok and target then
        local model = target.Parent
        local hum = model and model:FindFirstChildOfClass("Humanoid")
        if not hum and model and model.Parent then
            model = model.Parent
            hum = model:FindFirstChildOfClass("Humanoid")
        end
        if hum and hum.Health > 0 and model ~= LocalPlayer.Character then
            local plr = Players:GetPlayerFromCharacter(model)
            if plr and isEnemy(plr) then
                return true
            end
        end
    end

    -- 2) Ayuda pequena cerca de la mira
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)

    for _, plr in pairs(Players:GetPlayers()) do
        if isEnemy(plr) and plr.Character then
            local enemy = plr.Character
            local hum = enemy:FindFirstChildOfClass("Humanoid")
            local head = enemy:FindFirstChild("Head")
            local root = enemy:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and (head or root) then
                local part = head or root
                local sp, on = Camera:WorldToViewportPoint(part.Position)
                if on and sp.Z > 0 then
                    local d = (mousePos - Vector2.new(sp.X, sp.Y)).Magnitude
                    if d < FOV then
                        return true
                    end
                end
            end
        end
    end
    return false
end

while true do
    task.wait(0.045)

    if tick() - lastFire >= DELAY then
        local char = LocalPlayer.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool and not isKnife(tool) then
                if getTarget() then
                    lastFire = tick()
                    pcall(mouse1click)
                end
            end
        end
    end
end
]])()
