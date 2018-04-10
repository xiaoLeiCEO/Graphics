//
//  BrokenMarkCollectionViewCell.m
//  BrokenLine
//
//  Created by 王长磊 on 2018/1/12.
//  Copyright © 2018年 base. All rights reserved.
//

#import "BrokenMarkCollectionViewCell.h"

@implementation BrokenMarkCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.yDataLabel = [[UILabel alloc]init];
        self.yDataLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.yDataLabel];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.yDataLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
