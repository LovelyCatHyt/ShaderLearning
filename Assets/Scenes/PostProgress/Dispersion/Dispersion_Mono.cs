using System;
using CSDJK;
using UnityEngine;
using Random = UnityEngine.Random;

public class Dispersion_Mono : PostProcessBase
{
    public Vector2 center = new Vector2(.5f, .5f);
    [Min(0)] public float strength = .1f;
    private Shader _dispersionShader;
    private Material _material;
    private static readonly int Center = Shader.PropertyToID("_Center");
    private static readonly int Strength = Shader.PropertyToID("_Strength");
    private Material DispersionMaterial => _material ??= CheckShaderOrCreateMaterial(_dispersionShader, _material);

    private void Awake()
    {
        _dispersionShader = Shader.Find("LovelyCatHyt/Dispersion");
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        DispersionMaterial.SetVector(Center, center);
        DispersionMaterial.SetFloat(Strength, strength);
        Graphics.Blit(src, dest, DispersionMaterial);
    }
}