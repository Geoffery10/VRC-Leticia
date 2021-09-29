
Shader "Custom/Screen (Single Image)/Fractal Land"
	{

	Properties{
	iChannel0 ("iChannel0", 2D) = "" {}
	iChannel1 ("iChannel1", 2D) = "" {}
	_iMouse ("_iMouse", Vector) = (0,0,0,0)
	 origin ("origin", Range(0.5, 2)) = 1
	 det ("det", Range(0, 0.003)) = 0.003
	  WAVES ("WAVES", Range(0, 10)) = 0.003
	
	}

	 SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Overlay+1"
            "RenderType"="Overlay"
        }
        GrabPass{ "iChannel0"}
        GrabPass{ "iChannel1"}
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
float4 _iMouse;
sampler2D iChannel1;
sampler2D iChannel0;

// "Fractal Cartoon" - former "DE edge detection" by Kali

// There are no lights and no AO, only color by normals and dark edges.

// update: Nyan Cat cameo, thanks to code from mu6k: https://www.shadertoy.com/view/4dXGWH


//#define SHOWONLYEDGES
#define NYAN 
#define WAVES
#define BORDER

#define RAY_STEPS 150

#define BRIGHTNESS 1.2
#define GAMMA 1.4
#define SATURATION .65


#define detail .001
#define t _Time.y*.15


uniform fixed origin=fixed3(-1.,.7,0.);
uniform fixed det=0.0;


// 2D rotation function
static const fixed2x2 rot(float a) {
	return fixed2x2(cos(a),sin(a),-sin(a),cos(a));	
}

// "Amazing Surface" fractal
static const fixed4 formula(fixed4 p) {
		p.xz = abs(p.xz+1.)-abs(p.xz-1.)-p.xz;
		p.y-=.25;
		p.xy=mul(p.xy,rot(radians(35.)));
		p=p*2./clamp(dot(p.xyz,p.xyz),.2,1.);
	return p;
}

// Distance function
static const float de(fixed3 pos) {
#ifdef WAVES
	pos.y+=1*sin(pos.z-t*9.)*.25; //waves!
#endif
	static const float hid=0.;
	fixed3 tpos=pos;
	tpos.z=abs(3.-fmod(tpos.z,6.));
	fixed4 p=fixed4(tpos,1.);
	for (int i=0; i<4; i++) {p=formula(p);}
	float fr=(length(max(fixed2(0.,0),p.yz-1.5))-1.)/p.w;
	float ro=max(abs(pos.x+1.)-.3,pos.y-.35);
		  ro=max(ro,-max(abs(pos.x+1.)-.1,pos.y-.5));
	pos.z=abs(.25-fmod(pos.z,.5));
		  ro=max(ro,-max(abs(pos.z)-.2,pos.y-.3));
		  ro=max(ro,-max(abs(pos.z)-.01,-pos.y+.32));
	float d=min(fr,ro);
	return d;
}


// Camera path
static const fixed3 path(float ti) {
	ti*=1.5;
	fixed3  p=fixed3(sin(ti),(1.-sin(ti*2.))*.5,-ti*5.)*.5;
	return p;
}

// Calc normals, and here is edge detection, set to variable "edge"

uniform float edge=0.;
static const fixed3 normal(fixed3 p) { 
	static const fixed3 e = fixed3(0.0,det*5.,0.0);

	float d1=de(p-e.yxx),d2=de(p+e.yxx);
	float d3=de(p-e.xyx),d4=de(p+e.xyx);
	float d5=de(p-e.xxy),d6=de(p+e.xxy);
	float d=de(p);
	edge=abs(d-0.5*(d2+d1))+abs(d-0.5*(d4+d3))+abs(d-0.5*(d6+d5));//edge finder
	edge=min(1.,pow(edge,.55)*15.);
	return normalize(fixed3(d1-d2,d3-d4,d5-d6));
}


// Used Nyan Cat code by mu6k, with some mods

static const fixed4 rainbow(fixed2 p)
{
	float q = max(p.x,-0.1);
	float s = sin(p.x*7.0+t*70.0)*0.08;
	p.y+=s;
	p.y*=1.1;
	
	fixed4 c;
	if (p.x>0.0) c=fixed4(0,0,0,0); else
	if (0.0/6.0<p.y&&p.y<1.0/6.0) c= fixed4(255,43,14,255)/255.0; else
	if (1.0/6.0<p.y&&p.y<2.0/6.0) c= fixed4(255,168,6,255)/255.0; else
	if (2.0/6.0<p.y&&p.y<3.0/6.0) c= fixed4(255,244,0,255)/255.0; else
	if (3.0/6.0<p.y&&p.y<4.0/6.0) c= fixed4(51,234,5,255)/255.0; else
	if (4.0/6.0<p.y&&p.y<5.0/6.0) c= fixed4(8,163,255,255)/255.0; else
	if (5.0/6.0<p.y&&p.y<6.0/6.0) c= fixed4(122,85,255,255)/255.0; else
	if (abs(p.y)-.05<0.0001) c=fixed4(0.,0.,0.,1.); else
	if (abs(p.y-1.)-.05<0.0001) c=fixed4(0.,0.,0.,1.); else
		c=fixed4(0,0,0,0);
	c.a*=.8-min(.8,abs(p.x*.08));
	c.xyz=lerp(c.xyz,fixed3(length(c.xyz),length(c.xyz),length(c.xyz)),.15);
	return c;
}

static const fixed4 nyan(fixed2 p)
{
	fixed2 uv = mul(p,fixed2(0.4,1.0));
	static const float ns=3.0;
	float nt = _Time.y*ns; nt-=fmod(nt,240.0/256.0/6.0); nt = fmod(nt,240.0/256.0);
	float ny = fmod( _Time.y*ns,1.0); ny-=fmod(ny,0.75); ny*=-0.05;
	fixed4 color = tex2D(iChannel1,fixed2(uv.x/3.0+210.0/256.0-nt+0.05,.5-uv.y-ny));
	if (uv.x<-0.3) color.a = 0.0;
	if (uv.x>0.2) color.a=0.0;
	return color;
}


// Raymarching and 2D graphics

static const fixed3 raymarch(in fixed3 from, in fixed3 dir) 

{
	edge=0.;
	fixed3 p, norm;
	float d=100.;
	float totdist=0.;
	for (int i=0; i<RAY_STEPS; i++) {
		if (d>det && totdist<25.0) {
			p=from+totdist*dir;
			d=de(p);
			det=detail*exp(.13*totdist);
			totdist+=d; 
		}
	}
	fixed3 col=fixed3(0.,0,0);
	p-=mul((det-d),dir);
	norm=normal(p);
#ifdef SHOWONLYEDGES
	col=1.-fixed3(edge); // show wireframe version
#else
	col=(1.-abs(norm))*max(0.,1.-edge*.8); // set normal as color with dark edges
#endif		
	totdist=clamp(totdist,0.,26.);
	dir.y-=.02;
	static const float sunsize=7.-max(0.,tex2D(iChannel0,fixed2(.6,.2)).x)*5.; // responsive sun size
	float an=atan2(dir.x,dir.y)+_Time.y*1.5; // angle for drawing and rotating sun
	float s=pow(clamp(1.0-length(dir.xy)*sunsize-abs(.2-fmod(an,.4)),0.,1.),.1); // sun
	float sb=pow(clamp(1.0-length(dir.xy)*(sunsize-.2)-abs(.2-fmod(an,.4)),0.,1.),.1); // sun border
	float sg=pow(clamp(1.0-length(dir.xy)*(sunsize-4.5)-.5*abs(.2-fmod(an,.4)),0.,1.),3.); // sun rays
	float y=lerp(.45,1.2,pow(smoothstep(0.,1.,.75-dir.y),2.))*(1.-sb*.5); // gradient sky
	
	// set up background with sky and sun
	fixed3 backg=fixed3(0.5,0.,1.)*((1.-s)*(1.-sg)*y+(1.-sb)*sg*fixed3(1.,.8,0.15)*3.);
		 backg+=fixed3(1.,.9,.1)*s;
		 backg=max(backg,sg*fixed3(1.,.9,.5));
	
	col=lerp(fixed3(1.,.9,.3),col,exp(-.004*totdist*totdist));// distant fading to sun color
	if (totdist>25.) col=backg; // hit background
	col=pow(col,fixed3(GAMMA,GAMMA,GAMMA))*BRIGHTNESS;
	col=lerp(fixed3(length(col),length(col),length(col)),col,SATURATION);
#ifdef SHOWONLYEDGES
static const	col=1.-fixed3(length(col));
#else
	col*=fixed3(1.,.9,.85);
#ifdef NYAN
	dir.yx=mul(dir.yx,rot(dir.x));
	fixed2 ncatpos=(dir.xy+fixed2(-3.+fmod(-t,6.),-.27));
	fixed4 ncat=nyan(ncatpos*5.);
	fixed4 rain=rainbow(ncatpos*10.+fixed2(.8,.5));
	if (totdist>8.) col=lerp(col,max(fixed3(.2,.2,.2),rain.xyz),rain.a*.9);
	if (totdist>8.) col=lerp(col,max(fixed3(.2,.2,.2),ncat.xyz),ncat.a*.9);
#endif
#endif
	return col;
}

// get camera position
static const fixed3 move(inout fixed3 dir) {
	static const fixed3 go=path(_WorldSpaceCameraPos-6*t);
	static const fixed3 adv=path(t+.7);
	static const float hd=de(adv);
	static const fixed3 adfixed=normalize(adv-go);
	float an=adv.x-go.x; 
	an*=min(1.,abs(adv.z-go.z))*sign(adv.z-go.z)*.7;
	dir.xy=mul(dir.xy,fixed2x2(cos(an),sin(an),-sin(an),cos(an)));
    an=adfixed.y*1.7;
	dir.yz=mul(dir.yz,fixed2x2(cos(an),sin(an),-sin(an),cos(an)));
	an=atan2(adfixed.x,adfixed.z);
	dir.xz=mul(dir.xz,fixed2x2(cos(an),sin(an),-sin(an),cos(an)));
	return go;
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

	fixed2 uv =_WorldSpaceCameraPos;
	fixed2 oriuv=uv;
	uv.y*=1/1;
	fixed2 mouse=(_iMouse.xy/1-.5)*3.;
	if (_iMouse.y<1.) mouse=fixed2(0.,-0.05);
	static const float fov=.9-max(0.,.7-_Time.y*.3);
	fixed3 dir=normalize(i.worldSpaceView);
	dir.yz=mul(dir.yz,rot(mouse.y));
	dir.xz=mul(dir.xz,rot(mouse.x));
	fixed3 from=origin+move(dir);
	fixed3 color=raymarch(from,dir); 
	#ifdef BORDER
	color=lerp(fixed3(0.,0,0),color,pow(max(0.,.95-length(oriuv*oriuv*oriuv*fixed2(1.05,1.1))),.0));
	#endif
	return fixed4(color,1.);
}
	ENDCG
	}
  }
}

