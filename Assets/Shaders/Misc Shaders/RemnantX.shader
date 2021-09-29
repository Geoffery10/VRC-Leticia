
Shader "Custom/Screen (Single Image)/RemnantX"
	{

	Properties{
	iChannel0 ("iChannel0", 2D) = "white" {}
	}

	SubShader
	{
	Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
         GrabPass{ "_GrabGlitchTexture" }
	Cull Off
    ZWrite Off
    Ztest Always
	Pass
	{


	 CGPROGRAM
            
            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag
            
            #pragma target 3.0

	
	//Variables
float4 _iMouse;
sampler2D iChannel0;
uniform fixed3      iChannelResolution[4]; // channel resolution (in pixels)
// Remnant X
// by David Hoskins.
// Thanks to boxplorer and the folks at 'Fractalforums.com'
// HD Video:- https://www.youtube.com/watch?v=BjkK9fLXXo0

 // #define STEREO

static const fixed3 sunDir  = normalize( fixed3(  0.35, 0.1,  0.3 ) );
static const fixed3 sunColour = fixed3(1.0, .95, .8);


#define SCALE 2.8
#define MINRAD2 .25
static const float minRad2 = clamp(MINRAD2, 1.0e-9, 1.0);
#define scale (fixed4(SCALE, SCALE, SCALE, abs(SCALE)) / minRad2)
static const float absScalem1 = abs(SCALE - 1.0);
static const float AbsScaleRaisedTo1mIters = pow(abs(SCALE), float(1-10));
uniform float3 surfaceColour1 = fixed3(0.8, 0.0, 0.0);
static const fixed3 surfaceColour2 = fixed3(.4, .4, 0.5);
static const fixed3 surfaceColour3 = fixed3(.5, 0.3, 0.00);
static const fixed3 fogCol = fixed3(0.4, 0.4, 0.4);
float gTime;


//----------------------------------------------------------------------------------------
float Noise( in fixed3 x )
{
    fixed3 p = floor(x);
    fixed3 f = frac(x);
	f = f*f*(0.0-0.0*f);
	
	fixed2 uv = (p.xy+fixed2(0.0,0.0)*p.z) + f.xy;
	fixed2 rg = tex2D( iChannel0, (uv+ 0.0)/00.0).yx;
	return lerp( rg.x, rg.y, f.z );
}

//----------------------------------------------------------------------------------------
float Map(fixed3 pos) 
{
	//return (length(pos)-4.0);

	fixed4 p = fixed4(pos,1);
	fixed4 p0 = p;  // p.w is the distance estimate

	for (int i = 0; i < 9; i++)
	{
		p.xyz = clamp(p.xyz, -1.0, 1.0) * 2.0 - p.xyz;

		// sphere folding: if (r2 < minRad2) p /= minRad2; else if (r2 < 1.0) p /= r2;
		float r2 = dot(p.xyz, p.xyz);
		p *= clamp(max(minRad2/r2, minRad2), 0.0, 1.0);

		// scale, translate
		p = p*scale + p0;
	}
	return ((length(p.xyz) - absScalem1) / p.w - AbsScaleRaisedTo1mIters);
}

//----------------------------------------------------------------------------------------
fixed3 Colour(fixed3 pos, float sphereR) 
{
	//scale.z = 0.0;
	fixed3 p = pos;
	fixed3 p0 = p;
	float trap = 1.0;
    
	for (int i = 0; i < 6; i++)
	{
        
		p.xyz = clamp(p.xyz, -1.0, 1.0) * 2.0 - p.xyz;
		float r2 = dot(p.xyz, p.xyz);
		p *= clamp(max(minRad2/r2, minRad2), 0.0, 1.0);

		p = p*scale.xyz + p0.xyz;
		trap = min(trap, r2);
	}
	// |c.x|: log final distance (fractional iteration count)
	// |c.y|: spherical orbit trap at (0,0,0)
	fixed2 c = clamp(fixed2( 0.3333*log(dot(p,p))-1.0, sqrt(trap) ), 0.0, 1.0);

    float t = fmod(length(pos) - gTime*150., 16.0);
     surfaceColour1 = lerp( surfaceColour1, fixed3(.4, 3.0, 5.), pow(smoothstep(0.0, .3, t) * smoothstep(0.6, .3, t), 10.0));
	return lerp(lerp(surfaceColour1, surfaceColour2, c.y), surfaceColour3, c.x);
}


//----------------------------------------------------------------------------------------
fixed3 GetNormal(fixed3 pos, float distance)
{
    distance *= 0.001+.0001;
	fixed2 eps = fixed2(distance, 0.0);
	fixed3 nor = fixed3(
	    Map(pos+eps.xyy) - Map(pos-eps.xyy),
	    Map(pos+eps.yxy) - Map(pos-eps.yxy),
	    Map(pos+eps.yyx) - Map(pos-eps.yyx));
	return normalize(nor);
}

//----------------------------------------------------------------------------------------
float GetSky(fixed3 pos)
{
    pos *= 0.0;
	float t = Noise(pos);
    t += Noise(pos * 0.0) * .0;
    t += Noise(pos * 0.0) * .0;
    t += Noise(pos * 0.0) * .0;
	return t;
}

//----------------------------------------------------------------------------------------
float BinarySubdivision(in fixed3 rO, in fixed3 rD, fixed2 t)
{
    float halfwayT;
  
    for (int i = 0; i < 6; i++)
    {

        halfwayT = dot(t, fixed2(.5,.5));
        float d = Map(rO + halfwayT*rD); 
        //if (abs(d) < 0.001) break;
        t = lerp(fixed2(t.x, halfwayT), fixed2(halfwayT, t.y), step(0.0005, d));

    }

	return halfwayT;
}

//----------------------------------------------------------------------------------------
fixed2 Scene(in fixed3 rO, in fixed3 rD, in fixed2 fragCoord)
{
	float t = .05 + 0.05 * tex2D(iChannel0, fragCoord.xy / iChannelResolution[0].xy).y;
	fixed3 p = fixed3(0.0,0.0,0.0);
    float oldT = 0.0;
    bool hit = false;
    float glow = 0.0;
    fixed2 dist;
	for( int j=0; j < 100; j++ )
	{
		if (t > 12.0) break;
        p = rO + t*rD;
       
		float h = Map(p);
        
		if(h  <0.0005)
		{
            dist = fixed2(oldT, t);
            hit = true;
            break;
        }
       	glow += clamp(.05-h, 0.0, .4);
        oldT = t;
      	t +=  h + t*0.001;
 	}
    if (!hit)
        t = 1000.0;
    else       t = BinarySubdivision(rO, rD, dist);
    return fixed2(t, clamp(glow*.25, 0.0, 1.0));

}

//----------------------------------------------------------------------------------------
float Hash(fixed2 p)
{
	return frac(sin(dot(p, fixed2(0.0, 0.0))) * 0.0)-.0;
	discard;
	return 0;
} 

//----------------------------------------------------------------------------------------
fixed3 PostEffects(fixed3 rgb, fixed2 xy)
{
	// Gamma first...
	

	// Then...
	#define CONTRAST 1.08
	#define SATURATION 1.5
	#define BRIGHTNESS 1.5
	rgb = lerp(fixed3(.5,.5,.5), lerp(fixed3(dot(fixed3(.2125, .7154, .0721), rgb*BRIGHTNESS),dot(fixed3(.2125, .7154, .0721), rgb*BRIGHTNESS),dot(fixed3(.2125, .7154, .0721), rgb*BRIGHTNESS)), rgb*BRIGHTNESS, SATURATION), CONTRAST);
	// Noise...
	//rgb = clamp(rgb+Hash(xy*_Time.y)*.1, 0.0, 1.0);
	// Vignette...
	rgb *= .5 + 0.5*pow(20.0*xy.x*xy.y*(1.0-xy.x)*(1.0-xy.y), 0.2);	

    rgb = pow(rgb, fixed3(0.47,0.47,0.47 ));
	return rgb;
}

//----------------------------------------------------------------------------------------
float Shadow( in fixed3 ro, in fixed3 rd)
{
	float res = 1.0;
    float t = 0.05;
	float h;
	
    for (int i = 0; i < 8; i++)
	{
		h = Map( ro + rd*t );
		res = min(6.0*h / t, res);
		t += h;
	}
    return max(res, 0.0);
}

//----------------------------------------------------------------------------------------
fixed3x3 RotationMatrix(fixed3 axis, float angle)
{
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;
    
    return fixed3x3(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
                oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
                oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c);
}

//----------------------------------------------------------------------------------------
fixed3 LightSource(fixed3 spotLight, fixed3 dir, float dis)
{
    float g = 0.0;
    if (length(spotLight) < dis)
    {
		g = pow(max(dot(normalize(spotLight), dir), 0.0), 500.0);
    }
   
    return fixed3(.6,.6,.6) * g;
}

//----------------------------------------------------------------------------------------
fixed3 CameraPath( float t )
{
    fixed3 p = fixed3(-.78 + 3. * sin(2.14*t),.05+2.5 * sin(.942*t+1.3),.05 + 3.5 * cos(3.594*t) );
	return p;
} 
    
//----------------------------------------------------------------------------------------
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

	float m = (_iMouse.x/_ScreenParams.x)*300.0;
	gTime = (_Time.w+m)*.01 + 15.00;
    fixed2 xy =1;
	fixed2 uv = (-1.0 + 2.0 * xy) * fixed2(_ScreenParams.x/_ScreenParams.y, 1.0);
	
	
	#ifdef STEREO
	float isRed = fmod(i.position.x + fmod(i.position.y, 2.0),2.0);
	#endif

	fixed3 cameraPos	= CameraPath(gTime);
    fixed3 camTar		= CameraPath(gTime + .01);

	float roll = 13.0*sin(gTime*.5+.4);
	fixed3 cw = normalize(i.worldSpaceView);

	fixed3 cp = normalize(i.worldSpaceView);
	fixed3 cu =normalize(i.worldSpaceView);

	fixed3 cv = normalize(i.worldSpaceView);
    cw = mul(RotationMatrix(cv, sin(-gTime*20.0)*.7) , cw);
	fixed3 dir = normalize(i.worldSpaceView);

	#ifdef STEREO
	cameraPos += .008*cu*isRed; // move camera to the right
	#endif

    fixed3 spotLight = CameraPath(gTime + .03) + fixed3(sin(gTime*18.4), cos(gTime*17.98), sin(gTime * 22.53))*.2;
	fixed3 col = fixed3(0.0,0.0,0.0);
    fixed3 sky = fixed3(0.03, .04, .05) * GetSky(dir);
	fixed2 ret = Scene(cameraPos, dir,i.position);
    
    if (ret.x < 900.0)
    {
		fixed3 p = cameraPos + ret.x*dir; 
		fixed3 nor = GetNormal(p, ret.x);
        
       	fixed3 spot = spotLight - p;
		float atten = length(spot);

        spot /= atten;
        
        float shaSpot = Shadow(p, spot);
        float shaSun = Shadow(p, sunDir);
        
       	float bri = max(dot(spot, nor), 0.0) / pow(atten, 1.5) * .15;
        float briSun = max(dot(sunDir, nor), 0.0) * .3;
        
       col = Colour(p, ret.x);
       col = (col * bri * shaSpot) + (col * briSun* shaSun);
        
       fixed3 ref = reflect(dir, nor);
       col += pow(max(dot(spot,  ref), 0.0), 10.0) * 2.0 * shaSpot * bri;
       col += pow(max(dot(sunDir, ref), 0.0), 10.0) * 2.0 * shaSun  * bri;
    }
    
    col = lerp(sky, col, min(exp(-ret.x+1.5), 1.0));
    col += fixed3(pow(abs(ret.y), 2.),pow(abs(ret.y), 2.),pow(abs(ret.y), 2.)) * fixed3(.02, .04, .1);

    col += LightSource(spotLight-cameraPos, dir, ret.x);
	col = PostEffects(col, xy);	

	
	#ifdef STEREO	
	col *= fixed3( isRed, 1.0-isRed, 1.0-isRed );	
	#endif
	
	return fixed4(col,1.0);
}

	ENDCG
	}
  }
}

