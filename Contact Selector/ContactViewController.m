//
//  ContactViewController.m
//  Contact Selector
//
//  Created by CPU11815 on 2/24/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "ContactViewController.h"
#import "CSContactProvider.h"
#import "CSContactBusiness.h"
#import "CSDataProvider.h"
#import "CSDataBusiness.h"

@interface ContactViewController () <CSViewControllerDelegate, CSViewControllerDataSource>

@property (nonatomic) id<CSDataBusiness> contactBusiness;
@property (nonatomic) id<CSDataProvider> contactProvider;

@end

@implementation ContactViewController

+ (instancetype)viewController {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"ContactSelector" bundle:nil];
    ContactViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ContactSelectorViewControllerNVC"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTitleView];
    
    self.contactBusiness = [[CSContactBusiness alloc] init];
    self.contactProvider = [[CSContactProvider alloc] init];
    
    self.delegateCS = self;
    self.dataSourceCS = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self notifyDatasetChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTitleView {
    UILabel * label = [[UILabel alloc] init];
    [label setText:@"Contacts"];
    self.navigationItem.titleView = label;
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - CSViewControllerDataSource

- (id<CSDataProvider>)dataProviderForContactSelector:(ContactSelectorViewController *)csViewController {
    
    return self.contactProvider;
}

- (id<CSDataBusiness>)dataBusinessForContactSelector:(ContactSelectorViewController *)csViewController {
    
    return self.contactBusiness;
}

@end
