//Star Nest algorithm by Pablo Román Andrioli
//Unity 5.x shader by Jonathan Cohen
//This content is under the MIT License.
//
//Original Shader:
//https://www.shadertoy.com/view/XlfGRj
//
//This shader uses the same algorithm in 3d space to render a skybox.

//Edited by All4thlulz

Shader "Custom/Multi-Shader/StarNest" {
	Properties
	{
		//Iterations of inner loop.
		//The higher this is, the more distant objects get rendered.
		_Iterations ("Iterations", Range(1, 20)) = 15

		//Volumetric rendering steps. Each 'step' renders more objects at all distances.
		//This has a higher performance hit than iterations.
		_Volsteps ("Volumetric Steps", Range(1,20)) = 17

		//Exposing the uv offset variable for some added customisation
		[HideInInspector]_UVOffset ("UV Offset",  Range(0,1)) = 0.5

		//2D: Zoom level
		_Zoom ("Zoom", Float) = 800

		//Tint the color of the result with this
		_StarNestMainColor ("Main StarNest Color", Color) = (1,1,1,1)

		[Toggle(CLAMPOUT)] _CLAMPOUT("Clamp Output with Main Color ----->", Float) = 0

		//Scrolls in this direction over time. Set 'w' to zero to stop scrolling.
		_Scroll ("Scrolling direction (x,y,z) * w * time", Vector) = (3, 1, 0.6, .1)

		//Center position in space and time.
		//NOTE: This is now being used to correct the Z axis UV stretching that occurs
		[HideInInspector]_Center ("Center Position (x, y, z, time)", Vector) = (0, 0, 0.5, 0)

		[Toggle(Enable3DRotation)] _3DRotation("Enable 3D Rotation ----->", Float) = 0

		//Rotation angles
		_Rotation ("Rotation (x,y,z)*w angles", Vector) = (0, 0, 0, 0.1)

		//Magic number. Best values are around 400-600.
		_Formuparam ("Formuparam", Range(0,800)) = 575

		//How much farther each volumestep goes
		_StepSize ("Step Size", Range(0,1000)) = 228

		//Fractal repeating rate
		//Low numbers are busy and give lots of repitition
		//High numbers are very sparce
		_Tile ("Tile", Range(0,1000)) = 500

		//Brightness scale.
		_Brightness ("Brightness", Range(-50,50)) = 2
		//Abundance of Dark matter (in the distance).
		//Visible with Volsteps >= 8 (at 7 its really, really hard to see)
		_Darkmatter ("Dark Matter", Range(0,500)) = 25
		//Multiplies the brightness of darkmatter
		_DarkmatterContrastMultiplier("Dark Matter Contrast Multiplier", Range(1,20)) = 1
		//Brightness of distant objects (or dim) are distant objects
		//Ironically, Also affets brightness of 'darkmatter'
		_Distfading ("Distance Fading", Range(-100,100)) = 68
		//How much color is present?
		_Saturation ("Saturation", Range(-300,300)) = 85

	}

	SubShader
	{
		Tags { "Queue"="Geometry" "RenderType"="Opaque" }
		Cull Off


		CGPROGRAM


		#pragma surface surf Lambert
		#pragma multi_compile __ CLAMPOUT
		#pragma multi_compile __ Enable3DRotation
		#include "UnityCG.cginc"

		float _UVOffset;

		fixed4 _StarNestMainColor;

		int _Volsteps;
		int _Iterations;
		sampler2D _MainTex;

		float4 _Scroll;
		float4 _Center;
		float _CamScroll;
		float4 _Rotation;

		float _Formuparam;
		float _StepSize;

		float _Zoom;

		float _Tile;

		float _Brightness;
		float _Darkmatter;
		float _DarkmatterContrastMultiplier;
		float _Distfading;
		float _Saturation;

		struct Input
		{
			float4 screenPos;
			float3 viewDir; //used to create a flat texture that ignores mesh/texture uvs and follows camera view direction
		};



		void surf (Input IN, inout SurfaceOutput o)
		{
			half3 col = half3(0, 0, 0);
			float zoom = _Zoom / 1000;
			float2 uv = IN.viewDir;
			uv -= _UVOffset;

			half3 dir = float3(uv * zoom, 1);

			float time = _Center.w + _Time.x;

			//Un-scale parameters (source parameters for these are mostly in 0...1 range)
			//Scaling them up makes it much easier to fine-tune shader in the inspector.
			float brightness = _Brightness / 1000;
			float stepSize = _StepSize / 1000;
			float3 tile = abs(float3(_Tile, _Tile, _Tile)) / 1000;
			float formparam = _Formuparam / 1000;

			float darkmatter = _Darkmatter / 100;
			float distFade = _Distfading / 100;

			float3 from = float3(_Center.x, _Center.y,_Center.z * IN.viewDir.z);

			//scroll over time
			//float3 correctedScroll = float3(_Scroll.x , _Scroll.y , _Scroll.z * (-from.z / 2) ); //This causes pinching at the arms
			from +=  _Scroll.xyz * _Scroll.w * time;
			//scroll from camera position
			//from += _WorldSpaceCameraPos * _CamScroll * .00001;


			//Apply rotation if enabled
			//Use view dir for some intresting results if enabled
			#ifdef Enable3DRotation
				float3 rot = _Rotation.xyz * _Rotation.w * IN.viewDir;
			#else
				float3 rot = _Rotation.xyz * _Rotation.w;
			#endif
			if (length(rot) > 0)
			{
				float2x2 rx = float2x2(cos(rot.x), sin(rot.x), -sin(rot.x), cos(rot.x));
				float2x2 ry = float2x2(cos(rot.y), sin(rot.y), -sin(rot.y), cos(rot.y));
				float2x2 rz = float2x2(cos(rot.z), sin(rot.z), -sin(rot.z), cos(rot.z));

				dir.xy = mul(rz, dir.xy);
				dir.xz = mul(ry, dir.xz);
				dir.yz = mul(rx, dir.yz);
				from.xy = mul(rz, from.xy);
				from.xz = mul(ry, from.xz);
				from.yz = mul(rx, from.yz);
			}


			//volumetric rendering
			float s = 0.1, fade = 1.0;
			float3 v = float3(0, 0, 0);
			for (int r = 0; r < _Volsteps; r++)
			{
				float3 p = abs(from + s * dir * .5);

				p = abs(float3(tile - fmod(p, tile*2)));
				float pa,a = pa = 0.;
				for (int i = 0; i < _Iterations; i++) {
					p = abs(p) / dot(p, p) - formparam;
					a += abs(length(p) - pa);
					pa = length(p);
				}
				//Dark matter
				float dm = max(0., darkmatter - a * a * .001);
				if (r > 6) { fade *= 1. - dm; } // Render distant darkmatter
				a *= (a * a) * _DarkmatterContrastMultiplier; //add contrast

				v += fade;

				// coloring based on distance
				v += float3(s, s*s, s*s*s*s) * a * brightness * fade;

				// distance fading
				fade *= distFade;
				s += stepSize;
			}

			float len = length(v);
			//Quick color saturate
			v = lerp(float3(len, len, len), v, _Saturation / 100);
			v.xyz *= _StarNestMainColor.xyz * .01;

			#ifdef CLAMPOUT
				v = clamp(v, float3(0,0,0), _StarNestMainColor.xyz);
			#endif
			o.Emission = float3(v * .01);
		}



		ENDCG

	}

	Fallback Off
}
