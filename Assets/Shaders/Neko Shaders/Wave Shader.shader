// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Object Shaders/Waving Texture Shader"
{
	Properties
	{
		[NoScaleOffset][Normal]_DistortionNormal("Distortion Normal", 2D) = "bump" {}
		_Float0("Float 0", Range( -5 , 5)) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+1000000" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Texture0;
		uniform sampler2D _DistortionNormal;
		uniform float4 _Texture0_ST;
		uniform float _Float0;

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Texture0 = i.uv_texcoord * _Texture0_ST.xy + _Texture0_ST.zw;
			float2 MainUvs222_g4 = uv_Texture0;
			float4 tex2DNode65_g4 = tex2D( _DistortionNormal, MainUvs222_g4 );
			float4 appendResult82_g4 = (float4(0.0 , tex2DNode65_g4.g , 0.0 , tex2DNode65_g4.r));
			float mulTime35 = _Time.y * _Float0;
			float2 temp_output_84_0_g4 = (UnpackScaleNormal( appendResult82_g4 ,( sin( mulTime35 ) / 50.0 ) )).xy;
			float2 temp_output_71_0_g4 = ( temp_output_84_0_g4 + MainUvs222_g4 );
			float4 tex2DNode96_g4 = tex2D( _Texture0, temp_output_71_0_g4 );
			o.Emission = tex2DNode96_g4.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
259;347;1906;889;1562.485;96.7886;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;33;-1053.485,245.2114;Float;False;Property;_Float0;Float 0;7;0;Create;True;0;0;False;0;0;0;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;35;-1128.485,32.2114;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;34;-985.4849,-55.7886;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;36;-717.4849,18.2114;Float;False;2;0;FLOAT;0;False;1;FLOAT;50;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-654.9208,148.3257;Float;True;Property;_Texture0;Texture 0;8;0;Create;True;0;0;False;0;None;None;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.FunctionNode;32;-411.3332,-54.12177;Float;False;UI-Sprite Effect Layer;0;;4;789bf62641c5cfe4ab7126850acc22b8;18,204,0,74,0,191,0,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,0,98,0,234,0,126,0,129,1,130,0,31,0;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Custom/NEK0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;35;0;33;0
WireConnection;34;0;35;0
WireConnection;36;0;34;0
WireConnection;32;37;3;0
WireConnection;32;80;36;0
WireConnection;0;2;32;0
ASEEND*/
//CHKSM=415FAC2E4F83EDFB80278819D55A1F234E142221