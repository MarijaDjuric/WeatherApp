

@import Foundation;
@import CoreLocation;
#import "WXCondition.h"
#import "ReactiveCocoa.h"
#import "Place.h"

@protocol WXManagerDelegate <NSObject>

-(void) showErrorMessage: (NSString *) message;

@end

@interface WXManager : NSObject
<CLLocationManagerDelegate>

+ (instancetype)sharedManager;

@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, strong, readonly) WXCondition *currentCondition;
@property (nonatomic, strong, readonly) NSArray *hourlyForecast;
@property (nonatomic, strong, readonly) NSArray *dailyForecast;
@property (nonatomic, strong,readonly) Place* place;
@property (nonatomic, strong) NSMutableDictionary * placesWeather;

@property (nonatomic, strong) NSArray * cities;
@property (nonatomic, strong) id<WXManagerDelegate> delegate;

- (void)findCurrentLocation;
- (void)searchForCitiesWithName:(NSString *) name;
-(void)getWeatherForPlace:(Place *)place;
-(void)getWeatherForLocation:(CLLocation *)location;

@end