//
//  ESGetEarthquakesOperation.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/18/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "ESGetEarthquakesOperation.h"
#import "ESDownloadEarthquakesOperation.h"
#import "ESParseEarthquakesOperation.h"

@implementation ESGetEarthquakesOperation

- (instancetype)initWithContext:(NSManagedObjectContext *)context url:(NSURL *)url completionHandler:(void (^)())completion
{
	if (!(self = [super initWithOperations:@[]])) return nil;


	NSURL *cacheFolder = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory
																inDomain:NSUserDomainMask
													   appropriateForURL:nil
																  create:nil
																   error:nil];
	NSURL *cacheFile = [cacheFolder URLByAppendingPathComponent:@"earthquakes.json"];

    ESDownloadEarthquakesOperation *downloadOperation = [[ESDownloadEarthquakesOperation alloc] initWithURL:url cacheFile:cacheFile];
	[self addOperation:downloadOperation];

	ESParseEarthquakesOperation *parseOperation = [[ESParseEarthquakesOperation alloc] initWithCacheFile:cacheFile context:context];
	[parseOperation addDependency:downloadOperation];
	[self addOperation:parseOperation];

	NSBlockOperation *finishOperation = [NSBlockOperation blockOperationWithBlock:^{
		[self finish];
		completion();
	}];

	[finishOperation addDependency:parseOperation];
	[self addOperation:finishOperation];

	return self;
}

@end
