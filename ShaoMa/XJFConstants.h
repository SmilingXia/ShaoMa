//
//  XJFConstants.h
//  ShaoMa
//
//  Created by xia on 2017/8/26.
//  Copyright © 2017年 cn.xia. All rights reserved.
//

#ifndef XJFConstants_h
#define XJFConstants_h

#define TabBar_H 60
#define APP_Frame_Height   [[UIScreen mainScreen] bounds].size.height
#define App_Frame_Width    [[UIScreen mainScreen] bounds].size.width
#define App_Delegate ((AppDelegate*)[[UIApplication sharedApplication]delegate])
#define App_RootCtr  [UIApplication sharedApplication].keyWindow.rootViewController
#define WEAK_SELF __weak typeof(self) weakSelf = self
#define STRONG_SELF __strong typeof(self) strongSelf = weakSelf
#define TXFont(FONTSIZE)  [UIFont systemFontOfSize:(FONTSIZE)]
#define TXColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define ZDYColor(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#endif /* XJFConstants_h */
