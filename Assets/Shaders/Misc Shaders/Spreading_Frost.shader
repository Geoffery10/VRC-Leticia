
Shader "Custom/Screen/Spreading Frost/Sonic Boom"
	{

	Properties{
	iChannel0 ("iChannel0", 2D) = "" {}
	iChannel1 ("iChannel1", 2D) = "" {}
	iChannel2 ("iChannel2", 2D) = "" {}
	_iMouse ("_iMouse", Vector) = (0,0,0,0)
	}

	 SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Overlay+1"
            "RenderType"="Overlay"
        }
        GrabPass{ "iChannel0"}
        GrabPass{ "iChannel1"}
        GrabPass{ "iChannel2"}
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }

            Cull Front
            ZTest Always
            ZWrite Off


	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"



	//Variables
sampler2D iChannel2;
sampler2D iChannel1;
sampler2D iChannel0;

// Spreading Frost by dos
// Inspired by https://www.shadertoy.com/view/MsySzy by shadmar

#define FROSTYNESS 0.5
//#define RANDNERF 2.5

float rand(fixed2 uv) {
    #ifdef RANDNERF
    uv = floor(uv*pow(10.0, RANDNERF))/pow(10.0, RANDNERF);
    #endif
    
    float a = dot(uv, fixed2(92., 80.));
    float b = dot(uv, fixed2(41., 62.));
    
    float x = sin(a) + cos(b) * 51.;
    return frac(x);
}

 struct VertexInput {
                float4 vertex : POSITION;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 projPos : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                o.pos = UnityObjectToClipPos( v.vertex );
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {

    fixed2 uv = (i.projPos.xy / i.projPos.w);
    float progress = frac(_Time.y / 4.0);

    fixed4 frost = tex2D(iChannel1, uv);
    float icespread = tex2D(iChannel2, uv).r;

    fixed2 rnd = fixed2(rand(uv+frost.r*0.05), rand(uv+frost.b*0.05));
            
    float size = lerp(progress, sqrt(progress), 0.5);   
    size = size * 1.12 + 0.0000001; // just so 0.0 and 1.0 are fully (un)frozen and i'm lazy
    
    fixed2 lens = fixed2(size, pow(size, 4.0) / 2.0);
    float dist = distance(uv.xy, fixed2(0.5, 0.5)); // the center of the froziness
    float vignette = pow(1.0-smoothstep(lens.x, lens.y, dist), 2.0);
   
    rnd *= frost.rg*vignette*FROSTYNESS;
    
    rnd *= 1.0 - floor(vignette); // optimization - brings rnd to 0.0 if it won't contribute to the image
    
    fixed4 regular = tex2D(iChannel0, uv);
    fixed4 frozen = tex2D(iChannel0, uv + rnd);
    frozen *= fixed4(0.9, 0.9, 1.1, 1.0);
        
   return lerp(frozen, regular, smoothstep(icespread, 1.0, pow(vignette, 2.0)));
}
	ENDCG
	}
  }
}

