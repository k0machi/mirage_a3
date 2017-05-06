#define A3

#define IDC_PLAYER_LISTBOX 1500
#define IDC_TITLE_TEXT  1000

#define IDC_ACTION_LISTBOX 1501
#define IDC_ACTION_TREE 1901
#define IDC_ACTION_PARAMS 1502

#define IDC_MAP 1102
#define IDC_CAMERA 1100
#define IDC_UNIT_INFO 1101
#define IDC_BUTTON_CLOSE 1201
#define IDC_BUTTON_CONSOLE 1202
#define IDC_BUTTON_ACTION 1601
#define IDC_BUTTON_KICK 1607
#define IDC_BUTTON_BAN 1608
#define IDC_BUTTON_RESTART 1609
#define IDC_BUTTON_EXEC_LOCAL 1604
#define IDC_BUTTON_EXEC_REMOTE 1603
#define IDC_BUTTON_EXEC_SERVER 1602
#define IDC_BUTTON_CONSOLE_SAVE 1800
#define IDC_BUTTON_CONSOLE_LOAD 1801
#define IDC_BUTTON_CONSOLE_PREV 1802
#define IDC_BUTTON_CONSOLE_NEXT 1803
#define IDC_BUTTON_CONSOLE_CFG 1804
#define IDC_BUTTON_CONSOLE_HELP 1805
#define IDC_BUTTON_CAMERA_MODE 1600
#define IDC_BUTTON_CLEAR_LOG 1203
#define IDC_CODE_EDITBOX 1400
#define IDC_ACP_WATCHINPUT1 1420
#define IDC_ACP_WATCHINPUT2 1422
#define IDC_ACP_WATCHINPUT3 1424
#define IDC_ACP_WATCHINPUT4 1426
#define IDC_ACP_WATCHOUTPUT1 1421
#define IDC_ACP_WATCHOUTPUT2 1423
#define IDC_ACP_WATCHOUTPUT3 1425
#define IDC_ACP_WATCHOUTPUT4 1427
#define IDC_MESSAGE_FIELD 1110

#define MAP_ZOOM 0.1
#define MAP_SPEED 1
#define SCALE ((0.04) * (0.95))

#define IDC_OK 1
#define IDC_CANCEL 2

#define COLOR_BLUFOR [(profilenamespace getvariable ['Map_BLUFOR_R',0]),(profilenamespace getvariable ['Map_BLUFOR_G',1]),(profilenamespace getvariable ['Map_BLUFOR_B',1]),(profilenamespace getvariable ['Map_BLUFOR_A',0.8])]
#define COLOR_OPFOR [(profilenamespace getvariable ['Map_OPFOR_R',0]),(profilenamespace getvariable ['Map_OPFOR_G',1]),(profilenamespace getvariable ['Map_OPFOR_B',1]),(profilenamespace getvariable ['Map_OPFOR_A',0.8])]
#define COLOR_INDEPENDENT [(profilenamespace getvariable ['Map_Independent_R',0]),(profilenamespace getvariable ['Map_Independent_G',1]),(profilenamespace getvariable ['Map_Independent_B',1]),(profilenamespace getvariable ['Map_Independent_A',0.8])]
#define COLOR_CIV [(profilenamespace getvariable ['Map_Civilian_R',0]),(profilenamespace getvariable ['Map_Civilian_G',1]),(profilenamespace getvariable ['Map_Civilian_B',1]),(profilenamespace getvariable ['Map_Civilian_A',0.8])]

#define PLAYER_LIST allPlayers

#define CAMERA_OFFSET [0.12,0,0.15]
#define CAMERA_TARGET_OFFSET [0,8,1]
#define CAMERA_VEHICLE_OFFSET [0,-8,4]
#define CAMERA_VEHICLE_TARGET_OFFSET [0,8,2]
#define MEMORY_POINT "Head"

#define RENDER_SURFACE "miragecameraview"
#define NORMAL_MODE 0
#define NVG_MODE 1
#define TI_WHOT_MODE 2
#define TI_BHOT_MODE 7

#define ACTIONS_CONFIG_PATH (configFile >> "CfgAdminActions")

#define CONTROL	(_display displayctrl _idc)
#define GETCONTROL(x) (_display displayctrl x)



_fnc_addActions = 
{
    _actionList = [];
    {
        {
            _tag = if (getText (_x >> "tag") == "") then { configName _x } else { getText (_x >> "tag") };
            {
                {
                    _name = [getText (_x >> "name"), format["%1_act_%2",_tag,configName _x]] select (getText(_x >> "name") == "");
                    _tooltip = [getText (_x >> "tooltip"), "This action has no additional information associated with it."] select (getText(_x >> "tooltip") == "");
                    _action = format["%1_act_%2", _tag, configName _x];
                    _actionList pushBack [_name,_tooltip, _action];
                } foreach ("true" configClasses _x);
            } foreach ("true" configClasses _x);
        } foreach ("true" configClasses _x);
    } foreach [configFile >> "CfgAdminActions", missionConfigFile >> "CfgAdminActions"];
    _actionList
};

_fnc_addActions2 = 
{
    _actionList = [];
    {
        {
            _tag = if (getText (_x >> "tag") == "") then { configName _x } else { getText (_x >> "tag") };
            {
                _cat = if (getText (_x >> "category") == "") then { configName _x } else { getText (_x >> "category") };
                _catList = [];
                {
                    _name = [getText (_x >> "name"), format["%1_act_%2",_tag,configName _x]] select (getText(_x >> "name") == "");
                    _tooltip = [getText (_x >> "tooltip"), "This action has no additional information associated with it."] select (getText(_x >> "tooltip") == "");
                    _action = format["%1_act_%2", _tag, configName _x];
                    _catList pushBack [_name,_tooltip, _action];
                } foreach ("true" configClasses _x);
                _actionList pushBack [_cat, _catList];
            } foreach ("true" configClasses _x);
        } foreach ("true" configClasses _x);        
    } foreach [configFile >> "CfgAdminActions", missionConfigFile >> "CfgAdminActions"];
    _actionList
};

params ["_mode", "_params"];
disableSerialization;

if (count _this <= 1) exitWith
{
    with uiNamespace do
    {
        _displayMission = call (uiNamespace getVariable "BIS_fnc_displayMission");
        _displayMission createDisplay "RscDisplayAdministrator";
    };
};

switch (_mode) do
{
    case "Init": 
    {
        _display = _params select 0;
        GETCONTROL(IDC_TITLE_TEXT) ctrlSetText format["Welcome, %1", profileName];
        //Watchfield & Expression initialization - Thanks BI!
        _ctrlExpression = _display displayctrl IDC_CODE_EDITBOX;
        _ctrlExpression ctrlsettext (profilenamespace getvariable ["RscDisplayAdministrator_expression",""]);
        {
            disableSerialization;
            private _input = _display displayCtrl _x;
            private _value = profileNamespace getVariable ["RscDebugConsole_watch" + str (_forEachIndex + 1), [true, ""]];
            if !(_value isEqualTypeParams [true, ""]) then {_value = [true, _value]}; //backward compatibility
            _input ctrlSetText (_value select 1);
            _input setVariable ["RscDebugConsole_watchStatus", _value];
        }
        forEach [
            IDC_ACP_WATCHINPUT1,
            IDC_ACP_WATCHINPUT2,
            IDC_ACP_WATCHINPUT3,
            IDC_ACP_WATCHINPUT4
        ];

        #define LIMIT_WARNING 0.003
        #define COLOR_WARNING [0.8,0.4,0,0.5]
        #define LIMIT_CRITICAL 0.1
        #define COLOR_CRITICAL [0.5,0.1,0,0.8]
        #define WATCH_FIELD_FNC(WATCHINPUT,WATCHOUTPUT) \
        { \
            disableSerialization; \
            private _display = _this select 0; \
            private _input = _display displayCtrl WATCHINPUT; \
            private _this = ctrlText _input; \
            if !("h" in (call (missionNamespace getVariable "mrg_checkflags"))) exitWith \
            { \
                _input ctrlEnable false; \
                _display displayCtrl WATCHOUTPUT ctrlSetText "ACCESS DENIED"; \
            }; \
            if (_this isEqualTo "") exitWith \
            { \
                _input ctrlSetBackgroundColor [0,0,0,0]; \
                _display displayCtrl WATCHOUTPUT ctrlSetText ""; \
            }; \
            private _status = _input getVariable "RscDebugConsole_watchStatus"; \
            if (!(_status select 0) && {_status select 1 isEqualTo _this}) exitWith {_input ctrlSetBackgroundColor COLOR_CRITICAL}; \
            private _timeStart = diag_tickTime; \
            _display displayCtrl WATCHOUTPUT ctrlSetText (_this call \
            { \
                private ["_display", "_input", "_status", "_timeStart", "_x"]; \
                _this = [nil] apply compile _this select 0; \
                if (isNil "_this") exitWith {""}; \
                str _this \
            }); \
            private _duration = diag_tickTime - _timeStart; \
            if (_duration < LIMIT_WARNING) exitWith \
            { \
                _input ctrlSetBackgroundColor [0,0,0,0]; \
                _status set [0, true]; \
            }; \
            _input ctrlSetBackgroundColor COLOR_WARNING; \
            _status set [0, false]; \
            if (_duration > LIMIT_CRITICAL) exitWith {_status set [1, _this]}; \
            _status set [1, ""]; \
        }
        _display displayAddEventHandler ["MouseMoving", WATCH_FIELD_FNC(IDC_ACP_WATCHINPUT1,IDC_ACP_WATCHOUTPUT1)];
        _display displayAddEventHandler ["MouseHolding", WATCH_FIELD_FNC(IDC_ACP_WATCHINPUT1,IDC_ACP_WATCHOUTPUT1)];
        _display displayAddEventHandler ["MouseMoving", WATCH_FIELD_FNC(IDC_ACP_WATCHINPUT2,IDC_ACP_WATCHOUTPUT2)];
        _display displayAddEventHandler ["MouseHolding", WATCH_FIELD_FNC(IDC_ACP_WATCHINPUT2,IDC_ACP_WATCHOUTPUT2)];
        _display displayAddEventHandler ["MouseMoving", WATCH_FIELD_FNC(IDC_ACP_WATCHINPUT3,IDC_ACP_WATCHOUTPUT3)];
        _display displayAddEventHandler ["MouseHolding", WATCH_FIELD_FNC(IDC_ACP_WATCHINPUT3,IDC_ACP_WATCHOUTPUT3)];
        _display displayAddEventHandler ["MouseMoving", WATCH_FIELD_FNC(IDC_ACP_WATCHINPUT4,IDC_ACP_WATCHOUTPUT4)];
        _display displayAddEventHandler ["MouseHolding", WATCH_FIELD_FNC(IDC_ACP_WATCHINPUT4,IDC_ACP_WATCHOUTPUT4)];
        //Start Processing controls
        GETCONTROL(IDC_BUTTON_EXEC_LOCAL) ctrlAddEventHandler["ButtonClick", { with uiNamespace do { ["onExecLocal", _this] call MRG_fnc_adminControlPanel} }];
        GETCONTROL(IDC_BUTTON_EXEC_REMOTE) ctrlAddEventHandler["ButtonClick", { with uiNamespace do { ["onExecRemote", _this] call MRG_fnc_adminControlPanel} }];
        GETCONTROL(IDC_BUTTON_EXEC_SERVER) ctrlAddEventHandler["ButtonClick", { with uiNamespace do { ["onExecServer", _this] call MRG_fnc_adminControlPanel} }];
        GETCONTROL(IDC_BUTTON_CONSOLE_SAVE) ctrlAddEventHandler["ButtonClick", { with uiNamespace do { ["onButtonSave", _this] call MRG_fnc_adminControlPanel} }];
        GETCONTROL(IDC_BUTTON_CONSOLE_LOAD) ctrlAddEventHandler["ButtonClick", { with uiNamespace do { ["onButtonLoad", _this] call MRG_fnc_adminControlPanel} }];
        GETCONTROL(IDC_BUTTON_KICK) ctrlAddEventHandler["ButtonClick", { with uiNamespace do { ["onButtonKick", _this] call MRG_fnc_adminControlPanel} }];
        GETCONTROL(IDC_BUTTON_BAN) ctrlAddEventHandler["ButtonClick", { with uiNamespace do { ["onButtonBan", _this] call MRG_fnc_adminControlPanel} }];
        GETCONTROL(IDC_BUTTON_RESTART) ctrlAddEventHandler["ButtonClick", { with uiNamespace do { ["onButtonRestart", _this] call MRG_fnc_adminControlPanel} }];
        GETCONTROL(IDC_BUTTON_ACTION) ctrlAddEventHandler["ButtonClick", { with uiNamespace do { ["onAction", _this] call MRG_fnc_adminControlPanel} }];
        GETCONTROL(IDC_BUTTON_CLOSE) ctrlAddEventHandler["MouseButtonClick", { with uiNamespace do { ["Exit", _this] call MRG_fnc_adminControlPanel} }];
        GETCONTROL(IDC_BUTTON_CONSOLE) ctrlAddEventHandler["MouseButtonClick", { with uiNamespace do { ["onButtonConsole", _this] call MRG_fnc_adminControlPanel} }];
        GETCONTROL(IDC_BUTTON_CAMERA_MODE) ctrlAddEventHandler["ButtonClick", { with uiNamespace do { ["onButtonCameraMode", _this] call MRG_fnc_adminControlPanel} }];
        GETCONTROL(IDC_BUTTON_CLEAR_LOG) ctrlAddEventHandler["ButtonClick", { with uiNamespace do { ["onButtonClear", _this] call MRG_fnc_adminControlPanel} }];
        GETCONTROL(IDC_PLAYER_LISTBOX) ctrlAddEventHandler["LBSelChanged", { with uiNamespace do { ["onPlayerListSelectionChanged", _this] call MRG_fnc_adminControlPanel} }];
        GETCONTROL(IDC_PLAYER_LISTBOX) ctrlAddEventHandler["onLBDblClick", { with uiNamespace do { ["onPlayerListDblClick", _this] call MRG_fnc_adminControlPanel} }];
        { GETCONTROL((_x select 0)) ctrlEnable ([false,true] select ((_x select 1) in (call (missionNamespace getVariable "mrg_checkflags")))); } foreach [[IDC_BUTTON_KICK,"a"], [IDC_BUTTON_BAN,"b"], [IDC_BUTTON_RESTART, "c"], [IDC_BUTTON_ACTION,"d"], [IDC_BUTTON_EXEC_LOCAL, "e"], [IDC_BUTTON_EXEC_REMOTE, "f"], [IDC_BUTTON_EXEC_SERVER,"g"],[IDC_BUTTON_CONSOLE,"h"]];
        
        private _idc = IDC_PLAYER_LISTBOX;
        { 
            CONTROL lbAdd name _x;
            CONTROL lbSetPicture [_forEachIndex, ["\a3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa", "\a3\ui_f\data\Map\VehicleIcons\iconCar_ca.paa"] select (vehicle _x != _x)];
            CONTROL lbSetPictureColor [_forEachIndex, ([COLOR_BLUFOR, COLOR_OPFOR, COLOR_INDEPENDENT, COLOR_CIV,[1,0,0,1],COLOR_CIV] select ([west,east,resistance,civilian,sideEnemy,sideLogic] find (side _x)))];
            CONTROL lbSetTooltip [_forEachIndex, getPlayerUID _x];
        } foreach PLAYER_LIST;
        _center = PLAYER_LIST select 0;
        uiNamespace setVariable["ACP_selectedPlayer", _center];
        CONTROL lbSetCurSel 0;
        /*
        _idc = IDC_ACTION_LISTBOX;
        { 
            CONTROL lbAdd (_x select 0);
            CONTROL lbSetTooltip [_foreachIndex, (_x select 1)];
            CONTROL lbSetData [_foreachIndex, (_x select 2)];
        } foreach (call _fnc_addActions);
        */
        _idc = IDC_ACTION_TREE;
        {
            CONTROL tvAdd [[], _x select 0];
            _path = _forEachIndex;
            {
                CONTROL tvAdd[[_path], _x select 0];
                CONTROL tvSetTooltip[[_path, _forEachIndex], _x select 1];
                CONTROL tvSetData [[_path, _forEachIndex], _x select 2];
            } foreach (_x select 1);            
        } foreach (call _fnc_addActions2);
        _idc = IDC_MAP;
        CONTROL ctrlMapAnimAdd[MAP_SPEED, MAP_ZOOM,_center];
        ctrlMapAnimCommit CONTROL;
        _idc = IDC_UNIT_INFO;
        CONTROL ctrlSetStructuredText parseText format ["Name: %1<br />Class: %2<br />Side: <t color='%8'>%3</t><br />Map Position: <br />   X: %4<br />   Y: %5<br />   Z: %6<br />GRIDREF: %7<br /><a href='https://steamcommunity.com/profiles/%9'>Steam Profile</a>", name _center, typeOf _center, side _center, round ((getPosATL _center) select 0), round ((getPosATL _center) select 1), round ((getPosATL _center) select 2), mapGridPosition _center,(([COLOR_BLUFOR, COLOR_OPFOR, COLOR_INDEPENDENT, COLOR_CIV,[1,0,0,1],COLOR_CIV] select ([west,east,resistance,civilian,sideEnemy,sideLogic] find (side _center))) call BIS_fnc_colorRGBAtoHTML), getPlayerUID _center];
        _idc = IDC_BUTTON_CAMERA_MODE;
        CONTROL ctrlSetText "NORMAL";
        _display setVariable["camMode", 0];
        _idc = IDC_CAMERA;
        private _camera = "camera" camCreate [0,0,0];
        private _tgt = "Sign_Sphere10cm_F" createVehicleLocal [0,0,0];
        hideObject _tgt;
        uiNamespace setVariable["ACP_Camera", _camera];
        uiNamespace setVariable["ACP_Target", _tgt];
        _camera camSetTarget _tgt;
        _camera camCommit 0;
        _camera cameraEffect ["INTERNAL", "BACK", RENDER_SURFACE];
        if (vehicle _center != _center) then
        {
            _camera attachTo [vehicle _center, CAMERA_VEHICLE_OFFSET];
            _tgt attachTo[vehicle _center, CAMERA_VEHICLE_TARGET_OFFSET];
        }
        else
        {
            _camera attachTo [_center, CAMERA_OFFSET,MEMORY_POINT];
            _tgt attachTo[_center, CAMERA_TARGET_OFFSET];            
        };
        _idc = IDC_MESSAGE_FIELD; 
        _input = missionNamespace getVariable["ACP_messageLog", []]; 
        _pos = ctrlPosition CONTROL;
        _newHeight = count _input * SCALE;
        CONTROL ctrlSetText (_input joinString toString [10]); 
        CONTROL ctrlSetPosition [_pos select 0, _pos select 1, _pos select 2, [_newHeight, _pos select 3] select (_pos select 3 > _newHeight)]; 
        CONTROL ctrlCommit 0;
        #define LOGFUNC(LOGWINDOW) \
        { \
            disableSerialization; \
            private _display = _this select 0; \
            private _control = _display displayCtrl LOGWINDOW; \
            _input = missionNamespace getVariable["ACP_messageLog", []]; \
            _pos = ctrlPosition _control; \
            _newHeight = count _input * SCALE; \
            _control ctrlSetText (_input joinString toString [10]); \
            _control ctrlSetPosition [_pos select 0, _pos select 1, _pos select 2, [_newHeight, _pos select 3] select (_pos select 3 > _newHeight)]; \
            _control ctrlCommit 0; \
        }
        _display displayAddEventHandler ["MouseMoving", LOGFUNC(IDC_MESSAGE_FIELD)];
        _display displayAddEventHandler ["MouseHolding", LOGFUNC(IDC_MESSAGE_FIELD)];
    };
    case "onButtonSave": 
    {
        _display = (uiNamespace getVariable "RscDisplayAdministrator");
        profileNamespace setVariable["RscDisplayAdministrator_expression", ctrlText GETCONTROL(IDC_CODE_EDITBOX)];
    };
    case "onButtonLoad":
    {
        _display = (uiNamespace getVariable "RscDisplayAdministrator");
        GETCONTROL(IDC_CODE_EDITBOX) ctrlSetText (profileNamespace getVariable["RscDisplayAdministrator_expression", ""]);
    };
    case "onExecLocal":
    {
        private _display = (uiNamespace getVariable "RscDisplayAdministrator");
        private _idc = IDC_CODE_EDITBOX;
        private _center = uiNamespace getVariable["ACP_selectedPlayer", player];
        if ("e" in (call (missionNamespace getVariable "mrg_checkflags"))) then
        {
            with missionNamespace do 
            { 
                [_center] call compile ctrlText CONTROL;
                [missionNamespace, "ACP_messageToLog", [format["Local code execution by %1", profileName],false,true]] call BIS_fnc_callScriptedEventHandler;
            };   
        }
        else
        {
            [missionNamespace, "ACP_messageToLog", [format["Not enough permissions", profileName],false,false]] call BIS_fnc_callScriptedEventHandler;
        };
    };
    case "onButtonClear":
    {
        private _display = (uiNamespace getVariable "RscDisplayAdministrator");
        private _idc = (_this select 0);
        missionNamespace setVariable["ACP_messageLog", []];
        [missionNamespace, "ACP_messageToLog", ["Log Window Cleared",false,false]] call BIS_fnc_callScriptedEventHandler;
    };
    case "onPlayerListDblClick":
    {
        private _display = (uiNamespace getVariable "RscDisplayAdministrator");
        private _idc = (_this select 0);
        private _center = uiNamespace getVariable["ACP_selectedPlayer", player];
        [missionNamespace, "ACP_messageToLog", [format["Steam profile of %1(%2): https://steamcommunity.com/profiles/%2", name _center, getPlayerUID _center],false,false]] call BIS_fnc_callScriptedEventHandler;
    };
    case "onButtonConsole":
    {
        private _display = (uiNamespace getVariable "RscDisplayAdministrator");
        private _idc = (_this select 0);
        if ("h" in (call (missionNamespace getVariable "mrg_checkflags"))) then
        {
            [missionNamespace, "ACP_messageToLog", [format["RscDisplayDebugPublic opened by %1", profileName],false,true]] call BIS_fnc_callScriptedEventHandler;
            _display createDisplay "RscDisplayDebugPublic";
        }
        else
        {
            [missionNamespace, "ACP_messageToLog", [format["Not enough permissions", profileName],false,false]] call BIS_fnc_callScriptedEventHandler;
        };
        
    };
    case "onButtonKick":
    {
        private _center = uiNamespace getVariable["ACP_selectedPlayer", player];
        if ("a" in (call (missionNamespace getVariable "mrg_checkflags"))) then
        {
            [format["#kick %1", getPlayerUID _center], getPlayerUID player, getPlayerUID _center, serverCommandAvailable "#logout"] remoteExec ["MRG_fnc_executeServerCommand"];
            [missionNamespace, "ACP_messageToLog", [format["Player %1 (%2) has been kicked from the server by %3", name _center, getPlayerUID _center, profileName],true,true]] call BIS_fnc_callScriptedEventHandler;
        }
        else
        {
            [missionNamespace, "ACP_messageToLog", [format["Not enough permissions", profileName],false,false]] call BIS_fnc_callScriptedEventHandler;
        };
        
    };
    case "onButtonBan":
    {
        private _center = uiNamespace getVariable["ACP_selectedPlayer", player];
        if ("b" in (call (missionNamespace getVariable "mrg_checkflags"))) then
        {
            [format["#exec ban ""%1""", getPlayerUID _center], getPlayerUID player, getPlayerUID _center, serverCommandAvailable "#logout"] remoteExec ["MRG_fnc_executeServerCommand"];
            [missionNamespace, "ACP_messageToLog", [format["Player %1 (%2) has been banned from the server by %3", name _center, getPlayerUID _center, profileName],true,true]] call BIS_fnc_callScriptedEventHandler;
        }
        else
        {
            [missionNamespace, "ACP_messageToLog", [format["Not enough permissions", profileName],false,false]] call BIS_fnc_callScriptedEventHandler;
        };
    };
    case "onButtonRestart":
    {
        if ("c" in (call (missionNamespace getVariable "mrg_checkflags"))) then
        {
            if ((missionNamespace getVariable["acp_confirmRestart", 0]) == 4) then
            {
                [missionNamespace, "ACP_messageToLog", [format["Mission Restart by %1", profileName],true,true]] call BIS_fnc_callScriptedEventHandler;
                ["#restart", getPlayerUID player, getPlayerUID player, serverCommandAvailable "#logout"] remoteExec ["MRG_fnc_executeServerCommand"];
            }
            else
            {
                _level = missionNamespace getVariable["acp_confirmRestart", 0];
                [missionNamespace, "ACP_messageToLog", [format["Please click %1 more times to confirm restart.", 4-_level],false,false]] call BIS_fnc_callScriptedEventHandler;
                missionNamespace setVariable["acp_confirmRestart", _level + 1];
            };
        }
        else
        {
            [missionNamespace, "ACP_messageToLog", [format["Not enough permissions", profileName],false,false]] call BIS_fnc_callScriptedEventHandler;
        };
    };
    case "onAction":
    {
        private _display = (uiNamespace getVariable "RscDisplayAdministrator");
        private _center = uiNamespace getVariable["ACP_selectedPlayer", player];
        private _args = ctrlText GETCONTROL(IDC_ACTION_PARAMS);
        private _action = GETCONTROL(IDC_ACTION_TREE) tvData (tvCurSel GETCONTROL(IDC_ACTION_TREE));
        private _format = format["[_center, [%1]] call %2",_args,_action];
        systemchat format["Current selected tree action: %1", GETCONTROL(IDC_ACTION_TREE) tvData (tvCurSel GETCONTROL(IDC_ACTION_TREE))];
        if ("d" in (call (missionNamespace getVariable "mrg_checkflags"))) then
        {
            with missionNamespace do 
            { 
                call compile _format;
                [missionNamespace, "ACP_messageToLog", [format["An action named '%1' has been executed on %2 by %3", _action, name _center, profileName],false,true]] call BIS_fnc_callScriptedEventHandler;        
            };   
        }
        else
        {
            [missionNamespace, "ACP_messageToLog", [format["Not enough permissions", profileName],false,false]] call BIS_fnc_callScriptedEventHandler;
        };     
    };
    case "onButtonCameraMode":
    {
        private _display = (uiNamespace getVariable "RscDisplayAdministrator");
        private _cmode = _display getVariable "camMode";
        private _idc = IDC_BUTTON_CAMERA_MODE;
        private _modes = [NORMAL_MODE, NVG_MODE,TI_WHOT_MODE];
        private _modeStr = ["NORMAL", "NIGHTVISION", "THERMAL WHOT"];
        RENDER_SURFACE setPiPEffect [(_modes select (_cmode + 1))];
        CONTROL ctrlSetText (_modeStr select (_cmode + 1)); 
        _display setVariable["camMode", if (_cmode == 2) then { _cmode = -1; _cmode } else { _cmode + 1 }];
    };
    case "onPlayerListSelectionChanged":
    {
        private _display = (uiNamespace getVariable "RscDisplayAdministrator");
        private _idc = IDC_MAP;
        private _center = PLAYER_LIST select (_params select 1);
        uiNamespace setVariable["ACP_selectedPlayer", _center];        
        CONTROL ctrlMapAnimAdd[MAP_SPEED, MAP_ZOOM,_center];
        ctrlMapAnimCommit CONTROL;
        _idc = IDC_UNIT_INFO;
        CONTROL ctrlSetStructuredText parseText format ["Name: %1<br />Class: %2<br />Side: <t color='%8'>%3</t><br />Map Position: <br />   X: %4<br />   Y: %5<br />   Z: %6<br />GRIDREF: %7<br /><a href='https://steamcommunity.com/profiles/%9'>Steam Profile</a>", name _center, typeOf _center, side _center, round ((getPosATL _center) select 0), round ((getPosATL _center) select 1), round ((getPosATL _center) select 2), mapGridPosition _center,(([COLOR_BLUFOR, COLOR_OPFOR, COLOR_INDEPENDENT, COLOR_CIV,[1,0,0,1],COLOR_CIV] select ([west,east,resistance,civilian,sideEnemy,sideLogic] find (side _center))) call BIS_fnc_colorRGBAtoHTML), getPlayerUID _center];
        _camera = uiNamespace getVariable["ACP_Camera", objNull];
        _tgt = uiNamespace getVariable["ACP_Target", objNull];
        detach _camera;
        detach _tgt;
        if (vehicle _center != _center) then
        {
            _camera attachTo [vehicle _center, CAMERA_VEHICLE_OFFSET, "camera"];
            _tgt attachTo[vehicle _center, CAMERA_VEHICLE_TARGET_OFFSET];
        }
        else
        {
            _camera attachTo [_center, CAMERA_OFFSET,MEMORY_POINT];
            _tgt attachTo[_center, CAMERA_TARGET_OFFSET];            
        };
    };
    case "onExecServer":
    {
        private _display = (uiNamespace getVariable "RscDisplayAdministrator");
        private _idc = IDC_CODE_EDITBOX;
        private _center = uiNamespace getVariable["ACP_selectedPlayer", player];
        if ("g" in (call (missionNamespace getVariable "mrg_checkflags"))) then
        {
            with missionNamespace do
            {
                private _callback = [[_center], compile ctrlText CONTROL] remoteExecCall["call", [0,2] select isMultiplayer];
                [missionNamespace, "ACP_messageToLog", [format["Server code execution by %1", profileName],false,true]] call BIS_fnc_callScriptedEventHandler;
            };   
        }
        else
        {
            [missionNamespace, "ACP_messageToLog", [format["Not enough permissions", profileName],false,false]] call BIS_fnc_callScriptedEventHandler;
        };
    };
    case "onExecRemote":
    {
        private _display = (uiNamespace getVariable "RscDisplayAdministrator");
        private _idc = IDC_CODE_EDITBOX;
        private _center = uiNamespace getVariable["ACP_selectedPlayer", player];
        if ("f" in (call (missionNamespace getVariable "mrg_checkflags"))) then
        {
            with missionNamespace do
            {
                private _callback = [[_center], compile ctrlText CONTROL] remoteExecCall["call", _center];
                [missionNamespace, "ACP_messageToLog", [format["Code execution on %1 by %2", name _center, profileName],false,true]] call BIS_fnc_callScriptedEventHandler;
            };
        }
        else
        {
            [missionNamespace, "ACP_messageToLog", [format["Not enough permissions", profileName],false,false]] call BIS_fnc_callScriptedEventHandler;
        };
    };
    case "Exit": 
    {
        (uiNamespace getVariable["ACP_Camera", objNull]) cameraEffect ["TERMINATE", "BACK"];
        camDestroy (uiNamespace getVariable["ACP_Camera", objNull]);
        deleteVehicle (uiNamespace getVariable["ACP_Camera", objNull]);
        deleteVehicle (uiNamespace getVariable["ACP_Target", objNull]);
        (uiNamespace getVariable "RscDisplayAdministrator") closeDisplay IDC_OK;
        missionNamespace setVariable ["ACP_response", [2,""]];
        missionNamespace setVariable["acp_confirmRestart", 0];
    };
};