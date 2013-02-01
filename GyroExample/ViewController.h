//
//  ViewController.h
//  GyroExample
//
//  Created by Alexey Voitenko on 23.01.13.
//  Copyright (c) 2013 Alexey Voitenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UIButton* runningButton;
@property (nonatomic, strong) IBOutlet UIImageView* imageView;

-(IBAction)changeColorAction:(id)sender;

@end
