// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Animation Shaders/Vertex Move Shader"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_Offset("Offset", Range( -10 , 10)) = 10
		_Speed("Speed", Range( 0 , 0.5)) = 0.005
		_NoiseMap("Noise Map", 2D) = "white" {}
		[Toggle]_Vertexmove("Vertex move", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Overlay"  "Queue" = "Transparent+214748364" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite Off
		ZTest Always
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			fixed filler;
		};

		uniform sampler2D _NoiseMap;
		uniform float _Vertexmove;
		uniform float _Speed;
		uniform float _Offset;
		uniform float4 _Color;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (lerp(_Speed,( _Speed * _Time.y ),_Vertexmove)).xx;
			float2 uv_TexCoord9 = v.texcoord.xy + temp_cast_0;
			float simplePerlin2D8 = snoise( uv_TexCoord9 );
			float2 temp_cast_1 = (simplePerlin2D8).xx;
			float cos7 = cos( lerp(_Speed,( _Speed * _Time.y ),_Vertexmove) );
			float sin7 = sin( lerp(_Speed,( _Speed * _Time.y ),_Vertexmove) );
			float2 rotator7 = mul( temp_cast_1 - float2( 0,0 ) , float2x2( cos7 , -sin7 , sin7 , cos7 )) + float2( 0,0 );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( tex2Dlod( _NoiseMap, float4( rotator7, 0, 0.0) ) * float4( ase_vertexNormal , 0.0 ) * _Offset ).rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Emission = ( _Color * 1.0 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
294;280;1188;544;880.2239;392.0836;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;12;-2096,96;Float;False;Property;_Speed;Speed;2;0;Create;True;0;0;False;0;0.01;0;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;11;-2032,208;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1760,192;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;18;-1584,144;Float;False;Property;_Vertexmove;Vertex move;5;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-1312,64;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;8;-1040,64;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;7;-800,80;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-400,-32;Float;False;Constant;_Emission;Emission;0;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;19;-432,-224;Float;False;Property;_Color;Color;0;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-560,464;Float;False;Property;_Offset;Offset;1;0;Create;True;0;0;False;0;0.8;0;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;3;-480,288;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-576,64;Float;True;Property;_NoiseMap;Noise Map;3;0;Create;True;0;0;False;0;bdbe94d7623ec3940947b62544306f1c;bdbe94d7623ec3940947b62544306f1c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-176,-80;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-208,272;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Magic3000/VertexMove;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;False;False;False;False;Back;2;False;1;7;False;-1;False;0;0;False;0;Custom;0.5;True;False;214748364;True;Overlay;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;4;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;12;0
WireConnection;10;1;11;2
WireConnection;18;0;12;0
WireConnection;18;1;10;0
WireConnection;9;1;18;0
WireConnection;8;0;9;0
WireConnection;7;0;8;0
WireConnection;7;2;18;0
WireConnection;6;1;7;0
WireConnection;20;0;19;0
WireConnection;20;1;1;0
WireConnection;2;0;6;0
WireConnection;2;1;3;0
WireConnection;2;2;4;0
WireConnection;0;2;20;0
WireConnection;0;11;2;0
ASEEND*/
//CHKSM=FAD16BC9753DAF7A8085D2193657C56BCD774E72