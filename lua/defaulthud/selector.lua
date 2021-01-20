DefaultHUD = DefaultHUD or {}
DefaultHUD.Slot = 1
DefaultHUD.SlotPos = 1
DefaultHUD.Time = 0
DefaultHUD.Alpha = 0
DefaultHUD.Alpha2 = 0
DefaultHUD.Angles2 = Angle(0,0,0)
local dfweapons = {
	weapon_crowbar = "c",
	weapon_smg1 = "a",
	weapon_ar2 = "l",
	weapon_pistol = "d",
	weapon_357 = "e",
	weapon_shotgun = "b",
	weapon_crossbow = "g",
	weapon_physcannon = "m",
	weapon_physgun = "h",
	weapon_bugbait = "j",
	weapon_frag = "k",
	weapon_stunstick = "n",
	weapon_rpg = "i",
	weapon_slam = "o",
}
hook.Add("DFHUDPaint", "DefaultHUDSelectorPaint", function(bool)
	if !hook.Run("HUDShouldDraw", "CHudWeaponSelection", true) or !GetConVar("dfhud_enable"):GetBool() then return end
	local ScrH = ScrH
	local ScrW = ScrW -- Setting it to be a local var, so we'll won't change global one
	if DefaultHUD.Time < SysTime() then
		DefaultHUD.bindslot = "0"
		DefaultHUD.Alpha = math.max(DefaultHUD.Alpha-32, 0)
		DefaultHUD.Alpha2 = math.max(DefaultHUD.Alpha2-32, 0)
	else
		DefaultHUD.Alpha = math.min(DefaultHUD.Alpha+32, GetConVar("dfhud_box_color_a"):GetInt())
		DefaultHUD.Alpha2 = math.min(DefaultHUD.Alpha2+32, 255)
	end
	local alpha = DefaultHUD.Alpha
	local alpha2 = DefaultHUD.Alpha2
	local boxcolor = Color(GetConVar("dfhud_box_color_r"):GetInt(), GetConVar("dfhud_box_color_g"):GetInt(), GetConVar("dfhud_box_color_b"):GetInt(), alpha)
	local weapon = DefaultHUD.GetWeapons()
	local color = Color(GetConVar("dfhud_color_r"):GetInt(), GetConVar("dfhud_color_g"):GetInt(), GetConVar("dfhud_color_b"):GetInt())
	local x = 435 / 1366 * ScrW()
	local y = 25 / 768 * ScrH()
	if bool then
		ScrW = function() return 1366 end
		ScrH = function() return 768 end -- For 3D mode fix
		local vel1 =math.AngleDifference(DefaultHUD.Angles2[1], LocalPlayer():EyeAngles()[1])
		local vel2 = math.AngleDifference(DefaultHUD.Angles2[2], LocalPlayer():EyeAngles()[2])
		cam.Start3D(Vector(0,0,0), Angle(0,0,0), 106, 0, 0, ScrW(), ScrH(), 4, 512)
			cam.Start3D2D(Vector(14,18,10), Angle(0, 270+vel2/10, 95+vel1/2), 0.026)
	end
	for i=1, 6 do
		if DefaultHUD.Slot == i then
			for k, v in pairs(weapon[i]) do
				local base = weapons.Get(v.Base) or {}
				if k == DefaultHUD.SlotPos then
					draw.RoundedBox(8/768*ScrH(), x + (63 / 1366 * ScrW() ) * (i-1), y+(45/768*ScrH()) *(k-1), 181/1366*ScrW(), 128/768*ScrH(), boxcolor)
					if dfweapons[v:GetClass()] then
						draw.SimpleText(dfweapons[v:GetClass()], "LuaBoxRocketBlur", x + (90/1366*ScrW()) + (63 / 1366 * ScrW() ) * (i-1), y+56/768*ScrH()+(45/768*ScrH())*(k-1), Color( color.r, color.g, color.b, alpha2 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						draw.SimpleText(dfweapons[v:GetClass()], "LuaBoxRocket", x + (90/1366*ScrW()) + (63 / 1366 * ScrW() ) * (i-1), y+56/768*ScrH()+(45/768*ScrH())*(k-1), Color( color.r, color.g, color.b, alpha2 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					elseif isfunction(v.DrawWeaponSelection) and v.DrawWeaponSelection != weapons.Get("weapon_base").DrawWeaponSelection then
						if alpha2 > 50 then
							v:DrawWeaponSelection(x + 10/1366*ScrW() + 63/1366*ScrW() * (i-1), y+4/768*ScrH()+45/768*ScrH()*(k-1), 158/1366*ScrW(), 92/768*ScrH(), alpha2)
						end
					else
						if GetConVar("dfhud_procedural_icons"):GetBool() and #v:GetModel() > 0 and (v.WepSelectIcon == nil or v.WepSelectIcon == surface.GetTextureID( 'weapons/swep' )) then
							surface.SetMaterial(DefaultHUD.GetIcon(v) or Material("pp/copy"))
							surface.SetDrawColor(color.r, color.g, color.b, alpha2)
						else
							surface.SetTexture(v.WepSelectIcon or v.SelectIcon or surface.GetTextureID( 'weapons/swep' ))
							surface.SetDrawColor(255, 255, 255, alpha2)
						end
						local sin = v.BounceWeaponIcon and math.sin(CurTime() * 8) * 8 + 8 or 0
						surface.DrawTexturedRect(x + 10/1366*ScrW() + 63/1366*ScrW() * (i-1), y+4/768*ScrH()+45/768*ScrH()*(k-1)+sin, 158/1366*ScrW(), 92/768*ScrH()-sin)
					end
					draw.SimpleText(tostring(i), "HudSelectionText", x + ( 8 / 1366 * ScrW() ) + (63 / 1366 * ScrW() ) * (i-1), 34/768*ScrH(), Color( color.r, color.g, color.b, alpha2 ))
					draw.SimpleText(tostring(v.PrintName or language.GetPhrase(v:GetClass())), "HudSelectionText", x + 90/1366*ScrW() + 63/1366*ScrW() * (i-1), y+107/768*ScrH()+45/768*ScrH()*(k-1), Color( color.r, color.g, color.b, alpha2 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					y = 120/768*ScrH()
				else
					draw.SimpleText(tostring(i), "HudSelectionText", x + ( 8 / 1366 * ScrW() ) + (63 / 1366 * ScrW() ) * (i-1), 34/768*ScrH(), Color( color.r, color.g, color.b, alpha2 ))
					draw.RoundedBox(8/768*ScrH(), x + 63/1366*ScrW() * (i-1), y+45/768*ScrH()*(k-1), 181/1366*ScrW(), 33/768*ScrH(), boxcolor)
					draw.SimpleText(tostring(v.PrintName or language.GetPhrase(v:GetClass())), "HudSelectionText", x + 90/1366*ScrW() + 63/1366*ScrW() * (i-1), y+12/768*ScrH()+45/768*ScrH()*(k-1), Color( color.r, color.g, color.b, alpha2 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
			end
			y = 25 / 768 * ScrH()
			x = 564 / 1366 * ScrW()
		else
			draw.RoundedBox(8/768*ScrH(), x + 63/1366*ScrW() * (i-1), y, 52/1366*ScrW(), 50/768*ScrH(), boxcolor)
			draw.SimpleText(tostring(i), "HudSelectionText", x + 8/1366*ScrW() + 63/1366*ScrW() * (i-1), 34/768*ScrH(), Color( color.r, color.g, color.b , alpha2 ))
		end
	end
	if bool then
		DefaultHUD.Angles2 = LocalPlayer():EyeAngles()
		cam.End3D2D()
		cam.End3D()
	end
end)
hook.Add("CreateMove", "DefaultHUDMove", function(cmd)
	if !hook.Run("HUDShouldDraw", "CHudWeaponSelection", true) and (!IsValid(LocalPlayer():GetActiveWeapon()) or !GetConVar("dfhud_enable"):GetBool() or !LocalPlayer():GetActiveWeapon():GetClass() != "weapon_camera") then return end
	if ( cmd:GetMouseWheel() != 0 ) and !cmd:KeyDown(IN_WEAPON1) and !cmd:KeyDown(IN_WEAPON2) and !cmd:KeyDown(IN_ATTACK) and !cmd:KeyDown(IN_ATTACK2) and LocalPlayer():Alive() then
		if DefaultHUD.Time < SysTime() then
			DefaultHUD.Slot = LocalPlayer():GetActiveWeapon():GetSlot()+1
			DefaultHUD.SlotPos = table.KeyFromValue(DefaultHUD.GetWeapons()[DefaultHUD.Slot], LocalPlayer():GetActiveWeapon())
		end
		DefaultHUD.MoveWeapons(cmd:GetMouseWheel() < 0 , LocalPlayer():GetActiveWeapon())
		DefaultHUD.Time = SysTime() + 1
		surface.PlaySound "common/wpn_moveselect.wav"
	end
end)
hook.Add("PlayerBindPress", "DefaultHUDPress", function(ply, bind)
	if !GetConVar("dfhud_enable"):GetBool() then return end
	if bind == "+attack" and DefaultHUD.Time > SysTime() and LocalPlayer():Alive() then
		input.SelectWeapon(DefaultHUD.GetWeapons()[DefaultHUD.Slot][DefaultHUD.SlotPos])
		DefaultHUD.Time = SysTime()
		DefaultHUD.bindslot = "0"
		surface.PlaySound "common/wpn_select.wav" 
		return true
	end
	if bind:find("slot") then
		if DefaultHUD.GetWeapons()[tonumber(bind:Right(1))][1] != nil then
			if DefaultHUD.bindslot != bind:Right(1) then DefaultHUD.bindslot = bind:Right(1) DefaultHUD.SlotPos = 0 end
			DefaultHUD.Time = SysTime() + 1
			DefaultHUD.Slot = tonumber(bind:Right(1))
			surface.PlaySound "common/wpn_moveselect.wav"
			DefaultHUD.SlotPos = DefaultHUD.GetWeapons()[DefaultHUD.Slot][DefaultHUD.SlotPos+1] and DefaultHUD.SlotPos+1 or 1
		end
	end
end)