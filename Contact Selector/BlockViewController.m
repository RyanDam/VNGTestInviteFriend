//
//  BlockViewController.m
//  Contact Selector
//
//  Created by CPU11815 on 2/24/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "BlockViewController.h"
#import "ContactSelectorViewController.h"
#import "ContactDetailViewController.h"
#import "CSContactBusiness.h"
#import "CSContactProvider.h"
#import "BlockNumberProvider.h"
#import "BlockPhoneViewController.h"
#import "CSBlockDatebaseManager.h"
#import "CSContact.h"

@import CallKit;

@interface BlockViewController () <CSViewControllerDelegate, BlockPhoneViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation BlockViewController

+ (instancetype)viewController {
    return [[BlockViewController alloc] init];
}

- (void)viewDidLoad {
    self.allowMutilSelection = NO;
    [super viewDidLoad];
    
    [self setupNavigation];
    self.dataBusiness = [[CSContactBusiness alloc] initWithProvider:[[BlockNumberProvider alloc] init]];
    self.delegate = self;
    [self notifyDatasetChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self needRefreshBlockPhoneExtention];
}

- (void)setupNavigation {
    self.navigationItem.title = @"Block Contact";
    
    UIBarButtonItem * plusButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewBlockNumber)];
    self.navigationItem.rightBarButtonItem = plusButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNewBlockNumber {
    
    BlockPhoneViewController * viewController = [BlockPhoneViewController viewController];
    viewController.delegate = self;
    UINavigationController * wrapper = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:wrapper animated:YES completion:nil];
}

- (void)needRefreshBlockPhoneExtention {
    CXCallDirectoryManager * manager = [CXCallDirectoryManager sharedInstance];
    
    [manager getEnabledStatusForExtensionWithIdentifier:@"com.vng.ttphong.Contact-Selector.Contact-Selector-Block" completionHandler:^(CXCallDirectoryEnabledStatus enabledStatus, NSError * _Nullable error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMessage:error.localizedDescription];
            });
            return;
        }
        
        if (enabledStatus == CXCallDirectoryEnabledStatusDisabled || enabledStatus == CXCallDirectoryEnabledStatusUnknown) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMessage:@"Please enable to block contact in \nSettings > Phone > Call Blocking & Identification > enable Contact Selector"];
            });
        } else {
            [manager reloadExtensionWithIdentifier:@"com.vng.ttphong.Contact-Selector.Contact-Selector-Block" completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showMessage:error.localizedDescription];
                    });
                }
            }];
        }
    }];
}

#pragma mark - BlockPhoneViewControllerDelegate

- (void)addBlockPhoneViewController:(BlockPhoneViewController *)vc didAddModel:(CSContact *)model {
    
    [self dismissViewControllerAnimated:vc.navigationController completion:nil];
    
    if (model) {
        CSBlockDatebaseManager * manager = [CSBlockDatebaseManager manager];
        [manager blockContact:model];
        [self notifyDatasetChanged];
        [self needRefreshBlockPhoneExtention];
    }
}

#pragma mark - CSViewControllerDelegate

- (void)csViewController:(ContactSelectorViewController *)csViewController didSelectData:(CSModel *)data {
    
    CSContact * contact = (CSContact *) data;
    ContactDetailViewController * vc = [ContactDetailViewController viewController];
    vc.contact = contact;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Utils

- (void)showMessage:(NSString *)message {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:dismissAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
