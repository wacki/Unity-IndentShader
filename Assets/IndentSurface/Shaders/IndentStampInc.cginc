#ifndef INDENT_STAMP_SHARED
#define INDENT_STAMP_SHARED

uniform sampler2D _MainTex;
uniform sampler2D _SurfaceTex;
uniform float4 _SourceTexCoords;

struct appdata_t {
	float4 vertex : POSITION;
	float2 texcoord : TEXCOORD0;
}; 

struct v2f {
	float4 vertex : SV_POSITION;
	float2 texcoord : TEXCOORD0;
	float2 texcoord1 : TEXCOORD1;
};

v2f vert (appdata_t v)
{
	v2f o;
	UNITY_SETUP_INSTANCE_ID(v);
	UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
	o.vertex = UnityObjectToClipPos(v.vertex);
	o.texcoord = v.texcoord,_MainTex;
	o.texcoord1 = _SourceTexCoords.xy + v.texcoord * _SourceTexCoords.zw;
	return o;
}

#endif //