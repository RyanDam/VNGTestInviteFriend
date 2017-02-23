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

#import "CSThumbnailCreater.h"

@interface MainViewController () <CSViewControllerDelegate, CSViewControllerDataSource>

@property (nonatomic) CSContactBusiness * contactBusiness;
@property (nonatomic) CSContactProvider * contactProvider;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contactBusiness = [[CSContactBusiness alloc] init];
    self.contactProvider = [[CSContactProvider alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGSize size = CGSizeMake(42, 42);
    
    UIImage * img = [[CSThumbnailCreater getInstance] getThumbnailImageWithText:@"AA" withSize:size];
    
    [self.imageView setImage:img];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onPressButton:(id)sender {
    
    CSPresenterViewController * vc = [CSPresenterViewController presenter];

    [vc setDelegateCS:self];
    [vc setDataSourceCS:self];
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - CSViewControllerDataSource

- (id<CSDataProvider>)dataProviderForContactSelector:(ContactSelectorViewController *)csViewController {
    
    return self.contactProvider;
}

- (id<CSDataBusiness>)dataBusinessForContactSelector:(ContactSelectorViewController *)csViewController {
    
    return self.contactBusiness;
}

@end
