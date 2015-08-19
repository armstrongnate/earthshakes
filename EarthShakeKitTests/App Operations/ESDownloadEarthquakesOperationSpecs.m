//
//  ESDownloadEarthquakesOperationSpecs.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/13/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

@import Foundation;
@import Specta;
@import Expecta;

#import "ESDownloadEarthquakesOperation.h"

SpecBegin(ESDownloadEarthquakesOperationSpec)

describe(@"ESDownloadEarthquakesOperationSpec", ^{
	it(@"downloads earthquakes json", ^{
		NSError *error = nil;
		NSURL *cacheFolder = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory
																	inDomain:NSUserDomainMask
														   appropriateForURL:nil
																	  create:nil
																	   error:&error];
		expect(error).to.beNil();
		NSURL *cacheFile = [cacheFolder URLByAppendingPathComponent:@"earthquakes.json"];
		__block ESDownloadEarthquakesOperation *downloadOperation;
		waitUntil(^(DoneCallback done) {
    		NSOperationQueue *queue = [NSOperationQueue new];
			queue.suspended = true;

    		downloadOperation = [[ESDownloadEarthquakesOperation alloc] initWithCacheFile:cacheFile];
			[queue addOperation:downloadOperation];

			NSOperation *doneOperation = [NSBlockOperation blockOperationWithBlock:done];
			[doneOperation addDependency:downloadOperation];
			[queue addOperation:doneOperation];

			queue.suspended = false;
		});
		expect([[NSFileManager defaultManager] fileExistsAtPath:cacheFile.path]).to.beTruthy();
	});
});

SpecEnd
