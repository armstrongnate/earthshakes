//
//  EarthquakesFlowLayout.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/20/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "EarthquakesFlowLayout.h"

@interface EarthquakesFlowLayout ()

@end

@implementation EarthquakesFlowLayout

- (instancetype)init
{
    if (!(self = [super init])) return nil;

    self.minimumInteritemSpacing = 5;
    self.minimumLineSpacing = 5;
    self.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);

    return self;
}

@end
