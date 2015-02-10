//
//  BaseViewController.h
//  TravelApp
//
//  Created by Barrett Breshears on 10/23/14.
//  Copyright (c) 2014 Barrett Breshears. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SWRevealViewController.h"

@interface BaseViewController : UIViewController <SWRevealViewControllerDelegate>

@property (nonatomic, strong) UIView *loadingBackground;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) UILabel *loadingString;

-(BOOL) NSStringIsValidEmail:(NSString *)checkString;
- (BOOL) checkPassword:(NSString *)password andConfirmPassword:(NSString *)confirmPassword;
- (BOOL) validPassword:(NSString *)password;
- (void) showMyWarning:(NSString *)warning withTitle:(NSString *)title;
- (void)showLoadingView;
- (void)showLoadingViewWithText:(NSString *)loadingText;
- (void)hideLoadingView;

@end
