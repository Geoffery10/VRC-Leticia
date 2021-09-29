// Upgrade NOTE: upgraded instancing buffer 'NEK0ScreenCustomv1' to new syntax.

Shader "Custom/Multi-Shader/Neko Screen Shader+"
{
	Properties
	{
	
		[Header(___Light___)]
		_Float0("Light", Float) = 0

		[Space(1)]
		[Header(___GREYSCALE AND INVERT___)]
		[Toggle(_GREYSCALE_ON)] _Greyscale("Greyscale", Float) = 0
		[Toggle(_INVERT_ON)] _Invert("Invert", Float) = 0

		[Space(25)]
		[Header(___Screen Shake ___)]
		[Toggle(_SCREENSHAKE_ON)] _ScreenShake("Screen Shake", Float) = 0
		_Range("Range ", Range( 1 , 99)) = 1
		_speed("speed", Range( 0 , 99)) = 0

		[Space(1)]
		[Header(___FADE SCREEN___)]
		[Toggle]_FadeOn("Fade On", Float) = 0
		_FadeLight2("Fade Intensity", Range( 0 , 5)) = 0
		_Fadecolor("Fade color ", Range( -1 , 1)) = 0
		_Fadespeed("Fade speed", Range( -1 , 1)) = 0

		[Space(25)]
		[Header(___BLACK COLOR___)]
		[Toggle]_Backcoloron("Back color on", Float) = 0
		_BkLight("Bk Light", Range( -3 , 3)) = 0
		_BKcolor("BK color", Range( -1 , 1)) = 0
		_BkColor2("Bk Color", Color) = (1,1,1,0)

		[Space(18)]
		[Header(___OLD FILM___)]
		[Toggle]_OldFilm("Old Film", Float) = 0
		[Toggle]_GreyscaleFilm("Greyscale Film", Float) = 0
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Texture0("Texture 0", 2D) = "white" {}
		_Noissize("Nois size", Int) = 0
		_Speed("Speed", Int) = 0

		[Space(25)]
		[Header(___WAVE SCREEN___)]
		[Toggle]_WaveOn("Wave On", Float) = 0
		_WaveHigh("Wave High", Range( 0 , 0.5)) = 0
		_WaveSpeed("Wave Speed", Range( 0 , 50)) = 0

		[Space(25)]
		[Header(___RGB SCREEN___)]
		[Toggle]_RGBShakeOn("RGB Shake On", Float) = 0

		_RgbBlue("Blue ", Range( 0 , 5)) = 0
		_RGBRed("Red", Range( 0 , 5)) = 0
		_RgbGreen("Green", Range( 0 , 5)) = 0
		[Space(14)]
		[Toggle(_AUTOSHAKEONOFF_ON)] _AutoShakeOnOFF("Auto Shake  On/OFF", Float) = 0
		_Blue2("Blue 2", Range( -5 , 5)) = 0
		_Red2("Red 2", Range( -5 , 5)) = 0
		_Green2("Green 2", Range( -5 , 5)) = 0
		_Red3("Red 3", Range( -5 , 5)) = 0
		_Green3("Green 3", Range( -5 , 5)) = 0





		[Space(25)]
		[Header(___LSD Screen___)]
		[Toggle]_RainbowOn("LSD On", Float) = 0
		_StartRainbow("LSD Light", Range( -1 , 1)) = 0
		_RainbowMove("LSD Pulse", Range( -1 , 1)) = 0

		[Space(25)]
		[Header(___BACKGROUND___)]
		[Toggle]_Backcolor("BACKGROUND ON", Float) = 0
		_Background("Background ", Range( 0 , 50)) = 0

		[Space(25)]
		[Header(___TRUE IMIGE___)]
		[Toggle]_TrueImige("True Imige", Float) = 0
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_Alpha("Alpha", Int) = -2

	

	}

	SubShader
	{
		Tags{ "RenderType" = "Overlay"  "Queue" = "Transparent+5000" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		ZTest Always
		Offset  5 , 20
		GrabPass{ }
		GrabPass{ "_GrabDaddy" }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma shader_feature _GREYSCALE_ON
		#pragma shader_feature _INVERT_ON
		#pragma shader_feature _SCREENSHAKE_ON
		#pragma shader_feature _AUTOSHAKEONOFF_ON
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
		};

		uniform sampler2D _GrabTexture;
		uniform float _speed;
		uniform float _Range;
		uniform float _Float0;
		uniform float _Backcoloron;
		uniform float _BKcolor;
		uniform half4 _BkColor2;
		uniform float _WaveOn;
		uniform sampler2D _GrabDaddy;
		uniform float _WaveSpeed;
		uniform float _WaveHigh;
		uniform float _RGBShakeOn;
		uniform float _RgbGreen;
		uniform float _RGBRed;
		uniform float _RgbBlue;
		uniform float _Red2;
		uniform float _Red3;
		uniform float _Green2;
		uniform float _Green3;
		uniform float _Blue2;
		uniform float _RainbowOn;
		uniform float _StartRainbow;
		uniform float _RainbowMove;
		uniform float _Backcolor;
		uniform float _Background;
		uniform float _FadeOn;
		uniform float _Fadespeed;
		uniform float _FadeLight2;
		uniform float _Fadecolor;
		uniform float _screenColor;
		uniform float _Lightcolor;
		uniform float4 _Color0;
		uniform float _OldFilm;
		uniform float _GreyscaleFilm;
		uniform sampler2D _TextureSample1;
		uniform sampler2D _Texture0;
		uniform int _Noissize;
		uniform int _Speed;
		uniform float _TrueImige;
		uniform sampler2D _TextureSample2;
		uniform int _Alpha;

		UNITY_INSTANCING_BUFFER_START(NEK0ScreenCustomv1)
			UNITY_DEFINE_INSTANCED_PROP(float, _BkLight)
#define _BkLight_arr NEK0ScreenCustomv1
		UNITY_INSTANCING_BUFFER_END(NEK0ScreenCustomv1)


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


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
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
			float mulTime273 = _Time.y * _speed;
			#ifdef _SCREENSHAKE_ON
				float4 staticSwitch262 = ( ( sin( ( mulTime273 + 0.0 ) ) / _Range ) + ase_grabScreenPosNorm );
			#else
				float4 staticSwitch262 = ase_grabScreenPosNorm;
			#endif
			float4 screenColor208 = tex2D( _GrabTexture, staticSwitch262.xy );
			#ifdef _INVERT_ON
				float4 staticSwitch228 = ( 1.0 - screenColor208 );
			#else
				float4 staticSwitch228 = screenColor208;
			#endif
			float4 lerpResult211 = lerp( staticSwitch228 , float4( 0,0,0,0 ) , _Float0);
			float4 appendResult214 = (float4(lerpResult211));
			float4 lerpResult26 = lerp( ase_grabScreenPosNorm , ( _BKcolor + _BkColor2 ) , 1.0);
			float4 screenColor38 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float _BkLight_Instance = UNITY_ACCESS_INSTANCED_PROP(_BkLight_arr, _BkLight);
			float4 temp_cast_4 = (_BkLight_Instance).xxxx;
			float3 break3_g22 = ase_grabScreenPosNorm.xyz;
			float mulTime4_g22 = _Time.y * 2.0;
			float3 appendResult11_g22 = (float3(break3_g22.x , ( break3_g22.y + ( sin( ( ( break3_g22.x * _WaveSpeed ) + mulTime4_g22 ) ) * _WaveHigh ) ) , break3_g22.z));
			float4 screenColor1 = tex2D( _GrabDaddy, appendResult11_g22.xy );
			float mulTime47 = _Time.y * _RgbGreen;
			float4 screenColor50 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + ( sin( mulTime47 ) / 50.0 ) ).xy );
			float4 lerpResult45 = lerp( screenColor50 , float4( 0,0,0,0 ) , 0.0);
			float mulTime53 = _Time.y * _RGBRed;
			float4 screenColor55 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + ( sin( mulTime53 ) / 50.0 ) ).xy );
			float4 lerpResult56 = lerp( screenColor55 , float4( 0,0,0,0 ) , 0.0);
			float mulTime61 = _Time.y * _RgbBlue;
			float4 screenColor63 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + ( sin( mulTime61 ) / 50.0 ) ).xy );
			float lerpResult64 = lerp( screenColor63.b , 0.0 , 0.0);
			float4 appendResult44 = (float4(lerpResult45.r , lerpResult56.r , lerpResult64 , 0.0));
			float4 appendResult240 = (float4(_Red2 , _Red3 , 0.0 , 0.0));
			float4 screenColor229 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + appendResult240 ).xy );
			float4 appendResult234 = (float4(_Green2 , _Green3 , 0.0 , 0.0));
			float4 screenColor237 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + appendResult234 ).xy );
			float4 appendResult239 = (float4(_Blue2 , 0.0 , 0.0 , 0.0));
			float4 screenColor232 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + appendResult239 ).xy );
			float4 appendResult231 = (float4(screenColor229.r , screenColor237.g , screenColor232.b , 0.0));
			#ifdef _AUTOSHAKEONOFF_ON
				float4 staticSwitch248 = appendResult231;
			#else
				float4 staticSwitch248 = appendResult44;
			#endif
			float4 screenColor140 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float3 hsvTorgb3_g19 = HSVToRGB( float3(degrees( screenColor140 ).r,1.0,1.0) );
			float3 break3_g23 = hsvTorgb3_g19;
			float mulTime4_g23 = _Time.y * 2.0;
			float3 appendResult11_g23 = (float3(break3_g23.x , ( break3_g23.y + ( sin( ( ( break3_g23.x * 0.0 ) + mulTime4_g23 ) ) * _RainbowMove ) ) , break3_g23.z));
			float4 screenColor176 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float3 desaturateInitialColor174 = screenColor176.rgb;
			float desaturateDot174 = dot( desaturateInitialColor174, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar174 = lerp( desaturateInitialColor174, desaturateDot174.xxx, _Background );
			float mulTime43 = _Time.y * _Fadespeed;
			float3 hsvTorgb37 = HSVToRGB( float3(mulTime43,_FadeLight2,_Fadecolor) );
			float4 screenColor32 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float4 blendOpSrc36 = float4( hsvTorgb37 , 0.0 );
			float4 blendOpDest36 = screenColor32;
			float4 screenColor255 = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD( ase_grabScreenPosNorm ) );
			float2 temp_cast_30 = _Noissize;
			float2 temp_output_1_0_g18 = temp_cast_30;
			float2 appendResult10_g18 = (float2(( (temp_output_1_0_g18).x * i.uv_texcoord.x ) , ( i.uv_texcoord.y * (temp_output_1_0_g18).y )));
			float2 temp_output_11_0_g18 = float2( 0,0 );
			float2 panner18_g18 = ( ( (temp_output_11_0_g18).x * _Time.y ) * float2( 1,0 ) + i.uv_texcoord);
			float2 panner19_g18 = ( ( _Time.y * (temp_output_11_0_g18).y ) * float2( 0,1 ) + i.uv_texcoord);
			float2 appendResult24_g18 = (float2((panner18_g18).x , (panner19_g18).y));
			float2 temp_cast_31 = _Speed;
			float2 temp_output_47_0_g18 = temp_cast_31;
			float2 temp_output_31_0_g18 = ( ase_grabScreenPosNorm.xy - float2( 1,1 ) );
			float2 appendResult39_g18 = (float2(frac( ( atan2( (temp_output_31_0_g18).x , (temp_output_31_0_g18).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g18 )));
			float2 panner54_g18 = ( ( (temp_output_47_0_g18).x * _Time.y ) * float2( 1,0 ) + appendResult39_g18);
			float2 panner55_g18 = ( ( _Time.y * (temp_output_47_0_g18).y ) * float2( 0,1 ) + appendResult39_g18);
			float2 appendResult58_g18 = (float2((panner54_g18).x , (panner55_g18).y));
			float4 tex2DNode282 = tex2D( _TextureSample1, ( ( (tex2D( _Texture0, ( appendResult10_g18 + appendResult24_g18 ) )).rg * 1.0 ) + ( float2( 1,1 ) * appendResult58_g18 ) ) );
			float4 screenColor283 = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD( ase_grabScreenPos ) );
			float4 lerpResult284 = lerp( tex2DNode282 , screenColor283 , tex2DNode282.a);
			float grayscale285 = (lerpResult284.rgb.r + lerpResult284.rgb.g + lerpResult284.rgb.b) / 3;
			float4 temp_cast_34 = (grayscale285).xxxx;
			float4 tex2DNode289 = tex2D( _TextureSample2, ase_grabScreenPosNorm.xy );
			float4 screenColor290 = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD( ase_grabScreenPos ) );
			float4 lerpResult291 = lerp( tex2DNode289 , screenColor290 , ( tex2DNode289.a + _Alpha ));
			float4 temp_output_294_0 = ( ( appendResult214 + float4( 0,0,0,0 ) + lerp(float4( 0,0,0,0 ),( ( 1.0 - lerpResult26 ) + ( 1.0 - pow( screenColor38 , temp_cast_4 ) ) ),_Backcoloron) + lerp(float4( 0,0,0,0 ),screenColor1,_WaveOn) + lerp(float4( 0,0,0,0 ),staticSwitch248,_RGBShakeOn) + lerp(float4( 0,0,0,0 ),CalculateContrast(_StartRainbow,float4( appendResult11_g23 , 0.0 )),_RainbowOn) + float4( lerp(float3( 0,0,0 ),desaturateVar174,_Backcolor) , 0.0 ) + lerp(float4( 0,0,0,0 ),( saturate( (( blendOpDest36 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest36 - 0.5 ) ) * ( 1.0 - blendOpSrc36 ) ) : ( 2.0 * blendOpDest36 * blendOpSrc36 ) ) )),_FadeOn) + lerp(float4( 0,0,0,0 ),( screenColor255 + ( screenColor255 + ( _Lightcolor + _Color0 ) ) ),_screenColor) + lerp(float4( 0,0,0,0 ),lerp(temp_cast_34,lerpResult284,_GreyscaleFilm),_OldFilm) ) + lerp(float4( 0,0,0,0 ),lerpResult291,_TrueImige) );
			float4 temp_cast_45 = (grayscale285).xxxx;
			float grayscale198 = (temp_output_294_0.xyz.r + temp_output_294_0.xyz.g + temp_output_294_0.xyz.b) / 3;
			float4 temp_cast_49 = (grayscale198).xxxx;
			#ifdef _GREYSCALE_ON
				float4 staticSwitch200 = temp_cast_49;
			#else
				float4 staticSwitch200 = temp_output_294_0;
			#endif
			o.Emission = staticSwitch200.xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}