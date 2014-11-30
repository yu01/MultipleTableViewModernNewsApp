//
//  ViewController.m
//  NewsAppSample
//
//  Created by jun on 2014/11/16.
//  Copyright (c) 2014年 edu.self. All rights reserved.
//

#import "MainViewController.h"
#import "PagingScrollView.h"
#import "CoreData+MagicalRecord.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "Article.h"



@interface MainViewController ()

@property (nonatomic) NSMutableArray *articles;
@property ScrollMenuBar *scrollMenuBar;
@property NSArray *pageTitles;


@end


static const float HEADER_HEIGHT = 80.0f;
static const float STATUS_BAR_HEIGHT = 20.0f;
static const float SCROLL_MENU_BAR_HEIGHT = 40.0f;

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })


@implementation MainViewController{
    PagingScrollView *scrollView;
    
    //To interact with the API, create an instance variable
    AFHTTPRequestOperationManager *_operationManager;
}

#pragma mark - View LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Initialize AFHTTPRequestOperationManager with API Base URL
//    _operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.dribbble.com/"]];
    _operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://geeknews.herokuapp.com/"]];
    
    [self refreshData];
    
    //Refresh button
    
}

- (void)viewWillAppear:(BOOL)animated{

    [self configureUI];
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI
{
    [self loadPagingScrollView];
    
    [self loadSettingsButton];
}

-(void)loadSettingsButton
{
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    
    //
    //settings button
    CGFloat inset = 20;
    CGFloat settingsButtonHeight = 32;
    CGFloat settingsButtonWidth = 32;
    
    CGRect settingsButtonFrame = CGRectMake(screenFrame.size.width - (settingsButtonWidth + inset),
                                            screenFrame.size.height - (settingsButtonHeight + inset),
                                            settingsButtonWidth,
                                            settingsButtonHeight);
    
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton setFrame:settingsButtonFrame];
    
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"settings_button"] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(respondToPushSettingsButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:settingsButton];
    
    //bringSubViewToFront
    //Moves the specified subview so that it appears on top of its siblings.
    //This method moves the specified view to the end of the array of views in the subviews property.
    [self.view bringSubviewToFront:settingsButton];
    
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
    [self configureCell:cell atIndex:indexPath];
    return cell;
}

-(void)configureCell:(UITableViewCell*)cell atIndex:(NSIndexPath*)indexPath{
    // Get current article
    Article *article = self.articles[indexPath.row];
    cell.textLabel.text = article.title;
    
}

#pragma mark - API
- (void)refreshData
{
    //Fetch articles from API
    [_operationManager GET:@"api/v1/article" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        //AFNetworking parses the JSON response, which can now be used like a NSDictionary
        id articles = operation.responseObject;

        //for debug
        [Article MR_truncateAll];
        
        //Loop through articles from API
        for(id article in articles){

            //Take some values we'll need
            NSString *title = [article objectForKey:@"title"];
            NSString *link = [article objectForKey:@"link"];
            NSString *imageUrl = @"";
            NSString *body = NULL_TO_NIL([article objectForKey:@"description"]);
            NSInteger categoryId = [[article objectForKey:@"icategory_id"] integerValue];
            
            //Check if we already saved this articles...
            Article *existingEntity = [Article MR_findFirstByAttribute:@"link" withValue:link];

            //... if not, create a new entity
            if(!existingEntity)
            {
                Article *articleEntity = [Article MR_createEntity];
                articleEntity.categoryId = categoryId;
                articleEntity.title = title;
                articleEntity.imageUrl = imageUrl;
                articleEntity.body = (body == nil)? @"" : body;
                articleEntity.link = link;
            }
        }
        
        //Persist created entities to storage
        [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
            
            //Fetch all stored entitieds & reload tableView
            self.articles = [[Article MR_findAll] mutableCopy];
            
            for(UIView *view in [scrollView subviews]){
                if([view isKindOfClass:[UITableView class]]){
                    UITableView *tableView = (UITableView*)view;
                    tableView.delegate = self;
                    tableView.dataSource = self;
                    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
                    [tableView reloadData];
                }
            }
            
        } completion:^(BOOL success, NSError *error) {
            nil;
        }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to fetch articles from API");
    }];
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
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    // ５つのtableViewを横に並べる
    CGRect tableFrame = tableBounds;

    tableFrame.origin.x = 0.f;
    tableFrame.origin.y = (STATUS_BAR_HEIGHT + HEADER_HEIGHT);
    for (int i = 0; i < numberOfTables; i++) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
        
        //TODO refactore
        switch (i) {
            case 0:
                tableView.backgroundColor = [UIColor greenColor];
                tableView.tag = 100;
                break;
            case 1:
                tableView.backgroundColor = [UIColor redColor];
                tableView.tag = 110;
                break;
            case 2:
                tableView.backgroundColor = [UIColor blueColor];
                tableView.tag = 120;
                break;
            case 3:
                tableView.backgroundColor = [UIColor orangeColor];
                tableView.tag = 130;
                break;
            case 4:
                tableView.backgroundColor = [UIColor purpleColor];
                tableView.tag = 140;
                break;
            case 5:
                tableView.backgroundColor = [UIColor grayColor];
                tableView.tag = 150;
                break;
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
    _scrollMenuBar = [[ScrollMenuBar alloc] initWithArray:menus point:CGPointMake(0, (STATUS_BAR_HEIGHT+ SCROLL_MENU_BAR_HEIGHT))] ;

    
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
#pragma mark - handle touch event

-(void)respondToPushSettingsButton:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openSettings" object:self userInfo:nil];
}

@end
