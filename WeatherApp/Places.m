//
//  Places.m
//  WeatherApp
//
//  Created by Marija Djuric on 11/07/16.
//  Copyright © 2016 Marija Djuric. All rights reserved.
//

#import "Places.h"
#import "Place.h"

@implementation Places


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"places": @"place"
           
             };
}

+(NSValueTransformer *)placesJSONTransformer{
    
    return [NSValueTransformer  mtl_JSONArrayTransformerWithModelClass:[Place class]];
    
}

@end
