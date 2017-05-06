mkdir ..\release\
mkdir ..\release\@mirage 
mkdir ..\release\@mirage\addons 
mkdir ..\release\@mirage\keys
mkdir ..\release\userconfig\mrg_acp
copy ..\userconfig\mrg_acp\admin_list.hpp .\release\userconfig\mrg_acp\
DSCreateKey mirage-release
makePbo -A -U -P -N ..\addons\controlpanel_server ..\release\@mirage\addons\mrg_controlpanel_server.pbo
makePbo -A -U -P -N ..\addons\controlpanel ..\release\@mirage\addons\mrg_controlpanel.pbo
DSSignFile.exe mirage-release.biprivatekey ..\release\@mirage\addons\mrg_controlpanel_server.pbo
DSSignFile.exe mirage-release.biprivatekey ..\release\@mirage\addons\mrg_controlpanel.pbo
copy mirage-release.bikey ..\release\@mirage\keys
explorer ..\release\