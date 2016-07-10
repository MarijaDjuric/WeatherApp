#import "BasicViewController.h"
#import "WXManager.h"
#import "SWRevealViewController.h"
@import UIKit;

@interface WeatherContentController : BasicViewController

<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, WXManagerDelegate>

@property (nonatomic) int cityWoeid;
@property (nonatomic) BOOL showCurrentLocationWeather;
@end
