//Made with ASE by Doppelgänger#8376 v 1.1
Shader "Custom/Object Shaders/Rainbow Rim"
{
	Properties
	{
		[Header (Main settings)]
		[Space]
		[Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull", Int) = 2
		[Space]
		_MainTex("Main Texture", 2D) = "white" {}
		_Color("Main tint", Color) = (0,0,0,0)
		[Header (Rim settings)]
		[Space]
		_Rimnm("Rim Normal map", 2D) = "bump" {}
		_ns("Normals scale", Range( 0 , 1)) = 0
		_fc("Final color", Range( 0 , 1)) = 1
		_RimPower("Rim Power", Range( 0 , 1)) = 0.8
		_Shrapness("Shrapness", Range( 0 , 1)) = 0.2
		[Header (Rainbow settings)]
		[Space]
		_GradientTilling("Gradient Tilling", Range( 0 , 1)) = 0.5
		_Saturation("Saturation", Range( 0 , 1)) = 0.5
		_MovingSpeed("Moving Speed", Range( 0 , 1)) = 0.2
		[Toggle]_Changecalculation("Change calculation", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry" "IsEmissive" = "true"  }
		Cull [_Cull]
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
			INTERNAL_DATA
			half ASEVFace : VFACE;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _ns;
		uniform sampler2D _Rimnm;
		uniform float4 _Rimnm_ST;
		uniform float _Shrapness;
		uniform float _RimPower;
		uniform float _GradientTilling;
		uniform float _Changecalculation;
		uniform float _MovingSpeed;
		uniform float _Saturation;
		uniform float _fc;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;


		float3 ShadeSH955( float3 normal )
		{
			return ShadeSH9(float4(normal, 1.0));
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float3 normal55 = float3( 0,1,0 );
			float3 localShadeSH955 = ShadeSH955( normal55 );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			c.rgb = ( _Color * tex2D( _MainTex, uv_MainTex ) * saturate( ( float4( localShadeSH955 , 0.0 ) + ( ase_lightAtten * ase_lightColor ) ) ) ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			float2 uv_Rimnm = i.uv_texcoord * _Rimnm_ST.xy + _Rimnm_ST.zw;
			float3 tex2DNode19 = UnpackScaleNormal( tex2D( _Rimnm, uv_Rimnm ), _ns );
			float3 appendResult86 = (float3(tex2DNode19.r , tex2DNode19.g , ( tex2DNode19.b * ( _Shrapness + 1.0 ) )));
			float3 normalizeResult18 = normalize( i.viewDir );
			float dotResult20 = dot( appendResult86 , normalizeResult18 );
			float lerpResult103 = lerp( i.viewDir.y , i.viewDir.z , _Changecalculation);
			float temp_output_72_0 = ( ( _GradientTilling * 10.0 ) * -lerpResult103 );
			float3 appendResult73 = (float3(temp_output_72_0 , temp_output_72_0 , temp_output_72_0));
			float mulTime74 = _Time.y * ( _MovingSpeed * 5.0 );
			float3 switchResult119 = (((i.ASEVFace>0)?(( ( pow( ( 1.0 - saturate( dotResult20 ) ) , (30.0 + (_RimPower - 0.0) * (2.0 - 30.0) / (1.0 - 0.0)) ) * ( ( cos( ( appendResult73 + float3(0,2,4) + mulTime74 ) ) * _Saturation ) + ( 1.0 - _Saturation ) ) * ( _fc * 30.0 ) ) / 2.0 )):(float3( 0,0,0 ))));
			o.Emission = switchResult119;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows noshadow exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}