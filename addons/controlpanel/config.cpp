#define GUI_GRID_X	(0)
#define GUI_GRID_Y	(0)
#define GUI_GRID_W	(0.025)
#define GUI_GRID_H	(0.04)
#define GUI_GRID_WAbs	(1)
#define GUI_GRID_HAbs	(1)

class cfgPatches
{
	class MRG_ACP_F
	{
		author = "Xeno";
		authorUrl = "http://komachi.co.uk/";
		requiredAddons[] = { "A3_Functions_F" };
		units[] = {};
		vehicles[] = {};		
		version = "1.0";
		requiredVersion = 1.66;
	};
};

class CfgScriptPaths
{
    MRG_ACP = "mirage\addons\controlpanel\scripts\";
};

class cfgFunctions
{
	class MRG
	{
        class acp
        {
            file = "\mirage\addons\controlpanel\functions\acp";
            class adminControlPanel {};
            class requestAdminAccess {};
            class init 
            {
                postInit = 1;
                recompile = 1;
            };
        };
	};
};


class CfgAdminActions
{
    class MRG
    {
        class builtIn
        {
            file = "\mirage\addons\controlpanel\adminactions";
            class teleportToPlayer 
            {
                name = "Teleport player";
                tooltip = "Teleports player to your position.\nArguments: [invert::BOOL, includeVehicle::BOOL, you::OBJ]";
            };
            class squadTeleport
            {
                name = "Teleport to Squad";
                tooltip = "Teleports player to his current group.\nArguments: [mode::STRING, includeVehicle::BOOL]\nModes: leader, randomSquadmate, nearestUnit";
            };
            class healUnit
            {
                name = "Heal Unit";
                tooltip = "Heal Selected Unit.\nArguments: [ace3DisplayHealer::BOOL, healer::OBJ]";
            };
            class healEveryone
            {
                name = "Heal Everyone";
                tooltip = "Heal Every player.\nArguments: [ace3DisplayHealer::BOOL, healer::OBJ]";
            };
            class respawnPlayer
            {
                name = "Force Respawn";
                tooltip = "Respawn selected player.\nArguments: [mode::STRING]\nModes: forced, instant, respawnDisabled";
            };
            class changeUnitSide
            {
                name = "Change Side";
                tooltip = "Change selected unit side.\nArguments: [newSide::SIDE, includeGroup::BOOL]";
            };
            class createArsenalBox
            {
                name = "Spawn Arsenal Box";
                tooltip = "Create Arsenal Box infront of selected unit.\nArguments: [boxClass::STRING]";
            };
            class createZeusModule
            {
                name = "Create Zeus Module";
                tooltip = "Create Zeus Module and assign selected player as zeus.\nArguments: [name::STRING, addons::NUMBER]";
            };
            class vehicleLogistics
            {
                name = "Vehicle Service";
                tooltip = "Repair\Rearm\Refuel selected unit's vehicle.\nArguments: [repair::BOOL, rearm::BOOL, refuel::BOOL]";
            };
        };
    };
};

class RscStandardDisplay;
class IGUIBack;
class RscText;
class RscActiveText;
class RscButton;
class RscButtonMenu;
class RscButtonMenuCancel;
class RscStructuredText;
class RscEdit;
class RscListbox;
class RscCheckbox;
class RscPicture;
class RscMapControl;
class RscEditMulti;
class RscTitle;
class RscControlsGroup;

class MRGButtonMenu : RscButtonMenu
{
    idc = 17653;
    text = "Mirage Coordinator";
    x = "1 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX)";
    y = "15 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + safezoneY";
    w = "15 * (((safezoneW / safezoneH) min 1.2) / 40)";
    h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
    onButtonClick = "(findDisplay 49) closeDisplay 0; [] spawn Xeno_fnc_requestAdminAccess";
};

class RscDisplayMPInterrupt: RscStandardDisplay 
{
    class controls 
    {
        class MRGOpenMenu : MRGButtonMenu {};
    };
};

class RscDisplayInterruptEditorPreview: RscStandardDisplay 
{
    class controls 
    {
        class MRGOpenMenu : MRGButtonMenu {};
    };
};

class RscDisplayInterrupt: RscStandardDisplay {
    class controls 
    {
        class MRGOpenMenu : MRGButtonMenu {};
    };
};

class RscDisplayInterruptEditor3D: RscStandardDisplay {
    class controls 
    {
        class MRGOpenMenu : MRGButtonMenu {};
    };
};

class RscDisplayMovieInterrupt: RscStandardDisplay 
{
    class controls 
    {
        class MRGOpenMenu : MRGButtonMenu {};
    };
};

class RscDisplayAdministrator : RscStandardDisplay
{	
    idd = 12400;
	enableSimulation = 1;
    onLoad = "[""onLoad"",_this,""RscDisplayAdministrator"",'MRG_ACP'] call (uinamespace getvariable 'BIS_fnc_initDisplay');";
    onUnload = "[""onUnload"",_this,""RscDisplayAdministrator"",'MRG_ACP'] call (uinamespace getvariable 'BIS_fnc_initDisplay')";
    scriptPath = "MRG_ACP";
    scriptName = "RscDisplayAdministrator";
    class controls
    {
        class playerList: RscListbox
        {
            idc = 1500;
            moving = 1;
            x = -11 * GUI_GRID_W + GUI_GRID_X;
            y = 1 * GUI_GRID_H + GUI_GRID_Y;
            w = 14.5 * GUI_GRID_W;
            h = 12.5 * GUI_GRID_H;
        };
        class buttonCameraMode: RscButton
        {
            idc = 1600;
            moving = 1;
            text = "CameraMode"; //--- ToDo: Localize;
            x = 3.5 * GUI_GRID_W + GUI_GRID_X;
            y = 23 * GUI_GRID_H + GUI_GRID_Y;
            w = 15.5 * GUI_GRID_W;
            h = 3 * GUI_GRID_H;
        };
        class ctCamera: RscPicture
        {
            idc = 1100;
            moving = 1;
            text = "#(argb,512,512,1)r2t(miragecameraview,1.25)";
            x = 3.5 * GUI_GRID_W + GUI_GRID_X;
            y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 15.5 * GUI_GRID_W;
            h = 9.5 * GUI_GRID_H;
            onLoad = "";
            tooltip = "ViewPort"; //--- ToDo: Localize;
        };
        class actionList: RscListbox
        {
            idc = 1501;
            moving = 1;
            x = 19 * GUI_GRID_W + GUI_GRID_X;
            y = 1 * GUI_GRID_H + GUI_GRID_Y;
            w = 15.5 * GUI_GRID_W;
            h = 22 * GUI_GRID_H;
        };
        class codeField: RscEdit
        {
            idc = 1400;
            moving = 1;
            style = 16+0;
            autocomplete = "scripting";
            x = 34.5 * GUI_GRID_W + GUI_GRID_X;
            y = 1 * GUI_GRID_H + GUI_GRID_Y;
            w = 20.5 * GUI_GRID_W;
            h = 14 * GUI_GRID_H;
        };
        class WatchInput1: RscEdit
        {
            idc = 1420;
            autocomplete = "scripting";
            font = "EtelkaMonospacePro";
            shadow = 0;
            sizeEx = "0.7 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            x = 34.5 * GUI_GRID_W + GUI_GRID_X;
            y = 15 * GUI_GRID_H + GUI_GRID_Y;
            w = 20.5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
        };
        class WatchInput2: WatchInput1
        {
            idc = 1422;
            y = 17 * GUI_GRID_H + GUI_GRID_Y;
        };
        class WatchInput3: WatchInput1
        {
            idc = 1424;
            y = 19 * GUI_GRID_H + GUI_GRID_Y;
        };
        class WatchInput4: WatchInput1
        {
            idc = 1426;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
        };
        class WatchOutput1: RscEdit
        {
            idc = 1421;
            x = 34.5 * GUI_GRID_W + GUI_GRID_X;
            y = 16 * GUI_GRID_H + GUI_GRID_Y;
            w = 20.5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {0,0,0,0.75};
            font = "EtelkaMonospacePro";
            style = 512;
            sizeEx = "0.7 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
        };
        class WatchOutput2: WatchOutput1
        {
            idc = 1423;
            x = 34.5 * GUI_GRID_W + GUI_GRID_X;
            y = 18 * GUI_GRID_H + GUI_GRID_Y;
            w = 20.5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
        };
        class WatchOutput3: WatchOutput1
        {
            idc = 1425;
            x = 34.5 * GUI_GRID_W + GUI_GRID_X;
            y = 20 * GUI_GRID_H + GUI_GRID_Y;
            w = 20.5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
        };
        class WatchOutput4: WatchOutput1
        {
            idc = 1427;
            x = 34.5 * GUI_GRID_W + GUI_GRID_X;
            y = 22 * GUI_GRID_H + GUI_GRID_Y;
            w = 20.5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
        };
        class buttonAction: RscButton
        {
            idc = 1601;
            moving = 1;
            text = "EXECUTE"; //--- ToDo: Localize;
            x = 19 * GUI_GRID_W + GUI_GRID_X;
            y = 23 * GUI_GRID_H + GUI_GRID_Y;
            w = 15.5 * GUI_GRID_W;
            h = 3 * GUI_GRID_H;
        };
        class buttonServerExec: RscButton
        {
            idc = 1602;
            moving = 1;
            text = "Server Exec"; //--- ToDo: Localize;
            x = 34.5 * GUI_GRID_W + GUI_GRID_X;
            y = 23 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 3 * GUI_GRID_H;
        };
        class ButtonRemoteExec: RscButton
        {
            idc = 1603;
            moving = 1;
            text = "Remote Exec"; //--- ToDo: Localize;
            x = 41.5 * GUI_GRID_W + GUI_GRID_X;
            y = 23 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 3 * GUI_GRID_H;
        };
        class buttonLocalExec: RscButton
        {
            idc = 1604;
            moving = 1;
            text = "Local Exec"; //--- ToDo: Localize;
            x = 48.5 * GUI_GRID_W + GUI_GRID_X;
            y = 23 * GUI_GRID_H + GUI_GRID_Y;
            w = 6.5 * GUI_GRID_W;
            h = 3 * GUI_GRID_H;
        };
        class ButtonClose: RscActiveText
        {
            idc = 1201;
            moving = 1;
            style = 48;
            color[] = {1,1,1,0.7};
            colorActive[] = {1,1,1,1};
            colorBackground[] = {0,0,0,0};
            colorDisabled[] = {1,1,1,0.25};
            colorText[] = {1,1,1,0.7};
            tooltip = "Close";
            text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayArcadeMap\icon_exit_cross_ca.paa";
            x = 53 * GUI_GRID_W + GUI_GRID_X;
            y = -0.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 2 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;
        };
        class ButtonConsole: RscActiveText
        {
            idc = 1202;
            moving = 1;
            style = 48;
            color[] = {1,1,1,0.7};
            colorActive[] = {1,1,1,1};
            colorBackground[] = {0,0,0,0};
            colorDisabled[] = {1,1,1,0.25};
            colorText[] = {1,1,1,0.7};
            text = "\mirage\addons\controlpanel\res\iconConsole.paa";
            x = 50 * GUI_GRID_W + GUI_GRID_X;
            y = -0.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 2 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;
            tooltip = "Open Debug Console"; //--- ToDo: Localize;
        };
        class ctUnitInfo: RscStructuredText
        {
            idc = 1101;
            moving = 1;
            text = "UnitInfo"; //--- ToDo: Localize;
            x = -11 * GUI_GRID_W + GUI_GRID_X;
            y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 14.5 * GUI_GRID_W;
            h = 9.5 * GUI_GRID_H;
            onLoad = "";
        };
        class ctMap: RscMapControl
        {
            idc = 1102;
            moving = 1;
            x = 3.5 * GUI_GRID_W + GUI_GRID_X;
            y = 1 * GUI_GRID_H + GUI_GRID_Y;
            w = 15.5 * GUI_GRID_W;
            h = 12.5 * GUI_GRID_H;
        };
        class buttonClear : buttonClose
        {
            idc = 1203;
            text = "\mirage\addons\controlpanel\res\iconClearLog.paa";
            tooltip = "Clear Message Log";
            x = 40.5 * GUI_GRID_W + GUI_GRID_X;
            y = 26.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
        };
        class logWindowGroup : RscControlsGroup
        {
            idc = 1190;
            x = 4 * GUI_GRID_W + GUI_GRID_X;
            y = 28 * GUI_GRID_H + GUI_GRID_Y;
            w = 37 * GUI_GRID_W;
            h = 5.5 * GUI_GRID_H;  
            class controls
            {
                class logWindow : RscEdit
                {
                    idc = 1110;
                    text = "test";
                    canModify = 0;
                    style = 16+0;
                    font = "EtelkaMonospacePro";
                    sizeEx = "0.7 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
                    colorBackground[] = {0,0,0,0.5};
                    x = 0;
                    y = 0;
                    w = 36 * GUI_GRID_W;
                    h = 5.4 * GUI_GRID_H;  
                };
            };
        };
    };
    class controlsBackground
    {
        class IGUIBack_2200: IGUIBack
        {
            idc = 2200;
            moving = 1;
            x = -11 * GUI_GRID_W + GUI_GRID_X;
            y = -0.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 66 * GUI_GRID_W;
            h = 26.5 * GUI_GRID_H;
        };
        class IGUIBack_2201: IGUIBack
        {
            idc = 2201;
            moving = 1;
            colorBackground[] = {0,0,0,0.75};
            x = 34.5 * GUI_GRID_W + GUI_GRID_X;
            y = 1 * GUI_GRID_H + GUI_GRID_Y;
            w = 20.5 * GUI_GRID_W;
            h = 22 * GUI_GRID_H;
        };
        class messagesBg : IGUIBack_2200
        {
            idc = 2300;
            colorBackground[] = {0,0,0,0.30};
            x = 3.5 * GUI_GRID_W + GUI_GRID_X;
            y = 26.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 38 * GUI_GRID_W;
            h = 7.5 * GUI_GRID_H;            
        };
        class TitleBar: RscTitle
        {
            idc = 2201;
            moving = 1;
            x = -11 * GUI_GRID_W + GUI_GRID_X;
            y = -0.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 66 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])","(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"};
        };
        class TitleText: RscText
        {
            idc = 1000;
            moving = 1;
            text = "Admin Control Panel"; //--- ToDo: Localize;
            x = -11 * GUI_GRID_W + GUI_GRID_X;
            y = -0.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 11.5 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;
        };
        class messagesTitleBar : TitleBar
        {
            idc = 2301;
            x = 3.5 * GUI_GRID_W + GUI_GRID_X;
            y = 26.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 38 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
        };
        class messagesTitleText: TitleText
        {
            idc = 2302;
            text = "Log Window";
            x = 3.5 * GUI_GRID_W + GUI_GRID_X;
            y = 26.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 8 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
        };
    };
};