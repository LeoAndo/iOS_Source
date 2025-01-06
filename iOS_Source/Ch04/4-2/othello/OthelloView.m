//
//  OthelloView.m
//  othello
//
//  Created by Yoshitaka Yamashita on 3/16/14.
//  Copyright (c) 2014 Yoshitaka Yamashita. All rights reserved.
//

#import "OthelloView.h"

@implementation OthelloView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat cellWidth = width / 8;
    CGFloat cellHeight = height / 8;
	
    // 背景を描写
    CGContextSaveGState(context);
    {
        // 背景色を緑に設定
        CGContextSetRGBFillColor(context, 0, 1, 0, 1);
        // 背景を塗り潰す
        CGContextFillRect(context, rect);
    }
    CGContextRestoreGState(context);
	
	
    // 盤面の線を描写
    CGContextSaveGState(context);
    {
        // 線の色を黒に設定
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
        
        // 縦線をパスに追加
        for (NSInteger x = 0; x < 9; x++) {
            CGContextMoveToPoint(context, x * cellWidth, 0);
            CGContextAddLineToPoint(context, x * cellWidth, height);
        }
        
        // 横線をパスに追加
        for (NSInteger y = 0; y < 9; y++) {
            CGContextMoveToPoint(context, 0, y * cellHeight);
            CGContextAddLineToPoint(context, width, y * cellHeight);
        }
        
        // 線を描写
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
	
	
    // 初期の黒石を描写
    CGContextSaveGState(context);
    {
        // 塗り潰しの色を黒に設定
        CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
        
        [self addStonePathWithContext:context cellWidth:cellWidth cellHeight:cellHeight x:4 y:3];
        [self addStonePathWithContext:context cellWidth:cellWidth cellHeight:cellHeight x:3 y:4];
        
        // 黒石を描写
        CGContextFillPath(context);
    }
    CGContextRestoreGState(context);
	
    // 初期の白石を描写
    CGContextSaveGState(context);
    {
        // 塗り潰しの色を白に設定
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        
        [self addStonePathWithContext:context cellWidth:cellWidth cellHeight:cellHeight x:3 y:3];
        [self addStonePathWithContext:context cellWidth:cellWidth cellHeight:cellHeight x:4 y:4];
        
        // 黒石を描写
        CGContextFillPath(context);
    }
    CGContextRestoreGState(context);
}

- (void)addStonePathWithContext:(CGContextRef)context cellWidth:(CGFloat)cellWidth cellHeight:(CGFloat)cellHeight x:(NSInteger)x y:(NSInteger)y
{
    CGRect rect = CGRectMake(cellWidth * x, cellHeight * y, cellWidth, cellHeight);
    CGFloat horizontalInset = cellWidth * 0.05;
    CGFloat verticalInset = cellHeight * 0.05;
	
    CGContextAddEllipseInRect(context, CGRectInset(rect, horizontalInset, verticalInset));
}

@end
