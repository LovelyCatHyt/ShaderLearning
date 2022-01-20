# 溶解效果
采样一张噪声图, 减去一个阈值, 然后使用clip函数就神奇地把小于0的像素给剔除掉了, 效果类似于透明度测试.

除了能实现溶解效果, 还提供了一个动态镂空物体的思路, 前提是实现了某种动态生成遮罩的 Shader 或脚本.

用的噪声贴图来自[csdjk的库](https://github.com/csdjk/LearnUnityShader/blob/master/Assets/Textures/Noise/FoamCaustics.png): 
![腐蚀剂泡沫](../../Textures/FoamCaustics.png)

*ps: 理论上动画脚本很好做, 但作为新的比较独立的知识还是收集起来在另一个单独的场景里做, 这里就手动拖材质球数值吧XD*