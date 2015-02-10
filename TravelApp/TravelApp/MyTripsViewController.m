//
//  MyTripsViewController.m
//  TravelApp
//
//  Created by Barrett Breshears on 10/25/14.
//  Copyright (c) 2014 Barrett Breshears. All rights reserved.
//

#import "MyTripsViewController.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
#import "TripViewController.h"
#import "PopOver.h"
#import "TripDetailViewController.h"

@interface MyTripsViewController ()

@end

@implementation MyTripsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationItem setHidesBackButton:YES];
    self.title = NSLocalizedString(@"My Trips", nil);
    
    _filters = [[NSMutableArray alloc] init];
    
    _dateFormat = [[NSDateFormatter alloc] init];
    [_dateFormat setDateFormat:@"MM-dd-yy HH:mm"];
    
    // set up navbar
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                                                              action:@selector(newTrip)];
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"filter"]
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(filter)];
    self.navigationItem.rightBarButtonItems = @[addButton, filterButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"menu"
                                                                             style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
}

/*
 * Make sure the navigationbar is shown and set the correct color
 */
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:99.0/255.0f green:134.0/255.0f blue:169.0/255.0f alpha:1]];
    
    [self getTripData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * Gets the trip data from parse
 */
- (void)getTripData{
    
    __weak MyTripsViewController *weakself = self;
    
    // set up the query
    PFQuery *query = [PFQuery queryWithClassName:@"Trip"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query orderByAscending:@"startDate"];
    
    // add any filters
    for (int i = 0; i < [_filters count]; i++) {
        NSDictionary *filter = [_filters objectAtIndex:i];
        // filter based on destination
        if ( [[filter objectForKey:@"filter"] isEqualToString:@"destination"]) {
            
            [query whereKey:[filter objectForKey:@"filter"] containsString:[filter objectForKey:@"searchParam"]];
            
        // filter based on startDate
        }else if([[filter objectForKey:@"filter"] isEqualToString:@"startDate"]){
            
            // check if we filtering dates before or after filter date
            if ( [[filter objectForKey:@"dateIs"] isEqualToString:@"After"]) {
                [query whereKey:[filter objectForKey:@"filter"] greaterThan:[filter objectForKey:@"searchParam"]];
            }else{
                [query whereKey:[filter objectForKey:@"filter"] lessThan:[filter objectForKey:@"searchParam"]];
            }
         
        // filter based on endDate
        }else if([[filter objectForKey:@"filter"] isEqualToString:@"endDate"]){
            
            // check if we filtering dates before or after filter date
            if ( [[filter objectForKey:@"dateIs"] isEqualToString:@"After"]) {
                [query whereKey:[filter objectForKey:@"filter"] greaterThan:[filter objectForKey:@"searchParam"]];
            }else{
                [query whereKey:[filter objectForKey:@"filter"] lessThan:[filter objectForKey:@"searchParam"]];
            }
            
        // filter based on comments
        }else{
            [query whereKey:[filter objectForKey:@"filter"] containsString:[filter objectForKey:@"searchParam"]];
        }
        
    }

    // add loading screen and query parse
    [self showLoadingViewWithText:NSLocalizedString(@"Getting Trips", nil)];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [weakself hideLoadingView];
        if (!error) {
            // The find succeeded.
            // set array and reload table
            weakself.tripsArray = [[NSMutableArray alloc] initWithArray:objects];
            [weakself.myTripsTable reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


/*
 * User is going to add a new trip so we load in the new view
 */
- (void)newTrip{
    [self performSegueWithIdentifier:@"newTrip" sender:self];
}

/*
 * Toggle the menu
 */
- (void)showMenu{
    [self.revealViewController revealToggle:self];
}

/*
 * Add the filter view to current view
 */
- (void)filter{
    
    // get the filter frame
    CGRect newFrame = CGRectMake(5, 69, self.myTripsTable.frame.size.width - 10, self.myTripsTable.bounds.size.height - 74
                                 );
    // create the new filter popover and add to the view
    PopOver *filter = PopOver.new;
    filter.delegate = self;
    filter.view.frame = newFrame;
    [self addChildViewController:filter];
    [self.view addSubview:filter.view];
    
}


#pragma mark - Table view data source

/*
 * Set the number of table section
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // if there are filters there will be 2 sections
    if ([_filters count] > 0) {
        return 2;
    }
    // otherwise there will be only 2 section
    return 1;
}


/*
 * Set the table section headers
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // if there are any filters there will be two sections
    if ([_filters count] > 0 && section == 0) {
        return NSLocalizedString(@"Filters", nil);
    }else{
        // otherwise there is only the Trips section
        return NSLocalizedString(@"Trips", nil);
    }
};


/*
 * Set the number or rows in each section
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // get the number of filters for the filter section
    if ([_filters count] > 0 && section == 0) {
        return [_filters count];
    }else{
        // get the number of trips
        
        // if there aren't any load at least 1 so we can load an empty cell
        if ([_tripsArray count] == 0) {
            return 1;
        }
        
        return [_tripsArray count];
    }
}


/*
 * Return a cell for tableview at indexpath
 */
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

     // if there are filters and we are in section 0 load the filters cell
     if ([_filters count] > 0 && indexPath.section == 0) {
         // get the filter
         NSDictionary *filter = [_filters objectAtIndex:indexPath.row];
         
         // create the cell and retrun it
         NSString *reuseIdentifier = @"filterCell";
         UITableViewCell *cell = [self.myTripsTable dequeueReusableCellWithIdentifier:reuseIdentifier];
         if (!cell) {
             cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
         }
         
         // show the text based filter for comment and destination filters
         if ([[filter objectForKey:@"filter"] isEqualToString:@"destination"] || [[filter objectForKey:@"filter"] isEqualToString:@"comment"]) {
             cell.textLabel.text = [NSString stringWithFormat:@"%@ contains %@", [filter objectForKey:@"filterDescription"], [filter objectForKey:@"searchParam"]];
         }else{
         // show the date based filter for startDate and endDate
              cell.textLabel.text = [NSString stringWithFormat:@"%@ is %@  %@", [filter objectForKey:@"filterDescription"],[filter objectForKey:@"dateIs"], [_dateFormat stringFromDate:[filter objectForKey:@"searchParam"]]];
         }
         // set up custom accesory view to delete the filter
         cell.accessoryView = [self makeDetailDisclosureButton];
         [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
         
         return cell;
     }else{
         // check to se if there are any trips if not show an empty cell
         if([_tripsArray count] == 0){
             NSString *reuseIdentifier = @"filterCell";
             UITableViewCell *cell = [self.myTripsTable dequeueReusableCellWithIdentifier:reuseIdentifier];
             if (!cell) {
                 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
             }
             
             [cell.textLabel setText:NSLocalizedString(@"There are no trips use the + to add more", nil)];
             return  cell;
         }
         
         // otherwise get the trip and create the new cell
         PFObject *trip = [_tripsArray objectAtIndex:indexPath.row];
         static NSString * reuseIdentifier = @"programmaticCell";
         MGSwipeTableCell * cell = [self.myTripsTable dequeueReusableCellWithIdentifier:reuseIdentifier];
         if (!cell) {
             cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
         }
         
         cell.textLabel.text = [trip objectForKey:@"destination"];
         
         // show start date and end date
         if([self daysBetweenDate:[NSDate date] andDate:[trip objectForKey:@"startDate"]] < 1){
             cell.detailTextLabel.text = [NSString stringWithFormat:@"Start %@ -  End %@", [_dateFormat stringFromDate:[trip objectForKey:@"startDate"]], [_dateFormat stringFromDate:[trip objectForKey:@"endDate"]]];
         }else{
             // show days remaing until trip if its in the future as well as start and end date
             cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld days away Start %@ -  End %@", (long)[self daysBetweenDate:[NSDate date] andDate:[trip objectForKey:@"startDate"]], [_dateFormat stringFromDate:[trip objectForKey:@"startDate"]], [_dateFormat stringFromDate:[trip objectForKey:@"endDate"]]];

         
         }
         
         // set the delegate
         cell.delegate = self;
         
         //configure right buttons
         cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor]],
                               [MGSwipeButton buttonWithTitle:@"Edit" backgroundColor:[UIColor lightGrayColor]]];
         cell.rightSwipeSettings.transition = MGSwipeTransitionBorder;
         return cell;
     }
 
 }

/*
 * event handleing for when the edit or delete button is tapped
 */
-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion{
    NSIndexPath *indexPath = [_myTripsTable indexPathForCell:cell];
    if (index == 0) {
        // delete
        [self deleteTrip:indexPath];
    }else{
        _selectedTrip = [_tripsArray objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"editTrip" sender:self];
    }
    
    return YES;
}

/*
 * event handleing for the delete button on the filter accesoryButon
 */
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    // remove the filter and get the new data
    [_filters removeObjectAtIndex:indexPath.row];
    [_myTripsTable reloadData];
    [self getTripData];
}

/*
 * show the trip detail when the cell is selected
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // don't do naything when selecting a filter
    if ([_filters count] > 0 && indexPath.section == 0) {
        return;
    }
    
    // if there are no trips return
    if ([_tripsArray count] == 0) {
        return;
    }
    _selectedTrip = [_tripsArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showDetail" sender:self];
    
    
}

/*
 * create method for the custom accesory view
 */
- (void) accessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event
{
    NSIndexPath * indexPath = [_myTripsTable indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: _myTripsTable]];
    if ( indexPath == nil )
        return;
    
    [_myTripsTable.delegate tableView: _myTripsTable accessoryButtonTappedForRowWithIndexPath: indexPath];
}

/*
 * create the custom accessory view
 */
- (UIButton *) makeDetailDisclosureButton
{
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28.0, 28.0)];
    
    [button setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [button addTarget: self
               action: @selector(accessoryButtonTapped:withEvent:)
     forControlEvents: UIControlEventTouchUpInside];
    
    return ( button );
}


/*
 * return the number of days between two dates
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

/*
 * delete the trip when the user tapped the delete button
 */
- (void)deleteTrip:(NSIndexPath *)index{
    
    // remove trip from array and delete from pasre
    PFObject *trip = [_tripsArray objectAtIndex:index.row];
    [trip deleteInBackground];
    [_tripsArray removeObjectAtIndex:index.row];
    if([_tripsArray count] == 0){
        [self.myTripsTable reloadData];
        return;
    }
    // update the table
    [self.myTripsTable beginUpdates];
    [self.myTripsTable deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationBottom];
    [self.myTripsTable endUpdates];
    
}

/*
 * add filter, and query parse again
 */
- (void)addFilter:(NSDictionary *)filterDictionary{
    [_filters addObject:filterDictionary];
    [self.myTripsTable reloadData];
    [self getTripData];
}


/*
 * prepares the incomming viewcontroller for segue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // if we are going to edit trip load in trip data
    if ([segue.identifier isEqualToString:@"editTrip"]) {
        TripViewController *controller = (TripViewController *)[segue destinationViewController];
        controller.update = YES;
        controller.trip = _selectedTrip;
    // if we are going to trip detail load in trip data
    }else if([segue.identifier isEqualToString:@"showDetail"]){
        TripDetailViewController *controller = (TripDetailViewController *)[segue destinationViewController];
        controller.trip = _selectedTrip;
    }
    
}

@end
