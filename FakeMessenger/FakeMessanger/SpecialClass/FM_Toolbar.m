//
//  FM_Toolbar.m
//  FakeMessanger
//
//  Created by developer on 12/2/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import "FM_Toolbar.h"

@implementation FM_Toolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//Edit
        
        UIImage *editImage = [ UIImage imageNamed:is_ios_7()?@"FM_tbb_edit_ios7":@"FM_tbb_edit" ];
        UIView *editView = [ [ UIView alloc ] initWithFrame:CGRectMake(0, 0, editImage.size.width , editImage.size.height) ];
        
        self.editButton = [ UIButton buttonWithType:UIButtonTypeCustom ];
        self.editButton.frame = CGRectMake(0, 0, editImage.size.width, editImage.size.height);
        [ self.editButton setBackgroundImage:editImage forState:UIControlStateNormal ];

        [ editView addSubview:self.editButton ];
        
        UIBarButtonItem *edit = [ [ UIBarButtonItem alloc ] initWithCustomView:editView ];
        
//Carrier
        
        UIImage *carrierImage = [ UIImage imageNamed:is_ios_7()?@"FM_tbb_carrier_ios7":@"FM_tbb_carrier" ];
        UIView *carrierView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, carrierImage.size.width , carrierImage.size.height) ];
        
        self.carrierButton = [ UIButton buttonWithType:UIButtonTypeCustom ];
        self.carrierButton.frame = CGRectMake(0, 0, carrierImage.size.width, carrierImage.size.height);
        [ self.carrierButton setBackgroundImage:carrierImage forState:UIControlStateNormal ];
        
        [carrierView addSubview:self.carrierButton ];
        
        UIBarButtonItem *carrier = [ [ UIBarButtonItem alloc ] initWithCustomView:carrierView ];
        
//Mode
        
        UIImage *modeImage = [ UIImage imageNamed:is_ios_7()?@"FM_tbb_Mode":@"FM_tbb_Mode" ];
        UIView *modeView = [ [ UIView alloc ] initWithFrame:CGRectMake(0, 0, modeImage.size.width , modeImage.size.height) ];
        
        self.modeButton = [ UIButton buttonWithType:UIButtonTypeCustom ];
        self.modeButton.frame = CGRectMake(0, 0, modeImage.size.width, modeImage.size.height);
        [ self.modeButton setBackgroundImage:modeImage forState:UIControlStateNormal ];
        
        [ modeView addSubview:self.modeButton ];
    
        UIBarButtonItem *mode = [ [ UIBarButtonItem alloc ] initWithCustomView:modeView ];
        
//Clear
        
        self.clear = [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                  target:nil
                                                                                  action:nil ];

//ScreenShot
        
        self.screenShot = [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                                       target:nil
                                                                                       action:nil ];
        
//AddPost
        
        self.addPost = [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                    target:nil
                                                                                    action:nil ];
        
//Fixed
        
        UIBarButtonItem *fixedButton =[ [ UIBarButtonItem alloc ] init ];
        fixedButton.width = 10;

//Add to Toolbar
        
        self.toolbarButtons = [ [ NSMutableArray alloc ] initWithObjects:edit,fixedButton,
                                                                         carrier, fixedButton,
                                                                         mode, fixedButton,
                                                                         self.clear,fixedButton,
                                                                         self.screenShot,fixedButton,
                                                                         self.addPost,nil ];
        [ self setItems:self.toolbarButtons ];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
