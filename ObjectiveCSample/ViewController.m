//
//  ViewController.m
//  ObjectiveCSample
//
//  Created by Sven Herzberg on 18.10.19.
//

#import "ViewController.h"

@import Yieldprobe;

NS_ASSUME_NONNULL_BEGIN
@interface ViewController ()

@property Yieldprobe* yieldprobe;

@end
NS_ASSUME_NONNULL_END

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder*)decoder {
    self = [super initWithCoder:decoder];
    self.yieldprobe = Yieldprobe.sharedInstance;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadAd];
}

- (void)reloadAd {
    [self.yieldprobe probeWithSlot:6846238
                 completionHandler:^(YLDBid * _Nullable bid, NSError * _Nullable error) {
        if (error) {
            return [self handleError:error];
        }
        
        NSDictionary* targeting = [bid customTargetingWithError:&error];
        if (!targeting) {
            return [self handleError:error];
        }
        
        NSLog(@"Handle result: %@", targeting);
    }];
}

- (void)handleError:(nonnull NSError*)error {
    UIAlertController* vc = [UIAlertController alertControllerWithTitle:error.localizedDescription
                                                                message:@"It might be a good idea to request another ad after ~10s."
                                                         preferredStyle:UIAlertControllerStyleAlert];
    [vc addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
        [NSTimer scheduledTimerWithTimeInterval:10 repeats:NO block:^(NSTimer* timer) {
            [self reloadAd];
        }];
    }]];
    [self presentViewController:vc animated:true completion:nil];
}

@end
