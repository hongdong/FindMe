//
//  NewPostViewController.m
//  FindMe
//
//  Created by mac on 14-7-1.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "NewPostViewController.h"
#import <AFNetworking.h>
@interface NewPostViewController (){
        LXActionSheet *_actionSheet;
        UIImagePickerController *_imagePicker;
        BOOL _existImage;
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
    [self showHudInView:self.view.window hint:@"发送中..."];
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/post/release_post.do",Host];
    NSDictionary *parameters = @{@"postContent": self.content.text,
                                 @"postOfficial": @"2"
                                 };

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak __typeof(&*self)weakSelf = self;
    if (_existImage) {
        NSURL *filePath = [NSURL fileURLWithPath:[[self documentFolderPath] stringByAppendingString:@"/postImage.png"]];
        [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileURL:filePath name:@"photo" error:nil];
        }success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *state = [responseObject objectForKey:@"state"];
            if ([state isEqualToString:@"20001"]) {
                [weakSelf showResultWithType:ResultSuccess];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PostListwillRefresh" object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [weakSelf showResultWithType:ResultError];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [weakSelf showResultWithType:ResultError];
        }];
    }else{
        [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *state = [responseObject objectForKey:@"state"];
            if ([state isEqualToString:@"20001"]) {
                [weakSelf showResultWithType:ResultSuccess];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PostListwillRefresh" object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [weakSelf showResultWithType:ResultError];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [weakSelf showResultWithType:ResultError];
        }];
    }

}
- (IBAction)addimagePressed:(id)sender {
    [self.view endEditing:YES];
    _actionSheet = [[LXActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择",@"移除照片"]];
    [_actionSheet showInView:self.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
        case 2:
        {
            if (_existImage) {
                [self.addimage setImage:[UIImage imageNamed:@"addimage"] forState:UIControlStateNormal];
                _existImage = NO;
            }else{
                [self showHint:@"没有照片"];
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
    // Dispose of any resources that can be recreated.
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
    }
    else
    {
        NSString  * nsTextContent = textView.text;
        int existTextNum=[nsTextContent length];
        remainTextNum = 140-existTextNum;
        self.remainTextNum.text = [NSString stringWithFormat:@"%d",remainTextNum];
        return YES;
    }
}

@end
