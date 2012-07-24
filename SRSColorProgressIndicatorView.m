//
//  SRSColorProgressIndicatorView.m
//
//  Created by Cameron Hotchkies on 7/22/12.
//  Copyright (c) 2012 Srs Biznas, LLC. All rights reserved.
//
//  based on AMIndeterminateProgressIndicatorCell
//  Copyright 2007 Andreas Mayer. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "SRSColorProgressIndicatorView.h"

#define ConvertAngle(a) (fmod((90.0-(a)), 360.0))

#define DEG2RAD  0.017453292519943295

@interface SRSColorProgressIndicatorView ()
    
- (CALayer*)generateSpinnerLayerForIndex:(NSInteger)index;

@end

@implementation SRSColorProgressIndicatorView

@synthesize animationDelay, animationTimer;
@synthesize isSpinning, displayedWhenStopped;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        CALayer* mainLayer = [CALayer layer];
        
        [mainLayer setDelegate:self];
        [self setLayer:mainLayer];
        [self setWantsLayer:YES];
        layerIndex = 0;
        
        [self setAnimationDelay:5.0/60.0];
		[self setDisplayedWhenStopped:NO];
//		[self setDoubleValue:0.0];
		[self setColor:[NSColor blackColor]];
        

        // Init to NO, otherwise it can flash on/off
        self.isSpinning = NO;
    }
    
    return self;
}

-(void)animate:(NSTimer *)aTimer
{
    [[self.layer.sublayers objectAtIndex:layerIndex] setOpacity:0];
    [[self.layer.sublayers objectAtIndex:layerIndex] setNeedsDisplay];

    layerIndex += 1;
    if (layerIndex >= 30)
    {
        layerIndex = 0;
    }
    
    [[self.layer.sublayers objectAtIndex:layerIndex] setOpacity:1];
    //[[self.layer.sublayers objectAtIndex:layerIndex] setNeedsDisplay];
    [self.layer setNeedsDisplay];
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (self.isSpinning)
    {
        // Drawing code here.
        [self drawInteriorWithFrame:self.frame inView:self];
    }
    
    NSArray* sl = self.layer.sublayers;
    for (CALayer* cl in sl)
    {
        [cl setNeedsDisplay];
    }
}

- (NSColor*)color
{
    return color;
}

- (void)setColor:(NSColor *)value
{
	CGFloat alphaComponent;
	if (self.color != value) 
    {
		color = value;
		[[color colorUsingColorSpaceName:@"NSCalibratedRGBColorSpace"] 
         getRed:&redComponent 
         green:&greenComponent 
         blue:&blueComponent 
         alpha:&alphaComponent];
        
		NSAssert((alphaComponent > 0.999), @"color must be opaque");
        
        if ([self.layer.sublayers count] > 0)
        {
            self.layer.sublayers = nil; 
        }
        
        for (int i=0; i < 30; i++)
        {
            CALayer* thisLayer = [self generateSpinnerLayerForIndex:i];
            [self.layer addSublayer:thisLayer];
        }
	}
}

- (BOOL)isSpinning
{
    return isSpinning;
}

- (void)setIsSpinning:(BOOL)value
{
    isSpinning = value;
    
    if (value == YES)
    {
        layerIndex = 0;
        self.layer.hidden = NO;
        for (CALayer* slayer in self.layer.sublayers)
        {
            slayer.opacity = 0;
            //            [slayer setNeedsDisplay];
        }
        [self.layer setNeedsDisplay];
        
        if (self.animationTimer == nil || [self.animationTimer isValid] == NO)
        {
            self.animationTimer =
                [NSTimer scheduledTimerWithTimeInterval:self.animationDelay 
                                                 target:self 
                                               selector:@selector(animate:) 
                                               userInfo:NULL 
                                                repeats:YES];
            
            // keep running while menu is open
            [[NSRunLoop currentRunLoop] addTimer:animationTimer forMode:NSEventTrackingRunLoopMode];
        }
    }
    else 
    {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
        self.layer.hidden = YES;
        [self.layer setNeedsDisplay];
        for (CALayer* slayer in self.layer.sublayers)
        {
            slayer.opacity = 0;
//            [slayer setNeedsDisplay];
        }
    }
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	// cell has no border
	[self drawInteriorWithFrame:cellFrame inView:controlView];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    
}

- (CALayer*)generateSpinnerLayerForIndex:(NSInteger)index;
{
    CALayer* retVal = [[CALayer alloc] init];
    
    retVal.delegate = self;
    retVal.needsDisplayOnBoundsChange=YES;
    [retVal setOpacity:0];
    
//    [retVal setNeedsDisplay];

    return retVal;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    NSGraphicsContext *nsGraphicsContext;
    nsGraphicsContext = [NSGraphicsContext graphicsContextWithGraphicsPort:ctx
                                                                   flipped:NO];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:nsGraphicsContext];
    
    float flipFactor = -1;//([controlView isFlipped] ? 1.0 : -1.0);
    int step = layerIndex;
    float cellSize = MIN(self.frame.size.width, self.frame.size.height);
    NSPoint center = CGPointZero;//cellFrame.origin;
    
    center.x += cellSize/2.0;
    center.y += self.frame.size.height/2.0;
    float outerRadius;
    float innerRadius;
    float strokeWidth = cellSize*0.08;
    
    if (cellSize >= 32.0) 
    {
        outerRadius = cellSize*0.38;
        innerRadius = cellSize*0.23;
    }
    else 
    {
        outerRadius = cellSize*0.48;
        innerRadius = cellSize*0.27;
    }
    
    float a; // angle
    NSPoint inner;
    NSPoint outer;
    // remember defaults
    NSLineCapStyle previousLineCapStyle = [NSBezierPath defaultLineCapStyle];
    float previousLineWidth = [NSBezierPath defaultLineWidth]; 
    // new defaults for our loop
    [NSBezierPath setDefaultLineCapStyle:NSRoundLineCapStyle];
    [NSBezierPath setDefaultLineWidth:strokeWidth];
    
    if ([self isSpinning]) 
    {
        a = (270+(step* 30))*DEG2RAD;
    } 
    else
    {
        a = 270*DEG2RAD;
    }
    
    a = flipFactor*a;
    int i;
    
    for (i = 0; i < 12; i++) 
    {
        [[NSColor colorWithCalibratedRed:redComponent 
                                   green:greenComponent
                                    blue:blueComponent 
                                   alpha:1.0-sqrt(i)*0.25] set];
        outer = NSMakePoint(center.x+cos(a)*outerRadius, 
                            center.y+sin(a)*outerRadius);
        inner = NSMakePoint(center.x+cos(a)*innerRadius, 
                            center.y+sin(a)*innerRadius);
        
        [NSBezierPath strokeLineFromPoint:inner toPoint:outer];
        a -= flipFactor*30*DEG2RAD;
    }
    
    // restore previous defaults
    [NSBezierPath setDefaultLineCapStyle:previousLineCapStyle];
    [NSBezierPath setDefaultLineWidth:previousLineWidth];
    
    [NSGraphicsContext restoreGraphicsState];
}

- (void)setObjectValue:(id)value
{
	if ([value respondsToSelector:@selector(boolValue)]) 
    {
        self.isSpinning = [value boolValue];
	}
    else 
    {
        self.isSpinning = NO;
	}
}




@end
