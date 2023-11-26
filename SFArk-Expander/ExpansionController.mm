//
//  ExpansionController.m
//  SFArk-Expander
//
//  Created by Rod Münch on 08/06/2015.
//  Copyright (c) 2015 Rod Münch. All rights reserved.
//

#import "ExpansionController.h"
#import "sfArkLib.h"

@interface ExpansionController() {
  dispatch_queue_t _expansionQueue;
}

@end

static ExpansionController *currentInstance;

#pragma mark - Extern functions from sfArkLib

void sfkl_msg(const char *MessageText, int Flags)
{
  if (currentInstance) {
    NSString *messageText = [[NSString alloc] initWithUTF8String:MessageText];
    [currentInstance setMessage:messageText];
  }
}

void sfkl_UpdateProgress(int ProgressPercent)
{
  if (currentInstance) {
    [currentInstance setProgress:(float)ProgressPercent];
  }
}

bool sfkl_GetLicenseAgreement(const char *LicenseText, const char *LicenseFileName)
{
  return true;
}

void sfkl_DisplayNotes(const char *NotesText, const char *NotesFileName)
{
  return;
}

@implementation ExpansionController

- (id)init
{
  self = [super init];
  
  if (self) {
    _expansionQueue = dispatch_queue_create("com.rodmunch.SFExpansionQueue", DISPATCH_QUEUE_SERIAL);
    
    currentInstance = self;
  }
  
  return self;
}

- (void)dealloc
{
  if (currentInstance == self) {
    currentInstance = nil;
  }
}

- (void)decompressArchiveAtURL:(NSURL *)inputURL toURL:(NSURL *)outputURL
{
  dispatch_async(_expansionQueue, ^{
    const char *inputFileName = [[[inputURL path] stringByStandardizingPath] fileSystemRepresentation];
    const char *outputFileName = [[[outputURL path] stringByStandardizingPath] fileSystemRepresentation];
    
    [self setMessage:[NSString stringWithFormat:@"Expanding %s...", inputFileName]];
    
    sfkl_Decode(inputFileName, outputFileName);
  });
}

+ (void)decompressFiles:(NSArray *)filenames
{
  if (!currentInstance)
    currentInstance = [[ExpansionController alloc] init];
  
  for (NSString *path in filenames) {
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
    
    [currentInstance decompressArchiveAtURL:sourceURL
                                      toURL:destinationURL];
  }
}

#pragma mark - Property setters

- (void)setProgress:(float)progress
{
  _progress = progress;
  
  if (!_delegate || ![_delegate respondsToSelector:@selector(expansionController:didUpdateProgress:)])
    return;
  
  dispatch_block_t updateBlock = ^{
    [_delegate expansionController:self
                 didUpdateProgress:progress];
  };
  if (![NSThread isMainThread]) {
    dispatch_sync(dispatch_get_main_queue(), updateBlock);
    return;
  }
  updateBlock();
}

- (void)setMessage:(NSString *)aMessage
{
  NSString *message = [aMessage copy];
  
  _message = message;
  
  if (!_delegate || ![_delegate respondsToSelector:@selector(expansionController:didReceiveMessage:)])
    return;
  
  dispatch_block_t updateBlock = ^{
    [_delegate expansionController:self
                 didReceiveMessage:message];
  };
  
  if (![NSThread isMainThread]) {
    dispatch_sync(dispatch_get_main_queue(), updateBlock);
    return;
  }
  
  updateBlock();
}

@end
