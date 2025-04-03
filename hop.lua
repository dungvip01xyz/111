local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer 
local playerNames = getgenv().CheckpPlayer
function Hop()
    local v372 = game.PlaceId;
    local v373 = {};
    local v374 = "";
    local v375 = os.date("!*t").hour;
    local v376 = false;
    function TPReturner()
        local v556;
        if (v374 == "") then
            v556 = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. v372 .. "/servers/Public?sortOrder=Asc&limit=100"));
        else
            v556 = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. v372 .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. v374));
        end
        local v557 = "";
        if (v556.nextPageCursor and (v556.nextPageCursor ~= "null") and (v556.nextPageCursor ~= nil)) then
            v374 = v556.nextPageCursor;
        end
        local v558 = 0;
        for v651, v652 in pairs(v556.data) do
            local v653 = true;
            v557 = tostring(v652.id);
            if (tonumber(v652.maxPlayers) > tonumber(v652.playing)) then
                for v872, v873 in pairs(v373) do
                    if (v558 ~= 0) then
                        if (v557 == tostring(v873)) then
                            v653 = false;
                        end
                    elseif (tonumber(v375) ~= tonumber(v873)) then
                        local v1472 = pcall(function()
                            v373 = {};
                            table.insert(v373, v375);
                        end);
                    end
                    v558 = v558 + 1 ;
                end
                if (v653 == true) then
                    table.insert(v373, v557);
                    wait();
                    pcall(function()
                        wait();
                        game:GetService("TeleportService"):TeleportToPlaceInstance(v372, v557, game.Players.LocalPlayer);
                    end);
                    wait();
                end
            end
        end
    end
    function v118()
        while wait() do
            pcall(function()
                TPReturner();
                if (v374 ~= "") then
                    TPReturner();
                end
            end);
        end
    end
    v118();
end
function SuperFixLagMAX()
	wait(10)
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local Terrain = Workspace.Terrain

    -- Tắt hoàn toàn hiệu ứng ánh sáng
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or 
           v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
            v:Destroy()
        end
    end
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e9
    Lighting.Brightness = 0

    -- Tắt hiệu ứng nước
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1

    -- Xóa toàn bộ hiệu ứng và chi tiết không cần thiết
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("Union") or obj:IsA("MeshPart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.Color = Color3.fromRGB(128, 128, 128) -- Tô màu xám để giảm lag
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            obj:Destroy()
        elseif obj:IsA("Explosion") then
            obj.BlastPressure = 0
            obj.BlastRadius = 0
        elseif obj:IsA("Fire") or obj:IsA("SpotLight") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj:Destroy()
        end
    end

    -- Xóa mọi vật thể thừa trong Workspace để giảm lag
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Accessory") or obj:IsA("Hat") or obj:IsA("Clothing") or obj:IsA("ForceField") or 
           obj:IsA("FaceInstance") or obj:IsA("SpecialMesh") or obj:IsA("SurfaceAppearance") then
            obj:Destroy()
        end
    end

    -- Giảm tải camera tối đa
    local Camera = Workspace.CurrentCamera
    Camera.FieldOfView = 50 -- Giảm xuống để tối ưu FPS
    for _, obj in pairs(Camera:GetDescendants()) do
        if obj:IsA("Part") and obj.Material == Enum.Material.Water then
            obj.Transparency = 1
            obj.Material = Enum.Material.Plastic
        end
    end

    -- Xóa luôn skybox nếu cần
    if Lighting:FindFirstChildOfClass("Sky") then
        Lighting:FindFirstChildOfClass("Sky"):Destroy()
    end

    print("🚀 SuperFixLagMAX: Đã xóa mọi thứ gây lag, FPS tăng cực mạnh!")
end
local function checkBeli(time)
    while true do
        local beliBefore = localPlayer.Data.Beli.Value -- Lấy giá trị Beli ban đầu
        local startTime = tick() -- Lấy thời gian bắt đầu
        while tick() - startTime < time do
            local remainingTime = time - (tick() - startTime) -- Tính thời gian còn lại
            print("Thời gian còn lại: " .. math.ceil(remainingTime) .. " giây") -- Làm tròn lên
            wait(1)
        end
        local beliAfter = localPlayer.Data.Beli.Value 
        if beliAfter > beliBefore then
            print("Beli đã tăng! 🤑")
        elseif beliAfter < beliBefore then
            print("Beli đã giảm! 😢")
            task.spawn(Hop)
            task.spawn(Hop)
            task.spawn(Hop)
            break
        else
            print("Beli không thay đổi. 😐")
            task.spawn(Hop)
            task.spawn(Hop)
            task.spawn(Hop)
            break
        end
    end
end
for _, playerName in ipairs(playerNames) do 
    if playerName == localPlayer.Name then
        print("Tên tôi có trong danh sách, bỏ qua kiểm tra.") 
    else
        local player = Players:FindFirstChild(playerName)
        if player then
            print(playerName .. " đang ở trong server, tôi thoát game.")
            task.spawn(Hop)
            task.spawn(Hop)
            task.spawn(Hop)
            break 
        else
            print(playerName .. " không có trong server, tôi ở lại.")
        end
    end
end
task.spawn(SuperFixLagMAX)
task.spawn(checkBeli, 120)
