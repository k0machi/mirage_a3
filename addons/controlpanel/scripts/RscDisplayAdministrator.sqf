_mode = _this select 0;
_params = _this select 1;
_class = _this select 2;


switch _mode do {
	case "onLoad": {
		["Init",_params, _class] spawn (uiNamespace getvariable "Xeno_fnc_adminControlPanel");
	};
	case "onUnload": {
		["Exit",_params, _class] spawn (uiNamespace getvariable "Xeno_fnc_adminControlPanel");
	};
};