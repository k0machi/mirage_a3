params
[
    ["_target", (uiNamespace getVariable["ACP_selectedPlayer", player]),[objNull]],
    ["_params", [],[[]]]
];

_params params[["_aceShowHealer", true,[true]], ["_healer",player,[objNull]]];

if (missionNamespace getVariable["ace_medical", false] && missionNamespace getVariable["ace_medical_enabled", true]) then
{
    [[_target, _healer] select (_aceShowHealer),_target] call ace_medical_fnc_treatmentAdvanced_FullHeal;
}
else
{
    _target setDamage 0;
};