//
//  BrokenLineFlowLayout.h
//  BrokenLine
//
//  Created by 王长磊 on 2018/1/12.
//  Copyright © 2018年 base. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrokenLineFlowLayout : UICollectionViewFlowLayout

//标注Label的Y坐标
@property (nonatomic,strong) NSArray *markPointYArr;
//X轴的Y坐标
@property (nonatomic,assign) CGFloat xAxlePointY;


@end
