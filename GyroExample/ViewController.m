//
//  ViewController.m
//  GyroExample
//
//  Created by Alexey Voitenko on 23.01.13.
//  Copyright (c) 2013 Alexey Voitenko. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
	float redFloat;
	float greenFloat;
	float blueFloat;
}

@property (nonatomic) CGPoint lastPoint;
@property (nonatomic) BOOL canDraw;

@end

@implementation ViewController

@synthesize runningButton, imageView, lastPoint, canDraw;

////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - View controller's life circle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSString* objectKey = @"firstLaunch";
	if (![[NSUserDefaults standardUserDefaults] objectForKey:objectKey])
	{
		[[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:objectKey];
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"You can tap screen for pause/resume drawing"
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
	}
	
	canDraw = YES;
	redFloat = 1.0;
	greenFloat = 0.0;
	blueFloat = 0.0;
	
	CMMotionManager* manager = [[CMMotionManager alloc] init];
	manager.gyroUpdateInterval = .0001;
	
	NSOperationQueue* queue = [NSOperationQueue mainQueue];
	
	UIGraphicsBeginImageContext(imageView.frame.size);
	[imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 4.0);
	
	[manager startGyroUpdatesToQueue:queue withHandler:^(CMGyroData *gyroData, NSError *error) {
		//		NSLog(@"x = %f \n y = %f \n z = %f", gyroData.rotationRate.x, gyroData.rotationRate.y, gyroData.rotationRate.z);
		float frstVal = gyroData.rotationRate.x;
		float scndVal = gyroData.rotationRate.y;
		//		float thrdVal = gyroData.rotationRate.z; // changing in case rotating device around axis, perpendecular device's screen surface
		
		CGPoint center = runningButton.center;
		center = CGPointMake(center.x + scndVal*30, center.y + frstVal*30);
		if (center.x > 0 && center.x < imageView.frame.size.width && center.y > 0 && center.y < imageView.frame.size.height)
			runningButton.center = center;
		
		CGPoint currentPoint = runningButton.center;
		lastPoint = currentPoint;
		
		if (!canDraw)
			return;
		
		CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), redFloat, greenFloat, blueFloat, 1.0);
		CGContextBeginPath(UIGraphicsGetCurrentContext());
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		imageView.image = UIGraphicsGetImageFromCurrentImageContext();
		//		UIGraphicsEndImageContext(); // drawing is potentually endless, so we don't need to end context
	}];
}

#pragma mark -

////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Interface orientation methods

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(BOOL)shouldAutorotate
{
	return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -

////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Actions

-(void)changeColorAction:(id)sender
{
	canDraw = NO;
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose color"
															 delegate:self
													cancelButtonTitle:nil
											   destructiveButtonTitle:@"Cancel"
													otherButtonTitles:@"Red", @"Green", @"Blue", nil];
	[actionSheet showInView:self.view];
}

#pragma mark -

////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 1: // red
		{
			redFloat = 1.0;
			greenFloat = 0.0;
			blueFloat = 0.0;
		}
			break;
			
		case 2: // green
		{
			redFloat = 0.0;
			greenFloat = 1.0;
			blueFloat = 0.0;
		}
			break;
			
		case 3: // blue
		{
			redFloat = 0.0;
			greenFloat = 0.0;
			blueFloat = 1.0;
		}
			break;
			
		default:
			break;
	}
}

#pragma mark -

////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Other

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	canDraw = !canDraw;
}

#pragma mark -

////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
