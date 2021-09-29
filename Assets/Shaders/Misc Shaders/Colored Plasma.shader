// Converted the GLSL to CG, which is simple as shit. Then added a few properties, enjoy -Rubba#0420
// Original: https://www.shadertoy.com/view/ldSfzm by the user Himred on Shadertoy (he a qt)
Shader "Custom/Animation Shaders/Plasma Shader"
{

	Properties
	{
		_Size ("Size", Range (1, 256)) = 64
		_Value1 ("Color 1 RED", Range (.0, 1.0)) = .3
		_Value2 ("Color 1 GREEN", Range (.0, 1.0)) = .15
		_Value3 ("Color 1 BLUE", Range (.0, 1.0)) = .1
		_Value4 ("Color 2 RED", Range (.0, 1.0)) = .1
		_Value5 ("Color 2 GREEN", Range (.0, 1.0)) = .05
		_Value6 ("Color 2 BLUE", Range (.0, 1.0)) = .0
		/*Uses the values on line 62 -Rubba)*/
	}
	Subshader
	{
	Tags 
     { 
     	"Queue"="transparent+3969" "IgnoreProjector"="True" "RenderType"="opaque"
		/* lul 69 */
     }
		Pass
		{
			CGPROGRAM
			#pragma vertex vertex_shader
			#pragma fragment pixel_shader
			#pragma target 2.0
			
			float _Size;
			float _Value1;
			float _Value2;
			float _Value3;
			float _Value4;
			float _Value5;
			float _Value6;

			struct custom_type
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};
			
			float m(float3 p) 
			{ 
				p.z+=5.*_Time.g; 
				return length(.2*sin(p.x-p.y)+cos(p/3.)-.1*sin(1.5*p.x))-.8;
				/* you can replace this with return length(.2*sin(p.x-p.y)+cos(p/3.))-.8; if you want also -Rubba */
			}

			custom_type vertex_shader (float4 vertex : POSITION, float2 uv : TEXCOORD0)
			{
				custom_type vs;
				vs.vertex = UnityObjectToClipPos (vertex);
				vs.uv=uv;
				return vs;
			}
			float4 pixel_shader (custom_type ps) : SV_TARGET
			{
				float2 u = ps.uv.xy;
				float3 d=.5-float3(u,0),o=d;
				for(int i=0;i<_Size;i++) o+=m(o)*d;
				return  float4(abs(m(o+d)*float3(_Value1,_Value2,_Value3)+m(o*.05)*float3(_Value4,_Value5,_Value6))*(8.-o.x/2.),1.0);
			}
			ENDCG
		}
	}
}