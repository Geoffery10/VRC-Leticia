// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Screen/Fade Screen"
{
	Properties
	{
		_Colorspeed("Color speed", Range( 0 , 1)) = 0.2
		_Light("Light", Range( -1 , 1)) = 1
		_color("color ", Range( -1 , 1)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Overlay"  "Queue" = "Overlay+10000" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		ZTest Always
		Offset  0 , 0
		Blend SrcAlpha OneMinusSrcAlpha
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 screenPos;
		};

		uniform float _Colorspeed;
		uniform float _Light;
		uniform float _color;
		uniform sampler2D _GrabTexture;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


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


		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime8 = _Time.y * _Colorspeed;
			float3 hsvTorgb10 = HSVToRGB( float3(mulTime8,_Light,_color) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor2 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float4 blendOpSrc4 = float4( hsvTorgb10 , 0.0 );
			float4 blendOpDest4 = screenColor2;
			o.Emission = ( saturate( (( blendOpDest4 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest4 - 0.5 ) ) * ( 1.0 - blendOpSrc4 ) ) : ( 2.0 * blendOpDest4 * blendOpSrc4 ) ) )).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
-201;814;1906;994;1859.714;195.2503;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;9;-1328.434,193.2596;Float;False;Property;_Colorspeed;Color speed;1;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1328.146,337.5418;Float;False;Property;_color;color ;3;0;Create;True;0;0;False;0;0;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1324.673,265.6018;Float;False;Property;_Light;Light;2;0;Create;True;0;0;False;0;0;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;6;-1284.928,33.47828;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;8;-1068.129,196.1073;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;10;-1065.568,260.4396;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScreenColorNode;2;-1068.772,33.32107;Float;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;4;-906.6001,164.5;Float;False;Overlay;True;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-676,230;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;NEK0/Fade Screen;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;1;False;-1;7;False;-1;True;0;0;False;0;Custom;0.5;True;True;0;True;Overlay;;Overlay;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;9;0
WireConnection;10;0;8;0
WireConnection;10;1;11;0
WireConnection;10;2;12;0
WireConnection;2;0;6;0
WireConnection;4;0;10;0
WireConnection;4;1;2;0
WireConnection;0;2;4;0
ASEEND*/
//CHKSM=6C252660D823E92FD73C2586A3250FC3FC1510F8