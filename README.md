AddScore
========

ios simple animation demo

animation layer using CAShapeLayer
```objective-c
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

```

![](http://img.blog.csdn.net/20140304092836859)
