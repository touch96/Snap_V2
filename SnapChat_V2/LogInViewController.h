//
//  LogInViewController.h
//  SnapChat
//
//  Created by KimByungyoon on 2013/09/08.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CameraViewController.h"
//#import <CameraViewController.h>

@class CameraViewController;

@interface LogInViewController : UIViewController {
    CameraViewController *cameraViewController;
}

@property (strong, nonatomic) IBOutlet UITextField *account;
@property (strong, nonatomic) IBOutlet UITextField *password;

//@property (nonatomic,retain) CameraViewController *cameraViewController;

@end

