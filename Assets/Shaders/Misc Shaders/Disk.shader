#warning Upgrade NOTE: unity_Scale shader variable was removed; replaced '_WorldSpaceCameraPos.w' with '1.0'


Shader "Custom/Screen (Single Image)/Disk"
	{

	Properties{
	//Properties
	}

	SubShader
	{
	Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
	Cull off
Blend SrcColor one

ZWrite Off
           Ztest Always
	Pass
	{


	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"



	//Variables

	// The MIT License
// Copyright © 2013 Inigo Quilez
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, fmodify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


// Other intersectors:
//
// Box:       https://www.shadertoy.com/view/ld23DV
// Triangle:  https://www.shadertoy.com/view/MlGcDz
// Capsule:   https://www.shadertoy.com/view/Xt3SzX
// Ellipsoid: https://www.shadertoy.com/view/MlsSzn
// Sphere:    https://www.shadertoy.com/view/4d2XWV
// Cylinder:  https://www.shadertoy.com/view/4lcSRn
// Disk:      https://www.shadertoy.com/view/lsfGDB
// Torus:     https://www.shadertoy.com/view/4sBGDy



#define SC 3.0

#if 1
//
// Elegant way to intersect a planar coordinate system (3x3 linear system)
//
fixed3 intersectCoordSys( in fixed3 o, in fixed3 d, fixed3 c, fixed3 u, fixed3 v )
{
	fixed3 q = o - c;
	return fixed3(
        dot( cross(u,v), q ),
		dot( cross(q,u), d ),
		dot( cross(v,q), d ) ) / 
        dot( cross(v,u), d );
}

#else
//
// Ugly (but faster) way to intersect a planar coordinate system: plane + projection
//
fixed3 intersectCoordSys( in fixed3 o, in fixed3 d, fixed3 c, fixed3 u, fixed3 v )
{
	fixed3  q = o - c;
	fixed3  n = cross(u,v);
    fixed t = -dot(n,q)/dot(d,n);
    fixed r =  dot(u,q + d*t);
    fixed s =  dot(v,q + d*t);
    return fixed3(t,s,r);
}

#endif	

fixed3 hash3( fixed n )
{
    return frac(sin(fixed3(n,n+1.0,n+2.0))*fixed3(43758.5453123,12578.1459123,19642.3490423));
}

fixed3 shade( in fixed4 res )
{
    fixed ra = length(res.yz);
    fixed an = atan2(res.z,res.y) + 8.0*_Time.y;
    fixed pa = sin(3.0*an);

    fixed3 cola = 0.5 + 0.5*sin( (res.w/64.0)*3.5 + fixed3(0.0,1.0,2.0) );
	
	fixed3 col = fixed3(0.0,0.0,0.0);
	col += cola*0.4*(1.0-smoothstep( 0.90, 1.00, ra) );
    col += cola*1.0*(1.0-smoothstep( 0.00, 0.03, abs(ra-0.8)))*(0.5+0.5*pa);
    col += cola*1.0*(1.0-smoothstep( 0.00, 0.20, abs(ra-0.8)))*(0.5+0.5*pa);
	col += cola*0.5*(1.0-smoothstep( 0.05, 0.10, abs(ra-0.5)))*(0.5+0.5*pa);
    col += cola*0.7*(1.0-smoothstep( 0.00, 0.30, abs(ra-0.5)))*(0.5+0.5*pa);

	return col*0.3;
}

fixed3 render( in fixed3 ro, in fixed3 rd )
{
  	// raytrace
    fixed3 col = fixed3( 0.0 , 0.0 , 0.0 );

for( int i=0; i<34; i++ )
	{
		// position disk
	    fixed3 r = 2.5*(-1.0 + 2.0*hash3( fixed(i) ));
r *= SC;		
        // orientate disk
		fixed3 u = normalize( r.zxy );
        fixed3 v = normalize( cross( u, fixed3(0.0,1.0,0.0 ) ) );						   
		
        // intersect coord sys
        fixed3 tmp = intersectCoordSys( ro, rd, r, u, v );
tmp /= SC;		
	    if( dot(tmp.yz,tmp.yz)<1.0 && tmp.x>0.0 ) 
	    {
            // shade			
		    col += shade( fixed4(tmp,fixed(i)) );
	    }
	}

    return col;
}





struct v2f {
                float4 position : SV_POSITION;
                //float2 uv : TEXCOORD0; // stores uv
                float3 worldSpacePosition : TEXCOORD0;
                float3 worldSpaceView : TEXCOORD1; 
            };
            
            v2f vert(appdata_full i) {
            	
            
                v2f o;
                o.position = UnityObjectToClipPos (i.vertex);
                
                float4 vertexWorld = mul(unity_ObjectToWorld, i.vertex);
                
                o.worldSpacePosition = vertexWorld.xyz;
                o.worldSpaceView = vertexWorld.xyz - _WorldSpaceCameraPos;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {

	
	fixed2 q =  1.0;
    fixed2 p = -1.0 + 2.0 * q;
    p.x *= 1/1;

    // camera
	fixed3 ro =  normalize(i.worldSpaceView);
    fixed3 ta = fixed3(0.0,0.0,0.0);
    // camera matrix
    fixed3 ww = normalize(i.worldSpaceView);
    fixed3 uu = normalize(i.worldSpaceView);
    fixed3 vv = normalize(i.worldSpaceView);
	// create view ray
	fixed3 rd = normalize(i.worldSpaceView);

    fixed3 col = render( ro*SC, rd );
    
    return fixed4( col, 1.0 );

	}
	ENDCG
	}
  }
}

