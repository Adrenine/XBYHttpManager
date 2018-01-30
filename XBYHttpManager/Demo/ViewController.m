//
//  ViewController.m
//  XBYHttpManager
//
//  Created by xiebangyao on 2018/1/29.
//  Copyright © 2018年 xby. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "XBYTableView.h"
#import "DataModel.h"
#import "XBYHttpManager.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, XBYTableViewDelegate>

@property (nonatomic, strong) XBYTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataArray = @[].mutableCopy;
    [self.view addSubview:self.tableView];
    [self loadDataNeedRestData:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)loadDataNeedRestData:(BOOL)reset {
    if (reset) {
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [self.tableView resetPage];
    }
    
    XBYGET(fullHttpUrl(@""), nil, ^(NSURLSessionDataTask *task, id responseObject, BOOL suc) {
        if (suc) {
            NSArray *dataArray = responseObject[@"movies"];
            
            [self.dataArray addObjectsFromArray:[DataModel mj_objectArrayWithKeyValuesArray:dataArray]];
            self.tableView.totalSize = 30;      //假数据，测试是否停止加载更多
            [self.tableView reloadData];
        } else {
            
        }
    }, ^(NSURLSessionDataTask *task, NSError *error) {
        
    });
}

#pragma mark - XBYTableViewDelegate
- (void)refreshTableView:(XBYTableView *)tableView loadNewDataWithPage:(NSInteger)page {
    [self loadDataNeedRestData:YES];
}

- (void)refreshTableView:(XBYTableView *)tableView loadMoreDataWithPage:(NSInteger)page {
    [self loadDataNeedRestData:NO];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    DataModel *model = self.dataArray[indexPath.section];
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",model.actorName1,model.titleCn];
    return cell;
}

#pragma mark - Getter
- (XBYTableView *)tableView {
    if (!_tableView) {
        _tableView = [[XBYTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.refreshDelegate = self;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.from = 1;    //设置起始页为1
        _tableView.pageSize = 15;   //设置每一页数据为15条
        _tableView.pageAddOne = YES;    //页数自动加一
    }
    
    return _tableView;
}

@end
