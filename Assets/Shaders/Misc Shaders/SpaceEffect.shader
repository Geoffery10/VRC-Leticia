// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Misc/Space Effect"
{
	Properties
	{
		_TilingX ("Tiling X", Range(0,120)) = 14
		_TilingY ("Tiling Y", Range(120,170)) = 158
		_Brightness ("Space Brightness", Range(0.00,0.06)) = 0.12
		_Contrast ("Contrast", Range(-1,1)) = 0
		_Saturation ("Saturation", Range(0.00,2.00)) = 0.75
		_MovementXDirection ("Movement X Direction", Range(-3,3)) = 1
		_MovementYDirection ("Movement Y Direction", Range(-3,3)) = 1
		_Nebula ("Blue Nebula", Range(0.138,0.175)) = 0.157
		_SpaceType ("Space Distortion", Range(0.25,0.69)) = 0.53
		_Zoom ("Zoom", Range(-2,2)) = 0.53
		_Speed ("Speed", Range(0,0.06)) = 0.001
		_Iterations ("Layers", Range(12,20)) = 17

	}
	SubShader
	{
		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			
			#define stepsize 0.3

			#define tile   0.850
		
			#define brightness 0.0015
			#define darkmatter 0.80
			#define distfading 0.730

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			float _TilingX;
			float _TilingY;
			float _MovementXDirection;
			float _MovementYDirection;
			float _Brightness;
			float _Contrast;
			float _Saturation;
			float _Nebula;
			float _SpaceType;
			float _OverlayColor;
			float _Zoom;
			float _Speed;
			const int _Iterations;

			half4 frag (v2f i) : SV_Target
			{
				float screenParams = _ScreenParams.y/_ScreenParams.x;
				i.vertex.xy =mul(i.vertex.xy,screenParams);
				float uvZoom = i.uv*_Zoom;
				fixed4 dir=fixed4(uvZoom,uvZoom,1,1);
				float time=_Time.y*_Speed;

	
				float a1=(.5+i.uv.x/_ScreenParams.x*_TilingX);
				float a2=(.8+i.uv.y/_ScreenParams.y*_TilingY);
				float2x2 rot1=float2x2(cos(a1),sin(a1),-sin(a1),cos(a1));
				float2x2 rot2=float2x2(cos(a2),sin(a2),-sin(a2),cos(a2));
				dir.xz = mul(dir.xz,rot1);
				dir.xy = mul(dir.xy,rot2);
				float3 from=float3(1.,.5,0.5);
				from+=float3(time*_MovementXDirection,time*_MovementYDirection,-2);
	
				from.xz = mul(from.xz, rot1);
				from.xy = mul(from.xy, rot2);

				//volumetric rendering
				float s=0.1;
				float fade=1;
				float3 v=float3(0,0,0);

				for (int r=0; r<15; r++) {
					float3 p=from+(s*dir*.5);
					p = abs(float3(tile,tile,tile)-fmod(p,float3(tile*2,tile*2,tile*2))); // tiling fold
					float pa = 0;
					float a = 1;
					for (int i=0; i<_Iterations; i++) { 
						p=abs(p)/dot(p,p)-_SpaceType; // the magic formula
						a+=abs(length(p)-pa); // absolute sum of average change
						pa=length(p);
					}
					float dm=max(0.2,darkmatter-a*a*.001); //dark matter
					a = mul(a,a*a); // add contrast
					if (r>6) 
					{
						fade=mul(fade,1.-dm); // dark matter, don't render near
					}
		
					//v+=float3(dm,dm*.5,0.);
					v+=fade;
					v+=fixed4(s,s*s,s*s*s*s,1)*a*brightness*fade; // coloring based on distance
					fade = mul(fade, distfading); // distance fading
					s+=_Nebula;
				}
				v=lerp(fixed3(length(v),length(v),length(v)),v,_Saturation); //color adjust

							half4 col = fixed4(v*_Brightness, 1);
							return  col + _Contrast;
			}

						ENDCG
		}
	}
}
