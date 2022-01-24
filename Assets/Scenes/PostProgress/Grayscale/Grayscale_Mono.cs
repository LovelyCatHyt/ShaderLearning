using System;
using CSDJK;
using UnityEngine;

public class Grayscale_Mono : PostProcessBase
{
    [Range(0, 1)] public float blend = 0.5f;

    private Shader _grayscaleShader;
    private Material _material;
    private static readonly int BlendProperty = Shader.PropertyToID("_Blend");
    private Material GrayscaleMaterial => _material ??= CheckShaderOrCreateMaterial(_grayscaleShader, _material);



    private void Awake()
    {
        _grayscaleShader = Shader.Find("LovelyCatHyt/Grayscale");
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        GrayscaleMaterial.SetFloat(BlendProperty, blend);
        Graphics.Blit(src, dest, GrayscaleMaterial);
    }
}
