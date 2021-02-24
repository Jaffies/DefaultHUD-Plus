if SERVER then
	AddCSLuaFile "defaulthud/selector.lua"
	AddCSLuaFile "defaulthud/tables.lua"
	AddCSLuaFile "defaulthud/icons.lua"
	AddCSLuaFile "defaulthud/main.lua"
else
	include "defaulthud/selector.lua"
	include "defaulthud/tables.lua"
	include "defaulthud/icons.lua"
	include "defaulthud/main.lua"
end
CreateConVar("dfhud_enable", 1, FCVAR_ARCHIVE, "Enables DefaultHUD+", 0,1)
CreateConVar("dfhud_3d", 0, FCVAR_ARCHIVE, "Enables 3D mode", 0,1)
CreateConVar("dfhud_procedural_icons", 0, FCVAR_ARCHIVE, "Enables procedural icons when icon is not supplied", 0,1)
CreateConVar("dfhud_procedural_icons_style", 0, FCVAR_ARCHIVE, "Controls procedural icons style", 0,1)
CreateConVar("dfhud_color_r", 255, FCVAR_ARCHIVE, "Conrols HUD's color", 0,255)
CreateConVar("dfhud_color_g", 255, FCVAR_ARCHIVE, "Conrols HUD's color", 0,255)
CreateConVar("dfhud_color_b", 0, FCVAR_ARCHIVE, "Conrols HUD's color", 0,255)
CreateConVar("dfhud_box_color_r", 0, FCVAR_ARCHIVE, "Conrols HUD's color", 0,255)
CreateConVar("dfhud_box_color_g", 0, FCVAR_ARCHIVE, "Conrols HUD's color", 0,255)
CreateConVar("dfhud_box_color_b", 0, FCVAR_ARCHIVE, "Conrols HUD's color", 0,255)
CreateConVar("dfhud_box_color_a", 100, FCVAR_ARCHIVE, "Conrols HUD's color", 0,255)
CreateConVar("dfhud_blur", 0, FCVAR_ARCHIVE, "Enables HUD's blur", 0, 1)
CreateConVar("dfhud_blur_power", 3, FCVAR_ARCHIVE, "Conrols HUD's blur power", 0, 15)