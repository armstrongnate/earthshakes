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

	it(@"is initialized with a context and completion handler", ^{
		ESGetEarthquakesOperation *getOperation = [[ESGetEarthquakesOperation alloc] initWithContext:context completionHandler:nil];
		expect(getOperation).toNot.beNil();
	});

	it(@"should finish", ^{
		waitUntil(^(DoneCallback done) {
			NSOperationQueue *queue = [NSOperationQueue new];
    		ESGetEarthquakesOperation *getOperation = [[ESGetEarthquakesOperation alloc] initWithContext:context completionHandler:done];
			[queue addOperation:getOperation];
		});
        expect(context.insertedObjects.count > 0).to.beTruthy();
	});

});

SpecEnd
