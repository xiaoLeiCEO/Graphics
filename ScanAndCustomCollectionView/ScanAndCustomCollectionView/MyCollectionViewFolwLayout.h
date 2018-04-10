//
//  MyCollectionViewFolwLayout.h
//  RemoteControl
//
//  Created by 章丘研发 on 2017/12/18.
//  Copyright © 2017年 base. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JSCarouselSlideIndexBlock)(NSInteger index);

@interface MyCollectionViewFolwLayout : UICollectionViewFlowLayout

@property (nonatomic,assign) NSInteger visibleCount;

@property (nonatomic, copy) JSCarouselSlideIndexBlock carouselSlideIndexBlock;

@end
