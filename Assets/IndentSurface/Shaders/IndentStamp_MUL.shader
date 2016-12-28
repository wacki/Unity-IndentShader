Shader "IndentSurface/IndentStamp_MUL" {

	Properties{
		_Scale("Scale", Range(0, 1)) = 0.5
	}

	SubShader {
		Tags {
			"Queue"="Transparent"
			"IgnoreProjector"="True"
			"RenderType"="Transparent"
			"PreviewType"="Plane"
		}
		Lighting Off Cull Off ZTest Always ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "IndentStampInc.cginc"

			uniform float _Scale;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 stamp = tex2D(_MainTex, i.texcoord);
				fixed4 surface = tex2D(_SurfaceTex, i.texcoord1);
				return surface * stamp * _Scale;
			}
			ENDCG
		}
	}
}
