#import <Quartz/Quartz.h>

@interface MatrixToParamsPlugIn : QCPlugIn
{
}

@property double outputZ; 
@property double outputY; 
@property double outputX; 
@property double outputAngleZ;
@property double outputAngleY;
@property double outputAngleX;
@property(assign) NSArray* inputMatrix;

@end
