//
//  EarthquakeAnnotation.h
//  EarthShakes
//
//  Created by Nate Armstrong on 8/21/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

@import Foundation;
@import MapKit;
@import EarthShakeKit;

@interface EarthquakeAnnotation : NSObject <MKAnnotation>

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D)coordinate placeName:(NSString *)placeName magnitude:(EarthquakeMagnitude)magnitude;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) EarthquakeMagnitude magnitude;
@property (nonatomic, readonly) NSString *placeName;

@end
