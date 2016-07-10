
#import "WXDailyForecast.h"

@implementation WXDailyForecast

+ (NSDictionary *)JSONKeyPathsByPropertyKey  {
  return @{
           @"tempHigh" : @"high",
           @"tempLow" :@"low",
           @"text":@"text",
           @"date":@"date",
           @"day":@"day",
           @"icon":@"code"
           };
}




@end
