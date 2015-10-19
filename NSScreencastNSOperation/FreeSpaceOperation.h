//
//  FreeSpaceOperation.h
//  NSScreencastNSOperation
//
//  Created by Colin Smith on 10/18/15.
//  Copyright © 2015 Colin Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FreeSpaceOperation : NSOperation

@property (strong, nonatomic) NSDictionary *fileSystemAttributes;

- (instancetype)initWithPath:(NSString *)path;

@end
