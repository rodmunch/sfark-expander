//
//  ExpansionDropTargetView.h
//  SFArk-Expander
//
//  Created by Rod Münch on 08/06/2015.
//  Copyright (c) 2015 Rod Münch. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ExpansionController;

@interface ExpansionDropTargetView : NSView

@property (nonatomic, weak) IBOutlet ExpansionController *expansionController;

@end
