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
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *historyContext;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation EarthquakeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setEarthquake:(ESEarthquake *)earthquake
{
    _earthquake = earthquake;

    self.tableData = @{
                       @"Magnitude" : [earthquake.magnitude stringValue],
                       @"Location" : earthquake.place,
                       @"Lat/Long" : [NSString stringWithFormat:@"%@/%@", earthquake.latitude, earthquake.longitude],
                       @"Date" : [self.dateFormatter stringFromDate:earthquake.timestamp]
    };
    [self getHistory];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController)
    {
    	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[ESEarthquake entityName]];
    	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timestamp"
    															  ascending:NO
    															   selector:nil]];
        request.fetchLimit = 100;
    	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.historyContext
    																		  sectionNameKeyPath:nil
    																				   cacheName:nil];
    }

    return _fetchedResultsController;
}

- (NSManagedObjectContext *)historyContext
{
    if (!_historyContext)
    {
        // In memory context
    	NSURL *modelURL = [[NSBundle bundleForClass:[ESPersistenceController class]] URLForResource:@"DataModel" withExtension:@"momd"];
    	NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    	NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    	NSError *error = nil;
    	if (![coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error])
    	{
    		NSLog(@"Error: %@", error);
    	}
        _historyContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _historyContext.persistentStoreCoordinator = coordinator;
    }

    return _historyContext;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter)
    {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    }

    return _dateFormatter;
}

- (void)getHistory
{
    if (_queue == nil) _queue = [NSOperationQueue new];
    NSNumber *lat = self.earthquake.latitude;
    NSNumber *lon = self.earthquake.longitude;
    NSString *urlString = [NSString stringWithFormat:@"http://ehp2-earthquake.wr.usgs.gov/fdsnws/event/1/query?latitude=%@&longitude=%@&maxradius=5&format=geojson", lat, lon];
    NSLog(@"urlString = %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ESGetEarthquakesOperation *operation = [[ESGetEarthquakesOperation alloc] initWithContext:self.historyContext url:url completionHandler:^{
		dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            [self.fetchedResultsController performFetch:&error];
			[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
		});
	}];
	[self.queue addOperation:operation];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? [self.tableData allKeys].count : [self.fetchedResultsController fetchedObjects].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
    if (indexPath.section == 0)
    {
        NSString *label = [self.tableData allKeys][indexPath.row];
        cell.textLabel.text = label;
        cell.detailTextLabel.text = [self.tableData objectForKey:label];
    }
    else if (indexPath.section == 1)
    {
        NSIndexPath *historyIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        ESEarthquake *historicalEarthquake = [self.fetchedResultsController objectAtIndexPath:historyIndexPath];
        cell.textLabel.text = [self.dateFormatter stringFromDate:historicalEarthquake.timestamp];
        cell.detailTextLabel.text = [historicalEarthquake.magnitude stringValue];
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
    return section == 0 ? 180 : 34;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) return @"History";
    return nil;
}

@end
