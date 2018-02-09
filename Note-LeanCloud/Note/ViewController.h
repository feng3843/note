//
//  ViewController.h
//  Note
//
//  Created by 朱鑫华 on 2017/11/22.
//  Copyright © 2017年 朱鑫华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"

typedef void(^NeedRefreshData)(BOOL flag);


@interface ViewController : UIViewController
@property (nonatomic,strong) Bill  * bill;
@property (nonatomic,copy) NeedRefreshData  needRefreshData;
@end

//衣服",@"饮食",@"居住",@"交通",@"人情往来",@"医疗",@"娱乐",@"母婴",@"其他"
