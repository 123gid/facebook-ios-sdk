// Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <XCTest/XCTest.h>

#import "FBSDKCoreKit+Internal.h"

@interface FBSDKLibAnalyzer ()

+ (NSArray<NSString *> *)_getClassNames:(NSArray<NSString *> *)prefixes
                             frameworks:(NSArray<NSString *> *)frameworks;
+ (NSString *)_getAddress:(NSString *)callstackEntry;

@end

@interface FBSDKLibAnalyzerTests : XCTestCase
@end

@implementation FBSDKLibAnalyzerTests

- (void)setUp
{
  [super setUp];

  [FBSDKLibAnalyzer initialize];
}

- (void)testGetMethodsTableFromPrefixesAndFrameworks
{
  NSArray<NSString *> *prefixes = @[@"FBSDK", @"_FBSDK"];
  NSArray<NSString *> *frameworks = @[@"FBSDKCoreKit",
                                      @"FBSDKLoginKit",
                                      @"FBSDKShareKit",
                                      @"FBSDKTVOSKit"];
  NSDictionary *result = [FBSDKLibAnalyzer.class getMethodsTable:prefixes frameworks:frameworks];
  XCTAssertTrue(result.count > 0, "Should find at least one method declared in the provided frameworks");
}

- (void)testGetAddress
{
  NSString *callstackEntry = @"0 CoreFoundation 0x0000000104cbd02e __exceptionPreprocess + 350";
  NSString *result1 = [FBSDKLibAnalyzer _getAddress:callstackEntry];
  XCTAssertTrue([result1 isEqualToString:@"0x0000000104cbd02e"]);

  callstackEntry = @"0 CoreFoundation 0000000104cbd02e __exceptionPreprocess + 350";
  NSString *result2 = [FBSDKLibAnalyzer _getAddress:callstackEntry];
  XCTAssertNil(result2);
}

@end
