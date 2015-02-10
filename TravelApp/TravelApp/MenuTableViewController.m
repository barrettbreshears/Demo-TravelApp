//
//  MenuTableViewController.m
//  TravelApp
//
//  Created by Barrett Breshears on 10/25/14.
//  Copyright (c) 2014 Barrett Breshears. All rights reserved.
//

#import "MenuTableViewController.h"
#import "SWRevealViewController.h"
#import "MyTripsViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up menu item array
    _menuItems = @[
                   @{
                       @"title":NSLocalizedString(@"Print travel plan for next month", nil),
                       @"cellType":@"basic"
                       },
                   @{
                       @"title":NSLocalizedString(@"Log Out", nil),
                       @"cellType":@"log-out"
                       }
                   ];
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:99.0/255.0f green:134.0/255.0f blue:169.0/255.0f alpha:1]];
    
    _nextMonthView = [[UIWebView alloc] init];
    _nextMonthTrips = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
 * set the number of sections in the menu table
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

/*
 * set the number of rows in the table
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_menuItems count];
}

/*
 * set up menu cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *cellData = [_menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[cellData objectForKey:@"cellType"] forIndexPath:indexPath];
    
    [cell.textLabel setText:[cellData objectForKey:@"title"]];
    cell.backgroundColor = [UIColor colorWithRed:99.0/255.0f green:134.0/255.0f blue:169.0/255.0f alpha:1];
    cell.textLabel.textColor = [UIColor whiteColor];
    // Configure the cell...
    
    return cell;
}


/*
 * when the user selects a row goto the new view controller
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SWRevealViewController *revealController = self.revealViewController;
    
    // selecting row
    NSInteger row = indexPath.row;
    
    UIViewController *newFrontController = nil;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // print next months travel plans
    if (row == 0)
    {
        [self printNextMonth];
    }else if (row == 1){
        // log the user out and show the login screen
        [PFUser logOut];
        newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
        [revealController pushFrontViewController:navigationController animated:YES];
    }
    
    
}


/*
 * Gets the next months trips and sends them to the printer
 */
- (void)printNextMonth{
    
    
    
    // first we need to get next month
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 1;
    NSDate *nextMonth = [gregorian dateByAddingComponents:components toDate:today options:0];
    NSDateComponents *dayOneComponents = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:nextMonth];
    dayOneComponents.day = 1;
    
    // once we have the next month we are able to get the first day of the month
    NSDate *firstDay = [gregorian dateFromComponents:dayOneComponents];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange rng = [cal rangeOfUnit:NSCalendarUnitDay
                            inUnit:NSCalendarUnitMonth
                           forDate:nextMonth];
    
    // finally get the last day of the month
    NSUInteger numberOfDaysInMonth = rng.length;
    NSDateComponents *lastDayComponents = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:nextMonth];
    lastDayComponents.day = numberOfDaysInMonth;
    
    NSDate *lastDay = [gregorian dateFromComponents:lastDayComponents];
    
    
    // now that we have the first and last day of the month we can query
    // trips for next month
    PFQuery *query = [PFQuery queryWithClassName:@"Trip"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query orderByAscending:@"startDate"];
    [query whereKey:@"startDate" greaterThan:firstDay];
    [query whereKey:@"startDate" lessThan:lastDay];
    __weak MenuTableViewController *weakself = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            // clear out trips and load new trips into the array
            [weakself.nextMonthTrips removeAllObjects];
            [weakself.nextMonthTrips addObjectsFromArray:objects];
            // call loadWebViewAndPrint to send to printer
            [weakself loadWebViewAndPrint];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

/*
 * Load results into a webview that we will send to the printer
 */
-(void)loadWebViewAndPrint{
    
    // html string
    NSMutableString *html = [[NSMutableString alloc] init];
    [html appendString:@"<html><head><title>Next month's travel plans</title></head><body>"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM-dd-yy HH:mm"];
    // loop through the trips and add them to html
    for (int i = 0; [_nextMonthTrips count] > i; i++) {
        PFObject *trip = [_nextMonthTrips objectAtIndex:i];
        [html appendString:@"<div>"];
        [html appendString:[NSString stringWithFormat:@"Destination: %@ <br/>",[trip objectForKey:@"destination"]]];
        [html appendString:[NSString stringWithFormat:@"Start Date: %@ <br/>",[format stringFromDate:[trip objectForKey:@"startDate"]]]];
        [html appendString:[NSString stringWithFormat:@"End Date: %@ <br/>",[format stringFromDate:[trip objectForKey:@"endDate"]]]];
        [html appendString:[NSString stringWithFormat:@"Comment: %@ <br/>",[trip objectForKey:@"comment"]]];
        [html appendString:@"</div>"];
    }
    // close out the body and html tags
    [html appendString:@"</body></html>"];
    
    // initalize our webview
    _nextMonthView = [[UIWebView alloc] initWithFrame: CGRectZero];
    [_nextMonthView loadHTMLString:html baseURL:nil];
    
    
    // set up the interface to the printer
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.delegate = self;
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"travel plan for next month";
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    pic.printInfo = printInfo;
    pic.showsPageRange = YES;
    
    // send the print job over
    UIViewPrintFormatter *formatter = [_nextMonthView viewPrintFormatter];
    pic.printFormatter = formatter;
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"Printing could not complete because of error: %@", error);
        }
    };
    
    // present the printer interface
    [pic presentAnimated:YES completionHandler:completionHandler];
}


@end
