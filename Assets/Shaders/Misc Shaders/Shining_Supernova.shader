
Shader "Custom/Screen/Supernova Shader"
	{

	Properties{
	iChannel0 ("iChannel0", 2D) = "" {}
	col  (  "Ambient Color",  Color  ) = ( 1, 1, 1, 1 )
}

	 SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Overlay+1"
            "RenderType"="Overlay"
        }
        LOD 200
        GrabPass{ "iChannel0"}
        Pass {
     
            Cull Front
            ZTest Always
            ZWrite Off
          
	CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma target 3.0
           



	//Variables
sampler2D iChannel0;
 uniform fixed4 col;
// Updated from https://www.shadertoy.com/view/XdBSDh#

#define SPEED       (1.0 / 80.0)
#define SMOOTH_DIST 0.6

#define PI 3.14159265359

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

    // set up our coordinate system

    fixed2 uv = (i.projPos.xy / i.projPos.w);
   
    
	// get our distance and angle
    float dist = length(uv-0.5);
    float angle = (atan2(0.5-uv.y, uv.x-0.5) + PI) / (2.0 * PI);
    
   	// texture lookup
    fixed3 textureDist;
    textureDist  = tex2D(iChannel0, fixed2(_Time.y * SPEED, angle)).xyz*col;
    
    fixed3 normal = tex2D(iChannel0, uv).xyz;
    
    // manipulate distance
    textureDist *= 0.4;
    textureDist += 0.5;
    
    // set RGB
	fixed4 col = fixed4(0.0,0.0,0.0,0);
    
    if (dist < textureDist.x)
        col.x += smoothstep(0.0,SMOOTH_DIST, textureDist.x - dist);
    if (dist < textureDist.y)
        col.y += smoothstep(0.0,SMOOTH_DIST, textureDist.y - dist);
    
    if (dist < textureDist.z)
        col.z += smoothstep(0.0,SMOOTH_DIST, textureDist.z - dist);
    
    // add a background grid
    //if (fract(mod(uv.x,0.1)) < 0.005 || fract(mod(uv.y,0.1)) < 0.005)
    //    color.y += 0.5;
    //else
    //    color.y += 0.1;
    
    // set final color
    fixed4 fragColor;
	fragColor.rgb = fixed4(col + normal,1.0);
	return fragColor;
}
	ENDCG
	}
  }
}

