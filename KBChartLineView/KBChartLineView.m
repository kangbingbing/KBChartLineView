//
//  KBChartLineView.m
//  KBChartLineView
//
//  Created by iMac on 2018/2/28.
//  Copyright © 2018年 kangbing. All rights reserved.
//

#import "KBChartLineView.h"

#define XYLineWidth 1

@interface KBChartLineView ()<UIGestureRecognizerDelegate>

/** 横向 */
@property (nonatomic, strong) UIView *horizontalLine;
/** 纵向 */
@property (nonatomic, strong) UIView *verticalLine;

/** 纵向提示线 */
@property (nonatomic, strong) UIView *verTipsLine;
/** 横向提示线 */
@property (nonatomic, strong) UIView *horTipsLine;

@property (nonatomic, strong) NSMutableArray *pointArray;

@end

@implementation KBChartLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.horizontalLine = [[UIView alloc]init];
        self.horizontalLine.backgroundColor = [UIColor blueColor];
        [self addSubview:self.horizontalLine];
        
        self.verticalLine = [[UIView alloc]init];
        self.verticalLine.backgroundColor = [UIColor redColor];
        [self addSubview:self.verticalLine];
        
        
    }
    return self;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.horizontalLine.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, XYLineWidth);
    
    self.verticalLine.frame = CGRectMake(0, 0, XYLineWidth, self.frame.size.height);
    
    /** XY轴数据 */
    [self prepareXYLabel];
    /** 画线 */
    [self prepareDrawLine];
    
    if (self.enableTouch) {
        
        self.verTipsLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.frame.size.height)];
        self.verTipsLine.backgroundColor = [UIColor blackColor];
        self.verTipsLine.alpha = 0;
        [self addSubview:self.verTipsLine];
        
        self.horTipsLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        self.horTipsLine.backgroundColor = [UIColor redColor];
        self.horTipsLine.alpha = 0;
        [self addSubview:self.horTipsLine];
        
        UIView *panView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        panView.backgroundColor = [UIColor clearColor];
        [self addSubview:panView];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panGesture.delegate = self;
        [panGesture setMaximumNumberOfTouches:1];
        [panView addGestureRecognizer:panGesture];
    }
    
 
    
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint transLation = [recognizer locationInView:self];
    
    // 根据x的值, 计算下标
    CGFloat X_W = self.frame.size.width / (self.xValues.count - 1);
    NSInteger index = roundf(transLation.x / X_W);
    
    CGPoint point = [self.pointArray[index] CGPointValue];
    self.verTipsLine.frame = CGRectMake(point.x, 0, 1, self.frame.size.height);
    self.horTipsLine.frame = CGRectMake(0, point.y, self.frame.size.width, 1);
    
    NSLog(@"当前值%@",self.dataValues[index]);
    NSLog(@"X轴当前值%@",self.xValues[index]);
    
    if (transLation.x < 0 || transLation.x > self.frame.size.width || transLation.y < 0 || transLation.y > self.frame.size.height) {
        self.verTipsLine.alpha = 0;
        self.horTipsLine.alpha = 0;
    }else{
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.verTipsLine.alpha = 0.2;
            self.horTipsLine.alpha = 0.2;
        } completion:nil];
    }
    
    
    
    

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.verTipsLine.alpha = 0;
            self.horTipsLine.alpha = 0;
        } completion:nil];
    }
}

- (void)prepareDrawLine{
    
    CGFloat maxValue = [[self.yValues valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat minValue = [[self.yValues valueForKeyPath:@"@min.floatValue"] floatValue];
    
    
//    if ([[self.dataValues valueForKeyPath:@"@min.floatValue"] floatValue] < minValue) {
//        minValue = [[self.dataValues valueForKeyPath:@"@min.floatValue"] floatValue];
//    }
//    if ([[self.dataValues valueForKeyPath:@"@max.floatValue"] floatValue] > maxValue) {
//        maxValue = [[self.dataValues valueForKeyPath:@"@max.floatValue"] floatValue];
//    }
    
    NSLog(@"最大值%f----最小值%f",maxValue,minValue);
    for (int i = 0; i < [self.dataValues count]; i++) {
        
        CGFloat value = [self.dataValues[i] floatValue];
        CGFloat LineCenterX = (self.frame.size.width / (self.dataValues.count - 1)) * i;
        CGFloat LineCenterY = self.frame.size.height - (value - minValue) / (maxValue - minValue) * self.frame.size.height;
        CGPoint point = CGPointMake(LineCenterX, LineCenterY);
        [self.pointArray addObject:[NSValue valueWithCGPoint:point]];
        
    }
    
    NSLog(@"%@",self.dataValues);
    
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < self.pointArray.count - 1; i++) {
        CGPoint point1 = [self.pointArray[i] CGPointValue];
        CGPoint point2 = [self.pointArray[i + 1] CGPointValue];
        [path moveToPoint:point1];
        [path addLineToPoint:point2];
    }
    
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = 2;
    lineLayer.strokeColor = [UIColor greenColor].CGColor;
    lineLayer.path = path.CGPath;
    lineLayer.fillColor = nil;
    [self.layer addSublayer:lineLayer];
    
    
    
}

- (void)prepareXYLabel{
    
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[UILabel class]])
            [subview removeFromSuperview];
    }
    
    CGFloat X_W = self.frame.size.width / (self.xValues.count - 1);
    for (int i = 0; i < self.xValues.count; i++) {
        UILabel *horizontalLabel = [[UILabel alloc]init];
        [horizontalLabel sizeToFit];
        horizontalLabel.text = self.xValues[i];
        horizontalLabel.font = [UIFont systemFontOfSize:12];
        horizontalLabel.textAlignment = NSTextAlignmentCenter;
        horizontalLabel.textColor = [UIColor blackColor];
        horizontalLabel.backgroundColor = [UIColor clearColor];
        horizontalLabel.center = CGPointMake(i * X_W, self.frame.size.height + 10);
        horizontalLabel.bounds = CGRectMake(0, 0, 40, 20);
        [self addSubview:horizontalLabel];
    }
    
    CGFloat Y_H = self.frame.size.height / (self.yValues.count - 1);
    for (int i = 0; i < self.yValues.count; i++) {
        UILabel *verticalLabel = [[UILabel alloc]init];
        [verticalLabel sizeToFit];
        verticalLabel.text = self.yValues[i];
        verticalLabel.font = [UIFont systemFontOfSize:12];
        verticalLabel.textAlignment = NSTextAlignmentCenter;
        verticalLabel.textColor = [UIColor blackColor];
        verticalLabel.backgroundColor = [UIColor clearColor];
        verticalLabel.center = CGPointMake(-20,self.frame.size.height - i * Y_H);
        verticalLabel.bounds = CGRectMake(0, 0, 40, 20);
        [self addSubview:verticalLabel];
    }
    
    
    
    
}


- (NSMutableArray *)pointArray{
    if (_pointArray == nil) {
        _pointArray = [NSMutableArray arrayWithCapacity:5];
    }
    return _pointArray;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
