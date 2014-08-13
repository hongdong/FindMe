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
#import "UIView+Common.h"
#import "NSString+HD.h"
#import "TNSexyImageUploadProgress.h"
@interface DetailViewController (){
    User *_user;
    LXActionSheet *_actionSheet;
    UIImagePickerController *_imagePicker;
    QiniuSimpleUploader *_uploader;
    NSString *_photoName;
    TNSexyImageUploadProgress *_progress;
    UIImage *_image;
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
    
    self.photo.layer.cornerRadius = 40.0f;
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
    [self.photo sd_setImageWithURL:[HDTool getSImage:_user.userPhoto] placeholderImage:[UIImage imageNamed:@"defaultImage"] options:SDWebImageRetryFailed];
    CGSize size = CGSizeMake(320,2000);

    CGSize realsize = [_user.userRealName getRealSize:size andFont:[UIFont systemFontOfSize:14.0f]];
    self.realName.bounds = (CGRect){{0,0},realsize};
    self.realName.center = CGPointMake(self.photo.left+self.photo.width*0.5, self.photo.bottom+18);
    self.realName.text = _user.userRealName;
    self.sex.center = CGPointMake(self.realName.right+10, self.photo.bottom+18);
    if ([_user.userSex isEqualToString:@"男"]) {
        self.sex.image = [UIImage imageNamed:@"boy"];
    }else if([_user.userSex isEqualToString:@"女"]){
        self.sex.image = [UIImage imageNamed:@"girl"];
    }else{
        [HDTool autoSex:self.sex];
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
    __weak __typeof(&*self)weakSelf = self;
    [HDNet POST:@"/data/user/update_info.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
        
            if ([parameters objectForKey:@"userSignature"]!=nil) {
                weakSelf.qianming.text = [parameters objectForKey:@"userSignature"];
                _user.userSignature = [parameters objectForKey:@"userSignature"];
            }else{
                weakSelf.nickname.text = [parameters objectForKey:@"userNickName"];
                _user.userNickName = [parameters objectForKey:@"userNickName"];
            }
        
            [_user saveToNSUserDefaults];
        }else{
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
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
                [weakSelf showHint:@"请拍照"];
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
            _image= [info objectForKey:@"UIImagePickerControllerEditedImage"];
            //        UIImage *image= [self scaleToSize:[info objectForKey:@"UIImagePickerControllerOriginalImage"] size:CGSizeMake(300,300)];
            [self saveImage:_image WithName:@"myPhoto.png"];
            [self updatePhoto];
        }
        
    }];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)updatePhoto{
    _progress = [[TNSexyImageUploadProgress alloc] init];
    _progress.radius = 100;
    _progress.progressBorderThickness = -10;
    _progress.trackColor = [UIColor blackColor];
    _progress.progressColor = [UIColor whiteColor];
    _progress.imageToUpload = _image;
    [_progress show];
    
    NSString *filePath = [[self documentFolderPath] stringByAppendingString:@"/myPhoto.png"];
    _photoName = [NSString stringWithFormat:@"%@%@%@",_user._id,@"/",[HDTool generateImgName]];
    NSDictionary *parameters = @{@"type": @"user"};
    [HDNet GET:@"/data/qiniu/uploadtoken.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = responseObject[@"result"];
        if (1==[result intValue]) {
            NSString *token = responseObject[@"token"];
            _uploader = [QiniuSimpleUploader uploaderWithToken:token];
            _uploader.delegate = self;
            [_uploader uploadFile:filePath key:_photoName extra:nil];
        }else{
            [_progress removeFromSuperview];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_progress removeFromSuperview];
    }];

}

#pragma qiniuDelegate

- (void)uploadProgressUpdated:(NSString *)theFilePath percent:(float)percent
{
       _progress.progress = percent*0.95;
}

- (void)uploadSucceeded:(NSString *)theFilePath ret:(NSDictionary *)ret
{
    NSDictionary *parameters = @{@"key": _photoName};
    [HDNet POST:@"/data/user/user_uphoto_qn.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *state = [responseObject objectForKey:@"state"];
                if ([state isEqualToString:@"20001"]) {
                     _progress.progress = 1.0f;
                    _user.userPhoto = [responseObject objectForKey:@"userPhoto"];
                    [_user saveToNSUserDefaults];
                }else if ([state isEqualToString:@"10001"]){
                    [_progress removeFromSuperview];
                }else{
                    [_progress removeFromSuperview];
                }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_progress removeFromSuperview];
    }];
    
    
}

- (void)uploadFailed:(NSString *)theFilePath error:(NSError *)error
{
    [_progress removeFromSuperview];
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
}


@end
