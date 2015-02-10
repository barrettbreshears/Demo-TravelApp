//
//  LoginViewController.h
//  TravelApp
//
//  Created by Barrett Breshears on 10/24/14.
//  Copyright (c) 2014 Barrett Breshears. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UITextField *email;
@property (nonatomic, strong) IBOutlet UITextField *password;

- (IBAction)login:(id)sender;

@end
