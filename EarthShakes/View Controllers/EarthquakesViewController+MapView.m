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
        annotationView.image = [UIImage annotationImageForMagnitude:((EarthquakeAnnotation *)annotation).magnitude];
        annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
    }

    return annotationView;
}

@end
