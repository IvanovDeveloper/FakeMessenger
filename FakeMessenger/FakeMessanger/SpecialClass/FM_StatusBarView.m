//
//  FM_StatusBarView.m
//  FakeMessanger
//
//  Created by developer on 12/5/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import "FM_StatusBarView.h"

@implementation FM_StatusBarView

- (id)initWithFrame:(CGRect)frame typeSkin:(NSString*)type carrierName:(NSString*)carrier
{
    self = [super initWithFrame:frame];
    if (self) {

#pragma mark VK

        if( [ type isEqualToString:@"vk" ] )
        {
            if ( is_ios_7() )
            {
                self.backgroundColor = [ UIColor blackColor ];
                
                //signal Level
                UIImageView *signalView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(0, 0, 40.f, 20.f)];
                signalView.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_signal_ios7",type ] ];
                
                //carrier Name
                UILabel *carrierNameLabel = [ [ UILabel alloc ] initWithFrame:CGRectMake(signalView.frame.size.width + 5.f, 3, 60.f, 20.f) ];
                carrierNameLabel.text = carrier;
                carrierNameLabel.textColor = [ UIColor whiteColor ];
                carrierNameLabel.textAlignment =  NSTextAlignmentCenter;
                carrierNameLabel.font = [ UIFont fontWithName:@"HelveticaNeue" size:12.f ];
                carrierNameLabel.backgroundColor = [ UIColor clearColor ];
                [ carrierNameLabel sizeToFit ];
                if ( carrierNameLabel.frame.size.width > 60.f )
                    carrierNameLabel.frame = CGRectMake(signalView.frame.size.width + 5.f, 3, 60.f, 20.f);
                
                //Wi-Fi
                UIImageView *wi_fi_View = [ [ UIImageView alloc ] initWithFrame:CGRectMake(carrierNameLabel.frame.origin.x + carrierNameLabel.frame.size.width + 5.f, 0, 12.5f, 20.f)];
                wi_fi_View.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_wifi_ios7",type ] ];
                
                //Time
                UILabel *timeLabel = [ [ UILabel alloc ] initWithFrame:CGRectMake(0, 0, 320.f, 20.f) ];
                timeLabel.backgroundColor = [ UIColor clearColor ];
                timeLabel.font = [ UIFont fontWithName:@"Helvetica-Bold" size:12.f ];
                timeLabel.textAlignment =  NSTextAlignmentCenter;
                timeLabel.textColor = [ UIColor whiteColor ];
                
                NSDate *now = [ NSDate date ];
                NSDateFormatter *timeFormatter = [ [ NSDateFormatter alloc] init ];
                timeFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"en_US_POSIX" ];
                timeFormatter.dateFormat = @"HH:mm";
                timeLabel.text = [timeFormatter stringFromDate:now];
                
                //Battery Level
                UIImageView *batteryView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(320.f - 58.5f, 0, 58.5f, 20.f)];
                batteryView.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_battery_ios7",type ] ];
                
                //Add to StatusBarView
                [ self addSubview:signalView ];
                [ self addSubview:carrierNameLabel ];
                [ self addSubview:wi_fi_View ];
                [ self addSubview:timeLabel ];
                [ self addSubview:batteryView ];
            }
            else
            {
                self.backgroundColor = [ UIColor blackColor ];
                
//signal Level
                
                UIImageView *signalView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(0, 0, 23.f, 20.f)];
                signalView.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_signal",type ] ];
                
                //carrier Name
                
                UILabel *carrierNameLabel = [ [ UILabel alloc ] initWithFrame:CGRectMake(25.f, 0, 60.f, 20.f) ];
                carrierNameLabel.text = carrier;
                carrierNameLabel.textAlignment =  NSTextAlignmentCenter;
                carrierNameLabel.font = [ UIFont fontWithName:@"Helvetica-Bold" size:14.f ];
                carrierNameLabel.textColor = [ UIColor colorWithRed:(191.0f/255.f) green:(191.0f/255.f)  blue:(191.0f/255.f) alpha:1.0 ];
                carrierNameLabel.backgroundColor = [ UIColor clearColor ];
                [ carrierNameLabel sizeToFit ];
                if ( carrierNameLabel.frame.size.width > 60.f )
                    carrierNameLabel.frame = CGRectMake(25.f, 0, 60.f, 20.f);
                
//Wi-Fi
                
                UIImageView *wi_fi_View = [ [ UIImageView alloc ] initWithFrame:CGRectMake(carrierNameLabel.frame.origin.x + carrierNameLabel.frame.size.width + 5.f, 0, 16, 20.f)];
                wi_fi_View.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_wifi",type ] ];
                
//Time
                
                UILabel *timeLabel = [ [ UILabel alloc ] initWithFrame:CGRectMake(0, 0, 320.f, 20.f) ];
                timeLabel.backgroundColor = [ UIColor clearColor ];
                timeLabel.textAlignment =  NSTextAlignmentCenter;
                timeLabel.font = [ UIFont fontWithName:@"Helvetica-Bold" size:14.f ];
                timeLabel.textColor = [ UIColor colorWithRed:(191.0f/255.f) green:(191.0f/255.f)  blue:(191.0f/255.f) alpha:1.0 ];
                
                NSDate *now = [ NSDate date ];
                NSDateFormatter *timeFormatter = [ [ NSDateFormatter alloc] init ];
                timeFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"en_US_POSIX" ];
                timeFormatter.dateFormat = @"HH:mm";
                timeLabel.text = [timeFormatter stringFromDate:now];
                
//Battery Level
                
                UIImageView *batteryView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(320.f - 55.f, 0, 55.f, 20.f)];
                batteryView.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_battery",type ] ];
                
//Add to StatusBarView
                
                [ self addSubview:signalView ];
                [ self addSubview:carrierNameLabel ];
                [ self addSubview:wi_fi_View ];
                [ self addSubview:timeLabel ];
                [ self addSubview:batteryView ];
            }
        }
        
    }
 
#pragma mark VK7
    
    if( [ type isEqualToString:@"vk7" ] )
    {
        self.backgroundColor = RGBa(82.0f, 127.0f, 178.0f, 1.0f);
        
        //signal Level
        
        UIImageView *signalView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(0, 0, 40.f, 20.f)];
        signalView.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_signal",type ] ];
        
        //carrier Name
        
        UILabel *carrierNameLabel = [ [ UILabel alloc ] initWithFrame:CGRectMake(signalView.frame.size.width + 5.f, 3, 60.f, 20.f) ];
        carrierNameLabel.text = carrier;
        carrierNameLabel.textColor = [ UIColor whiteColor ];
        carrierNameLabel.textAlignment =  NSTextAlignmentCenter;
        carrierNameLabel.font = [ UIFont fontWithName:@"HelveticaNeue" size:12.f ];
        carrierNameLabel.backgroundColor = [ UIColor clearColor ];
        [ carrierNameLabel sizeToFit ];
        if ( carrierNameLabel.frame.size.width > 60.f )
            carrierNameLabel.frame = CGRectMake(signalView.frame.size.width + 5.f, 3, 60.f, 20.f);
        
        //Wi-Fi
        
        UIImageView *wi_fi_View = [ [ UIImageView alloc ] initWithFrame:CGRectMake(carrierNameLabel.frame.origin.x + carrierNameLabel.frame.size.width + 5.f, 0, 12.5f, 20.f)];
        wi_fi_View.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_wifi",type ] ];
        
        //Time
        
        UILabel *timeLabel = [ [ UILabel alloc ] initWithFrame:CGRectMake(0, 0, 320.f, 20.f) ];
        timeLabel.backgroundColor = [ UIColor clearColor ];
        timeLabel.font = [ UIFont fontWithName:@"Helvetica-Bold" size:12.f ];
        timeLabel.textAlignment =  NSTextAlignmentCenter;
        timeLabel.textColor = [ UIColor whiteColor ];
        
        NSDate *now = [ NSDate date ];
        NSDateFormatter *timeFormatter = [ [ NSDateFormatter alloc] init ];
        timeFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"en_US_POSIX" ];
        timeFormatter.dateFormat = @"HH:mm";
        timeLabel.text = [timeFormatter stringFromDate:now];
        
        //Battery Level
        
        UIImageView *batteryView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(320.f - 58.5f, 0, 58.5f, 20.f)];
        batteryView.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_battery",type ] ];
        
        //Add to StatusBarView
        
        [ self addSubview:signalView ];
        [ self addSubview:carrierNameLabel ];
        [ self addSubview:wi_fi_View ];
        [ self addSubview:timeLabel ];
        [ self addSubview:batteryView ];
    }
    
#pragma mark i

    if ( [ type isEqualToString:@"i" ] )
    {
        self.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_background",type ] ];
        
//signal Level
        
        UIImageView *signalView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(0, 0, 23.f, 20.f)];
        signalView.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_signal",type ] ];
        
//carrier Name
        
        UILabel *carrierNameLabel = [ [ UILabel alloc ] initWithFrame:CGRectMake(26.f, 2.5f, 60.f, 20.f) ];
        carrierNameLabel.text = carrier;
        carrierNameLabel.textColor = [ UIColor colorWithRed:(189.0f/255.f) green:(199.0f/255.f)  blue:(211.0f/255.f) alpha:1.0 ];
        carrierNameLabel.textAlignment =  NSTextAlignmentCenter;
        carrierNameLabel.font = [ UIFont fontWithName:@"Helvetica-Bold" size:13.f ];
        carrierNameLabel.backgroundColor = [ UIColor clearColor ];
        [ carrierNameLabel sizeToFit ];
        if ( carrierNameLabel.frame.size.width > 60.f )
            carrierNameLabel.frame = CGRectMake(26.f, 2.5f, 60.f, 20.f);
        
//Wi-Fi
        
        UIImageView *wi_fi_View = [ [ UIImageView alloc ] initWithFrame:CGRectMake(carrierNameLabel.frame.origin.x + carrierNameLabel.frame.size.width + 5.f, 0, 16.f, 20.f)];
        wi_fi_View.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_wifi",type ] ];
        
//Time
        
        UILabel *timeLabel = [ [ UILabel alloc ] initWithFrame:CGRectMake(0, 0, 320.f, 20.f) ];
        timeLabel.backgroundColor = [ UIColor clearColor ];
        timeLabel.font = [ UIFont fontWithName:@"Helvetica-Bold" size:14.f ];
        timeLabel.textAlignment =  NSTextAlignmentCenter;
        timeLabel.textColor = [ UIColor colorWithRed:(189.0f/255.f) green:(199.0f/255.f)  blue:(211.0f/255.f) alpha:1.0 ];
        
        NSDate *now = [ NSDate date ];
        NSDateFormatter *timeFormatter = [ [ NSDateFormatter alloc] init ];
        timeFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"en_US_POSIX" ];
        timeFormatter.dateFormat = @"HH:mm";
        timeLabel.text = [timeFormatter stringFromDate:now];

//Battery Level
        
        UIImageView *batteryView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(320.f - 55.f, 0, 55.f, 20.f)];
        batteryView.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_battery",type ] ];
        
//Add to StatusBarView
        
        [ self addSubview:signalView ];
        [ self addSubview:carrierNameLabel ];
        [ self addSubview:wi_fi_View ];
        [ self addSubview:timeLabel ];
        [ self addSubview:batteryView ];
    }
    
#pragma mark i7
    
    if( [ type isEqualToString:@"i7" ] )
    {
        self.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_background",type ] ];
        
//signal Level
        
        UIImageView *signalView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(0, 0, 40.f, 20.f)];
        signalView.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_signal",type ] ];
        
//carrier Name
        
        UILabel *carrierNameLabel = [ [ UILabel alloc ] initWithFrame:CGRectMake(signalView.frame.size.width + 3.f, 3, 60.f, 20.f) ];
        carrierNameLabel.text = carrier;
        carrierNameLabel.textColor = [ UIColor blackColor ];
        carrierNameLabel.textAlignment =  NSTextAlignmentCenter;
        carrierNameLabel.font = [ UIFont fontWithName:@"HelveticaNeue" size:12.f ];
        carrierNameLabel.backgroundColor = [ UIColor clearColor ];
        [ carrierNameLabel sizeToFit ];
        if ( carrierNameLabel.frame.size.width > 60.f )
            carrierNameLabel.frame = CGRectMake(signalView.frame.size.width + 3.f, 3, 60.f, 20.f);
        
//Wi-Fi
        
        UIImageView *wi_fi_View = [ [ UIImageView alloc ] initWithFrame:CGRectMake(carrierNameLabel.frame.origin.x + carrierNameLabel.frame.size.width + 5.f, 0, 12.5f, 20.f)];
        wi_fi_View.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_wifi",type ] ];
        
//Time
        
        UILabel *timeLabel = [ [ UILabel alloc ] initWithFrame:CGRectMake(0, 0, 320.f, 20.f) ];
        timeLabel.backgroundColor = [ UIColor clearColor ];
        timeLabel.font = [ UIFont fontWithName:@"Helvetica" size:12.f ];
        timeLabel.textAlignment =  NSTextAlignmentCenter;
        timeLabel.textColor = [ UIColor blackColor ];
        
        NSDate *now = [ NSDate date ];
        NSDateFormatter *timeFormatter = [ [ NSDateFormatter alloc] init ];
        timeFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"en_US_POSIX" ];
        timeFormatter.dateFormat = @"HH:mm";
        timeLabel.text = [timeFormatter stringFromDate:now];
        
//Battery Level
        
        UIImageView *batteryView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(320.f - 58.5f, 0, 58.5f, 20.f)];
        batteryView.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_battery",type ] ];
        
//Add to StatusBarView
        
        [ self addSubview:signalView ];
        [ self addSubview:carrierNameLabel ];
        [ self addSubview:wi_fi_View ];
        [ self addSubview:timeLabel ];
        [ self addSubview:batteryView ];
    }
    
#pragma mark VIB
    
    if( [ type isEqualToString:@"vib" ] )
    {
        self.backgroundColor = [ UIColor blackColor ];
        
//signal Level
        
        UIImageView *signalView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(0, 0, 40.f, 20.f)];
        signalView.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_signal",type ] ];
        
//carrier Name
        
        UILabel *carrierNameLabel = [ [ UILabel alloc ] initWithFrame:CGRectMake(signalView.frame.size.width + 5.f, 3, 60.f, 20.f) ];
        carrierNameLabel.text = carrier;
        carrierNameLabel.textColor = [ UIColor whiteColor ];
        carrierNameLabel.textAlignment =  NSTextAlignmentCenter;
        carrierNameLabel.font = [ UIFont fontWithName:@"HelveticaNeue" size:12.f ];
        carrierNameLabel.backgroundColor = [ UIColor clearColor ];
        [ carrierNameLabel sizeToFit ];
        if ( carrierNameLabel.frame.size.width > 60.f )
            carrierNameLabel.frame = CGRectMake(signalView.frame.size.width + 5.f, 3, 60.f, 20.f);
        
//Wi-Fi
        
        UIImageView *wi_fi_View = [ [ UIImageView alloc ] initWithFrame:CGRectMake(carrierNameLabel.frame.origin.x + carrierNameLabel.frame.size.width + 5.f, 0, 12.5f, 20.f)];
        wi_fi_View.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_wifi",type ] ];
        
//Time
        
        UILabel *timeLabel = [ [ UILabel alloc ] initWithFrame:CGRectMake(0, 0, 320.f, 20.f) ];
        timeLabel.backgroundColor = [ UIColor clearColor ];
        timeLabel.font = [ UIFont fontWithName:@"Helvetica-Bold" size:12.f ];
        timeLabel.textAlignment =  NSTextAlignmentCenter;
        timeLabel.textColor = [ UIColor whiteColor ];
        
        NSDate *now = [ NSDate date ];
        NSDateFormatter *timeFormatter = [ [ NSDateFormatter alloc] init ];
        timeFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"en_US_POSIX" ];
        timeFormatter.dateFormat = @"HH:mm";
        timeLabel.text = [timeFormatter stringFromDate:now];
        
//Battery Level
        
        UIImageView *batteryView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(320.f - 58.5f, 0, 58.5f, 20.f)];
        batteryView.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_battery",type ] ];
        
//Add to StatusBarView
        
        [ self addSubview:signalView ];
        [ self addSubview:carrierNameLabel ];
        [ self addSubview:wi_fi_View ];
        [ self addSubview:timeLabel ];
        [ self addSubview:batteryView ];
    }

#pragma mark WAT
    
    if( [ type isEqualToString:@"wat" ] )
    {
        self.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_background",type ] ];
        
//signal Level
        
        UIImageView *signalView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(0, 0, 40.f, 20.f)];
        signalView.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_signal",type ] ];
        
//carrier Name
        
        UILabel *carrierNameLabel = [ [ UILabel alloc ] initWithFrame:CGRectMake(signalView.frame.size.width + 3.f, 3, 60.f, 20.f) ];
        carrierNameLabel.text = carrier;
        carrierNameLabel.textColor = [ UIColor blackColor ];
        carrierNameLabel.textAlignment =  NSTextAlignmentCenter;
        carrierNameLabel.font = [ UIFont fontWithName:@"HelveticaNeue " size:12.f ];
        carrierNameLabel.backgroundColor = [ UIColor clearColor ];
        [ carrierNameLabel sizeToFit ];
        if ( carrierNameLabel.frame.size.width > 60.f )
            carrierNameLabel.frame = CGRectMake(signalView.frame.size.width + 3.f, 3, 60.f, 20.f);
        
//Wi-Fi
        
        UIImageView *wi_fi_View = [ [ UIImageView alloc ] initWithFrame:CGRectMake(carrierNameLabel.frame.origin.x + carrierNameLabel.frame.size.width + 5.f, 0, 12.5f, 20.f)];
        wi_fi_View.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_wifi",type ] ];
        
//Time
        
        UILabel *timeLabel = [ [ UILabel alloc ] initWithFrame:CGRectMake(0, 0, 320.f, 20.f) ];
        timeLabel.backgroundColor = [ UIColor clearColor ];
        timeLabel.font = [ UIFont fontWithName:@"Helvetica" size:12.f ];
        timeLabel.textAlignment =  NSTextAlignmentCenter;
        timeLabel.textColor = [ UIColor blackColor ];
        
        NSDate *now = [ NSDate date ];
        NSDateFormatter *timeFormatter = [ [ NSDateFormatter alloc] init ];
        timeFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"en_US_POSIX" ];
        timeFormatter.dateFormat = @"HH:mm";
        timeLabel.text = [timeFormatter stringFromDate:now];
        
//Battery Level
        
        UIImageView *batteryView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(320.f - 58.5f, 0, 58.5f, 20.f)];
        batteryView.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%@_sb_battery",type ] ];
        
//Add to StatusBarView
        
        [ self addSubview:signalView ];
        [ self addSubview:carrierNameLabel ];
        [ self addSubview:wi_fi_View ];
        [ self addSubview:timeLabel ];
        [ self addSubview:batteryView ];
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
