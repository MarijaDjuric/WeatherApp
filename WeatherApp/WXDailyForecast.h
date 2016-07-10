
#import "Mantle.h"
#import "WXCondition.h"

@interface WXDailyForecast : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *tempHigh;
@property (nonatomic, strong) NSNumber *tempLow;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSNumber *icon;
@end
