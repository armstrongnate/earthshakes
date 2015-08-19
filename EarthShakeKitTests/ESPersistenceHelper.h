//
//  PersistenceHelper.h
//  NameGame
//
//  Created by Nate Armstrong on 8/13/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface ESPersistenceHelper : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;

@end
