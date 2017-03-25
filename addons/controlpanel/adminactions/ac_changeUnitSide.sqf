params
[
    ["_target", (uiNamespace getVariable["ACP_selectedPlayer", player]),[objNull]],
    ["_params", [],[[]]]
];

_params params[["_side", west,[sideUnknown]], ["_includeGroup", false,[false]]];

([[_target], (units (group _target))] select _includeGroup) joinSilent (createGroup _side);