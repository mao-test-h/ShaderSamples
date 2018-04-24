// WorlryNoise単体
Shader "Custom/Samples/NoiseTest"
{
    CGINCLUDE
    #include "UnityCG.cginc"
    #include "../Noise.cginc"

    float4 frag(v2f_img i) : SV_Target
    {
        // BlockNoise
        //return block_noise(i.uv * 32);

        // ValueNoise
        //return value_noise(i.uv * 32);

        // Perlinnoise
        //return perlin_noise(i.uv * 32);

        // fBm
        //return fBm(i.uv * 32);

        // WorleyNoise
        return worley_noise(i.uv);
    }

    ENDCG

    SubShader
    {
        Cull Off
        ZWrite Off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            ENDCG
        }
    }
}
