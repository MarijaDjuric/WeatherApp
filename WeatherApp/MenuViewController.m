//
//  MenuViewController.m
//  WeatherApp
//
//  Created by Marija Djuric on 10/07/16.
//  Copyright © 2016 Marija Djuric. All rights reserved.
//
#import "SWRevealViewController.h"

#import "MenuViewController.h"

@interface MenuViewController ()

@property (strong, nonatomic) NSArray* menuItems;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.menuItems.count + 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    //[UIColor whiteColor];
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:14];
    cell.imageView.image = [UIImage imageNamed:@"pin"];
    
   
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Add new location";


    }else if(indexPath.row == 1){
        cell.textLabel.text = @"Current location";

    }
    
    return cell;
}



#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        
    }
    else{
        if(indexPath.row == 1){
        [self.revealViewController revealToggle:self];
            ((WeatherContentController *)self.revealViewController.frontViewController).showCurrentLocationWeather = YES;
        }
    }
}



@end
