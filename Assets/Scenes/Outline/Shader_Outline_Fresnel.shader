// Copied from https://github.com/csdjk/LearnUnityShader/blob/master/Assets/Scenes/OutLine/Fresnel/Outline_Fresnel.shader
//--------------------------- ����ߡ� - �������������ڷ������ӽǼн�---------------------
Shader "lcl/OutLine/Fresnel/outline_Fresnel"
{
	//---------------------------�����ԡ�---------------------------
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color("Color",Color) = (1,1,1,1)
			// ���ǿ��
			_FresnelPower("Fresnel Power",Range(0,10)) = 1
			_FresnelScale("Fresnel Power",Range(0,1)) = 1
			// �����ɫ
			_OutlineColor("Outline Color",Color) = (1,1,1,1)
	}
	SubShader
	{
		//��Ⱦ����
		Tags{
			"Queue" = "Transparent"
		}
		Blend SrcAlpha OneMinusSrcAlpha
		Pass
		{
			// ------------------------��CG���롿---------------------------
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			//������ɫ������ṹ��
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal:NORMAL;
			};
			//������ɫ������ṹ��
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 worldNormalDir:COLOR0;
				float3 worldPos:COLOR1;
			};

			// ------------------------��������ɫ����---------------------------
			v2f vert(appdata v)
			{
				v2f o;
				o.uv = v.uv;
				o.worldNormalDir = mul(v.normal,(float3x3) unity_WorldToObject);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			// ------------------------������������---------------------------
			sampler2D _MainTex;
			float4 _MainTex_TexelSize;
			float4 _Color;
			float _FresnelPower;
			float _FresnelScale;
			float4 _OutlineColor;
			// ------------------------��ƬԪ��ɫ����---------------------------
			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * _Color.xyz;
				float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				float3 normaleDir = normalize(i.worldNormalDir);
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				//��������ģ��
				fixed3 lambert = 0.5 * dot(normaleDir, worldLightDir) + 0.5;
				fixed3 diffuse = lambert * _Color.xyz * _LightColor0.xyz + ambient;
				fixed3 result = diffuse * col.xyz;

				// ������
				// float fresnel = pow(1 - saturate(dot(viewDir,normaleDir)),_FresnelPower);
				fixed fresnel = _FresnelScale + (1 - _FresnelScale) * pow(1 - dot(viewDir, normaleDir), _FresnelPower);

				result = lerp(result,_OutlineColor,fresnel);

				return float4(result,1);
			}
			ENDCG
		}
	}
}