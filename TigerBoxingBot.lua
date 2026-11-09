loadstring([[
-- Tiger Bot Duels
-- Solo arma | Solo enemigos | Cuchillo NO dispara

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local DELAY = 0.08
local lastFire = 0

print("Loaded! | Tiger Bot")

local function isEnemy(plr)
    if not plr or plr == LocalPlayer then return false end
    if LocalPlayer.Team and plr.Team and LocalPlayer.Team == plr.Team then
        return false
    end
    if LocalPlayer.TeamColor and plr.TeamColor and LocalPlayer.TeamColor == plr.TeamColor then
        return false
    end
    return true
end

local function isKnife(tool)
    if not tool then return true end
    local n = string.lower(tool.Name)
    return string.find(n, "knife")
        or string.find(n, "cuchillo")
        or string.find(n, "blade")
        or string.find(n, "machete")
end

while true do
    task.wait(0.04)

    if tick() - lastFire < DELAY then
        -- espera
    else
        local char = LocalPlayer.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            -- Solo si hay arma y NO es cuchillo
            if tool and not isKnife(tool) then
                local ok, target = pcall(function() return Mouse.Target end)
                if ok and target then
                    local model = target.Parent
                    local hum = model and model:FindFirstChildOfClass("Humanoid")
                    if not hum and model and model.Parent then
                        model = model.Parent
                        hum = model:FindFirstChildOfClass("Humanoid")
                    end
                    if hum and hum.Health > 0 and model ~= char then
                        local plr = Players:GetPlayerFromCharacter(model)
                        -- Solo enemigos (no equipo)
                        if plr and isEnemy(plr) then
                            lastFire = tick()
                            pcall(mouse1click)
                        end
                    end
                end
            end
        end
    end
end
]])()
