//
//  EarthquakeTableViewCell.m
//  EarthShakes
//
//  Created by Nate Armstrong on 8/19/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

#import "EarthquakeCollectionViewCell.h"
#import "UIColor+MagnitudeColors.h"

@interface EarthquakeCollectionViewCell ()

@property (nonatomic, strong) UILabel *magnitudeLabel;
@property (nonatomic, strong) UILabel *timestampLabel;
@property (nonatomic, strong) UILabel *placeLabel;

@end

@implementation EarthquakeCollectionViewCell

- (instancetype)init
{
    if (!(self = [super init])) return nil;
    [self setup];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    [self setup];
    return self;
}

- (void)setup
{
    self.layer.borderColor = [UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1.0].CGColor;
    self.layer.borderWidth = 0;
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.magnitudeLabel];
    [self.contentView addSubview:self.placeLabel];
}

- (void)setEarthquake:(ESEarthquake *)earthquake
{
    _earthquake = earthquake;
    EarthquakeMagnitude magnitude = [earthquake magnitudeCategory];

    self.backgroundColor = [UIColor colorForEarthquakeMagnitude:magnitude];
    self.magnitudeLabel.text = [earthquake.magnitude stringValue];
    self.placeLabel.text = earthquake.place;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.layer.borderWidth = selected ? 4 : 0;
}

- (UILabel *)magnitudeLabel
{
    if (!_magnitudeLabel)
    {
        _magnitudeLabel = [[UILabel alloc] init];
        [_magnitudeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _magnitudeLabel.font = [UIFont boldSystemFontOfSize:60];
        _magnitudeLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        _magnitudeLabel.adjustsFontSizeToFitWidth = YES;
        _magnitudeLabel.minimumScaleFactor = 0.5f;
        _magnitudeLabel.textAlignment = NSTextAlignmentCenter;
    }

    return _magnitudeLabel;
}

- (UILabel *)placeLabel
{
    if (!_placeLabel)
    {
        _placeLabel = [[UILabel alloc] init];
        [_placeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _placeLabel.font = [UIFont boldSystemFontOfSize:11];
        _placeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeLabel.textAlignment = NSTextAlignmentCenter;
        _placeLabel.numberOfLines = 0;
        _placeLabel.textColor = [UIColor whiteColor];
    }
    return _placeLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    [self layoutMagnitude];
    [self layoutPlace];
}

- (void)layoutMagnitude
{
    UILabel *magnitude = self.magnitudeLabel;

    CGFloat const margin = 2;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:magnitude attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:margin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:magnitude attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-margin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:magnitude attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:margin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:magnitude attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:-margin]];
}

- (void)layoutPlace
{
    UILabel *place = self.placeLabel;

    CGFloat const margin = 4;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:place attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:margin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:place attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-margin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:place attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:margin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:place attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:-margin]];
}

@end
