//
//  SectorView.m
//  RemoteControl
//
//  Created by 章丘研发 on 2017/12/18.
//  Copyright © 2017年 base. All rights reserved.
//

#import "SectorView.h"

@interface SectorView()

@property (nonatomic,strong) CAGradientLayer *gradientLayer;
@property (nonatomic,strong) CAShapeLayer *sectorLayer;
@property (nonatomic,strong) UIBezierPath *bezierPath;

@end

@implementation SectorView


-(CAGradientLayer *)gradientLayer{
    if (!_gradientLayer){
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = [NSArray arrayWithObjects:
                                 (id)[UIColor colorWithRed:0 green:1 blue:0 alpha:0.0].CGColor,
                                 (id)[UIColor colorWithRed:0 green:1 blue:0 alpha:0.5].CGColor,
                                 (id)[UIColor colorWithRed:0 green:1 blue:0 alpha:1].CGColor, nil];
        _gradientLayer.locations = @[@0.5,@0.6];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1);
        [_gradientLayer setMask:self.sectorLayer];
        [self.layer addSublayer:_gradientLayer];
    }
    return _gradientLayer;
}

-(CAShapeLayer *)sectorLayer{
    if(!_sectorLayer){
        CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidX(self.bounds));
        _bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:self.bounds.size.width/2 startAngle:0 endAngle:M_PI/4 clockwise:YES];
        [_bezierPath addLineToPoint:center];
        _sectorLayer = [CAShapeLayer layer];
        _sectorLayer.path = _bezierPath.CGPath;
        [self.layer addSublayer:_sectorLayer];
    }
    return _sectorLayer;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
}

@end
