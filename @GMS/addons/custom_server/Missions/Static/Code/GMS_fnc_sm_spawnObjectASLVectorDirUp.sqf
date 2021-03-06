
/*
	by Ghostrider [GRG]
	for ghostridergaming
	12/5/17
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";
diag_log format["_fnc_sm_spawnObjectASLVectorDirUp:  _this = %1",_this];
params["_buildingClassName","_posASL","_vectorDirUp","_enableDamSim"];
{
	diag_log format["_fnc_sm_spawnObjectASLVectorDirUp: %1 = %2",_x select 0, _x select 1];
}forEach [["_buildingClassName",_buildingClassName],["_posASL",_posASL],["_vectorDirUp",_vectorDirUp],["_enableDamSim",_enableDamSim]];
_object = createVehicle [_buildingClassName, [0,0,0], [], 0, "CAN_COLLIDE"];
_object setPosASL _posASL;
_object setVectorDirAndUp _vectorDirUp;
_object enableSimulationGlobal (_enableDamSim select 0);
_object allowDamage (_enableDamSim select 1);

_object