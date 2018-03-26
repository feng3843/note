//
//  BillCell.m
//  Note
//
//  Created by 朱鑫华 on 2017/11/22.
//  Copyright © 2017年 朱鑫华. All rights reserved.
//

#import "BillCell.h"
@interface BillCell()
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *iconV;
@property (weak, nonatomic) IBOutlet UILabel *kount;
@property (weak, nonatomic) IBOutlet UIButton *edit;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@end

@implementation BillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setBill:(Bill *)bill{
    _bill = bill;
    self.time.text = [bill.date substringToIndex:10];
    if ([bill.kind isEqualToString:@"衣服"]) {
        self.iconV.image = [UIImage imageNamed:@"ic_shirt"];
    }else  if ([bill.kind isEqualToString:@"饮食"]) {
         self.iconV.image = [UIImage imageNamed:@"ic_food"];
    }else  if ([bill.kind isEqualToString:@"居住"]) {
         self.iconV.image = [UIImage imageNamed:@"ic_home"];
    }else  if ([bill.kind isEqualToString:@"交通"]) {
         self.iconV.image = [UIImage imageNamed:@"ic_car"];
    }else  if ([bill.kind isEqualToString:@"人情往来"]) {
         self.iconV.image = [UIImage imageNamed:@"ic_gift"];
    }else  if ([bill.kind isEqualToString:@"医疗"]) {
         self.iconV.image = [UIImage imageNamed:@"ic_madical"];
    }else  if ([bill.kind isEqualToString:@"娱乐"]) {
         self.iconV.image = [UIImage imageNamed:@"ic_game"];
    }else{//其他
         self.iconV.image = [UIImage imageNamed:@"ic_other"];
    }
    self.kount.text = [NSString stringWithFormat:@"%.2f",bill.count];
    self.detail.text = [bill.detail isEqualToString:@""]||bill.detail == nil?@"无":bill.detail ;
}

- (IBAction)edit:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didEdit:)]) {
        [self.delegate didEdit:self.bill];
    }
}


@end
