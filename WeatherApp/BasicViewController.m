

#import "BasicViewController.h"

#import "MBProgressHUD.h"


@interface BasicViewController ()

@property (strong, nonatomic) NSTimer *timerProgress;
@property (nonatomic) BOOL isProgressViewShown;

@end

@implementation BasicViewController

static MBProgressHUD *mbProgressHud;

- (void) viewDidLoad
{
    [super viewDidLoad];

    [self initializeGui];
}

- (void) initializeGui
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//appDelegate.presentingViewController = self;
    if (!mbProgressHud) {
		mbProgressHud = [[MBProgressHUD alloc] initWithView:appDelegate.window];
	}
    
	self.isProgressViewShown = NO;
}

- (void) showProgressWithInfoMessage:(NSString *)message
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.window addSubview:mbProgressHud];
	mbProgressHud.mode = MBProgressHUDModeIndeterminate;
	mbProgressHud.labelText = @"";
    mbProgressHud.color = [UIColor colorWithWhite:0.4 alpha:0.8];
	mbProgressHud.detailsLabelText = message;
	self.isProgressViewShown = YES;
    
    [self startTimer];
    
    [mbProgressHud show:YES];
}

- (void) showTemporaryInfoMessage:(NSString *)message
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:mbProgressHud];
    mbProgressHud.customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 1)];
    mbProgressHud.customView.backgroundColor = [UIColor clearColor];
    mbProgressHud.mode = MBProgressHUDModeCustomView;
    [mbProgressHud show:YES];
    mbProgressHud.labelText = @"";
    mbProgressHud.detailsLabelText = message;
    self.isProgressViewShown = YES;
    [self killTimer];
    [mbProgressHud hide:YES afterDelay:2];
}

- (void) updateProgressWithInfoMessage :(NSString *) message
{
    mbProgressHud.labelText = @"";
    mbProgressHud.detailsLabelText = message;
}

- (void) hideProgressAndMessage
{
    self.isProgressViewShown = NO;
    [mbProgressHud hide:YES];
    [mbProgressHud removeFromSuperview];
    [self killTimer];
}

/*--------------------------------------------------------------
 * Timer for Spinner
 *-------------------------------------------------------------*/

- (void) killTimer
{
    [self clearTimeProgress];
}

- (void) stopTimer
{
    [self clearTimeProgress];
    
    if (self.isProgressViewShown)
    {
        [self showTemporaryInfoMessage:@"Service timeout ..."];
    }
    
    
}

- (void) startTimer
{
    [self clearTimeProgress];
    
    @synchronized (self)
    {
        self.timerProgress = [NSTimer scheduledTimerWithTimeInterval:30.0
                                                              target:self
                                                            selector:@selector(stopTimer)
                                                            userInfo:nil
                                                             repeats:NO];
    }
}

- (void) clearTimeProgress
{
    @synchronized (self)
    {
        if (self.timerProgress)
        {
            [self.timerProgress invalidate];
            self.timerProgress = nil;
        }
    }
}



@end
