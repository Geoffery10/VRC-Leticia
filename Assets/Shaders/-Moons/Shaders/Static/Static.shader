// Static shader with all features included.

// Discord: moons#1337

Shader "Custom/Misc/Static Shader"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_Cullmode("Cull mode", Float) = 2
		[Header(Texture)]
		_Texture("Texture", 2D) = "white" {}
		_Texturebrightness("Texture brightness", Float) = 1
		_Texturesaturation("Texture saturation", Range( 0 , 1)) = 1
		[Toggle]_Cutouttexture("Cutout texture", Float) = 0
		_Texturealphacutoff("Texture alpha cutoff", Range( 0 , 1)) = 0.5
		[Header(Static)]
		_Staticcolour1("Static colour 1", Color) = (0,0,0,1)
		_Staticcolour2("Static colour 2", Color) = (1,1,1,1)
		_StaticscaleX("Static scale (X)", Float) = 1
		_StaticscaleY("Static scale (Y)", Float) = 1
		_Staticrotationspeed("Static rotation speed", Float) = 1
		[Toggle]_Screenspacestatic("Screenspace static", Float) = 0
		[Header(Scanlines)]
		[Toggle]_Scanlines("Scanlines", Float) = 0
		[Enum(X,0,Y,1,Z,2)]_Scanlineaxis("Scanline axis", Float) = 1
		_Scanlinefrequency("Scanline frequency", Float) = 1
		_Scanlineintensity("Scanline intensity", Range( 0 , 1)) = 0.5
		_Scanlinespeed("Scanline speed", Float) = 1
		[Header(Rim light)]
		[Toggle]_Rimlight("Rim light", Float) = 0
		_Rimcolour("Rim colour", Color) = (1,1,1,1)
		_Rimbrightness("Rim brightness", Float) = 1
		_Rimscale("Rim scale", Float) = 1
		_Rimpower("Rim power", Float) = 1
		[Toggle]_Rainbowrim("Rainbow rim", Float) = 0
		_Rimcolourspeed("Rim colour speed", Float) = 1
		[Header(Vertex offset)]
		[Enum(None,0,Offset,1,Deform,2)]_Vertexoffsetstyle("Vertex offset style", Float) = 0
		_VertexoffsetX("Vertex offset (X)", Float) = 0
		_VertexoffsetY("Vertex offset (Y)", Float) = 0
		_VertexoffsetZ("Vertex offset (Z)", Float) = 0
		[Toggle]_Vertexoffsetpulse("Vertex offset pulse", Float) = 0
		_Vertexoffsetpulsespeed("Vertex offset pulse speed", Float) = 1
		_Vertexdeformfrequency("Vertex deform frequency", Float) = 1
		_Vertexdeformspeed("Vertex deform speed", Float) = 1
		[Header(Opacity)]
		_Opacity("Opacity", Range( 0 , 1)) = 1
		[Toggle]_Distancefade("Distance fade", Float) = 0
		[Toggle]_Reversedistancefade("Reverse distance fade", Float) = 0
		_Startfade("Start fade", Float) = 0
		_Endfade("End fade", Float) = 10
		[Toggle]_Usecustomdithertexture("Use custom dither texture", Float) = 0
		[NoScaleOffset]_Dithertexture("Dither texture", 2D) = "white" {}
		[Header(Mirror)]
		[Enum(None,0,Hide in mirror,1,Only show in mirror,2)]_Hidesettings("Hide settings", Float) = 0
		[HideInInspector]_Color("Fallback colour", Color) = (0,0,0,1)
		[HideInInspector]_Maskclip("Mask clip", Float) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull [_Cullmode]
		Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float3 worldNormal;
			float4 screenPosition;
		};

		uniform float _Vertexoffsetstyle;
		uniform float _StaticscaleX;
		uniform float _StaticscaleY;
		uniform float _Screenspacestatic;
		uniform float _Staticrotationspeed;
		uniform float _Vertexoffsetpulse;
		uniform float _Vertexoffsetpulsespeed;
		uniform float _VertexoffsetX;
		uniform float _VertexoffsetY;
		uniform float _VertexoffsetZ;
		uniform float _Vertexdeformfrequency;
		uniform float _Vertexdeformspeed;
		uniform float4 _Staticcolour1;
		uniform float4 _Staticcolour2;
		uniform float _Texturebrightness;
		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;
		uniform float _Texturesaturation;
		uniform float _Rimlight;
		uniform float _Rimbrightness;
		uniform float _Rainbowrim;
		uniform float4 _Rimcolour;
		uniform float _Rimcolourspeed;
		uniform float _Rimscale;
		uniform float _Rimpower;
		uniform float _Cullmode;
		uniform float4 _Color;
		uniform float _Hidesettings;
		uniform float _Cutouttexture;
		uniform float _Texturealphacutoff;
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
		uniform float _Usecustomdithertexture;
		uniform sampler2D _Dithertexture;
		uniform float4 _Dithertexture_TexelSize;
		uniform float _Maskclip;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


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


		inline float DitherNoiseTex( float4 screenPos, sampler2D noiseTexture, float4 noiseTexelSize )
		{
			float dither = tex2Dlod( noiseTexture, float4( screenPos.xy * _ScreenParams.xy * noiseTexelSize.xy, 0, 0 ) ).g;
			float ditherRate = noiseTexelSize.x * noiseTexelSize.y;
			dither = ( 1 - ditherRate ) * dither + ditherRate;
			return dither;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 temp_cast_0 = (0.0).xxx;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float2 appendResult457 = (float2(_StaticscaleX , _StaticscaleY));
			float2 uv_TexCoord1 = v.texcoord.xy * appendResult457;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 worldToView2_g1 = mul( UNITY_MATRIX_V, float4( _WorldSpaceCameraPos, 1 ) ).xyz;
			float3 worldToView5_g1 = mul( UNITY_MATRIX_V, float4( ( ase_worldPos - worldToView2_g1 ), 1 ) ).xyz;
			float2 appendResult6_g1 = (float2(worldToView5_g1.x , worldToView5_g1.y));
			float2 break11_g1 = ( appendResult6_g1 / worldToView5_g1.z );
			float2 appendResult15_g1 = (float2(( ( _ScreenParams.z / _ScreenParams.w ) * break11_g1.x * ( 1.0 - 0.0 ) ) , ( break11_g1.y * 2.0 * ( 1.0 - 0.0 ) )));
			float2 temp_cast_1 = (-1.0).xx;
			float2 temp_cast_2 = (0.5).xx;
			float2 temp_cast_3 = (1.1).xx;
			float2 temp_cast_4 = (0.2).xx;
			float2 temp_output_20_0_g1 = (temp_cast_3 + (appendResult15_g1 - temp_cast_1) * (temp_cast_4 - temp_cast_3) / (temp_cast_2 - temp_cast_1));
			float2 temp_cast_5 = (0.5).xx;
			float3 objToWorld467 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float temp_output_469_0 = distance( _WorldSpaceCameraPos , objToWorld467 );
			float2 appendResult470 = (float2(temp_output_469_0 , temp_output_469_0));
			float2 lerpResult462 = lerp( uv_TexCoord1 , ( ( appendResult457 * ( temp_output_20_0_g1 - temp_cast_5 ) * appendResult470 ) + 0.5 ) , _Screenspacestatic);
			float mulTime402 = _Time.y * _Staticrotationspeed;
			float cos401 = cos( mulTime402 );
			float sin401 = sin( mulTime402 );
			float2 rotator401 = mul( lerpResult462 - float2( 0,0 ) , float2x2( cos401 , -sin401 , sin401 , cos401 )) + float2( 0,0 );
			float2 break445 = lerpResult462;
			float2 temp_output_414_0 = ( rotator401 + 0.2127 + ( break445.x * break445.y * 0.3713 ) );
			float2 break424 = ( sin( ( temp_output_414_0 * 489.123 ) ) * 4.789 );
			float noise58 = frac( ( ( 1.0 + temp_output_414_0.x ) * break424.x * break424.y ) );
			float vertex_offset_speed146 = (0.0 + (sin( ( _Time.y * _Vertexoffsetpulsespeed ) ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0));
			float temp_output_136_0 = ( noise58 * lerp(1.0,vertex_offset_speed146,_Vertexoffsetpulse) );
			float3 appendResult119 = (float3(( ase_vertex3Pos.x * (0.0 + (temp_output_136_0 - 0.0) * (_VertexoffsetX - 0.0) / (1.0 - 0.0)) ) , ( ase_vertex3Pos.y * (0.0 + (temp_output_136_0 - 0.0) * (_VertexoffsetY - 0.0) / (1.0 - 0.0)) ) , ( ase_vertex3Pos.z * (0.0 + (temp_output_136_0 - 0.0) * (_VertexoffsetZ - 0.0) / (1.0 - 0.0)) )));
			float3 vertex_offset112 = appendResult119;
			float temp_output_106_0 = ( ( _Vertexdeformfrequency * ase_vertex3Pos.y ) + ( _Time.y * _Vertexdeformspeed ) );
			float vertex_deform128 = ( ( cos( temp_output_106_0 ) * 0.015 ) + ( sin( temp_output_106_0 ) * 0.005 ) );
			float3 temp_cast_6 = (vertex_deform128).xxx;
			float3 ifLocalVar123 = 0;
			if( 1.0 > _Vertexoffsetstyle )
				ifLocalVar123 = temp_cast_0;
			else if( 1.0 == _Vertexoffsetstyle )
				ifLocalVar123 = vertex_offset112;
			else if( 1.0 < _Vertexoffsetstyle )
				ifLocalVar123 = temp_cast_6;
			float3 vertex_final121 = ifLocalVar123;
			v.vertex.xyz += vertex_final121;
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			o.screenPosition = ase_screenPos;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult457 = (float2(_StaticscaleX , _StaticscaleY));
			float2 uv_TexCoord1 = i.uv_texcoord * appendResult457;
			float3 ase_worldPos = i.worldPos;
			float3 worldToView2_g1 = mul( UNITY_MATRIX_V, float4( _WorldSpaceCameraPos, 1 ) ).xyz;
			float3 worldToView5_g1 = mul( UNITY_MATRIX_V, float4( ( ase_worldPos - worldToView2_g1 ), 1 ) ).xyz;
			float2 appendResult6_g1 = (float2(worldToView5_g1.x , worldToView5_g1.y));
			float2 break11_g1 = ( appendResult6_g1 / worldToView5_g1.z );
			float2 appendResult15_g1 = (float2(( ( _ScreenParams.z / _ScreenParams.w ) * break11_g1.x * ( 1.0 - 0.0 ) ) , ( break11_g1.y * 2.0 * ( 1.0 - 0.0 ) )));
			float2 temp_cast_0 = (-1.0).xx;
			float2 temp_cast_1 = (0.5).xx;
			float2 temp_cast_2 = (1.1).xx;
			float2 temp_cast_3 = (0.2).xx;
			float2 temp_output_20_0_g1 = (temp_cast_2 + (appendResult15_g1 - temp_cast_0) * (temp_cast_3 - temp_cast_2) / (temp_cast_1 - temp_cast_0));
			float2 temp_cast_4 = (0.5).xx;
			float3 objToWorld467 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float temp_output_469_0 = distance( _WorldSpaceCameraPos , objToWorld467 );
			float2 appendResult470 = (float2(temp_output_469_0 , temp_output_469_0));
			float2 lerpResult462 = lerp( uv_TexCoord1 , ( ( appendResult457 * ( temp_output_20_0_g1 - temp_cast_4 ) * appendResult470 ) + 0.5 ) , _Screenspacestatic);
			float mulTime402 = _Time.y * _Staticrotationspeed;
			float cos401 = cos( mulTime402 );
			float sin401 = sin( mulTime402 );
			float2 rotator401 = mul( lerpResult462 - float2( 0,0 ) , float2x2( cos401 , -sin401 , sin401 , cos401 )) + float2( 0,0 );
			float2 break445 = lerpResult462;
			float2 temp_output_414_0 = ( rotator401 + 0.2127 + ( break445.x * break445.y * 0.3713 ) );
			float2 break424 = ( sin( ( temp_output_414_0 * 489.123 ) ) * 4.789 );
			float noise58 = frac( ( ( 1.0 + temp_output_414_0.x ) * break424.x * break424.y ) );
			float4 lerpResult80 = lerp( _Staticcolour1 , _Staticcolour2 , noise58);
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			float4 tex2DNode204 = tex2D( _Texture, uv_Texture );
			float3 desaturateInitialColor228 = ( _Texturebrightness * tex2DNode204 ).rgb;
			float desaturateDot228 = dot( desaturateInitialColor228, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar228 = lerp( desaturateInitialColor228, desaturateDot228.xxx, ( 1.0 - _Texturesaturation ) );
			float4 static82 = ( lerpResult80 * float4( desaturateVar228 , 0.0 ) );
			float4 temp_cast_7 = (0.0).xxxx;
			float mulTime240 = _Time.y * _Rimcolourspeed;
			float3 hsvTorgb244 = HSVToRGB( float3((0.0 + (sin( mulTime240 ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)),1.0,1.0) );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV85 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode85 = ( 0.0 + _Rimscale * pow( 1.0 - fresnelNdotV85, _Rimpower ) );
			float4 rim92 = lerp(temp_cast_7,( ( _Rimbrightness * lerp(_Rimcolour,float4( hsvTorgb244 , 0.0 ),_Rainbowrim) ) * fresnelNode85 ),_Rimlight);
			float localMirrorhidesettings409 = ( 0.0 );
			float Hide409 = _Hidesettings;
			bool isInMirror = (unity_CameraProjection[2][0] != 0.f || unity_CameraProjection[2][1] != 0.f);
			if (Hide409 == 1) {
			clip(!isInMirror - 1);
			} else if (Hide409 == 2) {
			clip(isInMirror - 1);
			}
			float localAlphacutout509 = ( 0.0 );
			float Cutout509 = _Cutouttexture;
			float tex_alpha516 = tex2DNode204.a;
			float Alpha509 = tex_alpha516;
			float Cutoff509 = _Texturealphacutoff;
			if (Cutout509 == 1) {
			if (Alpha509 < Cutoff509) {
			discard;
			}
			}
			float4 _217 = ( ( _Cullmode + _Color + localMirrorhidesettings409 + localAlphacutout509 ) * float4( 0,0,0,0 ) );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float ifLocalVar408 = 0;
			if( 1.0 > _Scanlineaxis )
				ifLocalVar408 = ase_vertex3Pos.x;
			else if( 1.0 == _Scanlineaxis )
				ifLocalVar408 = ase_vertex3Pos.y;
			else if( 1.0 < _Scanlineaxis )
				ifLocalVar408 = ase_vertex3Pos.z;
			float mulTime389 = _Time.y * _Scanlinespeed;
			float scanlines384 = lerp(1.0,( ( ( (0.0 + (_Scanlineintensity - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) * sin( ( ( ifLocalVar408 * max( _Scanlinefrequency , 0.0 ) ) + mulTime389 ) ) ) + 2.0 ) * 0.5 ),_Scanlines);
			float4 temp_cast_9 = (-10.0).xxxx;
			float4 temp_cast_10 = (10.0).xxxx;
			float4 clampResult246 = clamp( ( ( static82 + rim92 + _217 ) * scanlines384 ) , temp_cast_9 , temp_cast_10 );
			o.Emission = clampResult246.rgb;
			o.Alpha = 1;
			float lerpResult191 = lerp( (0.5 + (( ( 1.0 - _Opacity ) + 0.5 ) - 0.5) * (1.51 - 0.5) / (1.5 - 0.5)) , ( ( distance( ase_worldPos , _WorldSpaceCameraPos ) - ( max( _Startfade , 0.0 ) - 4.0 ) ) / max( ( _Endfade + 0.0001 ) , 0.0 ) ) , _Distancefade);
			float4 ase_screenPos = i.screenPosition;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 clipScreen176 = ase_screenPosNorm.xy * _ScreenParams.xy;
			float dither176 = Dither8x8Bayer( fmod(clipScreen176.x, 8), fmod(clipScreen176.y, 8) );
			float dither168 = DitherNoiseTex( ase_screenPosNorm, _Dithertexture, _Dithertexture_TexelSize);
			float lerpResult164 = lerp( 1.0 , 0.0 , saturate( ( lerpResult191 - lerp(dither176,dither168,_Usecustomdithertexture) ) ));
			float opacity_mask173 = lerp(lerpResult164,( 1.0 - lerpResult164 ),_Reversedistancefade);
			clip( opacity_mask173 - _Maskclip );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows noshadow vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack2.xyzw = customInputData.screenPosition;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.screenPosition = IN.customPack2.xyzw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}