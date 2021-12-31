## 基本效果
在 [HytStandardShader](HytStandardShader.shader) 中实现了一下效果:
- 漫反射
- 漫反射纹理, 法线纹理, 高光纹理采样(都包含纹理ST参数)
- 高光反射
## 研究体验
我本以为这是拿[别人的无纹理的漫反射和高光效果](https://github.com/csdjk/LearnUnityShader/tree/master/Assets/Scenes/LearnShader/LearnShader1/Shader)直接 Ctrl+CV 就完事, 后来发现法线的采样比想象中的复杂.


具体来说, 通过 `NORMAL` 语义在 vert 上获得的法线坐标是**模型空间**的, 而法线纹理通常是基于**切线空间**的. 这就导致无法直接读取法线纹理放进vert的输出, 而是需要保留切线等向量, 在计算最终法线时在切线空间进行一系列变换. 具体的实现是 [Unity Manual](https://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html) 的微调版本(*其实我也不知道这样改会不会耗更多的性能...?*), 对应的算法已在 Shader 中注释说明.

另一件有意思的事情是, `TEXCOORDx` 系列的语义除了可以存 uv 坐标之外, 还能存其它东西, 比如顶点的世界坐标, 在这之后这些蹭 `TEXCOORD` 语义的变量也自动进行了插值计算.