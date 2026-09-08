#version 300 es

uniform mat4 u_Model;

uniform mat4 u_ModelInvTr;

uniform mat4 u_ViewProj;

uniform float u_Time;

in vec4 vs_Pos;

in vec4 vs_Nor;

in vec4 vs_Col;

out vec4 fs_Nor;
out vec4 fs_LightVec;
out vec4 fs_Col;
out vec4 fs_Pos;
out vec3 fs_WorldPos;

const vec4 lightPos = vec4(5, 5, 3, 1);

void main()
{
    fs_Col = vs_Col;
    fs_Pos = vs_Pos;

    float scaleY = 1.0 + 0.35 * sin(u_Time*3.0);
    float scaleXZ = inversesqrt(scaleY);
    vec3 scale = vec3(scaleXZ, scaleY, scaleXZ);

    vec3 orig = vec3(0.0, -1.0, 0.0);
    vec3 newPos = orig + (vs_Pos.xyz - orig) * scale;

    float angle =  0.45*sin(u_Time*2.0)*(vs_Pos.y+1.0);
    float c = cos(angle);
    float s = sin(angle);

    newPos.xz = vec2(c*newPos.x - s*newPos.z, s*newPos.x + c*newPos.z);

    vec3 newNor = vs_Nor.xyz / scale;

    mat3 invTranspose = mat3(u_ModelInvTr);
    fs_Nor = vec4(invTranspose * vec3(newNor), 0);

    vec4 modelposition = u_Model * vec4(newPos, 1.0);
    fs_WorldPos = modelposition.xyz;
    fs_LightVec = lightPos - modelposition;
    gl_Position = u_ViewProj * modelposition;
}
