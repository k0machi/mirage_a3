with missionNamespace do
{
    ACP_requestAccess = [getPlayerUID player, clientOwner];
    publicVariableServer "ACP_requestAccess";

    if (isServer || !isMultiplayer || serverCommandAvailable "#logout") then
    {
        [] spawn Xeno_fnc_adminControlPanel;
    }
    else
    {
        _state = missionNamespace getVariable["ACP_response",2];
        waitUntil { (missionNamespace getVariable["ACP_response",2]) != _state };
        if (missionNamespace getVariable["ACP_response",2] == 0) then
        {
            [] spawn Xeno_fnc_adminControlPanel;
        }
        else
        {
            playSound "addItemFailed";
            missionNamespace setVariable["ACP_response",2];
        };
    };
};