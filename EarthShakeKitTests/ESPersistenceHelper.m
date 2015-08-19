//
//  PersistenceHelper.m
//  NameGame
//
//  Created by Nate Armstrong on 8/13/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "ESPersistenceHelper.h"
#import "ESPersistenceController.h"

@implementation ESPersistenceHelper

- (instancetype)init
{
	if (!(self = [super init])) return nil;
	[self initializeCoreData];
	return self;
}

- (void)initializeCoreData
{
	NSURL *modelURL = [[NSBundle bundleForClass:[ESPersistenceController class]] URLForResource:@"DataModel" withExtension:@"momd"];
	NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
	NSError *error = nil;
	if (![coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error])
	{
		NSLog(@"Error: %@", error);
	}
	[self setContext:[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType]];
	self.context.persistentStoreCoordinator = coordinator;
}

@end
