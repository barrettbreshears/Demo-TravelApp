//
//  PopOver.m
//  TravelApp
//
//  Created by Barrett Breshears on 10/26/14.
//  Copyright (c) 2014 Barrett Breshears. All rights reserved.
//

#import "PopOver.h"

@interface PopOver ()

@end

@implementation PopOver

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _buttonFormat = [[NSDateFormatter alloc] init];
    [_buttonFormat setDateFormat:@"MM-dd-yy HH:mm"];
    _filterDictionary = [[NSMutableDictionary alloc] init];
    
    _filterParam = @"destination";
    _filterDate = [NSDate date];
    _filterDateGreaterOrLess = @"After";
    _stringFilter = @"";
    
    [self setDateButtons];
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

-(IBAction)filterSegmentedChanged:(UISegmentedControl *)SControl{
    
    _filterByLabel.text = [SControl titleForSegmentAtIndex:SControl.selectedSegmentIndex];
    
    if (SControl.selectedSegmentIndex == 0) {
        _filterParam = @"destination";
        [self showTextFilters];
    }else if (SControl.selectedSegmentIndex == 1){
        _filterParam = @"startDate";
        [self showDateFilters];
    }else if (SControl.selectedSegmentIndex == 2){
        _filterParam = @"endDate";
        [self showDateFilters];
    }else{
        _filterParam = @"comment";
        [self showTextFilters];
    }
}

-(IBAction)beforeAfterSegmentedChanged:(UISegmentedControl *)SControl{
    
    _beforeAfterLabel.text = [SControl titleForSegmentAtIndex:SControl.selectedSegmentIndex];
    
    _filterDateGreaterOrLess = [SControl titleForSegmentAtIndex:SControl.selectedSegmentIndex];
}

- (void)showTextFilters{
    _filterTextField.hidden = NO;
    _afterBeforeSeg.hidden = YES;
    _beforeAfterLabel.hidden = YES;
    _filterDateBtn.hidden = YES;
}

- (void)showDateFilters{
    _filterTextField.hidden = YES;
    _afterBeforeSeg.hidden = NO;
    _beforeAfterLabel.hidden = NO;
    _filterDateBtn.hidden = NO;
}

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

- (IBAction)selectDate:(id)sender{
    [self hideDatePicker];
    _filterDate = _datePicker.date;
    [self setDateButtons];
    
}

- (IBAction)selectFilterDate:(id)sender{
    [self showDatePicker];
}

- (void)hideDatePicker{
    
    CGPoint currentCenter = self.dateView.center;
    // set the footerview to below the view area
    
    __weak PopOver *weakself = self;
    [UIView animateWithDuration:0.2f animations:^{
        self.dateView.alpha = 0;
    } completion:^(BOOL finished) {
        self.dateView.alpha = 1;
        weakself.dateView.hidden = YES;
        self.dateView.center = currentCenter;
        
    }];
}


- (void)initializeNewDates{
    _filterDate = [NSDate date];
    
    [self setDateButtons];
}

- (void)setDateButtons{
    
    [_filterDateBtn setTitle:[_buttonFormat stringFromDate:_filterDate] forState:UIControlStateNormal];
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self hideDatePicker];
}

-(IBAction)setFilter:(id)sender{
    _filterDictionary[@"filter"] = _filterParam;
    _filterDictionary[@"filterDescription"] = [_filterSeg titleForSegmentAtIndex:_filterSeg.selectedSegmentIndex];
    if ( [_filterParam isEqualToString:@"destination"] || [_filterParam isEqualToString:@"comment"]) {
        _filterDictionary[@"searchParam"] = _filterTextField.text;
       
    }else{
        _filterDictionary[@"dateIs"] = _filterDateGreaterOrLess;
        _filterDictionary[@"searchParam"] = _filterDate;
    }
     [_delegate addFilter:_filterDictionary];
    [self dismissFilter:self];
    
}
-(IBAction)dismissFilter:(id)sender{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
