//
//  EarthquakeDetailViewController.h
//  EarthShakes
//
//  Created by Nate Armstrong on 8/22/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

@import UIKit;
@import EarthShakeKit;

@interface EarthquakeDetailViewController : UITableViewController

@property (nonatomic, strong) ESEarthquake *earthquake;

@end
