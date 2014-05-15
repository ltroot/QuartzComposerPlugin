/*******************************************************************************
 *
 * \file	SingleMarkerDetectorPlugIn.m
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
#import <OpenGL/CGLMacro.h>

#import "SingleMarkerDetectorPlugIn.h"

#define	kQCPlugIn_Name				@"Single Marker Detector"
#define	kQCPlugIn_Description		@"Single Marker Detector Ver1.0 Copyright 2008 p_g_.\nSingle Marker Detectorは完全に無保証です。\n詳細は末尾をご覧ください。\nこれはフリー・ソフトウェアなので、特定の条件の下でこれを再頒布することができます。詳細は付属の\"COPYING.txt\"か\"COPYING_JPN.txt\"をご覧ください。\n\n--\n\nSingle Marker Detectorは指定した一つのマーカーを入力画像中から検出するパッチです．\noutputMatrixについて．\n変換の4x4行列が出力されます．これは立体モデルの座標を変換するための機能です．\n（中身は16個のdoubleをNSNumberに詰め込んでNSArrayで配列化したポートです．\nこのdoubleの配列がglLoadMatrixdの引数となるものです．)\n--\n\nSingle Marker Detector Ver1.0 Copyright 2008 p_g_.\n\nHe distribution policy is described in the file \"COPYING.txt\" furnished with this library.\n\n本プログラムは、GNU 一般公有使用許諾に準拠します。利用も配布も商用利用も自由ですが、著作権は放棄しておりません。また、改変も自由ですが、GPLである以上、改変バージョンの配布を行う際には、ソースの公開は必須条件となりますので、ご注意下さい。GNU 一般公有使用許諾については、付属の\"COPYING_JPN.txt\"をご覧ください。\n\n本プログラムはフリー・ソフトウェアです。あなたは、Free Software Foundation が公表したGNU 一般公有使用許諾の「バージョン２」或いはそれ以降の各バージョンの中からいずれかを選択し、そのバージョンが定める条項に従って本プログラムを再頒布または変更することができます。\n\n本プログラムは有用とは思いますが、頒布にあたっては、市場性及び特定目的適合性についての暗黙の保証を含めて、いかなる保証も行ないません。詳細についてはGNU 一般公有使用許諾書をお読みください。\n\nあなたは、本プログラムと一緒にGNU 一般公有使用許諾の写しを受け取っているはずです。そうでない場合は、Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA * へ手紙を書いてください。\n\n* 【注意】 現在、このバージョン2の発行者(FSF)住所は、正式に新しい住所の 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA に変わっている。\n\n"

@implementation SingleMarkerDetectorPlugIn

@dynamic inputImage, inputThreshold;
@dynamic outputMatrix, outputFound;
@synthesize pattName, currPattName;

+ (NSDictionary*) attributes
{
	return [NSDictionary dictionaryWithObjectsAndKeys:
			kQCPlugIn_Name, QCPlugInAttributeNameKey,
			kQCPlugIn_Description, QCPlugInAttributeDescriptionKey, nil];
}

+ (NSDictionary*) attributesForPropertyPortWithKey:(NSString*)key
{
	if([key isEqualToString:@"inputThreshold"]) 
		return [NSDictionary dictionaryWithObjectsAndKeys: 
				QCPortTypeIndex, QCPortAttributeTypeKey, 
				[NSNumber numberWithInt:1], QCPortAttributeMinimumValueKey,
				[NSNumber numberWithInt:100], QCPortAttributeDefaultValueKey,
				[NSNumber numberWithInt:255], QCPortAttributeMaximumValueKey,
				@"inputThreshold", QCPortAttributeNameKey, nil]; 
	return nil;
}

+ (QCPlugInExecutionMode) executionMode
{
	return kQCPlugInExecutionModeProcessor;
}

+ (QCPlugInTimeMode) timeMode
{
	return kQCPlugInTimeModeNone;
}

- (id) init
{
	if(self = [super init]) {
		gPatt_width = 80.0;
		gPatt_found = FALSE;
		gPatt_id= -1;
		self.pattName= @"sample1";
	}
	
	return self;
}

- (void) finalize
{
	[super finalize];
}

- (void) dealloc
{
	[super dealloc];
}

+ (NSArray*) plugInKeys
{
	return [NSArray arrayWithObjects:@"pattName", nil];
}

- (id) serializedValueForKey:(NSString*)key;
{
    if([key isEqualToString:@"pattName"])
        return self.pattName;
    return [super serializedValueForKey:key];
}

- (void) setSerializedValue:(id)serializedValue forKey:(NSString*)key
{
    if([key isEqualToString:@"pattName"])
        self.pattName= serializedValue;
    else
        [super setSerializedValue:serializedValue forKey:key];
}

- (QCPlugInViewController*) createViewController
{
	return [[QCPlugInViewController alloc] initWithPlugIn:self viewNibName:@"Settings"];
}

@end

@implementation SingleMarkerDetectorPlugIn (Execution)
- (NSArray*)items {
	return [NSArray arrayWithObjects:@"sample1", @"sample2", nil];
}
- (BOOL) setPatt:(id<QCPlugInContext>)context {
	
	arFreePatt(gPatt_id);
	gPatt_id= -1;
	if (self.pattName==nil) {
		return NO;
	}
	
	NSBundle* mainBundle = [NSBundle bundleWithIdentifier:@"net.y30.pg.plugins.qc.SingleMarkerDetector"];
	const char *patt_name  = [[mainBundle pathForResource:@"patt" ofType:self.pattName] UTF8String];
	if ((gPatt_id = arLoadPatt(patt_name)) < 0) {
		[context logMessage:@"arLoadPatt(): pattern load error !!\n"];
		return NO;
	}
	self.currPattName= self.pattName;
	return YES;
}	
- (BOOL) startExecution:(id<QCPlugInContext>)context
{
	NSBundle* mainBundle = [NSBundle bundleWithIdentifier:@"net.y30.pg.plugins.qc.SingleMarkerDetector"];
	const char *cparam_name  = [[mainBundle pathForResource:@"camera_para" ofType:@"dat"] UTF8String];
	if (arParamLoad(cparam_name, 1, &gARTCparam) < 0) {
		fprintf(stderr, "arParamLoad(): Error loading parameter file %s for camera.\n", cparam_name);
		return NO;
	}
	return YES;
}

- (void) enableExecution:(id<QCPlugInContext>)context
{
}

- (BOOL) execute:(id<QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary*)arguments
{
	if (![self.pattName isEqualToString:self.currPattName]) {
		[self setPatt:context];
	}
	
	if (gPatt_id==-1) {
		return YES;
	}
	
	id<QCPlugInInputImageSource> image = self.inputImage; 
	
	if ([image lockBufferRepresentationWithPixelFormat:QCPlugInPixelFormatARGB8
											colorSpace:[image imageColorSpace]
											 forBounds:[image imageBounds]]){
		
		arParamChangeSize(&gARTCparam, [image bufferPixelsWide], [image bufferPixelsHigh], &arParam);
		arInitCparam(&arParam);
		
		ARMarkerInfo *marker_info;	
		int marker_num;
		ARUint8 *gARTImage = [image bufferBaseAddress];
		
		if (arDetectMarker(gARTImage, self.inputThreshold, &marker_info, &marker_num) < 0) {
			[context logMessage:@"error in arDetectMarker()"]; 
			return NO;
		}
		
		int k = -1;
		for (int j = 0; j < marker_num; j++) {
			if (marker_info[j].id == gPatt_id) {
				if (k == -1) k = j;
				else if(marker_info[j].cf > marker_info[k].cf) k = j;
			}
		}
		if (k != -1) {
			arGetTransMat(&(marker_info[k]), gPatt_centre, gPatt_width, gPatt_trans);
			gPatt_found = TRUE;
		} else {
			gPatt_found = FALSE;
		}
		self.outputFound= gPatt_found;
		
		if (gPatt_found) {
			GLdouble m[16];
			arglCameraViewRH(gPatt_trans, m, VIEW_SCALEFACTOR);
			NSMutableArray* ary= [NSMutableArray array];
			int i;
			for(i= 0; i<16; i++) {
				[ary addObject:[NSNumber numberWithDouble:m[i]]];
			}
			self.outputMatrix= ary;
		} 
		
		[image unlockBufferRepresentation];
	}
	return YES;
	
}

- (void) disableExecution:(id<QCPlugInContext>)context
{
}

- (void) stopExecution:(id<QCPlugInContext>)context
{
}

@end
