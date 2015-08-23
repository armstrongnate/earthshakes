//
//  ESEarthquakeSpecs.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/21/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

@import Foundation;
@import Specta;
@import Expecta;

#import "ESEarthquake.h"
#import "ESPersistenceHelper.h"

SpecBegin(ESEarthquakeSpec)

describe(@"ESEarthquake", ^{

    __block ESEarthquake *_earthquake;
    beforeEach(^{
        NSManagedObjectContext *context = [[ESPersistenceHelper alloc] init].context;
        _earthquake = [ESEarthquake insertNewObjectInContext:context];
    });

    it(@"has magnitude category", ^{
        _earthquake.magnitude = [NSNumber numberWithDouble:1.0];
        expect([_earthquake magnitudeCategory]).to.equal(EarthquakeMagnitudeNone);

        _earthquake.magnitude = [NSNumber numberWithDouble:2.3];
        expect([_earthquake magnitudeCategory]).to.equal(EarthquakeMagnitudeWeak);

        _earthquake.magnitude = [NSNumber numberWithDouble:3.4];
        expect([_earthquake magnitudeCategory]).to.equal(EarthquakeMagnitudeModerate);

        _earthquake.magnitude = [NSNumber numberWithDouble:4.7];
        expect([_earthquake magnitudeCategory]).to.equal(EarthquakeMagnitudeStrong);

        _earthquake.magnitude = [NSNumber numberWithDouble:5.1];
        expect([_earthquake magnitudeCategory]).to.equal(EarthquakeMagnitudeViolent);

        _earthquake.magnitude = [NSNumber numberWithDouble:8.7];
        expect([_earthquake magnitudeCategory]).to.equal(EarthquakeMagnitudeViolent);

        _earthquake.magnitude = [NSNumber numberWithDouble:9.5];
        expect([_earthquake magnitudeCategory]).to.equal(EarthquakeMagnitudeViolent);
    });

});

SpecEnd
