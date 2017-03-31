with missionNamespace do
{
    missionNamespace setVariable["ACP_response",2];
    ACP_requestAccess = [getPlayerUID player, clientOwner];
    publicVariableServer "ACP_requestAccess";

    if (isServer || !isMultiplayer || serverCommandAvailable "#logout") then
    {
        [] spawn MRG_fnc_adminControlPanel;
    }
    else
    {
        _state = missionNamespace getVariable["ACP_response",2];
        _timeout = (time + 5);
        waitUntil { ((missionNamespace getVariable["ACP_response",2]) != _state) || time > _timeout };
        if (missionNamespace getVariable["ACP_response",2] == 0) then
        {
            [] spawn MRG_fnc_adminControlPanel;
        }
        else
        {
            playSound "addItemFailed";
            missionNamespace setVariable["ACP_response",2];
        };
    };
};