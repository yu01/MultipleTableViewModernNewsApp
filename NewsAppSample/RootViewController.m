//
//  RootViewController.m
//  NewsAppSample
//
//  Created by jun on 2014/11/29.
//  Copyright (c) 2014年 edu.self. All rights reserved.
//

#import "RootViewController.h"


@interface RootViewController ()

@end

@implementation RootViewController


- (void)awakeFromNib
{

    [self setCenterPanel:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainViewController"]];
    [self setRightPanel:[[UIStoryboard storyboardWithName:@"Settings" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingsViewController"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // get NSNOtificationCenter
    NSNotificationCenter *notificationCenter;
    notificationCenter = [NSNotificationCenter defaultCenter];
    
    // register observer
    [notificationCenter addObserver:self selector:@selector(openLeftPanel:) name:@"openSettings" object:nil];
    [notificationCenter addObserver:self selector:@selector(closeLeftPanel:) name:@"closeSettings" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)openLeftPanel:(id)sender
{
    [self showRightPanelAnimated:YES];
}

-(void)closeLeftPanel:(id)sender
{
    [self showCenterPanelAnimated:YES];
}

@end
