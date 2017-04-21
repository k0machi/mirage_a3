if !(isServer) exitWith {};
params ["_command","_asker", "_target", "_isLoggedIn"];

private _adminList = getArray(configFile >> "CfgAdmins" >> "ids"); 
private _missionAdminList = getArray(missionConfigFile >> "CfgAdmins" >> "ids"); 
private _adminPower = 0;
private _targetPower = if ((_target in (_adminList + _missionAdminList)) && !(_target in _missionAdminList)) then { parseNumber (getArray(configFile >> "CfgAdmins" >> "flags") select (_adminList find _target));  } else { [-9999,(parseNumber ((getText(configFile >> "CfgAdmins" >> "flagsMission") splitString ":") select 0))] select (_target in _missionAdminList)};

if !(_asker in _adminList) then 
{
    _adminPower = parseNumber ((getText(configFile >> "CfgAdmins" >> "flagsMission") splitString ":") select 0) 
} 
else 
{ 
    _adminPower = parseNumber (((getArray(configFile >> "CfgAdmins" >> "flags") select (_adminList find _asker)) splitString ":") select 0); 
};

if !(_asker in (_adminList + _missionAdminList)) exitWith 
{ 
    [missionNamespace, "ACP_messageToLog", [format["Unathorized usage of server commands by %1", _asker],true,true]] call BIS_fnc_callScriptedEventHandler; 
};

if (_adminPower < _targetPower && !(_isLoggedIn)) exitWith { [missionNamespace, "ACP_messageToLog", [format["Not enough power to execute server commands on %2 (A: %1)", _asker, _target],true,true]] call BIS_fnc_callScriptedEventHandler; };

_password = getText (configFile >> "CfgAdmins" >> "serverCommandPassword");
_password serverCommand _command;