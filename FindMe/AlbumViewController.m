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
#import "AFNetworking.h"
@interface AlbumViewController (){
    User *_user;
    LXActionSheet *_actionSheet;
    UIImagePickerController *_imagePicker;
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
    
    int BtnW = 100;
    int BtnWS = 6;
    int BtnX = 4;
    
    int BtnH = 100;
    int BtnHS = 0;
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
        
        [imageview setImageWithURL:[NSURL URLWithString: [_user.userAlbum objectAtIndex:i]] placeholderImage: [UIImage imageNamed:@"defaultImage"] ];
        [imageview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)] ];
        [self.view addSubview: imageview];
    }

    if (count<9) {
        self.addButton.frame = CGRectMake((BtnW+BtnWS) * (count%3) + BtnX , (BtnH+BtnHS) *(count/3) + BtnY, BtnW, BtnH );
        self.addButton.enabled = YES;
        self.addButton.hidden = NO;
    }
}



- (IBAction)addButtonPressed:(id)sender {
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
            [self saveImage:image WithName:@"albumPhoto.png"];
            [self updatePhoto];
        }
        
        
        
    }];
    
    
}

-(void)updatePhoto{
    [self showHudInView:self.view.window hint:@"上传中..."];
    NSString *url = [NSString stringWithFormat:@"%@/data/user/add_album_uphoto.do",Host];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak __typeof(&*self)weakSelf = self;
    NSURL *filePath = [NSURL fileURLWithPath:[[self documentFolderPath] stringByAppendingString:@"/albumPhoto.png"]];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePath name:@"photo" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            [weakSelf showResultWithType:ResultSuccess];
            NSArray *userAlbum = [responseObject objectForKey:@"userAlbum"];
            [_user.userAlbum addObjectsFromArray:userAlbum];
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
    NSLog(@"imageTag==%d", imageTap.view.tag);
    
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity: [_user.userAlbum count]];
    for (int i = 0; i < [_user.userAlbum count]; i++) {
        // 替换为大图
        
        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [_user.userAlbum objectAtIndex:i]];
        NSMutableString *temp = [[NSMutableString alloc] initWithString:getImageStrUrl];
        [temp insertString:@"l" atIndex:[temp rangeOfString:@".png"].location];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:temp]; // 图片路径
        
        UIImageView * imageView = (UIImageView *)[self.view viewWithTag: imageTap.view.tag];
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



@end
