

#import "WXManager.h"
#import "WXClient.h"
#import <TSMessages/TSMessage.h>


@interface WXManager ()

@property (nonatomic, strong, readwrite) WXCondition *currentCondition;
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isFirstUpdate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) WXClient *client;
@property (nonatomic, strong) NSMutableDictionary * citiesWeather;

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
        
        [[[[RACObserve(self, currentLocation)
            ignore:nil]
          
           flattenMap:^(CLLocation *newLocation) {
               return [self updateMyLocationCurrentConditions];
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
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        _citiesWeather= [NSMutableDictionary new];

        
        NSData *citiesWeatherDictionaryData = [userDefaults objectForKey:@"citiesWeather"];
        if (citiesWeatherDictionaryData) {
            NSMutableDictionary *citiesWeatherDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:citiesWeatherDictionaryData];
            if (citiesWeatherDictionary) {
                _citiesWeather = citiesWeatherDictionary;
                
            }
        }
    
    }
    return self;
}

- (void)findCurrentLocation {
    self.isFirstUpdate = YES;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

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

- (RACSignal *)updateMyLocationCurrentConditions {
    return [[self.client fetchCurrentConditionsForLocation:self.currentLocation.coordinate] doNext:^(WXCondition *condition) {
        self.currentCondition = condition;
    }];
}

- (RACSignal *)updateCurrentConditionsForCity:(int) woeid {
    return [[self.client fetchCurrentConditionsForCity:woeid] doNext:^(WXCondition *condition) {
        self.currentCondition = condition;
    }];
}

- (RACSignal *)getCitiesWithName:(NSString *) name {
    return [[self.client fetchCitiesWithName:name] doNext:^(NSArray *cities) {
        self.cities = cities;
    }];
}


- (NSString *)imageName: (int) icon{
  
   if(icon == 0){
        return @"";
    }
    else if(icon < 5|| (icon >37 && icon <39) || icon == 45 || icon == 47){
        return @"weather-tstorm";
    }
    else if((icon > 4 && icon <11) || icon == 35 ){
        return @"weather-rain";
    }
    else if(icon > 18 && icon < 24){
       return @"weather-mist";
    }
    else if((icon > 10 && icon < 19) && (icon > 40 && icon < 44) && icon == 46){;
        return @"weather-snow";
    }
    else if((icon > 23 && icon < 29) && icon == 44){
        return @"weather-broken";
    }
    else if(icon == 29){
        return @"weather-few-night";
    }
    else if(icon == 30){
        return @"weather-few";
    }
    else if(icon == 32 || icon == 34 || icon ==36){
        return @"weather-clear";
    }
    else if(icon == 31|| icon == 33){
        return @"weather-moon";
    }
   return @"weather-scattered";
}

- (void)searchForCitiesWithName:(NSString *) name{
    self.name = name;
    [self getCitiesWithName:name];
}


-(void)citiesWeather:(NSMutableDictionary *)citiesWeather{
    
    _citiesWeather = citiesWeather;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:citiesWeather] forKey:@"citiesWeather"];
    [defaults synchronize];
}
@end
