//
//  ESGetEarthquakesOperation.h
//  EarthShakes
//
//  Created by Nate Armstrong on 8/18/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

@import CoreData;

#import "ESGroupOperation.h"

@interface ESGetEarthquakesOperation : ESGroupOperation

- (instancetype)initWithContext:(NSManagedObjectContext *)context url:(NSURL *)url completionHandler:(void (^)())completion;

@end
