
#define ACTIONSPATH (configFile >> "CfgAdminActions")
#include "\a3\editor_f\Data\Scripts\dikCodes.h"

params ["_mode"];

switch (_mode) do
{
    case "postInit":
    {
        //Log EH
        [missionNamespace, "ACP_messageToLog", 
        {
            params ["_message", "_printToRPT", "_broadcast"];
            _log = missionNamespace getVariable["ACP_messageLog",[]];
            _log pushBack format["%1MT: %2",[time, "HH:MM:SS"] call BIS_fnc_secondsToString, _message];
            missionNamespace setVariable["ACP_messageLog", _log];
            if (_printToRPT) then { diag_log format["%1:MT ACP-MESSAGE: %2", [time, "HH:MM:SS"] call BIS_fnc_secondsToString, _message] };
            if (_broadcast) then { missionNamespace setVariable["ACP_netMessage", str _message, true]; ACP_netMessage = nil; };
        }] call BIS_fnc_addScriptedEventHandler;
        //netMessage Listener
        "ACP_netMessage" addPublicVariableEventHandler {
            [missionNamespace, "ACP_messageToLog", [format["[NETWORK] %1", (_this select 1)],true,false]] call BIS_fnc_callScriptedEventHandler;
        };
        //Dedicated Server ACL Listener -- DEPRECATED
        /*
        "ACP_requestAccess" addPublicVariableEventHandler {
            (_this select 1) params ["_uid", "_netId"];
            if (clientOwner == _netId) exitWith {};
            _ACL = getArray(configFile >> "CfgAdmins" >> "ids") + getArray(missionConfigFile >> "CfgAdmins" >> "ids");
            if (_uid in _ACL) then { ACP_response = 0; } else { ACP_response = 1; };
            _netId publicVariableClient "ACP_response";
        };
        
        //ACL Response Listener
        missionNamespace setVariable["ACP_response", 2];
        */
        //Compile actions and store them in missionNamespace
        {
            _prefix = configName _x;
            {
                _cat = configName _x;
                _parentPath = _x;
                _file = if !(isText(_x >> "file")) then { nil } else { getText (_x >> "file") };
                {
                    _acName = configName _x;
                    _EXT = if (isText(_x >> "extension")) then { getText (_x >> "extension") } else { ".sqf" };
                    _scriptPath = if !(isText(_x >> "file")) then { [("adminactions" + "\" + _cat + "\" + "ac_" + _acName + _EXT), (getText (_parentPath >> "file") + (["\", ""] select (getText (_parentPath >> "file") select[(count getText (_parentPath >> "file")) - 1, 1] == "\" || count getText (_parentPath >> "file") < 1)) + "ac_" + _acName + _EXT)] select !(isNil "_file") } else { getText (_x >> "file") };
                    _act = compileFinal (format["_act_scriptName = ""%1_act_%2"";",_prefix, _acName] + preProcessFileLineNumbers _scriptPath);
                    missionNamespace setVariable[format["%1_act_%2", _prefix,_acName], _act];
                } foreach ("true" configClasses _x);
            } foreach ("true" configClasses _x);
        } foreach (("true" configClasses (missionConfigFile >> "CfgAdminActions" )) + ("true" configClasses ACTIONSPATH));
        [missionNamespace, "ACP_messageToLog", ["postInit finished",true,false]] call BIS_fnc_callScriptedEventHandler;
        if (missionNamespace getVariable["cba_keybinding", false]) then
        {
            ["Mirage Coordinator", "OpenMirage", ["Open Mirage Coordinator", "Opens Administration Control Panel"], { ["Client",[]] spawn MRG_fnc_requestAdminAccess; false }, { }, [DIK_F12, [true, true, false]],false] call cba_fnc_addKeybind;
            [missionNamespace, "ACP_messageToLog", ["CBA Keybinding detected. Adding Hotkeys",true,false]] call BIS_fnc_callScriptedEventHandler;
        };
    };
};