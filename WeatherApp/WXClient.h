

@import Foundation;
@import CoreLocation;
#import "ReactiveCocoa.h"

@interface WXClient : NSObject

- (RACSignal *)fetchJSONFromURL:(NSURL *)url;
- (RACSignal *)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate;


@end
