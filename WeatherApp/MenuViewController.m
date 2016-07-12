//
//  MenuViewController.m
//  WeatherApp
//
//  Created by Marija Djuric on 10/07/16.
//  Copyright © 2016 Marija Djuric. All rights reserved.
//
#import "SWRevealViewController.h"
#import "WXManager.h"
#import "MenuViewController.h"
#import "Place.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView setFrame:CGRectMake(0,0, 260,self.tableView.frame.size.height)];
    [self.tableView reloadData];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[WXManager sharedManager].placesWeather allKeys] count] + 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"menuTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0];

    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:14];
    cell.detailTextLabel.text = nil;
   
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Add new location";


    }else if(indexPath.row == 1){
        cell.textLabel.text = @"Current location";
        cell.imageView.image = [UIImage imageNamed:@"pin"];


    }else{
        
        NSNumber* woeid = [[[WXManager sharedManager].placesWeather allKeys] objectAtIndex:indexPath.row - 2];
        Place *place = [[WXManager sharedManager].placesWeather objectForKey:woeid];
        cell.textLabel.text = place.name;
        cell.detailTextLabel.text = place.country;
        cell.imageView.image = [UIImage imageNamed:@"pin"];

        
    }
    
    return cell;
}



#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.revealViewController revealToggle:self];

    if(indexPath.row == 0){
        [((WeatherContentController *)self.revealViewController.frontViewController) openSearch];
    }
    else if(indexPath.row == 1){
            ((WeatherContentController *)self.revealViewController.frontViewController).showCurrentLocationWeather = YES;
        
    }else{

        NSNumber* woeid = [[[WXManager sharedManager].placesWeather allKeys] objectAtIndex:indexPath.row - 2];
        Place *place = [[WXManager sharedManager].placesWeather objectForKey:woeid];
        [[WXManager sharedManager] getWeatherForPlace:place];
    }
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < 2){
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber* woeid = [[[WXManager sharedManager].placesWeather allKeys] objectAtIndex:indexPath.row - 2];
    [[WXManager sharedManager].placesWeather removeObjectForKey:woeid];
    [self.tableView reloadData];
    NSLog(@"Deleted row.");
}


@end
