//
//  ViewController.m
//  ObjectiveCSample
//
//  Created by Sven Herzberg on 18.10.19.
//

#import "ViewController.h"

#import <AditionAdsLib/AditionAdsLib.h>
@import Yieldprobe;

NS_ASSUME_NONNULL_BEGIN
@interface ViewController () <AdsViewDelegate>

@property (nullable) AdsView* pendingAdView;

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
        
        // AditionAdsLib expects NSString or NSNull only.
        NSMutableDictionary* converted = [NSMutableDictionary dictionary];
        for (NSString* key in targeting) {
            NSObject* value = targeting[key];
            if ([value isKindOfClass:NSString.class] || [value isKindOfClass:NSNull.class]) {
                converted[key] = value;
            } else {
                converted[key] = [NSString stringWithFormat:@"%@", value];
            }
        }
        
        AdsView* view = [AdsView inlineAdWithFrame:CGRectMake(0, 0, 300, 250) delegate:self];
        if (![view.targeting mergeProfileTargetingWithDictionary:converted error:&error]) {
            return [self handleError:error];
        }
        
        if (![view loadCreativeFromNetwork:@"99" withContentUnitID: @"4493233" error:&error]) {
            return [self handleError:error];
        }
        
        self.pendingAdView = view;
        NSLog(@"Loading…");
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

- (void)adFinishedCaching:(AdsView *)inAdsView withSuccessOrError:(NSError *)inError {
    NSLog(@"%@: %@, %@", NSStringFromSelector(_cmd), inAdsView, inError);
}

@end
