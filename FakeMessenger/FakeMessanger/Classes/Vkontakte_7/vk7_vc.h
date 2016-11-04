//
//  vkontakteViewController.h
//  FakeMessanger
//
//  Created by developer on 8/30/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FM_Toolbar.h"

@interface vk7_vc : UIViewController < UITableViewDelegate, UITableViewDataSource,
                                      UIAlertViewDelegate, NSFetchedResultsControllerDelegate,
                                      UIActionSheetDelegate, UIImagePickerControllerDelegate,
                                      UINavigationControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;

//TabBar
///Tittle

@property (strong, nonatomic) UILabel *nameUser;
@property (strong, nonatomic) UILabel *labelOnline;
@property (nonatomic, strong) UIButton *buttonName;
@property (strong, nonatomic) UITextField *recipientField;

//Avatar

@property (nonatomic, strong) UIButton *avatarButton;

//ToolBar

@property (strong, nonatomic) FM_Toolbar *toolbar;
@property (strong, nonatomic) UITextField *carrierField;

//CoreData

@property (strong, nonatomic) NSFetchedResultsController *controller;

@end
