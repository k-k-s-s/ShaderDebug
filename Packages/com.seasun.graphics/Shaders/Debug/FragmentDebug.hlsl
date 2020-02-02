#ifndef __FRAGMENT_DEBUG__
#define __FRAGMENT_DEBUG__

/*
		ʹ�÷�����
			*����ʹ��MRT���е��ԣ���˲�֧���ӳ���Ⱦ�н��е��ԣ�֧������μ�
			https://docs.unity3d.com/Manual/RenderTech-DeferredShading.html
			*��Ҫʹ�ö��ư汾��URP
			*��PlayerSetting����Ӻ�FRAGMENG_DEBUG
			*�������GameObject�й��Ͻű�FragmentDebug.cs
			*�������²�����Ӳ�����shader��
			*������Ϸ����סCtrl��Ȼ������Ҫ���Ե����ص㣬֮����������

			//1��FragmentDebug:��HLSLPROGRAMǰ���
			Blend 1 One Zero

		HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_ALPHACLIP

			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				half2 texcoord  : TEXCOORD0;
			};

			//2��FragmentDebug: ��Fragment����ǰ���
			#pragma multi_compile __ FRAGMENT_DEBUG_ENABLE
			#include "Packages/com.seasun.graphics/Shaders/Debug/FragmentDebug.hlsl"

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				return OUT;
			}

			uniform sampler2D _OCCameraDepthTexture;

			//3��FragmentDebug: �޸�Frag�����ֱ���3����������������v2f�ṹ�����ơ��ṹ��ʵ��
			FRAGMENT_DEBUG_FUN(frag, v2f, IN)
			//fixed4 frag(v2f IN) : SV_Target
			{
				//4��FragmentDebug: ��ʼ��
				FRAGMENT_DEBUG_INIT

				float depth = tex2D(_OCCameraDepthTexture, IN.texcoord).r;
				depth = Linear01Depth(depth);

				//5��FragmentDebug: ������Ҫ��������ı�����֧��xyz3������
				FRAGMENT_DEBUG_VALUE(xy, float2(100,200))
				FRAGMENT_DEBUG_VALUE(z, -555.11)

				//6��FragmentDebug: ��ԭʼ����������
				FRAGMENT_DEBUG_OUTPUT(fixed4(depth, 0, 0, 1))
			}
		ENDHLSL
*/

#if defined(FRAGMENT_DEBUG_ENABLE)
	#define FRAGMENT_DEBUG_FUN(FUNNAME, STRUCTNAME, VARNAME) void FUNNAME(STRUCTNAME VARNAME, out float4 out0 : SV_Target, out float4 out1 : SV_Target1)
	#define FRAGMENT_DEBUG_INIT float3 debugValue = 0;
	#define FRAGMENT_DEBUG_VALUE(index, value) debugValue.index = value;
	#define FRAGMENT_DEBUG_OUTPUT(value) out0 = value; out1 = float4(debugValue, -12589);
#else
	#define FRAGMENT_DEBUG_FUN(FUNNAME, STRUCTNAME, VARNAME) void FUNNAME(STRUCTNAME VARNAME, out float4 out0 : SV_Target)
	#define FRAGMENT_DEBUG_INIT
	#define FRAGMENT_DEBUG_VALUE(index, value)
	#define FRAGMENT_DEBUG_OUTPUT(value) out0 = value;
#endif

#endif