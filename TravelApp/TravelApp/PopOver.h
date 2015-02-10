//
//  PopOver.h
//  TravelApp
//
//  Created by Barrett Breshears on 10/26/14.
//  Copyright (c) 2014 Barrett Breshears. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterPopOverDelegate <NSObject>

- (void)addFilter:(NSDictionary *)filterDictionary;

@end

@interface PopOver : UIViewController

@property (nonatomic, weak) id delegate;

@property (nonatomic, strong) IBOutlet UILabel *filterByLabel;
@property (nonatomic, strong) IBOutlet UISegmentedControl *filterSeg;
@property (nonatomic, strong) IBOutlet UITextField *filterTextField;
@property (nonatomic, strong) IBOutlet UISegmentedControl *afterBeforeSeg;
@property (nonatomic, strong) IBOutlet UILabel *beforeAfterLabel;
@property (nonatomic, strong) IBOutlet UIButton *filterDateBtn;
@property (nonatomic, strong) IBOutlet UIView *dateView;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, strong) NSString *filterParam;
@property (nonatomic, strong) NSDate *filterDate;
@property (nonatomic, strong) NSString *filterDateGreaterOrLess;
@property (nonatomic, strong) NSString *stringFilter;
@property (nonatomic, strong) NSDateFormatter *buttonFormat;
@property (nonatomic, strong) NSMutableDictionary *filterDictionary;

-(IBAction)filterSegmentedChanged:(UISegmentedControl *)SControl;
-(IBAction)beforeAfterSegmentedChanged:(UISegmentedControl *)SControl;
-(IBAction)selectFilterDate:(id)sender;
-(IBAction)selectDate:(id)sender;
-(IBAction)setFilter:(id)sender;
-(IBAction)dismissFilter:(id)sender;

@end
