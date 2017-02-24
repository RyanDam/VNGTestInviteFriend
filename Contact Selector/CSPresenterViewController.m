//
//  CSPresenterViewController.m
//  Contact Selector
//
//  Created by CPU11815 on 2/20/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSPresenterViewController.h"

@interface CSPresenterViewController ()

@end

@implementation CSPresenterViewController

@synthesize delegateCS = _delegateCS;
@synthesize dataSourceCS = _dataSourceCS;

+ (instancetype)presenter {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"ContactSelector" bundle:nil];
    CSPresenterViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ContactSelectorViewControllerNVC"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)allowMutilSelection:(BOOL)flag {
    
    [self getCSViewController].allowMutilSelection = flag;
}

- (void)notifyDatasetChanged {
    
    [[self getCSViewController] notifyDatasetChanged];
}

- (void)setDelegateCS:(id<CSViewControllerDelegate>)newDelegateCS {
    
    _delegateCS = newDelegateCS;
    [[self getCSViewController] setDelegate:newDelegateCS];
}

- (void)setDataSourceCS:(id<CSViewControllerDataSource>)newDataSourceCS {
    
    _dataSourceCS = newDataSourceCS;
    [[self getCSViewController] setDataSource:newDataSourceCS];
}

- (ContactSelectorViewController *)getCSViewController {
    
    return (ContactSelectorViewController*)self.viewControllers[0];
}

@end
