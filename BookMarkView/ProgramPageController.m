//
//  ProgramPageController.m
//  BookMarkView
//
//  Created by 张涛 on 2018/4/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ProgramPageController.h"

#import "BookMarkView.h"
#import "ProgramModel.h"
#import "AdaptationTool.h"
#import "ProgramListViewController.h"

#define DeviceWidth  [UIScreen mainScreen].bounds.size.width
#define DeviceHeight [UIScreen mainScreen].bounds.size.height

#define BookHeadCellTextWidth 60
#define BookHeadCellImageWidth 80


@interface ProgramPageController () <BookMarkViewDelegate,BookMarkViewDataSource>

@property (nonatomic, strong) BookMarkView *bookmarkView;

@property (nonatomic, strong) NSMutableArray *bookmarkHeaditemsArray; //头部数据源

@property (nonatomic, strong) NSMutableArray *bookmarkContentItemsArray; //内容区数据源


@end

@implementation ProgramPageController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"节目";
    
    [self loadContentView];
    
    [self firstRequestData];

}

#pragma mark - 加载视图
- (void)loadContentView {
    
    BookMarkView *bookmarkView = [[BookMarkView alloc] initWithFrame:CGRectMake(0, 64 + kStatusBarAddHeight, DeviceWidth, DeviceHeight - 64 - kStatusBarAddHeight)];
    
    [self.view addSubview:bookmarkView];
    
    bookmarkView.backgroundColor = [UIColor whiteColor];
    
//    bookmarkView.bookHeadCollectionView.frame = CGRectMake(0, 0, DeviceWidth, 40);
//    
//    bookmarkView.bookContentCollectionView.frame = CGRectMake(0, 40, DeviceWidth, DeviceHeight - 64 - 40);
    
    bookmarkView.datasource = self;
    
    bookmarkView.delegate = self;
    
    bookmarkView.beginCurrntIndex = 0;
    
    bookmarkView.sliderColor = [UIColor orangeColor];
    
    bookmarkView.isCanScroll = YES;
    
    bookmarkView.isAnimalSlider = YES;
    
    bookmarkView.bookHeadCellWidth = BookHeadCellTextWidth;
    
    /*
    //设置编辑按钮
    UIButton *editBtn = [[UIButton alloc] init];
    
    [editBtn setTitle:@"+" forState:UIControlStateNormal];
    
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [editBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 5, 5)];
    
    [editBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    bookmarkView.bookItemEditButton = editBtn;
    */
    
    self.bookmarkView = bookmarkView;
    
}


- (void)firstRequestData {
    
    self.bookmarkHeaditemsArray = [NSMutableArray new];
    
    self.bookmarkContentItemsArray = [NSMutableArray new];

    for (NSInteger i = 0; i < 10; i++) {
        
        ProgramModel *program = [[ProgramModel alloc] init];
        
        program.programId = [NSString stringWithFormat:@"1000_%ld", i];
        
        program.title = [NSString stringWithFormat:@"频道_%ld", i + 1];

        [self.bookmarkHeaditemsArray addObject:program];
        
        ProgramListViewController *programVC = [[ProgramListViewController alloc] init];
        
        [self.bookmarkContentItemsArray addObject:programVC];
        
    }

    [self.bookmarkView reloadData];

}

#pragma mark- BookMarkView的代理
//头部的数据源
- (NSMutableArray*)bookMarkViewHeaderItems:(BookMarkView*)bookmarkView {
    
    return self.bookmarkHeaditemsArray;
    
}

//头部非选中
- (void)bookMarkView:(BookMarkView *)bookmarkView cellForIndexPath:(NSIndexPath *)indexPath configNormalBookMarkHeadItemCell:(BookMarkHeadItemCell *)bookMarkHeadItemCell {
    
    ProgramModel *item = [self.bookmarkHeaditemsArray objectAtIndex:indexPath.row];
    
    if (item.normalChannelImage) {
        
        bookMarkHeadItemCell.imageView.image = [UIImage imageNamed:item.normalChannelImage];
        
        [bookMarkHeadItemCell.titleLable setHidden:YES];
        
        [bookMarkHeadItemCell.imageView setHidden:NO];
        
    } else {
        
        [bookMarkHeadItemCell.titleLable setHidden:NO];
        
        [bookMarkHeadItemCell.imageView setHidden:YES];
        
        bookMarkHeadItemCell.titleLable.text = item.title;
        
        bookMarkHeadItemCell.titleLable.textColor = [UIColor lightGrayColor];
        
    }
    
}

//头部选中
- (void)bookMarkView:(BookMarkView *)bookmarkView cellForIndexPath:(NSIndexPath *)indexPath configSelectBookMarkHeadItemCell:(BookMarkHeadItemCell *)bookMarkHeadItemCell {
    
    ProgramModel *item = [self.bookmarkHeaditemsArray objectAtIndex:indexPath.row];

    if (item.normalChannelImage) {
        
        bookMarkHeadItemCell.imageView.image = [UIImage imageNamed:item.selectedChannelImage];
        
        [bookMarkHeadItemCell.titleLable setHidden:YES];
        
        [bookMarkHeadItemCell.imageView setHidden:NO];
        
    } else {
        
        [bookMarkHeadItemCell.titleLable setHidden:NO];
        
        [bookMarkHeadItemCell.imageView setHidden:YES];
        
        bookMarkHeadItemCell.titleLable.text= item.title;
        
        bookMarkHeadItemCell.titleLable.textColor = [UIColor blackColor];
        
    }

}

//头部size
- (CGSize)bookMarkView:(BookMarkView *)bookmarkView itemSizeForIndexPath:(NSIndexPath *)indexPath {
    
    ProgramModel *item = [self.bookmarkHeaditemsArray objectAtIndex:indexPath.row];
    
    if (item.normalChannelImage) {
        
        return CGSizeMake(BookHeadCellImageWidth, 40);
        
    } else {
        
        return CGSizeMake(BookHeadCellTextWidth, 40);
        
    }
    
}

//内容数据源
- (NSMutableArray*)bookMarkViewContentViewItems:(BookMarkView *)bookmarkView {
    
    return self.bookmarkContentItemsArray;
    
}

//内容的设置
- (void)bookMarkView:(BookMarkView *)bookmarkView cellForIndexPath:(NSIndexPath *)indexPath configBookContentItemCell:(BookMarkContentItemCell *)bookmarkContentCell {
    
    UIViewController *vc = [self.bookmarkContentItemsArray objectAtIndex:indexPath.row];
    
    bookmarkContentCell.globalView = vc.view;
    
}

//内容的大小
- (CGSize)bookMarkView:(BookMarkView *)bookmarkView contentSizeForIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(DeviceWidth, DeviceHeight - 64 - 40);
    
}

//点中的回调
- (void)bookMarkView:(BookMarkView *)bookmarkView didSelectIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (void)bookMarkViewEditBookItem:(BookMarkView *)bookmarkView {
    
    NSLog(@"点击了编辑按钮");
    
}

@end









