#import <OpenGL/CGLMacro.h>

#import "MatrixToParamsPlugIn.h"

#define	kQCPlugIn_Name				@"MatrixToParams"
#define	kQCPlugIn_Description		@"Disassemble the 4x4 homogeneous transform matrix to each parameters for '3D Transformation' patch."

@implementation MatrixToParamsPlugIn

@dynamic inputMatrix;
@dynamic outputZ, outputY, outputX;
@dynamic outputAngleZ, outputAngleY, outputAngleX;

+ (NSDictionary*) attributes
{
	return [NSDictionary dictionaryWithObjectsAndKeys:kQCPlugIn_Name, QCPlugInAttributeNameKey, 
			kQCPlugIn_Description, QCPlugInAttributeDescriptionKey, nil];
}

+ (NSDictionary*) attributesForPropertyPortWithKey:(NSString*)key
{
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

@end

@implementation MatrixToParamsPlugIn (Execution)

- (BOOL) startExecution:(id<QCPlugInContext>)context
{
	return YES;
}

- (void) enableExecution:(id<QCPlugInContext>)context
{
}

- (BOOL) execute:(id<QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary*)arguments
{
	if (self.inputMatrix!=nil && [self.inputMatrix count]>15) {
		
		double m[16];
		NSArray* ary= self.inputMatrix;
		int i;
		for(i= 0; i<16; i++) {
			NSNumber* n= [ary objectAtIndex:i];
			m[i]= [n doubleValue];
		}
		double thy= asin ( m[2*4+0]);
		double thx= atan2(-m[2*4+1], m[2*4+2]);
		double thz= atan2(-m[1*4+0], m[0*4+0]);		
		
		self.outputAngleX=  thx * 180.0 / M_PI;
		self.outputAngleY=  thy * 180.0 / M_PI;
		self.outputAngleZ=  thz * 180.0 / M_PI;
		
		self.outputX= m[3*4+0];
		self.outputY= m[3*4+1];
		self.outputZ= m[3*4+2];
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
