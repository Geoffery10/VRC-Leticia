
Shader "Custom/Screen/Color Fun"
	{

	Properties{



	_MainTex ("MainTex", 2D) = "white" {}
	_Color ("Color", Color) = (1, 1, 1, 1)
	_Range5("Size ", Range( 0 , 4)) = 0
	_Range1("Offset ", Range( -10 , 10)) = 0
	[Space(9)]
	_Range2("BLUE ", Range( -10 , 10)) = 0
	_Range3("Red ", Range( -10 , 10)) = 0
	_Range4("Green ", Range( -10 , 10)) = 0


	


	}

	SubShader
		

	{	


	
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
sampler2D _MainTex;
uniform float _Range1;
uniform float _Range2;
uniform float _Range3;
uniform float _Range4;
uniform float _Range5;

uniform float _Rangea;
uniform float _Rangeb;
uniform float _Rangec;

	uniform float4 _Color;









	VertexOutput vert (VertexInput v)
	{
	VertexOutput o;
	o.pos = UnityObjectToClipPos (v.vertex);
	o.uv = v.uv;

	return o;
	}
	fixed4 frag(VertexOutput i) : SV_Target
	{









































	fixed2 q = (-1 + 2.0*i.uv) / 0.04;
    fixed2 p = q;
    
    p += _Range1*cos( 1.5*p.yx + 1*_Time.y + fixed2(0.1,1.1) );
	p += .2*cos( 2.4*p.yx + 1.6*_Time.y + fixed2(4.5,2.6) );
	p += .2*cos( 3.3*p.yx + 1.2*_Time.y + fixed2(3.2,3.4) );
	p += .2*cos( 4.2*p.yx + 1.7*_Time.y + fixed2(1.8,5.2) );
	p += .2*cos( 9.1*p.yx + 1.1*_Time.y + fixed2(6.3,3.9) );

	fixed r = length( p );
    
    fixed3 col1 = tex2Dlod( _MainTex  ,fixed4(r,     0.0,fixed2( 0.0 , 0.0 ))).zyx;
    fixed3 col2 = tex2Dlod( _MainTex,fixed4(r+0.04,0.0,fixed2( 0.0 , 0.0 ))).zyx;

    fixed3 col = col1;
    col += 1;;
    col *= 1.0 + 2*sin(r+fixed3(_Range3,_Range4,_Range2   ));
    col -= 4.0*max(fixed3(0,0,0),col1-col2).x;
    col += 1.0*max(fixed3(_Range5,0.0,0.0),col2-col1).x - 0.1;
    col *= 1 - 0.5*length(q);

    return fixed4( col, 0  );

	}
	ENDCG
	}
  }
}

