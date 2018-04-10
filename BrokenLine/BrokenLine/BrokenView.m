//
//  BrokenView.m
//  BrokenLine
//
//  Created by 王长磊 on 2018/1/6.
//  Copyright © 2018年 base. All rights reserved.
//

#import "BrokenView.h"
#import "ViewMacro.h"
#import "BrokenCollectionViewCell.h"
#import "BrokenMarkCollectionViewCell.h"
#import "BrokenLineFlowLayout.h"

@interface BrokenView()<UICollectionViewDelegate,UICollectionViewDataSource>

//绘制折线图
@property (nonatomic,strong) UIBezierPath *brokenPath;
@property (nonatomic, strong) CAShapeLayer *lineChartLayer;

//绘制标记点
@property (nonatomic,strong) UIBezierPath *markBrokenPath;
@property (nonatomic, strong) CAShapeLayer *markLineChartLayer;

//左右间距
@property (nonatomic,assign) CGFloat bounceX;
//上下间距
@property (nonatomic,assign) CGFloat bounceY;

@property (nonatomic,strong) BrokenLineFlowLayout *flowLayout;

@end



@implementation BrokenView

- (void)drawRect:(CGRect)rect{
    /*******画出坐标轴********/
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);

    CGContextMoveToPoint(context, _bounceX, _bounceY);
    CGContextAddLineToPoint(context, _bounceX, rect.size.height - _bounceY);
    CGContextAddLineToPoint(context,rect.size.width -  _bounceX, rect.size.height - _bounceY);
    CGContextStrokePath(context);
    
    [self createLabelY];
    [self setLineDash];
}


-(void)setLineType:(LineType)lineType{
    _lineType = lineType;
    _lineType==general?[self createZheXian]:[self createCircleZheXian];
}


-(id)initWithFrame:(CGRect)frame withBounceX:(CGFloat)bounceX withBounceY:(CGFloat)bounceY{
    self = [super initWithFrame:frame];
    
    if (self){
        
        _dataSourceY = [[NSMutableArray alloc]init];
        _dataSourceX = [[NSMutableArray alloc]init];
        
        _bounceX = bounceX;
        _bounceY = bounceY;
        
        _flowLayout = [[BrokenLineFlowLayout alloc]init];
        
        self.brokenCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(_bounceX, _bounceY, frame.size.width-_bounceX*2, frame.size.height-_bounceY) collectionViewLayout:_flowLayout];
        
        self.brokenCollectionView.delegate = self;
        self.brokenCollectionView.dataSource = self;
        self.brokenCollectionView.showsVerticalScrollIndicator = NO;
        [self.brokenCollectionView registerClass:[BrokenCollectionViewCell class] forCellWithReuseIdentifier:@"brokenCell"];
        [self.brokenCollectionView registerClass:[BrokenMarkCollectionViewCell class] forCellWithReuseIdentifier:@"markCell"];

        self.brokenCollectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.brokenCollectionView];
    }
    return self;
}

//设置item的宽高
-(void)setItemSize:(CGSize)itemSize{
    _itemSize = itemSize;
    _flowLayout.itemSize = itemSize;
    self.brokenCollectionView.contentInset = UIEdgeInsetsMake(0, _itemSize.width/2, 0, 0);
}

-(UIColor *)colorDashLine{
    if (!_colorDashLine){
        _colorDashLine = [UIColor whiteColor];
    }
    return _colorDashLine;
}

-(UIColor *)colorBrokenLine{
    if (!_colorBrokenLine){
        _colorBrokenLine = [UIColor yellowColor];
    }
    return _colorBrokenLine;
}

-(UIColor *)colorMarkPointFill{
    if (!_colorMarkPointFill){
        _colorMarkPointFill = [UIColor clearColor];
    }
    return _colorMarkPointFill;
}

-(UIColor *)colorMarkPointRound{
    if (!_colorMarkPointRound){
        _colorMarkPointRound = [UIColor blueColor];
    }
    return _colorMarkPointRound;
}

#pragma mark 创建y轴数据
- (void)createLabelY{
    CGFloat Ydivision = 6;
    for (NSInteger i = 0; i < Ydivision; i++) {
        UILabel * labelYdivision = [[UILabel alloc]initWithFrame:CGRectMake(0, ((self.frame.size.height - 2 * _bounceY)/Ydivision) *i + _bounceY - 21/2.0, _bounceX, 21)];
        
        labelYdivision.tag = 2000 + i;
        labelYdivision.textAlignment = NSTextAlignmentCenter;
        labelYdivision.text = [NSString stringWithFormat:@"%.0f",(Ydivision - i)*20];
        labelYdivision.font = [UIFont systemFontOfSize:11];
        labelYdivision.textColor = self.colorYAxleLabelText;
        [self addSubview:labelYdivision];
    }
}

//添加虚线
- (void)setLineDash{
    
    for (NSInteger i = 0;i < 6; i++ ) {
        CAShapeLayer * dashLayer = [CAShapeLayer layer];
        dashLayer.fillColor = [[UIColor clearColor] CGColor];
        // 默认设置路径宽度为0，使其在起始状态下不显示
        UILabel * label1 = (UILabel*)[self viewWithTag:2000 + i];//获取Y轴数据label的位置根据其位置画横虚线
        
        UIBezierPath * path = [[UIBezierPath alloc]init];
        path.lineWidth = 1.0;
        
        [path moveToPoint:CGPointMake( _bounceX, label1.center.y)];
        [path addLineToPoint:CGPointMake(self.frame.size.width - _bounceX,label1.center.y)];
        
        CGFloat dash[] = {5,5};
        [path setLineDash:dash count:2 phase:10];
        [self.colorDashLine setStroke];
        [path stroke];
        
        dashLayer.path = path.CGPath;
        [self.layer addSublayer:dashLayer];
    }
}



//绘制平滑折线图
-(void)createCircleZheXian{
    [self.brokenPath removeAllPoints];
    [self.markBrokenPath removeAllPoints];
    
    //使用四个点来求出前两个点之间的两个控制点,要添加 最前面一个点，最后面一个点
    NSMutableArray *tempArr = [[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%.1f",50.0], nil];
    [tempArr addObjectsFromArray:_dataSourceY];
    [tempArr addObject:[NSString stringWithFormat:@"%.1f",50.0]];
    
    //这个地方要使用tempArr.count-2 不能使用）_dataSourceY.count,因为_dataSourceY的数量在快速变化，可能在for循环当中tempArr会出现数组越界的情况 bug
    for (int i=0;i<tempArr.count-2;i++){
        CGPoint currentPoint = CGPointMake(25+i*50,(120 - [_dataSourceY[i] floatValue]) /120.0 * (self.frame.size.height - _bounceY*2));
        
        if (i==0){
            [_brokenPath moveToPoint:currentPoint];
        }
        else {
            CGPoint point1 = CGPointMake(25+(i-2)*50,(120 - [tempArr[i-1] floatValue]) /120.0 * (self.frame.size.height - _bounceY*2));
            CGPoint point2 = CGPointMake(25+(i-1)*50,(120 - [tempArr[i] floatValue]) /120.0 * (self.frame.size.height - _bounceY*2));
            CGPoint point3 = CGPointMake(25+(i)*50,(120 - [tempArr[i+1] floatValue]) /120.0 * (self.frame.size.height - _bounceY*2));
            CGPoint point4 = CGPointMake(25+(i+1)*50,(120 - [tempArr[i+2] floatValue]) /120.0 * (self.frame.size.height - _bounceY*2));
            [self getControlPointx0:point1.x andy0:point1.y x1:point2.x andy1:point2.y x2:point3.x andy2:point3.y x3:point4.x andy3:point4.y path:_brokenPath];
            
            //仅有三条数据
            
        }
        
        CGPoint markStartPoint = CGPointMake(25+(i)*50+5,(120 - [_dataSourceY[i] floatValue]) /120.0 * (self.frame.size.height - _bounceY*2));
        [self.markBrokenPath moveToPoint:markStartPoint];
        [self createMarkPoint:currentPoint];
    }
    
    
    
    self.brokenPath.lineCapStyle = kCGLineCapRound;
    self.brokenPath.lineJoinStyle = kCGLineJoinRound;
    self.lineChartLayer.path = self.brokenPath.CGPath;
    self.lineChartLayer.strokeColor = [UIColor yellowColor].CGColor;
    self.lineChartLayer.fillColor = [[UIColor clearColor] CGColor];
    self.lineChartLayer.lineCap = kCALineCapSquare;
    self.lineChartLayer.lineJoin = kCALineJoinBevel;
    
    [self.brokenCollectionView.layer addSublayer:self.lineChartLayer];
}



//绘制折线图
-(void)createZheXian{
        [self.brokenPath removeAllPoints];
    [self.markBrokenPath removeAllPoints];
    
    CGFloat space = _itemSize.width/2;
    [_brokenPath moveToPoint:CGPointMake(space,(120 - [_dataSourceY.firstObject  floatValue]) /120.0 * (self.frame.size.height - _bounceY*2))];
    
    for (int i = 0;i<_dataSourceY.count;i++){
       
        CGPoint point = CGPointMake(space+(i)*_itemSize.width,(120 - [_dataSourceY[i] floatValue]) /120.0 * (self.frame.size.height - _bounceY*2));
        
        [self.brokenPath addLineToPoint:point];
        
        CGPoint startPoint = CGPointMake(space+(i)*_itemSize.width+5,(120 - [_dataSourceY[i] floatValue]) /120.0 * (self.frame.size.height - _bounceY*2));
        
        [self.markBrokenPath moveToPoint:startPoint];
        
        [self createMarkPoint:point];
    }
    
    self.brokenPath.lineCapStyle = kCGLineCapRound;
    self.brokenPath.lineJoinStyle = kCGLineJoinRound;
    self.lineChartLayer.path = self.brokenPath.CGPath;
    self.lineChartLayer.strokeColor = self.colorBrokenLine.CGColor;
    self.lineChartLayer.fillColor = [[UIColor clearColor] CGColor];
    self.lineChartLayer.lineCap = kCALineCapSquare;
    self.lineChartLayer.lineJoin = kCALineJoinBevel;
    
    [self.brokenCollectionView.layer addSublayer:self.lineChartLayer];
    
}

//获取控制点
- (void)getControlPointx0:(CGFloat)x0 andy0:(CGFloat)y0
                       x1:(CGFloat)x1 andy1:(CGFloat)y1
                       x2:(CGFloat)x2 andy2:(CGFloat)y2
                       x3:(CGFloat)x3 andy3:(CGFloat)y3
                     path:(UIBezierPath*) path{
    CGFloat smooth_value =0.6;
    CGFloat ctrl1_x;
    CGFloat ctrl1_y;
    CGFloat ctrl2_x;
    CGFloat ctrl2_y;
    CGFloat xc1 = (x0 + x1) /2.0;
    CGFloat yc1 = (y0 + y1) /2.0;
    CGFloat xc2 = (x1 + x2) /2.0;
    CGFloat yc2 = (y1 + y2) /2.0;
    CGFloat xc3 = (x2 + x3) /2.0;
    CGFloat yc3 = (y2 + y3) /2.0;
    CGFloat len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
    CGFloat len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
    CGFloat len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2));
    CGFloat k1 = len1 / (len1 + len2);
    CGFloat k2 = len2 / (len2 + len3);
    CGFloat xm1 = xc1 + (xc2 - xc1) * k1;
    CGFloat ym1 = yc1 + (yc2 - yc1) * k1;
    CGFloat xm2 = xc2 + (xc3 - xc2) * k2;
    CGFloat ym2 = yc2 + (yc3 - yc2) * k2;
    ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + x1 - xm1;
    ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + y1 - ym1;
    ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + x2 - xm2;
    ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + y2 - ym2;
    [path addCurveToPoint:CGPointMake(x2, y2) controlPoint1:CGPointMake(ctrl1_x, ctrl1_y) controlPoint2:CGPointMake(ctrl2_x, ctrl2_y)];
}

//创建标记点
-(void)createMarkPoint:(CGPoint)point{
    [self.markBrokenPath addArcWithCenter:point radius:5 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    self.markBrokenPath.lineCapStyle = kCGLineCapRound;
    self.markBrokenPath.lineJoinStyle = kCGLineJoinRound;
    self.markLineChartLayer.path = self.markBrokenPath.CGPath;
    self.markLineChartLayer.strokeColor = self.colorMarkPointRound.CGColor;
    self.markLineChartLayer.fillColor = [self.colorMarkPointFill CGColor];
    self.markLineChartLayer.lineCap = kCALineCapSquare;
    self.markLineChartLayer.lineJoin = kCALineJoinBevel;
    
    [self.brokenCollectionView.layer addSublayer:self.markLineChartLayer];
}


-(UIBezierPath *)brokenPath{
    if (!_brokenPath){
        _brokenPath = [[UIBezierPath alloc]init];
    }
    return _brokenPath;
}

-(CAShapeLayer *)lineChartLayer{
    if (!_lineChartLayer){
        _lineChartLayer = [CAShapeLayer layer];
    }
    return _lineChartLayer;
}

-(UIBezierPath *)markBrokenPath{
    if (!_markBrokenPath){
        _markBrokenPath = [[UIBezierPath alloc]init];
    }
    return _markBrokenPath;
}

-(CAShapeLayer *)markLineChartLayer{
    if (!_markLineChartLayer){
        _markLineChartLayer = [CAShapeLayer layer];
    }
    return _markLineChartLayer;
}

-(void)setDataSourceY:(NSMutableArray *)dataSourceY{
    _dataSourceY = dataSourceY;
    
    _lineType==general?[self createZheXian]:[self createCircleZheXian];
    NSInteger sections = [self.brokenCollectionView numberOfSections];

    
    @try {
        if (sections<self.dataSourceY.count){
            [self.brokenCollectionView performBatchUpdates:^{
                //            NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
                NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc]init];
                
                for (NSUInteger i = sections; i < self.dataSourceY.count ; i++)
                {
                    [indexSet addIndex:i];
                }
                [self.brokenCollectionView insertSections:indexSet];
            } completion:^(BOOL finished) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:sections];
                
                [self.brokenCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }];
        }
        else {
            [self.brokenCollectionView reloadData];
            if (sections>0){
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:sections-1];
                [self.brokenCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
        }
    }
    @catch (NSException *exception){
        NSLog(@"捕获到异常");
        NSLog(@"%s\n%@",__FUNCTION__,exception);
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    _flowLayout.xAxlePointY = self.frame.size.height-_bounceY*2-5; //减5是横坐标小竖线的高度
    
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSString *yDataStr in _dataSourceY){
        CGFloat yData = [yDataStr floatValue];
        CGFloat markPointY = (120 - yData) /120.0 * (self.frame.size.height - _bounceY*2);
        [tempArr addObject:[NSString stringWithFormat:@"%f",markPointY]];
    }
    _flowLayout.markPointYArr = tempArr;
    
    return _dataSourceY.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item==0){
        BrokenMarkCollectionViewCell *markCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"markCell" forIndexPath:indexPath];

        markCell.yDataLabel.text = self.dataSourceY[indexPath.section];
        markCell.yDataLabel.textColor = self.colorMarkLabelText;
        return markCell;
    }
    else {
        BrokenCollectionViewCell *brokenCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"brokenCell" forIndexPath:indexPath];
        brokenCell.xDataLabel.text = self.dataSourceX[indexPath.section];
        brokenCell.xDataLabel.textColor = self.colorXAxleLabelText;
        return brokenCell;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
