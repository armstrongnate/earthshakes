//
//  ESPersistenceController.m
//  NameGame
//
//  Created by Nate Armstrong on 8/18/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "ESPersistenceController.h"

@interface ESPersistenceController()

@property (strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (strong) NSManagedObjectContext *privateContext;
@property (copy) InitCallbackBlock initCallback;

- (void)initializeCoreData;

@end

@implementation ESPersistenceController

- (id)initWithCallback:(InitCallbackBlock)callback
{
	if (!(self = [super init])) return nil;

	[self setInitCallback:callback];
	[self initializeCoreData];

	return self;
}

- (void)initializeCoreData
{
	if ([self managedObjectContext]) return;

	NSURL *modelURL = [[NSBundle bundleForClass:[ESPersistenceController class]] URLForResource:@"DataModel" withExtension:@"momd"];
	NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];

	[self setManagedObjectContext:[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType]];

	[self setPrivateContext:[[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType]];
	[[self privateContext] setPersistentStoreCoordinator:coordinator];
	[[self managedObjectContext] setParentContext:[self privateContext]];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		NSPersistentStoreCoordinator *psc = [[self privateContext] persistentStoreCoordinator];
		NSMutableDictionary *options = [NSMutableDictionary dictionary];
		options[NSMigratePersistentStoresAutomaticallyOption] = @YES;
		options[NSInferMappingModelAutomaticallyOption] = @YES;
		options[NSSQLitePragmasOption] = @{ @"journal_mode":@"DELETE" };

		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
		NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"DataModel.sqlite"];

		NSError *error = nil;
		[psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
		if (![self initCallback]) return;

		dispatch_sync(dispatch_get_main_queue(), ^{
			[self initCallback]();
		});
	});
}

- (void)save;
{
	if (![[self privateContext] hasChanges] && ![[self managedObjectContext] hasChanges]) return;

	[[self managedObjectContext] performBlockAndWait:^{
		NSError *error = nil;

		[[self managedObjectContext] save:&error];

		[[self privateContext] performBlock:^{
			NSError *privateError = nil;
			[[self privateContext] save:&privateError];
		}];
	}];
}

@end
