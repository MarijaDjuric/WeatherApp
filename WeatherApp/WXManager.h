

@import Foundation;
@import CoreLocation;
#import "ReactiveCocoa.h"
#import "WXCondition.h"

@interface WXManager : NSObject
<CLLocationManagerDelegate>

+ (instancetype)sharedManager;

@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, strong, readonly) WXCondition *currentCondition;


- (void)findCurrentLocation;
- (NSString *)imageName:(int) icon;


@end