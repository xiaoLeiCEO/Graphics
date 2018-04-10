//
//  BrokenLineFlowLayout.m
//  BrokenLine
//
//  Created by 王长磊 on 2018/1/12.
//  Copyright © 2018年 base. All rights reserved.
//

#import "BrokenLineFlowLayout.h"

@implementation BrokenLineFlowLayout

-(void)prepareLayout{
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frame = attributes.frame;
    if (indexPath.item==0){
        frame.origin.y = [_markPointYArr[indexPath.section] floatValue];
    }
    else {
        frame.origin.y = _xAxlePointY;
    }
    attributes.frame = frame;

    return attributes;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attributes in arr){
        CGRect frame = attributes.frame;
        if (attributes.indexPath.item==0){
            frame.origin.y = [_markPointYArr[attributes.indexPath.section] floatValue];
        }
        else{
            frame.origin.y = _xAxlePointY;
        }
        attributes.frame = frame;
    }
    return arr;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}



@end
