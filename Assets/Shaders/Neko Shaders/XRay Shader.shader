Shader "Custom/Misc/Xray Shader "
{
	Properties
	{

		[Header(___Textures___)]
			_TextureA("Texture A", 2D) = "white" {}
			_TextureB("Texture B", 2D) = "white" {}
			_Interpolator("Interpolator", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[Toggle]_EmissionSwitch("Emission Switch", Float) = 0
		_EmissionTexture("Emission Texture", 2D) = "white" {}

		[Space(18)]
		[Header(___X Ray___)]
		_XRayColor("XRayColor", Color) = (0,0,0,0)
		_ASEOutlineWidth( "Outline Width", Float ) = 0
		_XRayPower("XRayPower", Float) = 0
		_XRayScale("XRayScale", Float) = 0
		_XRayBias("XRayBias", Float) = 0
		_XRayIntensity("XRayIntensity", Float) = 0

		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Pass
		{
			ColorMask 0
			ZWrite On
		}

		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0"}
		ZWrite Off
		ZTest Always
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog alpha:fade  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		
		
		
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};
		uniform float _XRayBias;
		uniform float _XRayScale;
		uniform float _XRayPower;
		uniform float4 _XRayColor;
		uniform float _XRayIntensity;
		uniform half _ASEOutlineWidth;
		
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += ( v.normal * _ASEOutlineWidth );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV4 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode4 = ( _XRayBias + _XRayScale * pow( 1.0 - fresnelNdotV4, _XRayPower ) );
			o.Emission = ( fresnelNode4 * _XRayColor ).rgb;
			o.Alpha = ( fresnelNode4 * (_XRayColor).a * _XRayIntensity );
			o.Normal = float3(0,0,-1);
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+1" "IsEmissive" = "true"  }
		Cull Back
		ZWrite On
		ZTest LEqual
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureA;
		uniform float4 _TextureA_ST;
		uniform sampler2D _TextureB;
		uniform float4 _TextureB_ST;
		uniform sampler2D _Interpolator;
		uniform float4 _Interpolator_ST;
		uniform float _EmissionSwitch;
		uniform sampler2D _EmissionTexture;
		uniform float4 _EmissionTexture_ST;
		uniform float _Metallic;
		uniform float _Smoothness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += 0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureA = i.uv_texcoord * _TextureA_ST.xy + _TextureA_ST.zw;
			float4 temp_cast_0 = (tex2D( _TextureA, uv_TextureA ).r).xxxx;
			float2 uv_TextureB = i.uv_texcoord * _TextureB_ST.xy + _TextureB_ST.zw;
			float2 uv_Interpolator = i.uv_texcoord * _Interpolator_ST.xy + _Interpolator_ST.zw;
			float4 lerpResult18 = lerp( temp_cast_0 , tex2D( _TextureB, uv_TextureB ) , tex2D( _Interpolator, uv_Interpolator ).r);
			o.Albedo = lerpResult18.rgb;
			float2 uv_EmissionTexture = i.uv_texcoord * _EmissionTexture_ST.xy + _EmissionTexture_ST.zw;
			o.Emission = lerp(float4( 0,0,0,0 ),tex2D( _EmissionTexture, uv_EmissionTexture ),_EmissionSwitch).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}