DefaultHUD = DefaultHUD or {}
function DefaultHUD.GetWeapons()
	local weaponstab = LocalPlayer():GetWeapons()
	local tab1 = { {}, {}, {}, {}, {}, {}}
	for k, v in pairs(weaponstab) do
		table.insert(tab1[v:GetSlot()+1], v)
	end
	for i=1, 6 do
		if !next(tab1[i]) then continue end
		table.sort(tab1[i], function(a,b) return a:GetSlotPos() < b:GetSlotPos() end)
	end
	return tab1
end
function DefaultHUD.MoveWeapons(bool, weapon)
	local weapontab = DefaultHUD.GetWeapons()
	local slotpos = DefaultHUD.SlotPos
	if bool then
		if weapontab[DefaultHUD.Slot][slotpos+1] == nil then
			if weapontab[DefaultHUD.Slot+1] == nil then
				local i = 1
				while weapontab[i][1] == nil do
					i = i+1
				end
				DefaultHUD.Slot = i
				DefaultHUD.SlotPos = 1
			elseif weapontab[DefaultHUD.Slot+1][1] == nil then
				local i = DefaultHUD.Slot+1
				while weapontab[i][1] == nil and i <= 6 do
					i = i+1
					if weapontab[i] == nil then i = 1 end
				end
				DefaultHUD.Slot = i
				DefaultHUD.SlotPos = 1
			else
				DefaultHUD.Slot = DefaultHUD.Slot+1
				DefaultHUD.SlotPos = 1
			end
		else
			DefaultHUD.SlotPos = DefaultHUD.SlotPos+1
		end
	else
		if weapontab[DefaultHUD.Slot][slotpos-1] == nil then
			if weapontab[DefaultHUD.Slot-1] == nil then
				local i = 6
				while weapontab[i][1] == nil and i > 0 do
					i = i-1
				end
				DefaultHUD.Slot = i
				DefaultHUD.SlotPos = #weapontab[DefaultHUD.Slot]
			elseif weapontab[DefaultHUD.Slot-1][1] == nil then
				local i = DefaultHUD.Slot-1
				while weapontab[i][1] == nil do
					i = i-1
					if weapontab[i] == nil then i = 6 end
				end
				DefaultHUD.Slot = i
				DefaultHUD.SlotPos = #weapontab[DefaultHUD.Slot]
			else
				DefaultHUD.Slot = DefaultHUD.Slot-1
				DefaultHUD.SlotPos = #weapontab[DefaultHUD.Slot]
			end
		else
			DefaultHUD.SlotPos = DefaultHUD.SlotPos-1
		end
	end
end