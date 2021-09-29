// v2.0
// Made by Doppelganger#8376 with Amplify Shader Editor
// New metallic calculation. added Reflection Cubemap support, unlit/lit switch.
Shader "Custom/Object Shaders/MetallicFX"
{
	Properties
	{
		_Maintex("Main Texture", 2D) = "white" {}
		_Normalmap("Normal map", 2D) = "white" {}
		_ReflectionCubemap("Reflection Cubemap", CUBE) = "bump" {}
		[HDR]_Maintint("Main tint", Color) = (0,0,0,0)
		[HDR]_Metallictint("Metallic tint", Color) = (2,2,2,0)
		[HDR]_Cubemaptint("Cubemap tint", Color) = (0,0,0,0)
		_Metallicpower("Metallic power", Range( 0 , 10)) = 0
		_Normalmapscale("Normal map scale", Range( 0 , 1)) = 0
		[Toggle]_Unlitswitch("Unlit switch", Float) = 1
		[Toggle]_WorldnormalUVswitch("World normal UV switch", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityStandardUtils.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
			float3 viewDir;
			float3 worldRefl;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			fixed3 Albedo;
			fixed3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			fixed Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _Unlitswitch;
		uniform sampler2D _Maintex;
		uniform float4 _Maintex_ST;
		uniform float4 _Maintint;
		uniform float _WorldnormalUVswitch;
		uniform sampler2D _Normalmap;
		uniform float _Normalmapscale;
		uniform float4 _Normalmap_ST;
		uniform float _Metallicpower;
		uniform float4 _Metallictint;
		uniform samplerCUBE _ReflectionCubemap;
		uniform float4 _Cubemaptint;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			SurfaceOutputStandard s47 = (SurfaceOutputStandard ) 0;
			float2 uv_Maintex = i.uv_texcoord * _Maintex_ST.xy + _Maintex_ST.zw;
			float2 uv_Normalmap = i.uv_texcoord * _Normalmap_ST.xy + _Normalmap_ST.zw;
			float3 tex2DNode6 = UnpackScaleNormal( tex2D( _Normalmap, i.uv_texcoord ) ,_Normalmapscale );
			float3 normalizeResult4 = normalize( i.viewDir );
			float dotResult3 = dot( lerp(UnpackScaleNormal( tex2D( _Normalmap, uv_Normalmap ) ,_Normalmapscale ),WorldNormalVector( i , tex2DNode6 ),_WorldnormalUVswitch) , ( 1.0 - normalizeResult4 ) );
			float dotResult56 = dot( lerp(UnpackScaleNormal( tex2D( _Normalmap, uv_Normalmap ) ,_Normalmapscale ),WorldNormalVector( i , tex2DNode6 ),_WorldnormalUVswitch) , normalizeResult4 );
			float4 temp_output_32_0 = ( ( tex2D( _Maintex, uv_Maintex ) * _Maintint ) + ( pow( saturate( dotResult3 ) , (10.0 + (_Metallicpower - 0.0) * (0.0 - 10.0) / (10.0 - 0.0)) ) * ( _Metallictint / 3.0 ) ) + ( pow( saturate( dotResult56 ) , (10.0 + (_Metallicpower - 0.0) * (0.0 - 10.0) / (10.0 - 0.0)) ) * _Metallictint ) + ( texCUBE( _ReflectionCubemap, WorldReflectionVector( i , lerp(UnpackScaleNormal( tex2D( _Normalmap, uv_Normalmap ) ,_Normalmapscale ),WorldNormalVector( i , tex2DNode6 ),_WorldnormalUVswitch) ) ) * _Cubemaptint ) );
			s47.Albedo = temp_output_32_0.rgb;
			s47.Normal = WorldNormalVector( i , tex2DNode6 );
			float3 temp_cast_1 = (0.0).xxx;
			s47.Emission = temp_cast_1;
			s47.Metallic = 0.0;
			s47.Smoothness = 0.0;
			s47.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi47 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g47 = UnityGlossyEnvironmentSetup( s47.Smoothness, data.worldViewDir, s47.Normal, float3(0,0,0));
			gi47 = UnityGlobalIllumination( data, s47.Occlusion, s47.Normal, g47 );
			#endif

			float3 surfResult47 = LightingStandard ( s47, viewDir, gi47 ).rgb;
			surfResult47 += s47.Emission;

			c.rgb = lerp(float4( surfResult47 , 0.0 ),temp_output_32_0,_Unlitswitch).rgb;
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
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

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
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
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
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.worldRefl = -worldViewDir;
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