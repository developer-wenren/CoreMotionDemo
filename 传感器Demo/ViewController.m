//
//  ViewController.m
//  传感器Demo
//
//  Created by zjsruxxxy3 on 15/4/25.
//  Copyright (c) 2015年 WR. All rights reserved.
//

#import "ViewController.h"
@import CoreMotion;

@interface ViewController ()<UIAccelerometerDelegate>

@property(nonatomic,weak)IBOutlet UIButton *centerButton;

@property(nonatomic,strong)CMMotionManager *mgr;

-(IBAction)clickButton:(UIButton *)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /**
     *  添加距离传感器检测
     */
//    [self addDistanceSensor];
    
    
    /**
     *  添加加速计传感器检测
     */
//    [self addAccelerationSensorByUIAccelerometer];
//    [self addAccelerationSensorByCoreMotion];
//    [self addAccelerationSensorByCoreMotionUsingPull];
    
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CMAccelerometerData *accelerometerData = self.mgr.accelerometerData;
    
    NSLog(@"%f----%f",accelerometerData.acceleration.x,accelerometerData.acceleration.y);
}


#pragma mark 加速器
// 1.UIAccelerometer
-(void)addAccelerationSensorByUIAccelerometer
{
    UIAccelerometer *alt = [UIAccelerometer sharedAccelerometer];
    
    alt.delegate = self;
    
    alt.updateInterval = 1.0f;
    
}

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    NSLog(@"x:%f---y:%f---z:%f",acceleration.x,acceleration.y,acceleration.z);
    
}

// 1.CoreMotion
-(void)addAccelerationSensorByCoreMotion
{
    self.mgr = [[CMMotionManager alloc]init];
    
    if (self.mgr.isMagnetometerAvailable)
    {
        self.mgr.accelerometerUpdateInterval = 1.0f;
        
        [self.mgr startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            
            NSLog(@"%f----%f",accelerometerData.acceleration.x,accelerometerData.acceleration.y);
        }];
        
        
    }else
    {
        NSLog(@"不可用");
    }
}

-(void)clickButton:(UIButton *)sender
{
//    [self.mgr stopMagnetometerUpdates];
    
    self.mgr = nil;
//    [self.mgr stopMagnetometerUpdates];
    
}

-(void)addAccelerationSensorByCoreMotionUsingPull
{
    self.mgr = [[CMMotionManager alloc]init];
    
    if (self.mgr.isMagnetometerAvailable)
    {
        
        [self.mgr startAccelerometerUpdates];
        


    }else
    {
        NSLog(@"不可用");
    }
}

#pragma mark 距离传感器 ProximityMonitor
-(void)addDistanceSensor
{
    [[UIDevice currentDevice]setProximityMonitoringEnabled:YES];
    
    
    
    
    // 1.通知 可在子线程或者主线程执行
    [[NSNotificationCenter defaultCenter]addObserverForName:UIDeviceProximityStateDidChangeNotification object:nil queue:[[NSOperationQueue alloc]init] usingBlock:^(NSNotification *note) {
            NSLog(@"%@",[NSThread currentThread]);
        
        if ([[UIDevice currentDevice] proximityState])
        {
            
//            [self.centerButton setTitle:@"有人接近" forState:UIControlStateNormal];
            
            NSLog(@"有人接近了");
            
            
            
        }else
        {
            [self.centerButton setTitle:@"有人接近过" forState:UIControlStateNormal];

        }
        
    }];
    
    //.2 原来的通知
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(note) name:UIDeviceProximityStateDidChangeNotification object:nil];
    
    
}

-(void)note
{
    if ([[UIDevice currentDevice] proximityState])
    {
        
        //            [self.centerButton setTitle:@"有人接近" forState:UIControlStateNormal];
        
        NSLog(@"有人接近了");
        
        
        
    }else
    {
        [self.centerButton setTitle:@"有人接近过" forState:UIControlStateNormal];
        
    }
}

-(void)dealloc
{
    
#warning !!!!---通知必须在dealloc处移除
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

@end
