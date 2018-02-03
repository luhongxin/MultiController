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

#define EachSegmentWith             75   //segment单个宽度

@interface ViewController ()<UIScrollViewDelegate>{
    
    UIScrollView *mNavScrollView;
    UIScrollView *mScrollView;
    UISegmentedControl *mSegment;
    UIView *mLineView;
    
    NSMutableArray *mNavTitleArr;
    NSInteger mSelectIndex;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"MutiController";
    self.view.backgroundColor = RGB(243, 243, 243, 1);
    
    mNavTitleArr = [NSMutableArray arrayWithArray:@[@"测试lhx01",@"测试ddddd",@"测试03",@"测试04",@"测试05",@"测试06",@"测试07",@"测试08",@"测试09",]];
    
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
    
#pragma mark segment
-(void)setNavTitleView{
    
    mNavScrollView = [[UIScrollView alloc]init];
    mNavScrollView.frame = CGRectMake(0, 0, SCREENWIDTH, 29);
    mNavScrollView.showsHorizontalScrollIndicator = NO;
    CGFloat navTitleWith = EachSegmentWith * mNavTitleArr.count;
    mNavScrollView.contentSize = CGSizeMake(navTitleWith, 0);
    mNavScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mNavScrollView];
    
    
    mSegment = [[UISegmentedControl alloc]initWithItems:mNavTitleArr];
    mSegment.frame = CGRectMake(0, 0, navTitleWith, 27);
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
    if (mNavTitleArr.count * EachSegmentWith <= SCREENWIDTH) {
        //小于屏宽不移动
    }else{
        //中间
        if (mSelectIndex >= 3 && mSelectIndex <= (mNavTitleArr.count - 4)) {
            [UIView animateWithDuration:0.37 animations:^{
                mNavScrollView.contentOffset = CGPointMake((mSelectIndex - 2) * EachSegmentWith, 0);
            }];
        }else if (mSelectIndex < 3 ){
            //左三
            [UIView animateWithDuration:0.37 animations:^{
                mNavScrollView.contentOffset = CGPointMake(0, 0);
            }];
        }else{
            //右三
            CGFloat contentSize = EachSegmentWith * mNavTitleArr.count;
            [UIView animateWithDuration:0.37 animations:^{
                mNavScrollView.contentOffset = CGPointMake(contentSize - SCREENWIDTH, 0);
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
