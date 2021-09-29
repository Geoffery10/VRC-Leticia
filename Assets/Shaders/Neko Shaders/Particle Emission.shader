Shader "Custom/Particle/Particle Emission"
{
	Properties
	{

	

		[HDR]_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HDR]_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Float0("Emission", Range( -1.5 , 1.5)) = 0
		[Toggle]_EmissionAutoSwitch("Emission Auto Switch", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	Category 
	{
		SubShader
		{
			Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			Cull Off
			Lighting Off 
			ZWrite Off
			ZTest LEqual
			
			Pass {
			
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 2.0
				#pragma multi_compile_particles
				#pragma multi_compile_fog
				#include "UnityShaderVariables.cginc"


				#include "UnityCG.cginc"

				struct appdata_t 
				{
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					
				};

				struct v2f 
				{
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					#ifdef SOFTPARTICLES_ON
					float4 projPos : TEXCOORD2;
					#endif
					UNITY_VERTEX_OUTPUT_STEREO
					
				};
				
				uniform sampler2D _MainTex;
				uniform fixed4 _TintColor;
				uniform float4 _MainTex_ST;
				uniform sampler2D_float _CameraDepthTexture;
				uniform float _InvFade;
				uniform sampler2D _TextureSample0;
				uniform float4 _TextureSample0_ST;
				uniform float _EmissionAutoSwitch;
				uniform float _Float0;
				uniform sampler2D _TextureSample1;
				uniform float4 _TextureSample1_ST;

				v2f vert ( appdata_t v  )
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					

					v.vertex.xyz +=  float3( 0, 0, 0 ) ;
					o.vertex = UnityObjectToClipPos(v.vertex);
					#ifdef SOFTPARTICLES_ON
						o.projPos = ComputeScreenPos (o.vertex);
						COMPUTE_EYEDEPTH(o.projPos.z);
					#endif
					o.color = v.color;
					o.texcoord = v.texcoord;
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag ( v2f i  ) : SV_Target
				{
					#ifdef SOFTPARTICLES_ON
						float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
						float partZ = i.projPos.z;
						float fade = saturate (_InvFade * (sceneZ-partZ));
						i.color.a *= fade;
					#endif

					float2 uv_TextureSample0 = i.texcoord.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
					float4 tex2DNode51 = tex2D( _TextureSample0, uv_TextureSample0 );
					float2 uv_TextureSample1 = i.texcoord.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
					

					fixed4 col = ( ( tex2DNode51 * ( tex2DNode51 * ( lerp(_Float0,_CosTime.w,_EmissionAutoSwitch) + 1.5 ) ) ) + tex2D( _TextureSample1, uv_TextureSample1 ) );
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
				ENDCG 
			}
		}	
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
