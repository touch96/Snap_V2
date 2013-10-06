//
//  CameraViewController.h
//  SnapChat_V2
//
//  Created by A12325 on 2013/10/06.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//@property BOOL newMedia;
//@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)useCamera:(id)sender;
//- (IBAction)useCameraRoll:(id)sender;

@end
