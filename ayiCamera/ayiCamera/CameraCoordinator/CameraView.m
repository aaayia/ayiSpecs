//
//  JHCameraView.m
//  CustomCamera
//
//  Created by 章正义 on 15/10/20.
//  Copyright (c) 2015年 ayi. All rights reserved.
//

#import "CameraView.h"
#define JHCameraViewW 60


@interface CameraView ()
/**
 *  画线
 */
@property (strong, nonatomic) CADisplayLink *link;
/**
 *  画线次数
 */
@property (assign, nonatomic) NSInteger time;
/**
 *  点击的点
 */
@property (assign, nonatomic) CGPoint point;

/**
 *  是否点击
 */
@property (assign, nonatomic) BOOL isPlayerEnd;


@end

@implementation CameraView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if ( self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (CADisplayLink *)link{
    if (!_link) {
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshView:)];
    }
    return _link;
}
/**
 *  刷新IU
 */
- (void) refreshView : (CADisplayLink *) link{
    [self setNeedsDisplay];
    self.time++;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (self.isPlayerEnd) return;
    
    self.isPlayerEnd = YES;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    self.point = point;
    
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    if ([self.delegate respondsToSelector:@selector(cameraDidSelected:)]) {
        [self.delegate cameraDidSelected:self];
    }
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (self.isPlayerEnd) {
        CGFloat rectValue = JHCameraViewW - self.time % JHCameraViewW;
        
        CGRect rectangle = CGRectMake(self.point.x - rectValue / 2.0, self.point.y - rectValue / 2.0, rectValue, rectValue);
        //获得上下文句柄
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        if (rectValue <= 30) {
            self.isPlayerEnd = NO;
            [self.link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            self.link = nil;
            self.time = 0;
            
            CGContextClearRect(currentContext, rectangle);
            
        }else{
            //创建图形路径句柄
            CGMutablePathRef path = CGPathCreateMutable();
            //设置矩形的边界
            //添加矩形到路径中
            CGPathAddRect(path,NULL, rectangle);
            //添加路径到上下文中
            CGContextAddPath(currentContext, path);
            
            //    //填充颜色
            [[UIColor colorWithRed:0.20f green:0.60f blue:0.80f alpha:0] setFill];
            //设置画笔颜色
            [[UIColor yellowColor] setStroke];
            //设置边框线条宽度
            CGContextSetLineWidth(currentContext,1.0f);
            //画图
            CGContextDrawPath(currentContext, kCGPathFillStroke);
            /* 释放路径 */
            CGPathRelease(path);
        }
        
    }
    
}

@end
