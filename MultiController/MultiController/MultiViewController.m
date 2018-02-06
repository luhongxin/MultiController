//
//  MultiViewController.m
//  MultiController
//
//  Created by lhx on 2018/2/3.
//  Copyright © 2018年 lhx. All rights reserved.
//

#import "MultiViewController.h"

#define RGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define SCREENWIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREENHEIGHT ([UIScreen mainScreen].bounds.size.height)

#define NAVSCROLLHEIGHT 40
#define AnimatTime  0.37

@interface MultiViewController ()<UIScrollViewDelegate>{
    
    UIScrollView *mNavScrollView;
    UIScrollView *mScrollView;
    UISegmentedControl *mSegment;
    UIView *mLineView;
    
    NSMutableArray *mNavTitleArr;
    NSMutableArray *mTitleWidthArr;
    CGFloat mTotalWidth;
    
    NSInteger mSelectIndex;
    
}
@end

@implementation MultiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"MutiController";
    self.view.backgroundColor = RGB(243, 243, 243, 1);
    
    mSelectIndex = 3;
    mTitleWidthArr = [NSMutableArray array];
    mNavTitleArr = [NSMutableArray arrayWithArray:@[@"测试0000000001",@"测试02",@"测试03",@"测试04",@"测试00000000000005",@"测试06",@"测试07",@"测试08",@"测试0000000009",]];
    
    for (NSString *str in mNavTitleArr) {
        CGFloat width = [self widthWithStr:str andFont:14.0] + 15.0;
        mTotalWidth += width;
        [mTitleWidthArr addObject:[NSString stringWithFormat:@"%f",width]];
    }
    
    [self initialization];
    [self setNavTitleView];
    [self addChildViewController];
    [self chooseSegment:mSegment];
}
-(void)initialization{
    mScrollView = [[UIScrollView alloc]init];
    mScrollView.frame = CGRectMake(0, NAVSCROLLHEIGHT, SCREENWIDTH, SCREENHEIGHT - 64.0 - NAVSCROLLHEIGHT);
    mScrollView.delegate = self;
    [self.view addSubview:mScrollView];
    mScrollView.pagingEnabled = YES;
    mScrollView.showsHorizontalScrollIndicator = NO;
}
- (CGFloat)widthWithStr:(NSString *)str andFont:(CGFloat)font {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize  size = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 30)  options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)   attributes:attribute context:nil].size;
    return size.width;
}
    
#pragma mark segment
-(void)setNavTitleView{
    mNavScrollView = [[UIScrollView alloc]init];
    mNavScrollView.frame = CGRectMake(0, 0, SCREENWIDTH, NAVSCROLLHEIGHT);
    [self.view addSubview:mNavScrollView];
    mNavScrollView.showsHorizontalScrollIndicator = NO;
    mNavScrollView.contentSize = CGSizeMake(mTotalWidth, 0);
    mNavScrollView.backgroundColor = [UIColor whiteColor];
    
    mSegment = [[UISegmentedControl alloc]initWithItems:mNavTitleArr];
    mSegment.frame = CGRectMake(0, 0, mTotalWidth, NAVSCROLLHEIGHT - 2);
    [mNavScrollView addSubview:mSegment];
    mSegment.apportionsSegmentWidthsByContent = YES;
    mSegment.selectedSegmentIndex = mSelectIndex;
    [mSegment addTarget:self action:@selector(chooseSegment:) forControlEvents:UIControlEventValueChanged];

    mSegment.tintColor = [UIColor clearColor];
    NSMutableDictionary *UnselectedattDic = [NSMutableDictionary dictionary];
    UnselectedattDic[NSFontAttributeName] = [UIFont systemFontOfSize:14.0];
    UnselectedattDic[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSMutableDictionary *SelectedattDic = [NSMutableDictionary dictionary];
    SelectedattDic[NSFontAttributeName] = [UIFont systemFontOfSize:15.0];
    SelectedattDic[NSForegroundColorAttributeName] = [UIColor redColor];
    [mSegment setTitleTextAttributes:UnselectedattDic forState:UIControlStateNormal];
    [mSegment setTitleTextAttributes:SelectedattDic forState:UIControlStateSelected];
    
    mLineView = [[UIView alloc]init];
    mLineView.backgroundColor = [UIColor redColor];
    [mNavScrollView addSubview:mLineView];
}
-(void)addChildViewController{
    for (int i = 0; i<mNavTitleArr.count; i++) {
        NSString *classStr = @"MultiChildViewController";
        UIViewController *classVC = [[NSClassFromString(classStr) alloc] init];
        [self addChildViewController:classVC];
    }
    mScrollView.contentSize = CGSizeMake(self.childViewControllers.count * SCREENWIDTH, 0);
}
-(void)chooseSegment:(id)sender{
    UISegmentedControl *segment = sender;
    mSelectIndex = segment.selectedSegmentIndex;
    mScrollView.contentOffset = CGPointMake(SCREENWIDTH * mSelectIndex, 0);
    UIViewController *childVC = self.childViewControllers[mSelectIndex];
    if (childVC.isViewLoaded) {
        return;
    }
    childVC.view.frame = mScrollView.bounds;
    [mScrollView addSubview:childVC.view];
}
-(void)moveNavScrollView:(CGFloat)offSetX{
    CGFloat move = offSetX/SCREENWIDTH - mSelectIndex;
    CGFloat multiple = 1 - move;
    
    if (mTotalWidth <= SCREENWIDTH) {
    }else{
        CGFloat leftTotalWidth = 0;
        for (int i = 0; i<mSelectIndex; i++) {
            NSString *widthStr = mTitleWidthArr[i];
            CGFloat width = [widthStr floatValue];
            leftTotalWidth += width;
        }
        CGFloat relativeLeftWidth = [mTitleWidthArr[mSelectIndex] floatValue];
        CGFloat relativeLeftCenter = leftTotalWidth + relativeLeftWidth/2;
        CGFloat moveLeftWidth = relativeLeftCenter - SCREENWIDTH/2;
        
        CGFloat relativeRightWidth;
        if (mSelectIndex<mNavTitleArr.count - 1) {
            relativeRightWidth = [mTitleWidthArr[mSelectIndex + 1] floatValue];
        }else{
            relativeRightWidth = [mTitleWidthArr[mSelectIndex] floatValue];
        }
        CGFloat relativeRigthCenter = leftTotalWidth + relativeLeftWidth + relativeRightWidth/2;
        CGFloat moveRightWidth = relativeRigthCenter - SCREENWIDTH/2;

        if (moveLeftWidth >0) {
                CGFloat offset = moveRightWidth + (moveLeftWidth - moveRightWidth)*multiple;
                offset = (offset > (mTotalWidth - SCREENWIDTH)) ? (mTotalWidth - SCREENWIDTH) : offset;
                [UIView animateWithDuration:AnimatTime animations:^{
                    mNavScrollView.contentOffset = CGPointMake(offset, 0);
                }];
        }else{
            [UIView animateWithDuration:AnimatTime animations:^{
                mNavScrollView.contentOffset = CGPointMake(0, 0);
            }];
        }
    }
}
-(void)setLineScroll:(CGFloat)offSetX{
    CGFloat move = offSetX/SCREENWIDTH - mSelectIndex;
    CGFloat multiple = 1 - move;

    CGFloat relativeLeftWidth = [mTitleWidthArr[mSelectIndex] floatValue];
    CGFloat leftTotalWidth = 0;
    for (int i = 0; i<mSelectIndex; i++) {
        NSString *widthStr = mTitleWidthArr[i];
        CGFloat width = [widthStr floatValue];
        leftTotalWidth += width;
    }
    CGFloat relativeRightWidth;
    if (mSelectIndex<mNavTitleArr.count - 1) {
        relativeRightWidth = [mTitleWidthArr[mSelectIndex + 1] floatValue];
    }else{
        relativeRightWidth = [mTitleWidthArr[mSelectIndex] floatValue];
    }
    mLineView.frame = CGRectMake(leftTotalWidth + 15 + relativeLeftWidth * move, NAVSCROLLHEIGHT - 2, relativeRightWidth - 30 + (relativeLeftWidth - relativeRightWidth)*multiple, 2);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    mSelectIndex = scrollView.contentOffset.x/SCREENWIDTH;
    [self setLineScroll:scrollView.contentOffset.x];
    [self moveNavScrollView:scrollView.contentOffset.x];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    mSelectIndex = scrollView.contentOffset.x/SCREENWIDTH;
    mSegment.selectedSegmentIndex = mSelectIndex;
    UIViewController *childView = self.childViewControllers[mSelectIndex];
    if (childView.isViewLoaded) {
        return;
    }
    childView.view.frame = CGRectMake(mSelectIndex * SCREENWIDTH, 0, SCREENWIDTH, mScrollView.frame.size.height);
    [mScrollView addSubview:childView.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
