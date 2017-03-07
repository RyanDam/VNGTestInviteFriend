//
//  OutgoingCallViewController.m
//  Contact Selector
//
//  Created by CPU11808 on 3/7/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "OutgoingCallViewController.h"
#import "AppDelegate.h"
#import "CallManager.h"
#import "Call.h"

@interface OutgoingCallViewController ()

@property (weak, nonatomic) IBOutlet UILabel *callNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *callStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) Call *call;

@end

@implementation OutgoingCallViewController

+ (instancetype)viewController {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"OutgoingCall" bundle:nil];
    OutgoingCallViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"OutgoingCallViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.callNumberLabel.text = self.callNumber;
    self.callStatusLabel.text = @"Dialing";
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    __weak typeof(self) instance = self;
    
    // start call
    self.call = [self.appDelegate.callManager startCall:[NSUUID new] handle:self.callNumber];
    self.call.stateDidChange = ^(CallState state) {
        
        NSString *stateString;
        switch (state) {
            case kConnecting:
                stateString = @"Connecting";
                break;
            case kConnected:
                [instance updateCallDurationTimer];
                stateString = @"Connected";
                break;
            case kHeld:
                stateString = @"Held";
                break;
            default:
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            instance.callStatusLabel.text = stateString;
        });
    };
    
    // simulate answer call after 2 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[self.appDelegate callManager] answerCall:self.call];
    });
}

- (void)updateCallDurationTimer {
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        self.timeLabel.text = [self durationLabelText:self.call];
    }];
}

- (NSString *)durationLabelText:(Call *)call {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"mm:ss"];
    
    NSDate *dump = [NSDate dateWithTimeIntervalSince1970:call.duration];
//    NSLog(@"%f", self.call.duration);
    
    return [dateFormatter stringFromDate:dump];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)endCall:(id)sender {
    
    [self.appDelegate.callManager endCall:_call];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
