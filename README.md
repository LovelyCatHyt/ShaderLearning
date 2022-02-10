# ShaderLearning

Shader 的学习项目, 用于学习 Shader.

## 项目结构

- [Assets/Prefabs](Assets/Prefabs) 一些随便摆的场景来验证某些反射/折射相关的 Shader
- [Assets/Scenes](Assets/Scenes) 各个场景, 每个场景是某个主题下的一系列 Shader 的展示
  - [标准Shader](Assets/Scenes/StandardShader/) 构建一个标准的~~最简单的~~光照模型
  - [描边Shader](Assets/Scenes/Outline/) 两种基本的描边实现
  - ~~[素描风Shader](Assets/Scenes/Sketch/) 一个失败的素描风Shader~~
  - [水波Shader](Assets/Scenes/Water) 比较拉胯但勉强能用的水波渲染
  - [溶解Shader](Assets/Scenes/Dissolve/Readme.md) 用一个特制的噪声纹理和clip函数实现溶解效果
  - [后处理](Assest/sce/../../Assets/Scenes/PostProgress/Readme.md) 各种比较常见的后处理效果

##  小目标

- [x] 一个比较标准的简单的光照模型
- [x] 描边
  - [x] 法线外扩
  - [x] 菲涅尔
- ~~[Failed] 素描风格渲染~~
- [ ] 动画系列
  - [x] 水波
  - [x] 溶解/消散/破裂
- [ ] 后处理
  - [x] 后处理入门: 灰度
  - [x] 画面抖动
  - [x] 色散

## 参考资料
感谢前辈的示例和指导
部分代码直接从该库中复制, 并根据具体情况修改了一些内容.

https://github.com/csdjk/LearnUnityShader
