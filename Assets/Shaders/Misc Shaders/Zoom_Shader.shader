// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:32719,y:32712,varname:node_3138,prsc:2|emission-8515-RGB;n:type:ShaderForge.SFN_ScreenPos,id:1333,x:31918,y:32650,varname:node_1333,prsc:2,sctp:2;n:type:ShaderForge.SFN_SceneColor,id:8515,x:32394,y:32720,varname:node_8515,prsc:2|UVIN-7042-OUT;n:type:ShaderForge.SFN_Slider,id:4946,x:31799,y:32841,ptovrint:False,ptlb:Zoom,ptin:_Zoom,varname:node_4946,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_RemapRange,id:401,x:32083,y:32650,varname:node_401,prsc:2,frmn:0,frmx:1,tomn:-0.5,tomx:0.5|IN-1333-UVOUT;n:type:ShaderForge.SFN_Multiply,id:6240,x:32236,y:32757,varname:node_6240,prsc:2|A-401-OUT,B-8008-OUT;n:type:ShaderForge.SFN_Add,id:7042,x:32394,y:32885,varname:node_7042,prsc:2|A-6240-OUT,B-2849-OUT;n:type:ShaderForge.SFN_Vector2,id:2849,x:32198,y:32969,varname:node_2849,prsc:2,v1:0.5,v2:0.5;n:type:ShaderForge.SFN_OneMinus,id:8008,x:32083,y:32831,varname:node_8008,prsc:2|IN-4946-OUT;proporder:4946;pass:END;sub:END;*/

Shader "Custom/Misc/Zoom Effect" {
    Properties {
        _Zoom ("Zoom", Range(0, 1)) = 0
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        GrabPass{ }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _GrabTexture;
            uniform float _Zoom;
            struct VertexInput {
                float4 vertex : POSITION;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 projPos : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float2 sceneUVs = (i.projPos.xy / i.projPos.w);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
////// Lighting:
////// Emissive:
                float3 emissive = tex2D( _GrabTexture, (((sceneUVs.rg*1.0+-0.5)*(1.0 - _Zoom))+float2(0.5,0.5))).rgb;
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
