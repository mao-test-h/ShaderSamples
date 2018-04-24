float random(fixed2 p) 
{ 
    return frac(sin(dot(p, fixed2(12.9898,78.233))) * 43758.5453);
}

float2 random2(fixed2 st)
{
    st = fixed2(dot(st, fixed2(127.1, 311.7)),
                dot(st, fixed2(269.5, 183.3)));
    return -1.0 + 2.0 * frac(sin(st) * 43758.5453123);
}
