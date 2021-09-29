
Shader "Custom/Screen (Single Image)/Miracle Snowflakes"
	{

	Properties{
	iChannel0 ("iChannel0", 2D) = "" {}
	  bg ("bg", Color) = (1,1,1,1)
	   fallspeed ("fallspeed", Range(0, 16)) = 10
	    fallspeed ("fallspeed", Vector) = (100,100,0,0)
	}

	 SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Overlay+1"
            "RenderType"="Overlay"
        }
        GrabPass{ "iChannel0"}
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }

            Cull Front
            ZTest Always
            ZWrite Off
           Blend SrcColor one

	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"



	//Variables
float4 _iMouse;
sampler2D iChannel0;

// Created by inigo quilez - iq/2013
// Heavily modified by Steven An - 2014
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

// I've not seen anybody out there computing correct cell interior distances for Voronoi
// patterns yet. That's why they cannot shade the cell interior correctly, and why you've
// never seen cell boundaries rendered correctly. 
//
// However, here's how you do mathematically correct distances (note the equidistant and non
// degenerated grey isolines inside the cells) and hence edges (in yellow):
//
// http://www.iquilezles.org/www/articles/voronoilines/voronoilines.htm

uniform fixed3 bg = fixed3(0.6, 0.8, 1.0);
static const fixed3 white = fixed3(1.0, 1.0, 1.0);
static const float zoom = 0.08;
uniform  fixed2 fallspeed = fixed2(0.04,0.05);

static const float pi = 3.141592653;

#define ANIMATE

static const float animbias = 0.5;
static const float animscale = 0.4;

fixed2 hash( fixed2 p )
{
	return tex2D( iChannel0, (p+0.5)/200.0).xy;
	
	// this no longer works reliably due to a bug in some WebGL impls
//    p = fixed2( dot(p,fixed2(127.1,311.7)), dot(p,fixed2(269.5,183.3)) );
//	return fract(sin(p)*43758.5453);
}

fixed3 voronoi( in fixed2 x, out fixed2 cpId )
{
    fixed2 n = floor(x);
    fixed2 f = frac(x);

    //----------------------------------
    // first pass: regular voronoi
    //----------------------------------
	fixed2 mg, mr;

    float md = 8.0;
    for( int j=-1; j<=1; j++ )
    for( int i=-1; i<=1; i++ )
    {
        fixed2 g = fixed2(float(i),float(j));
		fixed2 o = hash( n + g );
		#ifdef ANIMATE
        o = animbias + animscale*sin( _Time.y*0.5 + 6.2831*o );
        #endif	
        fixed2 r = g + o - f;
        float d = dot(r,r);

        if( d<md )
        {
            md = d;
            mr = r;
            mg = g;
        }
    }

    //----------------------------------
    // second pass: distance to borders
    //----------------------------------
    md = 8.0;
    for( int j=-2; j<=2; j++ )
    for( int i=-2; i<=2; i++ )
    {
        fixed2 g = mg + fixed2(float(i),float(j));
		fixed2 o = hash( n + g );
		#ifdef ANIMATE
        o = animbias + animscale*sin( _Time.y*0.5 + 6.2831*o );
        #endif	
        fixed2 r = g + o - f;

		
        if( dot(mr-r,mr-r)>0.000001 )
		{
        // distance to line		
        float d = dot( 0.5*(mr+r), normalize(r-mr) );

        md = min( md, d );
		}
    }
	
	cpId = n+mg;

    return fixed3( md, mr );
}

float sin01(float theta)
{
	return sin(theta)*0.5 + 0.5;
}

float boxfilter( float x, float min, float max )
{
	if( x < min || x > max )
		return 0.0;
	else
		return x;
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

    fixed2 p = (i.projPos.xy-i.projPos.w*0.5)/i.projPos.w;
	p += _Time.y * fallspeed;
	// add variation to sky
	bg = lerp( bg, fixed3(0.8,0.7,0.9), pow(i.projPos.y/i.projPos.w, 1.0));
	fallspeed = lerp( fallspeed, fixed3(0.8,0.7,0.9), pow(i.projPos.y/i.projPos.w, 1.0));
	
	fixed2 cpid;
    fixed3 c = voronoi( p/zoom, cpid );
	float centerDist = length( c.yz );
	float borderDist = c.x;

	float size = lerp( 0.1, 0.20, sin01(cpid.x - cpid.y));
	
	// get angle to cp	
	float angle = atan2(c.z, c.y);
	// add some animated rotation
	float angvel = sin(cpid.x*123.0+cpid.y*451.0) * 0.5*pi;
	angle += _Time.y * angvel;

	float numpeds = floor(lerp(5.0, 9.0, sin01(cpid.x + cpid.y)));
	float pedval = sin01(angle*numpeds);
	fixed3 col = lerp( bg, white, pow(pedval,4.0) );
	
	// some radial details
	float numrings = floor(lerp(1.0, 4.0, sin01(cpid.x*100.0 + cpid.y*42.0)));
	float ringsharp = 2.0;
	float pedval2 = pedval;
	if( hash(cpid).x < 0.5 )
		// determine inward vs. outward warped circles
		pedval2 = 1.0-pedval;
	float warpdist = lerp( centerDist*0.8, centerDist, pedval2 );
	float ringval = sin01(warpdist/(size*0.8) * 2.0*pi * numrings - pi*0.5);
	col = lerp( col, white, pow(ringval, ringsharp)  );
	
	// cutoff past some distance from flake center
	col = lerp( col, bg, smoothstep( size*0.8, size*1.0, centerDist) );

	return fixed4(col,1.0);
}

	ENDCG
	}
  }
}

