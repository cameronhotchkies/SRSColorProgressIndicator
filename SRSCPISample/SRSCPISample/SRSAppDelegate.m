//
//  SRSAppDelegate.m
//  SRSCPISample
//
//  Created by Cameron Hotchkies on 7/24/12.
//  Copyright (c) 2012 Srs Biznas, LLC. All rights reserved.
//

#import "SRSAppDelegate.h"

@implementation SRSAppDelegate

@synthesize window = _window, progress, colorWell, startStopButton;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.startStopButton.tag = 0;
    colorWell.color = [NSColor blackColor];
}

- (void)startStopClicked:(id)sender
{
    NSButton* b = self.startStopButton;
    if (b.tag == 0)
    {
        progress.isSpinning = YES;
        b.tag = 1;
        b.title = @"Stop";
    }
    else 
    {
        progress.isSpinning = NO;
        b.tag = 0;
        b.title = @"Start";
    }
}


- (IBAction)colorChanged:(id)sender
{
    // Set the spinner color to match the colorwell
    self.progress.color = colorWell.color;
}


@end
