/*================================================================MCC_fnc_supressionEffects================================================================================
  Effects of being supressed
  IN <>
    hit
*/
private ["_blurEffects","_radar","_colorCorrectionEffect"];
params ["_ratio","_dir"];

_ratio = _ratio * (missionNamespace getVariable ["MCC_supressionEffectsForce",1]);
_radar = missionNamespace getVariable ["MCC_hitRadar",0];


_colorCorrectionEffect = ppEffectCreate ["ColorCorrections", 1500];
_colorCorrectionEffect ppEffectForceInNVG true;
_colorCorrectionEffect ppEffectEnable true;


//Hit direction
switch (_radar) do
{
	//Realistic
	case 0:
	{
		_radarIntensity = _ratio min 0.2;
		switch (true) do
		{
			case (_dir > 315 || _dir <= 45):
			{
				_colorCorrectionEffect ppEffectAdjust [0.1,1,0, [0,0,.50,0],[0,0,0,1],[0,0,0,1],[0.9,0.9,0,0,_radarIntensity,0.6,0.95]];
			};

			case (_dir > 45 && _dir <= 135):
			{
				_colorCorrectionEffect ppEffectAdjust [0.1,1,0, [0,0,.50,0],[0,0,0,1],[0,0,0,1],[0.9,0.9,0,-_radarIntensity,0,0.6,0.95]];
			};

			case (_dir > 135 && _dir <= 225):
			{
				_colorCorrectionEffect ppEffectAdjust [0.1,1,0, [0,0,.50,0],[0,0,0,1],[0,0,0,1],[0.9,0.9,0,0,-_radarIntensity,0.6,0.95]];
			};

			default
			{
				_colorCorrectionEffect ppEffectAdjust [0.1,1,0, [0,0,.50,0],[0,0,0,1],[0,0,0,1],[0.9,0.9,0,_radarIntensity,0,0.6,0.95]];
			};
		};
	};

	//Arcade
	case 1:
	{
		switch (true) do
		{
			case (_dir > 315 || _dir <= 45):
			{
				(["MCC_rssHitUp"] call BIS_fnc_rscLayer) cutRsc ["MCC_rssHitUp", "PLAIN"];
			};

			case (_dir > 45 && _dir <= 135):
			{
				(["MCC_rssHitRight"] call BIS_fnc_rscLayer) cutRsc ["MCC_rssHitRight", "PLAIN"];
			};

			case (_dir > 135 && _dir <= 225):
			{
				(["MCC_rssHitDown"] call BIS_fnc_rscLayer) cutRsc ["MCC_rssHitDown", "PLAIN"];
			};

			default
			{
				(["MCC_rssHitLeft"] call BIS_fnc_rscLayer) cutRsc ["MCC_rssHitLeft", "PLAIN"];
			};
		};
	};
};


_colorCorrectionEffect ppEffectCommit 0;

// RBlur
_blurEffects = ppEffectCreate ["DynamicBlur", 440];
_blurEffects ppEffectForceInNVG true;
_blurEffects ppEffectAdjust [_ratio];
_blurEffects ppEffectEnable true;

_blurEffects ppEffectCommit 0;

enableCamShake true;
resetCamShake;
addCamShake [(_ratio * 5),_ratio, _ratio*80];

sleep 0.5;
ppEffectDestroy [_blurEffects];
ppEffectDestroy [_colorCorrectionEffect];

/*
0 = ["ColorCorrections", 1500,  [0.1,1,0, [0,0,.50,0],[0,0,0,1],[0,0,0,1],[0.9,0.9,0,0.2,-0.1,0.6,0.95]]] spawn
{
 params ["_name", "_priority", "_effect", "_handle"];
_handle = ppEffectCreate [_name, _priority];
 _handle ppEffectEnable true;
 _handle ppEffectAdjust _effect;
 _handle ppEffectCommit 0;
 waitUntil {ppEffectCommitted _handle};
 uiSleep 0.3;
 comment "admire effect for a sec";
 _handle ppEffectEnable false;
 ppEffectDestroy _handle;
};*/