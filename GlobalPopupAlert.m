//
//  GlobalPopupAlert.m
//
//  Created by Stuart Hall on 14/03/11.
//

#import "GlobalPopupAlert.h"
#import <QuartzCore/QuartzCore.h>

// Private methods
@interface GlobalPopupAlert (Private)
- (void)updateForOrientation:(BOOL)animated;
@end

@implementation GlobalPopupAlert

// Our singleton
static GlobalPopupAlert *instance = nil;

// Dimensions
static int const GLOBAL_POPUP_WIDTH = 260;
static int const GLOBAL_POPUP_HEIGHT = 70;

@synthesize roundView;
@synthesize label;

+ (UIWindow*)mainWindow {
    return [UIApplication sharedApplication].keyWindow;
}

- (void)dealloc {
    // Remove ourselves from the notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Cleanup
    self.label = nil;
    self.roundView = nil;
    
    [super dealloc];
}

- (id) init {
    if (self == [super init]) {
        // The black background
        roundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GLOBAL_POPUP_WIDTH, GLOBAL_POPUP_HEIGHT)];
        roundView.autoresizingMask = UIViewAutoresizingNone;
        roundView.backgroundColor = [UIColor blackColor];
        roundView.layer.masksToBounds = YES;
        roundView.alpha = 0;
        roundView.hidden = YES;
        [[self.roundView layer] setCornerRadius:10.0];
        
        // Label
        label = [[UILabel alloc] initWithFrame:roundView.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        [roundView addSubview:label];
        
        // Set for the current orientation
        [self updateForOrientation:NO];
        
        // Alert the the orientation changes
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOrientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

+ (id)allocWithZone:(NSZone*)zone {
    @synchronized(self) {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
        }
        return instance;
    }
    return nil;
}

/**
 * The global access, all access should be via
 * this function
**/
+ (GlobalPopupAlert*)sharedInstance {
    @synchronized (self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

/**
 * Displays the alert with the specific string
**/
+ (void)show:(NSString*)text {
    GlobalPopupAlert* instance = [GlobalPopupAlert sharedInstance];
    [instance.roundView removeFromSuperview];
    
	instance.roundView.center = [self mainWindow].center;
	instance.label.text = text;
	instance.roundView.alpha = 1;
	instance.roundView.hidden = NO;
    
    [[self mainWindow] addSubview:instance.roundView];
}

/**
 * Displays the alert with the specific string and fades out
 **/
+ (void)show:(NSString*)text andFadeOutAfter:(double)secs {
    [GlobalPopupAlert show:text];
    [GlobalPopupAlert fadeOutAfter:secs];
}

/**
 * Hides the popup immediately
 **/
+ (void)hide {
	[GlobalPopupAlert sharedInstance].roundView.hidden = YES;
}

/**
 * Fades the popup out
 **/
+ (void)fadeOutAfter:(double)secs {
    GlobalPopupAlert* instance = [GlobalPopupAlert sharedInstance];
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:secs];
    [UIView setAnimationDuration:1];
	instance.roundView.alpha = 0;
	[UIView commitAnimations];
}

/**
 * Sets the background color
 **/
+ (void)setBackgroundColor:(UIColor*)color {
    [GlobalPopupAlert sharedInstance].roundView.backgroundColor = color;
}

/**
 * Sets the label color
 **/
+ (void)setLabelColor:(UIColor*)color {
    [GlobalPopupAlert sharedInstance].label.textColor = color;
}

/**
 * Determines the transformation for the current orientation
 **/
- (CGAffineTransform)transformForOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

/**
 * Updates the orientation
**/
- (void)updateForOrientation:(BOOL)animated {
    // Transform the alert to the correct orientation
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
    }
    
    [GlobalPopupAlert sharedInstance].roundView.transform = [self transformForOrientation];
    
    if (animated) {
        [UIView commitAnimations];
    }
}

/**
 * UIDeviceOrientationDidChangeNotification callback
**/
- (void)deviceOrientationDidChange:(void*)object {
    [self updateForOrientation:YES];
}

@end

