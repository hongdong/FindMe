//
//  AlbumViewController.m
//  FindMe
//
//  Created by mac on 14-7-8.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "AlbumViewController.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "User.h"
#import "AMSmoothAlertView.h"
#import "BlocksKit+UIKit.h"
#import "UIView+Common.h"
#import "TNSexyImageUploadProgress.h"

@interface AlbumViewController (){
    User *_user;
    LXActionSheet *_actionSheet;
    UIImagePickerController *_imagePicker;
    AMSmoothAlertView *_alert;
    TNSexyImageUploadProgress *_progress;
    UIImage *_image;
    QiniuSimpleUploader *_uploader;
    NSString *_photoName;
}

@end

@implementation AlbumViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageUploadCompleted:) name:IMAGE_UPLOAD_COMPLETED object:_progress];
    
    [self showPhoto];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([HDTool isFirstLoad2]) {
        [self showHint:@"长按可以删除照片"];
    }
}

-(void)showPhoto{
    int BtnW = 100;
    int BtnWS = 6;
    int BtnX = 4;
    
    int BtnH = 100;
    int BtnHS = 6;
    int BtnY = 5;
    
    int i = 0;
    int count = [_user.userAlbum count];
    for (i = 0; i < count; i++ ) {
        UIImageView * imageview = [[UIImageView alloc] init];
        imageview.frame = CGRectMake( (BtnW+BtnWS) * (i%3) + BtnX , (BtnH+BtnHS) *(i/3) + BtnY, BtnW, BtnH );
        imageview.tag = 10000 + i;
        imageview.userInteractionEnabled = YES;
        // 内容模式
        imageview.clipsToBounds = YES;
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        
        [imageview sd_setImageWithURL:[HDTool getSImage:[_user.userAlbum objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"defaultImage"] options:SDWebImageRetryFailed];
        [imageview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)]];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deletePhoto:)];
        longPress.minimumPressDuration = 0.6; //定义按的时间
        [imageview addGestureRecognizer:longPress];
        
        [self.view addSubview: imageview];
    }
    
    if (count<9) {
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake((BtnW+BtnWS) * (count%3) + BtnX , (BtnH+BtnHS) *(count/3) + BtnY, BtnW, BtnH)];
        [addButton setContentMode:UIViewContentModeLeft];
        [addButton setImage:[UIImage imageNamed:@"addimage"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addButton];
    }
}


-(void)deletePhoto:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        __weak __typeof(&*self)weakSelf = self;

        _alert = [[AMSmoothAlertView alloc]initDropAlertWithTitle:@"提醒" andText:@"照片是有多么惨不忍睹，你狠心删除吗？" andCancelButton:YES forAlertType:AlertInfo andColor:HDRED];
        [_alert.defaultButton setTitle:@"确认" forState:UIControlStateNormal];
        [_alert.defaultButton bk_addEventHandler:^(id sender) {
            [weakSelf deleteRequest:gestureRecognizer.view.tag];
        } forControlEvents:UIControlEventTouchUpInside];
        [_alert.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_alert setTitleFont:[UIFont fontWithName:@"Verdana" size:25.0f]];
        _alert.cornerRadius = 3.0f;
        //        [self.view addSubview:alert];
        [_alert show];
    }
}
-(void)deleteRequest:(NSInteger)tag{
    [HDTool showHUD:@"删除中..."];
    
    NSString *del = _user.userAlbum[tag-10000];
    __weak __typeof(&*self)weakSelf = self;
    NSDictionary *parameters = @{@"photoUrl": del};
    [HDNet GET:@"/data/user/del_album_uphoto_qn.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            [HDTool dismissHUD];
            [_user.userAlbum removeObjectAtIndex:tag-10000];
            [_user saveToNSUserDefaults];
            [weakSelf.view cleanSubViews];
            [weakSelf showPhoto];
            
        }else{
            [HDTool errorHUD];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HDTool errorHUD];
    }];

}

- (void)addButtonPressed:(id)sender {
    _actionSheet = [[LXActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"]];
    [_actionSheet showInView:self.view];
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
            [self saveImage:_image WithName:@"albumPhoto.png"];
            [self updatePhoto];
        }
    }];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)updatePhoto{
    NSString *filePathStr = [[self documentFolderPath] stringByAppendingString:@"/albumPhoto.png"];
    
    _progress = [[TNSexyImageUploadProgress alloc] init];
    _progress.radius = 100;
    _progress.progressBorderThickness = -10;
    _progress.trackColor = [UIColor blackColor];
    _progress.progressColor = [UIColor whiteColor];
    _progress.imageToUpload = _image;
    [_progress show];
    
    _photoName = [NSString stringWithFormat:@"%@%@%@",_user._id,@"/",[HDTool generateImgName]];
    NSDictionary *parameters = @{@"type": @"user"};
    [HDNet GET:@"/data/qiniu/uploadtoken.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = responseObject[@"result"];
        if (1==[result intValue]) {
            NSString *token = responseObject[@"token"];
            _uploader = [QiniuSimpleUploader uploaderWithToken:token];
            _uploader.delegate = self;
            [_uploader uploadFile:filePathStr key:_photoName extra:nil];
        }else{
           [_progress removeFromSuperview];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MJLog(@"错误");
        [_progress removeFromSuperview];
    }];

}

- (void)imageUploadCompleted:(NSNotification *)notification {
    
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{//把图片写成filePath
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

-(void)photoClick:(UITapGestureRecognizer *)imageTap
{    
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity: [_user.userAlbum count]];
    for (int i = 0; i < [_user.userAlbum count]; i++) {
        // 替换为大图
        
        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [_user.userAlbum objectAtIndex:i]];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [HDTool getLImage:getImageStrUrl];
        UIImageView * imageView = (UIImageView *)[self.view viewWithTag:(10000+i)];
        photo.srcImageView = imageView;
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = (imageTap.view.tag - 10000); // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma qiniuDelegate

- (void)uploadProgressUpdated:(NSString *)theFilePath percent:(float)percent
{
    _progress.progress = percent*0.95;
}

- (void)uploadSucceeded:(NSString *)theFilePath ret:(NSDictionary *)ret
{
    __weak __typeof(&*self)weakSelf = self;
    NSDictionary *parameters = @{@"key": _photoName};
    [HDNet POST:@"/data/user/add_album_uphoto_qn.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSString *state = [responseObject objectForKey:@"state"];
                            if ([state isEqualToString:@"20001"]) {
                                NSArray *userAlbum = [responseObject objectForKey:@"userAlbum"];
                                [_user.userAlbum addObjectsFromArray:userAlbum];
                                [_user saveToNSUserDefaults];
                                _progress.progress = 1.0f;
                               [weakSelf showPhoto];
                            }else if ([state isEqualToString:@"10001"]){
                                [_progress removeFromSuperview];
                                [weakSelf showHint:@"超时"];
                            }else{
                                [_progress removeFromSuperview];
                                [weakSelf showHint:@"超时"];
                            }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_progress removeFromSuperview];
        [weakSelf showHint:@"超时"];
    }];

}

- (void)uploadFailed:(NSString *)theFilePath error:(NSError *)error
{
    [_progress removeFromSuperview];
    [self showHint:@"超时"];
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMAGE_UPLOAD_COMPLETED object:_progress];
}


@end
