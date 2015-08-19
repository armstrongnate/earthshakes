//
//  ESURLSessionTaskOperation.h
//  EarthShakes
//
//  Created by Nate Armstrong on 8/18/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "ESGroupOperation.h"

@interface ESURLSessionTaskOperation : ESOperation

- (instancetype)initWithTask:(NSURLSessionTask *)task;

@end
