//
//  Places.h
//  WeatherApp
//
//  Created by Marija Djuric on 11/07/16.
//  Copyright © 2016 Marija Djuric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface Places : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSArray *places;

@end
