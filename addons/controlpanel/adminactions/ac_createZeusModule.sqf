params
[
    ["_target", (uiNamespace getVariable["ACP_selectedPlayer", player]),[objNull]],
    ["_params", [],[[]]]
];

_params params[["_name", "Zeus",[""]], ["_addons", 3,[0]]];

private _suffix = toUpper(((name _target) splitString " ") joinString "");

[[_suffix, _target],
{
    params ["_suffix", "_unit"];
    missionNamespace setVariable["UNIT_" + _suffix, _unit,true];
    _unit setVehicleVarName "UNIT_"+_suffix;
    _unit addEventHandler["Respawn",{params["_unit","_oldUnit"]; _unit setVehicleVarName (vehicleVarName _oldUnit); missionNamespace setVariable[vehicleVarName _unit, _unit,true];}];
    activateAddons (("true" configClasses (configFile >> "CfgPatches") apply { configName _x });
}] remoteExec ["call", _target];

[[_suffix, _name, _addons],
{
    params ["_suffix", "_name", "_addons"];
    activateAddons (("true" configClasses (configFile >> "CfgPatches") apply { configName _x });
    _gmModule = (createGroup sideLogic) createUnit["ModuleCurator_F", [0,90,90], [], 0, "NONE"];
    _gmModule setVariable["owner", "UNIT_"+_suffix];
    _gmModule setVariable["Addons", _addons];
    _gmModule setVariable["name", _name];
    [_gmModule, [], true] call BIS_fnc_moduleCurator;
    _gmModule addCuratorEditableObjects[entities "", true];
    [_gmModule, "GM_"+_suffix] remoteExecCall["setVehicleVarName", 0];
    missionNamespace setVariable["GM_"+_suffix, _gmModule, true];
}] remoteExec["call", 2];

[[],
{
    activateAddons (("true" configClasses (configFile >> "CfgPatches") apply { configName _x });
}] remoteExec["call", -2];