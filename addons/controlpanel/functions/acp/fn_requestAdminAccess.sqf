#define CAN_KICK 1
#define CAN_BAN 1
#define CAN_MISSIONCONTROL 1
#define CAN_USEDEBUGCONSOLE 1
#define CAN_DOACTIONS 1
#define CAN_SERVEREXEC 1
#define CAN_REMOTEEXEC 1
#define CAN_LOCALEXEC 1
#define CANNOT_KICK 0
#define CANNOT_BAN 0
#define CANNOT_MISSIONCONTROL 0
#define CANNOT_USEDEBUGCONSOLE 0
#define CANNOT_DOACTIONS 0
#define CANNOT_SERVEREXEC 0
#define CANNOT_REMOTEEXEC 0
#define CANNOT_LOCALEXEC 0
#define DEFAULT_MASK [CANNOT_KICK,CANNOT_BAN,CANNOT_MISSIONCONTROL,CANNOT_DOACTIONS,CANNOT_LOCALEXEC,CANNOT_REMOTEEXEC,CANNOT_SERVEREXEC,CANNOT_USEDEBUGCONSOLE]
#define MISSION_ADMIN_MASK (getArray(configFile >> "CfgAdmins" >> "maskMission"))
#define CONFIG_ADMIN_MASK (getArray(configFile >> "CfgAdmins" >> "masks") select (_configAdmins find _uid))
#define FULL_ACCESS [CAN_KICK,CAN_BAN,CAN_MISSIONCONTROL,CAN_DOACTIONS,CAN_LOCALEXEC,CAN_REMOTEEXEC,CAN_SERVEREXEC,CAN_USEDEBUGCONSOLE]

params ["_mode", "_params"];

with missionNamespace do
{
    switch (_mode) do
    {
        case "Client":
        {
            missionNamespace setVariable["ACP_response",[2,DEFAULT_MASK]];
            if (isServer || !isMultiplayer || serverCommandAvailable "#logout") then
            {
                missionNamespace setVariable["ACP_response",[0,FULL_ACCESS]];
                [] spawn MRG_fnc_adminControlPanel;
            }
            else
            {
                ["Server", [getPlayerUID player, clientOwner]] remoteExec ["MRG_fnc_requestAdminAccess", 2];
                _state = 2;
                _timeout = (time + 5);
                waitUntil { (((missionNamespace getVariable["ACP_response",[2,DEFAULT_MASK]]) select 0) != _state) || time > _timeout };
                if ((missionNamespace getVariable["ACP_response",[2,DEFAULT_MASK]]) select 0 == 0) then
                {
                    [] spawn MRG_fnc_adminControlPanel;
                }
                else
                {
                    playSound "addItemFailed";
                    missionNamespace setVariable["ACP_response",[2,DEFAULT_MASK]];
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
                ACP_response = [0, ([MISSION_ADMIN_MASK, CONFIG_ADMIN_MASK] select (_uid in _configAdmins))]; 
            }
            else 
            { 
                ACP_response = [1,DEFAULT_MASK];
            };
            _netId publicVariableClient "ACP_response";
        };
    };
};