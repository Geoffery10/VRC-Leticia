// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Misc/Costume Shader"
{
	Properties
	{
	_MAINTEX("MAIN TEX", 2D) = "white" {}
	_Color0("Color ", Color) = (0,0,0,0)
	[Space]
	[Space]
	[NoScaleOffset][Normal]_DistortionNormal("Main Distortion ", 2D) = "bump" {}
	_MainTexDistor("Main Distortion", Range( -5 , 5)) = 0
	[Space]
	[Toggle(_GRAYSCALE_ON)] _Grayscale("Grayscale", Float) = 0
	[Space]
	[Space]
	[Space]
	[Space]
	[Toggle(_MAINTEXSWITCH_ON)] _MainTexSwitch("Main Tex Switch", Float) = 0


		[NoScaleOffset]_FireTexture("Under Texture", 2D) = "white" {}
		[NoScaleOffset]_BurnMask("Over Mask", 2D) = "white" {}


	
		_Texsize("Tex size", Range( 0 , 5)) = 0
		_Speed("Speed", Range( 0 , 5)) = 0
		_Light("Light", Range( -9 , 9)) = 1

		[Space]
		[Space]
		[Space]
		[Space]
	




		_Outline("Outline", Range( 0 , 0.04)) = 0
		[Toggle(_TEXCOLOR_ON)] _TEXCOLOR("Outline TEX / COLOR", Float) = 0
		[NoScaleOffset]_Outlinetex("Outline tex", 2D) = "white" {}
		_OutlineColor("Outline Color ", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		
		
		#pragma shader_feature _TEXCOLOR_ON
		
		struct Input
		{
			float2 uv_texcoord;
		};
		uniform float _Outline;
		uniform sampler2D _Outlinetex;
		uniform float4 _Outlinetex_ST;
		uniform float4 _OutlineColor;
		
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float outlineVar = _Outline;
			v.vertex.xyz += ( v.normal * outlineVar );
		}
		inline fixed4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return fixed4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			float2 uv_Outlinetex = i.uv_texcoord * _Outlinetex_ST.xy + _Outlinetex_ST.zw;
			#ifdef _TEXCOLOR_ON
				float4 staticSwitch64 = _OutlineColor;
			#else
				float4 staticSwitch64 = tex2D( _Outlinetex, uv_Outlinetex );
			#endif
			o.Emission = staticSwitch64.rgb;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma shader_feature _MAINTEXSWITCH_ON
		#pragma shader_feature _GRAYSCALE_ON
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 vertexToFrag44;
		};

		uniform sampler2D _MAINTEX;
		uniform sampler2D _DistortionNormal;
		uniform float4 _MAINTEX_ST;
		uniform float _MainTexDistor;
		uniform float4 _Color0;
		uniform sampler2D _BurnMask;
		uniform float4 _BurnMask_ST;
		uniform sampler2D _FireTexture;
		uniform sampler2D sampler6048;
		uniform float _Texsize;
		uniform float _Speed;
		uniform float _Light;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.vertexToFrag44 = 0;
		}

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MAINTEX = i.uv_texcoord * _MAINTEX_ST.xy + _MAINTEX_ST.zw;
			float2 MainUvs222_g5 = uv_MAINTEX;
			float4 tex2DNode65_g5 = tex2D( _DistortionNormal, MainUvs222_g5 );
			float4 appendResult82_g5 = (float4(0.0 , tex2DNode65_g5.g , 0.0 , tex2DNode65_g5.r));
			float mulTime55 = _Time.y * _MainTexDistor;
			float2 temp_output_84_0_g5 = (UnpackScaleNormal( appendResult82_g5 ,( sin( mulTime55 ) / 50.0 ) )).xy;
			float2 temp_output_71_0_g5 = ( temp_output_84_0_g5 + MainUvs222_g5 );
			float4 tex2DNode96_g5 = tex2D( _MAINTEX, temp_output_71_0_g5 );
			float4 temp_output_52_0 = tex2DNode96_g5;
			float grayscale58 = Luminance(temp_output_52_0.rgb);
			float4 temp_cast_1 = (grayscale58).xxxx;
			#ifdef _GRAYSCALE_ON
				float4 staticSwitch61 = temp_cast_1;
			#else
				float4 staticSwitch61 = ( temp_output_52_0 + _Color0 );
			#endif
			float2 uv_BurnMask = i.uv_texcoord * _BurnMask_ST.xy + _BurnMask_ST.zw;
			float2 temp_output_1_0_g6 = float2( 1,1 );
			float2 appendResult10_g6 = (float2(( (temp_output_1_0_g6).x * i.uv_texcoord.x ) , ( i.uv_texcoord.y * (temp_output_1_0_g6).y )));
			float2 temp_output_11_0_g6 = float2( 0,0 );
			float2 panner18_g6 = ( ( (temp_output_11_0_g6).x * _Time.y ) * float2( 1,0 ) + i.uv_texcoord);
			float2 panner19_g6 = ( ( _Time.y * (temp_output_11_0_g6).y ) * float2( 0,1 ) + i.uv_texcoord);
			float2 appendResult24_g6 = (float2((panner18_g6).x , (panner19_g6).y));
			float2 temp_cast_2 = (_Texsize).xx;
			float2 temp_cast_3 = (_Speed).xx;
			float2 temp_output_47_0_g6 = temp_cast_3;
			float2 uv_TexCoord78_g6 = i.uv_texcoord * float2( 2,2 );
			float2 temp_output_31_0_g6 = ( uv_TexCoord78_g6 - float2( 1,1 ) );
			float2 appendResult39_g6 = (float2(frac( ( atan2( (temp_output_31_0_g6).x , (temp_output_31_0_g6).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g6 )));
			float2 panner54_g6 = ( ( (temp_output_47_0_g6).x * _Time.y ) * float2( 1,0 ) + appendResult39_g6);
			float2 panner55_g6 = ( ( _Time.y * (temp_output_47_0_g6).y ) * float2( 0,1 ) + appendResult39_g6);
			float2 appendResult58_g6 = (float2((panner54_g6).x , (panner55_g6).y));
			float2 panner2_g7 = ( _Time.x * float2( -1,0 ) + ( ( (tex2D( sampler6048, ( appendResult10_g6 + appendResult24_g6 ) )).rg * 1.0 ) + ( temp_cast_2 * appendResult58_g6 ) ));
			#ifdef _MAINTEXSWITCH_ON
				float4 staticSwitch45 = ( ( tex2D( _BurnMask, uv_BurnMask ) * tex2D( _FireTexture, panner2_g7 ) ) * ( _Light * ( _SinTime.w + 1.5 ) ) );
			#else
				float4 staticSwitch45 = staticSwitch61;
			#endif
			o.Emission = ( staticSwitch45 + float4( i.vertexToFrag44 , 0.0 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
7;29;1906;1004;3261.683;1248.151;3.1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;56;-1889.205,-105.2625;Float;False;Property;_MainTexDistor;Main Tex Distor;17;0;Create;True;0;0;False;0;0;1.38;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;55;-1789.306,-173.8626;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;54;-1149.406,-91.66251;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;53;-1638.806,-115.8625;Float;False;2;0;FLOAT;0;False;1;FLOAT;50;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;60;-1533.579,-211.5025;Float;True;Property;_MAINTEX;MAIN TEX;10;0;Create;True;0;0;False;0;None;70d9f94c81a63434a9d0548418f10ea0;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-1338.749,321.5046;Float;False;Property;_Texsize;Tex size;15;0;Create;True;0;0;False;0;0;3.1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;42;-1483.823,561.3298;Float;True;Property;_Outlinetex;Outline tex;11;0;Create;True;0;0;False;0;None;265befa8f6fc8f44882ecdb07165bc86;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;68;-1056.863,-207.9482;Float;False;Property;_Color0;Color 0;13;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;63;-1436.22,748.2269;Float;False;Property;_OutlineColor;Outline Color ;14;0;Create;True;0;0;False;0;0,0,0,0;1,0.4705881,0.4705881,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;52;-1322.854,-209.3957;Float;False;UI-Sprite Effect Layer;0;;5;789bf62641c5cfe4ab7126850acc22b8;18,204,0,74,0,191,0,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,0,98,0,234,0,126,0,129,1,130,0,31,0;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.RangedFloatNode;46;-1337.949,393.0057;Float;False;Property;_Speed;Speed;16;0;Create;True;0;0;False;0;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1202.249,672.5061;Float;True;Property;_Outline;Outline;21;0;Create;True;0;0;False;0;0;1.6E-06;0;0.04;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-1645.262,-203.7482;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;64;-1175.59,572.2174;Float;False;Property;_TEXCOLOR;TEX / COLOR;12;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;58;-1324.278,-95.60246;Float;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1289.349,236.7052;Float;False;Property;_Light;Light;18;0;Create;True;0;0;False;0;1;1;-9;9;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;48;-1082.549,318.5056;Float;False;RadialUVDistortion;-1;;6;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;sampler6048;False;1;FLOAT2;1,1;False;11;FLOAT2;0,0;False;65;FLOAT;1;False;68;FLOAT2;1,1;False;47;FLOAT2;1,1;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;61;-868.6783,-223.0025;Float;True;Property;_Grayscale;Grayscale;20;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;49;-1033.149,236.304;Float;False;Burn Effect;7;;7;e412e392e3db9574fbf6397db39b4c51;0;2;12;FLOAT;0;False;14;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OutlineNode;43;-935.621,635.6762;Float;False;0;True;None;0;0;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexToFragmentNode;44;-939.7639,567.6846;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;45;-651.6962,-220.8817;Float;True;Property;_MainTexSwitch;Main Tex Switch;19;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-219.4701,96.42908;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;38;-61.92028,49.33005;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Neko Nois Tex v1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;55;0;56;0
WireConnection;54;0;55;0
WireConnection;53;0;54;0
WireConnection;52;37;60;0
WireConnection;52;80;53;0
WireConnection;69;0;52;0
WireConnection;69;1;68;0
WireConnection;64;1;42;0
WireConnection;64;0;63;0
WireConnection;58;0;52;0
WireConnection;48;68;47;0
WireConnection;48;47;46;0
WireConnection;61;1;69;0
WireConnection;61;0;58;0
WireConnection;49;12;50;0
WireConnection;49;14;48;0
WireConnection;43;0;64;0
WireConnection;43;1;41;0
WireConnection;44;0;43;0
WireConnection;45;1;61;0
WireConnection;45;0;49;0
WireConnection;40;0;45;0
WireConnection;40;1;44;0
WireConnection;38;2;40;0
ASEEND*/
//CHKSM=E26270ECB3869802B3F3317A88112E7F5BB5C795