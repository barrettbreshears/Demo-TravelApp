//
//  TripDetailViewController.m
//  TravelApp
//
//  Created by Barrett Breshears on 10/27/14.
//  Copyright (c) 2014 Barrett Breshears. All rights reserved.
//

#import "TripDetailViewController.h"

@interface TripDetailViewController ()

@end

@implementation TripDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set up view and title
    self.title = NSLocalizedString(@"Trip Details", nil);
    
    // set the date format for the start and end date labels
    _format = [[NSDateFormatter alloc] init];
    [_format setDateFormat:@"MM-dd-yy HH:mm"];
    
    // set the view labels
    _destination.text = [_trip objectForKey:@"destination"];
    _startDate.text = [_format stringFromDate:[_trip objectForKey:@"startDate"]];
    _endDate.text = [_format stringFromDate:[_trip objectForKey:@"endDate"]];
    _comment.text = [_trip objectForKey:@"comment"];
    
    // if the start date is in the future show the remaining days until the trip
    if([self daysBetweenDate:[NSDate date] andDate:[_trip objectForKey:@"startDate"]] > 0){
        _daysLeft.text = [NSString stringWithFormat:@"%ld days away", (long)[self daysBetweenDate:[NSDate date] andDate:[_trip objectForKey:@"startDate"]]];
    }else{
        _daysLeft.text = @"";
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * Method to return the number of days between 2 dates
 * @params
 * NSDate fromDateTime the start date to compare
 * NSDate toDateTime the end date to compare
 * @returns NSInteger number of days
 */
-(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

@end
