//
//  SFArk_Expander_Tests.m
//  SFArk-Expander Tests
//
//  Created by Simon Lawrence on 11/06/2015.
//  Copyright (c) 2015 Rod Münch. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "ExpansionController.h"

@interface SFArk_Expander_Tests : XCTestCase<ExpansionControllerDelegate> {
  ExpansionController *_expansionController;
  XCTestExpectation *_expansionComplete;
}

@end

@implementation SFArk_Expander_Tests

- (void)expansionController:(ExpansionController *)controller didUpdateProgress:(float)progress
{
  NSLog(@"Progress -> %f %%", progress);
  if (progress == 100.0) {
    [_expansionComplete fulfill];
  }
}

- (void)expansionController:(ExpansionController *)controller didReceiveMessage:(NSString *)message
{
  NSLog(@"%@", message);
}

- (void)setUp
{
  [super setUp];
  
  _expansionController = [[ExpansionController alloc] init];
  _expansionController.delegate = self;
}

- (void)tearDown {
  _expansionController = nil;
  
  [super tearDown];
}

- (NSArray *)sourceURLs
{
  NSMutableArray *result = [NSMutableArray array];
  
  [result addObjectsFromArray:[[NSBundle bundleForClass:[self class]] URLsForResourcesWithExtension:@"sfArk"
                                                                                       subdirectory:nil]];
  [result addObjectsFromArray:[[NSBundle bundleForClass:[self class]] URLsForResourcesWithExtension:@"sfark"
                                                                                       subdirectory:nil]];
  
  return [result copy];
}

- (void)expandFileWithURL:(NSURL *)sourceURL
{
  NSString *outputFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
  XCTAssertNotNil(outputFolder);
  
  NSString *sourceFileName = [[sourceURL lastPathComponent] stringByDeletingPathExtension];
  
  NSURL *comparisonURL = [[NSBundle bundleForClass:[self class]] URLForResource:sourceFileName
                                                                  withExtension:@"sf2"];
  XCTAssertNotNil(comparisonURL);
  
  if (!comparisonURL)
    return;
  
  NSString *outputFilename = [[[[sourceURL path] lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"sf2"];
  NSString *outputPath = [outputFolder stringByAppendingPathComponent:outputFilename];
  
  NSURL *targetURL = [NSURL fileURLWithPath:outputPath];
  XCTAssertNotNil(outputPath);
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:[targetURL path]]) {
    XCTAssertTrue([[NSFileManager defaultManager] removeItemAtURL:targetURL
                                                            error:nil]);
  }
  
  _expansionComplete = [self expectationWithDescription:@"Decompression complete."];
  
  [_expansionController decompressArchiveAtURL:sourceURL
                                         toURL:targetURL];
  
  
  [self waitForExpectationsWithTimeout:240.0
                               handler:^(NSError *error) {
    if (error) {
      NSLog(@"%@", [error localizedDescription]);
      XCTFail(@"Expansion did not complete.");
    }
  }];
  
  NSData *decompressedData = [NSData dataWithContentsOfURL:targetURL];
  NSData *comparisonData = [NSData dataWithContentsOfURL:comparisonURL];
  XCTAssertNotNil(decompressedData);
  XCTAssertNotNil(comparisonData);
  
  XCTAssertEqualObjects(decompressedData, comparisonData);
}

- (void)testExpansion
{
  NSArray *sourceURLs = [self sourceURLs];
  XCTAssertNotNil(sourceURLs);
  XCTAssert([sourceURLs count] > 0);
  
  // NSURL *sourceURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"Blanchet-1720"
  //                                                             withExtension:@"sfArk"];
  for (NSURL *sourceURL in sourceURLs) {
    XCTAssertNotNil(sourceURL);
    
    [self expandFileWithURL:sourceURL];
  }
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
