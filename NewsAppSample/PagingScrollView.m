//
//  PagingScrollView.m
//  NewsAppSample
//
//  Created by jun on 2014/11/16.
//  Copyright (c) 2014年 edu.self. All rights reserved.
//

#import "PagingScrollView.h"

@implementation PagingScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//[(UIView*)hitTest:withEvent:]をオーバーライドすることで、scrollView.bounds外のタッチイベントも受け取れるようになります。
//第一引数のpointはtouchPointですので、その位置にサブビュー(この場合はtableView)があればそれを返してあげることでレスボンダチェーンをtableViewに返すことが出来ます。
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    for (UIView *subview in self.subviews) {
        if (CGRectContainsPoint(subview.frame, point))
            return subview;
    }
    return self;
}




@end
