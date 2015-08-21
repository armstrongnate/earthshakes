//
//  UIImage+MagnitudeAnnotationImages.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/21/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "UIImage+MagnitudeAnnotationImages.h"

@implementation UIImage (MagnitudeAnnotationImages)

+ (UIImage *)annotationImageForMagnitude:(EarthquakeMagnitude)magnitude
{
    NSString *magnitudeString = nil;
    switch (magnitude) {
        case EarthquakeMagnitudeNone:       magnitudeString = @"low"; break;
        case EarthquakeMagnitudeWeak:       magnitudeString = @"weak"; break;
        case EarthquakeMagnitudeModerate:   magnitudeString = @"moderate"; break;
        case EarthquakeMagnitudeStrong:     magnitudeString = @"strong"; break;
        case EarthquakeMagnitudeViolent:    magnitudeString = @"violent"; break;
    }

    return [UIImage imageNamed:[NSString stringWithFormat:@"%@-mag-annotation", magnitudeString]];
}

@end
