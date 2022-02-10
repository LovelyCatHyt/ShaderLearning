using System;
using CSDJK;
using UnityEngine;
using Random = UnityEngine.Random;

public class Jitter_Mono : PostProcessBase
{
    [Range(0, 1)] public float hMoveHeight = 0.5f;
    [Range(0, 1)] public float hMoveStrength = 0.01f;
    [Min(0)] public float swapSpeed;
    [Range(0, 1)] public float maxHMove;
    private Shader _jitterShader;
    private Material _material;
    private static readonly int HMoveStrength = Shader.PropertyToID("_HMoveStrength");
    private static readonly int HMoveHeight = Shader.PropertyToID("_HMoveHeight");
    private Material JitterMaterial => _material ??= CheckShaderOrCreateMaterial(_jitterShader, _material);

    private void Awake()
    {
        _jitterShader = Shader.Find("LovelyCatHyt/Jitter");
    }

    private void Update()
    {
        // 简单的扫描+随机抖动幅度
        hMoveHeight += Time.deltaTime * swapSpeed;
        hMoveHeight %= 1;
        hMoveStrength = Random.Range(-maxHMove, maxHMove);

    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        JitterMaterial.SetFloat(HMoveHeight, hMoveHeight);
        JitterMaterial.SetFloat(HMoveStrength, hMoveStrength);
        Graphics.Blit(src, dest, JitterMaterial);
    }
}
