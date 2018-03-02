//
//  ViewController.m
//  KBChartLineView
//
//  Created by iMac on 2018/2/28.
//  Copyright © 2018年 kangbing. All rights reserved.
//

#import "ViewController.h"
#import "KBChartLineView.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    KBChartLineView *line = [[KBChartLineView alloc]init];
    line.frame = CGRectMake(30, 30, 325, 200);
    [self.view addSubview:line];
//    line.backgroundColor = [UIColor darkGrayColor];
    
    NSArray *Xarray = @[@"10:00",@"12:00",@"14:00",@"16:00",@"18:00"];
    NSArray *Yarray = @[@"0.0",@"5.0",@"10.0"];
    NSArray *arrayData = @[@"8.9",@"1.2",@"3.6",@"9.0",@"5.3"];
    
    line.xValues = Xarray;
    line.yValues = Yarray;
    line.dataValues = arrayData;
    line.enableTouch = YES;
    
    
    NSString *max = [NSString stringWithFormat:@"%@", [arrayData valueForKeyPath:@"@min.floatValue"]];
    NSLog(@"%@",max);
    
    
    
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
