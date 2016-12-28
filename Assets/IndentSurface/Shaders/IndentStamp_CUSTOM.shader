Shader "IndentSurface/IndentStamp_CUSTOM" {
	
	Properties {
		_Scale("Scale", Range(0, 1)) = 0.2
		_HeightOffset("Stamp Height OFfset", Range(0, 1)) = 0.7
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
			uniform float _HeightOffset;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 stamp = tex2D(_MainTex, i.texcoord);
				fixed4 surface = tex2D(_SurfaceTex, i.texcoord1);
				float buildUp = clamp(stamp.r - _HeightOffset, 0, 1);
				float indent = clamp(stamp.r - _HeightOffset, -1, 0);
				return fixed4(surface.rgb + surface.rgb * buildUp + indent.rrr * _Scale, stamp.a);
			}
			ENDCG
		}
	}
}
