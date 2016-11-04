//
//  ViewController.m
//  FakeMessanger
//
//  Created by developer on 8/9/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import "menu_vc.h"
#import "AppDelegate.h"

#import "i_vc.h"
#import "i7_vc.h"
#import "vib_vc.h"
#import "vk_vc.h"
#import "vk7_vc.h"
#import "wat_vc.h"

@implementation menu_vc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Menu";
    self.view.backgroundColor = [ UIColor whiteColor ];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.title = @"Menu";
    [ self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault ];
}

#pragma mark - ON Button  -

-(IBAction)oni:(id)sender
{
    i_vc *newIphoneMessager = [ [ i_vc alloc ] init ];
    [ self.navigationController pushViewController:newIphoneMessager animated:YES ];
}

-(IBAction)oni7:(id)sender
{
    i7_vc *newIphoneMessager = [ [ i7_vc alloc ] init ];
    [ self.navigationController pushViewController:newIphoneMessager animated:YES ];
}

-(IBAction)onVib:(id)sender
{
    vib_vc *newVkonakteMessager = [ [ vib_vc alloc ] init ];
    [ self.navigationController pushViewController:newVkonakteMessager animated:YES ];
}

-(IBAction)onVK:(id)sender
{
    vk_vc *newVkonakteMessager = [ [ vk_vc alloc ] init ];
    [ self.navigationController pushViewController:newVkonakteMessager animated:YES ];
}

-(IBAction)onVK7:(id)sender
{
    vk7_vc *newVkonakteMessager = [ [ vk7_vc alloc ] init ];
    [ self.navigationController pushViewController:newVkonakteMessager animated:YES ];
}

-(IBAction)onWAT:(id)sender
{
    wat_vc *newVkonakteMessager = [ [ wat_vc alloc ] init ];
    [ self.navigationController pushViewController:newVkonakteMessager animated:YES ];
}

#pragma mark - Default methods -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end