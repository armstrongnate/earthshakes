//
//  EarthquakesViewController+MapView.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/21/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "EarthquakesViewController+MapView.h"
#import "EarthquakeAnnotation.h"
#import "UIImage+MagnitudeAnnotationImages.h"

@implementation EarthquakesViewController (MapView)

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = nil;
    if ([annotation isKindOfClass:[EarthquakeAnnotation class]])
    {
        static NSString * const identifier = @"earthquakeannotation";

        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:identifier];
        }
        annotationView.canShowCallout = YES;
        EarthquakeAnnotation *earthquakeAnnotation = (EarthquakeAnnotation *)annotation;
        annotationView.image = [UIImage annotationImageForMagnitude:[earthquakeAnnotation.earthquake magnitudeCategory]];
        annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
    }

    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[EarthquakeAnnotation class]])
    {
        EarthquakeAnnotation *annotation = view.annotation;
        NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:annotation.earthquake];
        if (indexPath != nil) {
            [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];
        }
    }
}

@end
