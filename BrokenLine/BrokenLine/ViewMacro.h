//
//  ViewMacro.h
//  RemoteControl
//
//  Created by 王长磊 on 2017/11/28.
//  Copyright © 2017年 base. All rights reserved.
//

#ifndef ViewMacro_h
#define ViewMacro_h
#define scale_screen [UIScreen mainScreen].scale

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define ThemeColor RGBColor(18,150,219)

#define RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]

#define documentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

#endif /* ViewMacro_h */
