//
//  ESEarthquake.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/18/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "ESEarthquake.h"

NSUInteger const ViolentMagnitude = 5;
NSUInteger const StrongMagnitude = 4;
NSUInteger const ModerateMagnitude = 3;
NSUInteger const WeakMagnitude = 2;
NSUInteger const NoMagnitude = 1;

@implementation ESEarthquake

@dynamic identifier;
@dynamic place;
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

+ (instancetype)earthquakeWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context
{
    ESEarthquake *earthquake = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];

    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];

    NSAssert(matches != nil && matches.count <= 1, @"unexpected results");
    if (!matches.count)
    {
        earthquake = [self insertNewObjectInContext:context];
        earthquake.identifier = identifier;
    }
    else
    {
        earthquake = [matches lastObject];
    }
    return earthquake;
}

- (EarthquakeMagnitude)magnitudeCategory
{
    double magnitude = [self.magnitude doubleValue];
    EarthquakeMagnitude category = EarthquakeMagnitudeNone;

    if (magnitude >= ViolentMagnitude) category = EarthquakeMagnitudeViolent;
    else if (magnitude >= StrongMagnitude) category = EarthquakeMagnitudeStrong;
    else if (magnitude >= ModerateMagnitude) category = EarthquakeMagnitudeModerate;
    else if (magnitude >= WeakMagnitude) category = EarthquakeMagnitudeWeak;

    return category;
}

@end
