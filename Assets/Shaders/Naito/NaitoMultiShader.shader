// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:9361,x:33209,y:32712,varname:node_9361,prsc:2|emission-2460-OUT,custl-4718-OUT,clip-44-OUT,olwid-7455-OUT,olcol-5271-OUT;n:type:ShaderForge.SFN_LightAttenuation,id:8068,x:32450,y:33095,varname:node_8068,prsc:2;n:type:ShaderForge.SFN_LightColor,id:3406,x:32730,y:32927,varname:node_3406,prsc:2;n:type:ShaderForge.SFN_LightVector,id:6869,x:31477,y:32546,varname:node_6869,prsc:2;n:type:ShaderForge.SFN_NormalVector,id:9684,x:31477,y:32688,prsc:2,pt:True;n:type:ShaderForge.SFN_HalfVector,id:9471,x:31477,y:32863,varname:node_9471,prsc:2;n:type:ShaderForge.SFN_Dot,id:7782,x:31965,y:32704,cmnt:Lambert,varname:node_7782,prsc:2,dt:1|A-6869-OUT,B-9684-OUT;n:type:ShaderForge.SFN_Dot,id:3269,x:32070,y:32859,cmnt:Blinn-Phong,varname:node_3269,prsc:2,dt:1|A-9684-OUT,B-9471-OUT;n:type:ShaderForge.SFN_Multiply,id:2746,x:32450,y:32977,cmnt:Specular Contribution,varname:node_2746,prsc:2|A-4453-OUT,B-5267-OUT,C-4865-RGB;n:type:ShaderForge.SFN_Tex2d,id:851,x:32014,y:32342,ptovrint:False,ptlb:Diffuse,ptin:_Diffuse,varname:node_851,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:1941,x:32415,y:32569,cmnt:Diffuse Contribution,varname:node_1941,prsc:2|A-544-OUT,B-4453-OUT;n:type:ShaderForge.SFN_Color,id:5927,x:32070,y:32534,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_5927,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Exp,id:1700,x:32070,y:33054,varname:node_1700,prsc:2,et:1|IN-9978-OUT;n:type:ShaderForge.SFN_Slider,id:5328,x:31529,y:33056,ptovrint:False,ptlb:Gloss,ptin:_Gloss,varname:node_5328,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:1;n:type:ShaderForge.SFN_Power,id:5267,x:32268,y:32940,varname:node_5267,prsc:2|VAL-3269-OUT,EXP-1700-OUT;n:type:ShaderForge.SFN_Add,id:2159,x:32769,y:32811,cmnt:Combine,varname:node_2159,prsc:2|A-1941-OUT,B-3022-OUT,C-7483-OUT;n:type:ShaderForge.SFN_Multiply,id:5085,x:32979,y:32894,cmnt:Attenuate and Color,varname:node_5085,prsc:2|A-2159-OUT,B-6962-OUT,C-8068-OUT,D-6962-OUT;n:type:ShaderForge.SFN_ConstantLerp,id:9978,x:31858,y:33056,varname:node_9978,prsc:2,a:1,b:11|IN-5328-OUT;n:type:ShaderForge.SFN_Color,id:4865,x:32268,y:33095,ptovrint:False,ptlb:Spec Color,ptin:_SpecColor,varname:node_4865,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_AmbientLight,id:7528,x:32545,y:32479,varname:node_7528,prsc:2;n:type:ShaderForge.SFN_Multiply,id:2460,x:32964,y:32569,cmnt:Ambient Light,varname:node_2460,prsc:2|A-544-OUT,B-1212-OUT;n:type:ShaderForge.SFN_Multiply,id:544,x:32301,y:32432,cmnt:Diffuse Color,varname:node_544,prsc:2|A-851-RGB,B-5927-RGB;n:type:ShaderForge.SFN_Multiply,id:6962,x:32979,y:33097,varname:node_6962,prsc:2|A-2457-OUT,B-5667-OUT;n:type:ShaderForge.SFN_Slider,id:9752,x:32577,y:33261,ptovrint:False,ptlb:Light Intensity,ptin:_LightIntensity,varname:node_9752,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.05,max:1;n:type:ShaderForge.SFN_RemapRange,id:5667,x:32934,y:33238,varname:node_5667,prsc:2,frmn:0,frmx:1,tomn:0,tomx:35|IN-9752-OUT;n:type:ShaderForge.SFN_Slider,id:1572,x:33145,y:33885,ptovrint:False,ptlb:Cutoff,ptin:_Cutoff,varname:node_1572,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-0.5,cur:0.2,max:1;n:type:ShaderForge.SFN_Color,id:7261,x:32373,y:33612,ptovrint:False,ptlb:Outline Color,ptin:_OutlineColor,varname:node_7261,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Slider,id:1378,x:33159,y:33184,ptovrint:False,ptlb:Outline Width,ptin:_OutlineWidth,varname:node_1378,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_RemapRange,id:7455,x:33546,y:33155,varname:node_7455,prsc:2,frmn:0,frmx:1,tomn:0,tomx:0.06|IN-1378-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:5271,x:32947,y:33447,ptovrint:False,ptlb:Outline Tinting,ptin:_OutlineTinting,varname:node_5271,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-7261-RGB,B-7803-OUT;n:type:ShaderForge.SFN_Slider,id:4938,x:32258,y:33854,ptovrint:False,ptlb:Outline Brightness,ptin:_OutlineBrightness,varname:node_4938,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:20;n:type:ShaderForge.SFN_Multiply,id:4287,x:32657,y:33704,varname:node_4287,prsc:2|A-7261-RGB,B-4938-OUT;n:type:ShaderForge.SFN_Multiply,id:7803,x:32824,y:33565,varname:node_7803,prsc:2|A-851-RGB,B-4287-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:3022,x:32571,y:32841,ptovrint:False,ptlb:Blinn-Phong Toggle,ptin:_BlinnPhongToggle,varname:node_3022,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-7775-OUT,B-2746-OUT;n:type:ShaderForge.SFN_Vector1,id:7775,x:32395,y:32825,varname:node_7775,prsc:2,v1:0;n:type:ShaderForge.SFN_Slider,id:2346,x:32436,y:32352,ptovrint:False,ptlb:Rim Lighting,ptin:_RimLighting,varname:node_2346,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.8350616,max:1;n:type:ShaderForge.SFN_Fresnel,id:3404,x:32927,y:32391,varname:node_3404,prsc:2|EXP-3571-OUT;n:type:ShaderForge.SFN_RemapRange,id:3571,x:32759,y:32423,varname:node_3571,prsc:2,frmn:0,frmx:1,tomn:2,tomx:50|IN-2346-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:7483,x:33151,y:32315,ptovrint:False,ptlb:Rim Light Toggle,ptin:_RimLightToggle,varname:node_7483,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-8138-OUT,B-8106-OUT;n:type:ShaderForge.SFN_Vector1,id:8138,x:32959,y:32227,varname:node_8138,prsc:2,v1:0;n:type:ShaderForge.SFN_Multiply,id:8106,x:33113,y:32443,varname:node_8106,prsc:2|A-3404-OUT,B-5385-OUT;n:type:ShaderForge.SFN_Color,id:6128,x:32747,y:32242,ptovrint:False,ptlb:Rim Color,ptin:_RimColor,varname:node_6128,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:255,c2:255,c3:255,c4:255;n:type:ShaderForge.SFN_Multiply,id:7250,x:32633,y:31881,varname:node_7250,prsc:2|A-851-RGB,B-6848-OUT;n:type:ShaderForge.SFN_Multiply,id:6848,x:32910,y:32069,varname:node_6848,prsc:2|A-5543-OUT,B-6128-RGB;n:type:ShaderForge.SFN_Slider,id:9017,x:32696,y:31807,ptovrint:False,ptlb:Rim Brightness,ptin:_RimBrightness,varname:node_9017,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_RemapRange,id:5543,x:33079,y:31740,varname:node_5543,prsc:2,frmn:0,frmx:1,tomn:0,tomx:35|IN-9017-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:5385,x:33136,y:32042,ptovrint:False,ptlb:Rim Light Tinting,ptin:_RimLightTinting,varname:node_5385,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-6128-RGB,B-7250-OUT;n:type:ShaderForge.SFN_Tex2d,id:8499,x:32973,y:33664,ptovrint:False,ptlb:Cutoff Texture,ptin:_CutoffTexture,varname:node_8499,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:44,x:33304,y:33382,varname:node_44,prsc:2|A-3442-OUT,B-4905-OUT;n:type:ShaderForge.SFN_Clamp01,id:8620,x:31971,y:33442,varname:node_8620,prsc:2|IN-9648-OUT;n:type:ShaderForge.SFN_Depth,id:2999,x:31237,y:33281,varname:node_2999,prsc:2;n:type:ShaderForge.SFN_Multiply,id:3694,x:32207,y:33442,varname:node_3694,prsc:2|A-8620-OUT,B-2107-OUT;n:type:ShaderForge.SFN_Noise,id:9951,x:31826,y:33712,varname:node_9951,prsc:2|XY-9395-OUT;n:type:ShaderForge.SFN_Lerp,id:2107,x:32092,y:33628,varname:node_2107,prsc:2|A-7993-OUT,B-9951-OUT,T-4745-OUT;n:type:ShaderForge.SFN_Slider,id:9146,x:31276,y:33570,ptovrint:False,ptlb:Distance (rough),ptin:_Distancerough,varname:node_9146,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:500;n:type:ShaderForge.SFN_TexCoord,id:710,x:31451,y:33739,varname:node_710,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_OneMinus,id:8162,x:32483,y:33390,varname:node_8162,prsc:2|IN-3694-OUT;n:type:ShaderForge.SFN_Add,id:3442,x:33413,y:33604,varname:node_3442,prsc:2|A-8499-A,B-1572-OUT;n:type:ShaderForge.SFN_Multiply,id:9648,x:31807,y:33300,varname:node_9648,prsc:2|A-1238-OUT,B-7590-OUT;n:type:ShaderForge.SFN_Slider,id:1775,x:31063,y:33195,ptovrint:False,ptlb:Distance (fine),ptin:_Distancefine,varname:node_1775,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_RemapRange,id:1238,x:31428,y:33136,varname:node_1238,prsc:2,frmn:0,frmx:1,tomn:0,tomx:0.01|IN-1775-OUT;n:type:ShaderForge.SFN_RemapRange,id:7993,x:31644,y:33568,varname:node_7993,prsc:2,frmn:0,frmx:500,tomn:0,tomx:10|IN-9146-OUT;n:type:ShaderForge.SFN_Slider,id:4745,x:31814,y:34004,ptovrint:False,ptlb:Dithering,ptin:_Dithering,varname:node_4745,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.8461539,max:1;n:type:ShaderForge.SFN_Multiply,id:9395,x:31660,y:33846,varname:node_9395,prsc:2|A-710-UVOUT,B-4745-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:4905,x:33127,y:33365,ptovrint:False,ptlb:Distance Fade,ptin:_DistanceFade,varname:node_4905,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-1385-OUT,B-8162-OUT;n:type:ShaderForge.SFN_Vector1,id:1385,x:32762,y:33434,varname:node_1385,prsc:2,v1:1;n:type:ShaderForge.SFN_Multiply,id:1212,x:32964,y:32733,varname:node_1212,prsc:2|A-8275-OUT,B-8718-OUT;n:type:ShaderForge.SFN_Slider,id:4400,x:33268,y:32453,ptovrint:False,ptlb:Ambient Intensity,ptin:_AmbientIntensity,varname:node_4400,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_RemapRange,id:8718,x:33346,y:32573,varname:node_8718,prsc:2,frmn:0,frmx:1,tomn:0,tomx:500|IN-4400-OUT;n:type:ShaderForge.SFN_Color,id:5272,x:32516,y:32672,ptovrint:False,ptlb:Ambient Light Color,ptin:_AmbientLightColor,varname:node_5272,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0,c3:0,c4:0;n:type:ShaderForge.SFN_Add,id:8275,x:32753,y:32636,varname:node_8275,prsc:2|A-7528-RGB,B-5272-RGB;n:type:ShaderForge.SFN_Color,id:5548,x:32420,y:33219,ptovrint:False,ptlb:Light Tint,ptin:_LightTint,varname:node_5548,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0,c3:0,c4:0;n:type:ShaderForge.SFN_Add,id:2457,x:32786,y:33114,varname:node_2457,prsc:2|A-3406-RGB,B-5548-RGB;n:type:ShaderForge.SFN_Add,id:4718,x:32656,y:32098,cmnt:Final Combine,varname:node_4718,prsc:2|A-2963-OUT,B-5085-OUT;n:type:ShaderForge.SFN_FragmentPosition,id:9123,x:30971,y:33371,varname:node_9123,prsc:2;n:type:ShaderForge.SFN_ObjectPosition,id:4538,x:30971,y:33495,varname:node_4538,prsc:2;n:type:ShaderForge.SFN_Distance,id:2356,x:31220,y:33421,varname:node_2356,prsc:2|A-9123-XYZ,B-4538-XYZ;n:type:ShaderForge.SFN_Distance,id:7590,x:31519,y:33349,varname:node_7590,prsc:2|A-2999-OUT,B-2356-OUT;n:type:ShaderForge.SFN_Code,id:4542,x:33910,y:33200,varname:node_4542,prsc:2,code:ZgBsAG8AYQB0ADQAIAB2AGEAbAAgAD0AIABVAE4ASQBUAFkAXwBTAEEATQBQAEwARQBfAFQARQBYAEMAVQBCAEUAXwBMAE8ARAAoAHUAbgBpAHQAeQBfAFMAcABlAGMAQwB1AGIAZQAwACwAIAByAGUAZgBsAFYAZQBjAHQALAAgADcAKQA7AAoAZgBsAG8AYQB0ADMAIAByAGUAZgBsAEMAbwBsACAAPQAgAEQAZQBjAG8AZABlAEgARABSACgAdgBhAGwALAAgAHUAbgBpAHQAeQBfAFMAcABlAGMAQwB1AGIAZQAwAF8ASABEAFIAKQA7AAoAcgBlAHQAdQByAG4AIAByAGUAZgBsAEMAbwBsACAAKgAgADAALgAwADIAOwA=,output:2,fname:CubemapReflections,width:515,height:130,input:2,input_1_label:reflVect;n:type:ShaderForge.SFN_SwitchProperty,id:4453,x:32257,y:32709,ptovrint:False,ptlb:Cel-Shading,ptin:_CelShading,varname:node_4453,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-7782-OUT,B-7642-OUT;n:type:ShaderForge.SFN_Slider,id:2546,x:31281,y:32269,ptovrint:False,ptlb:Step,ptin:_Step,varname:node_2546,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.4871795,max:2;n:type:ShaderForge.SFN_Vector1,id:2963,x:32358,y:32031,varname:node_2963,prsc:2,v1:0;n:type:ShaderForge.SFN_TexCoord,id:3335,x:31523,y:32105,varname:node_3335,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Posterize,id:7642,x:32096,y:32171,varname:node_7642,prsc:2|IN-4724-OUT,STPS-1204-OUT;n:type:ShaderForge.SFN_Slider,id:1204,x:31905,y:32062,ptovrint:False,ptlb:Toon Ramp,ptin:_ToonRamp,varname:node_1204,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:1.69,cur:1.69,max:20;n:type:ShaderForge.SFN_Multiply,id:4724,x:31922,y:32143,varname:node_4724,prsc:2|A-1291-OUT,B-7782-OUT;n:type:ShaderForge.SFN_Vector1,id:5785,x:31582,y:31981,varname:node_5785,prsc:2,v1:0;n:type:ShaderForge.SFN_Smoothstep,id:1291,x:31724,y:32143,varname:node_1291,prsc:2|A-5785-OUT,B-2546-OUT,V-3335-U;n:type:ShaderForge.SFN_OneMinus,id:5326,x:31782,y:32536,varname:node_5326,prsc:2|IN-8068-OUT;proporder:851-5927-5328-4865-9752-1572-1378-7261-5271-4938-3022-2346-7483-6128-9017-5385-8499-9146-1775-4745-4905-4400-5272-5548-4453-2546-1204;pass:END;sub:END;*/

Shader "Custom/Multi-Shader/Naito's MultiShader" {
    Properties {
        _Diffuse ("Diffuse", 2D) = "white" {}
        _Color ("Color", Color) = (0.5,0.5,0.5,1)
        _Gloss ("Gloss", Range(0, 1)) = 0.5
        _SpecColor ("Spec Color", Color) = (1,1,1,1)
        _LightIntensity ("Light Intensity", Range(0, 1)) = 0.05
        _Cutoff ("Cutoff", Range(-0.5, 1)) = 0.2
        _OutlineWidth ("Outline Width", Range(0, 1)) = 0
        _OutlineColor ("Outline Color", Color) = (0.5,0.5,0.5,1)
        [MaterialToggle] _OutlineTinting ("Outline Tinting", Float ) = 0.5
        _OutlineBrightness ("Outline Brightness", Range(0, 20)) = 0
        [MaterialToggle] _BlinnPhongToggle ("Blinn-Phong Toggle", Float ) = 0
        _RimLighting ("Rim Lighting", Range(0, 1)) = 0.8350616
        [MaterialToggle] _RimLightToggle ("Rim Light Toggle", Float ) = 0
        _RimColor ("Rim Color", Color) = (255,255,255,255)
        _RimBrightness ("Rim Brightness", Range(0, 1)) = 0
        [MaterialToggle] _RimLightTinting ("Rim Light Tinting", Float ) = 255
        _CutoffTexture ("Cutoff Texture", 2D) = "white" {}
        _Distancerough ("Distance (rough)", Range(0, 500)) = 0
        _Distancefine ("Distance (fine)", Range(0, 1)) = 0
        _Dithering ("Dithering", Range(0, 1)) = 0.8461539
        [MaterialToggle] _DistanceFade ("Distance Fade", Float ) = 1
        _AmbientIntensity ("Ambient Intensity", Range(0, 1)) = 0
        _AmbientLightColor ("Ambient Light Color", Color) = (0,0,0,0)
        _LightTint ("Light Tint", Color) = (0,0,0,0)
        [MaterialToggle] _CelShading ("Cel-Shading", Float ) = 0
        _Step ("Step", Range(0, 2)) = 0.4871795
        _ToonRamp ("Toon Ramp", Range(1.69, 20)) = 1.69
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Name "Outline"
            Tags {
            }
            Cull Front
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _Diffuse; uniform float4 _Diffuse_ST;
            uniform float _Cutoff;
            uniform float4 _OutlineColor;
            uniform float _OutlineWidth;
            uniform fixed _OutlineTinting;
            uniform float _OutlineBrightness;
            uniform sampler2D _CutoffTexture; uniform float4 _CutoffTexture_ST;
            uniform float _Distancerough;
            uniform float _Distancefine;
            uniform float _Dithering;
            uniform fixed _DistanceFade;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float4 projPos : TEXCOORD2;
                UNITY_FOG_COORDS(3)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( float4(v.vertex.xyz + v.normal*(_OutlineWidth*0.06+0.0),1) );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                float4 _CutoffTexture_var = tex2D(_CutoffTexture,TRANSFORM_TEX(i.uv0, _CutoffTexture));
                float2 node_9395 = (i.uv0*_Dithering);
                float2 node_9951_skew = node_9395 + 0.2127+node_9395.x*0.3713*node_9395.y;
                float2 node_9951_rnd = 4.789*sin(489.123*(node_9951_skew));
                float node_9951 = frac(node_9951_rnd.x*node_9951_rnd.y*(1+node_9951_skew.x));
                clip(((_CutoffTexture_var.a+_Cutoff)*lerp( 1.0, (1.0 - (saturate(((_Distancefine*0.01+0.0)*distance(partZ,distance(i.posWorld.rgb,objPos.rgb))))*lerp((_Distancerough*0.02+0.0),node_9951,_Dithering))), _DistanceFade )) - 0.5);
                float4 _Diffuse_var = tex2D(_Diffuse,TRANSFORM_TEX(i.uv0, _Diffuse));
                return fixed4(lerp( _OutlineColor.rgb, (_Diffuse_var.rgb*(_OutlineColor.rgb*_OutlineBrightness)), _OutlineTinting ),0);
            }
            ENDCG
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _Diffuse; uniform float4 _Diffuse_ST;
            uniform float4 _Color;
            uniform float _Gloss;
            uniform float _LightIntensity;
            uniform float _Cutoff;
            uniform fixed _BlinnPhongToggle;
            uniform float _RimLighting;
            uniform fixed _RimLightToggle;
            uniform float4 _RimColor;
            uniform float _RimBrightness;
            uniform fixed _RimLightTinting;
            uniform sampler2D _CutoffTexture; uniform float4 _CutoffTexture_ST;
            uniform float _Distancerough;
            uniform float _Distancefine;
            uniform float _Dithering;
            uniform fixed _DistanceFade;
            uniform float _AmbientIntensity;
            uniform float4 _AmbientLightColor;
            uniform float4 _LightTint;
            uniform fixed _CelShading;
            uniform float _Step;
            uniform float _ToonRamp;
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
                float4 projPos : TEXCOORD3;
                LIGHTING_COORDS(4,5)
                UNITY_FOG_COORDS(6)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                float4 _CutoffTexture_var = tex2D(_CutoffTexture,TRANSFORM_TEX(i.uv0, _CutoffTexture));
                float2 node_9395 = (i.uv0*_Dithering);
                float2 node_9951_skew = node_9395 + 0.2127+node_9395.x*0.3713*node_9395.y;
                float2 node_9951_rnd = 4.789*sin(489.123*(node_9951_skew));
                float node_9951 = frac(node_9951_rnd.x*node_9951_rnd.y*(1+node_9951_skew.x));
                clip(((_CutoffTexture_var.a+_Cutoff)*lerp( 1.0, (1.0 - (saturate(((_Distancefine*0.01+0.0)*distance(partZ,distance(i.posWorld.rgb,objPos.rgb))))*lerp((_Distancerough*0.02+0.0),node_9951,_Dithering))), _DistanceFade )) - 0.5);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
////// Emissive:
                float4 _Diffuse_var = tex2D(_Diffuse,TRANSFORM_TEX(i.uv0, _Diffuse));
                float3 node_544 = (_Diffuse_var.rgb*_Color.rgb); // Diffuse Color
                float3 emissive = (node_544*((UNITY_LIGHTMODEL_AMBIENT.rgb+_AmbientLightColor.rgb)*(_AmbientIntensity*500.0+0.0)));
                float node_7782 = max(0,dot(lightDirection,normalDirection)); // Lambert
                float node_7642 = floor((smoothstep( 0.0, _Step, i.uv0.r )*node_7782) * _ToonRamp) / (_ToonRamp - 1);
                float _CelShading_var = lerp( node_7782, node_7642, _CelShading );
                float3 node_6962 = ((_LightColor0.rgb+_LightTint.rgb)*(_LightIntensity*35.0+0.0));
                float3 finalColor = emissive + (0.0+(((node_544*_CelShading_var)+lerp( 0.0, (_CelShading_var*pow(max(0,dot(normalDirection,halfDirection)),exp2(lerp(1,11,_Gloss)))*_SpecColor.rgb), _BlinnPhongToggle )+lerp( 0.0, (pow(1.0-max(0,dot(normalDirection, viewDirection)),(_RimLighting*48.0+2.0))*lerp( _RimColor.rgb, (_Diffuse_var.rgb*((_RimBrightness*35.0+0.0)*_RimColor.rgb)), _RimLightTinting )), _RimLightToggle ))*node_6962*attenuation*node_6962));
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _Diffuse; uniform float4 _Diffuse_ST;
            uniform float4 _Color;
            uniform float _Gloss;
            uniform float _LightIntensity;
            uniform float _Cutoff;
            uniform fixed _BlinnPhongToggle;
            uniform float _RimLighting;
            uniform fixed _RimLightToggle;
            uniform float4 _RimColor;
            uniform float _RimBrightness;
            uniform fixed _RimLightTinting;
            uniform sampler2D _CutoffTexture; uniform float4 _CutoffTexture_ST;
            uniform float _Distancerough;
            uniform float _Distancefine;
            uniform float _Dithering;
            uniform fixed _DistanceFade;
            uniform float _AmbientIntensity;
            uniform float4 _AmbientLightColor;
            uniform float4 _LightTint;
            uniform fixed _CelShading;
            uniform float _Step;
            uniform float _ToonRamp;
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
                float4 projPos : TEXCOORD3;
                LIGHTING_COORDS(4,5)
                UNITY_FOG_COORDS(6)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                float4 _CutoffTexture_var = tex2D(_CutoffTexture,TRANSFORM_TEX(i.uv0, _CutoffTexture));
                float2 node_9395 = (i.uv0*_Dithering);
                float2 node_9951_skew = node_9395 + 0.2127+node_9395.x*0.3713*node_9395.y;
                float2 node_9951_rnd = 4.789*sin(489.123*(node_9951_skew));
                float node_9951 = frac(node_9951_rnd.x*node_9951_rnd.y*(1+node_9951_skew.x));
                clip(((_CutoffTexture_var.a+_Cutoff)*lerp( 1.0, (1.0 - (saturate(((_Distancefine*0.01+0.0)*distance(partZ,distance(i.posWorld.rgb,objPos.rgb))))*lerp((_Distancerough*0.02+0.0),node_9951,_Dithering))), _DistanceFade )) - 0.5);
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float4 _Diffuse_var = tex2D(_Diffuse,TRANSFORM_TEX(i.uv0, _Diffuse));
                float3 node_544 = (_Diffuse_var.rgb*_Color.rgb); // Diffuse Color
                float node_7782 = max(0,dot(lightDirection,normalDirection)); // Lambert
                float node_7642 = floor((smoothstep( 0.0, _Step, i.uv0.r )*node_7782) * _ToonRamp) / (_ToonRamp - 1);
                float _CelShading_var = lerp( node_7782, node_7642, _CelShading );
                float3 node_6962 = ((_LightColor0.rgb+_LightTint.rgb)*(_LightIntensity*35.0+0.0));
                float3 finalColor = (0.0+(((node_544*_CelShading_var)+lerp( 0.0, (_CelShading_var*pow(max(0,dot(normalDirection,halfDirection)),exp2(lerp(1,11,_Gloss)))*_SpecColor.rgb), _BlinnPhongToggle )+lerp( 0.0, (pow(1.0-max(0,dot(normalDirection, viewDirection)),(_RimLighting*48.0+2.0))*lerp( _RimColor.rgb, (_Diffuse_var.rgb*((_RimBrightness*35.0+0.0)*_RimColor.rgb)), _RimLightTinting )), _RimLightToggle ))*node_6962*attenuation*node_6962));
                fixed4 finalRGBA = fixed4(finalColor * 1,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Back
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float _Cutoff;
            uniform sampler2D _CutoffTexture; uniform float4 _CutoffTexture_ST;
            uniform float _Distancerough;
            uniform float _Distancefine;
            uniform float _Dithering;
            uniform fixed _DistanceFade;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float4 posWorld : TEXCOORD2;
                float4 projPos : TEXCOORD3;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                float4 _CutoffTexture_var = tex2D(_CutoffTexture,TRANSFORM_TEX(i.uv0, _CutoffTexture));
                float2 node_9395 = (i.uv0*_Dithering);
                float2 node_9951_skew = node_9395 + 0.2127+node_9395.x*0.3713*node_9395.y;
                float2 node_9951_rnd = 4.789*sin(489.123*(node_9951_skew));
                float node_9951 = frac(node_9951_rnd.x*node_9951_rnd.y*(1+node_9951_skew.x));
                clip(((_CutoffTexture_var.a+_Cutoff)*lerp( 1.0, (1.0 - (saturate(((_Distancefine*0.01+0.0)*distance(partZ,distance(i.posWorld.rgb,objPos.rgb))))*lerp((_Distancerough*0.02+0.0),node_9951,_Dithering))), _DistanceFade )) - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
