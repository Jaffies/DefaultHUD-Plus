DefaultHUD = DefaultHUD or {}
DefaultHUD.HealthAlpha = 0
DefaultHUD.ArmorAlpha = 0
DefaultHUD.AmmoAlpha = 0
DefaultHUD.Ammo2Alpha = 0
DefaultHUD.Ammo3Alpha = 0
local function CreateFonts()
	surface.CreateFont("LuaHudNumbers", {
		font = 'HalfLife2',
		size = math.Round(51/768*ScrH()),
	})
	surface.CreateFont("LuaHudNumbersBlur", {
		font = 'HalfLife2',
		size = math.Round(51/768*ScrH()),
		blursize = 6,
		scanlines = 3,
	})
	surface.CreateFont("LuaHudHintTextLarge", {
		font = system.IsOSX() and "Helvetica Bold" or 'Verdana',
		size = math.Round(14/768*ScrH()),
		weight = 1000,
	})
	surface.CreateFont("LuaHudNumbersSmall", {
		font = system.IsOSX() and "Helvetica Bold" or 'Verdana',
		size = math.Round(24/768*ScrH()),
		weight = 50,
	})
	surface.CreateFont("LuaHudNumbersSmallBlur", {
		font = system.IsOSX() and "Helvetica Bold" or 'Verdana',
		size = math.Round(24/768*ScrH()),
		weight = 50,
		blursize = 5,
		scanlines = 3,
	})
	surface.CreateFont("LuaBoxRocket", {
		font = 'HalfLife2',
		size = math.Round(100 / 768 * ScrH()),
	})
	surface.CreateFont("LuaBoxRocketBlur", {
		font = 'HalfLife2',
		size = math.Round(100 / 768 * ScrH()),
		blursize = 4,
		scanlines = 3,
	})
end
CreateFonts()
DefaultHUD.Params = {}
dfhudhealth = 0
dfhudarmor = 0
dfhudammo1 = 0
dfhudammo2 = 0
DefaultHUD.Ammo = 0
DefaultHUD.SecAmmo = 0
DefaultHUD.AltAmmo = 0
DefaultHUD.Angles = Angle(0,0,0)
hook.Add("OnScreenSizeChanged", "DefaultHUDChangeSize", function()
	CreateFonts()
end)
hook.Add("Think", "DFHUDAlphas", function()
	if IsValid(LocalPlayer():GetActiveWeapon()) then
		local weapon1 = LocalPlayer():GetActiveWeapon()
		local tab = isfunction(weapon1.CustomAmmoDisplay) and weapon1:CustomAmmoDisplay() or {}
		DefaultHUD.Ammo = tab.PrimaryClip or weapon1:Clip1()
		DefaultHUD.SecAmmo = tab.PrimaryAmmo or LocalPlayer():GetAmmoCount(weapon1:GetPrimaryAmmoType())
		DefaultHUD.AltAmmo = tab.SecondaryAmmo or weapon1:GetSecondaryAmmoType() == -1 and -1 or LocalPlayer():GetAmmoCount(weapon1:GetSecondaryAmmoType())
		DefaultHUD.DrawAmmo = tab.Draw
		if dfhudammo1 != DefaultHUD.Ammo then
			DefaultHUD.Ammo1Alpha = 255
			dfhudammo1 = DefaultHUD.Ammo
		end
		if dfhudammo2 != DefaultHUD.SecAmmo then
			DefaultHUD.Ammo2Alpha = 255
			dfhudammo2 = DefaultHUD.SecAmmo
		end
		if dfhudammo3 != DefaultHUD.AltAmmo then
			DefaultHUD.Ammo3Alpha = 255
			dfhudammo3 = DefaultHUD.AltAmmo
		end
	end
	if dfhudhealth != LocalPlayer():Health() then
		DefaultHUD.HealthAlpha = 255
		dfhudhealth = LocalPlayer():Health()
	end
	if dfhudarmor != LocalPlayer():Armor() then
		DefaultHUD.ArmorAlpha = 255
		dfhudarmor = LocalPlayer():Armor()
	end
	if LocalPlayer():IsSprinting() then
		DefaultHUD.Params[3] = true
	else
		DefaultHUD.Params[3] = nil
	end
	if LocalPlayer():FlashlightIsOn() then
		DefaultHUD.Params[2] = true
	else
		DefaultHUD.Params[2] = nil
	end
	if LocalPlayer():WaterLevel() == 3 then
		DefaultHUD.Params[1] = true
	else
		DefaultHUD.Params[1] = nil
	end
end)
hook.Add("HUDShouldDraw", "DefaultHUD", function(hud, bool)
	if bool or !GetConVar("dfhud_enable"):GetBool() then return end -- return till next thingies
	if hud == "CHudWeaponSelection" or hud == "CHudHealth" or hud == "CHudBattery" or hud == "CHudAmmo" or  hud == "CHudSuitPower" or hud == "CHudSecondaryAmmo" then return false end
end)
hook.Add("DFHUDPaint", "DefaultHUDPaint", function(bool)
	local ScrH = ScrH
	local ScrW = ScrW -- Setting it to be a local var, so we'll won't change global one
	if !GetConVar("dfhud_enable"):GetBool() then return end
	surface.DisableClipping(true)
	if bool then
		local vel1 =math.AngleDifference(DefaultHUD.Angles[1], LocalPlayer():EyeAngles()[1])
		local vel2 = math.AngleDifference(DefaultHUD.Angles[2], LocalPlayer():EyeAngles()[2])
		cam.Start3D(Vector(0,0,0), Angle(0,0,0), 106, 0, 0, ScrW(), ScrH(), 4, 512)
			cam.Start3D2D(Vector(14,18+vel2/16,9.5-vel1/16), Angle(0, 278, 90), 0.026)
		ScrW = function() return 1366 end
		ScrH = function() return 768 end -- For 3D mode fix
	end
	local boxcolor = Color(GetConVar("dfhud_box_color_r"):GetInt(), GetConVar("dfhud_box_color_g"):GetInt(), GetConVar("dfhud_box_color_b"):GetInt(), GetConVar("dfhud_box_color_a"):GetInt())
	if hook.Run("HUDShouldDraw", "CHudHealth", true) and LocalPlayer():Alive() then
		local color = Color(GetConVar("dfhud_color_r"):GetInt(), GetConVar("dfhud_color_g"):GetInt(), GetConVar("dfhud_color_b"):GetInt())
		draw.NoTexture()
		render.SetStencilWriteMask( 0xFF )
		render.SetStencilTestMask( 0xFF )
		render.SetStencilReferenceValue( 0 )
		render.SetStencilPassOperation( STENCIL_KEEP )
		render.SetStencilZFailOperation( STENCIL_KEEP )
		render.ClearStencil()
		render.SetStencilEnable( true )
		render.SetStencilReferenceValue( 1 )
		render.SetStencilCompareFunction( STENCIL_NEVER )
		render.SetStencilFailOperation( STENCIL_REPLACE )
			draw.RoundedBox(8/768*ScrH(), 25/1366*ScrW(), 690/768*ScrH(), math.max(163/1366*ScrW(), 100), 59/768*ScrH(), boxcolor)
		render.SetStencilCompareFunction( STENCIL_EQUAL )
		render.SetStencilFailOperation( STENCIL_KEEP )
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(Material("pp/blurscreen"))
			local blur = GetConVar("dfhud_blur"):GetBool() and !GetConVar("dfhud_3d"):GetBool() and GetConVar("dfhud_blur_power"):GetInt() or 0
			for i=1, blur do
				Material("pp/blurscreen"):SetFloat("$blur", i)
				Material("pp/blurscreen"):Recompute()
				render.UpdateScreenEffectTexture()
				surface.DrawTexturedRectUV(0, 0, ScrW(), ScrH(), 0, 0, 1, 1)
			end
			draw.RoundedBox(8/768*ScrH(), 25/1366*ScrW(), 690/768*ScrH(), math.max(163/1366*ScrW(), 100), 59/768*ScrH(), boxcolor)
			draw.SimpleText("#Valve_Hud_HEALTH", "LuaHudHintTextLarge", 37/1366*ScrW(), 723/768*ScrH(), Color(color.r,color.g,color.b,255))
			draw.SimpleText(LocalPlayer():Health(), "LuaHudNumbersBlur", 105/1366*ScrW(), 694/768*ScrH(), Color(color.r,color.g,color.b,DefaultHUD.HealthAlpha))
			draw.SimpleText(LocalPlayer():Health(), "LuaHudNumbers", 105/1366*ScrW(), 694/768*ScrH(), Color(color.r,color.g,color.b,255))
		render.SetStencilEnable(false)
		DefaultHUD.HealthAlpha = math.max(0, DefaultHUD.HealthAlpha - FrameTime() * 156)
	end
	if hook.Run("HUDShouldDraw", "CHudBattery", true) and LocalPlayer():Alive() and LocalPlayer():Armor() > 0 then
		local color = Color(GetConVar("dfhud_color_r"):GetInt(), GetConVar("dfhud_color_g"):GetInt(), GetConVar("dfhud_color_b"):GetInt())
		draw.NoTexture()
		render.SetStencilWriteMask( 0xFF )
		render.SetStencilTestMask( 0xFF )
		render.SetStencilReferenceValue( 0 )
		render.SetStencilPassOperation( STENCIL_KEEP )
		render.SetStencilZFailOperation( STENCIL_KEEP )
		render.ClearStencil()
		render.SetStencilEnable( true )
		render.SetStencilReferenceValue( 1 )
		render.SetStencilCompareFunction( STENCIL_NEVER )
		render.SetStencilFailOperation( STENCIL_REPLACE )
			draw.RoundedBox(8/768*ScrH(), 225/1366*ScrW(), 690/768*ScrH(), 170/1366*ScrW(), 59/768*ScrH(), boxcolor)
		render.SetStencilCompareFunction( STENCIL_EQUAL )
		render.SetStencilFailOperation( STENCIL_KEEP )
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(Material("pp/blurscreen"))
			local blur = GetConVar("dfhud_blur"):GetBool() and !GetConVar("dfhud_3d"):GetBool() and GetConVar("dfhud_blur_power"):GetInt() or 0
			for i=1, blur do
				Material("pp/blurscreen"):SetFloat("$blur", i)
				Material("pp/blurscreen"):Recompute()
				render.UpdateScreenEffectTexture()
				surface.DrawTexturedRectUV(0, 0, ScrW(), ScrH(), 0, 0, 1, 1)
			end
			draw.RoundedBox(8/768*ScrH(), 225/1366*ScrW(), 690/768*ScrH(), 170/1366*ScrW(), 59/768*ScrH(), boxcolor)
			draw.SimpleText("#Valve_Hud_SUIT", "LuaHudHintTextLarge", 236/1366*ScrW(), 723/768*ScrH(), Color(color.r,color.g,color.b,255))
			draw.SimpleText(LocalPlayer():Armor(), "LuaHudNumbersBlur", 304/1366*ScrW(), 694/768*ScrH(), Color(color.r,color.g,color.b,DefaultHUD.ArmorAlpha))
			draw.SimpleText(LocalPlayer():Armor(), "LuaHudNumbers", 304/1366*ScrW(), 694/768*ScrH(), Color(color.r,color.g,color.b,255))
		render.SetStencilEnable(false)
		DefaultHUD.ArmorAlpha = math.max(0, DefaultHUD.ArmorAlpha - FrameTime() * 156)
	end
		-- Stamina Bar
	if LocalPlayer():GetSuitPower() < 100 and hook.Run("HUDShouldDraw", "CHudSuitPower", true) and LocalPlayer():Alive() then
		local color = Color(GetConVar("dfhud_color_r"):GetInt(), GetConVar("dfhud_color_g"):GetInt(), GetConVar("dfhud_color_b"):GetInt())
		render.SetStencilWriteMask( 0xFF )
		render.SetStencilTestMask( 0xFF )
		render.SetStencilReferenceValue( 0 )
		render.SetStencilPassOperation( STENCIL_KEEP )
		render.SetStencilZFailOperation( STENCIL_KEEP )
		render.ClearStencil()
		render.SetStencilEnable( true )
		render.SetStencilReferenceValue( 1 )
		render.SetStencilCompareFunction( STENCIL_NEVER )
		render.SetStencilFailOperation( STENCIL_REPLACE )
			draw.RoundedBox(8/768*ScrH(), 25/1366*ScrW(), 640/768*ScrH()-table.Count(DefaultHUD.Params)*16/768*ScrH(), 162/1366*ScrW(), 40/768*ScrH()+table.Count(DefaultHUD.Params)*16/768*ScrH(), boxcolor)
		render.SetStencilCompareFunction( STENCIL_EQUAL )
		render.SetStencilFailOperation( STENCIL_KEEP )
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(Material("pp/blurscreen"))
			local blur = GetConVar("dfhud_blur"):GetBool() and !GetConVar("dfhud_3d"):GetBool() and GetConVar("dfhud_blur_power"):GetInt() or 0
			for i=1, blur do
				Material("pp/blurscreen"):SetFloat("$blur", i)
				Material("pp/blurscreen"):Recompute()
				render.UpdateScreenEffectTexture()
				surface.DrawTexturedRectUV(0, 0, ScrW(), ScrH(), 0, 0, 1, 1)
			end
			draw.RoundedBox(8/768*ScrH(), 25/1366*ScrW(), 640/768*ScrH()-table.Count(DefaultHUD.Params)*16/768*ScrH(), 162/1366*ScrW(), 40/768*ScrH()+table.Count(DefaultHUD.Params)*16, boxcolor)
			draw.SimpleText("#Valve_Hud_AUX_POWER", "LuaHudHintTextLarge", 37/1366*ScrW(), 646/768*ScrH()-table.Count(DefaultHUD.Params)*16/768*ScrH(), Color(color.r, color.g, color.b, 255))
			for i = 0, 10 do
				surface.SetDrawColor(math.ceil(LocalPlayer():GetSuitPower() / 10 ) >= i+1 and color.r or color.r-100, math.ceil(LocalPlayer():GetSuitPower() / 10 ) >= i+1 and color.g or color.g-100, math.ceil(LocalPlayer():GetSuitPower() / 10 ) >= i+1 and color.b or color.b-100, math.ceil(LocalPlayer():GetSuitPower() / 10 ) >= i+1 and 255 or 150)
				surface.DrawRect(37/1366*ScrW()+i*13/1366*ScrW(), 665/768*ScrH()-table.Count(DefaultHUD.Params)*16/768*ScrH(), 10/1366*ScrW(), 5/768*ScrH())
			end
			local sdvig = 0
			for i=1, 3 do
				if DefaultHUD.Params[i] then
					sdvig = sdvig + 15/768*ScrH()
					draw.SimpleText(i == 1 and "#Valve_Hud_OXYGEN" or i == 2 and "#Valve_Hud_FLASHLIGHT" or "#Valve_Hud_SPRINT", "LuaHudHintTextLarge", 37/1366*ScrW(), 660/768*ScrH()-table.Count(DefaultHUD.Params)*16/768*ScrH()+sdvig, Color(color.r, color.g, color.b, 255))
				end
			end
		render.SetStencilEnable(false)
	end
	if bool then
		cam.End3D2D()
		cam.End3D()
		local vel1 =math.AngleDifference(DefaultHUD.Angles[1], LocalPlayer():EyeAngles()[1])
		local vel2 = math.AngleDifference(DefaultHUD.Angles[2], LocalPlayer():EyeAngles()[2])
		cam.Start3D(Vector(0,0,0), Angle(0,0,0), 106, 0, 0, ScrW(), ScrH(), 4, 512)
		cam.Start3D2D(Vector(18,16+vel2/16,9-vel1/16), Angle(0, 265, 90), 0.026)
	end
	if hook.Run("HUDShouldDraw", "CHudAmmo", true) and LocalPlayer():Alive() and IsValid(LocalPlayer():GetActiveWeapon()) and (DefaultHUD.DrawAmmo == nil and true or DefaultHUD.DrawAmmo) then
		local weapon = LocalPlayer():GetActiveWeapon()
		local color = Color(GetConVar("dfhud_color_r"):GetInt(), GetConVar("dfhud_color_g"):GetInt(), GetConVar("dfhud_color_b"):GetInt())
		if DefaultHUD.Ammo >= 0 and DefaultHUD.AltAmmo == -1 then
			render.SetStencilWriteMask( 0xFF )
			render.SetStencilTestMask( 0xFF )
			render.SetStencilReferenceValue( 0 )
			render.SetStencilPassOperation( STENCIL_KEEP )
			render.SetStencilZFailOperation( STENCIL_KEEP )
			render.ClearStencil()
			render.SetStencilEnable( true )
			render.SetStencilReferenceValue( 1 )
			render.SetStencilCompareFunction( STENCIL_NEVER )
			render.SetStencilFailOperation( STENCIL_REPLACE )
				draw.RoundedBox(8/768*ScrH(), 1125/1366*ScrW(), 690/768*ScrH(), 212/1366*ScrW(), 59/768*ScrH(), boxcolor)
			render.SetStencilCompareFunction( STENCIL_EQUAL )
			render.SetStencilFailOperation( STENCIL_KEEP )
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(Material("pp/blurscreen"))
				local blur = GetConVar("dfhud_blur"):GetBool() and !GetConVar("dfhud_3d"):GetBool() and GetConVar("dfhud_blur_power"):GetInt() or 0
				for i=1, blur do
					Material("pp/blurscreen"):SetFloat("$blur", i)
					Material("pp/blurscreen"):Recompute()
					render.UpdateScreenEffectTexture()
					surface.DrawTexturedRectUV(0, 0, ScrW(), ScrH(), 0, 0, 1, 1)
				end
				draw.RoundedBox(8/768*ScrH(), 1125/1366*ScrW(), 690/768*ScrH(), 212/1366*ScrW(), 59/768*ScrH(), boxcolor)
				draw.SimpleText("#Valve_Hud_AMMO", "LuaHudHintTextLarge", 1138/1366*ScrW(), 723/768*ScrH(), Color(color.r,color.g,color.b,255))
				draw.SimpleText(DefaultHUD.Ammo, "LuaHudNumbersBlur", 1190/1366*ScrW(), 694/768*ScrH(), Color(color.r,color.g,color.b,DefaultHUD.Ammo1Alpha))
				draw.SimpleText(DefaultHUD.Ammo, "LuaHudNumbers", 1190/1366*ScrW(), 694/768*ScrH(), Color(color.r,color.g,color.b,255))
				draw.SimpleText(DefaultHUD.SecAmmo, "LuaHudNumbersSmallBlur", 1283/1366*ScrW(), 718/768*ScrH(), Color(color.r,color.g,color.b,DefaultHUD.Ammo2Alpha))
				draw.SimpleText(DefaultHUD.SecAmmo, "LuaHudNumbersSmall", 1283/1366*ScrW(), 718/768*ScrH(), Color(color.r,color.g,color.b,255))
			render.SetStencilEnable(false)
			DefaultHUD.Ammo1Alpha = math.max(0, DefaultHUD.Ammo1Alpha - FrameTime() * 156)
			DefaultHUD.Ammo2Alpha = math.max(0, DefaultHUD.Ammo2Alpha - FrameTime() * 156)
		elseif DefaultHUD.SecAmmo > 0 and DefaultHUD.AltAmmo == -1 then
			render.SetStencilWriteMask( 0xFF )
			render.SetStencilTestMask( 0xFF )
			render.SetStencilReferenceValue( 0 )
			render.SetStencilPassOperation( STENCIL_KEEP )
			render.SetStencilZFailOperation( STENCIL_KEEP )
			render.ClearStencil()
			render.SetStencilEnable( true )
			render.SetStencilReferenceValue( 1 )
			render.SetStencilCompareFunction( STENCIL_NEVER )
			render.SetStencilFailOperation( STENCIL_REPLACE )
				draw.RoundedBox(8/768*ScrH(), 1178/1366*ScrW(), 690/768*ScrH(), 160/1366*ScrW(), 59/768*ScrH(), boxcolor)
			render.SetStencilCompareFunction( STENCIL_EQUAL )
			render.SetStencilFailOperation( STENCIL_KEEP )
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(Material("pp/blurscreen"))
				local blur = GetConVar("dfhud_blur"):GetBool() and !GetConVar("dfhud_3d"):GetBool() and GetConVar("dfhud_blur_power"):GetInt() or 0
				for i=1, blur do
					Material("pp/blurscreen"):SetFloat("$blur", i)
					Material("pp/blurscreen"):Recompute()
					render.UpdateScreenEffectTexture()
					surface.DrawTexturedRectUV(0, 0, ScrW(), ScrH(), 0, 0, 1, 1)
				end
				draw.RoundedBox(8/768*ScrH(), 1178/1366*ScrW(), 690/768*ScrH(), 160/1366*ScrW(), 59/768*ScrH(), boxcolor)
				draw.SimpleText("#Valve_Hud_AMMO", "LuaHudHintTextLarge", 1190/1366*ScrW(), 723/768*ScrH(), Color(color.r,color.g,color.b,255))
				draw.SimpleText(DefaultHUD.SecAmmo, "LuaHudNumbersBlur", 1242/1366*ScrW(), 694/768*ScrH(), Color(color.r,color.g,color.b,DefaultHUD.Ammo2Alpha))
				draw.SimpleText(DefaultHUD.SecAmmo, "LuaHudNumbers", 1242/1366*ScrW(), 694/768*ScrH(), Color(color.r,color.g,color.b,255))
			render.SetStencilEnable(false)
			DefaultHUD.Ammo2Alpha = math.max(0, DefaultHUD.Ammo2Alpha - FrameTime() * 156)
		elseif LocalPlayer():GetAmmoCount(weapon:GetPrimaryAmmoType()) > 0 then
			render.SetStencilWriteMask( 0xFF )
			render.SetStencilTestMask( 0xFF )
			render.SetStencilReferenceValue( 0 )
			render.SetStencilPassOperation( STENCIL_KEEP )
			render.SetStencilZFailOperation( STENCIL_KEEP )
			render.ClearStencil()
			render.SetStencilEnable( true )
			render.SetStencilReferenceValue( 1 )
			render.SetStencilCompareFunction( STENCIL_NEVER )
			render.SetStencilFailOperation( STENCIL_REPLACE )
				draw.RoundedBox(8/768*ScrH(), 1010/1366*ScrW(), 690/768*ScrH(), 212/1366*ScrW(), 59/768*ScrH(), boxcolor)
			render.SetStencilCompareFunction( STENCIL_EQUAL )
			render.SetStencilFailOperation( STENCIL_KEEP )
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(Material("pp/blurscreen"))
				local blur = GetConVar("dfhud_blur"):GetBool() and !GetConVar("dfhud_3d"):GetBool() and GetConVar("dfhud_blur_power"):GetInt() or 0
				for i=1, blur do
					Material("pp/blurscreen"):SetFloat("$blur", i)
					Material("pp/blurscreen"):Recompute()
					render.UpdateScreenEffectTexture()
					surface.DrawTexturedRectUV(0, 0, ScrW(), ScrH(), 0, 0, 1, 1)
				end
				draw.RoundedBox(8/768*ScrH(), 1010/1366*ScrW(), 690/768*ScrH(), 212/1366*ScrW(), 59/768*ScrH(), boxcolor)
				draw.SimpleText("#Valve_Hud_AMMO", "LuaHudHintTextLarge", 1023/1366*ScrW(), 723/768*ScrH(), Color(color.r,color.g,color.b,255))
				draw.SimpleText(DefaultHUD.Ammo, "LuaHudNumbersBlur", 1075/1366*ScrW(), 694/768*ScrH(), Color(color.r,color.g,color.b,DefaultHUD.Ammo1Alpha))
				draw.SimpleText(DefaultHUD.Ammo, "LuaHudNumbers", 1075/1366*ScrW(), 694/768*ScrH(), Color(color.r,color.g,color.b,255))
				draw.SimpleText(DefaultHUD.SecAmmo, "LuaHudNumbersSmallBlur", 1166/1366*ScrW(), 718/768*ScrH(), Color(color.r,color.g,color.b,DefaultHUD.Ammo2Alpha))
				draw.SimpleText(DefaultHUD.SecAmmo, "LuaHudNumbersSmall", 1166/1366*ScrW(), 718/768*ScrH(), Color(color.r,color.g,color.b,255))
			render.SetStencilEnable(false)
			-- Alt FIRE
			render.SetStencilWriteMask( 0xFF )
			render.SetStencilTestMask( 0xFF )
			render.SetStencilReferenceValue( 0 )
			render.SetStencilPassOperation( STENCIL_KEEP )
			render.SetStencilZFailOperation( STENCIL_KEEP )
			render.ClearStencil()
			render.SetStencilEnable( true )
			render.SetStencilReferenceValue( 1 )
			render.SetStencilCompareFunction( STENCIL_NEVER )
			render.SetStencilFailOperation( STENCIL_REPLACE )
				draw.RoundedBox(8/768*ScrH(), 1236/1366*ScrW(), 690/768*ScrH(), 112/1366*ScrW(), 59/768*ScrH(), boxcolor)
			render.SetStencilCompareFunction( STENCIL_EQUAL )
			render.SetStencilFailOperation( STENCIL_KEEP )
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(Material("pp/blurscreen"))
				local blur = GetConVar("dfhud_blur"):GetBool() and !GetConVar("dfhud_3d"):GetBool() and GetConVar("dfhud_blur_power"):GetInt() or 0
				for i=1, blur do
					Material("pp/blurscreen"):SetFloat("$blur", i)
					Material("pp/blurscreen"):Recompute()
					render.UpdateScreenEffectTexture()
					surface.DrawTexturedRectUV(0, 0, ScrW(), ScrH(), 0, 0, 1, 1)
				end
				draw.RoundedBox(8/768*ScrH(), 1236/1366*ScrW(), 690/768*ScrH(), 112/1366*ScrW(), 59/768*ScrH(), boxcolor)
				draw.SimpleText("#Valve_Hud_AMMO_ALT", "LuaHudHintTextLarge", 1246/1366*ScrW(), 726/768*ScrH(), Color(color.r,color.g,color.b,255))
				draw.SimpleText(DefaultHUD.AltAmmo, "LuaHudNumbersBlur", 1275/1366*ScrW(), 694/768*ScrH(), Color(color.r,color.g,color.b,DefaultHUD.Ammo3Alpha))
				draw.SimpleText(DefaultHUD.AltAmmo, "LuaHudNumbers", 1275/1366*ScrW(), 694/768*ScrH(), Color(color.r,color.g,color.b,255))
			render.SetStencilEnable(false)
			DefaultHUD.Ammo1Alpha = math.max(0, DefaultHUD.Ammo1Alpha - FrameTime() * 156)
			DefaultHUD.Ammo2Alpha = math.max(0, DefaultHUD.Ammo2Alpha - FrameTime() * 156)
			DefaultHUD.Ammo3Alpha = math.max(0, DefaultHUD.Ammo3Alpha - FrameTime() * 156)
		end
	end
	if bool then
		DefaultHUD.Angles = LocalPlayer():EyeAngles()
		cam.End3D2D()
		cam.End3D()
	end
	surface.DisableClipping(false)
end)
if !ispanel(DefaultHUD.HudPanel) then
	timer.Simple(1, function()
		DefaultHUD.HudPanel = vgui.Create("DPanel")
		function DefaultHUD.HudPanel:Paint()
			hook.Run("DFHUDPaint", GetConVar("dfhud_3d"):GetBool())
		end
		function DefaultHUD.HudPanel:OnScreenSizeChanged()
			self:SetSize(ScrW(), ScrH())
		end
		DefaultHUD.HudPanel:SetSize(ScrW(), ScrH())
		DefaultHUD.HudPanel:SetPos(0, 0)
	end)
end