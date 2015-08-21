//
//  EarthquakesViewController.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/19/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

@import MapKit;
@import EarthShakeKit;

#import "EarthquakesViewController.h"
#import "EarthquakesViewController+CollectionView.h"
#import "EarthquakeCollectionViewCell.h"
#import "EarthquakesFlowLayout.h"

@interface EarthquakesViewController ()

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UICollectionView *collectionView;
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
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [self layoutMapView];
    [self layoutCollectionView];
}

- (void)layoutMapView
{
    UIView *view = self.view;
    MKMapView *mapView = [MKMapView new];
    [mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(0, 0);
    MKCoordinateSpan span = MKCoordinateSpanMake(1, 1);
    mapView.region = MKCoordinateRegionMake(center, span);
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
	ESGetEarthquakesOperation *operation = [[ESGetEarthquakesOperation alloc] initWithContext:self.context completionHandler:^{
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
}

@end
