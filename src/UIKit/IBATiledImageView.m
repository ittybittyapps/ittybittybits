//
//  IBATiledImageView.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 31/07/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "IBATiledImageView.h"
#import "../Foundation/IBAFoundation.h"

@implementation IBATiledImageView

IBA_SYNTHESIZE(dataSource, tiledLayer);

+ (Class)layerClass
{
    return [CATiledLayer class];
}

- (CATiledLayer *)tiledLayer
{
    return (CATiledLayer *)self.layer;
}

- (CGFloat)contentScaleFactor
{
    return 1.0;
}

- (void)setContentScaleFactor:(CGFloat)IBA_UNUSED contentScaleFactor
{
    // To handle the interaction between CATiledLayer and high resolution screens, we need to manually set the tiling view's contentScaleFactor to 1.0. (If we omitted this, it would be 2.0 on high resolution screens, which would cause the CATiledLayer to ask us for tiles of the wrong scales.)

    [super setContentScaleFactor:1.0];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGContextGetCTM(context);
    CGFloat scale = transform.a;

    CGSize tileSize = self.tiledLayer.tileSize;
    
    // Scale the tileSize by the current scale factor.
    tileSize.width /= scale;
    tileSize.height /= scale;
    
    NSInteger firstCol = (NSInteger)floorf(CGRectGetMinX(rect) / tileSize.width);
    NSInteger lastCol  = (NSInteger)floorf((CGRectGetMaxX(rect)-1) / tileSize.width);
    NSInteger firstRow = (NSInteger)floorf(CGRectGetMinY(rect) / tileSize.height);
    NSInteger lastRow  = (NSInteger)floorf((CGRectGetMaxY(rect)-1) / tileSize.height);
    
    
    for (NSInteger row = firstRow; row <= lastRow; ++row) 
    {
        for (NSInteger col = firstCol; col <= lastCol; ++col)
        {
            CGRect tileRect = CGRectMake(tileSize.width * col, tileSize.height * row, tileSize.width, tileSize.height);
            // Truncate the tileRect so that it does not exceed the view bounds rect (if we didn't do this some of the tiled images would be stretched.
            tileRect = CGRectIntersection(self.bounds, tileRect);
            
            
            UIImage *tile = [self.dataSource tileForView:self 
                                                   scale:scale 
                                                     row:row 
                                                  column:col];
            [tile drawInRect:tileRect];
            
#if 0
            [[UIColor whiteColor] set];
            CGContextSetLineWidth(context, 6.0 / scale);
            CGContextStrokeRect(context, tileRect);
#endif
        }
    }
}

@end
