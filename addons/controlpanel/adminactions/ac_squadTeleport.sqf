params
[
    ["_target", (uiNamespace getVariable["ACP_selectedPlayer", player]),[objNull]],
    ["_params", [],[[]]]
];

_params params[["_mode", "nearestUnit",[""]], ["_includeVehicle", false,[false]]];

if (_includeVehicle) then { _target = vehicle _target } else { if (vehicle _target != _target) then { _target remoteExec["moveOut", _target]; } };


switch (_mode) do
{
    case "leader": 
    {
        _unit = leader (group _target);
        _target setPosATL (_unit getRelPos[2,90]);
        if (vehicle _unit != _unit && !(_includeVehicle)) then { [_target, vehicle _unit] remoteExec["moveInAny", _target] };
    };
    case "randomSquadmate":
    {
        _unit = selectRandom((units (group _target)) - [_target]);
        _target setPosATL (_unit getRelPos[2,90]);
        if (vehicle _unit != _unit && !(_includeVehicle)) then { [_target, vehicle _unit] remoteExec["moveInAny", _target] };
    };
    case "nearestUnit":
    {
        private _distArr = [];
        {
            _distArr pushBack (_target distance _x);
        } foreach ((units (group _target)) - [_target]);
        _distArrSort = +_distArr;
        _distArrSort sort true;
        systemChat str [_distArr,_distArrSort];
        _unit = ((units (group _target) - [_target]) select (_distArr find (_distArrSort select 0)));
        _target setPosATL (_unit getRelPos[2,90]);
        if (vehicle _unit != _unit && !(_includeVehicle)) then { [_target, vehicle _unit] remoteExec["moveInAny", _target] };
    };
};