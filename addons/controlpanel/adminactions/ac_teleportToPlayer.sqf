params
[
    ["_target", (uiNamespace getVariable["ACP_selectedPlayer", player]),[objNull]],
    ["_params", [],[[]]]
];

_params params[["_reverse", false,[true]], ["_transferVehicle", false,[false]], ["_player", player,[objNull]]];

if !(_reverse) then 
{
    if !(_transferVehicle) then
    {
        if (vehicle _target != _target) then { _target remoteExec["moveOut", _target] };
        _target setPosATL (_player getRelPos [2,90]);
    }
    else
    {
        (vehicle _target) setPosATL (_player getRelPos [2,90]);
    };    
} 
else 
{ 
    _player setPosATL (_target getRelPos [2,90]);
};