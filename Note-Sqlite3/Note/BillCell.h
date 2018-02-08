//
//  BillCell.h
//  Note
//
//  Created by 朱鑫华 on 2017/11/22.
//  Copyright © 2017年 朱鑫华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"

@protocol BillCellDelegate <NSObject>
-(void)didEdit:(Bill *)bill;
@end


@interface BillCell : UITableViewCell
@property (nonatomic,strong) Bill  * bill;
@property (nonatomic,weak) id<BillCellDelegate>  delegate;
@end
