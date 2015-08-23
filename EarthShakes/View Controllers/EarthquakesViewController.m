//
//  EarthquakesViewController.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/19/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "EarthquakesViewController.h"
#import "EarthquakesViewController+CollectionView.h"
#import "EarthquakesViewController+MapView.h"
#import "EarthquakeDetailViewController.h"
#import "EarthquakeCollectionViewCell.h"
#import "EarthquakesFlowLayout.h"
#import "EarthquakeAnnotation.h"

@interface EarthquakesViewController ()

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation EarthquakesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup
{
    [self layoutMapView];
    [self layoutCollectionView];
    [self.refreshControl beginRefreshing];
}

- (void)layoutMapView
{
    UIView *view = self.view;
    MKMapView *mapView = [MKMapView new];
    [mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    mapView.delegate = self;
    [view addSubview:mapView];

    // constrain left and right
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[mapView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mapView)]];

    // constrain top
    [view addConstraint:[NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];

    // constrain bottom
    [view addConstraint:[NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    self.mapView = mapView;
}

- (void)layoutCollectionView
{
    UIView *view = self.view;
    EarthquakesFlowLayout *flowLayout = [EarthquakesFlowLayout new];
    CGRect frame = CGRectMake(0, CGRectGetMidY(view.frame), CGRectGetWidth(view.frame), CGRectGetHeight(view.frame) / 2);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    [collectionView registerClass:[EarthquakeCollectionViewCell class] forCellWithReuseIdentifier:EarthquakeCellReuseIdentifier];
    [collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [view addSubview:collectionView];

    // refresh control
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(getEarthquakes) forControlEvents:UIControlEventValueChanged];;
    [collectionView addSubview:refreshControl];
    self.refreshControl = refreshControl;
    collectionView.alwaysBounceVertical = YES;

    // constrain left and right
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];

    // constrain top
    [view addConstraint:[NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    // constrain bottom
    [view addConstraint:[NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

    self.collectionView = collectionView;
}

- (void)setContext:(NSManagedObjectContext *)context
{
	_context = context;
	if (context == nil) return;

	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[ESEarthquake entityName]];
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timestamp"
															  ascending:NO
															   selector:nil]];
    request.fetchLimit = 100;
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																		managedObjectContext:context
																		  sectionNameKeyPath:nil
																				   cacheName:nil];
    [self getEarthquakes];
}

- (void)getEarthquakes
{
    if (_queue == nil) _queue = [NSOperationQueue new];
    NSURL *url = [NSURL URLWithString:@"http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_month.geojson"];
    ESGetEarthquakesOperation *operation = [[ESGetEarthquakesOperation alloc] initWithContext:self.context url:url completionHandler:^{
		dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
			[self updateUI];
		});
	}];
	[self.queue addOperation:operation];
}

- (void)updateUI
{
	NSError *fetchError = nil;
	[self.fetchedResultsController performFetch:&fetchError];
    [self.collectionView reloadData];
    [self reloadMap];
}

- (void)reloadMap
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    __block MKMapRect zoomRect = MKMapRectNull;
    [[self.fetchedResultsController fetchedObjects] enumerateObjectsUsingBlock:^(ESEarthquake *earthquake, NSUInteger idx, BOOL *stop) {
        // add annotation
        EarthquakeAnnotation *annotation = [[EarthquakeAnnotation alloc] initWithEarthquake:earthquake];
        [self.mapView addAnnotation:annotation];

        // keep track of zoom rect
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }];
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
}

- (void)zoomMapViewToEarthquake:(ESEarthquake *)earthquake
{
    [self.mapView.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[EarthquakeAnnotation class]])
        {
            EarthquakeAnnotation *annotation = (EarthquakeAnnotation *)obj;
            if (annotation.earthquake == earthquake)
            {
                [self.mapView selectAnnotation:annotation animated:YES];
                *stop = YES;
            }
        }
    }];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"presentEarthquake:"] && [sender isKindOfClass:[MKAnnotationView class]])
    {
        EarthquakeAnnotation *annotation = ((MKAnnotationView *)sender).annotation;
        EarthquakeDetailViewController *detail = ((EarthquakeDetailViewController *)((UINavigationController *)segue.destinationViewController).topViewController);
        detail.earthquake = annotation.earthquake;
    }
}

- (IBAction)unwindFromEarthquake:(UIStoryboardSegue *)segue
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
