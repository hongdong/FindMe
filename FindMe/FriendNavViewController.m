
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
        self.tabBarItem.image = [[UIImage imageNamed:@"tb2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"tb2s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
