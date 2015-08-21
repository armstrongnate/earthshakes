//
//  UIColor+MagnitudeColors.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/21/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "UIColor+MagnitudeColors.h"

@implementation UIColor (MagnitudeColors)

+ (UIColor *)lowestMagnitudeColor
{
    return [UIColor colorWithWhite:223/255.0 alpha:1.0];
}

+ (UIColor *)weakMagnitudeColor
{
    return [UIColor colorWithWhite:155/255.0 alpha:1.0];
}

+ (UIColor *)moderateMagnitudeColor
{
    return [UIColor colorWithWhite:74/255.0 alpha:1.0];
}

+ (UIColor *)strongMagnitudeColor
{
    return [UIColor colorWithRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:1.0];
}

+ (UIColor *)violentMagnitudeColor
{
    return [UIColor colorWithRed:208/255.0 green:2/255.0 blue:27/255.0 alpha:1.0];
}

+ (UIColor *)colorForEarthquakeMagnitude:(EarthquakeMagnitude)magnitude
{
    switch (magnitude) {
        case EarthquakeMagnitudeNone:       return [self lowestMagnitudeColor];
        case EarthquakeMagnitudeWeak:       return [self weakMagnitudeColor];
        case EarthquakeMagnitudeModerate:   return [self moderateMagnitudeColor];
        case EarthquakeMagnitudeStrong:     return [self strongMagnitudeColor];
        case EarthquakeMagnitudeViolent:    return [self violentMagnitudeColor];
    }
}

@end
