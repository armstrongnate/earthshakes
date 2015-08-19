//
//  ESGroupOperation.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/18/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "ESGroupOperation.h"

@interface ESGroupOperation ()

@property (nonatomic, strong) NSOperationQueue *internalQueue;

@end

@implementation ESGroupOperation

- (NSOperationQueue *)internalQueue
{
	if (!_internalQueue)
	{
		_internalQueue = [NSOperationQueue new];
	}

	return _internalQueue;
}

- (instancetype)initWithOperations:(NSArray *)operations
{
	if (!(self = [super init])) return nil;

	self.internalQueue.suspended = YES;
	[operations enumerateObjectsUsingBlock:^(NSOperation *operation, NSUInteger idx, BOOL *stop) {
		[self addOperation:operation];
	}];

	return self;
}

- (void)addOperation:(NSOperation *)operation
{
	[self.internalQueue addOperation:operation];
}

- (void)execute
{
	self.internalQueue.suspended = NO;
}

@end
