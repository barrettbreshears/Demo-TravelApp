//
//  RootNavViewController.m
//  TravelApp
//
//  Created by Barrett Breshears on 10/25/14.
//  Copyright (c) 2014 Barrett Breshears. All rights reserved.
//

#import "RootNavViewController.h"
#import <Parse/Parse.h>
#import "MyTripsViewController.h"
#import "LoginViewController.h"

@interface RootNavViewController ()

@end

@implementation RootNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    // check to see if the user is logged in and if they are show the mytripsviewcontroller
    if ([PFUser currentUser]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MyTripsViewController *controller = (MyTripsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MyTripsViewController"];
        [self pushViewController:controller animated:NO];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
