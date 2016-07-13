

#import "WXManager.h"
#import "WXClient.h"
#import <TSMessages/TSMessage.h>
#import "Places.h"


@interface WXManager ()

@property (nonatomic, strong, readwrite) WXCondition *currentCondition;
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;
@property (nonatomic, strong, readwrite) NSArray *hourlyForecast;
@property (nonatomic, strong, readwrite) NSArray *dailyForecast;
@property (nonatomic, strong, readwrite) Place* place;
@property (nonatomic, strong) NSString* name;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isFirstUpdate;
@property (nonatomic, strong) WXClient *client;

@end

@implementation WXManager

+ (instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (id)init {
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
        _client = [[WXClient alloc] init];
        self.placesWeather = [[NSMutableDictionary alloc]init];
        
        //Add observers for properties
        
        [[[[RACObserve(self, currentLocation)
            ignore:nil]
          
           flattenMap:^(CLLocation *newLocation) {
               return [RACSignal merge:@[
                                         [self updateCurrentConditionsForLocation:newLocation.coordinate],
                                         [self updateDailyForecastForLocation:newLocation.coordinate],
                                         [self updateHourlyForecastForLocation:newLocation.coordinate]
                                         ]];
           }] deliverOn:RACScheduler.mainThreadScheduler]
         subscribeError:^(NSError *error) {
             NSString *message = @"There was a problem fetching the latest weather.";
             [self.delegate showErrorMessage:message];
           
         }];
        
    
        
        [[[[RACObserve(self, place)
            ignore:nil]
           flattenMap:^(Place* place) {
               return [RACSignal merge:@[
                                         [self updateCurrentConditionsForLocation: CLLocationCoordinate2DMake(place.latitude.floatValue, place.longitude.floatValue) ],
                                         [self updateDailyForecastForLocation:CLLocationCoordinate2DMake(place.latitude.floatValue, place.longitude.floatValue) ],
                                         [self updateHourlyForecastForLocation:CLLocationCoordinate2DMake(place.latitude.floatValue, place.longitude.floatValue) ]
                                         ]];
           }] deliverOn:RACScheduler.mainThreadScheduler]
         subscribeError:^(NSError *error) {
             NSString *message = @"There was a problem fetching the latest weather.";
             [self.delegate showErrorMessage:message];
             
         }];
        
        [[[[RACObserve(self, name)
            ignore:nil]
           
           flattenMap:^(NSString *name) {
               return [self getCitiesWithName:name];
           }] deliverOn:RACScheduler.mainThreadScheduler]
         subscribeError:^(NSError *error) {
             NSString *message = @"There was a problem fetching response";
             [self.delegate showErrorMessage:message];
             
         }];

        
    }
    return self;
}


#pragma mark Locaton manager

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (self.isFirstUpdate) {
        self.isFirstUpdate = NO;
        return;
    }
    
    CLLocation *location = [locations lastObject];
    
    if (location.horizontalAccuracy > 0) {
        self.currentLocation = location;
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
 
    NSString *message = @"There was a problem fetching your location.";
    [self.delegate showErrorMessage:message];
}

#pragma mark Private methods


- (RACSignal *)getCitiesWithName:(NSString *) name {
    return [[self.client fetchCitiesWithName:name] doNext:^(Places *results) {
        self.cities = results.places;
    }];
}

// Get weather for my location with lat/long

- (RACSignal *)updateCurrentConditionsForLocation:(CLLocationCoordinate2D )location {
    return [[self.client fetchCurrentConditionsForLocation:location] doNext:^(WXCondition *condition) {
        self.currentCondition = condition;
    }];
}


- (RACSignal *)updateHourlyForecastForLocation:(CLLocationCoordinate2D ) location {
    return [[self.client fetchHourlyForecastForLocation:location] doNext:^(NSArray *conditions) {
        self.hourlyForecast = conditions;
    }];
}

- (RACSignal *)updateDailyForecastForLocation:(CLLocationCoordinate2D )location {
    return [[self.client fetchDailyForecastForLocation:location] doNext:^(NSArray *conditions) {
        self.dailyForecast = conditions;
    }];
}


#pragma mark Publich methods

- (void)searchForCitiesWithName:(NSString *) name{
    //Observer will call methods for fetching data
    self.name = name;
}

-(void)getWeatherForPlace:(Place *)place{

    //Observer will call methods for fetching data
    self.place = place;
    [self.placesWeather setObject:place forKey:place.woeid];


}

- (void)findCurrentLocation {
    self.isFirstUpdate = YES;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}


@end
