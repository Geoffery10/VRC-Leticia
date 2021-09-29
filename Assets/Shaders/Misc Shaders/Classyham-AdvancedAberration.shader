// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Screen/Aberration Shader"
{
	Properties
	{
		_GreenOffset("GreenOffset", Vector) = (1,1,0,0)
		_BlueOffset("BlueOffset", Vector) = (1,1,0,0)
		_RedOffset("Red Offset", Vector) = (1,1,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Overlay+0" "IsEmissive" = "true"  }
		Cull Off
		ZTest Always
		GrabPass{ }
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float4 screenPos;
		};

		uniform sampler2D _GrabTexture;
		uniform float2 _RedOffset;
		uniform float2 _GreenOffset;
		uniform float2 _BlueOffset;


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
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 appendResult28 = (float4(( _RedOffset.x * ase_grabScreenPosNorm.r ) , ( ase_grabScreenPosNorm.g * _RedOffset.y ) , 0 , 0));
			float4 screenColor2 = tex2D( _GrabTexture, appendResult28.xy );
			float4 appendResult42 = (float4(( _GreenOffset.x * ase_grabScreenPosNorm.r ) , ( ase_grabScreenPosNorm.g * _GreenOffset.y ) , 0 , 0));
			float4 screenColor43 = tex2D( _GrabTexture, appendResult42.xy );
			float4 appendResult36 = (float4(( _BlueOffset.x * ase_grabScreenPosNorm.r ) , ( ase_grabScreenPosNorm.g * _BlueOffset.y ) , 0 , 0));
			float4 screenColor37 = tex2D( _GrabTexture, appendResult36.xy );
			float4 appendResult16 = (float4(screenColor2.r , screenColor43.g , screenColor37.b , 0));
			o.Emission = appendResult16.xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15001
106;139;1906;1014;2602.178;789.864;2.022472;True;True
Node;AmplifyShaderEditor.Vector2Node;31;-1388,-353;Float;False;Property;_RedOffset;Red Offset;3;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GrabScreenPosition;1;-1452,-216;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;44;-1386.689,-8.098907;Float;False;Property;_GreenOffset;GreenOffset;1;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;38;-1402.294,356.1025;Float;False;Property;_BlueOffset;BlueOffset;2;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GrabScreenPosition;39;-1450.689,128.9011;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GrabScreenPosition;33;-1466.294,493.1025;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1166.294,456.1025;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1155,-147;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1152,-253;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1153.689,197.9012;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-1150.689,91.90109;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-1169.294,562.1026;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;-970,-178;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;42;-968.6895,166.9012;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;36;-984.2939,531.1026;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenColorNode;2;-810,-195;Float;False;Global;_GrabScreen0;Grab Screen 0;1;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;37;-824.2939,514.1025;Float;False;Global;_GrabScreen2;Grab Screen 2;1;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;43;-808.6894,149.9011;Float;False;Global;_GrabScreen1;Grab Screen 1;1;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;16;-147,25;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;179,-40;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Classyham/Advanced Aberration;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;7;False;-1;False;0;0;False;0;Custom;0.5;True;False;0;False;Transparent;;Overlay;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;34;0;38;1
WireConnection;34;1;33;1
WireConnection;32;0;1;2
WireConnection;32;1;31;2
WireConnection;30;0;31;1
WireConnection;30;1;1;1
WireConnection;41;0;39;2
WireConnection;41;1;44;2
WireConnection;40;0;44;1
WireConnection;40;1;39;1
WireConnection;35;0;33;2
WireConnection;35;1;38;2
WireConnection;28;0;30;0
WireConnection;28;1;32;0
WireConnection;42;0;40;0
WireConnection;42;1;41;0
WireConnection;36;0;34;0
WireConnection;36;1;35;0
WireConnection;2;0;28;0
WireConnection;37;0;36;0
WireConnection;43;0;42;0
WireConnection;16;0;2;1
WireConnection;16;1;43;2
WireConnection;16;2;37;3
WireConnection;0;2;16;0
ASEEND*/
//CHKSM=AED23B3E5CDF81A8D2E83B963909C183A6897407