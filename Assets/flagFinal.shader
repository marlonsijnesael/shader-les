
Shader "Flag/flagFinal" {
	Properties{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_WaveSpeed("Wave speed", Range(0, 5.0)) = 1
		_WaveIntensity("wave intensity", Range(0, 5.0)) = 1
		_WaveHeight("wave height", Range(0, 5.0)) = 1
		_Cutoff("Alpha cutoff", Range(0, 5.0)) = 1
	}
		SubShader{
		Tags{ "RenderType" = "Opaque" "LightMode" = "ForwardBase" } 
		Cull off

		Pass{

		CGPROGRAM

		//added vertext:vert addshadow to do a shadow pass on the deformed vertices
		#pragma vertex vert  Standard fullforwardshadows vertex:vert addshadow	
		#pragma fragment frag

		#include "UnityCG.cginc"


			//passing properties as variables
			float _Cutoff;
			float _WaveHeight;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _WaveSpeed;
			float _WaveIntensity;
			
			//float to calculate vertex deformation
			//using a sinoid movement over Time to create a wave-like movement and then amplify it by using the wave height
			float wavesCalculated(float vertex) {
				return sin((vertex + _Time.y * _WaveSpeed) * _WaveIntensity) * _WaveHeight;
			}

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				half3 worldNormal : TEXCOORD1;
			};


			v2f vert(appdata_base v, float3 normal : NORMAL)
			{
				v2f o;

				//add waveCalculated float mentioned above
				v.vertex.y += wavesCalculated(v.vertex.x);
				
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.worldNormal = UnityObjectToWorldNormal(normal);
				return o;
			}

			fixed4 frag(v2f i, fixed facing : VFACE) : SV_Target
			{	 
				//attempt at smoothing the edges..
				fixed4 col = tex2D(_MainTex, i.uv);
				col.a = (col.a - _Cutoff) / max(fwidth(col.a), 5) + 0.5;
				return col;
			}
				ENDCG
			}



	}
		FallBack "Diffuse"
}