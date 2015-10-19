//
//  FreeSpaceOperation.m
//  NSScreencastNSOperation
//
//  Created by Colin Smith on 10/18/15.
//  Copyright © 2015 Colin Smith. All rights reserved.
//

#import "FreeSpaceOperation.h"

@interface FreeSpaceOperation ()

@property (strong, nonatomic) NSString *path;

@end

@implementation FreeSpaceOperation

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        _path = path;
    }
    return self;
}

- (void)main {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    for (int i = 5; i >= 0; i--) {
        if (self.cancelled) {
            return;
        }
        NSLog(@"Sleeping: %i", i);
        sleep(1);
    }

    NSError *error;

    if (!self.path) {
        self.path = @"/";
    }

    if (self.cancelled) {
        return;
    }

    self.fileSystemAttributes = [fileManager attributesOfFileSystemForPath:self.path error:&error];
    NSLog(@"%@", self.fileSystemAttributes);
}

@end
