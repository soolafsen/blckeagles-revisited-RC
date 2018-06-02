/*
	By Ghostrider [GRG]
	Copyright 2016

	
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

private["_groupSpawned"];

_groupSpawned = createGroup [blck_AI_Side, true]; 
_groupSpawned setVariable["groupVehicle",objNull];
#ifdef useDynamicSimulation
_groupSpawned enableDynamicSimulation true;
#endif
_groupSpawned setcombatmode "RED";
_groupSpawned setBehaviour "COMBAT";
_groupSpawned allowfleeing 0;
_groupSpawned setspeedmode "FULL";
_groupSpawned setFormation blck_groupFormation; 
_groupSpawned setVariable ["blck_group",true,true];

#ifdef blck_debugMode
diag_log format["_fnc_create_AI_Group: _groupSpawned = %1",_groupSpawned];
#endif

_groupSpawned