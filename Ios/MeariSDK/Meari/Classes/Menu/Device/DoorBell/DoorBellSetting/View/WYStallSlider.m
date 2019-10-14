//
//  WYStallSlider.m
//  Meari
//
//  Created by FMG on 2017/7/27.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYStallSlider.h"

@interface WYStallSlider ()
@property (nonatomic, assign) NSInteger stallNum;
@property (nonatomic, assign) float sliderMinimumValue;
@property (nonatomic, assign) float sliderMaximumValue;
@property (nonatomic, strong) NSMutableArray *dots;
@property (nonatomic, strong) NSMutableArray *dotContents;
@property (nonatomic, assign) NSInteger selectedStall;


@end

@implementation WYStallSlider


- (instancetype)initWithFrame:(CGRect)frame stallNum:(NSInteger)stallNum selectedStall:(NSInteger)selectedStall;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.stallNum = stallNum;
        self.selectedStall = selectedStall;
        [self addTarget:self action:@selector(valueChangeWithDrag:) forControlEvents:UIControlEventValueChanged];
        [self addTarget:self action:@selector(valueDidFinishedChange:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToSelect:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

//点击选档
- (void)tapToSelect:(UIGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    [self selectStallWithPoint:point Invocation:YES];
}
//拖拽选档
- (void)valueDidFinishedChange:(UISlider *)slider {
    CGRect viewRect = self.subviews[0].frame;
    CGPoint currentPoint = CGPointMake(viewRect.origin.x, viewRect.origin.y);
    [self selectStallWithPoint:currentPoint Invocation:YES];
}

- (void)selectStallWithPoint:(CGPoint)currentPoint Invocation:(BOOL)invocation {
    for (int i=0; i<self.dotContents.count; i++) {
        NSValue *value = self.dotContents[i];
        CGRect rect = value.CGRectValue;
        BOOL contains = CGRectContainsPoint(rect, currentPoint);
        if (contains) {
            NSInteger index = [self.dotContents indexOfObject:value];
            [self setValue:index/(self.stallNum-1.0) animated:YES];
            self.selectedStall = index +1;
            if (invocation) {
                if ([self.delegate respondsToSelector:@selector(stallSlider:didSelectedStall:)]) {
                    [self.delegate stallSlider:self didSelectedStall:index +1];
                }
            }
            [self valueChangeWithDrag:self];
        }
    }

}

//时时改变
- (void)valueChangeWithDrag:(UISlider *)slider {
    for (UILabel *view in self.dots) {
        if (view.x > self.width * self.value) {
            view.backgroundColor = WY_FontColor_Gray2;
        } else {
            view.backgroundColor = WY_MainColor;
        }
    }

}

- (void)setSliderSelectWithStall:(NSInteger)stall {
    if (stall<=0) return;
    NSValue *value = self.dotContents[stall -1];
    CGPoint point = value.CGRectValue.origin;
    [self selectStallWithPoint:point Invocation:NO];
}


- (void)setInit {
    self.dotContents = [NSMutableArray array];
    for (int i=0; i<self.stallNum; i++) {
        CGRect rect = CGRectMake((i*2 - 1) * self.width/(2*self.stallNum -2.0), self.subviews[0].y * 0.5 ,2.0 * self.width/(2*self.stallNum -2.0), self.subviews[0].y);
        [self.dotContents addObject:[NSValue valueWithCGRect:rect]];
    }
    
    CGFloat drawX ;
    CGFloat drawW = 8.0f;
    CGFloat drawH = drawW;
    self.dots = [NSMutableArray array];
    for (int i=0; i<self.stallNum; i++) {
        if (i==0) {
            drawX = 1;
        } else if(i == self.stallNum -1) {
            drawX = (CGFloat)self.width - drawW -1.5;
        } else {
            drawX = (CGFloat)self.width*i/(self.stallNum-1) - drawW/2.0;
        }
        UILabel *dot = [[UILabel alloc] initWithFrame:CGRectMake(drawX, self.height * 0.5 - drawW/2.0, drawW, drawH)];
        if (drawX > self.width * self.value) {
            dot.backgroundColor = WY_FontColor_Gray2;
        } else {
            dot.backgroundColor = WY_MainColor;
        }
        dot.userInteractionEnabled = NO;
        dot.layer.cornerRadius = drawW/2.0;
        dot.layer.masksToBounds = YES;
        [self.dots addObject:dot];
        [self insertSubview:dot atIndex:2];
    }
    [self setSliderSelectWithStall:self.selectedStall];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self setInit];

}



@end
