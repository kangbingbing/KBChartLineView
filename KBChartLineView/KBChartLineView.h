//
//  KBChartLineView.h
//  KBChartLineView
//
//  Created by iMac on 2018/2/28.
//  Copyright © 2018年 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KBChartLineView : UIView

/** 折线点数据 */
@property (nonatomic, strong) NSArray *dataValues;

/** X轴数据 */
@property (nonatomic, strong) NSArray *xValues;

/** Y轴数据 */
@property (nonatomic, strong) NSArray *yValues;

/** 是否可以点击 */
@property (nonatomic, assign) BOOL enableTouch;


@end
