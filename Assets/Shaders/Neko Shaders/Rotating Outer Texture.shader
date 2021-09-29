// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Misc/Rotation Texture"
{
	Properties
	{
		_FireTexture("Rotation Texture", 2D) = "white" {}
		_BurnMask("Main Texture", 2D) = "white" {}
		_Light("Light", Range( 1 , 10)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _BurnMask;
		uniform float4 _BurnMask_ST;
		uniform sampler2D _FireTexture;
		uniform float _Light;

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_BurnMask = i.uv_texcoord * _BurnMask_ST.xy + _BurnMask_ST.zw;
			float2 temp_cast_0 = (0.9241701).xx;
			float2 uv_TexCoord29 = i.uv_texcoord + temp_cast_0;
			float2 panner2_g2 = ( _Time.x * float2( -1,0 ) + uv_TexCoord29);
			o.Emission = ( ( tex2D( _BurnMask, uv_BurnMask ) * tex2D( _FireTexture, panner2_g2 ) ) * ( _Light * ( _SinTime.w + 1.5 ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
-22;852;1906;1004;1655.916;168.304;1.3;True;True
Node;AmplifyShaderEditor.RangedFloatNode;34;-800.4543,504.0679;Float;False;Constant;_Float3;Float 3;4;0;Create;True;0;0;False;0;0.9241701;0;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-588.3525,323.7679;Float;False;Property;_Light;Light;3;0;Create;True;0;0;False;0;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-548.0537,416.568;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;30;-327.8533,327.868;Float;False;Burn Effect;0;;2;e412e392e3db9574fbf6397db39b4c51;0;2;12;FLOAT;0;False;14;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;38;72.45956,823.4688;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;NEK0/ Nois Tex;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;29;1;34;0
WireConnection;30;12;31;0
WireConnection;30;14;29;0
WireConnection;38;2;30;0
ASEEND*/
//CHKSM=C6E69E6A4B236B87A6D2C05084EA6A29D84DA6A9