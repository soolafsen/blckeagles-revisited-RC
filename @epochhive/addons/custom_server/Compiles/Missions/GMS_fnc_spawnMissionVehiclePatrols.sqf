/*
	[_coords,_noVehiclePatrols,_aiDifficultyLevel,_uniforms,_headGear] call blck_fnc_spawnMissionVehiclePatrols
	by Ghostrider-DbD-
	3/17/17
	returns [] if no groups could be created
	returns [_AI_Vehicles,_missionAI] otherwise;
	
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";
params["_coords","_noVehiclePatrols","_aiDifficultyLevel","_uniforms","_headGear",["_missionType","unspecified"]];

if (blck_debugLevel > 1) then 
{
	diag_log format["_fnc_spawnMissionVehiclePatrols:: _coords = %1 | _noVehiclePatrols = %2 | _aiDifficultyLevel = %3 | _missionType = %4",_coords,_noVehiclePatrols,_aiDifficultyLevel,_missionType];
};

private["_vehGroup","_patrolVehicle","_vehiclePatrolSpawns","_missionAI","_missiongroups","_vehicles","_return","_vehiclePatrolSpawns","_randomVehicle","_return","_abort"];
_vehicles = [];
_missionAI = [];
_abort = false;

_vehiclePatrolSpawns = [_coords,_noVehiclePatrols,45,60] call blck_fnc_findPositionsAlongARadius;

{
	private ["_spawnPos"];
	_spawnPos = _x;
	_vehGroup = [_spawnPos,3,3,_aiDifficultyLevel,_coords,1,2,_uniforms,_headGear] call blck_fnc_spawnGroup;
	if (isNull _vehGroup) exitWith 
	{
		_abort = true;
	};
	if (blck_debugLevel > 2) then 
	{
		diag_log format["_fnc_spawnMissionVehiclePatrols (40):: -> _missionType = %3 _vehGroup = %1 and units _vehGroup = %2",_vehGroup, units _vehGroup,_missionType];
	};
	_randomVehicle = selectRandom blck_AIPatrolVehicles;
	if (blck_debugLevel > 2) then 
	{
		diag_log format["_fnc_spawnMissionVehiclePatrols:: -> randomly selected vehicle = %1",_randomVehicle];
	};	

	//params["_center","_pos",["_vehType","I_G_Offroad_01_armed_F"],["_minDis",30],["_maxDis",45],["_group",grpNull]];
	_patrolVehicle = [_coords,_spawnPos,_randomVehicle,30,45,_vehGroup] call blck_fnc_spawnVehiclePatrol;
	if (blck_debugLevel > 2) then
	{
		diag_log format["_fnc_spawnMissionVehiclePatrols:: - > patrol vehicle spawned was %1",_patrolVehicle];
	};
	if !(isNull _patrolVehicle) then
	{
		_vehicles pushback _patrolVehicle;
		_missionAI append (units _vehGroup);
	};
	if (blck_debugLevel > 2) then
	{
		diag_log format["_fnc_spawnMissionVehiclePatrols:: -- > _vehicles updated to %1",_vehicles];
	};
} forEach _vehiclePatrolSpawns;

blck_missionVehicles append _vehicles; 
_return = [_vehicles, _missionAI, _abort];

_return
