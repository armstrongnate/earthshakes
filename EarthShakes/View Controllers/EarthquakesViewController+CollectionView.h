//
//  EarthquakesViewController+TableViewDataSource.h
//  EarthShakes
//
//  Created by Nate Armstrong on 8/19/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "EarthquakesViewController.h"

extern NSString * const EarthquakeCellReuseIdentifier;

@interface EarthquakesViewController (CollectionView) <UICollectionViewDataSource, UICollectionViewDelegate>

@end
