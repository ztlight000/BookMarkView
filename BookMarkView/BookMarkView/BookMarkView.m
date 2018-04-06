//
//  BookMarkView.m
//  BookMarkView
//
//  Created by 张涛 on 2018/3/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BookMarkView.h"
#import "Masonry.h"
#import "AdaptationTool.h"

#define WeakSelf typeof(self) __weak weakSelf = self;

static NSString *BookMarkHeaderItemCellIndentify = @"BookMarkHeaderItemCellIndentify";

static NSString *BookMarkContentItemCellIndnetify = @"BookMarkContentItemCellIndnetify";


#define BookmarkHeadItemViewTag 1000

#define BookmarkItemContentViewTag 1001

@interface BookMarkView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    
    NSInteger _tempCurrentIndex;
    
}

//头部标签栏的数据源
@property (nonatomic, strong) NSMutableArray *bookHeadItemsArray;

//内容的数据源
@property (nonatomic, strong) NSMutableArray *bookContentItemsArray;

//底部标示线
@property (nonatomic, weak) UIView *sliderView;

//记住选中的cell
@property (nonatomic, weak) BookMarkHeadItemCell *currentheadCell;

@end

@implementation BookMarkView

#pragma mark - 基本设置
- (void)setIsCanScroll:(BOOL)isCanScroll {
    
    self.bookHeadCollectionView.scrollEnabled = isCanScroll;
    
    self.bookContentCollectionView.scrollEnabled = isCanScroll;
    
}


- (void)setBeginCurrntIndex:(NSInteger)beginCurrntIndex {
    
    _beginCurrntIndex = beginCurrntIndex;
    
}


- (void)setMiddleCurrentIndex:(NSInteger)middleCurrentIndex {
    
    _middleCurrentIndex = middleCurrentIndex;
    
    [self setSelectIndex:_middleCurrentIndex];
    
}


- (NSInteger)currentIndex {
    
    return _tempCurrentIndex;
    
}


//底部动画标示线
- (void)setIsAnimalSlider:(BOOL)isAnimalSlider {
    
    _isAnimalSlider = isAnimalSlider;
    
    if (isAnimalSlider) {
        
        //底部标示线
        UIView *sliderView = [[UIView alloc] initWithFrame:CGRectZero];
        
        sliderView.backgroundColor = _sliderColor;
        
        [sliderView.layer setCornerRadius:1];
        
        [self.bookHeadCollectionView addSubview:sliderView];
        
        _sliderView = sliderView;

    }
    
}


//设置标示线颜色
-(void)setSliderColor:(UIColor *)sliderColor {
    
    _sliderColor = sliderColor;
    
    _sliderView.backgroundColor = sliderColor;
    
}


//编辑按钮
- (void)setBookItemEditButton:(UIButton *)bookItemEditButton {
    
    if (_bookItemEditButton) {
        
        [_bookItemEditButton removeFromSuperview];
        
    }
    
    _bookItemEditButton = bookItemEditButton;
    
    [self addSubview:_bookItemEditButton];
    
    [_bookItemEditButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setNeedsLayout];
    
}


- (void)editButtonClick:(UIButton*)button {
    
    if ([self.delegate respondsToSelector:@selector(bookMarkViewEditBookItem:)]) {
        
        [self.delegate bookMarkViewEditBookItem:self];
        
    }
    
}


#pragma mark - 获取数据源
- (void)reloadData {
    
    //获取头部的数组
    self.bookHeadItemsArray = [self.datasource bookMarkViewHeaderItems:self];
    
    //获取内容体的数组
    self.bookContentItemsArray = [self.datasource bookMarkViewContentViewItems:self];
    
    //改变每个的frame
//    [self changeContentFrame];
    
    [self.bookHeadCollectionView reloadData];
    
    [self.bookContentCollectionView reloadData];
    
    if (_beginCurrntIndex != 0) {
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self setSelectIndex:_beginCurrntIndex];
            
        });

    }
    
}


#pragma mark - 设置当前的是第几个标签
- (void)setSelectIndex:(NSInteger)currentIndex {
    
    if (_tempCurrentIndex == currentIndex) {
        
        return;
    }
    
    if (_bookHeadItemsArray.count > 0 && _bookContentItemsArray.count > 0) {
        
        [self.bookContentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
    }
    
}

#pragma mark - 设置内容区cell中view的frame
- (void)changeContentFrame {
    
    for (id item in self.bookContentItemsArray) {
        
        if ([item isKindOfClass:[UIViewController class]]) {
            
            UIViewController *vc = (UIViewController *)item;
            
            vc.view.frame = CGRectMake(0, 0, self.bookContentCollectionView.frame.size.width, self.bookContentCollectionView.frame.size.height);
            
            if ([vc isKindOfClass:[UITableViewController class]]) {
                
                UITableViewController *tableVC = (UITableViewController *)vc;
                
                tableVC.tableView.frame = CGRectMake(0, 0, tableVC.tableView.frame.size.width, _bookContentCollectionView.frame.size.height);
                
                
            } else if ([vc isKindOfClass:[UICollectionViewController class]]){
                
                UICollectionViewController *collectionVC = (UICollectionViewController *)vc;
                
                collectionVC.collectionView.frame = CGRectMake(collectionVC.collectionView.frame.origin.x, collectionVC.collectionView.frame.origin.y, collectionVC.collectionView.frame.size.width, _bookContentCollectionView.frame.size.height);
                
            }
            
        } else if ([item isKindOfClass:[UIView class]]){
            
            UIView *view = (UIView *)item;
            
            view.frame = CGRectMake(0, 0, _bookContentCollectionView.frame.size.width, _bookContentCollectionView.frame.size.height);
            
        }
        
    }
    
}

#pragma mark - 调整因滑动过快导致的headCell未选中问题
- (void)adjustHeadCellSelected {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_tempCurrentIndex inSection:0];
        
        BookMarkHeadItemCell *cell = (BookMarkHeadItemCell *)[self.bookHeadCollectionView cellForItemAtIndexPath:indexPath];
        
        if (cell != _currentheadCell) {
            
            _currentheadCell = cell;
            
            [cell setSelected:YES];
            
            //做选中的效果处理
            if ([self.delegate respondsToSelector:@selector(bookMarkView:cellForIndexPath:configSelectBookMarkHeadItemCell:)]) {
                
                [self.delegate bookMarkView:self cellForIndexPath:indexPath configSelectBookMarkHeadItemCell:cell];
                
            }
        }

    });
    
}

#pragma mark - 调整标示线位置
- (void)adjustSliderView {
    
    CGFloat offsetX = self.bookContentCollectionView.contentOffset.x;
    
    CGFloat bookContentW = _bookContentCollectionView.frame.size.width;
    
    CGFloat adjustX = (offsetX - bookContentW * _tempCurrentIndex) / bookContentW * _bookHeadCellWidth + _tempCurrentIndex * _bookHeadCellWidth + (_bookHeadCellWidth - 20) / 2;
    
    CGRect sliderViewF = _sliderView.frame;
    
    sliderViewF.origin.x = adjustX;
    
    _sliderView.frame = sliderViewF;
    
}


#pragma mark - 观察到的偏移量的变化(待修改)
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        CGFloat offsetX = self.bookContentCollectionView.contentOffset.x;
        
        CGFloat bookContentW = _bookContentCollectionView.frame.size.width;

        //调整标示线frame
        [self adjustSliderView];
        
        CGFloat currentIndex = offsetX / bookContentW;
        
        if (currentIndex == _tempCurrentIndex) {
            
            return;
            
        }
        
        //到达一个item正位置的时候需要滚动和修正当前的indexPath，避免滑动过程中调用太频繁
        if ((int)currentIndex == currentIndex) {
            
            //将上一个选中的cell置灰
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_tempCurrentIndex inSection:0];
            
            BookMarkHeadItemCell *cell = (BookMarkHeadItemCell *)[self.bookHeadCollectionView cellForItemAtIndexPath:indexPath];
            
            if (_currentheadCell) {
                
                [_currentheadCell setSelected:NO];
                
                if ([self.delegate respondsToSelector:@selector(bookMarkView:cellForIndexPath:configNormalBookMarkHeadItemCell:)]) {
                    
                    [self.delegate bookMarkView:self cellForIndexPath:indexPath configNormalBookMarkHeadItemCell:_currentheadCell];
                    
                }

            }
            
            //标示向右滚动还是向左滚动
            bool isRightScroll = _tempCurrentIndex - currentIndex <= 0 ? YES : NO;
            
            _tempCurrentIndex = currentIndex;
            
            //将当前cell选中
            indexPath = [NSIndexPath indexPathForRow:_tempCurrentIndex inSection:0];
            
            cell = (BookMarkHeadItemCell *)[self.bookHeadCollectionView cellForItemAtIndexPath:indexPath];
            
            if (cell) {
                
                _currentheadCell = cell;
                
                [cell setSelected:YES];
                
                //做选中的效果处理
                if ([self.delegate respondsToSelector:@selector(bookMarkView:cellForIndexPath:configSelectBookMarkHeadItemCell:)]) {
                    
                    [self.delegate bookMarkView:self cellForIndexPath:indexPath configSelectBookMarkHeadItemCell:cell];
                    
                }

            }
            
            
            //调整头部collectionView偏移量
            CGFloat bookHeadW = _bookHeadCollectionView.frame.size.width;

            CGFloat nowOffsetX = _bookHeadCollectionView.contentOffset.x;

            if (isRightScroll) { //向右滚动调整
                
                if (_tempCurrentIndex + 1 >= _bookHeadItemsArray.count - 1) {
                    
                    [_bookHeadCollectionView setContentOffset:CGPointMake(_bookHeadCellWidth * _bookHeadItemsArray.count - bookHeadW, 0) animated:YES];
                    
                    [self adjustHeadCellSelected];

                    return;
                    
                }
                
                if ((_tempCurrentIndex + 2) * _bookHeadCellWidth > bookHeadW) {
                    
                    if (nowOffsetX >= (_tempCurrentIndex + 2) * _bookHeadCellWidth -  bookHeadW) { //如果当前的偏移量已经足够大则不必调整
                        
                        return;
                        
                    }
                    
                    [_bookHeadCollectionView setContentOffset:CGPointMake((_tempCurrentIndex + 2) * _bookHeadCellWidth -  bookHeadW, 0) animated:YES];
                    
                    [self adjustHeadCellSelected];

                    return;
                    
                }
                
            }
            
            //向左滚动调整
            if (_tempCurrentIndex - 1 <= 0) {
                
                [_bookHeadCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
                
                [self adjustHeadCellSelected];

                return;
                
            }
            
            if (nowOffsetX > (_tempCurrentIndex - 1) * _bookHeadCellWidth) {
                
                [_bookHeadCollectionView setContentOffset:CGPointMake((_tempCurrentIndex - 1) * _bookHeadCellWidth, 0) animated:YES];
                
                [self adjustHeadCellSelected];

            }

        }
        
    } else if ([keyPath isEqualToString:@"frame"]) {
        
        NSLog(@"frame 发生了变化");
        
        NSLog(@"1-->:%@",self.bookContentCollectionView);
        
        [self changeContentFrame];
        
        [self.bookHeadCollectionView reloadData];
        
        [self.bookContentCollectionView reloadData];
        
    }
    
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_tempCurrentIndex == indexPath.row) {
        
        if ([self.delegate respondsToSelector:@selector(bookMarkView:didSelectSameIndexPath:)]) {
            
            [self.delegate bookMarkView:self didSelectSameIndexPath:indexPath];
        }
        
        return;
        
    }
    
    if (collectionView.tag == BookmarkHeadItemViewTag) {
        
        [self setSelectIndex:indexPath.row];
        
        if ([self.delegate respondsToSelector:@selector(bookMarkView:didSelectIndexPath:)]) {
            
            [self.delegate bookMarkView:self didSelectIndexPath:indexPath];
            
        }
        
    }
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView.tag == BookmarkHeadItemViewTag) {
        
        return self.bookHeadItemsArray.count;
        
    }
    
    return self.bookContentItemsArray.count;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.tag == BookmarkHeadItemViewTag) {
        
        BookMarkHeadItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BookMarkHeaderItemCellIndentify forIndexPath:indexPath];
        
        if (self.sliderColor && !_isAnimalSlider) {
            
            cell.sliderView.backgroundColor = self.sliderColor;
            
        }
        
        if (indexPath.row == _tempCurrentIndex) {
            
            _currentheadCell = cell;
            
            [cell setSelected:YES];
            
            //做选中的效果处理
            if ([self.delegate respondsToSelector:@selector(bookMarkView:cellForIndexPath:configSelectBookMarkHeadItemCell:)]) {
                
                [self.delegate bookMarkView:self cellForIndexPath:indexPath configSelectBookMarkHeadItemCell:cell];
                
            }
            
        } else {
            
            [cell setSelected:NO];
            
            if ([self.delegate respondsToSelector:@selector(bookMarkView:cellForIndexPath:configNormalBookMarkHeadItemCell:)]) {
                
                [self.delegate bookMarkView:self cellForIndexPath:indexPath configNormalBookMarkHeadItemCell:cell];
            
            }
            
        }
        
        return cell;
        
    }
    
    BookMarkContentItemCell *contentCell = [collectionView dequeueReusableCellWithReuseIdentifier:BookMarkContentItemCellIndnetify forIndexPath:indexPath];
    
    [self.datasource bookMarkView:self cellForIndexPath:indexPath configBookContentItemCell:contentCell];
    
    return contentCell;
    
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.tag == BookmarkHeadItemViewTag) {
        
        return [self.delegate bookMarkView:self itemSizeForIndexPath:indexPath];
        
    }
    
    
    id item = [self.bookContentItemsArray objectAtIndex:indexPath.row];
    
    if ([item isKindOfClass:[UIViewController class]]) {
        
        UIViewController *vc = (UIViewController *)item;
        
        return CGSizeMake(vc.view.frame.size.width, vc.view.frame.size.height);
        
    } else {
        
        UIView *view = (UIView *)item;
        
        return CGSizeMake(view.frame.size.width, view.frame.size.height);
        
    }
    
}


#pragma - mark 下面是一些配置信息
- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self configParams];
        
        [self.bookContentCollectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        [self.bookContentCollectionView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
    }
    
    return self;
    
}


- (void)configParams {
    
    _isCanScroll = YES;
    
    _tempCurrentIndex = 0;
    
    _sliderColor = [UIColor redColor];
    
    //加载试图
    [self addSubview:self.bookHeadCollectionView];
    
    [self addSubview:self.bookContentCollectionView];
    
}


//布局
- (void)layoutSubviews {
    
    if (self.bookItemEditButton) {
        
        self.bookItemEditButton.frame = CGRectMake(self.frame.size.width - 40, 0, 40, 40);
        
        self.bookHeadCollectionView.frame = CGRectMake(0, 0, self.frame.size.width - 40, 40);
        
        self.bookContentCollectionView.frame = CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - 40);
        
    } else {
        
        self.bookHeadCollectionView.frame = CGRectMake(0, 0, self.frame.size.width, 40);
        
        self.bookContentCollectionView.frame = CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - 40);
        
    }
    
    _sliderView.frame = CGRectMake(_bookHeadCollectionView.frame.origin.x + (_bookHeadCellWidth - 20) / 2, CGRectGetMaxY(_bookHeadCollectionView.frame) - 2, 20, 2);
    
}


- (UICollectionView *)bookHeadCollectionView {
    
    if (_bookHeadCollectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        flowLayout.minimumLineSpacing = 0.0f;
        
        flowLayout.minimumInteritemSpacing = 0.0f;
        
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        UICollectionView *bookHeadCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        _bookHeadCollectionView = bookHeadCollectionView;
        
        _bookHeadCollectionView.backgroundColor = [UIColor whiteColor];
        
        _bookHeadCollectionView.dataSource = self;
        
        _bookHeadCollectionView.delegate = self;
        
        _bookHeadCollectionView.tag = BookmarkHeadItemViewTag;
        
        [_bookHeadCollectionView registerClass:[BookMarkHeadItemCell class] forCellWithReuseIdentifier:BookMarkHeaderItemCellIndentify];
        
        _bookHeadCollectionView.showsHorizontalScrollIndicator = NO;
        
        _bookHeadCollectionView.showsVerticalScrollIndicator = NO;
        
    }
    
    return _bookHeadCollectionView;
    
}


- (NSMutableArray*)bookHeadItemsArray {
    
    if (_bookHeadItemsArray == nil) {
        
        _bookHeadItemsArray = [NSMutableArray new];
        
    }
    
    return _bookHeadItemsArray;
    
}


- (UICollectionView*)bookContentCollectionView {
    
    if (_bookContentCollectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        flowLayout.minimumInteritemSpacing = 0.0f;
        
        flowLayout.minimumLineSpacing = 0.0f;
        
        
        UICollectionView *bookContentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        _bookContentCollectionView = bookContentCollectionView;
        
        _bookContentCollectionView.dataSource = self;
        
        _bookContentCollectionView.delegate = self;
        
        _bookContentCollectionView.backgroundColor = [UIColor whiteColor];
        
        _bookContentCollectionView.pagingEnabled = YES;
        
        _bookContentCollectionView.tag = BookmarkItemContentViewTag;
        
        [_bookContentCollectionView registerClass:[BookMarkContentItemCell class] forCellWithReuseIdentifier:BookMarkContentItemCellIndnetify];
        
        _bookContentCollectionView.showsHorizontalScrollIndicator = NO;
        
        _bookContentCollectionView.showsVerticalScrollIndicator = NO;
        
    }
    
    return _bookContentCollectionView;
    
}


- (NSMutableArray*)bookContentItemsArray {
    
    if (_bookContentItemsArray== nil) {
        
        _bookContentItemsArray = [NSMutableArray new];
        
    }
    
    return _bookContentItemsArray;
    
}


- (void)dealloc {
    
    [self.bookContentCollectionView removeObserver:self forKeyPath:@"contentOffset"];
    
    [self.bookContentCollectionView removeObserver:self forKeyPath:@"frame"];
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:self.bookContentCollectionView]) { // 如果是内容控制器在滚动
        
        if(_scroolBlock) _scroolBlock(0); // 暂时不控制
        
    }
    
}


- (void)setScroolBlock:(contentDidEndScrool)scroolBlock {
    
    _scroolBlock = scroolBlock?[scroolBlock copy] : nil;
    
}


@end


#pragma mark - 顶部标签栏cell

@implementation BookMarkHeadItemCell

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self configContentView];
        
    }
    
    return self;
    
}

- (void)configContentView {
    
    //文字
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
    
    titleLable.font = [UIFont systemFontOfSize:14];
    
    titleLable.textAlignment = NSTextAlignmentCenter;
    
    titleLable.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:titleLable];
    
    self.titleLable = titleLable;
    
    
    //图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView.clipsToBounds = YES;
    
    [self.contentView addSubview:imageView];
    
    self.imageView = imageView;
    
    
    //底部标示线
    UIView *sliderView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.contentView addSubview:sliderView];
    
    self.sliderView = sliderView;
    

    //下面的布局，基本的布局，如果还想做特殊的调整，在自己的类里面做调整
    
    WeakSelf
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.equalTo(weakSelf.mas_centerX);
        
        make.centerY.equalTo(weakSelf.mas_centerY);
        
    }];

    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.equalTo(weakSelf).with.insets(UIEdgeInsetsMake(2, 5, 2, 5));
        
    }];

    
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.equalTo(weakSelf.mas_centerX);
        
        make.bottom.equalTo(weakSelf.mas_bottom);
        
        make.height.mas_equalTo(@1);
        
        make.width.mas_equalTo(@20);
        
    }];

}

- (void)setSelected:(BOOL)selected {
    
    if (selected) {
        
        [self.sliderView setHidden:NO];
        
    } else {
        
        [self.sliderView setHidden:YES];
        
    }
    
}

@end


#pragma mark- 内容cell

@interface BookMarkContentItemCell ()

@end

@implementation BookMarkContentItemCell

- (id)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
    
}


- (void)setGlobalView:(UIView *)globalView {
    
    if (_globalView) {
        
        [_globalView removeFromSuperview];
        
    }
    
    _globalView = globalView;
    
    [self.contentView addSubview:_globalView];
    
    
    WeakSelf
    
    [_globalView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.right.equalTo(weakSelf);
        
    }];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
//    _globalView.frame = self.bounds;
    
}

@end
























