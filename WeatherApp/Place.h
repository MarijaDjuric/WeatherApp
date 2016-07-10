//
//  Place.h
//  WeatherApp
//
//  Created by Marija Djuric on 10/07/16.
//  Copyright © 2016 Marija Djuric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface Place :  MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *country;
@property (nonatomic) NSNumber *woeid;

@end
