//
//  ViewController.h
//  MultiImageDownloadDome
//
//  Created by 颜学宙 on 2021/3/18.
//

#import <UIKit/UIKit.h>
#import "MDDItemModel.h"
@interface ViewController : UIViewController


@end
@interface MDDTableCell : UITableViewCell
@property(nonatomic,strong)MDDItemModel *model;
@end
