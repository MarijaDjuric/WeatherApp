//
//  MenuViewController.h
//  WeatherApp
//
//  Created by Marija Djuric on 10/07/16.
//  Copyright © 2016 Marija Djuric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherContentController.h"

@interface MenuViewController : BasicViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
