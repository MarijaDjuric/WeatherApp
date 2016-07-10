
#import "WXCondition.h"
#import "WXDailyForecast.h"

@implementation WXCondition



+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"date": @"lastBuildDate",
             @"locationName": @"location.city",
             @"humidity": @"atmosphere.humidity",
             @"temperature": @"item.condition.temp",
             @"tempHigh": @"item.condition.temp",
             @"tempLow": @"item.condition.temp",
             @"sunrise": @"astronomy.sunrize",
             @"sunset": @"astronomy.sunset",
             @"conditionDescription": @"item.description",
             @"condition": @"item.condition.text",
             @"icon": @"item.condition.code",
             @"windBearing": @"wind.direction",
             @"windSpeed": @"wind.speed",
             @"forecast":@"item.forecast"
             };
}

#define MPS_TO_MPH 2.23694f

+ (NSValueTransformer *)windSpeedJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
        return @(num.floatValue*MPS_TO_MPH);
    } reverseBlock:^(NSNumber *speed) {
        return @(speed.floatValue/MPS_TO_MPH);
    }];
}


+(NSValueTransformer *)forecastJSONTransformer{
    
    return [NSValueTransformer  mtl_JSONArrayTransformerWithModelClass:[WXDailyForecast class]];

}



@end
