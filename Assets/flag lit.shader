Shader "Custom/flag lit" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_CutoutThresh("Cutout Threshold", Range(0.0,1.0)) = 0.2
		_Speed("speed", FLOAT) = 2
		_WaveHeight("Wave height", FLOAT)= 0.5	

		//_MainTex("Texture", 2D) = "white" {}

	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
	
		#pragma surface surf Standard fullforwardshadows vertex:vert addshadow
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		float _Speed;
		float2 _WaveHeight;
		float _CutoutThresh;

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props) 

		void vert(inout appdata_full v)
		{
			//float2 heightTranslation;
			float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
			float heightTranslation;
			heightTranslation = sin(worldPos.x + _Time.x) *_Speed;

			v.vertex.x += heightTranslation * _WaveHeight ;
		}
		


		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
			clip(c - _CutoutThresh);
			
		}
		ENDCG
	}
	FallBack "Diffuse"
}
