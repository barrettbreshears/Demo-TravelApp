//
//  LoginViewController.m
//  TravelApp
//
//  Created by Barrett Breshears on 10/24/14.
//  Copyright (c) 2014 Barrett Breshears. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
   [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * hide the keyboard when the user clicks the return button
 */
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

/*
 * log the user in
 */
-(IBAction)login:(id)sender{
    
    [self showLoadingViewWithText:NSLocalizedString(@"Logging In", nil)];
    
    __weak LoginViewController *weakself = self;
    // login with parse
    [PFUser logInWithUsernameInBackground:_email.text password:_password.text block:^(PFUser *user, NSError *error) {
        [weakself hideLoadingView];
        if (!error) {
            // go to my trips if successful
            [weakself performSegueWithIdentifier:@"goToMyTrips" sender:self];
        }else{
            // show error
            NSString *errorString = [error userInfo][@"error"];
            [weakself showMyWarning:errorString withTitle:NSLocalizedString(@"Error", nil)];
        }
        
        
    }];
}


@end
