//
//  RadarView.m
//  RemoteControl
//
//  Created by 章丘研发 on 2017/12/18.
//  Copyright © 2017年 base. All rights reserved.
//

#import "RadarView.h"
#import "SectorView.h"


@interface RadarView()

@property (nonatomic,strong) SectorView *sectorView;

@end

@implementation RadarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        

        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _sectorView = [[SectorView alloc]init];
//        _sectorView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
        [self addSubview:_sectorView];
        
        
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: 2 *M_PI ];
        rotationAnimation.duration = 2;
        rotationAnimation.cumulative = YES;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.repeatCount = MAXFLOAT;
        rotationAnimation.fillMode = kCAFillModeForwards;
        [_sectorView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
    return self;
}


-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat radius = rect.size.width / 8.0;
    for (int i=0;i<5;i++) {
//        CGFloat red, green, blue, alpha;
//        [color getRed:&red green:&green blue:&blue alpha:&alpha];
//        CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
        CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextAddArc(context, rect.size.width / 2.0, rect.size.width / 2.0, radius, 0, 2* M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
        radius += 20;
    }
}


-(void)layoutSubviews{
    [super layoutSubviews];
    _sectorView.frame = CGRectMake(0, 0, (self.bounds.size.width/8+20*4)*2, (self.bounds.size.width/8+20*4)*2);
    _sectorView.center = CGPointMake(CGRectGetMidX(self.bounds), self.bounds.size.width/2);
}





@end
