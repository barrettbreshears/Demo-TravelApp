//
//  TripViewController.m
//  TravelApp
//
//  Created by Barrett Breshears on 10/26/14.
//  Copyright (c) 2014 Barrett Breshears. All rights reserved.
//

#import "TripViewController.h"

@interface TripViewController ()

@end

@implementation TripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _buttonFormat = [[NSDateFormatter alloc] init];
    [_buttonFormat setDateFormat:@"MM-dd-yy HH:mm"];
    
    // check to see if we are updating or creating a trip and set up view to reflect this
    if (_update) {
        [_saveBtn setTitle:NSLocalizedString(@"Update Trip", nil) forState:UIControlStateNormal];
        self.title = NSLocalizedString(@"Update Trip", nil);
        [self setUpdateData];
    }else{
        [_saveBtn setTitle:NSLocalizedString(@"Create Trip", nil) forState:UIControlStateNormal];
        self.title = NSLocalizedString(@"Create Trip", nil);
        [self initializeNewDates];
    }
}


/*
 * Sets the text field values if updating trip
 */
- (void)setUpdateData{
    _startDate = [_trip objectForKey:@"startDate"];
    _endDate = [_trip objectForKey:@"endDate"];
    _destination.text = [_trip objectForKey:@"destination"];
    _comment.text = [_trip objectForKey:@"comment"];
    [self setDateButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * Event handler to select the date from the date picker
 */
- (IBAction)selectDate:(id)sender{
    [self hideDatePicker];
    if ([_date isEqualToString:@"start"]) {
        _startDate = _datePicker.date;
        if([_startDate timeIntervalSinceDate:_endDate] > 0){
            int daysToAdd = 1;
            _endDate = [_startDate dateByAddingTimeInterval:60*60*24*daysToAdd];
        }
    }else{
        _endDate = _datePicker.date;
    }
    [self setDateButtons];
    
}

/*
 * Set pop up date picker for the start date
 */
- (IBAction)selectStartDate:(id)sender{
    _date = @"start";
    [self setStartDateConstraints];
    [self showDatePicker];
}

/*
 * Set pop up date picker for the end date
 */
- (IBAction)selectEndDate:(id)sender{
    _date = @"end";
    [self setEndDateConstraints];
    [self showDatePicker];
}

/*
 * Validate the trip and call either the save or update method depending 
 * if we are editing or creating a trip
 */
- (IBAction)saveUpdate:(id)sender{
    if (![self validateTrip]) {
        return;
    }
    
    if (_update) {
        [self updateTrip];
    }else{
        [self createTrip];
    }
}

/*
 * Trip validation make sure the destination has a value
 */
- (BOOL)validateTrip{
    
    if (_destination.text.length == 0) {
        [self showMyWarning:NSLocalizedString(@"You must enter a destination", nil) withTitle:NSLocalizedString(@"Error", nil)];
        return NO;
    }
    
    
    return YES;
}

/*
 * Animate the date view that displays the date picker
 */
- (void)showDatePicker{
    
    CGPoint currentCenter = self.dateView.center;
    // set the footerview to below the view area
    CGFloat newY = currentCenter.y + self.dateView.frame.size.height;
    self.dateView.center = CGPointMake(currentCenter.x, newY);
    self.dateView.hidden = NO;
    [UIView animateWithDuration:0.2f animations:^{
        self.dateView.center = currentCenter;
    } completion:^(BOOL finished) {
        
    }];
}

/*
 * Hides the date picker
 */
- (void)hideDatePicker{
    
    CGPoint currentCenter = self.dateView.center;
    // set the footerview to below the view area
    
    __weak TripViewController *weakself = self;
    [UIView animateWithDuration:0.2f animations:^{
        self.dateView.alpha = 0;
    } completion:^(BOOL finished) {
        self.dateView.alpha = 1;
        weakself.dateView.hidden = YES;
        self.dateView.center = currentCenter;
        
    }];
}

/*
 * set constraints for the date picker on the start date
 */
- (void)setStartDateConstraints{
    self.datePicker.minimumDate = [[ NSDate alloc ] initWithTimeIntervalSinceNow: (NSTimeInterval) 0 ];
}

/*
 * set constraints for the date picker on the end date
 */
- (void)setEndDateConstraints{
    int daysToAdd = 1;
    self.datePicker.minimumDate = [_startDate dateByAddingTimeInterval:60*60*24*daysToAdd];
}


/*
 * set the intial dates when creating a new trip
 */
- (void)initializeNewDates{
    _startDate = [NSDate date];
    int daysToAdd = 1;
    _endDate = [_startDate dateByAddingTimeInterval:60*60*24*daysToAdd];
    
    [self setDateButtons];
}

/*
 * set the date buttons based on the selected date
 */
- (void)setDateButtons{
    [_startDateBtn setTitle:[_buttonFormat stringFromDate:_startDate] forState:UIControlStateNormal];
    [_endDateBtn setTitle:[_buttonFormat stringFromDate:_endDate] forState:UIControlStateNormal];
}

/*
 * hide keyboard when the user taps the return key
 */
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

/*
 * hide the datepicker when the text field is being edited
 */
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self hideDatePicker];
}

/*
 * creates a enw trip
 */
-(void)createTrip{
    [self showLoadingViewWithText:NSLocalizedString(@"Saving Trip", nil)];
    PFObject *trip = [PFObject objectWithClassName:@"Trip"];
    trip[@"user"] = [PFUser currentUser];
    trip[@"destination"] = _destination.text;
    trip[@"startDate"] = _startDate;
    trip[@"endDate"] = _endDate;
    trip[@"comment"] = _comment.text;
    
    __weak TripViewController *weakself = self;
    [trip saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [weakself hideLoadingView];
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
}

/*
 * updates the trip
 */
-(void)updateTrip{
    [self showLoadingViewWithText:NSLocalizedString(@"Updating Trip", nil)];
    _trip[@"destination"] = _destination.text;
    _trip[@"startDate"] = _startDate;
    _trip[@"endDate"] = _endDate;
    _trip[@"comment"] = _comment.text;
    __weak TripViewController *weakself = self;
    [_trip saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [weakself hideLoadingView];
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
}


@end
