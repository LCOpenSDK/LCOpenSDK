//
// Copyright (c) 2010, Õã½­´ó»ª¼¼Êõ¹É·ÝÓÐÏÞ¹«Ë¾
// All righSC reserved.
//
// ÎÄ ¼þ Ãû£ºStreamConvertor.h
// Õª    Òª£ºÌá¹SCÁ÷·â×°£¬Ö§³ÖDHAVÂëÁ÷
//
// ÐÞ¶¼ÇÂ¼£º´´½¨
// Íê³ÉÈÕÆÚ£º2011Äê01ÔÂ06ÈÕ
// ×÷    Õß£º
//

#ifndef _STREAM_CONVERTOR__H
#define _STREAM_CONVERTOR__H

#define IN
#define OUT

#if (defined(WIN32) || defined(WIN64))
    #ifdef ST_EXPORTS_DLL
        #define SCAPI __declspec(dllexport)
    #elif defined ST_USE_DLL
        #define SCAPI __declspec(dllimport)
	#else
		#define SCAPI
    #endif

    #define CALLMETHOD __stdcall
    typedef __int64 int64_t;

#else /*linux or mac*/

    #define SCAPI
#ifdef C_INTERFACE_NO_HIDDEN
	#define CALLMETHOD __attribute__((visibility("default")))
#else
	#define CALLMETHOD
#endif
	#include <inttypes.h>
	#include <stdint.h>

#endif


#ifdef __cplusplus
extern "C" {
#endif

typedef void* SCHANDLE;

// ´íÎóÂë
enum
{
	SCERR_NoError = 0,				/* ³É¹¦*/
	SCERR_InvalidHandle,			/* ÎÞÐ§¾ä±ú*/
	SCERR_NoSupport,				/* ½âÎö»ò·â×°ÀàÐÍ²»Ö§³Ö*/
	SCERR_Thread,					/* ÄÚ²¿Ïß³Ì³ö´í*/
	SCERR_Param,					/* ×ª»»¹ý³ÌÖÐ²ÎÊýÓÐÎó*/

	SCERR_FileOpen,					/* ÎÄ¼þ´ò¿ª³ö´í£¬¿ÉÄÜÒÑ±»»¥³â´ò¿ª*/
	SCERR_FileRead,					/* ÎÄ¼þ¶ÁÈ¡³ö´í*/
	SCERR_FileWrite,				/* ÎÄ¼þÐ´Èë³ö´í*/
	SCERR_Format,					/* ÂëÁ÷¸ñÊ½ÓÐÎó£¬ÎÞ·¨¼ÌÐø½âÎö*/

	SCERR_BufferOverFlow,			/* ÄÚ²¿»º³åÒç³ö*/
	SCERR_SysOutOfMem,				/* ÏµÍ³ÄÚ´æ²»×ã*/

	SCERR_NoIDRFrame,				/* ½âÎö»ò·â×°ÀàÐÍ²»Ö§³Ö*/
	SCERR_NoOutPut,					/* Í¬²½·â×°»ò½âÎöÂß¼­ÖÐÎÞÊý¾ÝÊä³ö*/
	SCERR_ErrorOrder,				/* µ÷ÓÃË³ÐòÓÐÎó*/

	SCERR_KeyError,					/* »Ø·ÅÊ±ÊäÈëÃØÔ¿´íÎó*/
	SCERR_InputParam,				/* ÊäÈë²ÎÊýÓÐÎó*/
};

typedef enum _SC_TYPE
{
	SC_NONE = -1,
	SC_TS,
	SC_PS,
    SC_RTP,
	SC_MP4,
	SC_GDPS,
	SC_GAYSPS,
	SC_FLV,
	SC_ASF_FILE,
	SC_ASF_STREAM,
	SC_FLV_STREAM,
	SC_MP4_NOSEEK,
	SC_DAV_FILE,
	SC_DAV_STREAM,
	SC_AVI_FILE,
	SC_AVI_STREAM,
	SC_TS_NEW,
	SC_PS_NEW,
	SC_MOV,
	SC_MP464,
	SC_MOV64,
	SC_WAV_FILE,
	SC_DHPS,
	SC_DHPS_STREAM,
	SC_CDJFPS,
	SC_CDJFTS,
	SC_RAW,	//ÂãÊý¾Ý»Øµ÷
	SC_TZDZTS,
	SC_DAV_PACKET,
	SC_DHTS
}SC_TYPE;

/*´ý×ª»»Ç°ÂëÁ÷·â×°¸ñÊ½*/
typedef enum _SC_SRC_TYPE
{
	SC_SRC_STREAM_TYPE_UNKNOWN = 0, /*Î´ÖªÂëÁ÷*/
	SC_SRC_STREAM_TYPE_MPEG4,       /*MPEG4*/
	SC_SRC_STREAM_TYPE_DHPT =3,	    /*´ó»ªÀÏÂëÁ÷£ºDHPT*/
	SC_SRC_STREAM_TYPE_NEW,         /*´ó»ªÀÏÂëÁ÷£ºNEW*/
	SC_SRC_STREAM_TYPE_HB,          /*´ó»ªÀÏÂëÁ÷£ºHB*/
	SC_SRC_STREAM_TYPE_AUDIO,       /*ÒôÆµÁ÷*/
	SC_SRC_STREAM_TYPE_PS,          /*MPEG-2£ºPS*/
	SC_SRC_STREAM_TYPE_DHSTD,       /*´ó»ª×îÐÂµÄ±ê×¼ÂëÁ÷*/
	SC_SRC_STREAM_TYPE_ASF,         /*ASF*/
	SC_SRC_STREAM_TYPE_3GPP,        /*3GP*/
	SC_SRC_STREAM_TYPE_RAW,	        /*´ó»ªÀÏÂëÁ÷£ºÂãÂëÁ÷*/
	SC_SRC_STREAM_TYPE_TS,          /*MPEG-2£ºTS*/
	SC_SRC_STREAM_TYPE_SVC,         /*svc*/
	SC_SRC_STREAM_TYPE_AVI,         /*AVI*/
	SC_SRC_STREAM_TYPE_MP4,         /*MP4*/
	SC_SRC_STREAM_TYPE_CGI,         /*CGI*/
	SC_SRC_STREAM_TYPE_WAV,			/*WAVÒôÆµ*/
	SC_SRC_STREAM_TYPE_FLV,         /*FLV*/

	SC_SRC_STREAM_TYPE_MKV,         /*mkv*/
	SC_SRC_STREAM_TYPE_RTP,			/*RTP*/
	SC_SRC_STREAM_TYPE_RAW_MPEG4,	/*MPEG4ÂãÂëÁ÷*/
	SC_SRC_STREAM_TYPE_RAW_H264,	/*H264ÂãÂëÁ÷*/
	SC_SRC_STREAM_TYPE_RAW_H265,	/*H265ÂãÂëÁ÷*/
	SC_SRC_STREAM_TYPE_WMV,			/*WMV*/
	SC_SRC_STREAM_TYPE_RAW_MPEG2,	/*MPEG2ÂãÂëÁ÷*/
	SC_SRC_STREAM_TYPE_RAW_SVAC,	/*SVACÂãÂëÁ÷*/
	SC_SRC_STREAM_TYPE_MOV,
	SC_SRC_STREAM_TYPE_VOB,			/*VOB*/
	SC_SRC_STREAM_TYPE_RAW_H263,
	SC_SRC_STREAM_TYPE_RM,
	SC_SRC_STREAM_TYPE_DHPS,		/*MPEG-2£ºPS*/

	// µÚÈý·½³§ÉÌÀàÐÍ£¬´Ó0x81¿ªÊ¼£¬ºÍÍ¨ÓÃ³§ÉÌ×öÇø·Ö
	SC_SRC_STREAM_TYPE_HENGYI = 0x81,	/*ºãÒ×*/
	SC_SRC_STREAM_TYPE_HUANGHE,		/*»ÆºÓ*/
	SC_SRC_STREAM_TYPE_LANGCHI,		/*ÀÊ³Û*/
	SC_SRC_STREAM_TYPE_TDWY,		/*ÌìµØÎ°Òµ*/
	SC_SRC_STREAM_TYPE_DALI,		/*´óÁ¢*/
	SC_SRC_STREAM_TYPE_LVFF,		/*LVFFÎÄ¼þÍ·£¬Î´Öª³§ÉÌ*/
	SC_SRC_STREAM_TYPE_H3C,			/*»ªÈý*/
	SC_SRC_STREAM_TYPE_FENGDA,		/*·á´ïÂ¼Ïñ*/
	SC_SRC_STREAM_TYPE_MDVRX,		/*ÎÄ¼þÍ·MDVRX£¬Î´Öª³§ÉÌ*/
	SC_SRC_STREAM_TYPE_PU8000,		/*ÎÄ¼þÍ·pu8000£¬Î´Öª³§ÉÌ*/
	SC_SRC_STREAM_TYPE_DVR,			/*ºó×ºÃûdvr£¬Î´Öª³§ÉÌ*/
	SC_SRC_STREAM_TYPE_IFV,			/*ºó×ºÃûifv£¬Î´Öª³§ÉÌ*/
	SC_SRC_STREAM_TYPE_264DV,		/*ÎÄ¼þÍ·264dv£¬Î´Öª³§ÉÌ*/
	SC_SRC_STREAM_TYPE_ZWSJ,		/*ÖÐÎ¬ÊÀ¼Í*/
	SC_SRC_STREAM_TYPE_SANLI,		/*½ðÈýÁ¢*/
	SC_SRC_STREAM_TYPE_HIK_PRIVATE,	/*º£¿µË½ÓÐÂëÁ÷*/
	SC_SRC_STREAM_TYPE_HIK_PS,		/*º£¿µPSÁ÷*/
	SC_SRC_STREAM_TYPE_STAR,		/*ÐÇÍûË½ÓÐÂëÁ÷*/
	SC_SRC_STREAM_TYPE_LIYUAN,		/*Á¢ÔªË½ÓÐÂëÁ÷*/
	SC_SRC_STREAM_TYPE_KAER,		/*±±¾¿¨¶ûÊÓÍ¨ÂëÁ÷*/
	SC_SRC_STREAM_TYPE_SSAV,		/*SSAVÄ³Î´Öª³§ÉÌÂëÁ÷*/
	SC_SRC_STREAM_TYPE_ZLAV,		/*ZLAVÖÇÅµÂëÁ÷*/
	SC_SRC_STREAM_TYPE_ZSLC_PS,		/*ÖÐÊÓÀï³ÌPS*/
	SC_SRC_STREAM_TYPE_STAR_EX,		/*Ò»ÖÖÐÂµÄÐÇÍûË½ÓÐÁ÷*/
	SC_SRC_STREAM_TYPE_DONGYANG,	/*¶«ÑôµÄÒ»¸öÌØÊâÂëÁ÷*/
	SC_SRC_STREAM_TYPE_CREARO,		/*´´ÊÀÂëÁ÷*/
}SC_SRC_STREAM_TYPE;

/*Ö¡ÀàÐÍ*/
typedef enum
{
	SC_FRAME_TYPE_UNKNOWN = 0,			/*Ö¡ÀàÐÍ²»¿ÉÖª*/
	SC_FRAME_TYPE_VIDEO,				/*Ö¡ÀàÐÍÊÇÊÓÆµÖ¡*/
	SC_FRAME_TYPE_AUDIO,				/*Ö¡ÀàÐÍÊÇÒôÆµÖ¡*/
	SC_FRAME_TYPE_DATA,					/*Ö¡ÀàÐÍÊÇÊý¾ÝÖ¡*/
}SC_FrameType;

/*Ö¡×ÓÀàÐÍ*/
typedef enum _FRAME_SUB_TYPE
{
	SC_FRAME_SUB_TYPE_INVALID = -1,     	/*Êý¾ÝÎÞÐ§*/
	SC_FRAME_SUB_TYPE_I_FRAME,				/*ÊÓÆµIÖ¡*/
	SC_FRAME_SUB_TYPE_P_FRAME,				/*ÊÓÆµPÖ¡*/
	SC_FRAME_SUB_TYPE_B_FRAME,				/*ÊÓÆµBÖ¡*/

}SC_FrameSubType;

/*±àÂëÀàÐÍ*/
typedef enum _VIDEO_ENCODE
{
	SC_ENCODE_VIDEO_UNKNOWN = 0,		/*ÊÓÆµ±àÂë¸ñÊ½²»¿ÉÖª*/
	SC_ENCODE_VIDEO_MPEG4 ,			    /*ÊÓÆµ±àÂë¸ñÊ½ÊÇMPEG4*/
	SC_ENCODE_VIDEO_HI_H264,			/*ÊÓÆµ±àÂë¸ñÊ½ÊÇº£Ë¼H264*/
	SC_ENCODE_VIDEO_JPEG,				/*ÊÓÆµ±àÂë¸ñÊ½ÊÇ±ê×¼JPEG*/
	SC_ENCODE_VIDEO_DH_H264,			/*ÊÓÆµ±àÂë¸ñÊ½ÊÇ´ó»ªÂëÁ÷H264*/
	SC_ENCODE_VIDEO_JPEG2000 = 6,		/*ÊÓÆµ±àÂë¸ñÊ½ÊÇ±ê×¼JPEG2000*/
	SC_ENCODE_VIDEO_STD_H264 = 8,		/*ÊÓÆµ±àÂë¸ñÊ½ÊÇ±ê×¼H264*/
	SC_ENCODE_VIDEO_MPEG2 = 9,          /*ÊÓÆµ±àÂë¸ñÊ½ÊÇMPEG2*/
	SC_ENCODE_VIDEO_SVAC = 11,          /*ÊÓÆµ±àÂë¸ñÊ½ÊÇSVAC*/
	SC_ENCODE_VIDEO_DH_H265 = 12,		/*ÊÓÆµ±àÂë¸ñÊ½ÊÇH265*/

	//Ë½ÓÐ±àÂë¸ñÊ½
	SC_ENCODE_VIDEO_HIK_H264 = 0x81,		/*º£¿µË½ÓÐH264ÂëÁ÷*/
}SC_VIDEO_ENCODE;

typedef enum
{
	SC_ENCODE_AUDIO_UNKNOWN = 0,
	SC_ENCODE_AUDIO_PCM = 7,			/*ÒôÆµ±àÂë¸ñÊ½ÊÇPCM8*/
	SC_ENCODE_AUDIO_G729,				/*ÒôÆµ±àÂë¸ñÊ½ÊÇG729*/
	SC_ENCODE_AUDIO_IMA,				/*ÒôÆµ±àÂë¸ñÊ½ÊÇIMA*/
	SC_ENCODE_PCM_MULAW,				/*ÒôÆµ±àÂë¸ñÊ½ÊÇPCM MULAW*/
	SC_ENCODE_AUDIO_G721,				/*ÒôÆµ±àÂë¸ñÊ½ÊÇG721*/
	SC_ENCODE_PCM8_VWIS,				/*ÒôÆµ±àÂë¸ñÊ½ÊÇPCM8_VWIS*/
	SC_ENCODE_MS_ADPCM,				    /*ÒôÆµ±àÂë¸ñÊ½ÊÇMS_ADPCM*/
	SC_ENCODE_AUDIO_G711A,				/*ÒôÆµ±àÂë¸ñÊ½ÊÇG711A*/
	SC_ENCODE_AUDIO_AMR,				/*ÒôÆµ±àÂë¸ñÊ½ÊÇAMR-NB Õ­´ø*/
	SC_ENCODE_AUDIO_PCM16,				/*ÒôÆµ±àÂë¸ñÊ½ÊÇPCM16*/
	SC_ENCODE_AUDIO_G711U = 22,		    /*ÒôÆµ±àÂë¸ñÊ½ÊÇG711U*/
	SC_ENCODE_AUDIO_G723 = 25,			/*ÒôÆµ±àÂë¸ñÊ½ÊÇG723*/
	SC_ENCODE_AUDIO_AAC,			    /*ÒôÆµ±àÂë¸ñÊ½ÊÇAAC Low Complex*/
	SC_ENCODE_AUDIO_G726_40,            /*40kbps,ÒÔÏÂ32/24/16*/
	SC_ENCODE_AUDIO_G726_32,            /*·Ö±ð±íÊ¾±ÈÌØÂÊµÄ²»Í¬*/
	SC_ENCODE_AUDIO_G726_24,            /*Ïà¶ÔÓÚ8k²ÉÑùÂÊµÄ*/
	SC_ENCODE_AUDIO_G726_16,            /*Çé¿öÏÂ*/
	SC_ENCODE_AUDIO_MP2,				/*ÒôÆµ±àÂë¸ñÊ½ÊÇmp2*/
	SC_ENCODE_AUDIO_OGG,				/*ÒôÆµ±àÂë¸ñÊ½ÊÇogg vorbis*/
	SC_ENCODE_AUDIO_MP3,				/*ÒôÆµ±àÂë¸ñÊ½ÊÇmp3*/
	SC_ENCODE_AUDIO_G722_1,				/*ÒôÆµ±àÂë¸ñÊ½ÊÇG722.1*/
	SC_ENCODE_AUDIO_G722,				/*ÒôÆµ±àÂë¸ñÊ½ÊÇG722*/
	SC_ENCODE_AUDIO_G722_1C_48,			/*ÒôÆµ±àÂë¸ñÊ½ÊÇG722_1C_48*/
	SC_ENCODE_AUDIO_AAC_LD,				/*ÒôÆµ±àÂë¸ñÊ½ÊÇAAC_LD*/
	SC_ENCODE_AUDIO_OPUS,				/*ÒôÆµ±àÂë¸ñÊ½ÊÇOPUS*/
	SC_ENCODE_AUDIO_G719,				/*ÒôÆµ±àÂë¸ñÊ½ÊÇG719*/
	SC_ENCODE_AUDIO_G728,				/*ÒôÆµ±àÂë¸ñÊ½ÊÇG728*/
	SC_ENCODE_AUDIO_G722_1_16,			/*ÒôÆµ±àÂë¸ñÊ½ÊÇG722_1_16*/
	SC_ENCODE_AUDIO_G722_1_24,			/*ÒôÆµ±àÂë¸ñÊ½ÊÇG722_1_24*/
	SC_ENCODE_AUDIO_G722_1C_24,			/*ÒôÆµ±àÂë¸ñÊ½ÊÇG722_1C_24*/
	SC_ENCODE_AUDIO_G722_1C_32,			/*ÒôÆµ±àÂë¸ñÊ½ÊÇG722_1C_32*/

	SC_ENCODE_AUDIO_TALK = 0x30,		/*ÒôÆµ±àÂë¸ñÊ½ÊÇ¶Ô½²*/

}SC_AUDIO_ENCODE;

#pragma pack(1)
/// ÊÓÆµ²ÎÊý 40×Ö½Ú
typedef struct
{
	unsigned int nEncodeType;	/*ÊÓÆµ±àÂë¸ñÊ½,È¡ÖµSC_VIDEO_ENCODE */
	unsigned int nWidth;		/* ¿í */
	unsigned int nHeight;		/* ¸ß */
	unsigned int nFrameRate;	/* Ö¡ÂÊ */
	unsigned int nReserved[6];
}SC_Video_INFO;

/// ÒôÆµ²ÎÊý 40×Ö½Ú
typedef struct
{
	unsigned int nEncodeType;	/*ÒôÆµ±àÂë¸ñÊ½£¬È¡ÖµSC_AUDIO_ENCODE*/
	unsigned int nChannel;		/* ÒôÆµÍ¨µÀÊý*/
	unsigned int nSampleRate;	/* ÒôÆµ²ÉÑùÆµÂÊ*/
	unsigned int nBitPerSample;	/* ÒôÆµ²ÉÑùÎ»Êý*/
	unsigned int nReserved[6];
}SC_Audio_INFO;


//Ã¿Ò»Ö¡ÂãÊý¾ÝÐÅÏ¢£¬¹Ì¶¨´óÐ¡256×Ö½Ú
typedef struct
{
	int nFrameType;				/* Ö¡ÀàÐÍ£¬È¡ÖµSC_FrameType */
	int nFrameSubType;			/* Ö¡×ÓÀàÐÍ£¬È¡ÖµSC_FrameSubType */

	int nYear;					/* Äê */
	int nMonth;					/* ÔÂ */
	int nDay;					/* ÈÕ */
	int nHour;					/* Ð¡Ê± */
	int nMinute;				/* ·ÖÖÓ */
	int nSecond;				/* Ãë */
	int nMilliSecond;			/* ºÁÃë */
	int64_t pts;				/* pts Ê±¼ä´Á */
	int64_t dts;				/* dts Ê±¼ä´Á */
	union
	{
		SC_Video_INFO video;
		SC_Audio_INFO audio;
	}Info;
	int nValid;					/* ÊÇ·ñ°üº¬ÓÐÐ§Êý¾Ý£¬0²»°üº¬£¬1°üº¬ */
	
	int nReserved[40];
}SC_FRAME_INFO;

#pragma pack()

/********************************************************************
*	Funcname: 	    	SC_GetVersion
*	Purpose:	        »ñÈ¡svn°æ±¾ÐÅÏ¢
*   InputParam:         ÎÞ
*   OutputParam:		ÎÞ
*   Return:             ¿â°æ±¾ºÅ×Ö·û´®
*********************************************************************/
SCAPI char* CALLMETHOD SC_GetVersion(void);

//
// ·â°üÐÅÏ¢»Øµ÷£¬ÒÔÁ÷·½Ê½Êä³ö
// pData£º  ÒÑÍê³ÉµÄÒ»Ö¡Êý¾Ý£¬·â×°ºóµÄÊý¾ÝÓ¦´Ó¸Ã»Øµ÷ÖÐÈ¡µÃ
// iLen:    Ö¡Êý¾Ý³¤¶È
// lUser£º  ÓÃ»§Êý¾Ý
//
typedef void (CALLMETHOD *pfSCPacketsCallback)(unsigned char* pData, int iLen, void* lUser);


// ·â°üÐÅÏ¢»Øµ÷,µ±Ä¿µÄÀàÐÍÎªps,ts£¬dav¿É½øÐÐÊµÊ±×ª·¢£»MP4,flv£¬asf,aviµÈÀàÐÍÓÉÓÚÐèÒª»ØÐ´ÎÄ¼þÍ·£¬²»Ö§³ÖÊµÊ±×ª·¢
// pData£º  Ò»Ö¡Êý¾Ý£¬´Ó¸Ã»Øµ÷ÖÐÈ¡µÃ
// iLen:    Ö¡Êý¾Ý³¤¶È
// offset:	Æ«ÒÆ
// offsetType:Æ«ÒÆÀàÐÍ
// lUser£º  ÓÃ»§Êý¾Ý
//
typedef void (CALLMETHOD* pfSCPacketsCallbackEx)(unsigned char* pData, int iLen, int64_t offset, int64_t offsetType, void* lUser);

//
// Ö¡Êý¾Ý¼°Ö¡ÐÅÏ¢»Øµ÷£¬Ä¿Ç°½öÖ§³Ö£ºps£¬ÀÕ¹ps£¬ÒÔ¼°SC_RAW
// pFrmHdr: ÒôÊÓÆµÖ¡ÐÅÏ¢
// pData£º  Ò»Ö¡Êý¾Ý£¬´Ó¸Ã»Øµ÷ÖÐÈ¡µÃ
// iLen:    Ö¡Êý¾Ý³¤¶È
// lUser£º  ÓÃ»§Êý¾Ý
//
typedef void (CALLMETHOD *pfSCFrameDataCallback)(SC_FRAME_INFO* pFrmHdr, unsigned char* pData, int iLen, void* lUser);


//
// ¹¦  ÄÜ£ºSCÁ÷·â×°¿â³õÊ¼»¯º¯Êý
// ²Î  Êý£ºÎÞ
// ·µ»ØÖµ£ºTRUE³É¹¦£¬FALSEÊ§°Ü
//
SCAPI bool CALLMETHOD SC_Init(void);

//
// ¹¦  ÄÜ£º´ò¿ªÒ»¸öSCÁ÷×ª»»Í¨µÀ(MP4²»Ö§³Ö)
// ²Î  Êý£º
//		   IN  eSCType£º×ª»»ÀàÐÍ
//		   IN  fSCPackeSCCallback£ºDHAVÂëÁ÷×ª»»ÎªSCÁ÷ºóµÄÊý¾Ý»Øµ÷
//		   IN  lUser£ºÓÃ»§Êý¾Ý£¬»Øµ÷º¯ÊýÖÐÊ¹ÓÃ
//		   OUT pSCHandle£ºSCÁ÷×ª»»Í¨µÀ¾ä±ú
//
// ·µ»ØÖµ£º¼û´íÎóÂë
//
SCAPI int CALLMETHOD SC_Open(IN SC_TYPE eSCType, IN pfSCPacketsCallback fSCPacketsCallback, IN void* lUser, OUT SCHANDLE* pSCHandle);


//
// ¹¦  ÄÜ£º´ò¿ªÒ»¸öSC×ª»»Í¨µÀ,Ä¿µÄ×ª»»Êý¾ÝÊÇÒÔ»Øµ÷·½Ê½Êä³ö£¬ÓÉÓÃ»§×Ô¶¨Òå×ö×ª·¢»òÕß´æ´¢
// ²Î  Êý£º
//		   IN  eSrcType:Ô­Ê¼ÊäÈëÂëÁ÷ÀàÐÍ£¬È¡Ã¶¾ÙÖµSC_SRC_STREAM_TYPE£¬µ±²»È·¶¨Ô­Ê¼ÂëÁ÷ÀàÐÍÊ±£¬ÇëÊ¹ÓÃSC_SRC_STREAM_TYPE_UNKNOWN;
//		   IN  eSCType£ºÄ¿µÄ×ª»»ÀàÐÍ,È¡ÖµSC_TYPE£¬µ±È¡ÖµÎªSC_RAW£¬½ö´¥·¢»Øµ÷fSCFramesDataCallback;
//												  µ±È¡ÖµÎªSC_PS£¬SC_GAYSPS£¬¼È¿ÉÒÔ´¥·¢»Øµ÷fSCFramesDataCallback£¬Ò²¿ÉÒÔ´¥·¢fSCPacketsCallbackEx£»µ«½öÄÜ´¥·¢ÆäÖÐÒ»ÖÖ;
//												  µ±È¡ÖµÎªÆäËûÖµ£¬½ö´¥·¢fSCPacketsCallbackEx;
//		   IN  pfSCPacketsCallbackEx£º×ª»»ºóÊý¾Ý»Øµ÷
//		   IN  fSCFramesDataCallback£º×ª»»ºóÊý¾Ý»Øµ÷£¬ÒÔ¼°ÏàÓ¦µÄÖ¡ÐÅÏ¢
//		   IN  lUser£ºÓÃ»§Êý¾Ý£¬»Øµ÷º¯ÊýÖÐÊ¹ÓÃ
//		   OUT pSCHandle£ºSCÁ÷×ª»»Í¨µÀ¾ä±ú
//
// ·µ»ØÖµ£º¼û´íÎóÂë
//
SCAPI int CALLMETHOD SC_OpenProc(IN SC_SRC_STREAM_TYPE eSrcType, IN SC_TYPE eDstType, IN pfSCPacketsCallbackEx fSCPacketsCallbackEx, IN pfSCFrameDataCallback fSCFramesDataCallback, IN void* lUser, OUT SCHANDLE* pSCHandle);

//
// ¹¦  ÄÜ£º´ò¿ªÒ»¸öSC×ª»»·½Ê½£¬±£´æÔÚÎÄ¼þÀïÃæ
// ²Î  Êý£º
//		   IN  eSCType£º×ª»»ÀàÐÍ
//		   IN  szFileName Òª±£´æµÄÎÄ¼þÃû
//			IN nlen   ÎÄ¼þÃû³¤¶È
//		   IN  lUser£ºÓÃ»§Êý¾Ý£¬»Øµ÷º¯ÊýÖÐÊ¹ÓÃ
//		   OUT pSCHandle£ºSCÁ÷×ª»»Í¨µÀ¾ä±ú
//
// ·µ»ØÖµ£º¼û´íÎóÂë
//
SCAPI int CALLMETHOD SC_OpenFile(IN SC_TYPE eSCType, IN const char* szFileName,IN int nlen, OUT SCHANDLE* pSCHandle);


// ¹¦  ÄÜ£º¸ù¾ÝÊµ¼ÊÐèÇóÉèÖÃ×ª»»²ÎÊý
// ²Î  Êý£º
//		   IN hSCHandle£ºSCÁ÷×ª»»Í¨µÀ£¬ÓÉSC_OpenFile£¬»òÕßSC_Open²úÉú
//		   IN type£ºÉèÖÃ×ª»»²ÎÊý£ºµ±typeÎª"mutiMode"£¬Ö§³Ö×ª»»MP4Ê±±ä·Ö±æÂÊ¡¢Ö¡ÂÊµÈÊÓÆµ²ÎÊý£¬½«×Ô¶¯ÒÔÏÂ»®Ïß+Êý×ÖÃüÃû·½Ê½±£´æÎÄ¼þ£»
//		   IN nValue£ºÓÃ»§×Ô¶¨Òå²ÎÊýtypeµÄÖµ,µ±typeÎª"mutiMode"Ê±£¬nValueÎªÈÎÒâÖµ¾ù¿É£»
// ·µ»ØÖµ£º¼û´íÎóÂë
//
SCAPI int CALLMETHOD SC_SetParam( IN SCHANDLE hSCHandle ,IN char* type, IN int nValue);

//
// ¹¦  ÄÜ£º½«Ô­Ê¼Êý¾ÝËÍÈëSCÁ÷×ª»»¿â
// ²Î  Êý£º
//		   IN hSCHandle£ºSCÁ÷×ª»»Í¨µÀ£¬ÓÉSC_OpenFile²úÉú
//		   IN pData£ºÔ­Ê¼Êý¾Ý
//		   IN iLen£ºÔ­Ê¼Êý¾Ý³¤¶È
//
// ·µ»ØÖµ£º¼û´íÎóÂë
//
SCAPI int CALLMETHOD SC_InputData(IN SCHANDLE hSCHandle, IN unsigned char* pData, IN int iLen);

//
// ¹¦  ÄÜ£ºÌáÊ¾×ª»»¿âËÍÊý¾Ý½áÊø
// ²Î  Êý£º
//		   IN hSCHandle£ºSCÁ÷×ª»»Í¨µÀ£¬ÓÉSC_OpenFile²úÉú,(mp4±ØÐëµ÷ÓÃ)
//
// ·µ»ØÖµ£º¼û´íÎóÂë
//
SCAPI int CALLMETHOD SC_EndInput(IN SCHANDLE hSCHandle);
//
// ¹¦  ÄÜ£º¹Ø±ÕSCÁ÷×ª»»Í¨µÀ
// ²Î  Êý£º
//		   IN hSCHandle£ºSCÁ÷×ª»»Í¨µÀ£¬ÓÐSC_Open²úÉú
// ·µ»ØÖµ£º¼û´íÎóÂë
//
SCAPI int CALLMETHOD SC_Close(IN SCHANDLE hSCHandle);

//
// ¹¦  ÄÜ£ºSCÁ÷·â×°¿âÇåÀíº¯Êý
// ²Î  Êý£ºÎÞ
// ·µ»ØÖµ£ºTRUE³É¹¦£¬FALSEÊ§°Ü
//
SCAPI bool CALLMETHOD SC_Cleanup(void);

//
//¹¦ÄÜ:	1.ÉèÖÃ½âÃÜÀàÐÍºÍÃÜÔ¿¼°ÃÜÔ¿³¤¶È,ÊµÏÖ½âÃÜ¹¦ÄÜ
//		2.×ª»¯RTP£¬ÉèÖÃ±ØÒª²ÎÊý
//²ÎÊý£ºhSCHandle£ºSCÁ÷×ª»»Í¨µÀ£¬ÓÉSC_Open²úÉú
//		1.ÊµÏÖ½âÃÜ¹¦ÄÜ£¬Ô­Ê¼ÂëÁ÷µÄ¼ÓÃÜÀàÐÍÎªaes£¬typeÉèÖÃ£º"Decryptkey_aes",pExtInfo£ºÃØÔ¿£¬nLength£ºÃØÔ¿³¤¶È
//													 ÉèÖÃ£º	"Decryptkey_aes256"	,pExtInfo£ºÃØÔ¿£¬nLength£ºÃØÔ¿³¤¶È
//		2.×ª»»ÂëÁ÷³ÉRTPÊ±£¬typeÉèÖÃ£º"package_rtp_custom_data"£¬°üÇ°×Ô¶¨ÒåÊý¾Ý,nLength:°üÇ°×Ô¶¨ÒåÊý¾Ý³¤¶È
//							"package_rtp_extension_data":°üÀÕ¹Êý¾Ý,nLength:°üÀÕ¹Êý¾Ý³¤¶È
//							"package_rtp_audio_custom_data" :°üÇ°×Ô¶¨ÒåÒôÆµÊý¾Ý,nLength:°üÇ°×Ô¶¨ÒåÒôÆµÊý¾Ý³¤¶È
/// ·µ»ØÖµ£º¼û´íÎóÂë
//
SCAPI int CALLMETHOD SC_SetExtInfo(IN SCHANDLE hSCHandle, IN const char* type, IN const void* pExtInfo, IN int nLength);

#ifdef __cplusplus
}
#endif

#endif

