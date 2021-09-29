// This shader is used for static screen effects.
// I recommend that you use this shader on a sphere, as it has a distance disable feature, making the effect only visible while the user is inside the sphere. This feature won't work well on other shapes. 

// Discord: moons#1337

Shader "Custom/Screen/Static Shader (Dots)"
{
	Properties
	{
		[Header(Static)]
		_Staticcolour1("Static colour 1", Color) = (0,0,0,1)
		_Staticcolour2("Static colour 2", Color) = (1,1,1,1)
		_StaticscaleX("Static scale (X)", Float) = 1
		_StaticscaleY("Static scale (Y)", Float) = 1
		_Staticrotationspeed("Static rotation speed", Float) = 1
		[Header(Scanlines)]
		[Toggle]_Scanlines("Scanlines", Float) = 0
		[Enum(X,0,Y,1)]_Scanlineaxis("Scanline axis", Float) = 1
		_Scanlinefrequency("Scanline frequency", Float) = 1
		_Scanlineintensity("Scanline intensity", Range( 0 , 1)) = 0.5
		_Scanlinespeed("Scanline speed", Float) = 1
		[Header(Opacity)]
		_Opacity("Opacity", Range( 0 , 1)) = 1
		[Toggle]_Distancefade("Distance fade", Float) = 0
		[Toggle]_Reversedistancefade("Reverse distance fade", Float) = 0
		_Startfade("Start fade", Float) = 0
		_Endfade("End fade", Float) = 10
		[HideInInspector]_Color("Fallback colour", Color) = (0,0,0,1)
		[HideInInspector]_Maskclip("Mask clip", Float) = 0.5
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+2147481647" "IsEmissive" = "true"  }
		Cull Front
		ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float4 screenPosition;
		};

		uniform float4 _Staticcolour1;
		uniform float4 _Staticcolour2;
		uniform float _StaticscaleX;
		uniform float _StaticscaleY;
		uniform float _Staticrotationspeed;
		uniform float4 _Color;
		uniform float _Scanlines;
		uniform float _Scanlineintensity;
		uniform float _Scanlineaxis;
		uniform float _Scanlinefrequency;
		uniform float _Scanlinespeed;
		uniform float _Reversedistancefade;
		uniform float _Opacity;
		uniform float _Startfade;
		uniform float _Endfade;
		uniform float _Distancefade;
		uniform float _Maskclip;


		inline float Dither8x8Bayer( int x, int y )
		{
			const float dither[ 64 ] = {
				 1, 49, 13, 61,  4, 52, 16, 64,
				33, 17, 45, 29, 36, 20, 48, 32,
				 9, 57,  5, 53, 12, 60,  8, 56,
				41, 25, 37, 21, 44, 28, 40, 24,
				 3, 51, 15, 63,  2, 50, 14, 62,
				35, 19, 47, 31, 34, 18, 46, 30,
				11, 59,  7, 55, 10, 58,  6, 54,
				43, 27, 39, 23, 42, 26, 38, 22};
			int r = y * 8 + x;
			return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			o.screenPosition = ase_screenPos;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 worldToView2_g9 = mul( UNITY_MATRIX_V, float4( _WorldSpaceCameraPos, 1 ) ).xyz;
			float3 worldToView5_g9 = mul( UNITY_MATRIX_V, float4( ( ase_worldPos - worldToView2_g9 ), 1 ) ).xyz;
			float2 appendResult6_g9 = (float2(worldToView5_g9.x , worldToView5_g9.y));
			float2 break11_g9 = ( appendResult6_g9 / worldToView5_g9.z );
			float2 appendResult15_g9 = (float2(( ( _ScreenParams.z / _ScreenParams.w ) * break11_g9.x * ( 1.0 - 0.0 ) ) , ( break11_g9.y * 2.0 * ( 1.0 - 0.0 ) )));
			float2 temp_cast_0 = (-1.0).xx;
			float2 temp_cast_1 = (0.5).xx;
			float2 temp_cast_2 = (1.1).xx;
			float2 temp_cast_3 = (0.2).xx;
			float2 temp_output_20_0_g9 = (temp_cast_2 + (appendResult15_g9 - temp_cast_0) * (temp_cast_3 - temp_cast_2) / (temp_cast_1 - temp_cast_0));
			float2 temp_cast_4 = (0.5).xx;
			float2 appendResult305 = (float2(_StaticscaleX , _StaticscaleY));
			float3 objToWorld346 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float temp_output_347_0 = distance( _WorldSpaceCameraPos , objToWorld346 );
			float2 appendResult348 = (float2(temp_output_347_0 , temp_output_347_0));
			float2 temp_output_343_0 = ( ( ( temp_output_20_0_g9 - temp_cast_4 ) * appendResult305 * appendResult348 ) + 0.5 );
			float mulTime309 = _Time.y * _Staticrotationspeed;
			float cos311 = cos( mulTime309 );
			float sin311 = sin( mulTime309 );
			float2 rotator311 = mul( temp_output_343_0 - float2( 0,0 ) , float2x2( cos311 , -sin311 , sin311 , cos311 )) + float2( 0,0 );
			float2 temp_cast_5 = (0.5).xx;
			float2 break308 = temp_output_343_0;
			float2 temp_output_315_0 = ( rotator311 + 0.2127 + ( break308.x * break308.y * 0.3713 ) );
			float2 break323 = ( sin( ( temp_output_315_0 * 489.123 ) ) * 4.789 );
			float noise326 = frac( ( ( 1.0 + temp_output_315_0.x ) * break323.x * break323.y ) );
			float4 lerpResult335 = lerp( _Staticcolour1 , _Staticcolour2 , noise326);
			float4 static338 = lerpResult335;
			float localMirrorhidesettings301 = ( 0.0 );
			bool isInMirror = (unity_CameraProjection[2][0] != 0.f || unity_CameraProjection[2][1] != 0.f);
			clip(!isInMirror - 1);
			float4 _217 = ( ( _Color + localMirrorhidesettings301 ) * float4( 0,0,0,0 ) );
			float3 worldToView2_g10 = mul( UNITY_MATRIX_V, float4( _WorldSpaceCameraPos, 1 ) ).xyz;
			float3 worldToView5_g10 = mul( UNITY_MATRIX_V, float4( ( ase_worldPos - worldToView2_g10 ), 1 ) ).xyz;
			float2 appendResult6_g10 = (float2(worldToView5_g10.x , worldToView5_g10.y));
			float2 break11_g10 = ( appendResult6_g10 / worldToView5_g10.z );
			float2 appendResult15_g10 = (float2(( ( _ScreenParams.z / _ScreenParams.w ) * break11_g10.x * ( 1.0 - 0.0 ) ) , ( break11_g10.y * 2.0 * ( 1.0 - 0.0 ) )));
			float2 temp_cast_6 = (-1.0).xx;
			float2 temp_cast_7 = (0.5).xx;
			float2 temp_cast_8 = (1.1).xx;
			float2 temp_cast_9 = (0.2).xx;
			float2 temp_output_20_0_g10 = (temp_cast_8 + (appendResult15_g10 - temp_cast_6) * (temp_cast_9 - temp_cast_8) / (temp_cast_7 - temp_cast_6));
			float2 break31_g10 = temp_output_20_0_g10;
			float lerpResult298 = lerp( break31_g10.x , break31_g10.y , _Scanlineaxis);
			float mulTime277 = _Time.y * _Scanlinespeed;
			float scanlines289 = lerp(1.0,( ( ( (0.0 + (_Scanlineintensity - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) * sin( ( ( lerpResult298 * max( _Scanlinefrequency , 0.0 ) ) + mulTime277 ) ) ) + 2.0 ) * 0.5 ),_Scanlines);
			float4 temp_cast_10 = (-10.0).xxxx;
			float4 temp_cast_11 = (10.0).xxxx;
			float4 clampResult246 = clamp( ( ( static338 + _217 ) * scanlines289 ) , temp_cast_10 , temp_cast_11 );
			o.Emission = clampResult246.rgb;
			o.Alpha = 1;
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float3 objToWorld251 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float lerpResult191 = lerp( (0.5 + (( ( 1.0 - _Opacity ) + 0.5 ) - 0.5) * (1.51 - 0.5) / (1.5 - 0.5)) , ( ( distance( ase_worldPos , _WorldSpaceCameraPos ) - ( max( _Startfade , 0.0 ) - 4.0 ) ) / max( ( _Endfade + 0.0001 ) , 0.0 ) ) , _Distancefade);
			float4 ase_screenPos = i.screenPosition;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 clipScreen176 = ase_screenPosNorm.xy * _ScreenParams.xy;
			float dither176 = Dither8x8Bayer( fmod(clipScreen176.x, 8), fmod(clipScreen176.y, 8) );
			float lerpResult164 = lerp( 1.0 , 0.0 , saturate( ( lerpResult191 - dither176 ) ));
			float ifLocalVar257 = 0;
			if( ( ase_objectScale.x / 2.0 ) <= length( distance( _WorldSpaceCameraPos , objToWorld251 ) ) )
				ifLocalVar257 = 0.0;
			else
				ifLocalVar257 = lerp(lerpResult164,( 1.0 - lerpResult164 ),_Reversedistancefade);
			float opacity_mask173 = ifLocalVar257;
			clip( opacity_mask173 - _Maskclip );
		}

		ENDCG
	}
}