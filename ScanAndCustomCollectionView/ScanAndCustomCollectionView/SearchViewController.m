//
//  SearchViewController.m
//  NewWind
//
//  Created by 章丘研发 on 2018/4/9.
//  Copyright © 2018年 base. All rights reserved.
//

#import "SearchViewController.h"
#import "UdpSearch.h"
#import "SearchCollectionViewCell.h"
#import "RadarView.h"
#import "MyCollectionViewFolwLayout.h"
#import "ViewMacro.h"

@interface SearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UdpSearchDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UdpSearch *udpSearch;

@end


@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataSource = [[NSMutableArray alloc]init];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        
    
    [self cretateUI];
    

}



-(void)cretateUI{
    
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"saomiaoBackground"]];
    backgroundImageView.frame = CGRectMake(0, 0, screen_width, screen_height);
    [self.view addSubview:backgroundImageView];
    
    RadarView *radarView = [[RadarView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    [self.view addSubview:radarView];
    
    MyCollectionViewFolwLayout *flowLayout = [[MyCollectionViewFolwLayout alloc]init];
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = 20;
    
    flowLayout.itemSize = CGSizeMake(2*(screen_height-(screen_width+64)-40)/3, screen_height-(screen_width+64)-40);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, screen_width, screen_width, screen_height-(screen_width+64)) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"SearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"searchcell"];
    [self.view addSubview:_collectionView];
}



#pragma mark 点击事件
//配置按钮点击事件
-(void)configurationBtnAction:(UIButton *)sender{
    
    CGFloat itemWidth = 2*(screen_height-(screen_width+64)-40)/3;
    int centerX = (int)(self.collectionView.contentOffset.x + screen_width / 2);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag - 200 inSection:0];
    
    SearchCollectionViewCell *cell = (SearchCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    //在中心
    if (cell.center.x<centerX+2&&cell.center.x>centerX-2){
        
        NSLog(@"%ld",(long)sender.tag);

        
        
    }
    else {
        [self.collectionView setContentOffset:CGPointMake(itemWidth * indexPath.row + itemWidth / 2 - screen_width / 2, 0) animated:YES];
    }
    
}


#pragma mark UICollectionViewDataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchcell" forIndexPath:indexPath];

    if (_dataSource.count>0){
        NSString *IPAndMac = _dataSource[indexPath.row];
        NSArray *arr = [IPAndMac componentsSeparatedByString:@","];
        cell.deviceIP.text = [NSString stringWithFormat:@"IP:%@",arr[0]];
        cell.deviceMac.text = [NSString stringWithFormat:@"MAC:%@",arr[1]];
    }
    
    [cell.configurationBtn addTarget:self action:@selector(configurationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.configurationBtn.tag = indexPath.row + 200;
    
//    cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    cell.layer.cornerRadius = 15;
    cell.layer.masksToBounds = YES;
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return 10;
    return _dataSource.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


#pragma mark UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchCollectionViewCell *cell =(SearchCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    CGFloat itemWidth = 2*(screen_height-(screen_width+64)-40)/3;
    int centerX = (int)(self.collectionView.contentOffset.x + screen_width / 2);
    //在中心
    if (cell.center.x<centerX+2&&cell.center.x>centerX-2){
        
        

        
    }
    else {
        [self.collectionView setContentOffset:CGPointMake(itemWidth * indexPath.row + itemWidth / 2 - screen_width / 2, 0) animated:YES];
    }
}



#pragma mark UdpSearchDelegate 接收UDP搜索返回的设备IP和Mac

-(void)receiveData:(NSString *)receiveStr{
    if (![_dataSource containsObject:receiveStr]){
        [_dataSource addObject:receiveStr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionView reloadData];
        });
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [_udpSearch stopSearch];
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

@end
