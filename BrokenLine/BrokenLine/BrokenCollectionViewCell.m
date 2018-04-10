//
//  BrokenCollectionViewCell.m
//  BrokenLine
//
//  Created by 王长磊 on 2018/1/6.
//  Copyright © 2018年 base. All rights reserved.
//

#import "BrokenCollectionViewCell.h"

@implementation BrokenCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor clearColor];
        self.xDataLabel = [[UILabel alloc]init];
        self.xDataLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.xDataLabel];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.xDataLabel.frame = CGRectMake(0, 5, self.frame.size.width, self.frame.size.height-5);
}

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    CGContextMoveToPoint(context, rect.size.width/2, 0);
    CGContextAddLineToPoint(context,rect.size.width/2, 5);
    CGContextStrokePath(context);

}

@end
