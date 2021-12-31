Shader "LovelyCatHyt/StandardShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}	// ������
		_Diffuse("Diffuse", float) = 1          // ������ֵ
		_Norm("Normal", 2D) = "bump" {}			// ����
		_Specular("Specular", 2D) = "white" {}  // �߹�
		[Power(10)]_Gloss("Gloss",Range(1,100)) = 1         // �����
	}
		SubShader
		{
			// ����ѡ��
			Tags {"RenderType" = "Opaque"}
			// �������Ӱ��ʲô
			LOD 100

			Pass
			{
				Tags { "LightMode" = "ForwardBase" }
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				// Unity ��һЩ���ú�
				#include "UnityCG.cginc"
				// �������
				#include "Lighting.cginc"
				
				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
					half3 normal : NORMAL;
					half4 tangent : TANGENT;
				};

				struct v2f
				{
					half3 normal : NORMAL;
					float4 uv : TEXCOORD0;
					float2 uv_spec : TEXCOORD1;
					float4 vertex : SV_POSITION;
					float3 worldVertex : TEXCOORD2;
					half4 tangent : TANGENT;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float _Diffuse;
				sampler2D _Norm;
				float4 _Norm_ST;
				sampler2D _Specular;
				float4 _Specular_ST;
				float _Gloss;

				v2f vert(const appdata v)
				{
					// ��ͨ������任
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.worldVertex = mul(unity_ObjectToWorld, v.vertex).xyz;
					// �������ʹ�� _MainTex_ST ��ִ��ǰ�ڵ�һЩ����ƫ��, ��Щ����Ҳ����ʾ�ڲ���������϶�Ӧ�����������
					o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
					o.uv.zw = TRANSFORM_TEX(v.uv, _Norm);
					o.uv_spec = TRANSFORM_TEX(v.uv, _Specular);
					o.normal = v.normal;
					o.tangent = v.tangent;
					return o;
				}

				fixed4 frag(const v2f i) : SV_Target
				{
					// ����MainTex
					const fixed4 col = tex2D(_MainTex, i.uv.xy);
				// ����Norm��ת��������ռ�
				const half3 norm = UnpackNormal(tex2D(_Norm, i.uv.zw));
				half3 wNormal = UnityObjectToWorldNormal(i.normal);
				half3 wTangent = UnityObjectToWorldDir(i.tangent.xyz);
				const half tangentSign = i.tangent.w * unity_WorldTransformParams.w;
				half3 wBitangent = cross(wNormal, wTangent) * tangentSign;
				half3x3 tspace = transpose(half3x3(wTangent, wBitangent, wNormal));
				half3 worldNormal = mul(tspace, norm);
				// ���߷���
				const float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				// ������� (���ǲ�֪���õ��ĸ�ģ��)
				const fixed3 diffuse = _LightColor0.rgb * (dot(worldNormal, lightDir) * 0.5 + 0.5);
				// ������
				const fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
				// �����
				const half3 reflectDir = reflect(-lightDir, worldNormal);
				const half3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldVertex);
				// ������ɫ
				const fixed3 specular = _LightColor0.rgb * pow(max(dot(reflectDir, viewDir), 0), _Gloss) * tex2D(_Specular, i.uv_spec);
				
				return fixed4(col * (diffuse + ambient + specular), 1);
			}
			ENDCG
		}
		}
}
