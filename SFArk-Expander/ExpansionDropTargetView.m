//
//  ExpansionDropTargetView.m
//  SFArk-Expander
//
//  Created by Rod Münch on 08/06/2015.
//  Copyright (c) 2015 Rod Münch. All rights reserved.
//

#import "ExpansionDropTargetView.h"
#import "ExpansionController.h"

@implementation ExpansionDropTargetView

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  
  if (self) {
    [self registerForDraggedTypes:@[NSFilenamesPboardType]];
  }
  
  return self;
}

- (id)initWithFrame:(NSRect)frameRect
{
  self = [super initWithFrame:frameRect];
  
  if (self) {
    [self registerForDraggedTypes:@[NSFilenamesPboardType]];
  }
  
  return self;
}

- (NSDragOperation)draggingEntered:(id)sender
{
  NSPasteboard *pboard;
  NSDragOperation sourceDragMask;
  
  sourceDragMask = [sender draggingSourceOperationMask];
  pboard = [sender draggingPasteboard];
  
  if ([[pboard types] containsObject:NSFilenamesPboardType] ) {
    if (sourceDragMask & NSDragOperationCopy) {
      return NSDragOperationCopy;
    }
  }
  
  return NSDragOperationNone;
}

- (BOOL)prepareForDragOperation:(id)sender
{
  return YES;
}

- (BOOL)performDragOperation:(id)sender
{
  NSPasteboard *pasteboard = [sender draggingPasteboard];
  NSString *desiredType = [pasteboard availableTypeFromArray:@[NSFilenamesPboardType]];
  
  if ([desiredType isEqualToString:NSFilenamesPboardType]) {
    NSArray *filenamesArray = [pasteboard propertyListForType:NSFilenamesPboardType];
    for (NSString *path in filenamesArray) {
      if ([[path pathExtension] localizedCaseInsensitiveCompare:@"sfark"] != NSOrderedSame)
        continue;
      
      NSURL *sourceURL = [NSURL fileURLWithPath:path];
      NSString *destinationRootPath = [path stringByDeletingPathExtension];
      NSString *destinationPath = [destinationRootPath stringByAppendingPathExtension:@"sf2"];
      NSInteger destinationFileNumber = 1;
      while ([[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        destinationPath = [[NSString stringWithFormat:@"%@-%ld", destinationRootPath, (long)destinationFileNumber] stringByAppendingPathExtension:@"sf2"];
        ++destinationFileNumber;
      }
      
      NSURL *destinationURL = [NSURL fileURLWithPath:destinationPath];
      
      [_expansionController decompressArchiveAtURL:sourceURL
                                             toURL:destinationURL];
    }
    
    return YES;
  }
  
  return NO;
}


- (void)concludeDragOperation:(id)sender
{
  [self setNeedsDisplay:YES];
}


@end
