Shader "LovelyCatHyt/Dissolve"
{
	// ���� VS �� Shader �ļ��Ĵ���������Ҳ��̶�, ���ֶ������ǳ������ҷ�ʱ, 
	// �� 2022-01-20 ��֮��� Shader �������ֶ���������, �벻Ҫ����ֵĴ����Ÿе��Ի�
	
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    	_Color ("Color", Color) = (1,1,1,1)
    	_Noise ("Noise", 2D) = "white" {}
    	_Threshold ("Threshold", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Cull off // ˫��!
    
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
            fixed4 _Color;
            float4 _MainTex_ST;
            sampler2D _Noise;
            float _Threshold;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float cut_out = tex2D(_Noise, i.uv);
            	clip(cut_out - _Threshold);
            	
                // ���ô������ģ����, �͸�����ɫ��
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                return col;
            }
            ENDCG
        }
    }
}
