

Shader "Custom/Screen/Color Distend"
{
	Properties
	{

		_FalloffStart("Falloff Start", Float) = 5
		_FalloffEnd("Falloff End", Float) = 6
		[HDR]_Colorize("Colorize", Color) = (1,1,1,0)
	}
	
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Overlay" }
		LOD 100
		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		BlendOp Add , Add
		Cull Front
		ColorMask RGBA
		ZWrite Off
		ZTest Always
		Offset 0 , 0
		
		GrabPass{ "Unknown" }


		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
			};

			uniform sampler2D _NEKo;
			uniform float4 _Colorize;
			uniform float _FalloffStart;
			uniform float _FalloffEnd;
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
			
			float3 Float105( float3 In0 )
			{
				#if UNITY_SINGLE_PASS_STEREO
				float3 cPos = (unity_StereoWorldSpaceCameraPos[0] + unity_StereoWorldSpaceCameraPos[1])*0.5;
				#else
				float3 cPos = _WorldSpaceCameraPos;
				#endif
				return cPos;
			}
			
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord = screenPos;
				
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				fixed4 finalColor;
				float4 screenPos = i.ase_texcoord;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float4 screenColor3 = tex2D( _NEKo, ase_grabScreenPosNorm.xy );
				float3 In0105 = float3( 0,0,0 );
				float3 localFloat105 = Float105( In0105 );
				float4 transform27 = mul(unity_ObjectToWorld,float4(0,0,0,1));
				float clampResult20 = clamp( distance( float4( localFloat105 , 0.0 ) , transform27 ) , _FalloffStart , _FalloffEnd );
				float Dist124 = ( 1.0 - ( ( clampResult20 - _FalloffStart ) / ( _FalloffEnd - _FalloffStart ) ) );
				float4 lerpResult57 = lerp( screenColor3 , ( screenColor3 * _Colorize ) , ( Dist124 * 1.0 ));
				
				
				finalColor = lerpResult57;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
