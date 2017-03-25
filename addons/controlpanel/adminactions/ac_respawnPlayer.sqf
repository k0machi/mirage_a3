params
[
    ["_target", (uiNamespace getVariable["ACP_selectedPlayer", player]),[objNull]],
    ["_params", [],[[]]]
];

_params params[["_mode", "instant",[""]]];

switch _mode do
{
    case "forced": 
    {
        _target remoteExec["forceRespawn", _target];
    };
    case "instant":
    {
        [[_target],
        {
            params ["_target"];
            forceRespawn _target;
            setPlayerRespawnTime 0;
            [] spawn { sleep 5; setPlayerRespawnTime (getMissionConfigValue["respawnDelay", 60]) };
        }] remoteExec["bis_fnc_call", _target];
    };
    case "respawnDisabled":
    {
        [[_target],
        {
            params ["_oldUnit"];
            _side = west;
            _class = (typeOf _oldUnit);
            _pos = getPos _oldUnit;
            _newgrp = (createGroup _side);
            _loadout = getUnitLoadout _oldUnit;
            _old = _oldUnit;
            _new = _newgrp createUnit[_class, _pos, [], 0, "NONE"];
            selectPlayer _new;
            _new setUnitLoadout _loadout;
            ["Terminate",[]] call BIS_fnc_EGSpectator;
            _new setVehicleVarName (vehicleVarName _old);
        }] remoteExec["bis_fnc_call", _target];
    };
};