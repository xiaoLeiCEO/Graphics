//
//  BrokenView.h
//  BrokenLine
//
//  Created by 王长磊 on 2018/1/6.
//  Copyright © 2018年 base. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LineType) {
    general,
    circle
};

@interface BrokenView : UIView

@property (nonatomic,strong) UICollectionView *brokenCollectionView;

//构造方法，bounceX左右间距，bounceY上下间距
-(instancetype)initWithFrame:(CGRect)frame withBounceX:(CGFloat)bounceX withBounceY:(CGFloat)bounceY;

//数据源
@property (nonatomic,strong) NSMutableArray *dataSourceY;
@property (nonatomic,strong) NSMutableArray *dataSourceX;


//颜色设置
@property (nonatomic,strong) UIColor *colorYAxleLabelText;//Y轴Label字体颜色
@property (nonatomic,strong) UIColor *colorXAxleLabelText;//X轴Label字体颜色
@property (nonatomic,strong) UIColor *colorMarkLabelText;//标记Label字体颜色

@property (nonatomic,strong) UIColor *colorDashLine;//虚线颜色
@property (nonatomic,strong) UIColor *colorBrokenLine;//折线颜色
@property (nonatomic,strong) UIColor *colorMarkPointRound;//标记点圆圈颜色
@property (nonatomic,strong) UIColor *colorMarkPointFill;//标记点填充颜色

////item的大小
@property (nonatomic,assign) CGSize itemSize;


@property (nonatomic,assign) LineType lineType;


@end
