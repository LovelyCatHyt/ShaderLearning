Shader "LovelyCatHyt/Dispersion"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Center("Center", vector) = (0.5, 0.5, 0, 0)
		_Strength("Strength", float) = 0
	}
		SubShader
		{
			// No culling or depth
			Cull Off ZWrite Off ZTest Always

			Pass
			{
				CGPROGRAM
				//vert_img 在 UnityCG.cginc 中内置的
				#pragma vertex vert_img
				#pragma fragment frag

				#include "UnityCG.cginc"

				sampler2D _MainTex;
				float4 _Center;
				float _Strength;

				fixed4 frag(v2f_img i) : SV_Target
				{
					const float sampleCount = 32;
					const float inv_sampleCount = 1 / sampleCount;
					// 从中心指向外面的方向乘上强度
					const float2 dir_Mul_Strength = (i.uv - _Center.xy) * _Strength;
					fixed3 col = 0;
					fixed g = tex2D(_MainTex, i.uv).g;
					// 均匀采样五次
					for (float j = 0; j < sampleCount; j++)
					{
						fixed r = tex2D(_MainTex, i.uv - dir_Mul_Strength * j).r;
						fixed b = tex2D(_MainTex, i.uv + dir_Mul_Strength * j).b;
						col += fixed3(r, g, b);
					}
					col *= inv_sampleCount;
					return fixed4(col, 1);
				}
				ENDCG
			}
		}
}
