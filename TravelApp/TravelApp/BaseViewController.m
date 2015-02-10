//
//  BaseViewController.m
//  TravelApp
//
//  Created by Barrett Breshears on 10/23/14.
//  Copyright (c) 2014 Barrett Breshears. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:99.0/255.0f green:134.0/255.0f blue:169.0/255.0f alpha:1]];
    LoginViewController *rootController = (LoginViewController *)[self.navigationController.viewControllers objectAtIndex: 0];
    
    if ( self == rootController ) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    } else if ( [self.navigationController isNavigationBarHidden] ) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)stopEditing{
    self.editing = NO;
}


/*
 * Checks string to make sure its a valid email
 */
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


/*
 * Check if password and confirm pass match
 */
- (BOOL) checkPassword:(NSString *)password andConfirmPassword:(NSString *)confirmPassword{
    if ([password isEqualToString:confirmPassword]) {
        return YES;
    }else{
        return NO;
    }
    
}

/*
 * Validates password is at least 4 characters and doesn't contain spaces
 */
- (BOOL) validPassword:(NSString *)password{
    // check for white space its not allowed
    NSRange whiteSpaceRange = [password rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    if (whiteSpaceRange.location != NSNotFound) {
        return NO;
    }
    
    // check if password is at least 4 characters
    if (password.length <= 3) {
        return NO;
    }
    
    return YES;
}

/*
 * Shows an alertview warning
 */
- (void) showMyWarning:(NSString *)warning withTitle:(NSString *)title{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:warning
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:NSLocalizedString(@"ok", nil)
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];

}

/*
 * Displays loading overlay
 */
- (void)showLoadingView{
    _loadingBackground = [[UIView alloc] initWithFrame:self.view.frame];
    [_loadingBackground setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.65]];
    
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_loadingIndicator startAnimating];
    [_loadingIndicator setCenter:_loadingBackground.center];
    [_loadingBackground addSubview:_loadingIndicator];
    
    [self.view addSubview:_loadingBackground];
}

/*
 * Displays loading overlay with text message
 */
- (void)showLoadingViewWithText:(NSString *)loadingText{
    
    _loadingBackground = [[UIView alloc] initWithFrame:self.view.frame];
    [_loadingBackground setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.65]];
    
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_loadingIndicator startAnimating];
    [_loadingIndicator setCenter:_loadingBackground.center];
    [_loadingBackground addSubview:_loadingIndicator];
    
    _loadingString = [[UILabel alloc] init];
    [_loadingString setTextColor:[UIColor whiteColor]];
    _loadingString.text = loadingText;
    [_loadingString sizeToFit];
    
    CGFloat newY = _loadingBackground.center.x + _loadingIndicator.frame.size.height;
    [_loadingString setCenter:CGPointMake(self.view.center.x, newY)];
    [_loadingBackground addSubview:_loadingString];
    
    [self.view addSubview:_loadingBackground];
    
}

/*
 * Hides the loading mask
 */
- (void)hideLoadingView{
    
    [_loadingBackground removeFromSuperview];
    
}



@end
