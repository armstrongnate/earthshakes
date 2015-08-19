//
//  ESParseEarthquakesOperation.h
//  EarthShakes
//
//  Created by Nate Armstrong on 8/18/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

@import CoreData;

#import "ESOperation.h"

@interface ESParseEarthquakesOperation : ESOperation

- (instancetype)initWithCacheFile:(NSURL *)cacheFile context:(NSManagedObjectContext *)context;

@end
