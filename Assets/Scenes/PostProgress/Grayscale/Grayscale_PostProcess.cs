using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

// ��֪���������������, �ƺ���������˴����ͼ��/ģ��?
[Serializable]
[PostProcess(typeof(Grayscale_PostProcessRenderer), PostProcessEvent.AfterStack, "LovelyCatHyt/Grayscale")]
public sealed class Grayscale_PostProcess : PostProcessEffectSettings
{
    [Range(0f, 1f), Tooltip("Grayscale effect intensity.")]
    public FloatParameter blend = new FloatParameter { value = 0.5f };
}

public sealed class Grayscale_PostProcessRenderer : PostProcessEffectRenderer<Grayscale_PostProcess>
{
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("LovelyCatHyt/Grayscale"));
        sheet.properties.SetFloat("_Blend", settings.blend);
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}