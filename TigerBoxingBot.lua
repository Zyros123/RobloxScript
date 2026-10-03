-- Tiger Boxing Bot - Preciso y más seguro

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

print("Loaded! | Tiger Boxing Triggerbot")

local HITBOX = 1.6
local MAX_DIST = 280
local DELAY = 0.07
local lastFire = 0

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
            local root = model:FindFirstChild("HumanoidRootPart")
            if root and (root.Position - myRoot.Position).Magnitude <= MAX_DIST then
                return true
            end
        end
    end

    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local limit = 36 * HITBOX

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local enemy = plr.Character
            local hum = enemy:FindFirstChildOfClass("Humanoid")
            local root = enemy:FindFirstChild("HumanoidRootPart")
            local head = enemy:FindFirstChild("Head")

            if hum and hum.Health > 0 and root then
                if (root.Position - myRoot.Position).Magnitude <= MAX_DIST then
                    local sp, on = Camera:WorldToViewportPoint(root.Position)
                    if on then
                        local d = (mousePos - Vector2.new(sp.X, sp.Y)).Magnitude
                        if d < limit then return true end
                    end
                    if head then
                        local hp, hon = Camera:WorldToViewportPoint(head.Position)
                        if hon then
                            local d = (mousePos - Vector2.new(hp.X, hp.Y)).Magnitude
                            if d < (30 * HITBOX) then return true end
                        end
                    end
                end
            end
        end
    end

    return false
end

task.spawn(function()
    while true do
        task.wait(0.04)
        if tick() - lastFire >= DELAY then
            local success, result = pcall(getTarget)
            if success and result then
                lastFire = tick()
                pcall(mouse1click)
            end
        end
    end
end)
