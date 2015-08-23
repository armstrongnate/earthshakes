//
//  ESGetEarthquakesOperationSpecs.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/18/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

@import Foundation;
@import Specta;
@import Expecta;
@import CoreData;

#import "ESGetEarthquakesOperation.h"
#import "ESPersistenceHelper.h"

SpecBegin(ESGetEarthquakesOperationSpec)

describe(@"ESGetEarthquakesOperation", ^{

	__block NSManagedObjectContext *context;
	beforeAll(^{
		context = [[[ESPersistenceHelper alloc] init] context];
	});

	afterEach(^{
		[context reset];
	});

	it(@"is initialized with a context, url, and completion handler", ^{
        NSURL *url = [NSURL URLWithString:@"http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_month.geojson"];
        ESGetEarthquakesOperation *getOperation = [[ESGetEarthquakesOperation alloc] initWithContext:context url:url completionHandler:nil];
		expect(getOperation).toNot.beNil();
	});

	it(@"should finish", ^{
		waitUntil(^(DoneCallback done) {
			NSOperationQueue *queue = [NSOperationQueue new];
            NSURL *url = [NSURL URLWithString:@"http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_month.geojson"];
            ESGetEarthquakesOperation *getOperation = [[ESGetEarthquakesOperation alloc] initWithContext:context url:url completionHandler:done];
			[queue addOperation:getOperation];
		});
        expect(context.insertedObjects.count > 0).to.beTruthy();
	});

});

SpecEnd
