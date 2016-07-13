//
//  Place.m
//  WeatherApp
//
//  Created by Marija Djuric on 10/07/16.
//  Copyright © 2016 Marija Djuric. All rights reserved.
//

#import "Place.h"

@implementation Place

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"country": @"country",
             @"woeid": @"woeid",
             @"latitude":@"centroid.latitude",
             @"longitude":@"centroid.longitude",
             };
}
@end

