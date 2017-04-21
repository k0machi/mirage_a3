params
[
    ["_target", (uiNamespace getVariable["ACP_selectedPlayer", player]),[objNull]],
    ["_params", [],[[]]]
];


[_target] call BIS_fnc_neutralizeUnit;