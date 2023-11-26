//
//  ExpansionController.h
//  SFArk-Expander
//
//  Created by Rod Münch on 08/06/2015.
//  Copyright (c) 2015 Rod Münch. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ExpansionControllerDelegate;

@interface ExpansionController : NSObject

@property (nonatomic, assign) float progress;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, weak) IBOutlet id<ExpansionControllerDelegate> delegate;

- (void)decompressArchiveAtURL:(NSURL *)inputURL toURL:(NSURL *)outputURL;

+ (void)decompressFiles:(NSArray *)filenames;

@end

@protocol ExpansionControllerDelegate<NSObject>

- (void)expansionController:(ExpansionController *)controller didUpdateProgress:(float)progress;
- (void)expansionController:(ExpansionController *)controller didReceiveMessage:(NSString *)message;

@end