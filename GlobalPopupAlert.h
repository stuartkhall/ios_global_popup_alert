//
//  GlobalPopupAlert.h
//
//  Created by Stuart Hall on 14/03/11.
//

#import <Foundation/Foundation.h>


@interface GlobalPopupAlert : NSObject {
@protected
    UIView* roundView;
    UILabel* label;
    double alpha;
}

@property (nonatomic, retain) UIView* roundView;
@property (nonatomic, retain) UILabel* label;
@property double alpha;

/**
 * Displays the alert with the specific string
 **/
+ (void)show:(NSString*)text;

/**
 * Displays the alert with the specific string and fades out
 **/
+ (void)show:(NSString*)text andFadeOutAfter:(double)secs;

/**
 * Displays the alert with the specific string and fades out
 **/
+ (void)show:(NSString*)text andFadeOutAfter:(double)secs inView:(UIView*)view;

/**
 * Hides the popup immediately
 **/
+ (void)hide;

/**
 * Fades the popup out
 **/
+ (void)fadeOutAfter:(double)secs;

/**
 * Sets the background color
 **/
+ (void)setBackgroundColor:(UIColor*)color;

/**
 * Sets the label color
 **/
+ (void)setLabelColor:(UIColor*)color;

/**
 * Sets the height
**/
+ (void)setHeight:(double)h;

/**
 * Sets the alpha
 **/
+ (void)setAlpha:(double)a;

@end
