//
//  WYCalendarCell.m
//  Meari
//
//  Created by 李兵 on 16/8/3.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCalendarCell.h"
#import "WYCalendarModel.h"

@interface WYCalendarCell ()
{
    UILabel *_label;
}

@end

@implementation WYCalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        int w = MIN(frame.size.width, frame.size.height);
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.size = CGSizeMake(w, w);
        label.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        label.layer.cornerRadius = w/2.0;
        label.layer.masksToBounds = YES;
        label.font = WYFont_Text_S_Normal;
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _label = label;
    }
    return self;
}

- (void)clickAction:(UIButton *)sender {
    
}


- (void)setModel:(WYCalendarModel *)model {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat"
    _label.text = [NSString stringWithFormat:@"%ld", model.date.day];
#pragma clang diagnostic pop
    UIColor *color = model.uistytle == WYUIStytleOrange ? WY_FontColor_DarkOrange : WY_FontColor_Cyan;
    _label.textColor = model.hasVideo ? color : [UIColor lightGrayColor];
    
    if (model.isSelected) {
        _label.textColor = [UIColor whiteColor];
        _label.backgroundColor = color;
    }else {
        _label.backgroundColor = [UIColor clearColor];
    }
    
}



@end
