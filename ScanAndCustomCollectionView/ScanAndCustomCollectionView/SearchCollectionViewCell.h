//
//  SearchCollectionViewCell.h
//  NewWind
//
//  Created by 章丘研发 on 2018/4/10.
//  Copyright © 2018年 base. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceIP;
@property (weak, nonatomic) IBOutlet UILabel *deviceMac;
@property (weak, nonatomic) IBOutlet UIButton *configurationBtn;

@end
