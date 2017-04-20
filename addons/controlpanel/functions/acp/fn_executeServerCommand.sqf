if !(isServer) exitWith {};
params ["_command","_asker"];

_password = getText (configFile >> "CfgAdmins" >> "serverCommandPassword");
_password serverCommand _command;