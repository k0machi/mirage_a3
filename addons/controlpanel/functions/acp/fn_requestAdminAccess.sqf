#define FULL_ACCESS "99:abcdefgh"
#define MISSION_ADMIN_FLAGS (getText(configFile >> "CfgAdmins" >> "flagsMission"))
#define CONFIG_ADMIN_FLAGS (getArray(configFile >> "CfgAdmins" >> "flags") select (_configAdmins find _uid))

params ["_mode", "_params"];

with missionNamespace do
{
    switch (_mode) do
    {
        case "Client":
        {
            missionNamespace setVariable["ACP_response",[2,"0:"]];
            if (isServer || !isMultiplayer || serverCommandAvailable "#logout") then
            {
                missionNamespace setVariable["ACP_response",[0,FULL_ACCESS]];
                if (isNil "mrg_checkflags") then { mrg_checkflags = compile str ((((ACP_response select 1) splitString ":") select 1) splitString ""); };
                [] spawn MRG_fnc_adminControlPanel;
            }
            else
            {
                ["Server", [getPlayerUID player, clientOwner]] remoteExec ["MRG_fnc_requestAdminAccess", 2];
                _state = 2;
                _timeout = (time + 5);
                waitUntil { (((missionNamespace getVariable["ACP_response",[2,"0:"]]) select 0) != _state) || time > _timeout };
                if ((missionNamespace getVariable["ACP_response",[2,"0:"]]) select 0 == 0) then
                {
                    if (isNil "mrg_checkflags") then { mrg_checkflags = compileFinal str ((((ACP_response select 1) splitString ":") select 1) splitString ""); };
                    [] spawn MRG_fnc_adminControlPanel;
                }
                else
                {
                    playSound "addItemFailed";
                    missionNamespace setVariable["ACP_response",[2,"0:"]];
                };
            };
        };
        case "Server":
        {
            _params params ["_uid", "_netId"];
            if (clientOwner == _netId) exitWith {};
            _configAdmins = getArray(configFile >> "CfgAdmins" >> "ids");
            _missionAdmins = getArray(missionConfigFile >> "CfgAdmins" >> "ids");
            if (_uid in (_configAdmins + _missionAdmins)) then
            {
                ACP_response = [0, ([MISSION_ADMIN_FLAGS, CONFIG_ADMIN_FLAGS] select (_uid in _configAdmins))];
            }
            else
            {
                ACP_response = [1,"0:"];
            };
            _netId publicVariableClient "ACP_response";
        };
    };
};
