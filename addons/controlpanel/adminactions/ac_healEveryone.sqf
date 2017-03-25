params
[
    ["_target", (uiNamespace getVariable["ACP_selectedPlayer", player]),[objNull]],
    ["_params", [],[[]]]
];

_params params[["_aceShowHealer", true,[true]], ["_healer",player,[objNull]]];

{
    if (missionNamespace getVariable["ace_medical", false] && missionNamespace getVariable["ace_medical_enabled", true]) then
    {
        [[_x, _healer] select (_aceShowHealer),_x] call ace_medical_fnc_treatmentAdvanced_FullHeal;
    }
    else
    {
        _x setDamage 0;
    };
} foreach allPlayers;
