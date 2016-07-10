//

#import "WXClient.h"
#import "WXCondition.h"
#import "WXDailyForecast.h"
#import "Place.h"

#define YQLQUERY_PREFIX @"http://query.yahooapis.com/v1/public/yql?q="
#define YQLQUERY_SUFFIX @"&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
#define YAHOO_APP_ID  @"a5a66b16e82bdb9bc80a0988d07c9482f1ccbc7e"

@interface WXClient ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation WXClient

- (id)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

- (RACSignal *)fetchJSONFromURL:(NSURL *)url {
    NSLog(@"Fetching: %@",url.absoluteString);
    
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (! error) {
                NSError *jsonError = nil;
                id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                if (! jsonError) {
                    
                    [subscriber sendNext:json];
                }
                else {
                    [subscriber sendError:jsonError];
                }
            }
            else {
                [subscriber sendError:error];
            }
            
            [subscriber sendCompleted];
        }];
        
        [dataTask resume];
        
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }] doError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    return signal;
}

- (RACSignal *)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate {
    NSString * statement = [NSString stringWithFormat:@"select * from weather.forecast where woeid=2502265 and u = 'c'"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", YQLQUERY_PREFIX, [statement stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]], YQLQUERY_SUFFIX];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        NSDictionary *resultJson = json[@"query"][@"results"][@"channel"];

        return [MTLJSONAdapter modelOfClass:[WXCondition class] fromJSONDictionary:resultJson error:nil];
    }];
}


- (RACSignal *)fetchCurrentConditionsForCity:(int) woeid {
    
    NSString * statement = [NSString stringWithFormat:@"select * from weather.forecast where woeid=%d and u = 'c'", woeid];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", YQLQUERY_PREFIX, [statement stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], YQLQUERY_SUFFIX];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        return [MTLJSONAdapter modelOfClass:[WXCondition class] fromJSONDictionary:json error:nil];
    }];
}


- (RACSignal *)fetchCitiesWithName:(NSString *) name {
    
    NSString * statement = [NSString stringWithFormat:@"http://where.yahooapis.com/v1/places.q('%@');count=0;?appid=%@&format=json",name,YAHOO_APP_ID];
    
    NSString *urlString = [NSString stringWithFormat:@"%@", [statement stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        
        return [NSValueTransformer  mtl_JSONArrayTransformerWithModelClass:[Place class]];
    }];
}
@end
