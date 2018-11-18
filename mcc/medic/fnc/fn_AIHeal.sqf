/*=====================================================================  MCC_fnc_AIHeal ===========================================================================================
Handles AI heal - for internal use, move AI to another unit and heal it

<IN>
	0:	OBJECT - the unit that is healing
	1:	OBJECT - the unit that need to be heales


*/

params ["_savior","_unit"];

_savior doMove getpos _unit;
_t = time + 15;

waituntil { sleep .5; (_savior distance _unit < 3) or !(alive _unit) or !(alive _savior) or (_savior getVariable ["MCC_medicUnconscious",false]) or !(canMove _savior) or (lifeState _savior == "INCAPACITATED")  or (vehicle _savior != _savior) or time > _t};

if (_savior distance _unit < 3) then {
	_savior action ["heal", _unit];

	[_unit] remoteExec ["MCC_fnc_wakeUp",_unit];
};

_unit setVariable ["MCC_medicSavior",objNull,true];
_savior setVariable ["MCC_medicSavingUnit",objNull,true];