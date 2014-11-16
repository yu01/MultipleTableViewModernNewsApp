//
//  ViewController.m
//  NewsAppSample
//
//  Created by jun on 2014/11/16.
//  Copyright (c) 2014年 edu.self. All rights reserved.
//

#import "ViewController.h"
#import "PagingScrollView.h"



@interface ViewController ()

@property ScrollMenuBar *scrollMenuBar;
@property NSArray *pageTitles;


@end


static const float HEADER_HEIGHT = 60.0f;

@implementation ViewController{
    PagingScrollView *scrollView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

}

- (void)viewWillAppear:(BOOL)animated{
    [self loadPagingScrollView];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PagingScrollView

- (void)loadPagingScrollView
{
    int numberOfTables = 6;
    float tableWidth = self.view.bounds.size.width;
    
    CGFloat height = self.view.bounds.size.height;
    CGRect tableBounds = CGRectMake(0.0f, 0.0f, tableWidth, CGRectGetHeight(self.view.bounds));
    
    scrollView = [[PagingScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width, self.view.bounds.size.height)];

    scrollView.contentSize = CGSizeMake(tableWidth * numberOfTables, height);
    scrollView.pagingEnabled = YES;
    scrollView.bounds = tableBounds; // scrollViewのページングをtableWidth単位に。
    scrollView.clipsToBounds = NO;   // 非表示になっているtableBounds外を表示。
    scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scrollView];
    
    // ５つのtableViewを横に並べる
    CGRect tableFrame = tableBounds;

    tableFrame.origin.x = 0.f;
    tableFrame.origin.y = HEADER_HEIGHT;
    for (int i = 0; i < numberOfTables; i++) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
        
        switch (i) {
            case 0:
                tableView.backgroundColor = [UIColor greenColor];
                break;
            case 1:
                tableView.backgroundColor = [UIColor redColor];
                break;
            case 2:
                tableView.backgroundColor = [UIColor blueColor];
                break;
            case 3:
                tableView.backgroundColor = [UIColor orangeColor];
                break;
            case 4:
                tableView.backgroundColor = [UIColor purpleColor];
                break;
            case 5:
                tableView.backgroundColor = [UIColor grayColor];
            default:
                break;
        }
        [scrollView addSubview:tableView];
        
        tableFrame.origin.x += tableWidth;
    }
    
    // Create the data model
    _pageTitles = @[@"Rails", @"iOS", @"Android", @"プロセス", @"インフラ", @"キャリア"];
    
    // メニューバー追加
    NSArray *menus = [self setupMenus];
    _scrollMenuBar = [[ScrollMenuBar alloc] initWithArray:menus point:CGPointMake(0, 20)] ;

    
    _scrollMenuBar.delegate = self ;
    [self.view addSubview:_scrollMenuBar];
    
    
}

/*
 * create elements of menu bar
 */
- (NSArray *)setupMenus {
    return @[
             @{
                 @"title":@"Rails",
                 @"color":[ScrollMenuBar smartGreen]
                 }, @{
                 @"title":@"iOS",
                 @"color":[ScrollMenuBar smartRed]
                 }, @{
                 @"title":@"Android",
                 @"color":[ScrollMenuBar smartBlue]
                 }, @{
                 @"title":@"プロセス",
                 @"color":[ScrollMenuBar smartOrange]
                 }, @{
                 @"title":@"インフラ",
                 @"color":[ScrollMenuBar smartPurple]
                 }, @{
                 @"title":@"キャリア",
                 @"color":[ScrollMenuBar smartGray]
                 },
             ] ;
    
}
#pragma mark - ScrollMenuBarDelegate
- (void)scrollMenuBar:(ScrollMenuBar *)scrollMenuBar selected:(NSInteger)selectedIndex
{
    int tabIndex = [_scrollMenuBar selectedIndex];
    float viewWidth = CGRectGetWidth(self.view.bounds);
    
    [scrollView setContentOffset:CGPointMake(tabIndex * viewWidth, 0)];
    
}

@end
