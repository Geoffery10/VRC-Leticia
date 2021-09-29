// Made By NEK0
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Screen/Dark Screen"
{
	Properties
	{
		_darkness("darkness", Float) = 0
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

		Tags{ "RenderType" = "Opaque"  "Queue" = "Overlay+4000" "IsEmissive" = "true"  }
		Cull Front
		ZWrite On
		ZTest Always
		Offset  10 , 1
		GrabPass{ }
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 screenPos;
		};

		uniform sampler2D _GrabTexture;
		uniform float _darkness;


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
			float4 screenColor1 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + float4( 0,0,0,0 ) ).xy );
			float lerpResult16 = lerp( screenColor1.r , 0.0 , _darkness);
			float4 screenColor21 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + float4( 0,0,0,0 ) ).xy );
			float lerpResult19 = lerp( screenColor21.g , 0.0 , _darkness);
			float4 screenColor22 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + float4( 0,0,0,0 ) ).xy );
			float lerpResult20 = lerp( screenColor22.b , 0.0 , _darkness);
			float4 appendResult11 = (float4(lerpResult16 , lerpResult19 , lerpResult20 , 0.0));
			o.Emission = appendResult11.xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "NEKO"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
7;150;1266;561;1260.608;-21.5157;1.849292;True;True
Node;AmplifyShaderEditor.GrabScreenPosition;2;-715.1228,301.28;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GrabScreenPosition;26;-712.6384,670.3337;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GrabScreenPosition;25;-719.7863,486.6231;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-495.9551,695.9531;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-498.8892,523.9741;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;4;-498.0828,309.2605;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenColorNode;21;-392.6969,484.5291;Float;False;Global;_GrabScreen1;Grab Screen 1;1;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;22;-389.8629,656.8119;Float;False;Global;_GrabScreen2;Grab Screen 2;1;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;1;-390.3282,306.7181;Float;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-233.8374,463.3188;Float;True;Property;_darkness;darkness;1;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;-79.95323,508.8917;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;20;-225.3148,679.9572;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;16;-234.6982,338.0508;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;11;54.96307,491.0878;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;43;179.1574,445.2121;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Nek0  dark v2 shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Front;1;False;-1;7;False;-1;True;10;1;True;2;Custom;0.5;True;True;0;True;Opaque;;Overlay;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;NEKO;0;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;0;26;0
WireConnection;23;0;25;0
WireConnection;4;0;2;0
WireConnection;21;0;23;0
WireConnection;22;0;24;0
WireConnection;1;0;4;0
WireConnection;19;0;21;2
WireConnection;19;2;17;0
WireConnection;20;0;22;3
WireConnection;20;2;17;0
WireConnection;16;0;1;1
WireConnection;16;2;17;0
WireConnection;11;0;16;0
WireConnection;11;1;19;0
WireConnection;11;2;20;0
WireConnection;43;2;11;0
ASEEND*/
//CHKSM=0A8EAA73D9B1E7C349C581454AD49D47B78A20B5