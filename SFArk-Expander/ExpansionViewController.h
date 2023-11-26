//
//  ViewController.h
//  SFArk Expander
//
//  Created by Rod Münch on 08/06/2015.
//  Copyright (c) 2015 Rod Münch. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ExpansionController.h"

@interface ExpansionViewController : NSViewController<ExpansionControllerDelegate>

@property (nonatomic, weak) IBOutlet NSProgressIndicator *progress;
@property (nonatomic, strong) IBOutlet NSTextView *logText;

@property (nonatomic, strong) IBOutlet ExpansionController *expansionController;

@end

