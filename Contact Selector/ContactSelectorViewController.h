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

/**
 Call before data is selected

 @param csViewController 
    view controller hold the data
 @param data 
    data will be selected
 @return 
    return data will be selected, return nil if don't want that data be selected
 */
- (CSModel *)csViewController:(ContactSelectorViewController *)csViewController willSelectData:(CSModel *)data;

/**
 Call after data is selected

 @param csViewController 
    view controller hold the data
 @param data 
    data selected
 */
- (void)csViewController:(ContactSelectorViewController *)csViewController didSelectData:(CSModel *)data;

/**
 Call before data is deselected
 
 @param csViewController
    view controller hold the data
 @param data
    data will be deselected
 @return
    return data will be deselected, return nil if don't want that data be deselected
 */
- (CSModel *)csViewController:(ContactSelectorViewController *)csViewController willDeselectData:(CSModel *)data;

/**
 Call after data is deselected
 
 @param csViewController
    view controller hold the data
 @param data
    data deselected
 */
- (void)csViewController:(ContactSelectorViewController *)csViewController didDeselectData:(CSModel *)data;

/**
 Call before view controller is exit

 @param csViewController view controller will exit
 */
- (void)onExitCSViewController:(ContactSelectorViewController *)csViewController;

/**
 Call before view controller export it datas

 @param csViewController view controller will export
 @param datas array of expoted datas
 */
- (void)onExportCSViewController:(ContactSelectorViewController *)csViewController withSelectedDatas:(NSArray<CSModel *> *)datas;

/**
 call when max data reached

 @param csViewController vew controller be reached
 @param datas current selected data
 */
- (void)csViewController:(ContactSelectorViewController *)csViewController reachedMaxSelectedDatas:(NSArray<CSModel *> *)datas;

@end

@interface ContactSelectorViewController : UIViewController

@property (nonatomic, weak) id<CSViewControllerDelegate> delegate;
@property (nonatomic) id<CSDataBusiness> dataBusiness;
@property (nonatomic) BOOL allowMutilSelection;

+ (ContactSelectorViewController *)viewController;

- (void)setHeaderTitle:(NSString *)title;

- (void)notifyDatasetChanged;

@end

