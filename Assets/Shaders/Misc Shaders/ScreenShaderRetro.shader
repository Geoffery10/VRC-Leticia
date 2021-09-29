Shader "Custom/Screen/Retro Shader"
{
	Properties
	{
		_DistanceMain("Main Distance", Range( 0 , 100)) = 1
		_DistanceStart("Fade Distance", Range( 0 , 100)) = 1
		_Size("Pixel Size", Range( 1 , 50)) = 8
		_ColDepth("Color Depth", Range( 1 , 50)) = 7
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+1000" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  }
		ZWrite Off
		Cull Off
		GrabPass{ }
		ZTest Always

		Pass {
			Stencil {
	         Ref 1
	         Comp always
	         Pass replace
			 }
		}

		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow
		struct Input
		{
			float4 screenPos;
		};

		uniform float _DistanceMain;
		uniform float _DistanceStart;
		uniform sampler2D _GrabTexture;
		float _Size;
		float _ColDepth;

		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 transform20 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor1 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float3 color = 0.0;
			float dist = distance( _WorldSpaceCameraPos, transform20.xyz );
			if(dist >= _DistanceStart){
				color = screenColor1.rgb;
			}else{
				float4 screenColor2 = tex2D(_GrabTexture, round(ase_grabScreenPosNorm.xy*(_ScreenParams.xy/_Size))/(_ScreenParams.xy/_Size));
				color = round(screenColor2*_ColDepth)/_ColDepth;
				dist = (dist - _DistanceMain) / (_DistanceStart-_DistanceMain);
				if(dist > 0){
					color = color * (1.0-dist) + screenColor1 * dist;
				}
			}
			o.Emission = color;
			o.Alpha = 1;
		}

		ENDCG
	}
}
