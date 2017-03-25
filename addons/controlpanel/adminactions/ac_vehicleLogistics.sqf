params
[
    ["_target", (uiNamespace getVariable["ACP_selectedPlayer", player]),[objNull]],
    ["_params", [],[[]]]
];

_params params[["_repair", true ,[true]],["_rearm", false ,[true]],["_refuel", false ,[true]]];

if ((vehicle _target) isKindOf "Man") exitWith {};

if (_repair) then { (vehicle _target) setDamage 0 };
if (_rearm) then { [(vehicle _target), 1] remoteExec["setVehicleAmmo", (vehicle _target)]; };
if (_refuel) then { [(vehicle _target), 1] remoteExec["setFuel", (vehicle _target)]; };