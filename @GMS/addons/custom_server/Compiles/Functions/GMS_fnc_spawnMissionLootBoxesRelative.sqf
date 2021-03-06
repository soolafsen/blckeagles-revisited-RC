
/*
	By Ghostrider [GRG]
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";
    
params["_center","_crates"];
private["_crate","_cratesSpawned"];

_cratesSpawned = [];
{
    _x params["_objClassName","_objRelPos","_crateLoot","_lootCounts","_objDir"];
    _crate = [_objClassName, _objRelPos vectorAdd _center, _objDir] call blck_fnc_spawn_lootCrate;
    //_crate setPosATL _objRelPos vectorAdd _center;
    _cratesSpawned pushBack _crate;
    //_crate setVariable ["LAST_CHECK", 100000];
    _crate allowDamage false;
    _crate enableRopeAttach false;
    _crate 
}forEach _crates;
_cratesSpawned