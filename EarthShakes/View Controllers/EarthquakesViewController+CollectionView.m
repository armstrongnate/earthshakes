//
//  EarthquakesViewController+CollectionViewDataSource.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/19/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "EarthquakesViewController+CollectionView.h"
#import "EarthquakeCollectionViewCell.h"
#import "EarthquakeBehavior.h"

NSString * const EarthquakeCellReuseIdentifier = @"EarthquakeCell";

@implementation EarthquakesViewController (CollectionView)

#pragma MARK - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.fetchedResultsController fetchedObjects].count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EarthquakeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EarthquakeCellReuseIdentifier forIndexPath:indexPath];
    cell.earthquake = [self.fetchedResultsController objectAtIndexPath:indexPath];

    return cell;
}


#pragma MARK - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    static CGFloat const height = 60;
    CGFloat width = CGRectGetWidth(collectionView.frame) / 3;
    width -= 10;
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ESEarthquake *earthquake = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake([earthquake.latitude doubleValue], [earthquake.longitude doubleValue]);
    MKCoordinateSpan span = MKCoordinateSpanMake(3, 3);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [self.mapView setRegion:region animated:YES];
}

@end
