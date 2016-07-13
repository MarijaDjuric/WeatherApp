#import "BasicViewController.h"
#import "WXManager.h"
#import "SWRevealViewController.h"
#import "SearchTableViewController.h"


@import UIKit;

@interface WeatherContentController : BasicViewController

<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, WXManagerDelegate,SearchViewControllerDelegate>

@property (nonatomic, strong) Place* place;
@property (nonatomic) BOOL showCurrentLocationWeather;

-(void)openSearch;
@end
