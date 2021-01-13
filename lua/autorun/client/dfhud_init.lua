local function GetPhrase(str, default)
	return language.GetPhrase(str) == str and default or language.GetPhrase(str)
end
hook.Add("AddToolMenuCategories", "DFHUDAdd", function() 
	spawnmenu.AddToolCategory("Options", "DefaultHUDMenu", "Default HUD+")
end)
hook.Add("PopulateToolMenu", "DFHUDPopulate", function() // Наполняем менюшку
	spawnmenu.AddToolMenuOption("Options", "DefaultHUDMenu", "DFHUDOptions", GetPhrase("dfhud.options", "Options"), "", "", function(panel)
		panel:ClearControls()
		panel:Help(GetPhrase("dfhud.help", "This is Default HUD+ options!"))
		panel:CheckBox(GetPhrase("dfhud.enable", "Enable DefaultHUD+?"), "dfhud_enable")
		panel:CheckBox(GetPhrase("dfhud.3d", "Enable 3D mode?"), "dfhud_3d")
		panel:CheckBox(GetPhrase("dfhud.proceduralicons", "Enable procedural icons?"), "dfhud_procedural_icons")
		panel:CheckBox(GetPhrase("dfhud.proceduralicons.style", "Procedural icons style"), "dfhud_procedural_icons_style")
		local picker = vgui.Create("DColorMixer")
		picker:SetLabel(GetPhrase("dfhud.help2", "DefaultHUD+ color"))
		picker:SetAlphaBar(false)
		picker:SetConVarR "dfhud_color_r"
		picker:SetConVarG "dfhud_color_g"
		picker:SetConVarB "dfhud_color_b"
		local picker2 = vgui.Create("DColorMixer")
		picker2:SetAlphaBar(true)
		picker2:SetPalette(false)
		picker2:SetLabel(GetPhrase("dfhud.help2", "another DefaultHUD+ box color"))
		picker2:SetConVarA "dfhud_box_color_a"
		picker2:SetConVarR "dfhud_box_color_r"
		picker2:SetConVarG "dfhud_box_color_g"
		picker2:SetConVarB "dfhud_box_color_b"
		panel:AddItem(picker)
		panel:AddItem(picker2)
	end)
end)