//
//  NewPostViewController.m
//  FindMe
//
//  Created by mac on 14-7-1.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "NewPostViewController.h"
#import "NSString+HD.h"

@interface NewPostViewController (){
        LXActionSheet *_actionSheet;
        UIImagePickerController *_imagePicker;
        BOOL _existImage;
        QiniuSimpleUploader *_uploader;
}

@end

@implementation NewPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)sendPressed:(id)sender {
    [self.view endEditing:YES];
    [HDTool showHDJGHUD:@"发送中..."];

    if (_existImage) {
        NSString *filePath = [[self documentFolderPath] stringByAppendingString:@"/postImage.png"];
        NSDictionary *parameters = @{@"type": @"post"};
        [HDNet GET:@"/data/qiniu/uploadtoken.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *result = responseObject[@"result"];
            if (1==[result intValue]) {
                NSString *token = responseObject[@"token"];
                _uploader = [QiniuSimpleUploader uploaderWithToken:token];
                _uploader.delegate = self;
                [_uploader uploadFile:filePath key:[HDTool generateImgName] extra:nil];
            }else{
                [HDTool errorHDJGHUD];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [HDTool errorHDJGHUD];
        }];

    }else{
        [self sendData:nil];
    }

}

#pragma qiniuDelegate

- (void)uploadProgressUpdated:(NSString *)theFilePath percent:(float)percent
{
    
}

- (void)uploadSucceeded:(NSString *)theFilePath ret:(NSDictionary *)ret
{
    [self sendData:ret[@"key"]];
}

- (void)sendData:(NSString *)key{
    NSDictionary *parameters;
    if (key) {
        parameters = @{@"postContent": self.content.text,
                                     @"postOfficial": @"2",
                                     @"key":key};
    }else{
        parameters = @{@"postContent": self.content.text,
                                     @"postOfficial": @"2"};
    }
    __weak __typeof(&*self)weakSelf = self;
    [HDNet POST:@"/data/post/release_post_qn.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            [HDTool dismissHDJGHUD];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PostListwillRefresh" object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [HDTool errorHDJGHUD];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HDTool errorHDJGHUD];
    }];
}

- (void)uploadFailed:(NSString *)theFilePath error:(NSError *)error
{
    [HDTool errorHDJGHUD];
}

- (IBAction)addimagePressed:(id)sender {
    [self.view endEditing:YES];
    _actionSheet = [[LXActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择",@"移除照片"]];
    [_actionSheet showInView:self.view];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sendBt.enabled = NO;
    _existImage = NO;
    [self.content setPlaceHolderTextColor:[UIColor grayColor]];
    [self.content setPlaceHolder:@"说点什么吧...."];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.content becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.content resignFirstResponder];
}

#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger *)buttonIndex
{
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
                [HDTool showHDJGHUDHint:@"请拍照"];
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
                [HDTool showHDJGHUDHint:@"请选择照片"];
            }];
            break;}
        case 2:
        {
            if (_existImage) {
                [self.addimage setImage:[UIImage imageNamed:@"addimage"] forState:UIControlStateNormal];
                _existImage = NO;
            }else{
                [HDTool showHDJGHUDHint:@"没有照片"];
            }
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
            [self saveImage:image WithName:@"postImage.png"];
        }
        
        
        
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    [self.addimage setImage:tempImage forState:UIControlStateNormal];
    _existImage = YES;
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
#pragma textView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self sendPressed:nil];
        return NO;
    }
    int  remainTextNum = 140;
    //计算剩下多少文字可以输入
    if(range.location>=140)
    {
        remainTextNum = 0;
        return NO;
    }else
    {
        NSString  * nsTextContent = textView.text;
        int existTextNum=[nsTextContent length];
        remainTextNum = 140-existTextNum;
        self.remainTextNum.text = [NSString stringWithFormat:@"%d",remainTextNum];
        return YES;
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([textView.text isOK]) {
        self.sendBt.enabled = YES;
    }else{
        self.sendBt.enabled = NO;
    }
}

@end
