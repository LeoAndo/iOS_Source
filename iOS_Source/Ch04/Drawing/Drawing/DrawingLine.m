//
//  DrawingLine.m
//  Drawing
//
//  Created by Ryosuke Sasaki on 2013/05/19.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import "DrawingLine.h"

@implementation DrawingLine

- (UIBezierPath *)bezierPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.beginPoint];
    [path addLineToPoint:self.endPoint];
    
    return path;
}

- (BOOL)containsPoint:(CGPoint)point
{
    CGFloat acceptableDistance = 10.0f;
    
    CGRect acceptableBounds = CGRectInset(self.bounds, -acceptableDistance, -acceptableDistance);
    if (!CGRectContainsPoint(acceptableBounds, point))
        return NO;
    
    CGPoint beginPoint = self.beginPoint;
    CGPoint endPoint = self.endPoint;
    
    if (endPoint.x - beginPoint.x == 0.0f)
        return YES;
    
    CGFloat slope = (endPoint.y - beginPoint.y) / (endPoint.x - beginPoint.x);
    if (ABS(((point.x - beginPoint.x) * slope) - (point.y - beginPoint.y)) <= acceptableDistance)
        return YES;
    
    return NO;
}

- (void)draw
{
    UIBezierPath *path = [self bezierPath];
    path.lineWidth = self.strokeWidth;
    [self.strokeColor setStroke];
    [path stroke];
}

@end