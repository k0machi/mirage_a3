params
[
    ["_target", (uiNamespace getVariable["ACP_selectedPlayer", player]),[objNull]],
    ["_params", [],[[]]]
];

_params params[["_classname", "Box_NATO_Equip_F",[""]]];

_box = createVehicle[_classname, _target getRelPos[3,0], [],0,"CAN_COLLIDE"];
_box setDir (direction _target - 90);
_box allowDamage false;
["AmmoboxInit", [_box, true, {true}]] call BIS_fnc_arsenal;