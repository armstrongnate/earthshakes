//
//  ESParseEarthquakesOperationSpecs.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/18/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

@import Foundation;
@import Specta;
@import Expecta;

#import "ESParseEarthquakesOperation.h"
#import "ESPersistenceHelper.h"
#import "ESDownloadEarthquakesOperation.h"

SpecBegin(ESParseEarthquakesOperationSpec)

describe(@"ESParseEarthquakesOperation", ^{

	__block NSManagedObjectContext *context;
	__block NSURL *cacheFile;
	beforeAll(^{
		context = [[[ESPersistenceHelper alloc] init] context];

		NSURL *cacheFolder = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:nil error:nil];
		cacheFile = [cacheFolder URLByAppendingPathComponent:@"earthquakes.json"];

		expect(context).toNot.beNil();
		expect(cacheFile).toNot.beNil();
	});

	afterEach(^{
		[context reset];
	});

	it(@"can be initialized with path and context", ^{
		ESParseEarthquakesOperation *parseOperation = [[ESParseEarthquakesOperation alloc] initWithCacheFile:cacheFile context:context];
		expect(parseOperation).toNot.beNil();
	});

	it(@"inserts objects into the context", ^{
		__block ESParseEarthquakesOperation *parseOperation;
		waitUntil(^(DoneCallback done) {
			NSOperationQueue *queue = [NSOperationQueue new];
			queue.suspended = YES;

			ESDownloadEarthquakesOperation *downloadOperation = [[ESDownloadEarthquakesOperation alloc] initWithCacheFile:cacheFile];
			[queue addOperation:downloadOperation];

			parseOperation = [[ESParseEarthquakesOperation alloc] initWithCacheFile:cacheFile context:context];
			[parseOperation addDependency:downloadOperation];
			[queue addOperation:parseOperation];

			NSBlockOperation *doneOperation = [NSBlockOperation blockOperationWithBlock:done];
			[doneOperation addDependency:parseOperation];
			[queue addOperation:doneOperation];

			queue.suspended = NO;
		});
        expect([context insertedObjects].count > 0).to.beTruthy();
	});

});

SpecEnd
