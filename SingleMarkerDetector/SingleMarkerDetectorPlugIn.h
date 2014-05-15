/*******************************************************************************
 *
 * \file	SingleMarkerDetectorPlugIn.h
 *
 * \brief	Quartz Composer Patch，
 * \brief	入力画像より一つのマーカーを検出する．
 *
 * \author	p_g_
 *
 * \date    08/11/12	p_g_	作成
 *
 *******************************************************************************/
/*******************************************************************************
 *
 *   Copyright (c) 2008 p_g_
 *
 *   The distribution policy is described in the file "COPYING.txt" furnished 
 *    with this library.
 *
 *    本プログラムは、GNU 一般公有使用許諾に準拠します。
 *    利用も配布も商用利用も自由ですが、著作権は放棄しておりません。
 *    また、改変も自由ですが、GPLである以上、改変バージョンの配布を行う際には、
 *    ソースの公開は必須条件となりますので、ご注意下さい。
 *    GNU 一般公有使用許諾については、付属の"COPYING_JPN.txt"をご覧ください
 *
 *
 *　本プログラムはフリー・ソフトウェアです。あなたは、Free Software
 *　Foundation が公表したGNU 一般公有使用許諾の「バージョン２」或い
 *　はそれ以降の各バージョンの中からいずれかを選択し、そのバージョン
 *　が定める条項に従って本プログラムを再頒布または変更することができ
 *　ます。
 *
 *　本プログラムは有用とは思いますが、頒布にあたっては、市場性及び特
 *　定目的適合性についての暗黙の保証を含めて、いかなる保証も行ないま
 *　せん。詳細についてはGNU 一般公有使用許諾書をお読みください。
 *
 *　あなたは、本プログラムと一緒にGNU 一般公有使用許諾の写しを受け取っ
 *　ているはずです。そうでない場合は、Free Software Foundation, Inc.,
 *　675 Mass Ave, Cambridge, MA 02139, USA * へ手紙を書いてください。
 *
 *    ----------------------------------------------------------------------
 *    * 【注意】 現在、このバージョン2の発行者(FSF)住所は、正式に新
 *     しい住所の 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, 
 *     USA に変わっている。
 *    ----------------------------------------------------------------------
 *
 *******************************************************************************/
#import <Quartz/Quartz.h>
#include <AR/ar.h>

#define VIEW_SCALEFACTOR		0.025

@interface SingleMarkerDetectorPlugIn : QCPlugIn
{
	double	gPatt_width;	
	double	gPatt_centre[2];
	double	gPatt_trans[3][4];	
	int		gPatt_found;
	int		gPatt_id;
	ARParam	gARTCparam;
	
	NSString *pattName;
	NSString *currPattName;
	
}
@property(copy) NSString *pattName;
@property(copy) NSString *currPattName;

@property(assign)		NSArray* outputMatrix;
@property BOOL			outputFound;
@property NSUInteger	inputThreshold;
@property(assign)		id<QCPlugInInputImageSource> inputImage; 
@end
