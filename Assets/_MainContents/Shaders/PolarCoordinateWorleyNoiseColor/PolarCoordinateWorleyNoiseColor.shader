// PolarCoordinateWorleyNoise.shaderに適当に色つけてみたやつ
Shader "Custom/Samples/PolarCoordinateWorleyNoiseColor"
{
    CGINCLUDE
    #include "UnityCG.cginc"
    #include "../Noise.cginc"

    float4 polar_coordinate_worley_noise_color(float2 uv)
    {
        float time = _Time.z;
        float2 st = 0.5 - uv;
        float a = atan2(st.y, st.x);

        float _distance = worley_noise(st).x;
        float _radius = length(st);

        float4 color = lerp(0.8, float4(0, 0.4, 1, 1), uv.y);
        float s = step(_radius, _distance);
        color = lerp(color, lerp(float4(0, 0.3, 1, 1), 0, worley_noise(st).x), s);

        return color;
    }

    float4 frag(v2f_img i) : SV_Target
    {
        return polar_coordinate_worley_noise_color(i.uv);
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
