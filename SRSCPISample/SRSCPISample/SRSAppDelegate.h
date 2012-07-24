//
//  SRSAppDelegate.h
//  SRSCPISample
//
//  Created by Cameron Hotchkies on 7/24/12.
//  Copyright (c) 2012 Srs Biznas, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SRSColorProgressIndicatorView.h"

@interface SRSAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet SRSColorProgressIndicatorView* progress;
@property (assign) IBOutlet NSColorWell* colorWell;
@property (assign) IBOutlet NSButton* startStopButton;

- (IBAction)startStopClicked:(id)sender;
- (IBAction)colorChanged:(id)sender;

@end
