//designed for 2.3.8

using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class PoiToon : ShaderGUI
{

    private class PoiToonHeader
    {
        private List<MaterialProperty> propertyes;
        private bool currentState;

        public PoiToonHeader(MaterialEditor materialEditor, string propertyName)
        {
            this.propertyes = new List<MaterialProperty>();
            foreach (Material materialEditorTarget in materialEditor.targets)
            {
                Object[] asArray = new Object[] { materialEditorTarget };
                propertyes.Add(MaterialEditor.GetMaterialProperty(asArray, propertyName));
            }

            this.currentState = fetchState();
        }

        public bool fetchState()
        {
            foreach (MaterialProperty materialProperty in propertyes)
            {
                if (materialProperty.floatValue == 1)
                    return true;
            }
            return false;
        }

        public bool getState()
        {
            return this.currentState;
        }

        public void Toggle()
        {
            if (getState())
            {
                foreach (MaterialProperty materialProperty in propertyes)
                {
                    materialProperty.floatValue = 0;
                }
            }
            else
            {
                foreach (MaterialProperty materialProperty in propertyes)
                {
                    materialProperty.floatValue = 1;
                }
            }

            this.currentState = !this.currentState;
        }
    }

    public static void linkButton(int Width, int Height, string title, string link)
    {
        if (GUILayout.Button(title, GUILayout.Width(Width), GUILayout.Height(Height)))
        {
            Application.OpenURL(link);
        }
    }
    private static class PoiToonUI
    {
        public static PoiToonHeader Foldout(string title, PoiToonHeader display)
        {
            var style = new GUIStyle("ShurikenModuleTitle");
            style.font = new GUIStyle(EditorStyles.label).font;
            style.border = new RectOffset(15, 7, 4, 4);
            style.fixedHeight = 22;
            style.contentOffset = new Vector2(20f, -2f);

            var rect = GUILayoutUtility.GetRect(16f, 22f, style);
            GUI.Box(rect, title, style);

            var e = Event.current;

            var toggleRect = new Rect(rect.x + 4f, rect.y + 2f, 13f, 13f);
            if (e.type == EventType.Repaint)
            {
                EditorStyles.foldout.Draw(toggleRect, false, false, display.getState(), false);
            }

            if (e.type == EventType.MouseDown && rect.Contains(e.mousePosition))
            {
                display.Toggle();
                e.Use();
            }

            return display;
        }
    }

    private static class Styles
    {
        public static GUIContent Color = new GUIContent("Color", "Color used for tinting the main texture");
        public static GUIContent Desaturation = new GUIContent("Desaturation", "Desaturate the colors before applying Color");
        public static GUIContent MainTex = new GUIContent("Main Tex", "Main texture for the shader");
        public static GUIContent Clip = new GUIContent("Alpha Cutoff", "Alpha treshold");
        public static GUIContent NormalMap = new GUIContent("Normal Map", "Bump map");
        public static GUIContent NormalIntensity = new GUIContent("Normal Intensity", "Normal Strength");

        public static GUIContent CubeMap = new GUIContent("Baked CubeMap", "");
        public static GUIContent SampleWorld = new GUIContent("Force Baked Cubemap", "Don't sample the world for reflections if 1");
        public static GUIContent AdditiveClearCoat = new GUIContent("Additive Clear Coat", "");
        public static GUIContent PurelyAdditive = new GUIContent("Purely Additive", "");
        public static GUIContent MetallicMap = new GUIContent("MetallicMap", "");
        public static GUIContent Metallic = new GUIContent("Metallic", "");
        public static GUIContent RoughnessMap = new GUIContent("RoughnessMap", "");
        public static GUIContent Roughness = new GUIContent("Smoothness", "");

        public static GUIContent Matcap = new GUIContent("Matcap", "");
        public static GUIContent MatcapMap = new GUIContent("Matcap Map", "");
        public static GUIContent MatcapColor = new GUIContent("Matcap Color", "");
        public static GUIContent MatcapStrength = new GUIContent("Matcap Strength", "");
        public static GUIContent ReplaceWithMatcap = new GUIContent("Replace With Matcap", "");
        public static GUIContent MultiplyMatcap = new GUIContent("Multiply Matcap", "");
        public static GUIContent AddMatcap = new GUIContent("Add Matcap", "");

        // outlines
        public static GUIContent LineWidth = new GUIContent("Line Width", "Width of the outline");
        public static GUIContent OutlineColor = new GUIContent("Outline Color", "Tint of the outline");
        public static GUIContent OutlineEmission = new GUIContent("Outline Emission", "How much emission glows");
        public static GUIContent OutlineTexture = new GUIContent("Outline Texture", "Texture for the outline");
        public static GUIContent Speed = new GUIContent("Speed", "speed of texture scrolling on outline");

        // emission
        public static GUIContent EmissionColor = new GUIContent("Color", "Color used for emission");
        public static GUIContent EmissionMap = new GUIContent("Map", "Texture used for emission");
        public static GUIContent EmissionScrollSpeed = new GUIContent("Emission Pan Speed", "");
        public static GUIContent EmissionStrength = new GUIContent("Strength", "Strength multiplier for emission");

        // emissive blink
        public static GUIContent EmissiveBlinkMin = new GUIContent("Min", "Minimum value used for emissive blink");
        public static GUIContent EmissiveBlinkMax = new GUIContent("Max", "Maximum value used for emissive blink");
        public static GUIContent EmissiveBlinkVelocity = new GUIContent("Velocity", "Blinking speed");

        // emissive scroll
        public static GUIContent EmissiveScrollEnabled = new GUIContent("Emissive Scrolling Enabled", "");
        public static GUIContent EmissiveScrollDirection = new GUIContent("Direction", "Emissive scrolling direction");
        public static GUIContent EmissiveScrollWidth = new GUIContent("Width", "Emissive scrolling width");
        public static GUIContent EmissiveScrollVelocity = new GUIContent("Velocity", "Emissive scrolling speed");
        public static GUIContent EmissiveScrollInterval = new GUIContent("Interval", "Delay between emissive scrolls");

        // fake lighting
        public static GUIContent LightingGradient = new GUIContent("Lighting Ramp", "Texture the fake light uses for tinting");
        public static GUIContent LightingShadowStrength = new GUIContent("Shadow Strength", "Shadow intensity");
        public static GUIContent LightingShadowOffsett = new GUIContent("Shadow Offset", "Shadow Offset");
        public static GUIContent LightingDirection = new GUIContent("Light Direction", "Direction towards which the light will cast shadows");
        public static GUIContent ForceLightDirection = new GUIContent("Force Light Direction", "");
        public static GUIContent ForceShadowStrength = new GUIContent("Force Shadow Strength", "");
        public static GUIContent MinBrightness = new GUIContent("Min Brightness", "Limit how dark you can get");
        public static GUIContent MaxDirectionalIntensity = new GUIContent("Max Directional Intensity", "Limit how bright the directional light in a map can be");
        public static GUIContent AdditiveRamp = new GUIContent("Additive Ramp", "Don't touch this if you don't know what it does");
        public static GUIContent FlatOrFullAmbientLighting = new GUIContent("Flat-Full Ambient Lighting", "Use normals for ambient lighting");

        // specular
        public static GUIContent HardSpecular = new GUIContent("Hard Specular?", ""); // TODO: all of these vvv
        public static GUIContent SpecularMap = new GUIContent("Map", ""); // TODO: all of these vvv
        public static GUIContent Gloss = new GUIContent("Gloss", ""); // TODO: all of these vvv
        public static GUIContent SpecularColor = new GUIContent("Color", "");
        public static GUIContent SpecularBias = new GUIContent("Specular Bias", "");
        public static GUIContent SpecularStrength = new GUIContent("Strength", "");
        public static GUIContent SpecularSize = new GUIContent("Specular Size", "");

        // rim Lighting
        public static GUIContent RimColor = new GUIContent("Rim Color", "");
        public static GUIContent RimWidth = new GUIContent("Width", "");
        public static GUIContent RimGlowStrength = new GUIContent("Glow Strength", "");
        public static GUIContent RimSharpness = new GUIContent("Rim Sharpness", "");
        public static GUIContent RimColorBias = new GUIContent("Color Bias", "");
        public static GUIContent RimTexture = new GUIContent("Texture", "");
        public static GUIContent RimTexturePanSpeed = new GUIContent("Texture Pan Speed", "");

        // stencils
        public static GUIContent StencilRef = new GUIContent("Stencil Value", "The refernce to be compared against");
        public static GUIContent StencilCompareFunction = new GUIContent("Stencil Compare Function", "How the referenced value is being compared");
        public static GUIContent StencilOp = new GUIContent("Stencil Op", "What to do if stencil comparison passes");

        // misc
        public static GUIContent CullMode = new GUIContent("Cull Mode", "Controls which face of the mesh is rendered \nOff = Double sided \nFront = Single sided (reverse) \nBack = Single sided");
        public static GUIContent SrcBlend = new GUIContent("Src Blend", "");
        public static GUIContent DstBlend = new GUIContent("Dst Blend", "");
        public static GUIContent ZTest = new GUIContent("ZTest", "don't be an asshole");
    }

    GUIStyle m_sectionStyle;
    MaterialProperty m_color = null;
    MaterialProperty m_desaturation = null;
    MaterialProperty m_mainTex = null;
    MaterialProperty m_normalMap = null;
    MaterialProperty m_normalIntensity = null;

    MaterialProperty m_cubeMap;
    MaterialProperty m_sampleWorld;
    MaterialProperty m_additiveClearCoat;
    MaterialProperty m_purelyAdditive;
    MaterialProperty m_metallicMap;
    MaterialProperty m_metallic;
    MaterialProperty m_roughnessMap;
    MaterialProperty m_roughness;

    MaterialProperty m_matcap;
    MaterialProperty m_matcapMap;
    MaterialProperty m_matcapColor;
    MaterialProperty m_matcapStrength;
    MaterialProperty m_replaceWithMatcap;
    MaterialProperty m_multiplyMatcap;
    MaterialProperty m_addMatcap;

    MaterialProperty m_lineWidth;
    MaterialProperty m_outlineColor;
    MaterialProperty m_outlineEmission;
    MaterialProperty m_outlineTexture;
    MaterialProperty m_speed;

    MaterialProperty m_emissionColor = null;
    MaterialProperty m_emissionMap = null;
    MaterialProperty m_emissionScrollSpeed = null;
    MaterialProperty m_emissionStrength = null;

    MaterialProperty m_emissiveBlinkMin = null;
    MaterialProperty m_emissiveBlinkMax = null;
    MaterialProperty m_emissiveBlinkVelocity = null;

    MaterialProperty m_emissiveScrollEnabled = null;
    MaterialProperty m_emissiveScrollDirection = null;
    MaterialProperty m_emissiveScrollWidth = null;
    MaterialProperty m_emissiveScrollVelocity = null;
    MaterialProperty m_emissiveScrollInterval = null;

    MaterialProperty m_Ramp = null;
    MaterialProperty m_lightingShadowStrength = null;
    MaterialProperty m_lightingShadowOffset = null;
    MaterialProperty m_lightingDirection = null;
    MaterialProperty m_forceLightDirection = null;
    MaterialProperty m_forceShadowStrength = null;
    MaterialProperty m_minBrightness = null;
    MaterialProperty m_maxDirectionalIntensity = null;
    MaterialProperty m_additiveRamp = null;
    MaterialProperty m_flatOrFullAmbientLighting = null;

    MaterialProperty m_specularMap = null;
    MaterialProperty m_specularColor = null;
    MaterialProperty m_hardSpecular = null;
    MaterialProperty m_specularBias = null;
    MaterialProperty m_gloss = null;
    MaterialProperty m_specularStrength = null;
    MaterialProperty m_specularSize = null;

    MaterialProperty m_rimColor = null;
    MaterialProperty m_rimWidth = null;
    MaterialProperty m_rimStrength = null;
    MaterialProperty m_rimSharpness = null;
    MaterialProperty m__rimLightColorBias = null;
    MaterialProperty m_rimTex = null;
    MaterialProperty m_rimTexPanSpeed = null;

    MaterialProperty m_stencilRef = null;
    MaterialProperty m_stencilOp = null;
    MaterialProperty m_stencilCompareFunction = null;

    MaterialProperty m_cullMode = null;
    MaterialProperty m_clip = null;
    MaterialProperty m_srcBlend = null;
    MaterialProperty m_dstBlend = null;
    MaterialProperty m_zTest = null;

    PoiToonHeader m_mainOptions;
    PoiToonHeader m_metallicOptions;
    PoiToonHeader m_matcapOptions;
    PoiToonHeader m_outlineOptions;
    PoiToonHeader m_emissionOptions;
    PoiToonHeader m_fakeLightingOptions;
    PoiToonHeader m_specularHighlightsOptions;
    PoiToonHeader m_stencilOptions;
    PoiToonHeader m_rimLightOptions;
    PoiToonHeader m_miscOptions;

    private void HeaderInit(MaterialEditor materialEditor)
    {
        m_mainOptions = new PoiToonHeader(materialEditor, "m_mainOptions");
        m_metallicOptions = new PoiToonHeader(materialEditor, "m_metallicOptions");
        m_matcapOptions = new PoiToonHeader(materialEditor, "m_matcapOptions");
        m_outlineOptions = new PoiToonHeader(materialEditor, "m_outlineOptions");
        m_emissionOptions = new PoiToonHeader(materialEditor, "m_emissionOptions");
        m_fakeLightingOptions = new PoiToonHeader(materialEditor, "m_fakeLightingOptions");
        m_specularHighlightsOptions = new PoiToonHeader(materialEditor, "m_specularHighlightsOptions");
        m_stencilOptions = new PoiToonHeader(materialEditor, "m_stencilOptions");
        m_rimLightOptions = new PoiToonHeader(materialEditor, "m_rimLightOptions");
        m_miscOptions = new PoiToonHeader(materialEditor, "m_miscOptions");
    }

    private void FindProperties(MaterialProperty[] props)
    {
        m_color = FindProperty("_Color", props);
        m_desaturation = FindProperty("_Desaturation", props);
        m_mainTex = FindProperty("_MainTex", props);
        m_normalMap = FindProperty("_NormalMap", props);
        m_normalIntensity = FindProperty("_NormalIntensity", props);

        m_cubeMap = FindProperty("_CubeMap", props);
        m_sampleWorld = FindProperty("_SampleWorld", props);
        m_additiveClearCoat = FindProperty("_AdditiveClearCoat", props);
        m_purelyAdditive = FindProperty("_PurelyAdditive", props);
        m_metallicMap = FindProperty("_MetallicMap", props);
        m_metallic = FindProperty("_Metallic", props);
        m_roughnessMap = FindProperty("_RoughnessMap", props);
        m_roughness = FindProperty("_Roughness", props);

        m_matcap = FindProperty("_Matcap", props);
        m_matcapMap = FindProperty("_MatcapMap", props);
        m_matcapColor = FindProperty("_MatcapColor", props);
        m_matcapStrength = FindProperty("_MatcapStrength", props);
        m_replaceWithMatcap = FindProperty("_ReplaceWithMatcap", props);
        m_multiplyMatcap = FindProperty("_MultiplyMatcap", props);
        m_addMatcap = FindProperty("_AddMatcap", props);

        m_lineWidth = FindProperty("_LineWidth", props);
        m_outlineColor = FindProperty("_LineColor", props);
        m_outlineEmission = FindProperty("_OutlineEmission", props);
        m_outlineTexture = FindProperty("_OutlineTexture", props);
        m_speed = FindProperty("_Speed", props);

        m_emissionColor = FindProperty("_EmissionColor", props);
        m_emissionMap = FindProperty("_EmissionMap", props);
        m_emissionScrollSpeed = FindProperty("_EmissionScrollSpeed", props);
        m_emissionStrength = FindProperty("_EmissionStrength", props);

        m_emissiveBlinkMin = FindProperty("_EmissiveBlink_Min", props);
        m_emissiveBlinkMax = FindProperty("_EmissiveBlink_Max", props);
        m_emissiveBlinkVelocity = FindProperty("_EmissiveBlink_Velocity", props);

        m_emissiveScrollEnabled = FindProperty("_ScrollingEmission", props);
        m_emissiveScrollDirection = FindProperty("_EmissiveScroll_Direction", props);
        m_emissiveScrollWidth = FindProperty("_EmissiveScroll_Width", props);
        m_emissiveScrollVelocity = FindProperty("_EmissiveScroll_Velocity", props);
        m_emissiveScrollInterval = FindProperty("_EmissiveScroll_Interval", props);

        m_Ramp = FindProperty("_Ramp", props);
        m_lightingShadowStrength = FindProperty("_ShadowStrength", props);
        m_lightingShadowOffset = FindProperty("_ShadowOffset", props);
        m_lightingDirection = FindProperty("_LightDirection", props);
        m_forceLightDirection = FindProperty("_ForceLightDirection", props);
        m_forceShadowStrength = FindProperty("_ForceShadowStrength", props);
        m_minBrightness = FindProperty("_MinBrightness", props);
        m_maxDirectionalIntensity = FindProperty("_MaxDirectionalIntensity", props);
        m_additiveRamp = FindProperty("_AdditiveRamp", props);
        m_flatOrFullAmbientLighting = FindProperty("_FlatOrFullAmbientLighting", props);

        m_specularMap = FindProperty("_SpecularMap", props);
        m_specularColor = FindProperty("_SpecularColor", props);
        m_gloss = FindProperty("_Gloss", props);
        m_specularStrength = FindProperty("_SpecularStrength", props);
        m_specularBias = FindProperty("_SpecularBias", props);
        m_hardSpecular = FindProperty("_HardSpecular", props);
        m_specularSize = FindProperty("_SpecularSize", props);

        m_rimColor = FindProperty("_RimLightColor", props);
        m_rimWidth = FindProperty("_RimWidth", props);
        m_rimStrength = FindProperty("_RimStrength", props);
        m_rimSharpness = FindProperty("_RimSharpness", props);
        m__rimLightColorBias = FindProperty("_RimLightColorBias", props);
        m_rimTex = FindProperty("_RimTex", props);

        m_stencilRef = FindProperty("_StencilRef", props);
        m_stencilOp = FindProperty("_StencilOp", props);
        m_stencilCompareFunction = FindProperty("_StencilCompareFunction", props);

        m_rimTexPanSpeed = FindProperty("_RimTexPanSpeed", props);
        m_cullMode = FindProperty("_Cull", props);
        m_clip = FindProperty("_Clip", props);
        m_srcBlend = FindProperty("_SourceBlend", props);
        m_dstBlend = FindProperty("_DestinationBlend", props);
        m_zTest = FindProperty("_ZTest", props);
    }

    private void SetupStyle()
    {
        m_sectionStyle = new GUIStyle(EditorStyles.boldLabel);
        m_sectionStyle.alignment = TextAnchor.MiddleCenter;
    }

    private void ToggleDefine(Material mat, string define, bool state)
    {
        if (state)
        {
            mat.EnableKeyword(define);
        }
        else
        {
            mat.DisableKeyword(define);
        }
    }

    void ToggleDefines(Material mat)
    {
    }

    void LoadDefaults(Material mat)
    {
    }

    void DrawHeader(ref bool enabled, ref bool options, GUIContent name)
    {
        var r = EditorGUILayout.BeginHorizontal("box");
        enabled = EditorGUILayout.Toggle(enabled, EditorStyles.radioButton, GUILayout.MaxWidth(15.0f));
        options = GUI.Toggle(r, options, GUIContent.none, new GUIStyle());
        EditorGUILayout.LabelField(name, m_sectionStyle);
        EditorGUILayout.EndHorizontal();
    }

    void DrawMasterLabel()
    {
        GUIStyle style = new GUIStyle(GUI.skin.label);
        style.richText = true;
        style.alignment = TextAnchor.MiddleCenter;

        EditorGUILayout.LabelField("<size=16><color=#008080>❤ Poiyomi Toon Shader V2.3.8 ❤</color></size>", style, GUILayout.MinHeight(18));
    }

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
        Material material = materialEditor.target as Material;

        HeaderInit(materialEditor);

        // map shader properties to script variables
        FindProperties(props);

        // set up style for the base look
        SetupStyle();
        // load default toggle values
        LoadDefaults(material);

        DrawMasterLabel();

        // main section
        m_mainOptions = PoiToonUI.Foldout("Main", m_mainOptions);
        if (m_mainOptions.getState())
        {
            EditorGUILayout.Space();

            materialEditor.ShaderProperty(m_color, Styles.Color);
            materialEditor.ShaderProperty(m_desaturation, Styles.Desaturation);
            materialEditor.ShaderProperty(m_mainTex, Styles.MainTex);
            materialEditor.ShaderProperty(m_normalMap, Styles.NormalMap);
            materialEditor.ShaderProperty(m_normalIntensity, Styles.NormalIntensity);
            materialEditor.ShaderProperty(m_clip, Styles.Clip);

            EditorGUILayout.Space();
        }

        m_metallicOptions = PoiToonUI.Foldout("Metallic", m_metallicOptions);
        if (m_metallicOptions.getState())
        {
            EditorGUILayout.Space();
            materialEditor.ShaderProperty(m_cubeMap, Styles.CubeMap);
            materialEditor.ShaderProperty(m_sampleWorld, Styles.SampleWorld);
            materialEditor.ShaderProperty(m_additiveClearCoat, Styles.AdditiveClearCoat);
            materialEditor.ShaderProperty(m_purelyAdditive, Styles.PurelyAdditive);
            materialEditor.ShaderProperty(m_metallicMap, Styles.MetallicMap);
            materialEditor.ShaderProperty(m_metallic, Styles.Metallic);
            materialEditor.ShaderProperty(m_roughnessMap, Styles.RoughnessMap);
            materialEditor.ShaderProperty(m_roughness, Styles.Roughness);
            EditorGUILayout.Space();
        }

        m_matcapOptions = PoiToonUI.Foldout("Matcap / Sphere Textures", m_matcapOptions);
        if (m_matcapOptions.getState())
        {
            EditorGUILayout.Space();
            materialEditor.ShaderProperty(m_matcap, Styles.Matcap);
            materialEditor.ShaderProperty(m_matcapMap, Styles.MatcapMap);
            materialEditor.ShaderProperty(m_matcapColor, Styles.MatcapColor);
            materialEditor.ShaderProperty(m_matcapStrength, Styles.MatcapStrength);
            materialEditor.ShaderProperty(m_replaceWithMatcap, Styles.ReplaceWithMatcap);
            materialEditor.ShaderProperty(m_multiplyMatcap, Styles.MultiplyMatcap);
            materialEditor.ShaderProperty(m_addMatcap, Styles.AddMatcap);
            EditorGUILayout.Space();
        }

        // outline section
        m_outlineOptions = PoiToonUI.Foldout("Outline", m_outlineOptions);
        if (m_outlineOptions.getState())
        {
            EditorGUILayout.Space();
            materialEditor.ShaderProperty(m_lineWidth, Styles.LineWidth);
            materialEditor.ShaderProperty(m_outlineColor, Styles.OutlineColor);
            materialEditor.ShaderProperty(m_outlineEmission, Styles.OutlineEmission);
            materialEditor.ShaderProperty(m_outlineTexture, Styles.OutlineTexture);
            materialEditor.ShaderProperty(m_speed, Styles.Speed);

            EditorGUILayout.Space();
        }

        // emissive section
        m_emissionOptions = PoiToonUI.Foldout("Emission", m_emissionOptions);
        if (m_emissionOptions.getState())
        {
            EditorGUILayout.Space();
            materialEditor.ShaderProperty(m_emissionColor, Styles.EmissionColor);
            materialEditor.ShaderProperty(m_emissionMap, Styles.EmissionMap);
            materialEditor.ShaderProperty(m_emissionScrollSpeed, Styles.EmissionScrollSpeed);
            materialEditor.ShaderProperty(m_emissionStrength, Styles.EmissionStrength);
            EditorGUILayout.Space();
            materialEditor.ShaderProperty(m_emissiveBlinkMin, Styles.EmissiveBlinkMin);
            materialEditor.ShaderProperty(m_emissiveBlinkMax, Styles.EmissiveBlinkMax);
            materialEditor.ShaderProperty(m_emissiveBlinkVelocity, Styles.EmissiveBlinkVelocity);
            EditorGUILayout.Space();
            materialEditor.ShaderProperty(m_emissiveScrollEnabled, Styles.EmissiveScrollEnabled);
            materialEditor.ShaderProperty(m_emissiveScrollDirection, Styles.EmissiveScrollDirection);
            materialEditor.ShaderProperty(m_emissiveScrollWidth, Styles.EmissiveScrollWidth);
            materialEditor.ShaderProperty(m_emissiveScrollVelocity, Styles.EmissiveScrollVelocity);
            materialEditor.ShaderProperty(m_emissiveScrollInterval, Styles.EmissiveScrollInterval);
            EditorGUILayout.Space();
        }

        // fake lighting
        m_fakeLightingOptions = PoiToonUI.Foldout("Fake Lighting", m_fakeLightingOptions);
        if (m_fakeLightingOptions.getState())
        {
            EditorGUILayout.Space();
            materialEditor.ShaderProperty(m_Ramp, Styles.LightingGradient);
            materialEditor.ShaderProperty(m_lightingShadowStrength, Styles.LightingShadowStrength);
            materialEditor.ShaderProperty(m_lightingShadowOffset, Styles.LightingShadowOffsett);
            materialEditor.ShaderProperty(m_forceLightDirection, Styles.ForceLightDirection);
            materialEditor.ShaderProperty(m_forceShadowStrength, Styles.ForceShadowStrength);
            materialEditor.ShaderProperty(m_lightingDirection, Styles.LightingDirection);
            materialEditor.ShaderProperty(m_minBrightness, Styles.MinBrightness);
            materialEditor.ShaderProperty(m_maxDirectionalIntensity, Styles.MaxDirectionalIntensity);
            materialEditor.ShaderProperty(m_flatOrFullAmbientLighting, Styles.FlatOrFullAmbientLighting);
            materialEditor.ShaderProperty(m_additiveRamp, Styles.AdditiveRamp);
            EditorGUILayout.Space();
        }

        // Specular Highlights
        m_specularHighlightsOptions = PoiToonUI.Foldout("Specular Highlight", m_specularHighlightsOptions);
        if (m_specularHighlightsOptions.getState())
        {
            EditorGUILayout.Space();
            materialEditor.ShaderProperty(m_specularMap, Styles.SpecularMap);
            materialEditor.ShaderProperty(m_gloss, Styles.Gloss);
            materialEditor.ShaderProperty(m_specularColor, Styles.SpecularColor);
            materialEditor.ShaderProperty(m_specularStrength, Styles.SpecularStrength);
            materialEditor.ShaderProperty(m_specularBias, Styles.SpecularBias);
            materialEditor.ShaderProperty(m_hardSpecular, Styles.HardSpecular);
            materialEditor.ShaderProperty(m_specularSize, Styles.SpecularSize);
            EditorGUILayout.Space();
        }

        // Rim Lighting
        m_rimLightOptions = PoiToonUI.Foldout("Rim Lighting", m_rimLightOptions);
        if (m_rimLightOptions.getState())
        {
            EditorGUILayout.Space();
            materialEditor.ShaderProperty(m_rimColor, Styles.RimColor);
            materialEditor.ShaderProperty(m_rimStrength, Styles.RimGlowStrength);
            materialEditor.ShaderProperty(m_rimSharpness, Styles.RimSharpness);
            materialEditor.ShaderProperty(m_rimWidth, Styles.RimWidth);
            materialEditor.ShaderProperty(m__rimLightColorBias, Styles.RimColorBias);
            materialEditor.ShaderProperty(m_rimTex, Styles.RimTexture);
            materialEditor.ShaderProperty(m_rimTexPanSpeed, Styles.RimTexturePanSpeed);
            EditorGUILayout.Space();
        }

        m_stencilOptions = PoiToonUI.Foldout("Stencil", m_stencilOptions);
        if (m_stencilOptions.getState())
        {
            EditorGUILayout.Space();

            materialEditor.ShaderProperty(m_stencilRef, Styles.StencilRef);
            materialEditor.ShaderProperty(m_stencilCompareFunction, Styles.StencilCompareFunction);
            materialEditor.ShaderProperty(m_stencilOp, Styles.StencilOp);

            EditorGUILayout.Space();
        }

        m_miscOptions = PoiToonUI.Foldout("Misc", m_miscOptions);
        if (m_miscOptions.getState())
        {
            EditorGUILayout.Space();

            materialEditor.ShaderProperty(m_cullMode, Styles.CullMode);
            materialEditor.ShaderProperty(m_srcBlend, Styles.SrcBlend);
            materialEditor.ShaderProperty(m_dstBlend, Styles.DstBlend);
            materialEditor.ShaderProperty(m_zTest, Styles.ZTest);

            EditorGUILayout.Space();
        }

        ToggleDefines(material);

        EditorGUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        PoiToon.linkButton(70, 20, "Github", "https://github.com/poiyomi/PoiyomiToonShader");
        GUILayout.Space(2);
        PoiToon.linkButton(70, 20, "Discord", "https://discord.gg/Ays52PY");
        GUILayout.Space(2);
        PoiToon.linkButton(70, 20, "Donate", "https://www.paypal.me/poiyomi");
        GUILayout.Space(2);
        PoiToon.linkButton(70, 20, "Patreon", "https://www.patreon.com/poiyomi");
        GUILayout.FlexibleSpace();
        EditorGUILayout.EndHorizontal();
    }
}
