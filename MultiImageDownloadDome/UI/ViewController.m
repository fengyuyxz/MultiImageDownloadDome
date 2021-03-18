//
//  ViewController.m
//  MultiImageDownloadDome
//
//  Created by 颜学宙 on 2021/3/18.
//

#import "ViewController.h"
#import "MDDItemModel.h"
#import "MDDImageCache.h"
#import "UIImageView+MDDCache.h"
#define SPACE 5
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray<MDDItemModel *> *dataSouce;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[MDDTableCell class] forCellReuseIdentifier:@"MDDTableCell"];
    MDDImageCache *m1=[[MDDImageCache alloc]init];
    MDDImageCache *m2=[MDDImageCache shareMDDImageCache];
    NSLog(@"%p -- %p",m1,m2);
}

-(IBAction)startClick{
    __weak typeof(self) weakSefl = self;
    _dataSouce=[[NSMutableArray alloc]init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[NSBundle mainBundle]pathForResource:@"dataSouce" ofType:@"plist"];
        NSArray<NSDictionary *> *list =[NSArray arrayWithContentsOfFile:path];
        
        for (NSDictionary *dic in list) {
            MDDItemModel *model = [MDDItemModel shareMDDItemModel:dic];
            [weakSefl.dataSouce addObject:model];
        }
        
        [weakSefl.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    });
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSouce.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDDTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MDDTableCell"];
    
    MDDItemModel *model = self.dataSouce[indexPath.row];
    cell.model = model;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

@end
@interface MDDTableCell()
@property(nonatomic,weak)UIImageView *iconImageView;
@property(nonatomic,weak)UILabel *nameTitleLabel;
@end
@implementation MDDTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}
-(void)configUI{
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.backgroundColor = [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:0.8];
    [self.contentView addSubview:imgView];
    self.iconImageView = imgView;
    UILabel *label = [[UILabel alloc]init];
    label.font=[UIFont systemFontOfSize:16];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:label];
    self.nameTitleLabel = label;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    self.iconImageView.frame = CGRectMake(SPACE, SPACE, height-SPACE*2, height-SPACE*2);
    self.nameTitleLabel.frame = CGRectMake(height, SPACE, width-height, height-SPACE*2);
}
-(void)setModel:(MDDItemModel *)model{
    _model = model;
    self.nameTitleLabel.text=_model.name?_model.name:@"";
    NSURL *url = [NSURL URLWithString:_model.image?_model.image:@""];
    [self.iconImageView mdd_setImage:url completion:^(UIImage * _Nonnull image, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"download error --- %@",error);
        }
    }];
}
@end
