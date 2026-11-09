loadstring([[
-- Tiger Bot (rapido + anti-kick)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local lastFire = 0
local DELAY = 0.08

print("Loaded! | Tiger Bot")

while true do
    task.wait(0.035)

    if tick() - lastFire >= DELAY then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Tool") then
            local ok, target = pcall(function() return Mouse.Target end)
            if ok and target then
                local model = target.Parent
                local hum = model and model:FindFirstChildOfClass("Humanoid")
                if not hum and model and model.Parent then
                    model = model.Parent
                    hum = model:FindFirstChildOfClass("Humanoid")
                end
                if hum and hum.Health > 0 and model ~= char then
                    lastFire = tick()
                    pcall(mouse1click)
                end
            end
        end
    end
end
]])()
