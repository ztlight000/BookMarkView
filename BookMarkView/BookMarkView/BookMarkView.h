//
//  BookMarkView.h
//  BookMarkView
//
//  Created by 张涛 on 2018/3/28.
//  Copyright © 2018年 apple. All rights reserved.
//

/*说明
 1.书签栏分为两部份，第一部分是顶部标签栏，第二部分是内容承载体
 2.顶部标签栏和内容承载体均为CollectionView
 */

#import <UIKit/UIKit.h>

@class BookMarkView;
@class BookMarkHeadItemCell;
@class BookMarkContentItemCell;


//BookMarkViewDelegate
@protocol BookMarkViewDelegate <NSObject>

@optional

//头部->非选中
- (void)bookMarkView:(BookMarkView *)bookmarkView cellForIndexPath:(NSIndexPath *)indexPath configNormalBookMarkHeadItemCell:(BookMarkHeadItemCell *)bookMarkHeadItemCell;

//头部->选中
- (void)bookMarkView:(BookMarkView *)bookmarkView cellForIndexPath:(NSIndexPath *)indexPath configSelectBookMarkHeadItemCell:(BookMarkHeadItemCell *)bookMarkHeadItemCell;

//头部size
- (CGSize)bookMarkView:(BookMarkView *)bookmarkView itemSizeForIndexPath:(NSIndexPath *)indexPath;

//内容size
- (CGSize)bookMarkView:(BookMarkView *)bookmarkView contentSizeForIndexPath:(NSIndexPath *)indexPath;

//头部选中的回调
- (void)bookMarkView:(BookMarkView *)bookmarkView didSelectIndexPath:(NSIndexPath *)indexPath;

//重复点击同一个的事件
- (void)bookMarkView:(BookMarkView *)bookmarkView didSelectSameIndexPath:(NSIndexPath *)indexPath;

//点击edit的事件
- (void)bookMarkViewEditBookItem:(BookMarkView *)bookmarkView;

@end


//BookMarkViewDataSource
@protocol BookMarkViewDataSource <NSObject>

@required

//头部的数据源
- (NSMutableArray *)bookMarkViewHeaderItems:(BookMarkView *)bookmarkView;

//内容数据源
- (NSMutableArray *)bookMarkViewContentViewItems:(BookMarkView *)bookmarkView;

//内容的设置
- (void)bookMarkView:(BookMarkView *)bookmarkView cellForIndexPath:(NSIndexPath *)indexPath configBookContentItemCell:(BookMarkContentItemCell *)bookmarkContentCell;

@end


//当滑动时，调用的block
typedef void(^contentDidEndScrool)(NSInteger index);

//书签
@interface BookMarkView : UIView

@property (nonatomic, weak) id<BookMarkViewDelegate> delegate;

@property (nonatomic, weak) id<BookMarkViewDataSource> datasource;

@property (nonatomic, weak) UICollectionView *bookHeadCollectionView;

@property (nonatomic, weak) UICollectionView *bookContentCollectionView;


@property (nonatomic, assign) NSInteger currentIndex; // 当前选中的位置

@property (nonatomic, assign) NSInteger beginCurrntIndex;  //加载前 开始要显示的位置

@property (nonatomic, assign) NSInteger middleCurrentIndex;//加载后 中间过程要显示的位置


@property (nonatomic, assign) BOOL isCanScroll; //是否可以滑动

@property (nonatomic, assign) BOOL isAnimalSlider; //是否使用动画标示线

@property (nonatomic, strong) UIColor *sliderColor;

@property (nonatomic, assign) CGFloat bookHeadCellWidth; //头部cell的宽度

@property (nonatomic, weak) UIButton *bookItemEditButton; //书签的编辑按钮

@property (nonatomic, copy) contentDidEndScrool scroolBlock;


//刷新处理
- (void)reloadData;

//编辑操作（待实现）
//删除
//- (void)deleteItemWithIndex:(NSInteger *)index;

//交换
//- (void)exchangeItemFormIndex:(NSInteger)formIndex toIndex:(NSInteger)toIndex;

//添加
//- (void)addItemWithHeadItem:(NSObject *)headItem withContentItem:(NSObject *)contentItem;

@end



//顶部:顶部可能是图，也可能是文字
@interface BookMarkHeadItemCell : UICollectionViewCell

@property (nonatomic, weak) UILabel *titleLable; //展示文字

@property (nonatomic, weak) UIImageView *imageView; //展示图片

@property (nonatomic, weak) UIView *sliderView; //底部标示线

@end



//内容体
@interface BookMarkContentItemCell : UICollectionViewCell

@property (nonatomic, weak) UIView *globalView;

@end






