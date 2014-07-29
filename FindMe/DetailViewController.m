//
//  DetailViewController.m
//  FindMe
//
//  Created by mac on 14-7-4.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "DetailViewController.h"
#import "JMWhenTapped.h"
#import "UIImageView+WebCache.h"
#import "XYAlertViewHeader.h"
#import "User.h"
#import "UIImageView+MJWebCache.h"
#import "AFNetworking.h"
#import "UIView+Common.h"
@interface DetailViewController (){
    User *_user;
    LXActionSheet *_actionSheet;
    UIImagePickerController *_imagePicker;
}

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _user = [User getUserFromNSUserDefaults];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak __typeof(&*self)weakSelf = self;
    
    self.photo.layer.cornerRadius = 35.0f;
    self.photo.layer.masksToBounds = YES;
    [self.photo whenTouchedDown:^{
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            weakSelf.photo.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
        } completion:nil];
    }];
    
    [self.photo whenTouchedUp:^{
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            weakSelf.photo.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        } completion:nil];
        
        _actionSheet = [[LXActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"]];
        [_actionSheet showInView:self.view];
    }];
    
    
    [self.nicknameView whenTouchedDown:^{
        weakSelf.nicknameView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.nicknameView whenTouchedUp:^{
        weakSelf.nicknameView.backgroundColor = [UIColor whiteColor];
        XYInputView *inputView = [XYInputView inputViewWithTitle:@"修改小名"
                                                         message:@"显示给别人看的昵称"
                                                     placeholder:@"说些什么吧"
                                                     initialText:_user.userNickName
                                                         buttons:[NSArray arrayWithObjects:@"放弃", @"确定", nil]
                                                    afterDismiss:^(int buttonIndex, NSString *text) {
                                                        
                                                        if(buttonIndex == 1){
                                                            if (![weakSelf isOK:text]) {
                                                                [weakSelf showHint:@"不能为空"];
                                                                return;
                                                            }
                                                            if ([text isEqualToString:_user.userNickName]) {
                                                                return;
                                                            }
                                                        
                                                            [weakSelf updateInfo:@{@"userNickName": text}];
                                                        }
                                                    }];
        [inputView setButtonStyle:XYButtonStyleGreen atIndex:1];
        [inputView show];
    }];
    
    [self.qianmingView whenTouchedDown:^{
        weakSelf.qianmingView.backgroundColor = [UIColor lightGrayColor];
    }];
    [self.qianmingView whenTouchedUp:^{
        weakSelf.qianmingView.backgroundColor = [UIColor whiteColor];
        XYInputView *inputView = [XYInputView inputViewWithTitle:@"修改签名"
                                                         message:@"展示个性签名"
                                                     placeholder:@"说些什么吧"
                                                     initialText:_user.userSignature
                                                         buttons:[NSArray arrayWithObjects:@"放弃", @"确定", nil]
                                                    afterDismiss:^(int buttonIndex, NSString *text) {
                                                        if(buttonIndex == 1){
                                                            if (![weakSelf isOK:text]) {
                                                                [weakSelf showHint:@"不能为空"];
                                                                return;
                                                            }
                                                            if ([text isEqualToString:_user.userSignature]) {
                                                                return;
                                                            }
                                                            [weakSelf updateInfo:@{@"userSignature": text}];
                                                        }
                                                        
                                                    }];
        [inputView setButtonStyle:XYButtonStyleGreen atIndex:1];
        [inputView show];
    }];
    
    [self.photo setImageURLStr:_user.userPhoto placeholder:[UIImage imageNamed:@"defaultImage"]];
    CGSize size = CGSizeMake(320,2000);
    CGSize realsize = [_user.userRealName sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    self.realName.bounds = (CGRect){{0,0},realsize};
    self.realName.center = CGPointMake(self.photo.left+self.photo.width*0.5, self.photo.bottom+18);
    self.realName.text = _user.userRealName;
    self.sex.center = CGPointMake(self.realName.right+10, self.photo.bottom+18);
    if ([_user.userSex isEqualToString:@"男"]) {
        self.sex.image = [UIImage imageNamed:@"boy"];
    }else{
        self.sex.image = [UIImage imageNamed:@"girl"];
    }
    if ([_user.userAuth integerValue]==1) {
        self.vUserImg.center = CGPointMake(self.sex.right+10, self.photo.bottom+18);
        self.vUserImg.hidden = NO;
    }
    self.nickname.text = _user.userNickName;
    
    self.qianming.text = _user.userSignature;
    
    self.constellation.text = _user.userConstellation;
    
    self.school.text = [_user getSchoolName];
    
    self.department.text = [_user getDepartmentName];
    
    self.grade.text = _user.userGrade;
    
}

-(BOOL)isOK:(NSString *)text{
    NSString *temp = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(temp.length==0)
    {
        return NO;
    }

    return YES;
}

-(void)updateInfo:(NSDictionary *)parameters{
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/user/update_info.do",Host];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak __typeof(&*self)weakSelf = self;
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            NSLog(@"修改用户资料成功");

            if ([parameters objectForKey:@"userSignature"]!=nil) {
                weakSelf.qianming.text = [parameters objectForKey:@"userSignature"];
                _user.userSignature = [parameters objectForKey:@"userSignature"];
            }else{
                weakSelf.nickname.text = [parameters objectForKey:@"userNickName"];
                _user.userNickName = [parameters objectForKey:@"userNickName"];
            }
            
            [_user saveToNSUserDefaults];
        }else{
            NSLog(@"修改用户资料失败");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"修改用户资料失败");
        
    }];
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
                [weakSelf showHint:@"请选择照片"];
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
                [weakSelf showHint:@"请选择照片"];
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
            [self updatePhoto];
        }
        
        
        
    }];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)updatePhoto{
    [self showHudInView:self.view.window hint:@"上传中..."];
    NSString *url = [NSString stringWithFormat:@"%@/data/user/user_uphoto.do",Host];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak __typeof(&*self)weakSelf = self;
    NSURL *filePath = [NSURL fileURLWithPath:[[self documentFolderPath] stringByAppendingString:@"/myPhoto.png"]];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePath name:@"photo" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            [weakSelf showResultWithType:ResultSuccess];
            _user.userPhoto = [responseObject objectForKey:@"userPhoto"];
            [_user saveToNSUserDefaults];
        }else if ([state isEqualToString:@"10001"]){
            
        }else{
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf showResultWithType:ResultError];
        NSLog(@"Error: %@", error);
    }];
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    self.photo.image = tempImage;
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


@end
