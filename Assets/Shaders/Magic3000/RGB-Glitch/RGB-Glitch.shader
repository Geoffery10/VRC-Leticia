//Converted from shadertoy https://www.shadertoy.com/view/4dXBW2 and modified by Magic3000. Thanks for help Doppelganger and Leviant.
Shader "Custom/Screen/Glitch Shader"
{

	Properties
	{
		_NoiseTex("Noise Texture", 2D) = "White" {}
		NUM_SAMPLES("Samples (iterations (screen colors count))", int) = 20
		//[MaterialToggle]_rgbSplit("RGB-Split", Float) = 1
		_rgbSplit("Shifting mode", Range(0, 1)) = 1
		[KeywordEnum(Red_to_Blue, Blue_to_Red, Pink_to_Green, Green_to_Pink)] _ColorSwitch("Switch Color", Int) = 1
		_GlitchSpeed("Glitch Speed", Float) = 0.01
		_GlitchOffset("Glitch Offset", Float) = 0.025
		_saturateFactor("Saturate Factor", Float) = 1
		_screenMovesX("Screen Moves X", Range(0.95, 1.05)) = 1
		_screenMovesY("Screen Moves Y", Range(0.95, 1.05)) = 1
		[KeywordEnum(On, Off)] _screenMovesXoffset("X-Moving mode", Int) = 0
		[KeywordEnum(On, Off)] _screenMovesYoffset("Y-Moving mode", Int) = 1
		_rndGlitchFactor("Random Glitch Factor", Float) = -1.0
		_shiftXSpeed("Shift Speed X", Float) = 100
		_shiftXOffset("Shift Offset X", Float) = 0
		_shiftYSpeed("Shift Speed Y", Float) = 50
		_shiftYOffset("Shift Offset Y", Float) = 0.1
		_shiftTime("Shift Time", Float) = 100
		_vigOff("Vignette Offset", Float) = 0
		_stripes("Stripes Offset", Float) = 0
		_stripesCou("Stripes Count", Float) = 4
		[MaterialToggle]_stripesSin("Stripes Sin", Float) = 1
		_scanline("Scanline", Float) = 0
		_scanlineSpeed("Scanline Speed", Float) = 0
		[MaterialToggle]_scanlineSin("Scanline Sin", Float) = 0
		_noise("Noise", Float) = 1
		[MaterialToggle]_grayscaleToggle("Grayscale", Float) = 0
		_grayscaleOffset("Grayscale Offset", Float) = 3
		[HDR]_color("Color Add", Color) = (0, 0, 0, 1)
		[HDR]_colorMul("Color Multiply", Color) = (1, 1, 1, 1)
		_timeManual("Time", Float) = 100
		[MaterialToggle]_timeAuto("Use Global Time", Float) = 0
		_horzGlitch("Glitch Offset X", Float) = 1
		_vertGlitch("Glitch Offset Y", Float) = 10000
		[KeywordEnum(Default, Glitch, Blur, Manual)] _ShiftingMode("Shifting mode", Int) = 0
		_GlitchFactor("Glitch Factor (for Manual)", Range(0, 0.1)) = 0
		_blurOffset("Blur Offset (for Blur)", Range(0.9599999, 0.9999999)) = 0.9999999
		//[MaterialToggle]_r1LerpToggle("Toggle r1", Float) = 0
		_brightness("Brightness", Float) = 6.25
		_EffectsOffset("Effects Offset", Range (0, 1)) = 1
		_FadeStart("Min Distance", Float) = 4
		_FadeEnd("Max Distance", Float) = 5
		[Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull", Int) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Int) = 8
		//_VREffectsMultiply("VR Effects Multiply", Float) = 0.5
		//_DesktopEffectsMultiply("Desktop Effects Multiply", Float) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Overlay"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  }
		Cull[_Cull]
		ZTest[_ZTest]
		//Blend SrcAlpha OneMinusSrcAlpha
		GrabPass{ "_glitchShiftGrabScreenPos" }
		
		Pass
		{

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _SHIFTINGMODE_DEFAULT _SHIFTINGMODE_GLITCH _SHIFTINGMODE_BLUR _SHIFTINGMODE_MANUAL
			#pragma multi_compile _COLORSWITCH_RED_TO_BLUE _COLORSWITCH_BLUE_TO_RED _COLORSWITCH_PINK_TO_GREEN _COLORSWITCH_GREEN_TO_PINK
			#pragma multi_compile _SCREENMOVESXOFFSET_ON _SCREENMOVESXOFFSET_OFF
			#pragma multi_compile _SCREENMOVESYOFFSET_ON _SCREENMOVESYOFFSET_OFF
			#include "UnityCG.cginc"

			struct appdata{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			//Variables
			sampler2D _glitchShiftGrabScreenPos;
			sampler2D _NoiseTex;
			float _FadeStart;
			float _FadeEnd;
			float NUM_SAMPLES;
			float _GlitchOffset;
			float _brightness;
			float _GlitchSpeed;
			float _saturateFactor;
			float _shiftXOffset;
			float _shiftYOffset;	
			float _horzGlitch;
			float _vertGlitch;
			float3 _color;
			float3 _colorMul;
			float _screenMovesX;
			float _screenMovesY;
			//float _ColorSwitch;
			float _EffectsOffset;
			float _vigOff;
			float _stripes;
			float _stripesCou;	
			float _noise;
			float _grayscaleToggle;
			float _grayscaleOffset;
			float _timeManual;
			float _timeAuto;
			//float _VREffectsMultiply;
			//float _DesktopEffectsMultiply;
			float _shiftTime;
			float _rgbSplit;
			float _rndGlitchFactor;
			//float _r1LerpToggle;
			float _blurOffset;
			float _shiftXSpeed;
			float _shiftYSpeed;
			float _GlitchFactor;
			float _scanline;
			float _scanlineSpeed;
			float _scanlineSin;
			float _stripesSin;
			
			float vrcheck()
			{
				#if UNITY_SINGLE_PASS_STEREO
				float factor = 0.5;
				#else
				float factor = 1;
				#endif
				return factor;
			}
			
			float sat( float t )
			{
				return clamp( t, 0.0, 1.0 );
			}

			float2 sat( float2 t )
			{
				return clamp( t, 0.0, 1.0 );
			}

			//remaps inteval [a;b] to [0;1]
			float remap  ( float t, float a, float b )
			{
				return sat( (t - a) / (b - a) );
			}

			//note: /\ t=[0;0.5;1], y=[0;1;0]
			float linterp( float t )
			{
				return sat( 1.0 - abs( 2.0*t - 1.0 ) );
			}

			float3 spectrum_offset( float t )
			{
				float3 ret;
				float lo = step(t,0.5);
				float hi = 1.0-lo;
				float w = linterp( remap( t, 1.0/6.0, 5.0/6.0 ) );
				float neg_w = 1.0-w;
				//float3 lerpColor = lerp(float3(lo, 1.0, hi), float3(hi, 1.0, lo), _ColorSwitch);
				#ifdef _COLORSWITCH_RED_TO_BLUE
					float3 ColorSwitchDef = float3(hi, 1.0, lo);
				#elif defined(_COLORSWITCH_BLUE_TO_RED)
					float3 ColorSwitchDef = float3(lo, 1.0, hi);
				#elif defined(_COLORSWITCH_PINK_TO_GREEN)
					float3 ColorSwitchDef = float3((lo+hi)/2, 1.0, (lo+hi)/2);
				#elif defined(_COLORSWITCH_GREEN_TO_PINK)
					float3 ColorSwitchDef = float3(lo*2, 0.5, hi*2);	
				#endif
				#ifdef _COLORSWITCH_GREEN_TO_PINK
					ret = ColorSwitchDef * float3(w, neg_w, w);
				#else
					ret = ColorSwitchDef * float3(neg_w, w, neg_w);
				#endif
				return pow( ret, 1);
			}

			//note: [0;1]
			float rand( float2 n )
			{
				return frac(sin(dot(n.xy, float2(12.9898, 78.233)))* 41758.5453);
			}

			//note: [-1;1]
			/*float srand( float2 n )
			{
				return rand(n) * 2.0 - 1.0;
			}*/

			float mytrunc( float x, float num_levels )
			{
				return floor(x*num_levels) / num_levels;
			}
			
			float2 mytrunc( float2 x, float num_levels )
			{
				return floor(x*num_levels) / num_levels;
			}

			float noise(float2 p)
			{
				float s = tex2D(_NoiseTex,float2(1.,2.*cos(_Time.y))*_Time.y*8. + p*1.).x;
				s *= s;
				return s;
			}

			float ramp(float y, float start, float end)
			{
				float inside = step(start,y) - step(end,y);
				float fact = (y-start)/(end-start)*inside;
				return (1.-fact) * inside;
				
			}

			float stripes(float2 uv)
			{
				
				float noi = noise(uv*float2(0.5,1.) + float2(1.,3.));
				float stripesLerp = lerp((_Time.y + (_Time.y*0.63)), sin(_Time.y + sin(_Time.y*0.63)), _stripesSin);
				return ramp(fmod(uv.y*_stripesCou + _Time.y/2.+stripesLerp,1.),0.5,0.6)*noi;
			}
			
			v2f vert (float4 vertex:POSITION)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(vertex);
				o.uv = ComputeGrabScreenPos(o.vertex);
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				float vrcheckOffset = vrcheck();
				float4 transform = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
				float3 CamObjDist = length(float3(abs( ( _WorldSpaceCameraPos.x - transform.x ) ) , abs( ( _WorldSpaceCameraPos.y - transform.y ) ) , abs( ( _WorldSpaceCameraPos.z - transform.z ) )));
				float DistsanceFade = saturate( ( ( CamObjDist - _FadeEnd ) / ( _FadeStart - _FadeEnd ) ) );
				float2 uv = i.uv.xy/i.uv.w;

				float _time = lerp(_timeManual, _Time.y, _timeAuto);
				float time = fmod(_time*_GlitchSpeed, 32.0)/110.0; // + fmodelmat[0].x + fmodelmat[0].z;

				float gnm = sat( _GlitchOffset );
				float rnd0 = rand( mytrunc( float2(time, time), 6 ) );
				float r0 = sat((1.0-gnm)*0.7 + rnd0);
				float rnd1 = rand( float2(mytrunc( uv.x, _horzGlitch * r0 ), time) ); //horz
				
				//float r1 = 1.0f - sat( (1.0f-gnm)*0.5f + rnd1 );

				
				float r11 = 0.5 - 0.5 * gnm + rnd1;
				
				#ifdef _SHIFTINGMODE_DEFAULT
					
					float r1rand = 1.0 - max( 0.0, ((r11<1.0) ? r11 : _blurOffset) );
				#elif defined(_SHIFTINGMODE_GLITCH)
					float r1rand = 1.0 - max( 0.0, ((r11<1.0) ? r11 : r11) );
				#elif defined(_SHIFTINGMODE_BLUR)
					float r1rand = 1.0 - max( 0.0, ((r11<1.0) ? _blurOffset : _blurOffset) );
				#elif defined(_SHIFTINGMODE_MANUAL)
					float GlitcLerp = lerp(_blurOffset, r11, _GlitchFactor);
					float r1rand = 1.0 - max( 0.0, ((r11<1.0) ? GlitcLerp : GlitcLerp) );
				#endif
				
				//float r1rand = 1.0 - max( 0.0, ((r11<1.0) ? r11Rand : _blurOffset) );

				float r1 = r1rand;

				/*float r1Lerp = lerp(	0.5 - 0.5 * gnm + rnd1, 1.0f - sat( (1.0f-gnm)*0.5f + rnd1 ), _r1LerpToggle);
				float r1 = r1Lerp;
				float r1 = 0.5 - 0.5 * gnm + rnd1;
				r1 = 1.0 - max( 0.0, ((r1<1.0) ? r1 : 0.9999999) );*/

				/*#ifdef ShiftingMode_Default
					float4 r1 = r11;
				#elif defined(ShiftingMode_Glitch)
					float4 r1 = r12;
				#elif defined(ShiftingMode_Blur)
					float4 r1 = r13;
				#endif*/
				
				float rnd2 = rand( float2(mytrunc( uv.y, _vertGlitch * r1 ), time) ); //vert
				float r2 = sat( rnd2 );

				float rnd3 = rand( float2(mytrunc( uv.y, 10.0*r0 ), _shiftTime) );
				float r3 = (1.0-sat(rnd3+0.8)) - 0.1;

				float pxrnd = rand( uv + time );

				float ofs = 0.05 * r2 * _GlitchOffset * ( rnd0 > 0.5 ? 1.0 : _rndGlitchFactor )  * vrcheckOffset ;
				ofs += 0.5 * pxrnd * ofs;
				
				float _shiftXOffsetTime = _shiftXOffset * sin(_Time.y * _shiftXSpeed) * vrcheckOffset;
				float _shiftYOffsetTime = _shiftYOffset * sin(_Time.y * _shiftYSpeed) * vrcheckOffset;

				uv.x += lerp(0, _shiftXOffsetTime * r3 * _GlitchOffset, DistsanceFade);
				uv.y += lerp(0, _shiftYOffsetTime * r3 * _GlitchOffset, DistsanceFade);

				const float RCP_NUM_SAMPLES_F = 1.0 / float(NUM_SAMPLES) * _saturateFactor;
				float3 sum = _color;
				//float3 wsum = float3(0.0,0.0,0.0);
				float4 screenfade = tex2D( _glitchShiftGrabScreenPos, uv);
				for( int i=0; i<NUM_SAMPLES; ++i )
				{
					float t = float(i) * RCP_NUM_SAMPLES_F;
					
					#ifdef _SCREENMOVESXOFFSET_ON
						uv.x = sat( uv.x + ofs ) * _screenMovesX;
					#elif defined(_SCREENMOVESXOFFSET_OFF)
						uv.x = sat( uv.x ) * _screenMovesX;
					#endif
					#ifdef _SCREENMOVESYOFFSET_ON
						uv.y = sat( uv.y + ofs ) * _screenMovesY;
					#elif defined(_SCREENMOVESYOFFSET_OFF)
						uv.y = sat( uv.y ) * _screenMovesY;
					#endif
					/*uv.x = sat( uv.x + ofs ) * _screenMovesX;
					uv.y = sat( uv.y + ofs * t )*_screenMovesY; //_screenMovesY distortion
					uv.y = sat( uv.y + ofs) * _screenMovesY;*/
					float4 samplecol = tex2D( _glitchShiftGrabScreenPos, uv);
					float3 s = spectrum_offset( t );
					float3 grayscaleLerp = lerp(samplecol.rgb, (samplecol.r + samplecol.g + samplecol.b)/_grayscaleOffset * s, _grayscaleToggle);
					float3 sLerp = lerp(.33, s, _rgbSplit);
					samplecol.rgb = grayscaleLerp * sLerp;
					sum += samplecol.rgb;
					//wsum += s;
				}
				sum *= _colorMul;
				float vigAmt = _vigOff*vrcheckOffset;
				float vignette = (1.-vigAmt*(uv.y-.5)*(uv.y-.5))*(1.-vigAmt*(uv.x-.5)*(uv.x-.5));
				sum *= vignette;
				//float vrcheck1 = vrcheck();
				sum += stripes(uv)*_stripes*vrcheckOffset;
				sum += noise(uv*2.)/2*_noise;
				float scanlineLerp = lerp((_Time.y*_scanlineSpeed), sin(_Time.y*_scanlineSpeed), _scanlineSin);
				sum *= (12.+fmod(uv.y*_scanline+scanlineLerp,1))/13*1;
				float4 FinalColor = float4(sum/_brightness, 1);
				float4 EffectsOffset = lerp(screenfade, FinalColor, _EffectsOffset);
				float4 lerpres = lerp(screenfade, EffectsOffset, DistsanceFade);
				return lerpres;
			}
			ENDCG
		}
	}
}