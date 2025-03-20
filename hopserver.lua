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




