
Shader "Custom/Screen/Britney's Spaceship"
	{

	Properties{
	iChannel0 ("iChannel0", 2D) = "white" {}
	}

	SubShader
	{

	cull off
	Pass
	{


	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"

	struct VertexInput {
    fixed4 vertex : POSITION;
	fixed2 uv:TEXCOORD0;
    fixed4 tangent : TANGENT;
    fixed3 normal : NORMAL;
	//VertexInput
	};


	struct VertexOutput {
	fixed4 pos : SV_POSITION;
	fixed2 uv:TEXCOORD0;
	//VertexOutput
	};

	//Variables
float4 _iMouse;
sampler2D iChannel0;

// "Britney's Spaceship" by Kali

//#define LESSDETAIL
#define mat2 fixed2x2
#define mat3 fixed3x3
#define mod fmod
#define RAY_STEPS 100
#define SHADOW_STEPS 50
#define LIGHT_COLOR fixed3(1.,.97,.93)
#define AMBIENT_COLOR fixed3(.75,.65,.6)

#define SPECULAR 0.65
#define DIFFUSE  1.0
#define AMBIENT  0.35

#define BRIGHTNESS 1.5
#define GAMMA 1.35
#define SATURATION .8


#define detail .00004
#define t _Time.y*.2


fixed3 lightdir=normalize(fixed3(0.1,-0.15,-1.));
static const fixed3 origin=fixed3(-1.,0.2,0.);
float det=0.0;
fixed3 pth1;


mat2 rot(float a) {
	return mat2(cos(a),sin(a),-sin(a),cos(a));	
}



fixed4 formula(fixed4 p) {
		p.xz = abs(p.xz+1.)-abs(p.xz-1.)-p.xz;
		p=p*2./clamp(dot(p.xyz,p.xyz),.15,1.)-fixed4(0.5,0.5,0.8,0.);
		p.xy=mul(p.xy,rot(.5));
	return p;
}

float screen(fixed3 p) {
	float d1=length(p.yz-fixed2(.25,0.))-.5;	
	float d2=length(p.yz-fixed2(.25,2.))-.5;	
	return min(max(d1,abs(p.x-.3)-.01),max(d2,abs(p.x+2.3)-.01));
}

fixed2 de(fixed3 pos) {
	float hid=0.;
	fixed3 tpos=pos;
	tpos.z=abs(2.-mod(tpos.z,4.));
	fixed4 p=fixed4(tpos,1.5);
	float y=max(0.,.35-abs(pos.y-3.35))/.35;
#ifdef LESSDETAIL
	for (int i=0; i<6; i++) {p=formula(p);}
	float fr=max(-tpos.x-4.,(length(max(fixed2(0.),p.yz-2.))-.5)/p.w);
#else 
	for (int i=0; i<8; i++) {p=formula(p);}
	float fr=max(-tpos.x-4.,(length(max(fixed2(0.,0.),p.yz-3.)))/p.w);
#endif	

	float sc=screen(tpos);
	float d=min(sc,fr);
	if (abs(d-sc)<.001) hid=1.;
	return fixed2(d,hid);
}

fixed2 colorize(fixed3 p) {
	p.z=abs(2.-mod(p.z,4.));
	float es, l=es=0.;
	float ot=1000.;
	for (int i = 0; i < 15; i++) { 
		p=formula(fixed4(p,0.)).xyz;
				float pl = l;
				l = length(p);
				es+= exp(-10. / abs(l - pl));
				ot=min(ot,abs(l-3.));
	}
	return fixed2(es,ot);
}



fixed3 path(float ti) {
	fixed3  p=fixed3(sin(ti)*2.,(1.-sin(ti*.5))*.5,-cos(ti*.25)*30.)*.5;
	return p;
}


fixed3 normal(fixed3 p) {
	fixed3 e = fixed3(0.0,det,0.0);
	
	return normalize(fixed3(
			de(p+e.yxx).x-de(p-e.yxx).x,
			de(p+e.xyx).x-de(p-e.xyx).x,
			de(p+e.xxy).x-de(p-e.xxy).x
			)
		);	
}

float shadow(fixed3 pos, fixed3 sdir) {
	float sh=1.0;
	float totdist =2.0*det;
	float dist=10.;
		for (int steps=0; steps<SHADOW_STEPS; steps++) {
			if (totdist<1. && dist>detail) {
				fixed3 p = pos - totdist * sdir;
				dist = de(p).x;
				sh = min( sh, max(50.*dist/totdist,0.0) );
				totdist += max(.01,dist);
			}
		}
	
    return clamp(sh,0.1,1.0);
}


float calcAO( const fixed3 pos, const fixed3 nor ) {
	float aodet=detail*40.;
	float totao = 0.0;
    float sca = 13.0;
    for( int aoi=0; aoi<5; aoi++ ) {
        float hr = aodet*float(aoi*aoi);
        fixed3 aopos =  nor * hr + pos;
        float dd = de( aopos ).x;
        totao += -(dd-hr)*sca;
        sca *= 0.7;
    }
    return clamp( 1.0 - 5.0*totao, 0., 1.0 );
}


fixed3 light(in fixed3 p, in fixed3 dir, in fixed3 n, in float hid) {
	float sh=shadow(p, lightdir);
	float ao=calcAO(p,n);
	float diff=max(0.,dot(lightdir,-n))*sh*DIFFUSE;
	fixed3 amb=max(.5,dot(dir,-n))*AMBIENT*AMBIENT_COLOR;
	fixed3 r = reflect(lightdir,n);
	float spec=pow(max(0.,dot(dir,-r))*sh,15.)*SPECULAR;
	fixed3 col;
	fixed2 getcol=colorize(p);
	if (hid>.5) {col=fixed3(1.,1.,1.); spec=spec*spec;}
	else{
		float k=pow(getcol.x*.11,2.); 
		col=lerp(fixed3(k,k*k,k*k),fixed3(k,k,k),.5)+.1;
		col+=pow(max(0.,1.-getcol.y),5.)*.3;
	}
	col=col*ao*(amb+diff*LIGHT_COLOR)+spec*LIGHT_COLOR;	

	if (hid>.5) {
		fixed3 p2=p;
		p2.z=abs(1.-mod(p2.z,2.));
		fixed3 c=tex2D(iChannel0,mod(1.-p.zy-fixed2(.4,0.2),fixed2(1.,1.))).xyz*2.;
		col+=c*abs(.01-mod(p.y-_Time.y*.1,.02))/.01*ao;
		col*=max(0.,1.-pow(length(p2.yz-fixed2(.25,1.)),2.)*3.5);
	} else{
		fixed3 c=(tex2D(iChannel0,mod(p.zx*2.+fixed2(0.5,0.5),fixed2(1.,1.))).xyz);
		c*=abs(.01-mod(p.x-_Time.y*.1*sign(p.x+1.),.02))/.01;
		col+=pow(getcol.x,10.)*.0000000003*c;
		col+=pow(max(0.,1.-getcol.y),4.)
			*pow(max(0.,1.-abs(1.-mod(p.z+_Time.y*2.,4.))),2.)
			*fixed3(1.,.8,.4)*4.*max(0.,.05-abs(p.x+1.))/.05;
	}
	return col;
}

fixed3 raymarch(in fixed3 from, in fixed3 dir) 

{
	float glow,eglow,totdist=glow=0.;
	fixed2 d=fixed2(1.,0.);
	fixed3 p, col=fixed3(0.,0.,0.);
	
	for (int i=0; i<RAY_STEPS; i++) {
		if (d.x>det && totdist<30.0) {
			p=from+totdist*dir;
			d=de(p);
			det=detail*(1.+totdist*50.);
			totdist+=d.x; 
			if(d.x<0.015)glow+=max(0.,.015-d.x)*exp(-totdist);
		}
	}
	float l=max(0.,dot(normalize(-dir),normalize(lightdir)));
	fixed3 backg=fixed3(max(0.,-dir.y+.6),max(0.,-dir.y+.6),max(0.,-dir.y+.6))*AMBIENT_COLOR*.5*max(0.4,l);

	if (d.x<det || totdist<30.) {
		p=p-abs(d.x-det)*dir;
		fixed3 norm=normal(p);
		col=light(p, dir, norm, d.y); 
		col = lerp(col, backg, 1.0-exp(-.15*pow(totdist,1.5)));
	} else { 
		col=backg;
	    fixed3 st = (dir * 3.+ fixed3(1.3,2.5,1.25)) * .3;
		for (int i = 0; i < 13; i++) st = abs(st) / dot(st,st) - .9;
		col+= min( 1., pow( min( 5., length(st) ), 3. ) * .0025 );

	}
	fixed3 lglow=LIGHT_COLOR*pow(l,25.)*.5;
	col+=glow*(.5+l*.5)*LIGHT_COLOR*.7;
	col+=lglow*exp(min(30.,totdist)*.02);
	return col; 
}

fixed3 move(inout fixed3 dir) {
	fixed3 go=path(t);
	fixed3 adv=path(t+.7);
	float hd=de(adv).x;
	fixed3 adfixed=normalize(adv-go);
	float an=adv.x-go.x; 
	an*=min(1.,abs(adv.z-go.z))*sign(adv.z-go.z)*.7;
	dir.xy=mul(dir.xy,mat2(cos(an),sin(an),-sin(an),cos(an)));
    an=adfixed.y*1.7;
	dir.yz=mul(dir.yz,mat2(cos(an),sin(an),-sin(an),cos(an)));
	an=atan2(adfixed.z,adfixed.x);
	dir.xz=mul(dir.xz,mat2(cos(an),sin(an),-sin(an),cos(an)));
	return go;
}


struct v2f {
                float4 position : SV_POSITION;
                //float2 uv : TEXCOORD0; // stores uv
                float3 worldSpacePosition : TEXCOORD0;
                float3 worldSpaceView : TEXCOORD1; 
                fixed4 tangent : TANGENT;
                fixed3 normal : NORMAL;
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


	fixed2 uv = uv = 1;
	uv.y*=1/1;
	fixed2 mouse=(_iMouse.xy/_ScreenParams.xy-.5)*3.;
	if (_iMouse.z<1.) mouse=fixed2(0.,-.2);
	fixed3 dir=normalize(i.worldSpaceView);
	dir.yz=mul(dir.yz,rot(mouse.y));
	dir.xz=mul(dir.xz,rot(mouse.x));
	fixed3 from=origin+move(dir);
	fixed3 color=raymarch(from,dir); 
	color=clamp(color,fixed3(.0,.0,.0),fixed3(1.,1.,1.));
	color=pow(color,fixed3(GAMMA,GAMMA,GAMMA))*BRIGHTNESS;
	color=lerp(fixed3(length(color),length(color),length(color)),color,SATURATION);
	return fixed4(color,1.);
}
	ENDCG
	}
  }
}

