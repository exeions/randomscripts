local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Terrain = workspace:FindFirstChildOfClass("Terrain")
local player = game:GetService("Players").LocalPlayer

RunService:Set3dRenderingEnabled(false)

Lighting.GlobalShadows = false
Lighting.Brightness = 0
Lighting.FogEnd = 9e9
Lighting.ClockTime = 14
Lighting.OutdoorAmbient = Color3.new(0,0,0)

for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then
        v:Destroy()
    end
end

if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
end

for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("Decal") or obj:IsA("Texture") then
        obj:Destroy()
    end

    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
        obj:Destroy()
    end

    if obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
        obj:Destroy()
    end

    if obj:IsA("Beam") then
        obj.Enabled = false
    end

    if obj:IsA("BasePart") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
        obj.CastShadow = false
    end

    if obj:IsA("MeshPart") then
        obj.TextureID = ""
        obj.Material = Enum.Material.SmoothPlastic
    end

    if obj:IsA("SpecialMesh") then
        obj.TextureId = ""
    end
end

if player and player.Character then
    for _, v in pairs(player.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = 1
        elseif v:IsA("Decal") then
            v:Destroy()
        end
    end
end

pcall(function()
    for _, track in pairs(player.Character.Humanoid:GetPlayingAnimationTracks()) do
        track:Stop()
    end
end)
