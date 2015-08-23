//
//  EarthquakeDetailViewController.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/22/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

@import MapKit;

#import "EarthquakeDetailViewController.h"
#import "EarthquakeAnnotation.h"

@interface EarthquakeDetailViewController ()

@property (nonatomic, strong) NSDictionary *tableData;

@end

@implementation EarthquakeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setEarthquake:(ESEarthquake *)earthquake
{
    _earthquake = earthquake;

    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterMediumStyle;
    self.tableData = @{
                       @"Magnitude" : [earthquake.magnitude stringValue],
                       @"Location" : earthquake.place,
                       @"Lat/Long" : [NSString stringWithFormat:@"%@/%@", earthquake.latitude, earthquake.longitude],
                       @"Date" : [formatter stringFromDate:earthquake.timestamp]
   };
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData allKeys].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
        NSString *label = [self.tableData allKeys][indexPath.row];
        cell.textLabel.text = label;
        cell.detailTextLabel.text = [self.tableData objectForKey:label];
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 180)];
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake([self.earthquake.latitude doubleValue], [self.earthquake.longitude doubleValue]);
        MKCoordinateSpan span = MKCoordinateSpanMake(3, 3);
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        [mapView setRegion:region animated:NO];

        EarthquakeAnnotation *annotation = [[EarthquakeAnnotation alloc] initWithEarthquake:self.earthquake];
        [mapView addAnnotation:annotation];
        return mapView;
    }

    return nil;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180.0;
}

@end
