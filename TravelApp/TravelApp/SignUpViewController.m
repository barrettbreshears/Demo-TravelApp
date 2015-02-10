//
//  SignUpViewController.m
//  TravelApp
//
//  Created by Barrett Breshears on 10/24/14.
//  Copyright (c) 2014 Barrett Breshears. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * run validation and add the user to parse
 */
-(IBAction)join:(id)sender{
    
    // validate email
    if (![self NSStringIsValidEmail:_email.text]) {
        [self showMyWarning:NSLocalizedString(@"Must be a valid email", nil) withTitle:NSLocalizedString(@"Unable to create account", nil)];
        return;
    }
    
    // validate password
    if (![self validPassword:_password.text]) {
        [self showMyWarning:NSLocalizedString(@"Password can only contain alpha numeric characters with no spaces and must contain least 4 characters long.", nil) withTitle:NSLocalizedString(@"Unable to create account", nil)];
        return;
    }
    
    // check if password and confirm password match
    if (![self checkPassword:_password.text andConfirmPassword:_confrimPassword.text]) {
        [self showMyWarning:NSLocalizedString(@"Password and Confirm Password must match", nil) withTitle:NSLocalizedString(@"Unable to create account", nil)];
        return;
    }
    
    // show loading screen
    [self showLoadingViewWithText:NSLocalizedString(@"Creating Account", nil)];
    
    PFUser *user = [PFUser user];
    user.username = _email.text;
    user.password = _password.text;
    user.email = _email.text;
    
    __weak SignUpViewController *weakself = self;
    // create user
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [weakself hideLoadingView];
        if (!error) {
            // Hooray! Let them use the app now, and go to my trips
            [weakself performSegueWithIdentifier:@"goToMyTrips" sender:self];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            [weakself showMyWarning:errorString withTitle:NSLocalizedString(@"Unable to create account", nil)];
            // Show the errorString somewhere and let the user try again.
        }
    }];
    
}



@end
