//
//  SCOPMainViewController.m
//  NSScreencastNSOperation
//
//  Created by Colin Smith on 10/18/15.
//  Copyright © 2015 Colin Smith. All rights reserved.
//

#import "SCOPMainViewController.h"
#import "FreeSpaceOperation.h"

@interface SCOPMainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *calculateButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *usageDisplayLabel;
@property (strong, nonatomic) NSOperationQueue *operationQueue;

@end

@implementation SCOPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.calculateButton.enabled = YES;
    self.cancelButton.enabled = NO;
    self.cancelButton.alpha = 0.25;
    self.operationQueue = [[NSOperationQueue alloc] init];
}

#pragma mark - Button Actions

- (IBAction)calculateUsageButtonWasTouched:(id)sender {
    self.calculateButton.enabled = NO;
    self.calculateButton.alpha = 0.25;
    self.cancelButton.alpha = 1;
    self.cancelButton.enabled = YES;
    [self computeFreeSpaceForPath:@"/"];
    [self computeFreeSpaceForPath:@"/Volumes/colinsmith"];
}

- (void)computeFreeSpaceForPath:(NSString *)path {
    __weak typeof(self) weakSelf = self;
    if (self.operationQueue) {
        //        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        //            NSFileManager *fileManager = [NSFileManager defaultManager];
        //
        //            for (int i = 4; i >= 0; i--) {
        //                NSLog(@"sleeping: %i", i);
        //                sleep(1);
        //            }
        //
        //            NSError *error;
        //            NSDictionary *attributes =[fileManager attributesOfFileSystemForPath:@"/" error:&error];
        //            NSLog(@"attributes: %@", attributes);
        //        }];
        FreeSpaceOperation *operation = [[FreeSpaceOperation alloc] initWithPath:path];
        __block FreeSpaceOperation *weakOperation = operation;
        [self appendText:[NSString stringWithFormat:@"Computing Free Space for %@", path]];
        operation.completionBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakOperation.cancelled) {
                    weakSelf.usageDisplayLabel.text = @"Cancelled";
                }
                if (weakOperation.fileSystemAttributes[NSFileSystemFreeSize]) {
                    long long spaceFreeBytes = [weakOperation.fileSystemAttributes[NSFileSystemFreeSize] longLongValue];
                    [weakSelf appendText:[NSString stringWithFormat:@"Space for %@: %@", path, [NSByteCountFormatter stringFromByteCount:spaceFreeBytes countStyle:NSByteCountFormatterCountStyleFile]]];
                }
                weakSelf.cancelButton.enabled = NO;
                weakSelf.cancelButton.alpha = 0.25;
                weakSelf.calculateButton.alpha = 1;
                weakSelf.calculateButton.enabled = YES;
            });
        };
        
        [self.operationQueue addOperation:operation];
    }
}

- (IBAction)cancelButtonWasTouched:(id)sender {
    [self.operationQueue cancelAllOperations];
}

- (void)appendText:(NSString *)text {
    self.usageDisplayLabel.text = [self.usageDisplayLabel.text stringByAppendingString:[NSString stringWithFormat:@"\n %@", text]];
}


@end
