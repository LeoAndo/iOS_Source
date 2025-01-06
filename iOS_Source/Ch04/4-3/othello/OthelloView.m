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
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat cellWidth = width / 8;
    CGFloat cellHeight = height / 8;
    
    // 背景を描写
    [[UIColor greenColor] setFill];
    UIRectFill(rect);
    
    // 盤面の線を描写
    [[UIColor blackColor] setStroke];
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger x = 0; x < 9; x++) {
        [path moveToPoint:CGPointMake(x * cellWidth, 0)];
        [path addLineToPoint:CGPointMake(x * cellWidth, height)];
    }
    for (NSInteger y = 0; y < 9; y++) {
        [path moveToPoint:CGPointMake(0, y * cellHeight)];
        [path addLineToPoint:CGPointMake(width, y * cellHeight)];
    }
    [path stroke];
    
    // 初期の黒石を描写
    [[UIColor blackColor] setFill];
    path = [UIBezierPath bezierPath];
    [self appendStonePathToBezierPath:path cellWidth:cellWidth cellHeight:cellHeight x:4 y:3];
    [self appendStonePathToBezierPath:path cellWidth:cellWidth cellHeight:cellHeight x:3 y:4];
    [path fill];
    
    // 初期の白石を描写
    [[UIColor whiteColor] setFill];
    path = [UIBezierPath bezierPath];
    [self appendStonePathToBezierPath:path cellWidth:cellWidth cellHeight:cellHeight x:3 y:3];
    [self appendStonePathToBezierPath:path cellWidth:cellWidth cellHeight:cellHeight x:4 y:4];
    [path fill];
}

- (void)appendStonePathToBezierPath:(UIBezierPath *)path cellWidth:(CGFloat)cellWidth cellHeight:(CGFloat)cellHeight x:(NSInteger)x y:(NSInteger)y
{
    CGRect rect = CGRectMake(cellWidth * x, cellHeight * y, cellWidth, cellHeight);
    CGFloat horizontalInset = cellWidth * 0.05;
    CGFloat verticalInset = cellHeight * 0.05;
    
    CGRect stoneRect = CGRectInset(rect, horizontalInset, verticalInset);
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:stoneRect];
    
    [path appendPath:ovalPath];
}

@end
