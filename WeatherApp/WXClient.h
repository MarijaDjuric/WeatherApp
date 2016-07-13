

@import Foundation;
@import CoreLocation;
#import "ReactiveCocoa.h"
#import "Place.h"

@interface WXClient : NSObject

- (RACSignal *)fetchJSONFromURL:(NSURL *)url;

- (RACSignal *)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate;
- (RACSignal *)fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate;
- (RACSignal *)fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate;


- (RACSignal *)fetchCitiesWithName:(NSString *) name;
@end
