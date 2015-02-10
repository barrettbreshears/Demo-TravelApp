//
//  MenuTableViewController.h
//  TravelApp
//
//  Created by Barrett Breshears on 10/25/14.
//  Copyright (c) 2014 Barrett Breshears. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewController : UITableViewController <UIPrintInteractionControllerDelegate>

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) UIWebView *nextMonthView;
@property (nonatomic, strong) NSMutableArray *nextMonthTrips;

@end
