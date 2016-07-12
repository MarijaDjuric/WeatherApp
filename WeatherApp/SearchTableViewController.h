//
//  SearchTableViewController.h
//  WeatherApp
//
//  Created by Marija Djuric on 11/07/16.
//  Copyright © 2016 Marija Djuric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXManager.h"
#import "Place.h"
#import "BasicViewController.h"
@protocol SearchViewControllerDelegate <NSObject>

-(void)chosePlace:(Place *)place;

@end

@interface SearchTableViewController : BasicViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,WXManagerDelegate>

@property (strong, nonatomic) id<SearchViewControllerDelegate> delegate;
@end
