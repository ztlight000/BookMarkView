//
//  AdaptationTool.h
//  MicroviewProject
//
//  Created by 张涛 on 2017/12/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 判断是否是iPhone X
#ifndef iPhoneX
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

// iOS11
#ifndef kiOS11
#define kiOS11 @available(iOS 11.0, *)
#endif

// 导航栏高度
#ifndef kCustomNaviHeight
#define kCustomNaviHeight 44.0f
#endif

// iOS11之前的状态栏高度
#ifndef kPrimaryStatusBarHeight
#define kPrimaryStatusBarHeight 20.0f
#endif

/**
 获取safeAreaInsets

 @param view vc.view
 @return safeAreaInsets
 */
static inline UIEdgeInsets XCSafeAreaInset(UIView *view) {
    if (kiOS11) {
        return view.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

/**
 * 用以获取自定义导航栏高度
 * 在有状态栏&&自定义导航栏的环境下使用

 @param view vc.view
 @return 导航栏高度
 */
static inline CGFloat XCCustomNaviHeight(UIView *view) {
    UIEdgeInsets inset = XCSafeAreaInset(view);
    CGFloat height = kCustomNaviHeight;
    height += inset.top  > 0 ? inset.top : kPrimaryStatusBarHeight;
    return height;
}

/**
 用以获取状态栏的高度

 @param view vc.view
 @return 状态栏的高度
 */
static inline CGFloat XCStatusBarHeight(UIView *view) {
    UIEdgeInsets inset = XCSafeAreaInset(view);
    CGFloat inset_top = inset.top;
    return inset_top  > 0 ? inset_top : kPrimaryStatusBarHeight;
}

/**
 * 可以理解为自定义导航栏增加的高度，也可以理解为状态栏增加的高度
 * 在有状态栏&&自定义导航栏的环境下使用

 @param view vc.view
 @return 获取导航栏应增加的高度
 */
static inline CGFloat XCStatusBarMetaHeight(UIView *view) {
    CGFloat statusBarHeight = XCStatusBarHeight(view);
    return statusBarHeight - kPrimaryStatusBarHeight;
}

/**
 用以返回底部view居vc.view的高度
 
 @param view vc.view
 @return bottom
 */
static inline CGFloat XCHomeBarBottom(UIView *view) {
    UIEdgeInsets inset = XCSafeAreaInset(view);
    return inset.bottom;
}


#pragma mark - 下面为写死高度的宏。优先使用上面的动态获取safeArea的值，如果特定环境下上面方法不能使用，可以使用下面的宏。
// 状态栏增加的高度
#ifndef kStatusBarAddHeight
#define kStatusBarAddHeight (iPhoneX ? 24.f : 0.f)
#endif

// 适配iPhone X 状态栏高度
#ifndef kStatusBarHeight
#define kStatusBarHeight ((kStatusBarAddHeight) + (kPrimaryStatusBarHeight))
#endif

//iphoneX的状态栏，如果有状态栏就多44否则就是0
#ifndef kStatusBarCustomHeight

#define kStatusBarCustomHeight (iPhoneX ? 44.f : 0.f)

#endif


//适配iPhone X 导航栏高度
#ifndef kNaviHeight
#define kNaviHeight ((kStatusBarHeight) + (kCustomNaviHeight))
#endif

//适配iPhone X 竖屏距离底部的距离
#ifndef kHomeBarBottom
#define kHomeBarBottom (iPhoneX ? 34.f : 0.f)
#endif

//适配iPhone X 横屏距离底部的距离
#ifndef kHomeBarBottom_horizontal
#define kHomeBarBottom_horizontal (iPhoneX ? 21.f : 0.f)
#endif


//适配iPhone X 距离左右两边的距离
#ifndef kStatusBarLeftRight
#define kStatusBarLeftRight (iPhoneX ? 44.f : 0.f)
#endif


// 之前的Tabbar高度
#ifndef kPrimaryTabbarHeight
#define kPrimaryTabbarHeight 49.f
#endif

//适配iPhone X Tabbar高度
#ifndef kTabbarHeight
#define kTabbarHeight ((kPrimaryTabbarHeight) + (kHomeBarBottom))
#endif

NS_ASSUME_NONNULL_END
