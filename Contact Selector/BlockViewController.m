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
#import "Utils.h"

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

- (void)addNewBlockNumber {
    
    BlockPhoneViewController * viewController = [BlockPhoneViewController viewController];
    viewController.delegate = self;
    UINavigationController * wrapper = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:wrapper animated:YES completion:nil];
}

- (void)needRefreshBlockPhoneExtention {
    __weak typeof(self) softSelf = self;
    [Utils refreshCallDirectionBlockListWithCompletion:^(NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utils showMessage:error.localizedDescription inViewController:softSelf];
            });
        }
    }];
}

#pragma mark - BlockPhoneViewControllerDelegate

- (void)addBlockPhoneViewController:(BlockPhoneViewController *)vc didAddModel:(CSContact *)model {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
