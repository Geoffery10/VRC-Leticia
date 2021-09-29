// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Object Shaders/Glass Shader"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 13.6
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
		[Header(Refraction)]
		_ChromaticAberration("Chromatic Aberration", Range( 0 , 0.3)) = 0.1
		_NormalMap("Normal Map", 2D) = "bump" {}
		_NormalScale("Normal Scale", Range( 0 , 1)) = 0.1
		_CubeMap("Cube Map", CUBE) = "white" {}
		_Opacity("Opacity", Range( 0 , 0.02)) = 0
		_IndexofRefraction("Index of Refraction", Range( -3 , 4)) = 1
		_Smooth("Smooth", Range( 0 , 1)) = 1
		_Metalic("Metalic", Range( 0 , 0.02)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+3000" "IgnoreProjector" = "True" }
		Cull Back
		AlphaToMask On
		GrabPass{ }
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#pragma multi_compile _ALPHAPREMULTIPLY_ON
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
			float2 uv_texcoord;
			float3 worldRefl;
			INTERNAL_DATA
			float4 screenPos;
			float3 worldPos;
		};

		uniform float _NormalScale;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform samplerCUBE _CubeMap;
		uniform float _Metalic;
		uniform float _Smooth;
		uniform float _Opacity;
		uniform sampler2D _GrabTexture;
		uniform float _ChromaticAberration;
		uniform float _IndexofRefraction;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		inline float4 Refraction( Input i, SurfaceOutputStandard o, float indexOfRefraction, float chomaticAberration ) {
			float3 worldNormal = o.Normal;
			float4 screenPos = i.screenPos;
			#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
			#else
				float scale = 1.0;
			#endif
			float halfPosW = screenPos.w * 0.5;
			screenPos.y = ( screenPos.y - halfPosW ) * _ProjectionParams.x * scale + halfPosW;
			#if SHADER_API_D3D9 || SHADER_API_D3D11
				screenPos.w += 0.00000000001;
			#endif
			float2 projScreenPos = ( screenPos / screenPos.w ).xy;
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float3 refractionOffset = ( ( ( ( indexOfRefraction - 1.0 ) * mul( UNITY_MATRIX_V, float4( worldNormal, 0.0 ) ) ) * ( 1.0 / ( screenPos.z + 1.0 ) ) ) * ( 1.0 - dot( worldNormal, worldViewDir ) ) );
			float2 cameraRefraction = float2( refractionOffset.x, -( refractionOffset.y * _ProjectionParams.x ) );
			float4 redAlpha = tex2D( _GrabTexture, ( projScreenPos + cameraRefraction ) );
			float green = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 - chomaticAberration ) ) ) ).g;
			float blue = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 + chomaticAberration ) ) ) ).b;
			return float4( redAlpha.r, green, blue, redAlpha.a );
		}

		void RefractionF( Input i, SurfaceOutputStandard o, inout fixed4 color )
		{
			#ifdef UNITY_PASS_FORWARDBASE
			color.rgb = color.rgb + Refraction( i, o, _IndexofRefraction, _ChromaticAberration ) * ( 1 - color.a );
			color.a = 1;
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 tex2DNode54 = UnpackScaleNormal( tex2D( _NormalMap, uv_NormalMap ) ,_NormalScale );
			o.Normal = tex2DNode54;
			float div79=256.0/float(256);
			float4 posterize79 = ( floor( CalculateContrast(1.2,( texCUBE( _CubeMap, WorldReflectionVector( i , tex2DNode54 ) ) * 99 )) * div79 ) / div79 );
			o.Albedo = posterize79.rgb;
			o.Metallic = _Metalic;
			o.Smoothness = _Smooth;
			o.Alpha = _Opacity;
			o.Normal = o.Normal + 0.00001 * i.screenPos * i.worldPos;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha finalcolor:RefractionF fullforwardshadows exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			AlphaToMask Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
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
				o.screenPos = ComputeScreenPos( o.pos );
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
				surfIN.worldPos = worldPos;
				surfIN.worldRefl = -worldViewDir;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
200;254;1208;579;437.5426;265.7023;1.3;True;True
Node;AmplifyShaderEditor.RangedFloatNode;55;-975.6902,141.84;Float;False;Property;_NormalScale;Normal Scale;7;0;Create;True;0;0;False;0;0.1;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;-646.7961,71.6934;Float;True;Property;_NormalMap;Normal Map;6;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldReflectionVector;46;-268.58,-82.80111;Float;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;52;304.7198,-183.0011;Float;False;293.1999;207.6;Multiplier to make it POP;2;53;79;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;45;-23.07985,-140.8011;Float;True;Property;_CubeMap;Cube Map;8;0;Create;True;0;0;False;0;56a68e301a0ff55469ae441c0112d256;504df9e52643429478e418b6a0562535;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleNode;53;322.1033,-130.1067;Float;False;99;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;75;525.3408,-172.0972;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.2;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-118.1801,371.399;Float;False;Property;_Opacity;Opacity;9;0;Create;True;0;0;False;0;0;0.00799;0;0.02;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;357.5978,131.4218;Float;False;Property;_Metalic;Metalic;12;0;Create;True;0;0;False;0;0;0.02;0;0.02;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;262.5978,240.4218;Float;False;Property;_Smooth;Smooth;11;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;165.3408,466.9028;Float;False;Property;_Float0;Float 0;13;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;46.05365,152.9166;Float;False;Property;_IndexofRefraction;Index of Refraction;10;0;Create;True;0;0;False;0;1;0.976;-3;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;73;399.3408,427.9028;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosterizeNode;79;533.5571,-42.10237;Float;False;256;2;1;COLOR;0,0,0,0;False;0;INT;256;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;696.3,49.80001;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;Rollthered/CrushedRGBRefraction;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;3;False;-1;False;0;0;False;0;Translucent;0.5;True;True;3000;False;Opaque;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;0;13.6;10;25;False;0.5;True;0;1;False;-1;10;False;-1;8;5;False;-1;1;False;-1;2;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;5;0;0;0;0;True;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;54;5;55;0
WireConnection;46;0;54;0
WireConnection;45;1;46;0
WireConnection;53;0;45;0
WireConnection;75;1;53;0
WireConnection;73;0;74;0
WireConnection;79;1;75;0
WireConnection;0;0;79;0
WireConnection;0;1;54;0
WireConnection;0;3;68;0
WireConnection;0;4;67;0
WireConnection;0;8;41;0
WireConnection;0;9;42;0
ASEEND*/
//CHKSM=5CD1DF8CDE7BC40512BC1934AC6168C058AFA47B