function Hop()
	local L_61_ = game.PlaceId;
	local L_62_ = {}
	local L_63_ = ""
	local L_64_ = os.date("!*t").hour;
	local L_65_ = false;
	function TPReturner()
		local L_66_;
		if L_63_ == "" then
			L_66_ = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. L_61_ .. '/servers/Public?sortOrder=Asc&limit=100'))
		else
			L_66_ = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. L_61_ .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. L_63_))
		end;
		local L_67_ = ""
		if L_66_.nextPageCursor and L_66_.nextPageCursor ~= "null" and L_66_.nextPageCursor ~= nil then
			L_63_ = L_66_.nextPageCursor
		end;
		local L_68_ = 0;
		for L_69_forvar0, L_70_forvar1 in pairs(L_66_.data) do
			local L_71_ = true;
			L_67_ = tostring(L_70_forvar1.id)
			if tonumber(L_70_forvar1.maxPlayers) > tonumber(L_70_forvar1.playing) then
				for L_72_forvar0, L_73_forvar1 in pairs(L_62_) do
					if L_68_ ~= 0 then
						if L_67_ == tostring(L_73_forvar1) then
							L_71_ = false
						end
					else
						if tonumber(L_64_) ~= tonumber(L_73_forvar1) then
							local L_74_ = pcall(function()
								L_62_ = {}
								table.insert(L_62_, L_64_)
							end)
						end
					end;
					L_68_ = L_68_ + 1
				end;
				if L_71_ == true then
					table.insert(L_62_, L_67_)
					wait()
					pcall(function()
						wait()
						game:GetService("TeleportService"):TeleportToPlaceInstance(L_61_, L_67_, game.Players.LocalPlayer)
					end)
					wait(4)
				end
			end
		end
	end;
	function Teleport()
		while wait() do
			pcall(function()
				TPReturner()
				if L_63_ ~= "" then
					TPReturner()
				end
			end)
		end
	end;
	Teleport()
end;
function fixlag()
    local lighting = game:GetService("Lighting")
    local g = game
    local w = g.Workspace
    local l = g.Lighting
    local t = w.Terrain
    if lighting:FindFirstChild("FantasySky") then
        lighting.FantasySky:Destroy()
    end
    t.WaterWaveSize = 0
    t.WaterWaveSpeed = 0
    t.WaterReflectance = 0
    t.WaterTransparency = 0
    l.GlobalShadows = false
    l.FogEnd = 9e9
    l.Brightness = 0
    for _, v in pairs(g:GetDescendants()) do
        if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then 
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = false
        elseif v:IsA("MeshPart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
            v.TextureID = "rbxassetid://10385902758728957"
        end
    end
    for _, e in pairs(l:GetChildren()) do
        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or 
           e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
            e.Enabled = false
        end
    end
    for _, v in pairs(game:GetService("Workspace").Camera:GetDescendants()) do
        if v:IsA("Part") and v.Material == Enum.Material.Water then
            v.Transparency = 1
            v.Material = Enum.Material.Plastic
        end
    end
end
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer -- Lấy người chơi đang chạy script
local playerNames = getgenv().CheckpPlayer
for _, playerName in ipairs(playerNames) do 
    if playerName == localPlayer.Name then
        print("Tên tôi có trong danh sách, bỏ qua kiểm tra.") 
    else
        local player = Players:FindFirstChild(playerName)
        if player then
            print(playerName .. " đang ở trong server, tôi thoát game.")
            Hop()
            break -- Dừng vòng lặp ngay khi tìm thấy người cần tránh
        else
            print(playerName .. " không có trong server, tôi ở lại.")
        end
    end
end
fixlag()



