//
//  LBCountryVC.m
//  Pods
//
//  Created by 李兵 on 2017/12/6.
//

#import "LBCountryVC.h"
#import "LBCountrySearchVC.h"

@interface LBCountryVC ()<UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, LBCountrySearchVCDelegate>
@property (nonatomic, strong)NSDictionary *dataSource;
@property (nonatomic, strong)NSArray *keys;
@property (nonatomic, strong)NSArray *searchResults;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UISearchController *searchVC;
@end

@implementation LBCountryVC
#pragma mark -- Getter
- (NSDictionary *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSDictionary dictionary];
    }
    return _dataSource;
}
- (NSArray *)keys {
    if (!_keys) {
        _keys = [self.dataSource.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
    }
    return _keys;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = self.searchVC.searchBar;
    }
    return _tableView;
}
- (UISearchController *)searchVC {
    if (!_searchVC) {
        LBCountrySearchVC *vc = [LBCountrySearchVC new];
        vc.delegate = self;
        _searchVC = [[UISearchController alloc] initWithSearchResultsController:vc];
        _searchVC.searchResultsUpdater = self;
        _searchVC.hidesNavigationBarDuringPresentation = NO;
        _searchVC.definesPresentationContext = YES;
        _searchVC.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchVC.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _searchVC;
}

- (NSString *)language {
    if (!_language) {
        _language = [NSLocale preferredLanguages].firstObject;
    }
    return _language;
}

#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initLayout];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    __weak typeof(self) weakSelf = self;
    __block NSIndexPath *indexPath = nil;
    [self.dataSource enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSArray *  _Nonnull arr, BOOL * _Nonnull stop) {
        [arr enumerateObjectsUsingBlock:^(LBCountryModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([weakSelf.currentCountry.countryCode isEqualToString:obj.countryCode]) {
                indexPath = [NSIndexPath indexPathForRow:idx inSection:[weakSelf.keys indexOfObject:key]];
            }
        }];
    }];
    if (indexPath) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma mark -- Init
- (void)initSet {
    self.dataSource = [LBCountryModel allCountriesDictionaryOfLanguage:self.language];
    self.showPhoneCodePlus = YES;
    
    if (self.uiConfig) {
        self.uiConfig(self.searchVC, self.tableView);
    }
}
- (void)initLayout {
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *t = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *b = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *l = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *r = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    [NSLayoutConstraint activateConstraints:@[t,b,l,r]];
    
}


#pragma mark -- Utilities
- (void)dealSelectCountry:(LBCountryModel *)country {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (self.selectCountry) {
        self.selectCountry(country);
    }
    NSLog(@"select country:%@", country);
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.keys.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = self.keys[section];
    NSArray *arr = self.dataSource[key];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    return cell;
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.keys;
}
#pragma mark -- UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.keys[section];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.keys[indexPath.section];
    NSArray *arr = self.dataSource[key];
    LBCountryModel *m = arr[indexPath.row];
    cell.textLabel.text = m.displayCountryName;
    cell.detailTextLabel.text = self.showPhoneCodePlus ? m.phoneCodePlus : m.phoneCode;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LBCountryModel *m = self.dataSource[self.keys[indexPath.section]][indexPath.row];
    [self dealSelectCountry:m];
}

#pragma mark -- UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *text = searchController.searchBar.text;
    if (text.length <= 0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSString *countryName;
        __block NSMutableArray *searchResults = [NSMutableArray arrayWithCapacity:0];
        __weak typeof(self) weakSelf = self;
        [self.keys enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *arr = weakSelf.dataSource[obj];
            for (LBCountryModel *m in arr) {
                countryName = m.displayCountryName;
                if ([countryName containsString:text] ||
                    [countryName.lowercaseString containsString:text.lowercaseString] ||
                    [countryName.lbc_pinyin.lowercaseString containsString:text.lowercaseString] ||
                    [countryName.lbc_pinyin.lbc_trimSpace.lowercaseString containsString:text.lowercaseString]) {
                    [searchResults addObject:m];
                }
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            LBCountrySearchVC *vc = (LBCountrySearchVC *)searchController.searchResultsController;
            [vc showCountries:searchResults showPhoneCodePlus:self.showPhoneCodePlus];
        });
    });
}

#pragma mark -- LBCountrySearchVCDelegate
- (void)searchVC:(LBCountrySearchVC *)vc selectCountry:(LBCountryModel *)country {
    self.searchVC.active = NO;
    [self dealSelectCountry:country];
}

@end
