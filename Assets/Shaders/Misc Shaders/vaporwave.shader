// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Screen/VaporWave Shader"
{
	Properties
	{
		_OffsetXRed("Offset X Red", Range( -1 , 1)) = 0
		_OffsetYRed("Offset Y Red", Range( -1 , 1)) = 0
		_OffsetXGreen("Offset X Green", Range( -1 , 1)) = 0
		_OffsetYGreen("Offset Y Green", Range( -1 , 1)) = 0
		_OffsetXBlue("Offset X Blue", Range( -1 , 1)) = 0
		_OffsetYBlue("Offset Y Blue", Range( -1 , 1)) = 0
		_Effect("Effect", Float) = 0
		[Toggle]_EnableGreen("Enable Green", Float) = 1
		[Toggle]_EnableBluie("Enable Bluie", Float) = 1
		[Toggle]_EnableRed("Enable Red", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Pass
		{
			ColorMask 0
			ZTest Greater
			ZWrite On
		}

		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		ZTest Always
		Offset  10 , 1
		Blend SrcAlpha OneMinusSrcAlpha
		GrabPass{ }
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float4 screenPos;
		};

		uniform float _EnableRed;
		uniform sampler2D _GrabTexture;
		uniform float _OffsetXRed;
		uniform float _OffsetYRed;
		uniform float _Effect;
		uniform float _EnableGreen;
		uniform float _OffsetXGreen;
		uniform float _OffsetYGreen;
		uniform float _EnableBluie;
		uniform float _OffsetXBlue;
		uniform float _OffsetYBlue;


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
			float4 appendResult192 = (float4(_OffsetXRed , _OffsetYRed , 0 , 0));
			float4 screenColor86 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + appendResult192 ).xy );
			float4 temp_cast_1 = (screenColor86.r).xxxx;
			float4 screenColor222 = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD( ase_grabScreenPos ) );
			float4 appendResult223 = (float4(screenColor222.g , screenColor222.b , 0 , 0));
			float4 lerpResult208 = lerp( temp_cast_1 , appendResult223 , _Effect);
			float4 appendResult203 = (float4(_OffsetXGreen , _OffsetYGreen , 0 , 0));
			float4 screenColor175 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + appendResult203 ).xy );
			float4 temp_cast_4 = (screenColor175.g).xxxx;
			float4 appendResult224 = (float4(screenColor222.r , screenColor222.b , 0 , 0));
			float4 lerpResult209 = lerp( temp_cast_4 , appendResult224 , _Effect);
			float4 appendResult197 = (float4(_OffsetXBlue , _OffsetYBlue , 0 , 0));
			float4 screenColor164 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + appendResult197 ).xy );
			float4 temp_cast_7 = (screenColor164.b).xxxx;
			float4 appendResult225 = (float4(screenColor222.g , screenColor222.r , 0 , 0));
			float4 lerpResult210 = lerp( temp_cast_7 , appendResult225 , _Effect);
			float4 appendResult161 = (float4(lerp(float4( 0,0,0,0 ),lerpResult208,_EnableRed).x , lerp(float4( 0,0,0,0 ),lerpResult209,_EnableGreen).x , lerp(float4( 0,0,0,0 ),lerpResult210,_EnableBluie).xy));
			o.Emission = appendResult161.xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15001
7;29;1906;1004;1192.794;562.2369;1.948196;True;False
Node;AmplifyShaderEditor.RangedFloatNode;193;-291.2001,-33.59998;Float;False;Property;_OffsetXRed;Offset X Red;0;0;Create;True;0;0;False;0;0;0.035;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;194;-289.6003,35.19986;Float;False;Property;_OffsetYRed;Offset Y Red;1;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;201;-305.5999,352.0003;Float;False;Property;_OffsetXGreen;Offset X Green;2;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;195;-337.5998,721.6;Float;False;Property;_OffsetXBlue;Offset X Blue;4;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;202;-300.8006,425.6002;Float;False;Property;_OffsetYGreen;Offset Y Green;3;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;196;-336.0005,796.7998;Float;False;Property;_OffsetYBlue;Offset Y Blue;5;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;109;-97.31958,-199.8616;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;192;-9.731918,-32.35788;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GrabScreenPosition;173;-118.5997,183.7383;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;203;-26.53677,354.1505;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;197;-39.53799,724.6486;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GrabScreenPosition;162;-119.0607,555.9471;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;114;163.7195,-104.7662;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;174;156.8392,301.2338;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenColorNode;222;299.8156,-214.2063;Float;False;Global;_GrabScreen3;Grab Screen 3;1;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;163;143.5785,647.8412;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;225;565.4164,46.59384;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;224;565.4177,-86.20618;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenColorNode;86;293.9711,12.02534;Float;False;Global;_GrabScreen0;Grab Screen 0;1;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;164;286.13,470.234;Float;False;Global;_GrabScreen1;Grab Screen 1;1;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;175;286.5909,296.4253;Float;False;Global;_GrabScreen2;Grab Screen 2;1;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;212;539.1999,260.8;Float;False;Property;_Effect;Effect;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;223;565.4185,-217.4064;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;208;876.1566,166.3695;Float;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;210;875.5577,404.569;Float;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;209;875.2571,286.5684;Float;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ToggleSwitchNode;226;1053.415,169.7934;Float;False;Property;_EnableRed;Enable Red;10;0;Create;True;0;0;False;0;1;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ToggleSwitchNode;228;1055.014,377.7934;Float;False;Property;_EnableBluie;Enable Bluie;9;0;Create;True;0;0;False;0;1;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ToggleSwitchNode;227;1053.414,276.9934;Float;False;Property;_EnableGreen;Enable Green;7;0;Create;True;0;0;False;0;1;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;161;1316.314,266.6962;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;129;1468.552,191.417;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Zer0/vaporwave;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;Off;1;False;-1;7;False;-1;True;10;1;True;2;Custom;0.5;True;False;0;True;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;8;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;192;0;193;0
WireConnection;192;1;194;0
WireConnection;203;0;201;0
WireConnection;203;1;202;0
WireConnection;197;0;195;0
WireConnection;197;1;196;0
WireConnection;114;0;109;0
WireConnection;114;1;192;0
WireConnection;174;0;173;0
WireConnection;174;1;203;0
WireConnection;163;0;162;0
WireConnection;163;1;197;0
WireConnection;225;0;222;2
WireConnection;225;1;222;1
WireConnection;224;0;222;1
WireConnection;224;1;222;3
WireConnection;86;0;114;0
WireConnection;164;0;163;0
WireConnection;175;0;174;0
WireConnection;223;0;222;2
WireConnection;223;1;222;3
WireConnection;208;0;86;1
WireConnection;208;1;223;0
WireConnection;208;2;212;0
WireConnection;210;0;164;3
WireConnection;210;1;225;0
WireConnection;210;2;212;0
WireConnection;209;0;175;2
WireConnection;209;1;224;0
WireConnection;209;2;212;0
WireConnection;226;1;208;0
WireConnection;228;1;210;0
WireConnection;227;1;209;0
WireConnection;161;0;226;0
WireConnection;161;1;227;0
WireConnection;161;2;228;0
WireConnection;129;2;161;0
ASEEND*/
//CHKSM=E280EBD5141149CFD29BBB5FCD55083647AC63AB