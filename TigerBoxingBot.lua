-- Tiger Boxing Bot - Triggerbot
-- Arma = dispara | Cuchillo = lanza
-- Solo funciona en ronda

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Vim = game:GetService("VirtualInputManager")

print("Loaded! | Tiger Boxing Triggerbot")

local function hasWeapon()
    local character = LocalPlayer.Character
    if not character then return false end
    return character:FindFirstChildOfClass("Tool") ~= nil
end

local function isKnife(tool)
    if not tool then return false end
    local name = tool.Name:lower()
    return name:find("knife") or name:find("cuchillo") or name:find("blade")
end

local function throwKnife()
    Vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.05)
    Vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

while true do
    task.wait(0.01)

    if not hasWeapon() then
        continue
    end

    local target = Mouse.Target
    if target then
        local character = target.Parent
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if not humanoid and character.Parent then
            humanoid = character.Parent:FindFirstChildOfClass("Humanoid")
            character = character.Parent
        end

        if humanoid and humanoid.Health > 0 and character ~= LocalPlayer.Character then
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            
            if isKnife(tool) then
                throwKnife()
            else
                mouse1click()
            end
        end
    end
end
