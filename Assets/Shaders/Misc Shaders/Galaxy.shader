// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:True,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:4795,x:33429,y:32691,varname:node_4795,prsc:2|emission-2393-OUT,alpha-7042-OUT;n:type:ShaderForge.SFN_Tex2d,id:6074,x:32322,y:32611,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:08dff1a4d0286b3428b1a8ce93112b74,ntxv:0,isnm:False|UVIN-7088-OUT;n:type:ShaderForge.SFN_Multiply,id:2393,x:33041,y:32795,varname:node_2393,prsc:2|A-6074-R,B-797-RGB,C-3245-OUT;n:type:ShaderForge.SFN_Color,id:797,x:32713,y:32826,ptovrint:True,ptlb:Color,ptin:_TintColor,varname:_TintColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:798,x:32865,y:33253,varname:node_798,prsc:2|A-6074-G,B-9480-OUT;n:type:ShaderForge.SFN_Desaturate,id:8836,x:32563,y:33215,varname:node_8836,prsc:2|COL-6074-RGB;n:type:ShaderForge.SFN_Slider,id:9480,x:32406,y:33362,ptovrint:False,ptlb:Opacity Boost,ptin:_OpacityBoost,varname:node_9480,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:10,max:10;n:type:ShaderForge.SFN_Slider,id:3245,x:32563,y:32994,ptovrint:False,ptlb:Final Power,ptin:_FinalPower,varname:node_3245,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:4,max:10;n:type:ShaderForge.SFN_TexCoord,id:6383,x:31185,y:32523,varname:node_6383,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Rotator,id:9998,x:31360,y:32523,varname:node_9998,prsc:2|UVIN-6383-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:5029,x:31106,y:32770,ptovrint:False,ptlb:Distortion,ptin:_Distortion,varname:node_5029,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:33c80b1218040074996abae228863773,ntxv:3,isnm:True;n:type:ShaderForge.SFN_Multiply,id:1737,x:31431,y:32770,varname:node_1737,prsc:2|A-1107-OUT,B-7147-OUT;n:type:ShaderForge.SFN_Slider,id:7147,x:31107,y:32953,ptovrint:False,ptlb:Distortion Power,ptin:_DistortionPower,varname:node_7147,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.3418804,max:1;n:type:ShaderForge.SFN_RemapRange,id:1107,x:31264,y:32770,varname:node_1107,prsc:2,frmn:0,frmx:1,tomn:0,tomx:1|IN-5029-RGB;n:type:ShaderForge.SFN_ComponentMask,id:5274,x:31597,y:32770,varname:node_5274,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-1737-OUT;n:type:ShaderForge.SFN_ComponentMask,id:8565,x:31520,y:32523,varname:node_8565,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-9998-UVOUT;n:type:ShaderForge.SFN_Add,id:8935,x:31938,y:32534,varname:node_8935,prsc:2|A-8565-R,B-5274-R;n:type:ShaderForge.SFN_Add,id:5576,x:31938,y:32666,varname:node_5576,prsc:2|A-8565-G,B-5274-G;n:type:ShaderForge.SFN_Append,id:7088,x:32142,y:32611,varname:node_7088,prsc:2|A-8935-OUT,B-5576-OUT;n:type:ShaderForge.SFN_Clamp01,id:7042,x:33028,y:33253,varname:node_7042,prsc:2|IN-798-OUT;proporder:6074-797-9480-3245-5029-7147;pass:END;sub:END;*/

Shader "Custom/Screen/Galaxy Shader" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _TintColor ("Color", Color) = (0.5,0.5,0.5,1)
        _OpacityBoost ("Opacity Boost", Range(0, 10)) = 10
        _FinalPower ("Final Power", Range(0, 10)) = 4
        _Distortion ("Distortion", 2D) = "bump" {}
        _DistortionPower ("Distortion Power", Range(0, 1)) = 0.3418804
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
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
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
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
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float4 _TintColor;
            uniform float _OpacityBoost;
            uniform float _FinalPower;
            uniform sampler2D _Distortion; uniform float4 _Distortion_ST;
            uniform float _DistortionPower;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
////// Emissive:
                float4 node_5944 = _Time;
                float node_9998_ang = node_5944.g;
                float node_9998_spd = 1.0;
                float node_9998_cos = cos(node_9998_spd*node_9998_ang);
                float node_9998_sin = sin(node_9998_spd*node_9998_ang);
                float2 node_9998_piv = float2(0.5,0.5);
                float2 node_9998 = (mul(i.uv0-node_9998_piv,float2x2( node_9998_cos, -node_9998_sin, node_9998_sin, node_9998_cos))+node_9998_piv);
                float2 node_8565 = node_9998.rg;
                float3 _Distortion_var = UnpackNormal(tex2D(_Distortion,TRANSFORM_TEX(i.uv0, _Distortion)));
                float2 node_5274 = ((_Distortion_var.rgb*1.0+0.0)*_DistortionPower).rg;
                float2 node_7088 = float2((node_8565.r+node_5274.r),(node_8565.g+node_5274.g));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_7088, _MainTex));
                float3 emissive = (_MainTex_var.r*_TintColor.rgb*_FinalPower);
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,saturate((_MainTex_var.g*_OpacityBoost)));
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
