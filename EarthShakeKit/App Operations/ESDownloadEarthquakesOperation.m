//
//  ESDownloadEarthquakesOperation.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/18/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "ESDownloadEarthquakesOperation.h"
#import "ESURLSessionTaskOperation.h"

@interface ESDownloadEarthquakesOperation ()

@property (nonatomic, strong) NSURL *cacheFile;

@end

@implementation ESDownloadEarthquakesOperation

- (instancetype)initWithURL:(NSURL *)url cacheFile:(NSURL *)cacheFile
{
	if (!(self = [super initWithOperations:@[]])) return nil;

	self.cacheFile = cacheFile;

	if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFile.path])
	{
		[[NSFileManager defaultManager] removeItemAtPath:cacheFile.path error:nil];
	}

	NSURLSessionTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
		[self downloadFinishedWithURL:url response:(NSHTTPURLResponse *)response error:error];
	}];
	ESURLSessionTaskOperation *taskOperation = [[ESURLSessionTaskOperation alloc] initWithTask:task];
	[self addOperation:taskOperation];

	return self;
}

- (void)downloadFinishedWithURL:(NSURL *)url response:(NSHTTPURLResponse *)response error:(NSError *)error
{
	if (error == nil && response.statusCode == 200)
	{
		NSData *data = [NSData dataWithContentsOfURL:url];
		[data writeToURL:self.cacheFile atomically:YES];
	}
    [self finish];
}

@end
