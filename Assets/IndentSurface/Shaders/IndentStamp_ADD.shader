Shader "IndentSurface/IndentStamp_ADD" {

	Properties{
		_Scale("Scale", Range(-1, 1)) = -0.5
		_Offset("Offset", Range(-1, 1)) = -1
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
			#pragma multi_compile _ STEREO_INSTANCING_ON 
			#pragma multi_compile _ UNITY_SINGLE_PASS_STEREO
			
			#include "UnityCG.cginc"
			#include "IndentStampInc.cginc"

			uniform float _Scale;
			uniform float _Offset;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 stamp = tex2D(_MainTex, i.texcoord);
				fixed4 surface = tex2D(_SurfaceTex, i.texcoord1);
				return fixed4(surface.rgb + _Scale * (stamp.rgb + _Offset.rrr), stamp.a);
			}
			ENDCG
		}
	}
}
