//
//  AppDelegate.m
//  SFArk Expander
//
//  Created by Rod Münch on 08/06/2015.
//  Copyright (c) 2015 Rod Münch. All rights reserved.
//

#import "AppDelegate.h"
#import "ExpansionController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
  // Insert code here to tear down your application
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames
{
  [ExpansionController decompressFiles:filenames];
}

@end
