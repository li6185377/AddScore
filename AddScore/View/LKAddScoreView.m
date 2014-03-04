//
//  SYAddScoreView.m
//
//
//  Created by ljh on 14-3-3.
//  Copyright (c) 2014年 linggan. All rights reserved.
//

#import "LKAddScoreView.h"

#ifndef RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#endif

@interface LKAddScoreView()
@property(strong,nonatomic)CAShapeLayer* pregress;

@property float nowTo;
@property float nextTo;

@property BOOL isAnimationing;
@property BOOL hasTo;
@property BOOL fadeIn;
@property BOOL fadeOut;
@end

@implementation LKAddScoreView

+(instancetype)shareInstance
{
    static LKAddScoreView* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    });
    return instance;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"record_addscorer"];
        self.lb_message = [[UILabel alloc]initWithFrame:CGRectMake(17, 28, 60, 22)];
        _lb_message.font = [UIFont systemFontOfSize:16];
        _lb_message.textColor = RGBCOLOR(160,154,149);
        _lb_message.textAlignment = NSTextAlignmentCenter;
        _lb_message.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_lb_message];
        
        self.lb_sub = [[UILabel alloc]initWithFrame:CGRectMake(17, 50, 60, 20)];
        _lb_sub.font = [UIFont systemFontOfSize:14];
        _lb_sub.textColor = RGBCOLOR(255,135,160);
        _lb_sub.textAlignment = NSTextAlignmentCenter;
        _lb_sub.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_lb_sub];
        
        CAShapeLayer* pregress_bg = [[CAShapeLayer alloc]init];
        pregress_bg.frame = CGRectMake(15,18, 64,64);
        pregress_bg.lineWidth= 3;
        pregress_bg.fillColor= [UIColor colorWithWhite:0 alpha:0].CGColor;
        pregress_bg.strokeColor = [UIColor colorWithWhite:0.6 alpha:0.2].CGColor;
        pregress_bg.path = CGPathCreateWithEllipseInRect(pregress_bg.bounds, NULL);
        
        [self.layer addSublayer:pregress_bg];
        
        self.pregress = [[CAShapeLayer alloc]init];
        _pregress.frame = CGRectMake(15,18, 64,64);
        _pregress.lineWidth= 3;
        _pregress.fillColor= [UIColor colorWithWhite:0 alpha:0].CGColor;
        _pregress.strokeColor = RGBCOLOR(225,140,150).CGColor;
        _pregress.lineCap = @"round";
        _pregress.strokeStart = 0;
        _pregress.strokeEnd = 0;
        
        _pregress.path = CGPathCreateWithEllipseInRect(pregress_bg.bounds, NULL);
        _pregress.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        [self.layer addSublayer:_pregress];
    }
    return self;
}
-(void)startFrom:(float)from to:(float)to
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(from);
    animation.toValue = @(to);
    animation.duration = 1 * fabsf(to - from);
    animation.delegate  = self;

    _nowTo = to;
    _pregress.strokeEnd = to;
    [_pregress addAnimation:animation forKey:nil];
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(_hasTo)
    {
        _hasTo = NO;
        if(_nowTo != _nextTo)
        {
            [self startFrom:_nowTo to:_nextTo];
            return;
        }
    }
    else
    {
        [self performSelector:@selector(beginFadeOut) withObject:nil afterDelay:1];
    }
    _isAnimationing = NO;
}
-(void)beginFadeOut
{
    self.fadeOut = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    }];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.25];
}
-(void)dismiss
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(beginFadeOut) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    
    [self removeFromSuperview];
    _fadeOut = NO;
}
-(void)showMessage:(NSString *)message subMes:(NSString *)subMes fromScore:(float)from toScore:(float)to
{
    _lb_message.text = message;
    _lb_sub.text = subMes;
    
    if(_fadeOut){
        [self dismiss];
    }
    else{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(beginFadeOut) object:nil];
    }
    
    if(_fadeIn)
    {
        _nowTo = to;
    }
    else if(self.superview == nil)
    {
        _nextTo = 0;
        _hasTo = NO;
        _isAnimationing = NO;
        
        _nowTo = to;
        
        UIWindow* window = [LKAddScoreView getShowWindow];
        self.center = CGPointMake(window.bounds.size.width/2, window.bounds.size.height/2 - 50);
        self.alpha = 0;
        [window addSubview:self];
        
        _fadeIn = YES;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            self.fadeIn = NO;
            [self startFrom:from to:self.nowTo];
        }];
    }
    else if(_isAnimationing)
    {
        _nextTo = to;
        _hasTo = YES;
        return;
    }
    else{
        [self startFrom:from to:to];
    }
}

+(UIWindow*)getShowWindow
{
    UIWindow *window = nil;
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *uiWindow in windows)
    {
        //有inputView或者键盘时，避免提示被挡住，应该选择这个 UITextEffectsWindow 来显示
        if ([NSStringFromClass(uiWindow.class) isEqualToString:@"UITextEffectsWindow"])
        {
            window = uiWindow;
            break;
        }
    }
    if (!window)
    {
        window = [[UIApplication sharedApplication] keyWindow];
    }
    return window;
}
@end
