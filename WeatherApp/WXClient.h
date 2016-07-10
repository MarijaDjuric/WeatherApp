

@import Foundation;
@import CoreLocation;
#import "ReactiveCocoa.h"


@interface WXClient : NSObject

- (RACSignal *)fetchJSONFromURL:(NSURL *)url;
- (RACSignal *)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate;
- (RACSignal *)fetchCurrentConditionsForCity:(int) woeid;
- (RACSignal *)fetchCitiesWithName:(NSString *) name;
@end
