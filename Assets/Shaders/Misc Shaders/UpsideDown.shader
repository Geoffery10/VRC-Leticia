Shader "Custom/Screen/UpsideDown Vision Shader"
{
	Properties
	{
		_CutoffDistance("Cutoff Distance", Float) = 1
		_Flip("Flip", Range(-1, 1)) = 1
	}
	SubShader
    {
        Tags { "Queue" = "Transparent+2000" }

        GrabPass
        {
            "_FullScreenTexture"
        }

        Pass
        {
			Cull Off
			ZTest Always
			ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 grabPos : TEXCOORD0;
				float clip : TEXCOORD1;
            };

			uniform float _CutoffDistance;
			uniform float _Flip;

            v2f vert(appdata_base v) {
                v2f o;
				float3 objectPos = mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz;
				#if defined(USING_STEREO_MATRICES)
					float3 leftEye = unity_StereoWorldSpaceCameraPos[0];
					float3 rightEye = unity_StereoWorldSpaceCameraPos[1];

					float3 centerEye = lerp(leftEye, rightEye, 0.5);
				#endif
				#if !defined(USING_STEREO_MATRICES)
					float3 centerEye = _WorldSpaceCameraPos;
				#endif
				o.clip = _CutoffDistance - distance(centerEye, objectPos);
				o.pos = v.vertex;
				o.pos.xy *= 2;
				o.pos.z = .5;
                o.grabPos = ComputeGrabScreenPos(o.pos);
				float y = o.grabPos.y - .5;
				float flipSignMul = (_Flip < 0) ? -1 : 1;
				y = lerp(y, -y, 1 / (_Flip * flipSignMul)) * flipSignMul;
				o.grabPos.y = y + .5;
				if(_Flip == 0)
					o.grabPos.y = 2;
                return o;
            }

            sampler2D _FullScreenTexture;

            half4 frag(v2f i) : SV_Target
            {
				clip(i.clip);
				if(i.grabPos.y > 1 | i.grabPos.y < 0)
					return half4(0,0,0,1);
                half4 bgcolor = tex2Dproj(_FullScreenTexture, i.grabPos);
                return bgcolor;
            }
            ENDCG
        }

    }
}
