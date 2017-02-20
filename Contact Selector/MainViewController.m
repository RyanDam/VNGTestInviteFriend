//
//  MainViewController.m
//  Contact Selector
//
//  Created by CPU11815 on 2/20/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "MainViewController.h"
#import "ContactSelectorViewController.h"
#import "CSContactProvider.h"
#import "CSContactBusiness.h"
#import "CSPresenterViewController.h"

@interface MainViewController () <CSViewControllerDelegate, CSViewControllerDataSource>

@property (nonatomic) CSContactBusiness * contactBusiness;
@property (nonatomic) CSContactProvider * contactProvider;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contactBusiness = [[CSContactBusiness alloc] init];
    self.contactProvider = [[CSContactProvider alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPressButton:(id)sender {
    
    CSPresenterViewController * vc = [CSPresenterViewController presenter];

    [vc setDelegateCS:self];
    [vc setDataSourceCS:self];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (id<CSDataProvider>)dataProviderForContactSelector:(ContactSelectorViewController *)csViewController {
    return self.contactProvider;
}

- (id<CSDataBusiness>)dataBusinessForContactSelector:(ContactSelectorViewController *)csViewController {
    return self.contactBusiness;
}

@end
