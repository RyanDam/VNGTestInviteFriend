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

@interface BlockViewController () <CSViewControllerDelegate, CSViewControllerDataSource, BlockPhoneViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic) ContactSelectorViewController * contactSlecterVC;
@property (nonatomic) id<CSDataBusiness> contactBusiness;
@property (nonatomic) id<CSDataProvider> blockNumberProvider;

@end

@implementation BlockViewController

+ (instancetype)viewController {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Block" bundle:nil];
    BlockViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"BlockViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    
    self.contactBusiness = [[CSContactBusiness alloc] init];
    self.blockNumberProvider = [[BlockNumberProvider alloc] init];
    
    self.contactSlecterVC = [ContactSelectorViewController viewController];
    self.contactSlecterVC.delegate = self;
    self.contactSlecterVC.dataSource = self;
    [self.contactSlecterVC setAllowMutilSelection:NO];
    
    [self.containerView addSubview:self.contactSlecterVC.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.contactSlecterVC notifyDatasetChanged];
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
    
    [manager getEnabledStatusForExtensionWithIdentifier:@"com.vng.duydv2.Contact-Selector.Contact-Selector-Block" completionHandler:^(CXCallDirectoryEnabledStatus enabledStatus, NSError * _Nullable error) {
        
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
            [manager reloadExtensionWithIdentifier:@"com.vng.duydv2.Contact-Selector.Contact-Selector-Block" completionHandler:^(NSError * _Nullable error) {
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
        [self.contactSlecterVC notifyDatasetChanged];
        [self needRefreshBlockPhoneExtention];
    }
}

#pragma mark - CSViewControllerDataSource

- (id<CSDataProvider>)dataProviderForContactSelector:(ContactSelectorViewController *)csViewController {
    
    return self.blockNumberProvider;
}

- (id<CSDataBusiness>)dataBusinessForContactSelector:(ContactSelectorViewController *)csViewController {
    
    return self.contactBusiness;
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
