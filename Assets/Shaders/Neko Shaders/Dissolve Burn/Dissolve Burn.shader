
Shader "Custom/Animation Shaders/Dissolve Burn Shader"
{
	Properties
	{



		_Cutoff( "Mask Clip Value", Float ) = 0.4
		_MainTex("Main Tex", 2D) = "white" {}
		_BurnTex("Burn Tex", 2D) = "white" {}
		_DisolveMap("Dissolve Map", 2D) = "white" {}
		_Dissolve("Dissolve ", Range( 0 , 3)) = 0
		[HDR]_ColorBurnRamp("Color Burn Ramp", Color) = (1,1,1,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _Dissolve;
		uniform sampler2D _DisolveMap;
		uniform float4 _DisolveMap_ST;
		uniform sampler2D _BurnTex;
		uniform float4 _ColorBurnRamp;
		uniform float _Cutoff = 0.4;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			o.Albedo = tex2D( _MainTex, uv_MainTex ).rgb;
			float2 uv_DisolveMap = i.uv_texcoord * _DisolveMap_ST.xy + _DisolveMap_ST.zw;
			float temp_output_73_0 = ( (-0.6 + (( 1.0 - _Dissolve ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + tex2D( _DisolveMap, uv_DisolveMap ).r );
			float clampResult113 = clamp( (-4.0 + (temp_output_73_0 - 0.0) * (4.0 - -4.0) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float temp_output_130_0 = ( 1.0 - clampResult113 );
			float2 appendResult115 = (float2(temp_output_130_0 , 0.0));
			o.Emission = ( temp_output_130_0 * ( tex2D( _BurnTex, appendResult115 ) + _ColorBurnRamp ) ).rgb;
			o.Alpha = 1;
			clip( temp_output_73_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
