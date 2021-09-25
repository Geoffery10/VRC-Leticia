// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:True,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:True,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:4795,x:33192,y:32988,varname:node_4795,prsc:2|emission-2800-OUT,voffset-3604-OUT;n:type:ShaderForge.SFN_Slider,id:7831,x:32449,y:33027,ptovrint:False,ptlb:Final Power,ptin:_FinalPower,varname:node_7831,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:4;n:type:ShaderForge.SFN_Tex2d,id:1357,x:32597,y:32810,ptovrint:False,ptlb:Ramp,ptin:_Ramp,varname:node_1357,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:0c1654a137d7df741b6e1a143703a9a8,ntxv:0,isnm:False|UVIN-4927-OUT;n:type:ShaderForge.SFN_Append,id:4927,x:32426,y:32810,varname:node_4927,prsc:2|A-3088-OUT,B-2639-OUT;n:type:ShaderForge.SFN_Vector1,id:2639,x:32229,y:32892,varname:node_2639,prsc:2,v1:0;n:type:ShaderForge.SFN_NormalVector,id:253,x:31819,y:33903,prsc:2,pt:False;n:type:ShaderForge.SFN_Slider,id:1892,x:31819,y:34083,ptovrint:False,ptlb:Offset Power,ptin:_OffsetPower,varname:node_1892,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.3333333,max:4;n:type:ShaderForge.SFN_Multiply,id:3604,x:32238,y:33825,varname:node_3604,prsc:2|A-6959-OUT,B-253-OUT,C-1892-OUT;n:type:ShaderForge.SFN_Multiply,id:2800,x:32873,y:32962,varname:node_2800,prsc:2|A-1357-RGB,B-7831-OUT,C-6234-RGB;n:type:ShaderForge.SFN_Panner,id:7463,x:30234,y:33136,varname:node_7463,prsc:2,spu:0,spv:-1|UVIN-1100-UVOUT,DIST-9851-OUT;n:type:ShaderForge.SFN_Color,id:6234,x:32606,y:33129,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_6234,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_TexCoord,id:1100,x:29948,y:33064,varname:node_1100,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Tex2dAsset,id:2829,x:30575,y:33403,ptovrint:False,ptlb:Wave,ptin:_Wave,varname:node_2829,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:2453,x:30944,y:33275,varname:node_2453,prsc:2,ntxv:0,isnm:False|UVIN-9579-OUT,TEX-2829-TEX;n:type:ShaderForge.SFN_ValueProperty,id:2053,x:31550,y:33735,ptovrint:False,ptlb:Offset Add,ptin:_OffsetAdd,varname:node_2053,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Time,id:151,x:29730,y:33172,varname:node_151,prsc:2;n:type:ShaderForge.SFN_Multiply,id:9851,x:29948,y:33232,varname:node_9851,prsc:2|A-151-T,B-4186-OUT;n:type:ShaderForge.SFN_ValueProperty,id:4186,x:29730,y:33322,ptovrint:False,ptlb:Scroll Speed,ptin:_ScrollSpeed,varname:node_4186,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Add,id:9579,x:30456,y:33214,varname:node_9579,prsc:2|A-7463-UVOUT,B-3653-OUT;n:type:ShaderForge.SFN_Tex2d,id:1054,x:29851,y:33584,ptovrint:False,ptlb:Distortion,ptin:_Distortion,varname:node_1054,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:3,isnm:False;n:type:ShaderForge.SFN_Multiply,id:3653,x:30232,y:33635,varname:node_3653,prsc:2|A-1054-R,B-6585-OUT;n:type:ShaderForge.SFN_Slider,id:6585,x:29862,y:33770,ptovrint:False,ptlb:Distortion Power,ptin:_DistortionPower,varname:node_6585,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.1,max:1;n:type:ShaderForge.SFN_RemapRange,id:1699,x:30019,y:33584,varname:node_1699,prsc:2,frmn:0,frmx:1,tomn:-1,tomx:1|IN-1054-R;n:type:ShaderForge.SFN_Add,id:3109,x:31515,y:33135,varname:node_3109,prsc:2|A-1648-OUT,B-3245-OUT;n:type:ShaderForge.SFN_Fresnel,id:1648,x:30944,y:33080,varname:node_1648,prsc:2|EXP-391-OUT;n:type:ShaderForge.SFN_Clamp01,id:3088,x:31728,y:33135,varname:node_3088,prsc:2|IN-3109-OUT;n:type:ShaderForge.SFN_Slider,id:391,x:30569,y:33066,ptovrint:False,ptlb:Fresnel Exp,ptin:_FresnelExp,varname:node_391,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:2,max:4;n:type:ShaderForge.SFN_Multiply,id:3245,x:31269,y:33209,varname:node_3245,prsc:2|A-7713-OUT,B-2453-R,C-8113-R;n:type:ShaderForge.SFN_Fresnel,id:7713,x:30944,y:33407,varname:node_7713,prsc:2;n:type:ShaderForge.SFN_Tex2d,id:8113,x:30944,y:33564,ptovrint:False,ptlb:Mask,ptin:_Mask,varname:node_8113,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:4d1e98cacbba9ac40ab6290eb81181c9,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Add,id:6959,x:31826,y:33625,varname:node_6959,prsc:2|A-2453-R,B-2053-OUT;proporder:7831-1357-1892-6234-2829-2053-4186-1054-6585-391-8113;pass:END;sub:END;*/

Shader "Sine VFX/StartSphereV5" {
    Properties {
        _FinalPower ("Final Power", Range(0, 4)) = 1
        _Ramp ("Ramp", 2D) = "white" {}
        _OffsetPower ("Offset Power", Range(0, 4)) = 0.3333333
        _Color ("Color", Color) = (0.5,0.5,0.5,1)
        _Wave ("Wave", 2D) = "white" {}
        _OffsetAdd ("Offset Add", Float ) = 0
        _ScrollSpeed ("Scroll Speed", Float ) = 1
        _Distortion ("Distortion", 2D) = "bump" {}
        _DistortionPower ("Distortion Power", Range(0, 1)) = 0.1
        _FresnelExp ("Fresnel Exp", Range(0, 4)) = 2
        _Mask ("Mask", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One One
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float _FinalPower;
            uniform sampler2D _Ramp; uniform float4 _Ramp_ST;
            uniform float _OffsetPower;
            uniform float4 _Color;
            uniform sampler2D _Wave; uniform float4 _Wave_ST;
            uniform float _OffsetAdd;
            uniform float _ScrollSpeed;
            uniform sampler2D _Distortion; uniform float4 _Distortion_ST;
            uniform float _DistortionPower;
            uniform float _FresnelExp;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                UNITY_FOG_COORDS(3)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_151 = _Time;
                float4 _Distortion_var = tex2Dlod(_Distortion,float4(TRANSFORM_TEX(o.uv0, _Distortion),0.0,0));
                float2 node_9579 = ((o.uv0+(node_151.g*_ScrollSpeed)*float2(0,-1))+(_Distortion_var.r*_DistortionPower));
                float4 node_2453 = tex2Dlod(_Wave,float4(TRANSFORM_TEX(node_9579, _Wave),0.0,0));
                v.vertex.xyz += ((node_2453.r+_OffsetAdd)*v.normal*_OffsetPower);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
////// Lighting:
////// Emissive:
                float4 node_151 = _Time;
                float4 _Distortion_var = tex2D(_Distortion,TRANSFORM_TEX(i.uv0, _Distortion));
                float2 node_9579 = ((i.uv0+(node_151.g*_ScrollSpeed)*float2(0,-1))+(_Distortion_var.r*_DistortionPower));
                float4 node_2453 = tex2D(_Wave,TRANSFORM_TEX(node_9579, _Wave));
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                float2 node_4927 = float2(saturate((pow(1.0-max(0,dot(normalDirection, viewDirection)),_FresnelExp)+((1.0-max(0,dot(normalDirection, viewDirection)))*node_2453.r*_Mask_var.r))),0.0);
                float4 _Ramp_var = tex2D(_Ramp,TRANSFORM_TEX(node_4927, _Ramp));
                float3 emissive = (_Ramp_var.rgb*_FinalPower*_Color.rgb);
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0,0,0,1));
                return finalRGBA;
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
