Shader "LovelyCatHyt/Shader_Sketch"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1, 1, 1, 1)
		_LightStrengthMap("LightStrengthMap", 2D) = "white" {}
		_BaseColor("Base Color", Color) = (0, 0, 0, 0)
		_Gloss("Gloss", float) = 0.5
		_Specular("Specular", Range(0, 1)) = 0.5
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
			#include "Lighting.cginc"

			//顶点着色器输入结构体
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv :		TEXCOORD0;
				float3 normal:	NORMAL;
			};
			//顶点着色器输出结构体
			struct v2f
			{
				float4 vertex :			SV_POSITION;
				float2 uv :				TEXCOORD0;
				float3 worldNormalDir :	COLOR0;
				float3 worldPos :		COLOR1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _LightStrengthMap;
			float4 _BaseColor;
			float4 _Color;
			float _Gloss;
			float _Specular;
			// 普通的顶点变换
			v2f vert(appdata v)
			{
				v2f o;
				o.uv = v.uv;
				o.worldNormalDir = mul(v.normal, (float3x3) unity_WorldToObject);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				const fixed4 col = tex2D(_MainTex, i.uv);
				const fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * _Color.xyz;
				const float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				const float3 normalDir = normalize(i.worldNormalDir);
				const fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				//半兰伯特模型
				const fixed lambert = 0.5 * dot(normalDir, worldLightDir) + 0.5;
				const fixed3 diffuse = lambert * _Color.xyz * _LightColor0.xyz + ambient;
				// 高光
				const half3 reflectDir = reflect(-worldLightDir, normalDir);
				const fixed3 specular = _LightColor0.rgb * pow(max(dot(reflectDir, viewDir), 0), _Gloss) * _Specular;

				fixed3 result = diffuse * col.xyz + specular;


				// 使用光强映射图作为颜色的系数
				float lightStrength = tex2D(_LightStrengthMap, float2(max(max(result.r, result.g), result.b), 0.5));
				result = result * lightStrength + (1 - lightStrength) * _BaseColor;
				// result = result * tex2D(_LightStrengthMap, float2(result.x, 0.5));

				return float4(result,1);
			}
			ENDCG
		}
	}
}
