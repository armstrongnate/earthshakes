//
//  ESEarthquake.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/18/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "ESEarthquake.h"


@implementation ESEarthquake

@dynamic identifier;
@dynamic latitude;
@dynamic longitude;
@dynamic timestamp;
@dynamic magnitude;

+ (NSString *)entityName
{
	return @"ESEarthquake";
}

+ (instancetype)insertNewObjectInContext:(NSManagedObjectContext *)context
{
	return [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
}

@end
