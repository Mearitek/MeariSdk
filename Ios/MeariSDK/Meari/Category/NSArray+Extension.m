//
//  NSArray+Extension.m
//  Meari
//
//  Created by 李兵 on 16/7/7.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)

- (CGFloat)wy_maxWidthWithFont:(UIFont *)font {
    CGFloat maxWidth = 0;
    for (id obj in self) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *string = (NSString *)obj;
            CGSize titleSize = [string sizeWithAttributes:@{NSFontAttributeName:font}];
            maxWidth = MAX(titleSize.width, maxWidth);
        }
    }
    return maxWidth;
}



@end


@implementation NSMutableArray (Extension)
+ (void)load {
    WY_ExchangeInstanceImp(@selector(removeObject:), @selector(wy_removeObject:));
}
- (void)wy_removeObject:(id)anObject {
    if (anObject && [self containsObject:anObject]) {
        [self wy_removeObject:anObject];
    }
}
@end

