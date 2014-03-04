//
//  SYAddScoreView.h
//  
//
//  Created by ljh on 14-3-3.
//  Copyright (c) 2014年 linggan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKAddScoreView : UIImageView
+(instancetype)shareInstance;

@property(strong,nonatomic)UILabel* lb_message;
@property(strong,nonatomic)UILabel* lb_sub;


-(void)showMessage:(NSString*)message subMes:(NSString*)subMes fromScore:(float)from toScore:(float)to;
-(void)dismiss;
@end
