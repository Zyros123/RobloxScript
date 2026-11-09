loadstring([[
-- Tiger Bot - dispara con cualquier arma

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local DELAY = 0.07
local lastFire = 0

print("Loaded! | Tiger Bot")

local function isKnife(tool)
    if not tool then return true end
    local n = string.lower(tostring(tool.Name))
    return n:find("knife") or n:find("cuchillo") or n:find("blade") or n:find("machete")
end

local function isEnemy(plr)
    if not plr or plr == LocalPlayer then return false end
    if LocalPlayer.Team and plr.Team and LocalPlayer.Team == plr.Team then
        return false
    end
    return true
end

while true do
    task.wait(0.03)
    if tick() - lastFire < DELAY then
    else
        local char = LocalPlayer.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            -- Cualquier arma = si hay Tool y no es cuchillo
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
