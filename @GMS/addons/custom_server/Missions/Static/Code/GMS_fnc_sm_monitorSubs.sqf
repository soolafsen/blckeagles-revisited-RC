/*
	by Ghostrider [GRG]

	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/

#include "\q\addons\custom_server\Configs\blck_defines.hpp";
private["_mode","_sm_groups"];
_sm_groups = +blck_sm_submarines;
//diag_log format["_fnc_monitorSubs: time %2 |  blck_sm_submarines %1",blck_sm_submarines,diag_tickTime];
{
	_x params["_groupParameters","_group","_groupSpawned","_timesSpawned","_respawnAt","_maxRespawns"];
	//diag_log format["_fnc_monitorSubs: _x %1",_x];
	//diag_log format["_fnc_monitorSubs: _groupParameters = %1",_groupParameters];
	//diag_log format["_fnc_monitorSubs (9): _group %1 | _groupSpawned %2 | _timesSpawned %3 | _respawnAt %4",_group,_groupSpawned,_timesSpawned,_respawnAt];
	//_groupParameters params["_pos","_difficulty","_units","_patrolRadius","_respawnTime"];
	_groupParameters params["_vehicleType","_pos","_difficulty","_patrolRadius","_respawnTime","_maxRespawns"];	
	//diag_log format["_fnc_monitorVehicles: _vehicleType | %1 | _pos = %2 | _difficulty = %3 | _patrolRadius = %4 | _respawnTime = %5",_vehicleType,_pos,_difficulty,_patrolRadius,_respawnTime];
	private _element = +_x;//
	
	if (!(isNull _group) && {alive _x} count (units _group) == 0) then
	{
		deleteGroup _group;
		_group = grpNull;
	};
	if (isNull _group) then
	{
		_mode = -1;
		if ((_timesSpawned == 0) && (_groupSpawned == 0)) then {_mode = 1};  // spawn-respawn
		if (_timesSpawned > 0) then
		{
			if ((_groupSpawned == 1) && (_respawnTime == 0)) then {_mode = 0}; // remove patrol from further evaluation
			if ((_timesSpawned > _maxRespawns) && (_maxRespawns != -1)) then {_mode = 0}; 			
			if ((_groupSpawned == 1) && (_respawnTime > 0)) then {_mode = 2}; // set up for respawn at a later time 
			if ((_groupSpawned == 0) && (diag_tickTime > _respawnAt)) then {_mode = 1};
		};
		switch (_mode) do
		{
			case 0: {blck_sm_submarines deleteAt (blck_sm_submarines find _x)};
			case 1: {
						
						if ([_pos,staticPatrolTriggerRange] call blck_fnc_playerInRange) then
						{
							_return = [_pos,1,_difficulty,[_groupParameters],false,blck_UMS_uniforms,blck_UMS_headgear,blck_UMS_vests,blck_backpacks,blck_UMS_weapons,blck_Pistols,true] call blck_fnc_spawnMissionVehiclePatrols;
							//diag_log format["_fnc_monitorSubs: _return = %1",_return];
							_group = group ((_return select 1) select 0);							
							_timesSpawned = _timesSpawned + 1;
							_groupSpawned = 1;
							_respawnAt = 0;
							_element set[patrolGroup,_group];
							_element set[groupSpawned,1];
							_element set[timesSpawned,_timesSpawned];
							_element set[respawnAt,_respawnAt];	
							blck_sm_submarines set[blck_sm_submarines find _x,_element];
						};
					};
			case 2: {
						_groupSpawned = 0;
						_respawnAt = diag_tickTime + _respawnTime;
						_element set[respawnAt,_respawnAt];	
						_element set[groupSpawned,_groupSpawned];
						blck_sm_submarines set[blck_sm_submarines find _x,_element];
						//diag_log format["_fnc_monitorSubs: update respawn time to %1",_respawnAt];						
					};
			default {};
		};
		//diag_log format["_fnc_monitorSubs(56) respawn conditions evaluated : _group = %1 | _groupSpawned = %2 | _timesSpawned = %3",_group,_groupSpawned,_timesSpawned];
	} else {
		//diag_log format["_fnc_monitorSubs: diag_tickTime = %1 | playerNearAt = %2",diag_tickTime,_group getVariable["playerNearAt",-1]];
		if ([_pos,staticPatrolTriggerRange] call blck_fnc_playerInRange) then
		{
			_group setVariable["playerNearAt",diag_tickTime];
			//diag_log format["_fnc_monitorSubs: playerNearAt updated to %1",_group getVariable["playerNearAt",-1]];
		} else {
			if (diag_tickTime > (_group getVariable["playerNearAt",diag_tickTime]) + blck_sm_groupDespawnTime) then
			{
				//diag_log format["_fnc_monitorSubs: despanwing patrol for _element %1",_element];
				_groupParameters set [2, {alive _x} count (units _group)];
				private _veh = vehicle (leader _group);
				[_veh] call blck_fnc_destroyVehicleAndCrew;
				_element set[groupParameters,_groupParameters];
				_element set[patrolGroup ,grpNull];
				_element set[timesSpawned,(_timesSpawned - 1)];
				_element set[groupSpawned,0];
				blck_sm_submarines set[(blck_sm_submarines find _x), _element];
			};
		};
	};
}forEach _sm_groups;