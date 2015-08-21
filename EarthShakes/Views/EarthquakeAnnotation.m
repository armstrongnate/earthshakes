//
//  EarthquakeAnnotation.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/21/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "EarthquakeAnnotation.h"

@interface EarthquakeAnnotation ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite) NSString *title;

@end

@implementation EarthquakeAnnotation

- (instancetype)initWithEarthquake:(ESEarthquake *)earthquake
{
    if (!(self = [super init])) return nil;

    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([earthquake.latitude doubleValue], [earthquake.longitude doubleValue]);
    self.coordinate = coordinate;
    self.title = earthquake.place;
    self.earthquake = earthquake;

    return self;
}

@end
