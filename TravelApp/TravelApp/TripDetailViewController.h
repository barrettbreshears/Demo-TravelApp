//
//  TripDetailViewController.h
//  TravelApp
//
//  Created by Barrett Breshears on 10/27/14.
//  Copyright (c) 2014 Barrett Breshears. All rights reserved.
//

#import "BaseViewController.h"

@interface TripDetailViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UILabel *destination;
@property (nonatomic, strong) IBOutlet UILabel *startDate;
@property (nonatomic, strong) IBOutlet UILabel *endDate;
@property (nonatomic, strong) IBOutlet UITextView *comment;
@property (nonatomic, strong) IBOutlet UILabel *daysLeft;

@property (nonatomic, strong) NSDateFormatter *format;
@property (nonatomic, strong) PFObject *trip;

@end
