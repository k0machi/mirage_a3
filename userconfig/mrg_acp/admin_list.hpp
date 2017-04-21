/*

    Here you can define users who can access mirage coordinator and specify their permissions
    ids: List of SteamID64s of people you want to have access
    flags: Their respective flags, an array of strings in the format of power:flags, where power corresponds to kick\ban power of the user and flags granting or revoking specific permissions
    flagsMission: Single string in the same format
    serverCommandPassword: should match same property in your server.cfg to allow kick, ban and restart actions.
    
    Flags:
    a - can kick
    b - can ban
    c - can restart mission
    d - can perform administrative actions
    e - can locally execute code
    f - can remotely execute code
    g - can server execute code
    h - can use debug console shortcut

*/


#define FULL_ACCESS "99:abcdefgh"
#define LIMITED_ACCESS "33:acdefg"


ids[] = {"760000000000000000", "760000000000000001"};
flags[] = {FULL_ACCESS, LIMITED_ACCESS}; //flags order match steamid order
flagsMission = "1:d"; //actions only
serverCommandPassword = "example";