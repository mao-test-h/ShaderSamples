// WorleyNoiseを極座標系で表示調整
Shader "Custom/Samples/PolarCoordinateWorleyNoise"
{
    CGINCLUDE
    #include "UnityCG.cginc"
    #include "../Noise.cginc"

    float4 polar_coordinate_worley_noise(float2 uv)
    {
        float time = _Time.z;
        float2 st = 0.5 - uv;
        float a = atan2(st.y, st.x);

        float _distance = worley_noise(st).x;
        float _radius = length(st);

        float4 color = float4(0, 0, 0, 1);
        float s = step(_radius, _distance);
        color = lerp(color, float4(1, 1, 1, 1), s);

        return color;
    }

    float4 frag(v2f_img i) : SV_Target
    {
        return polar_coordinate_worley_noise(i.uv);
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
