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
@property (weak, nonatomic) IBOutlet UILabel *kind;
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
    self.kind.text = bill.kind;
    self.kount.text = [NSString stringWithFormat:@"%.2f",bill.count];
    self.detail.text = [bill.detail isEqualToString:@""]||bill.detail == nil?@"无":bill.detail ;
}

- (IBAction)edit:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didEdit:)]) {
        [self.delegate didEdit:self.bill];
    }
}


@end
