//
//  EarthquakesViewController.h
//  EarthShakes
//
//  Created by Nate Armstrong on 8/19/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

@import UIKit;
@import CoreData;

@interface EarthquakesViewController : UIViewController

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end
