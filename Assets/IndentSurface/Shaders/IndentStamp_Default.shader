Shader "IndentSurface/IndentStamp_Default" {
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

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 stamp = tex2D(_MainTex, i.texcoord);
				return stamp;
			}
			ENDCG
		}
	}
}
