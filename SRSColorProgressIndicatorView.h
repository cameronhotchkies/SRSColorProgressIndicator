//
//  SRSColorProgressIndicatorView.h
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


#import <Cocoa/Cocoa.h>

@interface SRSColorProgressIndicatorView : NSView
{
	//double doubleValue;
    NSInteger layerIndex;
	NSTimeInterval animationDelay;
	BOOL displayedWhenStopped;
	BOOL isSpinning;
	NSColor *color;
	CGFloat redComponent;
	CGFloat greenComponent;
	CGFloat blueComponent;
    NSTimer *animationTimer;
}

@property (retain) NSColor* color;
@property (retain) NSTimer* animationTimer;
//@property (assign) double doubleValue;
@property (assign) NSTimeInterval animationDelay;
@property (assign) BOOL isSpinning;
@property (assign) BOOL displayedWhenStopped;

@end
