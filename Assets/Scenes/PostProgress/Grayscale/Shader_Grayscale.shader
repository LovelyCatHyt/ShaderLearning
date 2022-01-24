Shader "LovelyCatHyt/Grayscale"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    	_Blend ("Blend", float) = 0.5
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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float _Blend;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                // grayscale
                fixed3 grayscale = dot(col.rgb, fixed3(0.2126729, 0.7151522, 0.0721750));
                return fixed4(lerp(col, grayscale, _Blend), col.a);
            }
            ENDCG
        }
    }
}
