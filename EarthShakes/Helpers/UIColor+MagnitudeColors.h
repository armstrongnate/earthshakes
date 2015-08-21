//
//  UIColor+MagnitudeColors.h
//  EarthShakes
//
//  Created by Nate Armstrong on 8/21/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

@import UIKit;
@import EarthShakeKit;

@interface UIColor (MagnitudeColors)

+ (UIColor *)lowestMagnitudeColor;
+ (UIColor *)weakMagnitudeColor;
+ (UIColor *)moderateMagnitudeColor;
+ (UIColor *)strongMagnitudeColor;
+ (UIColor *)violentMagnitudeColor;
+ (UIColor *)colorForEarthquakeMagnitude:(EarthquakeMagnitude)magnitude;

@end
