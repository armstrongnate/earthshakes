//
//  ESEarthquake.h
//  EarthShakes
//
//  Created by Nate Armstrong on 8/18/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

@import Foundation;
@import CoreData;

typedef NS_ENUM(NSUInteger, EarthquakeMagnitude) {
    EarthquakeMagnitudeNone,
    EarthquakeMagnitudeWeak,
    EarthquakeMagnitudeModerate,
    EarthquakeMagnitudeStrong,
    EarthquakeMagnitudeViolent
};

@interface ESEarthquake : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber * magnitude;

+ (instancetype)insertNewObjectInContext:(NSManagedObjectContext *)context;
+ (instancetype)earthquakeWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context;
+ (NSString *)entityName;

- (EarthquakeMagnitude)magnitudeCategory;

@end
