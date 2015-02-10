//
//  MyTripsViewController.h
//  TravelApp
//
//  Created by Barrett Breshears on 10/25/14.
//  Copyright (c) 2014 Barrett Breshears. All rights reserved.
//

#import "BaseViewController.h"
#import "MGSwipeTableCell.h"
#import "PopOver.h"

@interface MyTripsViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate, FilterPopOverDelegate>

@property (nonatomic, strong) IBOutlet UITableView *myTripsTable;

@property (nonatomic, strong) NSMutableArray *tripsArray;
@property (nonatomic, strong) NSMutableArray *filters;
@property (nonatomic, strong) NSDateFormatter *dateFormat;
@property (nonatomic, strong) PFObject *selectedTrip;


@end
