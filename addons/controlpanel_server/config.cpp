class CfgPatches
{
    class MRG_ACP_SERVER_F
    {
		author = "Xeno";
		authorUrl = "http://komachi.co.uk/";
		requiredAddons[] = { "A3_Functions_F", "MRG_ACP_F" };
		units[] = {};
		vehicles[] = {};		
		version = "1.0";
		requiredVersion = 1.66;
    };
};

class CfgAdmins
{
    #include <\userconfig\mrg_acp\admin_list.hpp> 
};
