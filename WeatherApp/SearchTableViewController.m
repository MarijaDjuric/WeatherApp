//
//  SearchTableViewController.m
//  WeatherApp
//
//  Created by Marija Djuric on 11/07/16.
//  Copyright © 2016 Marija Djuric. All rights reserved.
//

#import "SearchTableViewController.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>

@interface SearchTableViewController ()
@property (nonatomic, strong) NSArray * cities;
@property (strong, nonatomic) NSTimer *searchTimer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIImageView *blurredImageView;

@end

@implementation SearchTableViewController

NSArray *searchResults;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WXManager sharedManager].delegate = self;

     self.activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.activityView.center=self.view.center;
    [self.view addSubview:self.activityView];

    self.searchTextField.delegate = self;
    [self.searchTextField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    [[RACObserve([WXManager sharedManager], cities)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *cities) {
         self.cities = cities;
         [self.activityView stopAnimating];
         [self.tableView reloadData];
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.cities count];
 
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityTableCell" forIndexPath:indexPath];

    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:@"cityTableCell"];
        
    }
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
    [cell setSelectedBackgroundView:bgColorView];

    Place* place = [self.cities objectAtIndex:indexPath.row];

    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    cell.textLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
    cell.detailTextLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
    cell.textLabel.text = place.name;
    cell.detailTextLabel.text = place.country;
  

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if([self.cities count] >= indexPath.row){
        [self.delegate chosePlace:[self.cities objectAtIndex:indexPath.row]];
        [self backButtonPressed:self];
       
    }
    
}

#pragma mark - Action methods

- (IBAction)backButtonPressed:(id)sender {
    [WXManager sharedManager].cities = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)textFieldDidChange :(UITextField *)theTextField{
    
    if ([theTextField.text length] == 0) {
        
        [self stopSearchTimer];
        self.cities = nil;
        [self.tableView reloadData];
        
    }else if([theTextField.text length]>0){
        [self startSearchTimer];
    }
}
#pragma mar - Private methods

-(void)searchForCities{
    [self.activityView startAnimating];
    [[WXManager sharedManager] searchForCitiesWithName:self.searchTextField.text];
}

- (void)startSearchTimer {
    [self stopSearchTimer];
    if (self.searchTimer == nil) {
        
        self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.7
                                                            target:self
                                                          selector:@selector(searchForCities)
                                                          userInfo:nil
                                                           repeats:NO];
        
    }
}

- (void)stopSearchTimer {
    if (self.searchTimer || [self.searchTimer isValid]) {
        [self.searchTimer invalidate];
        self.searchTimer = nil;
    }
}

#pragma mark - Text Field delegate


-(void)textFieldDidEndEditing:(UITextField *)textField{
     [self.searchTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma  mark - WXManager Delegate

-(void) showErrorMessage:(NSString *)message{
    
    [self.activityView stopAnimating];
    [self.tableView reloadData];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
@end
