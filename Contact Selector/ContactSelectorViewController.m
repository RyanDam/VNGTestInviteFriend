//
//  ViewController.m
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "ContactSelectorViewController.h"
#import "CSContactProvider.h"
#import "CSContactTableViewCell.h"
#import "CSSelectedContactCollectionViewCell.h"
#import "CSSearchNoResultTableViewCell.h"
#import "CSModel.h"

@interface ContactSelectorViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *friendTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *friendChoosedCollectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *friendChoosedcollectionHeightConstraint;

@property (nonatomic) NSUInteger defaultFriendChoosedCollectionHeight;

// Navigation title view
@property (nonatomic) UIView * headerTitleView;
@property (nonatomic) UILabel * headerTitleLabel;
@property (nonatomic) UILabel * headerCountingLabel;

// Data select properties
@property (nonatomic, weak) id<CSDataBusiness> dataBusiness;
@property (nonatomic, weak) id<CSDataProvider> dataProvider;
@property (nonatomic) NSUInteger maxSelectedData;
@property (nonatomic) NSMutableArray<CSModel *> * selectedDatas;
@property (nonatomic, copy) NSArray<CSModel *> * dataArray;

@property (nonatomic, copy) NSArray<NSString *> * originalDataIndex;
@property (nonatomic, copy) NSDictionary<NSString *, NSArray<CSModel *> *> * originalDataDictionary;

@property (nonatomic, copy) NSArray<NSString *> * dataIndex;
@property (nonatomic, copy) NSDictionary<NSString *, NSArray<CSModel *> *> * dataDictionary;

// Current search state of view controller
@property (nonatomic) CSSearchResult userSearchResult;

@end

@implementation ContactSelectorViewController

+ (ContactSelectorViewController *)viewController {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"ContactSelector" bundle:nil];
    ContactSelectorViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ContactSelectorViewController"];
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.maxSelectedData = 10;
    self.selectedDatas = [NSMutableArray array];
    
    [self initFriendTableView];
    [self initFriendCollectionView];
    [self initHeaderTitleView];
    [self initSearchBar];
    [self initDataProvider];
    
    [self setHeaderTitle:@"Choose Friend"];
    [self setCoutingValue:0 animate:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // Without this, the collection view will crash when show then hide itself with message: attribute for indexPath not exist
    [self.friendChoosedCollectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - Init

- (void)initDataProvider {
    
    self.dataIndex = [NSArray array];
    self.dataDictionary = [NSDictionary dictionary];
    
    [self notifyDatasetChanged];
}

- (void)initHeaderTitleView {
    
    self.headerTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, self.navigationController.navigationBar.frame.size.height)];
    self.headerTitleView.backgroundColor = [UIColor clearColor];
    
    self.headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.headerTitleView.frame.size.width, 0.4*self.headerTitleView.frame.size.height)];
    self.headerTitleLabel.textColor = [UIColor blackColor];
    self.headerTitleLabel.font = [UIFont systemFontOfSize:16];
    self.headerTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerTitleView addSubview:self.headerTitleLabel];
    
    self.headerCountingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.4*self.headerTitleView.frame.size.height, self.headerTitleView.frame.size.width, 18.0)];
    self.headerCountingLabel.textColor = [UIColor blackColor];
    self.headerCountingLabel.font = [UIFont systemFontOfSize:12];
    self.headerCountingLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerTitleView addSubview:self.headerCountingLabel];
    
    self.navigationItem.titleView = self.headerTitleView;
}

- (void)initSearchBar {
    
    self.searchBarView.backgroundImage = [[UIImage alloc] init];
    self.searchBarView.delegate = self;
}

- (void)initFriendCollectionView {
    
    self.friendChoosedCollectionView.dataSource = self;
    self.friendChoosedCollectionView.delegate = self;
    self.defaultFriendChoosedCollectionHeight = 58;
    self.friendChoosedcollectionHeightConstraint.constant = 0;
    self.friendChoosedCollectionView.showsHorizontalScrollIndicator = NO;
    self.friendChoosedCollectionView.bounces = YES;
    self.friendChoosedCollectionView.prefetchingEnabled = NO;
}

- (void)initFriendTableView {
    
    self.friendTableView.dataSource = self;
    self.friendTableView.delegate = self;
    self.friendTableView.separatorColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    self.friendTableView.sectionIndexBackgroundColor = [UIColor clearColor];
}

- (void)setHeaderTitle:(NSString *)title {
    
    self.headerTitleLabel.text = title;
}

- (void)notifyDatasetChanged {
    
    if (self.dataSource == nil) {
        return;
    }
    
    self.dataBusiness = [self.dataSource dataBusinessForContactSelector:self];
    self.dataProvider = [self.dataSource dataProviderForContactSelector:self];
    
    if (self.dataBusiness && self.dataProvider) {
        [self.dataProvider getDataArrayWithCompletion:^(NSArray<CSModel *> *data, NSError *err) {
            
            if (err) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showMessage:[err localizedDescription]];
                });
            } else {
                self.dataArray = data;
                self.dataIndex = [self.dataBusiness getDataIndexFromDataArray:data];
                self.dataDictionary = [self.dataBusiness getDataDictionaryFromDataArray:data];
                
                self.originalDataIndex = [self.dataIndex copy];
                self.originalDataDictionary = [self.dataDictionary copy];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.friendTableView reloadData];
            });
        }];
    }
}

/**
 Set counting number in the navigation title view

 @param num 
    current number of selected data
 @param animated
    zoom in then zoom out animation or not
 */
- (void)setCoutingValue:(NSUInteger)num animate:(BOOL)animated{
    
    self.headerCountingLabel.text = [NSString stringWithFormat:@"%ld/%ld", num, self.maxSelectedData];
    
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            self.headerCountingLabel.transform = CGAffineTransformMakeScale(1.3, 1.3);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.headerCountingLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

#pragma mark - Navigation bar button event handler

- (IBAction)onCancelPressed:(UIBarButtonItem *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onExitCSViewController:)]) {
        [self.delegate onExitCSViewController:self];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onExportPressed:(UIBarButtonItem *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onExportCSViewController:withSelectedDatas:)]) {
        [self.delegate onExportCSViewController:self withSelectedDatas:self.selectedDatas];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    self.originalDataIndex = [self.dataIndex copy];
    self.originalDataDictionary = [self.dataDictionary copy];
    
    if (self.dataBusiness && [self.dataBusiness respondsToSelector:@selector(prepareForSearch)]) {
        [self.dataBusiness prepareForSearch];
    }
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (self.dataBusiness && [self.dataBusiness respondsToSelector:@selector(performSearch:onDataArray:withCompletion:)]) {
        [self.dataBusiness performSearch:searchText onDataArray:self.dataArray withCompletion:^(CSSearchResult searchResult, NSArray<NSString *> *index, NSDictionary<NSString *,NSArray<CSModel *> *> *dictionary) {
            
            self.userSearchResult = searchResult;
            
            self.dataIndex = index;
            self.dataDictionary = dictionary;
            
            if ([self isUserSearchNoResult]) {
                self.friendTableView.allowsSelection = NO;
            } else {
                self.friendTableView.allowsSelection = YES;
            }
            
            [self.friendTableView reloadData];
        }];
    }
}

/**
 force complete search
 */
- (void)forceEndSearch {
    
    self.dataIndex = [self.originalDataIndex copy];
    self.dataDictionary = [self.originalDataDictionary copy];
    
    if (self.dataBusiness && [self.dataBusiness respondsToSelector:@selector(completeSearch)]) {
        [self.dataBusiness completeSearch];
    }
    
    [self.searchBarView setText:@""];
    
    [self.friendTableView reloadData];
}

#pragma mark - Select contact logic

/**
 Add selected data when user selected it on the friendTableView

 @param data
    data will be added to selectedContact array
 */
- (void)didSelectData:(CSModel *)data {
    
    CSModel * finalData = data;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(csViewController:willSelectData:)]) {
        finalData = [self.delegate csViewController:self willSelectData:data];
        if (finalData == nil) {
            return;
        }
    }
    
    // Show selected contact collection view
    if (self.selectedDatas.count == 0) {
        self.friendChoosedcollectionHeightConstraint.constant = self.defaultFriendChoosedCollectionHeight;
        [UIView animateWithDuration:0.13 animations:^{
            
            [self.view layoutIfNeeded];
        } completion:nil];
    }
    
    // start add selected contact to collection view
    [self.friendChoosedCollectionView performBatchUpdates:^{
        
        [self.selectedDatas addObject:finalData];
        NSUInteger index = [self.selectedDatas indexOfObject:finalData];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        [self.friendChoosedCollectionView insertItemsAtIndexPaths:@[indexPath]];
        
    } completion:^(BOOL finished) {
        if (finished) {
            
            [self.friendChoosedCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedDatas.count - 1 inSection:0]
                                                     atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            [self setCoutingValue:self.selectedDatas.count animate:YES];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(csViewController:didSelectData:)]) {
                [self.delegate csViewController:self didSelectData:finalData];
            }
            
        }
    }];
    
    // turn off search when done adding contact
    [self forceEndSearch];
}

/**
 Remove data from selected contact data when user deselected it

 @param data
    data will be remove
 */
- (void)didDeselectData:(CSModel *)data {
    
    CSModel * finalData = data;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(csViewController:willDeselectData:)]) {
        finalData = [self.delegate csViewController:self willDeselectData:data];
        if (finalData == nil) {
            return;
        }
    }
    
    // Hide selected contact collection view
    if (self.selectedDatas.count == 1) {
        self.friendChoosedcollectionHeightConstraint.constant = 0;
        [UIView animateWithDuration:0.13 animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
    }
    
    // start remove selected contact from collection view
    [self.friendChoosedCollectionView performBatchUpdates:^{
        
        NSUInteger index = [self.selectedDatas indexOfObject:finalData];
        [self.selectedDatas removeObject:finalData];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.friendChoosedCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self setCoutingValue:self.selectedDatas.count animate:YES];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(csViewController:didDeselectData:)]) {
                [self.delegate csViewController:self didDeselectData:finalData];
            }
        }
    }];
    
    // turn off search when done adding contact
    [self forceEndSearch];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CSModel * data = self.selectedDatas[indexPath.row];
    CSSelectedContactCollectionViewCell * csCell = (CSSelectedContactCollectionViewCell *) cell;
    [csCell setData:data];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [self forceEndSearch];
    
    CSSelectedContactCollectionViewCell * csCell = (CSSelectedContactCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    [csCell toggleHighlight];
    
    CSModel * data = self.selectedDatas[indexPath.row];
    NSIndexPath * tableIndexPath = [self getIndexPathOfFriendTableForData:data];
    
    [self.friendTableView selectRowAtIndexPath:tableIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CSSelectedContactCollectionViewCell * csCell = (CSSelectedContactCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    [csCell setHighlight:NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.selectedDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCSSelectedContactCollectionViewCellID forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isUserSearchNoResult]) {
        return [CSSearchNoResultTableViewCell getCellHeight];
    } else {
        return [CSContactTableViewCell getCellHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([self isUserSearching]) {
        return 0;
    }
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if ([self isUserSearching]) {
        return 0;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isUserSearchNoResult]) {
        return;
    }
    
    CSContactTableViewCell * contactCell = (CSContactTableViewCell *) cell;
    CSModel * data = [self getDataAtIndexPath:indexPath];
    contactCell.data = data;
    
    // Override this view for customize selection highligh color for cell
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    cell.selectedBackgroundView = myBackView;
    
    if ([self.selectedDatas containsObject:data]) {
        [contactCell setSelect:YES];
    } else {
        [contactCell setSelect:NO];
    }
    
    // hide seperator when this cell is the last cell in section
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        [contactCell hideSeperator];
    } else {
        [contactCell showSeperator];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // No need section view when user is searching
    if ([self isUserSearching]) {
        return nil;
    }
    
    NSString * sectionKey = self.dataIndex[section];
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(16, 0, tableView.frame.size.width, 24)];
    headerView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    
    UILabel * headerKeyLabel = [[UILabel alloc] initWithFrame:headerView.frame];
    UIFont * headerFont = [UIFont boldSystemFontOfSize:12];
    headerKeyLabel.font = headerFont;
    headerKeyLabel.text = sectionKey;
    headerKeyLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [headerView addSubview:headerKeyLabel];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    // No need footer view when user is searching
    if ([self isUserSearching]) {
        return nil;
    }
    
    UIView * dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    dividerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    return dividerView;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isUserSearchNoResult]) {
        return nil;
    }
    
    if (self.selectedDatas.count < self.maxSelectedData) {
        return indexPath;
    } else {
        CSModel * selectedData = [self getDataAtIndexPath:indexPath];
        if ([self.selectedDatas containsObject:selectedData]) {
            return indexPath; // case: deselect cell when maximum selected contact reached
        }
        [self showMessage:[NSString stringWithFormat:@"You may select %ld friends at maximum", self.maxSelectedData]];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(csViewController:reachedMaxSelectedDatas:)]) {
            [self.delegate csViewController:self reachedMaxSelectedDatas:self.dataArray];
        }
        
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    CSModel * selectedData = [self getDataAtIndexPath:indexPath];
    CSContactTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.selectedDatas containsObject:selectedData]) {
        [self didDeselectData:selectedData];
        [cell setSelect:NO];
    } else {
        [self didSelectData:selectedData];
        [cell setSelect:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([self isUserSearchNoResult]) {
        return 1;
    }
    
    return [self.dataIndex count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self isUserSearchNoResult]) {
        return 1;
    }
    
    NSString * sectionKey = self.dataIndex[section];
    return [[self.dataDictionary objectForKey:sectionKey] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if ([self isUserSearchNoResult]) {
        return [tableView dequeueReusableCellWithIdentifier:kCSSearchNoResultTableViewCellID];
    } else {
        return [tableView dequeueReusableCellWithIdentifier:kCSContactTableViewCellID];
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    // data not init yet
    if (self.dataIndex.count == 0) {
        return nil;
    }
    
    if ([self isUserSearching]) {
        return nil;
    }
    
    NSString * searchIcon = UITableViewIndexSearch;
    NSString * hastagIcon = @"#";
    NSArray * indexWithIcon = [[@[searchIcon] arrayByAddingObjectsFromArray:self.dataIndex] arrayByAddingObject:hastagIcon];
    
    return indexWithIcon;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    if (index == 0) return 0; // search icon
    else if (index == self.dataIndex.count + 2 - 1) return index - 2; // hastag icon
    else return index - 1; // normal index
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.searchBarView endEditing:YES];
}

#pragma mark - Utils

- (BOOL)isUserSearchNoResult {
    
    if ([self isUserSearching]) {
        return self.userSearchResult == CSSearchResultNoResult;
    }
    
    return NO;
}

- (BOOL)isUserSearching {
    
    if (self.dataIndex.count == 0) {
        return NO;
    }
    
    NSString * firstSectionKey = self.dataIndex[0];
    if ([firstSectionKey compare:kCSProviderSearchKey] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

- (CSModel *)getDataAtIndexPath: (NSIndexPath *)indexPath {
    
    NSString * sectionKey = self.dataIndex[indexPath.section];
    NSArray * contactListOfKey = [self.dataDictionary objectForKey:sectionKey];
    CSModel * data = contactListOfKey[indexPath.row];
    return data;
}

- (NSIndexPath *)getIndexPathOfFriendTableForData:(CSModel *)data {
    
    NSString * sectionKey = [data.fullName substringWithRange:NSMakeRange(0, 1)].uppercaseString;
    NSUInteger section = [self.dataIndex indexOfObject:sectionKey];
    
    NSArray * dataList = [self.dataDictionary objectForKey:sectionKey];
    NSUInteger row = [dataList indexOfObject:data];
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (void)showMessage:(NSString *)message {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:dismissAction];
    [dismissAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)printSelectedContacts {
    
    for (CSModel * data in self.selectedDatas) {
        NSLog(@"%@", data.fullName);
    }
}

- (void)printIndexPath:(NSIndexPath *)index {
    
    NSLog(@"Section %ld row %ld", (long)index.section, (long)index.row);
}

@end
