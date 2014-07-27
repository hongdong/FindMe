
#import "FriendNavViewController.h"

@interface FriendNavViewController ()

@end

@implementation FriendNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tb2s"]
                      withFinishedUnselectedImage:[UIImage imageNamed:@"tb2"]];
        self.tabBarItem.tag = 2;
        self.navigationBar.translucent = NO;        
        if ([[Config sharedConfig] friendNew:nil]) {
            self.tabBarItem.badgeValue = @"NEW";
        }
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
