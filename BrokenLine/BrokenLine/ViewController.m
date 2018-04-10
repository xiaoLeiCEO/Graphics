//
//  ViewController.m
//  BrokenLine
//
//  Created by 王长磊 on 2018/1/6.
//  Copyright © 2018年 base. All rights reserved.
//

#import "ViewController.h"
#import "ViewMacro.h"
#import "BrokenView.h"

@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *dataSourceX;
@property (nonatomic,strong) NSMutableArray *dataSourceY;

@property (nonatomic,strong) BrokenView *brokenView;

@property (nonatomic,assign) LineType LineType;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _dataSourceX = [[NSMutableArray alloc]init];
    _dataSourceY = [[NSMutableArray alloc]init];
    _brokenView = [[BrokenView alloc]initWithFrame:CGRectMake(0, 170, screen_width, screen_width) withBounceX:50 withBounceY:50];
    _brokenView.backgroundColor = [UIColor cyanColor];
    _brokenView.itemSize = CGSizeMake(50, 50);
    [self.view addSubview:_brokenView];
    
    
    UIButton *generalBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    generalBtn.frame = CGRectMake(50, screen_height-80, 100, 50);
    [generalBtn setTitle:@"普通折线" forState:normal];
    generalBtn.tag = 200;
    [generalBtn addTarget:self action:@selector(brokenLineStyle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:generalBtn];
    
    UIButton *circleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    circleBtn.frame = CGRectMake(screen_width-50-100, screen_height-80, 100, 50);
    [circleBtn setTitle:@"平滑折线" forState:normal];
    circleBtn.tag = 300;
    [circleBtn addTarget:self action:@selector(brokenLineStyle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:circleBtn];
}


-(void)brokenLineStyle:(UIButton *)sender{
    _LineType = sender.tag==200 ? general:circle;
    _brokenView.lineType = _LineType;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

        [self.dataSourceX addObject:[self getCurrentTime]];
        float yData = arc4random() % 100;
        [self.dataSourceY addObject:[NSString stringWithFormat:@"%.2f",yData]];
    
    
    //注意这个地方要先设置X轴数据，再设置Y轴数据，否则会奔溃
    _brokenView.dataSourceX = self.dataSourceX;
    _brokenView.dataSourceY = self.dataSourceY;
    
}

//获取系统当前时间
-(NSString *)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
