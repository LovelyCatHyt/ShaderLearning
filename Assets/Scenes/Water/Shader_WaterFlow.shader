Shader "LovelyCatHyt/WaterFlow"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)					// ��ɫ
		_Norm("Normal", 2D) = "bump" {}						// ����
		_StackSize("Stack Size", float) = 4					// ����ѵ�����
		_Specular("Specular", Range(0, 1)) = 1				// �߹�
		[Power(10)]_Gloss("Gloss",Range(1,100)) = 1         // �����
		_SpeedX("SpeedX", float) = 0.05						// �ٶ�
		_SpeedY("SpeedY", float) = 0.05
		_UnstableScale("UnstableScale", float) = 0.1		// ���ȶ��˶��ı���
		//_Cube("Reflection Map", CUBE) = "" {}				// �ƺ�ֻ���������ܻ�ȡ������̽��
	}
	SubShader
	{
		// ˮ�浱Ȼ��͸����!
		Tags {"Queue" = "Transparent"}
		// �������Ӱ��ʲô
		LOD 100

		Pass
		{
			Tags { "LightMode" = "ForwardBase" }
			// ͸����Ϸ���
			Blend SrcAlpha OneMinusSrcAlpha
			
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
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float3 worldVertex : TEXCOORD2;
				half4 tangent : TANGENT;
			};

			float4 _Color;
			sampler2D _Norm;
			float4 _Norm_ST;
			float _StackSize;
			float _Specular;
			float _Gloss;
			float _SpeedX;
			float _SpeedY;
			float _UnstableScale;
			// samplerCUBE _Cube;
		
			v2f vert(const appdata v)
			{
				// ��ͨ������任
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldVertex = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.uv = TRANSFORM_TEX(v.uv, _Norm);
				o.normal = v.normal;
				o.tangent = v.tangent;
				return o;
			}

			fixed4 frag(const v2f i) : SV_Target
			{
				// �������� Norm
				const half3 norm1 = UnpackNormal(tex2D(_Norm, _StackSize * float2(i.uv.x + _SpeedX * _Time.y + _SinTime.y * _UnstableScale, i.uv.y)));
				const half3 norm2 = UnpackNormal(tex2D(_Norm, _StackSize * float2(i.uv.x, i.uv.y + _SpeedY * _Time.y + _CosTime.y*_UnstableScale)));
				const half3 norm = (norm1 + norm2) * 0.5;
				// ��ת��������ռ�
				half3 wNormal = UnityObjectToWorldNormal(i.normal);
				half3 wTangent = UnityObjectToWorldDir(i.tangent.xyz);
				const half tangentSign = i.tangent.w * unity_WorldTransformParams.w;
				half3 wBitangent = cross(wNormal, wTangent) * tangentSign;
				half3x3 tspace = transpose(half3x3(wTangent, wBitangent, wNormal));
				half3 worldNormal = mul(tspace, norm);
				// ���߷���
				const float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				// ������� (���ǲ�֪���õ��ĸ�ģ��)
				const fixed3 diffuse = _LightColor0.rgb * dot(worldNormal, lightDir);
				// ������
				const fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
				// �����ӷ���̽���л�ȡ
				const half3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldVertex);
				const half3 reflectDir = reflect(-viewDir, worldNormal);
				// ������ɫ
				const half4 specCubeVal = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, reflectDir);
				const fixed3 specular = DecodeHDR(specCubeVal, unity_SpecCube0_HDR).xyz * pow(max(dot(reflectDir, viewDir), 0), _Gloss) * _Specular;

				return fixed4(_Color.rgb * (diffuse + ambient + specular), _Color.a);
			}
		ENDCG
		}
	}
}
