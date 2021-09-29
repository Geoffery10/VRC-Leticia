Shader "Custom/Animation Shaders/Water Shader (Texture Input)"
{
 
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _BumpMap ("Bumpmap", 2D) = "bump" { }
        _waterFlow ("waterSpeed", float) = .1
        _waterBounce ("water Bounce", float) = 5
        _rimColor ("Rim Color", Color) = (0.26,0.19,0.16,0.0)
        _rimPower ("Rim Power", Range(0.5,8.0)) = 3.0
    }
 
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }
 
        CGPROGRAM
        #include "UnityCG.cginc"
        #pragma surface surf Lambert
 
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float3 viewDir;
            float4x4 cameraToObject;
        };
 
        sampler2D _MainTex;
        sampler2D _BumpMap;
        float _waterFlow;
        float4 _rimColor;
        float _rimPower;
        float _waterBounce;
 
        void surf(Input IN, inout SurfaceOutput o)
        {
 
            float bounceSinMainTexture = sin(IN.uv_MainTex.y*_waterBounce+_Time.y*_waterBounce)*.01;
 
            float bounceCosMainTexture = cos(IN.uv_MainTex.x*_waterBounce+_Time.y*_waterBounce)*.01;
 
            IN.uv_MainTex.y = IN.uv_BumpMap.y + _Time.y*_waterFlow + bounceSinMainTexture;
            IN.uv_MainTex.x = IN.uv_MainTex.x + bounceCosMainTexture;
 
            float bumpBounceX = cos(IN.uv_BumpMap.x*_waterBounce+_Time.y*_waterBounce)*.01;
            float bumpBounceY = sin(IN.uv_BumpMap.y*_waterBounce+_Time.y*_waterBounce)*.01;
 
            IN.uv_BumpMap.y = IN.uv_BumpMap.y + _Time.y*_waterFlow*2+ bumpBounceY;
            IN.uv_BumpMap.x = IN.uv_BumpMap.x + bumpBounceX;
 
            float2 uvBumpMap2 =  IN.uv_BumpMap;
            uvBumpMap2.x += cos(-bumpBounceX + .5);
            uvBumpMap2.y += sin(-bumpBounceY + .5);
 
            float2 uvBumpMap3 =  uvBumpMap2;
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * tex2D(_MainTex, uvBumpMap2).rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap)) + UnpackNormal(tex2D(_BumpMap, uvBumpMap2));
 
            half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
            half rim2 = sin(dot (normalize(IN.viewDir), o.Normal)*UNITY_PI);
 
            o.Emission = _rimColor.rgb * pow (rim, _rimPower);
        }
 
        ENDCG
    }
 
    FallBack "Diffuse"
}