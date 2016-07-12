#import "BasicViewController.h"
#import "WXManager.h"
#import "SWRevealViewController.h"
#import "SearchTableViewController.h"


@import UIKit;

@interface WeatherContentController : BasicViewController

<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, WXManagerDelegate,SearchViewControllerDelegate>

@property (nonatomic) int cityWoeid;
@property (nonatomic) BOOL showCurrentLocationWeather;
@end
