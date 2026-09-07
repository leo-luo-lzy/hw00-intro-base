#version 300 es

precision highp float;

uniform vec4 u_Color;

in vec4 fs_Nor;
in vec4 fs_LightVec;
in vec4 fs_Col;
in vec4 fs_Pos;

out vec4 out_Col;

float hash31(vec3 p)
{
    return fract(sin(dot(p, vec3(127.1, 311.7, 74.7)))* 43758.5453);
}

vec3 randomGradient3D(vec3 p)
{
    float r = sin(dot(p, vec3(12.9898, 78.233, 37.719))) * 43758.5453;

    float phi = r * 2.0 * 3.14159;
    float theta = r * 157.0;

    float x = cos(phi) * sin(theta);
    float y = sin(phi) * sin(theta);
    float z = cos(theta);

    return vec3(x, y, z);
}

float perlin3D(vec3 p)
{
    vec3 i = floor(p);
    vec3 f = fract(p);

    vec3 g000 = randomGradient3D(i + vec3(0.0, 0.0, 0.0));
    vec3 g100 = randomGradient3D(i + vec3(1.0, 0.0, 0.0));
    vec3 g010 = randomGradient3D(i + vec3(0.0, 1.0, 0.0));
    vec3 g110 = randomGradient3D(i + vec3(1.0, 1.0, 0.0));

    vec3 g001 = randomGradient3D(i + vec3(0.0, 0.0, 1.0));
    vec3 g101 = randomGradient3D(i + vec3(1.0, 0.0, 1.0));
    vec3 g011 = randomGradient3D(i + vec3(0.0, 1.0, 1.0));
    vec3 g111 = randomGradient3D(i + vec3(1.0, 1.0, 1.0));

    float v000 = dot(g000, f - vec3(0.0, 0.0, 0.0));
    float v100 = dot(g100, f - vec3(1.0, 0.0, 0.0));
    float v010 = dot(g010, f - vec3(0.0, 1.0, 0.0));
    float v110 = dot(g110, f - vec3(1.0, 1.0, 0.0));

    float v001 = dot(g001, f - vec3(0.0, 0.0, 1.0));
    float v101 = dot(g101, f - vec3(1.0, 0.0, 1.0));
    float v011 = dot(g011, f - vec3(0.0, 1.0, 1.0));
    float v111 = dot(g111, f - vec3(1.0, 1.0, 1.0));

    vec3 u = f * f * f * (
        f * (f * 6.0 - 15.0) + 10.0
    );

    float mix00 = mix(v000, v100, u.x);
    float mix10 = mix(v010, v110, u.x);
    float mix01 = mix(v001, v101, u.x);
    float mix11 = mix(v011, v111, u.x);

    float mix0 = mix(mix00, mix10, u.y);
    float mix1 = mix(mix01, mix11, u.y);

    return mix(mix0, mix1, u.z);
}

void main()
{
    float noiseValue = perlin3D(fs_Pos.xyz * 5.0);

    float pattern = clamp(0.5 + 0.5 * noiseValue, 0.0, 1.0);
    pattern = smoothstep(0.4, 0.6, pattern);

    vec3 darkColor = u_Color.rgb * 0.15;
    vec3 lightColor = u_Color.rgb;

    vec3 diffuseColor = mix(
        darkColor,
        lightColor,
        pattern
    );

    float diffuseTerm = max(dot(normalize(fs_Nor.xyz),normalize(fs_LightVec.xyz)),0.0);

    float ambientTerm = 0.2;

    float lightIntensity = ambientTerm + diffuseTerm;

    out_Col = vec4(diffuseColor.rgb * lightIntensity, 1.0);
}
