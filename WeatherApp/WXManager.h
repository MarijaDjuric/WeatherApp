

@import Foundation;
@import CoreLocation;
#import "WXCondition.h"
#import "ReactiveCocoa.h"

@protocol WXManagerDelegate <NSObject>

-(void) showErrorMessage: (NSString *) message;

@end

@interface WXManager : NSObject
<CLLocationManagerDelegate>

+ (instancetype)sharedManager;

@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, strong, readonly) WXCondition *currentCondition;
@property (nonatomic, strong) NSArray * cities;
@property (nonatomic, strong) id<WXManagerDelegate> delegate;

- (void)findCurrentLocation;
- (void)searchForCitiesWithName:(NSString *) name;
- (NSString *)imageName:(int) icon;
-(void) getWeatherForPlaceWithWoeid:(int)woeid;

@end