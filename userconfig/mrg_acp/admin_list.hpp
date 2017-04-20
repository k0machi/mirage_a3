/*

    Here you can define users who can access mirage coordinator and specify their permissions
    ids: List of SteamID64s of people you want to have access
    masks: Their respective masks, has to be an array with 8 elements of either 0 or 1, granting or revoking specific permissions
    maskMission: Single mask for any user that has been added through missionConfigFile
    serverCommandPassword: should match same property in your server.cfg to allow kick, ban and restart actions.

*/


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
#define FULL_ACCESS {CAN_KICK,CAN_BAN,CAN_MISSIONCONTROL,CAN_DOACTIONS,CAN_LOCALEXEC,CAN_REMOTEEXEC,CAN_SERVEREXEC,CAN_USEDEBUGCONSOLE}
#define LIMITED_ACCESS {CAN_KICK,CANNOT_BAN,CANNOT_MISSIONCONTROL,CAN_DOACTIONS,CAN_LOCALEXEC,CAN_REMOTEEXEC,CAN_SERVEREXEC,CANNOT_USEDEBUGCONSOLE}


ids[] = {"760000000000000000"};
masks[] = {FULL_ACCESS};
maskMission[] = {CANNOT_KICK,CANNOT_BAN,CANNOT_MISSIONCONTROL,CAN_DOACTIONS,CAN_LOCALEXEC,CAN_REMOTEEXEC,CAN_SERVEREXEC,CANNOT_USEDEBUGCONSOLE};
serverCommandPassword = "examplePassword";