//
//  CallViewController.m
//  Contact Selector
//
//  Created by CPU11815 on 2/24/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CallViewController.h"
#import "CSCallHistoryManager.h"
#import "CallCell.h"

#import "CSContactBusiness.h"

#import "CSContact.h"
#import "CallManager.h"
#import "CallProvider.h"
#import "AppDelegate.h"
#import "OutgoingCallViewController.h"
#import "CSContact.h"

#define DIALER_VIEW_SHOW_CONSTANT -34
#define DIALER_VIEW_HIDE_CONSTANT -350
#define INPUT_VIEW_SHOW_CONSTANT 0
#define INPUT_VIEW_HIDE_CONSTANT -40

#define LOADING_CELL_HEIGHT 300
#define CALL_CELL_HEIGHT 64

@interface CallViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CSContactBusiness *contactBusiness;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *keypadView;

@property (weak, nonatomic) IBOutlet UITextField *inputNumber;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diallerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputConstraint;

@property (strong, nonatomic) NSArray<CSCall *> *calls;
@property (strong, nonatomic) NSMutableDictionary *cacheContact;
@property (strong, nonatomic) NSArray *allContact;

@property int waitForLoading;

@end

@implementation CallViewController

+ (instancetype)viewController {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Call" bundle:nil];
    CallViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"CallViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];

    self.contactBusiness = [CSContactBusiness new];
    self.cacheContact = [NSMutableDictionary new];
    
    self.inputNumber.userInteractionEnabled = NO;
    
    self.waitForLoading = 2;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.calls = [[CSCallHistoryManager manager] getAllCalls];
        self.waitForLoading--;
    });
    
    [self.contactBusiness getDataArrayWithCompletion:^(NSArray<CSModel *> *data, NSError *err) {
        self.waitForLoading--;
        if (!err) {
            self.allContact = data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            NSLog(@"%@", [err localizedDescription]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButtonDelegate

- (IBAction)numberClick:(id)sender {
    
    [self showInputView];
    
    UIButton *btn = (UIButton *)sender;
    self.inputNumber.text = [self.inputNumber.text stringByAppendingString:btn.titleLabel.text];
}

- (IBAction)showDialler:(id)sender {
    
    [UIView animateWithDuration:0.1 animations:^{
        self.keypadView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    }];
    
    self.diallerConstraint.constant = DIALER_VIEW_SHOW_CONSTANT;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil
     ];
}


- (IBAction)hideDialler:(id)sender {
    
    if ([self isInputViewShowing])
        self.diallerConstraint.constant = DIALER_VIEW_HIDE_CONSTANT + INPUT_VIEW_HIDE_CONSTANT;
    else
        self.diallerConstraint.constant = DIALER_VIEW_HIDE_CONSTANT;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.keypadView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (IBAction)deleteNumber:(id)sender {
    
    NSString *textNumber = self.inputNumber.text;
    if (textNumber.length > 0) {
        self.inputNumber.text = [textNumber substringToIndex:[textNumber length] - 1];
    }
    
    if (self.inputNumber.text.length < 1) {
        [self hideInputView];
    }
}

- (IBAction)addNewContact:(id)sender {
    NSLog(@"Implement add a new contact");
}

- (IBAction)makePhoneCall:(id)sender {
    
    if (self.inputNumber.text.length > 0) {
        
        OutgoingCallViewController * vc = [OutgoingCallViewController viewController];
        
        [self searchForContactMatchWith:self.inputNumber.text Completion:^(CSContact *contact) {
            
            vc.callNumber = self.inputNumber.text;
            vc.contact = contact;
            
            [self presentViewController:vc animated:YES completion:nil];
        }];
    }
}
- (IBAction)simulateIncommingCall:(id)sender {
    AppDelegate * delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    UIBackgroundTaskIdentifier iden = [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"NAME" expirationHandler:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate simulateIncommingCall:[[NSUUID alloc] init] handle:@"ABC" completion:^{
                [[UIApplication sharedApplication] endBackgroundTask:iden];
            }];
        });
    });
    
    
}

#pragma mark - InternalMethod

- (BOOL)isInputViewShowing {
    return self.inputConstraint.constant >= 0;
}

- (void)showInputView {
    self.inputConstraint.constant = INPUT_VIEW_SHOW_CONSTANT;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)hideInputView {
    self.inputConstraint.constant = INPUT_VIEW_HIDE_CONSTANT;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)searchForContactMatchWith:(NSString *)phoneNumber Completion:(void(^)(CSContact *))completion {

    if (![self.cacheContact objectForKey:phoneNumber]) {
        
        [self.contactBusiness searchForContactWithNumber:phoneNumber withCompletion:^(CSContact *contact) {
            if (contact == nil) {
                contact = [CSContact new];
                contact.fullName = phoneNumber;
            }
            
            completion(contact);
            [self.cacheContact setValue:contact forKey:phoneNumber];
        }];
    } else {
        completion([self.cacheContact objectForKey:phoneNumber]);
    }

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.waitForLoading > 0) {
        return 1;
    }
    return [self.calls count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *calledCellID = @"calledCell";
    static NSString *loadingCellID = @"loadingCell";
    
    CallCell *cell;
    
    if (self.waitForLoading > 0) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:loadingCellID];
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:calledCellID];
        
        CSCall *call = self.calls[indexPath.row];
        
        [self searchForContactMatchWith:call.number Completion:^(CSContact *contact) {
            cell.fullName.text = contact.fullName;
            [cell.thumnailView setData:contact];
        }];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd.MM.YYYY HH:mm:ss"];
        
        cell.subcription.text = [NSString stringWithFormat:@"↗ %@", [dateFormatter stringFromDate:call.start]];
    }
    return cell;
}


#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.waitForLoading > 0)
        return LOADING_CELL_HEIGHT;
    return CALL_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *phoneNumber = self.calls[indexPath.row].number;
    
    OutgoingCallViewController * vc = [OutgoingCallViewController viewController];

    vc.contact = self.cacheContact[phoneNumber];
    vc.callNumber = phoneNumber;
        
    [self presentViewController:vc animated:YES completion:nil];

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideDialler:nil];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
