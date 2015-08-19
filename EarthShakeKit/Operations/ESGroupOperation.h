//
//  ESGroupOperation.h
//  EarthShakes
//
//  Created by Nate Armstrong on 8/18/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "ESOperation.h"

@interface ESGroupOperation : ESOperation

- (instancetype)initWithOperations:(NSArray *)operations;
- (void)addOperation:(NSOperation *)operation;

@end
