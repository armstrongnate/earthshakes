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
@property (nonatomic, readwrite) EarthquakeMagnitude magnitude;
@property (nonatomic, readwrite) NSString *placeName;
@property (nonatomic, readwrite) NSString *title;

@end

@implementation EarthquakeAnnotation

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D)coordinate placeName:(NSString *)placeName magnitude:(EarthquakeMagnitude)magnitude
{
    if (!(self = [super init])) return nil;

    self.coordinate = coordinate;
    self.placeName = placeName;
    self.magnitude = magnitude;
    self.title = placeName;

    return self;
}

@end
