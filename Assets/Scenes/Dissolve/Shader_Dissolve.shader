Shader "LovelyCatHyt/Dissolve"
{
	// 由于 VS 对 Shader 文件的代码块缩进惨不忍睹, 而手动调整非常无聊且费时, 
	// 在 2022-01-20 及之后的 Shader 不会再手动调整缩进, 请不要对奇怪的大括号感到迷惑
	
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

        Cull off // 双面!
    
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
            	
                // 懒得代入光照模型了, 就给个调色吧
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                return col;
            }
            ENDCG
        }
    }
}
