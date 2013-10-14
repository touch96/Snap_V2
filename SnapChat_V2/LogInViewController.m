//
//  LogInViewController.m
//  SnapChat
//
//  Created by KimByungyoon on 2013/09/08.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

//@property (nonatomic) CameraViewController *cameraViewController;

@end

@implementation LogInViewController

@synthesize account;
@synthesize password;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doButtonDown:(id)sender {
    NSLog(@"account:%@", account.text);
    NSLog(@"password:%@", password.text);
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.allowsEditing = NO;
    ipc.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera]) {
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    
    [self.navigationController presentViewController:ipc animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    // 사진,앨범선택창 닫기
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(image,
                                       self,
                                       @selector(image:finishedSaving:contextInfo:),
                                       nil);
        
        // 서버설정
        NSString *urlString = @"http://211.239.124.234:13405/test";
        NSString *boundary = @"SpecificString";
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
        [request setHTTPMethod:@"POST"];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        NSMutableData *body = [NSMutableData data];
        
        // 이미지크기 조절
        UIImage *image_ = image;
        float resizeWidth = 150;
        float resizeHeight = image_.size.width/(image_.size.height/150);
        
        CGSize newSize=CGSizeMake(resizeWidth, resizeHeight);
        UIGraphicsBeginImageContext(newSize);
        [image_ drawInRect:CGRectMake(0,0,resizeWidth,resizeHeight)];
        
        UIImage* scaledImage2 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        // 파일:uploadedfile, 파일명:filename
        
        // 해상도 조절, 파일이름을 만들기 : 서버에 보내기위한 준비작업
        NSData *imageData2 =UIImageJPEGRepresentation(scaledImage2, 0.7);
        NSString *tFileName=@"img";
        NSString *imageFileName= [NSString stringWithFormat:@"%@.jpg",tFileName];
        
        // http해더
        [body appendData:[[NSString stringWithFormat:
                           @"\r\n--%@\r\n",
                           boundary]
                          dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:
                           @"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"%@\"\r\n",
                           imageFileName]
                          dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n"
                          dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData2]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",
                           boundary]
                          dataUsingEncoding:NSUTF8StringEncoding]];
        
        // 전송
        [request setHTTPBody:body];
        
        // 보낸결과
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"aaaaaaaaaaaa:%@", returnString);
        
    } else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *mediaURL=[info objectForKey:UIImagePickerControllerMediaURL];
        NSString *mediaPath=[mediaURL path];
        if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(mediaPath)) {
            //비디오를 사진 앨범에 저장한다.
            UISaveVideoAtPathToSavedPhotosAlbum(mediaPath,
                                                self,
                                                nil,
                                                nil);
        } else {
            NSLog(@"사진 앨범에 저장할수 없는 경우의 처리!");
        }
    }
}

-(void)image:(UIImage *)image finishedSaving:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"finishedSaving");
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"imagePickerControllerDidCancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
