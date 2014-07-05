//
//  PersonInfoViewController.m
//  FindMe
//
//  Created by mac on 14-6-27.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "NYSegmentedControl.h"
#import "JMWhenTapped.h"
#import "ChooseConstellationViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "EaseMob.h"
#import "EMError.h"

@interface PersonInfoViewController (){
    LXActionSheet *_actionSheet;
    UIImagePickerController *_imagePicker;
    NSString *_constellationStr;
}

@end

@implementation PersonInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpForDismissKeyboard];
    
    self.phtot.layer.cornerRadius = 25.0f;
    self.phtot.layer.masksToBounds = YES;
    
    NYSegmentedControl *segmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"GG", @"MM"]];
    
    // Add desired targets/actions
    [segmentedControl addTarget:self action:@selector(segmentSelected) forControlEvents:UIControlEventValueChanged];
    segmentedControl.center = CGPointMake(self.sexView.center.x - 80, 2);
    // Customize and size the control
    segmentedControl.titleTextColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    segmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    segmentedControl.borderWidth = 1.0f;
    segmentedControl.borderColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
    segmentedControl.drawsGradientBackground = YES;
    segmentedControl.segmentIndicatorInset = 2.0f;
    segmentedControl.drawsSegmentIndicatorGradientBackground = YES;
    segmentedControl.segmentIndicatorGradientTopColor = [UIColor colorWithRed:0.30 green:0.50 blue:0.88f alpha:1.0f];
    segmentedControl.segmentIndicatorGradientBottomColor = [UIColor colorWithRed:0.20 green:0.35 blue:0.75f alpha:1.0f];
    segmentedControl.segmentIndicatorAnimationDuration = 0.3f;
    segmentedControl.segmentIndicatorBorderWidth = 0.0f;
    [segmentedControl sizeToFit];
    [self.sexView addSubview:segmentedControl];
    

    
    __weak __typeof(&*self)weakSelf = self;
	[self.constellationView whenTouchedDown:^{
		weakSelf.constellationView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	}];
    
	[self.constellationView whenTouchedUp:^{
		weakSelf.constellationView.backgroundColor = [UIColor whiteColor];
        [self performSegueWithIdentifier:@"chooseConstellation" sender:self];
	}];
    
    
    [self.photoView whenTouchedDown:^{
        weakSelf.photoView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }];
    
    [self.photoView whenTouchedUp:^{
		weakSelf.photoView.backgroundColor = [UIColor whiteColor];
        [weakSelf.view endEditing:YES];
        _actionSheet = [[LXActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"]];
        [_actionSheet showInView:self.view];
	}];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"chooseConstellation"])
    {
        
        __weak ChooseConstellationViewController *controller=(ChooseConstellationViewController *)segue.destinationViewController;
        controller.personInfoViewController = sender;
    }
}
- (IBAction)submitPressed:(id)sender {
    [self.view endEditing:YES];
    if (![self isOK]) {
        return;
    }
    
    [self showHudInView:self.view hint:@"请稍后..."];
    _user.userRealName = self.nameTextField.text;
    _user.constellation = _constellationStr;
    
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@/data/user/rgst_user.do",Host];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"userNickName": _user.userNickName,
                                 @"school._id": _user.userScNo,
                                 @"school.schoolName": _user.userScName,
                                 @"department._id": _user.userDeptNo,
                                 @"department.deptName": _user.userDeptName,
                                 @"userConstellation": _user.constellation,
                                 @"userGrade": _user.userGrade,
                                 @"userSex": _user.userSex,
                                 @"userEquipment.equitNo": [[Config sharedConfig] getRegistrationID],
                                 @"userEquipment.osType": @"1",
                                 @"userOpenId": _user.openId,
                                 @"userAuthType": _user.userAuthType,
                                 @"userRealName": _user.userRealName
                                 };
    
    
    __weak __typeof(&*self)weakSelf = self;
    NSURL *filePath = [NSURL fileURLWithPath:[[self documentFolderPath] stringByAppendingString:@"/myPhoto.png"]];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePath name:@"photo" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"进度 %lu%+lld+%lld",(unsigned long)bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
        }];
        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            

            _user._id = [responseObject objectForKey:@"userId"];
            
            [weakSelf showResultWithType:ResultSuccess];
            [_user saveToNSUserDefaults];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];


        }else if ([state isEqualToString:@"10001"]){
            [weakSelf showResultWithType:ResultError];
        }else{
            [weakSelf showResultWithType:ResultError];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf showResultWithType:ResultError];
        NSLog(@"Error: %@", error);
    }];
}
- (void)segmentSelected {

}


-(BOOL)isOK{
    
    NSString *temp = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(temp.length==0)
    {
        [HDTool ToastNotification:@"名字不能为空" andView:self.view andLoading:NO andIsBottom:NO];
        return NO;
    }
    temp = [_constellationStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    if (temp.length==0) {
        [HDTool ToastNotification:@"星座不选吗" andView:self.view andLoading:NO andIsBottom:NO];
        return NO;
    }
    return YES;
}

-(void)setConstellation:(NSIndexPath *)indexPath{
    NSString *imageStr = [NSString stringWithFormat:@"xzd%ld",(long)indexPath.row];
    switch (indexPath.row) {
        case 0:
            _constellationStr =@"白羊座";

            break;
        case 1:
            _constellationStr =@"金牛座";
            break;
        case 2:
            _constellationStr =@"双子座";
            break;
        case 3:
            _constellationStr =@"巨蟹座";
            break;
        case 4:
            _constellationStr =@"狮子座";
            break;
        case 5:
            _constellationStr =@"处女座";
            break;
        case 6:
            _constellationStr =@"天平座";
            break;
        case 7:
            _constellationStr =@"天蝎座";
            break;
        case 8:
            _constellationStr =@"射手座";
            break;
        case 9:
            _constellationStr =@"魔蝎座";
            break;
        case 10:
            _constellationStr =@"水瓶座";
            break;
        case 11:
            _constellationStr =@"双鱼座";
            break;
        default:
            break;
    }
    self.constellationImageView.image = [UIImage imageNamed:imageStr];
    self.constellationLbl.text = _constellationStr;
}
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    singleTapGR.delegate = self;
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ((touch.view ==self.constellationView)||(touch.view ==self.photoView)) {
        return NO;
    }
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.nameTextField resignFirstResponder];
}

#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger *)buttonIndex
{
    __weak __typeof(&*self)weakSelf = self;
    switch ((int)buttonIndex) {
        case 0:
        {
            _imagePicker = [[UIImagePickerController alloc] init];
            _imagePicker.delegate = self;
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            _imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
            _imagePicker.allowsEditing = YES;
            [self presentViewController:_imagePicker animated:YES completion:^{
                [weakSelf showHint:@"期待你真实的头像"];
            }];

            break;}
        case 1:
        {
            _imagePicker = [[UIImagePickerController alloc] init];
            _imagePicker.delegate = self;
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            _imagePicker.allowsEditing = YES;
            _imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
            //[self presentModalViewController:_imagePicker animated:YES];
            [self presentViewController:_imagePicker animated:YES completion:^{
                [weakSelf showHint:@"期待你真实的头像"];
            }];
            break;}
        default:
            break;
    }
}
#pragma UIImagePickerControllerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        //判断是静态图像还是视频
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            UIImage *image= [info objectForKey:@"UIImagePickerControllerEditedImage"];
            //        UIImage *image= [self scaleToSize:[info objectForKey:@"UIImagePickerControllerOriginalImage"] size:CGSizeMake(300,300)];
            [self saveImage:image WithName:@"myPhoto.png"];
        }

        

    }];
    
    
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    self.phtot.image = tempImage;
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}
- (NSString *)documentFolderPath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
