// copied and modified from https://github.com/csdjk/LearnUnityShader/blob/master/Assets/Scripts/PostEffectsbase.cs
using UnityEngine;

namespace CSDJK
{
    /// <summary>
    /// 后处理的基类, 可以复用检查 Shader 和创建材质的方法
    /// </summary>
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    public class PostProcessBase : MonoBehaviour
    {

        // Called when need to create the material used by this effect
        protected Material CheckShaderOrCreateMaterial(Shader shader, Material material)
        {
            if (shader == null)
            {
                // Debug.Log("shader is null");
                return null;
            }

            if (shader.isSupported && material && material.shader == shader)
            {
                return material;
            }

            if (!shader.isSupported)
            {
                Debug.Log($"Shader \"{shader.name}\" is not supported.");
                return null;
            }
            else
            {
                material = new Material(shader) {hideFlags = HideFlags.DontSave};
                return material ? material : null;
            }
        }
    }
}
