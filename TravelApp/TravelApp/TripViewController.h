//
//  TripViewController.h
//  TravelApp
//
//  Created by Barrett Breshears on 10/26/14.
//  Copyright (c) 2014 Barrett Breshears. All rights reserved.
//

#import "BaseViewController.h"

@interface TripViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UITextField *destination;
@property (nonatomic, strong) IBOutlet UITextField *comment;
@property (nonatomic, strong) IBOutlet UIButton *startDateBtn;
@property (nonatomic, strong) IBOutlet UIButton *endDateBtn;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet UIView *dateView;
@property (nonatomic, strong) IBOutlet UIButton *saveBtn;

@property (nonatomic, strong) NSString *date;
@property (nonatomic, assign) BOOL update;
@property (nonatomic, strong) PFObject *trip;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSDateFormatter *buttonFormat;



- (IBAction)saveUpdate:(id)sender;
- (IBAction)selectStartDate:(id)sender;
- (IBAction)selectEndDate:(id)sender;
- (IBAction)selectDate:(id)sender;

@end
