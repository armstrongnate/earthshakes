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

- (instancetype)initWithEarthquake:(ESEarthquake *)earthquake;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, strong) ESEarthquake *earthquake;

@end
