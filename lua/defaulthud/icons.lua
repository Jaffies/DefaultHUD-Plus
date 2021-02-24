DefaultHUD = DefaultHUD or {}
-- Код с иконками стыбзил из своего прошлого аддона, называется CyberPunkHUD
function DefaultHUD.GetIcon(weapon) -- Позволяет получить иконку для выбора, или иконку для киллайкона или иконку из спавнменю.
	local weap = weapon
	local mat = CreateMaterial( "DefaultHUDIcons", "UnLitGeneric", {
	["$basetexture"] = "color/white",
	["$model"] = 1,
	["$alphatest"] = 1,
	["$vertexalpha"] = 1,
	["$vertexcolor"] = 1,
	})
	local icon = DefaultHUD.CreateIcon(weapon, 255, 0)
	mat:SetTexture("$basetexture", icon)
	return mat
end
function DefaultHUD.CreateIcon(weap, c1, c2)
	local icon = GetRenderTarget("DHUD/" .. weap:GetClass(), 512, 512, true)
	local weapmodel = weap:GetModel()
	render.PushRenderTarget(icon)
		local model = ClientsideModel(weapmodel) or weap
		local maxs, mins = model:GetModelBounds()
		local max, min =maxs:Length2D(), mins:Length2D()
		local angle = math.abs(maxs[1])+math.abs(mins[1]) > math.abs(maxs[2])+math.abs(mins[2]) and Angle(0,90,0) or Angle(0,9,0)
		render.OverrideAlphaWriteEnable( true, true )
		render.SetWriteDepthToDestAlpha( true )
		render.Clear(0,0,0,0,true,true)
		render.SetStencilWriteMask( 0xFF )
		render.SetStencilTestMask( 0xFF )
		render.SetStencilReferenceValue( 0 )
		render.SetStencilPassOperation( STENCIL_KEEP )
		render.SetStencilFailOperation( STENCIL_KEEP )
		render.SetStencilZFailOperation( STENCIL_KEEP )
		render.ClearStencil()
		render.SetStencilEnable( true )
		render.SetStencilReferenceValue( 1 )
		render.SetStencilCompareFunction( STENCIL_EQUAL )
		render.SetStencilFailOperation( STENCIL_REPLACE )
			cam.Start3D(mins, Angle(0,0,0), min+max, 0, 0, icon:Width(), icon:Height(), 2, 512)
				render.Model({
					model = weapmodel,
					pos = Vector(64,0,0) - Vector((maxs[1]-mins[1]) /2,(maxs[2]-mins[2]) /2,(maxs[3]-mins[3]) /2 ),
					angle = angle,
				})
			cam.End3D()
		render.SetStencilCompareFunction( STENCIL_EQUAL )
		render.ClearBuffersObeyStencil(c1, c1, c1, 255, false);
		render.SetStencilEnable( false )
		if GetConVar "dfhud_procedural_icons_style":GetBool() then goto end1 end
	--	model:SetModelScale( 0.99 )
		render.SetStencilWriteMask( 0xFF )
		render.SetStencilTestMask( 0xFF )
		render.SetStencilReferenceValue( 0 )
		render.SetStencilPassOperation( STENCIL_KEEP )
		render.SetStencilFailOperation( STENCIL_KEEP )
		render.SetStencilZFailOperation( STENCIL_KEEP )
		render.ClearStencil()
		render.SetStencilEnable( true )
		render.SetStencilReferenceValue( 1 )
		render.SetStencilCompareFunction( STENCIL_KEEP )
		render.SetStencilFailOperation( STENCIL_REPLACE )
			cam.Start3D(mins, Angle(0,0,0), (min+max)*1.1, 0, 0, icon:Width(), icon:Height(), 2, 512)
				render.Model({
					model = weapmodel,
					pos = Vector(65,0,0) - Vector((maxs[1]-mins[1]) /2,(maxs[2]-mins[2]) /2,(maxs[3]-mins[3]) /2 ),
					angle = angle,
				})
		cam.End3D()
		render.SetStencilCompareFunction( STENCIL_EQUAL )
		render.ClearBuffersObeyStencil(c2, c2, c2, 255, false);
		render.SetStencilEnable( false )
		::end1::
		render.PopRenderTarget()
		if model != weap then model:Remove() end
	return icon
end