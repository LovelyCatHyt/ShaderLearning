Shader "LovelyCatHyt/Outline"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_OutlineStrength("Outline Strength", Range(0, 1)) = 0.05
			// 描边颜色
			_Color("lineColor",Color) = (1,1,1,1)
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

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

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				// 只贴图 不算光照
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}

		// ------------------------【描边通道】---------------------------
		 Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Front
			ZWrite Off
			Offset[_OffsetFactor],[_OffsetUnits] // 这是什么?

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#define _USE_SMOOTH_NORMAL_ON 0

			struct appdata
			{
				float4 vertex : POSITION;
				// float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
			};

			struct v2f
			{
				// float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			float _OutlineStrength;
			float4 _Color;

			v2f vert(appdata v)
			{
				v2f o;
				//顶点沿着法线方向扩张

				// 使用平滑的法线计算
				// v.vertex.xyz += normalize(v.tangent.xyz) * _OutlineStrength;       // 为什么用切线?
				// 使用自带的法线计算
				// v.vertex.xyz += normalize(v.normal) * _OutlineStrength * 0.7;   // 0.7 哪来的
				// 
				// o.vertex = UnityObjectToClipPos(v.vertex);

				// 如果需要使描边线不随Camera距离变大而跟着变小，就需要变换到ndc空间
				float3 normalDir = normalize(v.normal.xyz);
				float4 pos = UnityObjectToClipPos(v.vertex);
				float3 viewNormal = mul((float3x3)UNITY_MATRIX_IT_MV, normalDir);
				float3 ndcNormal = normalize(TransformViewToProjection(viewNormal.xyz)) * pos.w;//将法线变换到NDC空间
				pos.xy += _OutlineStrength * ndcNormal.xy;
				o.vertex = pos;
			   return o;
		   }
		   fixed4 frag(v2f i) : SV_Target
		   {
			   return _Color;
		   }

		   ENDCG
	   }
	}
}
