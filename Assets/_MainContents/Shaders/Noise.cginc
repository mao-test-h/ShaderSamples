#include "Random.cginc"

// ---------------------------------------------------------------
// ▼参考サイト
// ・【Unityシェーダ入門】シェーダで作るノイズ５種盛り
// http://nn-hokuson.hatenablog.com/entry/2017/01/27/195659

// BlockNoise
float block_noise(fixed2 st)
{
    //return floor(random(st));
    return random(floor(st));
}

// ValueNoise
float value_noise(fixed2 st)
{
    fixed2 p = floor(st);
    fixed2 f = frac(st);

    float v00 = random(p + fixed2(0 ,0));
    float v10 = random(p + fixed2(1 ,0));
    float v01 = random(p + fixed2(0 ,1));
    float v11 = random(p + fixed2(1 ,1));

    fixed2 u = f * f * (3.0 - 2.0 * f);

    float v0010 = lerp(v00, v10, u.x);
    float v0111 = lerp(v01, v11, u.x);
    return lerp(v0010, v0111, u.y);
}

// PerlinNoise
float perlin_noise(fixed2 st)
{
    fixed2 p = floor(st);
    fixed2 f = frac(st);
    fixed2 u = f * f * (3.0 - 2.0 * f);

    float v00 = random2(p + fixed2(0, 0));
    float v10 = random2(p + fixed2(1, 0));
    float v01 = random2(p + fixed2(0, 1));
    float v11 = random2(p + fixed2(1, 1));

    float x = lerp(dot(v00, f - fixed2(0, 0)), dot(v10, f - fixed2(1, 0)), u.x);
    float y = lerp(dot(v01, f - fixed2(0, 1)), dot(v11, f - fixed2(1, 1)), u.x);
    return lerp(x, y, u.y) + 0.5f;
}

// fBm
float fBm(fixed2 st)
{
    float f = 0;
    fixed2 q = st;

    f += 0.5000 * perlin_noise(q);
    q = q * 2.01;
    f += 0.2500 * perlin_noise(q);
    q = q * 2.02;
    f += 0.1250 * perlin_noise(q);
    q = q * 2.03;
    f += 0.0625 * perlin_noise(q);
    q = q * 2.01;

    return f;
}

// ---------------------------------------------------------------
// ▼参考サイト
// ・セルラーノイズ
// https://thebookofshaders.com/12/?lan=jp

// WorleyNoise
float4 worley_noise(float2 st)
{
    // セルのサイズ
    const float Size = 8;

    st *= Size;

    // 出力色
    float3 color = float3(0, 0, 0);
    // タイルの間隔
    float2 i_st = floor(st);
    float2 f_st = frac(st);
    // 最小距離の記録用
    float dist = 1.0;

    for(int y = -1; y <= 1; y++)
    {
        for(int x = -1; x <= 1; x++)
        {
            // 隣接するタイル
            float2 neighbor = float2(x, y);
            // 隣接するタイルの中のランダムな位置を取得(位置はアニメーションさせる)
            float2 p = 0.5 + 0.5 * sin(_Time.w + 6.2831 * random2(i_st + neighbor));
            // 点までの距離を計算して、最も近いものまでの距離をdistに記録
            dist = min(dist, length(neighbor + p - f_st));
        }
    }

    // 最小距離を描画
    color += dist;
    // セルの中央を描画
    color += 1.0 - step(0.02, dist);
    // グリッドを描画
    //color.x += step(0.98, f_st.x) + step(0.98, f_st.y);
    return float4(color, 1.0);
}
