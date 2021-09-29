Shader "Custom/Screen (Single Image)/Galaxy Shader"{
	Properties{
		_Stars1 ("Stars1", Color) = (1, 1, 1, 1)
		_Stars2 ("Stars2", Color) = (1, 1, 1, 1)
		_Stars3 ("Stars3", Color) = (1, 1, 1, 1)
		_Nebula1 ("Nebula1", Color) = (.1, .1, .1, 1)
		_Nebula2 ("Nebula2", Color) = (.1, .1, .1, 1)
		_Nebula3 ("Nebula3", Color) = (.1, .1, .1, 1)
		_Seed ("RNG Seed", Range(0,3.1416)) = 0
	}

	CGINCLUDE
	float4 _Stars1;
	float4 _Stars2;
	float4 _Stars3;
	float _Seed;
	float3 noise_3d(float4 p) {
		p.w += frac(sin(dot(floor(p).xyz,float3(127.1, 311.7, 413.5)))*(43758.5453 + _Seed));
		float f = frac(p.w);
		float3 u = f*f*(3.0-2.0*f);
		p.w = floor(p.w);
		float3 t1 = frac(sin(float3(dot(p,float4(127.1, 311.7, 413.5, 759.3)), dot(p,float4(269.5, 183.3, 197.7, 571.1)), dot(p,float4(975.1, 343.7, 435.3, 183.5))))*(43758.5453 + _Seed));
		p.w+=1.0;
		float3 t2 = frac(sin(float3(dot(p,float4(127.1, 311.7, 413.5, 759.3)), dot(p,float4(269.5, 183.3, 197.7, 571.1)), dot(p,float4(975.1, 343.7, 435.3, 183.5))))*(43758.5453 + _Seed));
		return t1*(1.0-u) + t2*u;
	}

	float3 voronoi(float3 x){
		float3 n = floor(x);
		float3 f = frac(x);

		//regular voronoi
		float3 col = float3(0,0,0);
		for (int x= -1; x <= 1; x++) {
			for (int y= -1; y <= 1; y++) {
				for (int z= -1; z <= 1; z++) {
					float3 g = float3(float(x),float(y),float(z));
					float3 o = noise_3d(float4(n + g, _Time.x*5.));

					float3 r = g + o - f;
					float v = length(o);
					float3 tint = _Stars2;
					float tintD = (normalize(o).x)*2-1;

					if(tintD < 0){
						tint = _Stars1 * -tintD + tint*(1+tintD);
					}else{
						tint = _Stars3 * tintD + tint*(1-tintD);
					}
					r = 1.0-length(r*5.);
					float d = clamp(((r.x+r.y+r.z))-1./(v*2.), 0., 1.);
					col += float3(d, d, d)*tint;
				}
			}
		}
		return col;
	}

	#define rand4 float4(12.9898,78.233,54.5913, 33.13467)

	float random4dLerp(in float4 st) {
		float4 i = floor(st);
		float4 f = frac(st);
		return lerp(lerp(lerp(lerp(frac(sin(dot(i							,rand4))*(43758.5453 + _Seed)),
			 					   frac(sin(dot(i+float4(1.0, 0.0, 0.0, 0.0),rand4))*(43758.5453 + _Seed)),
							  f.x),
							  lerp(frac(sin(dot(i+float4(0.0, 1.0, 0.0, 0.0),rand4))*(43758.5453 + _Seed)),
							 	   frac(sin(dot(i+float4(1.0, 1.0, 0.0, 0.0),rand4))*(43758.5453 + _Seed)),
							  f.x),
						 f.y),
						 lerp(lerp(frac(sin(dot(i+float4(0.0, 0.0, 1.0, 0.0),rand4))*(43758.5453 + _Seed)),
								   frac(sin(dot(i+float4(1.0, 0.0, 1.0, 0.0),rand4))*(43758.5453 + _Seed)),
							  f.x),
						 	  lerp(frac(sin(dot(i+float4(0.0, 1.0, 1.0, 0.0),rand4))*(43758.5453 + _Seed)),
							 	   frac(sin(dot(i+float4(1.0, 1.0, 1.0, 0.0),rand4))*(43758.5453 + _Seed)),
							  f.x),
						 f.y),
					f.z),
					lerp(lerp(lerp(frac(sin(dot(i+float4(0.0, 0.0, 0.0, 1.0),rand4))*(43758.5453 + _Seed)),
			 					   frac(sin(dot(i+float4(1.0, 0.0, 0.0, 1.0),rand4))*(43758.5453 + _Seed)),
							  f.x),
							  lerp(frac(sin(dot(i+float4(0.0, 1.0, 0.0, 1.0),rand4))*(43758.5453 + _Seed)),
							 	   frac(sin(dot(i+float4(1.0, 1.0, 0.0, 1.0),rand4))*(43758.5453 + _Seed)),
							  f.x),
						 f.y),
						 lerp(lerp(frac(sin(dot(i+float4(0.0, 0.0, 1.0, 1.0),rand4))*(43758.5453 + _Seed)),
								   frac(sin(dot(i+float4(1.0, 0.0, 1.0, 1.0),rand4))*(43758.5453 + _Seed)),
							  f.x),
						 	  lerp(frac(sin(dot(i+float4(0.0, 1.0, 1.0, 1.0),rand4))*(43758.5453 + _Seed)),
							 	   frac(sin(dot(i+float4(1.0, 1.0, 1.0, 1.0),rand4))*(43758.5453 + _Seed)),
							  f.x),
						 f.y),
					f.z),
				f.w);
	}

	#define NUM_OCTAVES 5

	float fbm ( in float4 _st) {
		float v = 0.0;
		float a = 0.5;
		float2 shift = float2(100.0, 100.0);
		// Rotate to reduce axial bias
		float2x2 rot = float2x2(cos(0.5), sin(0.5),
						-sin(0.5), cos(0.5));
		for (int i = 0; i < NUM_OCTAVES; ++i) {
			v += a * random4dLerp(_st);
			_st.xy = mul(rot,_st.xy) * 2.0 + shift;
			_st.yz = mul(rot,_st.yz) * 2.0 + shift;
			a *= 0.5;
		}
		return v;
	}
	ENDCG

	SubShader{
		Pass{
			Cull Off
			CGPROGRAM

			#pragma vertex vertexFunction
			#pragma fragment fragmentFunction

			#include "UnityCG.cginc"


			struct appdata{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f{
				float4 position : SV_POSITION;
				float3 uv : TEXCOORD0;
			};

			float4 _Nebula1;
			float4 _Nebula2;
			float4 _Nebula3;

			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;

			v2f vertexFunction(appdata IN){
				v2f OUT;

				OUT.position = UnityObjectToClipPos(IN.vertex);
				OUT.uv = mul(unity_ObjectToWorld, IN.vertex);

				return OUT;
			}

			float2 MonoPanoProjection( float3 coords ){
				float3 normalizedCoords = normalize(coords);
				float latitude = acos(normalizedCoords.y);
				float longitude = atan2(normalizedCoords.z, normalizedCoords.x);
				float2 sphereCoords = float2(longitude, latitude) * float2(1.0/UNITY_PI, 1.0/UNITY_PI);
				sphereCoords = float2(1.0,1.0) - sphereCoords;
				return (sphereCoords + float4(0, 1-unity_StereoEyeIndex,1,1.0).xy) * float4(0, 1-unity_StereoEyeIndex,1,1.0).zw;
			}

			fixed4 fragmentFunction(v2f IN) : SV_Target{
				float3 viewDirection = normalize(IN.uv.xyz - _WorldSpaceCameraPos.xyz);
				float2 _MainTex_var = MonoPanoProjection(viewDirection);

				float3 col = float3(0,0,0);
				col += fbm(float4(viewDirection.xyz*50.0,_Time.y/5.+3.))*_Nebula3.xyz;
				col += fbm(float4(viewDirection.xyz*20.0,_Time.y/5.+1.))*_Nebula2.xyz;
				col += fbm(float4(viewDirection.xyz*10.0,_Time.y/5.))*_Nebula1.xyz;
				col += voronoi(viewDirection.xyz*50.0);
				col += voronoi(viewDirection.xyz*100.0);
				col += voronoi(viewDirection.xyz*300.0);
				return float4(col,1);
			}
			ENDCG
		}
	}
}
