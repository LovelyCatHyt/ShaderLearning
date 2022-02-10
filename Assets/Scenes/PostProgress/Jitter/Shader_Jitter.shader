Shader "LovelyCatHyt/Jitter"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_HMoveStrength("Horizontal Move Strength", float) = 0.01
		_HMoveHeight("Horizontal Move Height", float) = 0.5
	}
		SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;
			float _HMoveStrength;
			float _HMoveHeight;

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col;
				// 验证性的效果就做个简单点的, 因为更复杂的效果可能需要额外的噪声贴图
				if(i.uv.y <= _HMoveHeight)
				{
					col = tex2D(_MainTex, i.uv + float2(_HMoveStrength, 0));
				}else
				{
					col = tex2D(_MainTex, i.uv);
				}
			return col;
		}
		ENDCG
	}
	}
}
