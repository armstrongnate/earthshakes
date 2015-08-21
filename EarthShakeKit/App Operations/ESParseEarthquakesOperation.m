//
//  ESParseEarthquakesOperation.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/18/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "ESParseEarthquakesOperation.h"
#import "ESEarthquake.h"

@interface ESParseEarthquakesOperation ()

@property (nonatomic, strong) NSURL *cacheFile;
@property (nonatomic, strong) NSManagedObjectContext *importContext;

@end

@implementation ESParseEarthquakesOperation

- (instancetype)initWithCacheFile:(NSURL *)cacheFile context:(NSManagedObjectContext *)context
{
	if (!(self = [super init])) return nil;

	self.cacheFile = cacheFile;
	self.importContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
	self.importContext.parentContext = context;
	self.importContext.mergePolicy = NSOverwriteMergePolicy;

	return self;
}

- (void)execute
{
	NSDictionary *jsonEarthquakes = [self parseEarthquakes];
	NSAssert(jsonEarthquakes != nil, @"Failed to parse response");
	[self importEarthquakes:jsonEarthquakes];
	[self finish];
}

- (NSDictionary *)parseEarthquakes
{
	NSInputStream *inputStream = [NSInputStream inputStreamWithURL:self.cacheFile];
	NSAssert(inputStream != nil, @"No file at url %@", self.cacheFile.path);
	[inputStream open];

	NSError *jsonError;
	NSDictionary *json = [NSJSONSerialization JSONObjectWithStream:inputStream options:0 error:&jsonError];

	NSAssert(jsonError == nil && json != nil, @"JSON error: %@", jsonError);

	[inputStream close];

	return json;
}

- (void)importEarthquakes:(NSDictionary *)jsonEarthquakes
{
    NSArray *features = jsonEarthquakes[@"features"];
    if (features == nil) return;
	[features enumerateObjectsUsingBlock:^(NSDictionary *feature, NSUInteger idx, BOOL *stop) {
		[self.importContext performBlockAndWait:^{

            NSString *identifier = feature[@"id"];
            ESEarthquake *earthquake = [ESEarthquake earthquakeWithIdentifier:identifier inContext:self.importContext];

            NSDictionary *props = feature[@"properties"];

            earthquake.place = props[@"place"];
            earthquake.magnitude = props[@"mag"];
            NSNumber *offset = props[@"time"];
            earthquake.timestamp = offset == nil ? [NSDate dateWithTimeIntervalSince1970:[offset doubleValue] / 1000] : [NSDate distantFuture];

            NSDictionary *geometry = feature[@"geometry"];

            NSArray *coordinates = geometry[@"coordinates"];
            if (coordinates.count == 3)
            {
                earthquake.longitude = coordinates[0];
                earthquake.latitude = coordinates[1];
            }
            else
            {
                earthquake.longitude = 0;
                earthquake.latitude = 0;
            }

    		NSError *saveError;
    		[self.importContext save:&saveError];
    		NSAssert(saveError == nil, @"Save error: %@", saveError);
		}];
	}];
}

@end
