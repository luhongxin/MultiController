//
//  ViewController.m
//  MultiController
//
//  Created by lhx on 2018/2/3.
//  Copyright © 2018年 lhx. All rights reserved.
//

#import "ViewController.h"

#define RGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define SCREENWIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREENHEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()<UIScrollViewDelegate>{
    
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

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"MutiController";
    self.view.backgroundColor = RGB(243, 243, 243, 1);
    
    mTitleWidthArr = [NSMutableArray array];
    mNavTitleArr = [NSMutableArray arrayWithArray:@[@"测试0000000001",@"测试02",@"测试03",@"测试04",@"测试05",@"测试06",@"测试07",@"测试08",@"测试0000000009",]];
    
    for (NSString *str in mNavTitleArr) {
        CGFloat width = [self widthWithStr:str andFont:14.0] + 15.0;
        NSLog(@"width === %f",width);
        mTotalWidth += width;
        [mTitleWidthArr addObject:[NSString stringWithFormat:@"%f",width]];
    }
    
    [self initialization];
    [self setNavTitleView];
    [self addChildViewController];
    
    [self scrollViewDidEndScrollingAnimation:mScrollView];
}

-(void)initialization{
    mScrollView = [[UIScrollView alloc]init];
    mScrollView.frame = CGRectMake(0, 29.0, SCREENWIDTH, SCREENHEIGHT - 64.0 - 29.0);
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
    mNavScrollView.frame = CGRectMake(0, 0, SCREENWIDTH, 29);
    mNavScrollView.showsHorizontalScrollIndicator = NO;
    mNavScrollView.contentSize = CGSizeMake(mTotalWidth, 0);

    mNavScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mNavScrollView];
    
    
    mSegment = [[UISegmentedControl alloc]initWithItems:mNavTitleArr];
    mSegment.frame = CGRectMake(0, 0, mTotalWidth, 27);

    mSegment.apportionsSegmentWidthsByContent = YES;
    [mNavScrollView addSubview:mSegment];
    
    [mSegment addTarget:self action:@selector(chooseSegment:) forControlEvents:UIControlEventValueChanged];
    
    mSegment.selectedSegmentIndex = 0;//设置初始位置
    int selectedIndex = 0;
    
    mSegment.tintColor = [UIColor clearColor];
    NSMutableDictionary *UnselectedattDic = [NSMutableDictionary dictionary];
    UnselectedattDic[NSFontAttributeName] = [UIFont systemFontOfSize:14.0];
    UnselectedattDic[NSForegroundColorAttributeName] = RGB(102, 102, 102, 1);
    NSMutableDictionary *SelectedattDic = [NSMutableDictionary dictionary];
    SelectedattDic[NSFontAttributeName] = [UIFont systemFontOfSize:14.0];
    SelectedattDic[NSForegroundColorAttributeName] = [UIColor redColor];
    [mSegment setTitleTextAttributes:UnselectedattDic forState:UIControlStateNormal];
    [mSegment setTitleTextAttributes:SelectedattDic forState:UIControlStateSelected];
    
    mLineView = [[UIView alloc]init];
    mLineView.backgroundColor = [UIColor redColor];
    mLineView.frame = CGRectMake(10 + selectedIndex * (mSegment.frame.size.width/mNavTitleArr.count), 27, (mSegment.frame.size.width/mNavTitleArr.count) - 20, 2);
    
    [mNavScrollView addSubview:mLineView];
    mLineView.hidden = YES;
}
    
#pragma mark ChildViewController
-(void)addChildViewController{
    
    for (int i = 0; i<mNavTitleArr.count; i++) {
        NSString *classStr = @"ChildViewController";
        UIViewController *classVC = [[NSClassFromString(classStr) alloc] init];
        [self addChildViewController:classVC];
    }
    mScrollView.contentSize = CGSizeMake(self.childViewControllers.count * SCREENWIDTH, 0);
}
    
#pragma mark UISegmentedControl
-(void)chooseSegment:(id)sender{
    UISegmentedControl *segment = sender;
    mSelectIndex = segment.selectedSegmentIndex;
    [self moveNavScrollView];
    mScrollView.contentOffset = CGPointMake(SCREENWIDTH * mSelectIndex, 0);
    UIViewController *childVC = self.childViewControllers[mSelectIndex];
    if (childVC.isViewLoaded) {
        
        return;
    }
    childVC.view.frame = mScrollView.bounds;
    [mScrollView addSubview:childVC.view];
    
}
    
#pragma mark 移动 mNavScrollView
-(void)moveNavScrollView{
    if (mTotalWidth <= SCREENWIDTH) {
        //小于屏宽不移动
    }else{
        //当前中心
        CGFloat leftWidth = 0;
        for (int i = 0; i<mSelectIndex; i++) {
            NSString *widthStr = mTitleWidthArr[i];
            CGFloat width = [widthStr floatValue];
            leftWidth += width;
        }
        CGFloat selectWidth = [mTitleWidthArr[mSelectIndex] floatValue];
        CGFloat currectCenter = leftWidth + selectWidth/2;
        

        CGFloat moveWidth = currectCenter - SCREENWIDTH/2;
        if (moveWidth >0) {

            if (mTotalWidth - currectCenter < (SCREENWIDTH/2)) {
                [UIView animateWithDuration:0.37 animations:^{
                    mNavScrollView.contentOffset = CGPointMake(mTotalWidth - SCREENWIDTH, 0);
                }];
            } else {
                [UIView animateWithDuration:0.37 animations:^{
                    mNavScrollView.contentOffset = CGPointMake(moveWidth, 0);
                }];
            }
        }else{
            [UIView animateWithDuration:0.37 animations:^{
                mNavScrollView.contentOffset = CGPointMake(0, 0);
            }];
        }

    }
}
#pragma mark ScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    mSelectIndex = scrollView.contentOffset.x/SCREENWIDTH;
    mSegment.selectedSegmentIndex = mSelectIndex;//设置位置
    [self moveNavScrollView];
    UIViewController *childView = self.childViewControllers[mSelectIndex];
    if (childView.isViewLoaded) {
        return;
    }
    childView.view.frame = mScrollView.bounds;
    [mScrollView addSubview:childView.view];
    
    
}
    
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float offSetX = scrollView.contentOffset.x/SCREENWIDTH;
    mLineView.frame = CGRectMake(10 + offSetX * (mSegment.frame.size.width/mNavTitleArr.count), 27, (mSegment.frame.size.width/mNavTitleArr.count) - 20 , 2);
}
    
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
