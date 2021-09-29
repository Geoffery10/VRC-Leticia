// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Misc/Glitch Shader"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
		_NoiseTex("Noise Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags{ "Queue" = "Transparent+5279" "RenderType" = "Transparent"}
		LOD 100
		ZWrite off
		ZTest always
		// Grab the screen behind the object into _MainTex


		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 pos : POSITION;
				float4 screenPos : TEXCOORD1;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 screenPos : TEXCOORD1;
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				o.uv = v.uv;
				o.pos = UnityObjectToClipPos(v.pos);
				o.screenPos = ComputeScreenPos(o.pos);
				return o;
			}
			sampler2D _MainTex;
			sampler2D _MainTex_ST;
			sampler2D _NoiseTex;
			fixed4 frag (v2f i) : SV_Target
			{

			float3 noiseInput = tex2D(_NoiseTex, float2(_Time.x, _Time.x)).rgb;
			float2 redOffset = float2(sin(_Time.x * 0.1), 0);
			float2 greenOffset = float2(0, sin(_Time.x * -0.1));
			float2 blueOffset = float2(sin(_Time.x * -0.1), 0);
			float2 uvScreen = i.screenPos / i.screenPos.w;
			float red = tex2D(_MainTex, uvScreen + redOffset * step(0.2, noiseInput.r)).r;
			float green = tex2D(_MainTex, uvScreen + greenOffset * step(0.2, noiseInput.g)).g;
			float blue = tex2D(_MainTex, uvScreen + blueOffset * step(0.2, noiseInput.b)).b;

			return fixed4(red, green, blue, 1);
			}
			ENDCG
		}
	}
}
