params
[
    ["_target", (uiNamespace getVariable["ACP_selectedPlayer", player]),[objNull]],
    ["_params", [],[[]]]
];

["Open", [true,nil,_target]] spawn BIS_fnc_arsenal;