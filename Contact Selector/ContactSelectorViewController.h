//
//  ViewController.h
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSDataProvider.h"
#import "CSDataBusiness.h"

@class ContactSelectorViewController;
@class CSModel;

@protocol CSViewControllerDelegate <NSObject>

@optional

- (CSModel *)csViewController:(ContactSelectorViewController *)csViewController willSelectData:(CSModel *)data;

- (void)csViewController:(ContactSelectorViewController *)csViewController didSelectData:(CSModel *)data;

- (CSModel *)csViewController:(ContactSelectorViewController *)csViewController willDeselectData:(CSModel *)data;

- (void)csViewController:(ContactSelectorViewController *)csViewController didDeselectData:(CSModel *)data;

- (void)onExitCSViewController:(ContactSelectorViewController *)csViewController;

- (void)onExportCSViewController:(ContactSelectorViewController *)csViewController withSelectedDatas:(NSArray<CSModel *> *)datas;

- (void)csViewController:(ContactSelectorViewController *)csViewController reachedMaxSelectedDatas:(NSArray<CSModel *> *)datas;

@end

@protocol CSViewControllerDataSource <NSObject>

@required

- (id<CSDataProvider>)dataProviderForContactSelector:(ContactSelectorViewController *)csViewController;

- (id<CSDataBusiness>)dataBusinessForContactSelector:(ContactSelectorViewController *)csViewController;

@end

@interface ContactSelectorViewController : UIViewController

@property (nonatomic) NSMutableArray<CSModel *> * selectedDatas;

@property (nonatomic, weak) id<CSViewControllerDelegate> delegate;
@property (nonatomic, weak) id<CSViewControllerDataSource> dataSource;

+ (ContactSelectorViewController *)viewController;

- (void)notifyDatasetChanged;

@end

