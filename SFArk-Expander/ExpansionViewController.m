//
//  ViewController.m
//  SFArk Expander
//
//  Created by Rod Münch on 08/06/2015.
//  Copyright (c) 2015 Rod Münch. All rights reserved.
//

#import "ExpansionViewController.h"

@implementation ExpansionViewController

- (void)setRepresentedObject:(id)representedObject
{
  [super setRepresentedObject:representedObject];
}

- (void)expansionController:(ExpansionController *)controller didUpdateProgress:(float)progress
{
  [self.progress setIndeterminate:NO];
  [self.progress setDoubleValue:progress];
}

- (void)expansionController:(ExpansionController *)controller didReceiveMessage:(NSString *)message
{
  NSDictionary *attributes = @{NSFontAttributeName: [NSFont systemFontOfSize:[NSFont systemFontSize]],
                               NSForegroundColorAttributeName: [NSColor textColor]};
  static NSDateFormatter *timeFormatter = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateStyle:NSDateFormatterNoStyle];
    [timeFormatter setTimeStyle:NSDateFormatterMediumStyle];
  });
  message = [NSString stringWithFormat:@"%@ %@", [timeFormatter stringFromDate:[NSDate date]], message];
  NSAttributedString *attributedMessage = [[NSAttributedString alloc] initWithString:[message stringByAppendingString:@"\n"]
                                                                          attributes:attributes];
  [self.logText.textStorage insertAttributedString:attributedMessage
                                           atIndex:0];
}

@end
