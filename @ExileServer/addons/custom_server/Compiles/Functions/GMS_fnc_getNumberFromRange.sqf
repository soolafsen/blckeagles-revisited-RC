
// Last modified 8/13/17 by Ghostrider-DBD-
/*
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

params["_data"];
_value = objNull;
if (typeName _data isEqualTo "ARRAY") then
{
	_min = _data select 0;
	_max = _data select 1;
	if (_max > _min) then 
	{
		_value = _min + round(random(_max - _min));
	} else {
		_value = _min;
	};
};
if (typeName _data isEqualTo "SCALAR") then
{
	_value = _data;
};
_value