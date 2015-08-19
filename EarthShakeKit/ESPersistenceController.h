//
//  ESPersistenceController.h
//  NameGame
//
//  Created by Nate Armstrong on 8/18/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

@import Foundation;
@import CoreData;

typedef void (^InitCallbackBlock)(void);

@interface ESPersistenceController : NSObject

@property (strong, readonly) NSManagedObjectContext *managedObjectContext;

- (id)initWithCallback:(InitCallbackBlock)callback;
- (void)save;

@end
