//
//  ChildViewController.m
//  MultiController
//
//  Created by lhx on 2018/2/3.
//  Copyright © 2018年 lhx. All rights reserved.
//

#import "ChildViewController.h"

#define RGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface ChildViewController ()

@end

@implementation ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    int R = arc4random() % 255;
    int G = arc4random() % 255;
    int B = arc4random() % 255;
    self.view.backgroundColor = RGB(R, G, B, 1);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
