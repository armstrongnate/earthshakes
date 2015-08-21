//
//  EarthquakeBehavior.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/19/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "EarthquakeBehavior.h"

CGFloat const WiggleRoom = 10.0;

@implementation EarthquakeBehavior

- (instancetype)initWithItems:(NSArray *)items
{
    if (!(self = [super init])) return nil;

    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:items];
    [collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(0, -WiggleRoom, 0, -WiggleRoom)];
    [self addChildBehavior:collisionBehavior];

    UIDynamicItemBehavior *buildingBehavior = [[UIDynamicItemBehavior alloc] initWithItems:items];
    buildingBehavior.elasticity = 1.0;
    buildingBehavior.friction = 0.0;
    buildingBehavior.resistance = 4.0;
    buildingBehavior.allowsRotation = NO;
    [self addChildBehavior:buildingBehavior];

    [items enumerateObjectsUsingBlock:^(UIView *item, NSUInteger idx, BOOL *stop) {
        UIAttachmentBehavior *anchorBehavior = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:item.center];
        anchorBehavior.damping = 2.0;
        [self addChildBehavior:anchorBehavior];
    }];

    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:items mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.pushDirection = CGVectorMake(20.0, 0.0); // TODO: dynamic x value
    [self addChildBehavior:pushBehavior];

    return self;
}

@end
