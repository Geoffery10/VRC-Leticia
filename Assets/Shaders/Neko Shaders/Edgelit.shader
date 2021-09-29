Shader "Custom/Screen/Edgelit"
{
	Properties
	{

		_EdgeRange("Edge Range ", Range( 0 , 5)) = 0
		[HDR][Gamma]_Color("Color ", Color) = (3,0,0,0)

		[Space(12)]
		_Divide("Divide", Int) = 8
		[Space(5)]

		[Toggle]_ToggleEdge6("Toggle Edge 1", Float) = 0
		[Toggle]_ToggleEdge5("Toggle Edge 2", Float) = 0
		[Toggle]_ToggleEdge7("Toggle Edge 3", Float) = 0
		[Toggle]_ToggleEdge2("Toggle Edge 4", Float) = 0
		[Toggle]_ToggleEdge1("Toggle Edge 5", Float) = 0
		[Toggle]_ToggleEdge4("Toggle Edge 6", Float) = 0
		[Toggle]_ToggleEdge3("Toggle Edge 7", Float) = 0

		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Overlay"  "Queue" = "Overlay+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		ZTest Always
		GrabPass{ }
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 screenPos;
		};

		uniform float _ToggleEdge1;
		uniform sampler2D _GrabTexture;
		uniform float4 _Color;
		uniform float _EdgeRange;
		uniform float _ToggleEdge2;
		uniform float _ToggleEdge3;
		uniform float _ToggleEdge4;
		uniform float _ToggleEdge5;
		uniform float _ToggleEdge6;
		uniform float _ToggleEdge7;
		uniform int _Divide;


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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor286 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float4 screenColor285 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float temp_output_380_0 = ( _EdgeRange / 800.0 );
			float4 appendResult123 = (float4(temp_output_380_0 , temp_output_380_0 , 0.0 , 0.0));
			float4 screenColor287 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + appendResult123 ).xy );
			float4 screenColor274 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float4 appendResult132 = (float4(( temp_output_380_0 * -1.0 ) , ( temp_output_380_0 * -1.0 ) , 0.0 , 0.0));
			float4 screenColor276 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + appendResult132 ).xy );
			float4 screenColor242 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float4 screenColor241 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float4 appendResult163 = (float4(temp_output_380_0 , 0.0 , 0.0 , 0.0));
			float4 screenColor243 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + appendResult163 ).xy );
			float4 screenColor231 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float4 screenColor230 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float4 appendResult161 = (float4(( temp_output_380_0 * -1.0 ) , 0.0 , 0.0 , 0.0));
			float4 screenColor232 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + appendResult161 ).xy );
			float4 screenColor220 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float4 screenColor219 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float4 appendResult179 = (float4(0.0 , temp_output_380_0 , 0.0 , 0.0));
			float4 screenColor221 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + appendResult179 ).xy );
			float4 screenColor201 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float4 screenColor206 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float4 appendResult177 = (float4(0.0 , ( temp_output_380_0 * -1.0 ) , 0.0 , 0.0));
			float4 screenColor211 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + appendResult177 ).xy );
			float4 screenColor253 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float4 screenColor252 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float4 appendResult149 = (float4(temp_output_380_0 , ( temp_output_380_0 * -1.0 ) , 0.0 , 0.0));
			float4 screenColor254 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + appendResult149 ).xy );
			float4 screenColor264 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float4 screenColor263 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float4 appendResult146 = (float4(( temp_output_380_0 * -1.0 ) , temp_output_380_0 , 0.0 , 0.0));
			float4 screenColor265 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + appendResult146 ).xy );
			o.Emission = ( ( lerp(( ( screenColor286 - ( screenColor285 * _Color ) ) + ( _Color * screenColor287 ) ),float4( 0,0,0,0 ),_ToggleEdge1) + lerp(( ( screenColor285 - ( screenColor274 * _Color ) ) + ( _Color * screenColor276 ) ),float4( 0,0,0,0 ),_ToggleEdge2) + lerp(( ( screenColor242 - ( screenColor241 * _Color ) ) + ( _Color * screenColor243 ) ),float4( 0,0,0,0 ),_ToggleEdge3) + lerp(( ( screenColor231 - ( screenColor230 * _Color ) ) + ( _Color * screenColor232 ) ),float4( 0,0,0,0 ),_ToggleEdge4) + lerp(( ( screenColor220 - ( screenColor219 * _Color ) ) + ( _Color * screenColor221 ) ),float4( 0,0,0,0 ),_ToggleEdge5) + lerp(( ( screenColor201 - ( screenColor206 * _Color ) ) + ( _Color * screenColor211 ) ),float4( 0,0,0,0 ),_ToggleEdge6) + lerp(( ( screenColor253 - ( screenColor252 * _Color ) ) + ( _Color * screenColor254 ) ),float4( 0,0,0,0 ),_ToggleEdge7) + ( ( screenColor264 - ( screenColor263 * _Color ) ) + ( _Color * screenColor265 ) ) ) / _Divide ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}