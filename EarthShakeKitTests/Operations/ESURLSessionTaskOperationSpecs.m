//
//  ESURLSessionTaskOperationSpecs.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/18/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

@import Foundation;
@import Specta;
@import Expecta;

#import "ESURLSessionTaskOperation.h"

SpecBegin(ESURLSessionTaskOperationSpec)

describe(@"ESURLSessionTaskOperation", ^{
	it(@"should complete task and finish operation", ^{
		__block NSURLSessionTask *task;
		__block ESURLSessionTaskOperation *taskOperation;
		waitUntil(^(DoneCallback done) {
        	NSOperationQueue *queue = [NSOperationQueue new];
			queue.suspended = true;

        	NSURL *url = [NSURL URLWithString:@"http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_month.geojson"];
			task = [[NSURLSession sharedSession] downloadTaskWithURL:url];
			taskOperation = [[ESURLSessionTaskOperation alloc] initWithTask:task];
			[queue addOperation:taskOperation];

			NSBlockOperation *doneOperation = [NSBlockOperation blockOperationWithBlock:done];
			[doneOperation addDependency:taskOperation];
			[queue addOperation:doneOperation];

			queue.suspended = false;
		});
		expect(task.state).to.equal(NSURLSessionTaskStateCompleted);
		expect(taskOperation.finished).to.beTruthy();
	});
});

SpecEnd
