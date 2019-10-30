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

- (id)initWithCoder:(NSCoder*)decoder {
    self = [super initWithCoder:decoder];
    self.yieldprobe = Yieldprobe.sharedInstance;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
