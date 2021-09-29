
Shader "Custom/Screen (Single Image)/Circuits"
	{

	Properties{
	iChannel0("iChannel0", 2D) = "black" {}
	iChannel1("iChannel1", 2D) = "black" {}
	}

	SubShader
	{
	cull off

	Pass
	{


	CGPROGRAM
            
            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag
            
            #pragma target 3.0

            struct appdata{
    float4 vertex : POSITION;
	float2 uv:TEXCOORD0;
	};

   #define vec2 float2
  	#define vec3 float3
  	#define vec4 float4
  	#define mat2 float2x2
  	#define iTime _Time.y
  	#define mod fmod
  	#define mix lerp
  	#define atan atan2
  	#define fract frac 
  	#define texture tex2D

  	#define iResolution _ScreenParams

  	#define FragCoord ((_iParam.scrPos.xy/_iParam.scrPos.w)*_ScreenParams.xy) 
  	 
  	struct v2f
    {
    float2 uv : TEXCOORD0;
    float4 vertex : SV_POSITION;
    float4 screenCoord : TEXCOORD1;
    };

    v2f vert(appdata v)
    {
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.uv = v.uv;
    o.screenCoord.xy = ComputeScreenPos(o.vertex);
    return o;
    }

	//Variables

sampler2D iChannel1;
sampler2D iChannel0;

  
// This content is under the MIT License.

#define time _Time.y*.02


#define width .005
static float zoom = .18;

float shape=0.;
vec3 color=vec3(0.,0.,0.),randcol;

void formula(vec2 z, float c) {
	float minit=0.;
	float o,ot2,ot=ot2=1000.;
	for (int i=0; i<9; i++) {
		z=abs(z)/clamp(dot(z,z),.1,.5)-c;
		float l=length(z);
		o=min(max(abs(min(z.x,z.y)),-l+.25),abs(l-.25));
		ot=min(ot,o);
		ot2=min(l*.1,ot2);
		minit=max(minit,float(i)*(1.-abs(sign(ot-o))));
	}
	minit+=1.;
	float w=width*minit*2.;
	float circ=pow(max(0.,w-ot2)/w,6.);
	shape+=max(pow(max(0.,w-ot)/w,.25),circ);
	vec3 col=normalize(.1+texture(iChannel1,vec2(minit*.1,minit*.1)).rgb);
	color+=col*(.4+mod(minit/9.-time*10.+ot2*2.,1.)*1.6);
	color+=vec3(1.,.7,.3)*circ*(10.-minit)*3.*smoothstep(0.,.5,.15+texture(iChannel0,vec2(.0,1.)).x-.5);
}


fixed4 frag(v2f i) : SV_Target{

	vec2 pos = i.uv.xy / 1 - .5;
	pos.x*=1/1;
	vec2 uv=pos;
	float sph = length(uv); sph = sqrt(1. - sph*sph)*1.5; // curve for spheric distortion
	uv=normalize(vec3(uv,sph)).xy;
	float a=time+mod(time,1.)*.5;
	vec2 luv=uv;
	float b=a*5.48535;
//	zoom*=1.+sin(time*3.758123)*.8;
	uv=mul(uv,mat2(cos(b),sin(b),-sin(b),cos(b)));
	uv+=vec2(sin(a),cos(a*.5))*8.;
	uv*=zoom;
	float pix=.5/iResolution.x*zoom/sph;
	float dof=max(1.,(10.-mod(time,1.)/.01));
	float c=1.5+mod(floor(time),6.)*.125;
	for (int aa=0; aa<36; aa++) {
		vec2 aauv=floor(vec2(float(aa)/6.,mod(float(aa),6.)));
		formula(uv+aauv*pix*dof,c);
	}
	shape/=36.; color/=36.;
	vec3 colo=mix(vec3(.15,.15,.15),color,shape)*(1.-length(pos))*min(1.,abs(.5-mod(time+.5,1.))*10.);	
	colo*=vec3(1.2,1.1,1.0);
	return vec4(colo,1.0);
}
	ENDCG
	}
  }
}

