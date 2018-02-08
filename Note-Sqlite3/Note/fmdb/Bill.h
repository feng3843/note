//
//  Bill.h
//  Note
//
//  Created by 朱鑫华 on 2017/11/22.
//  Copyright © 2017年 朱鑫华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bill : NSObject
@property (nonatomic,assign)  int  ID ;
@property (nonatomic,assign) float  count;
@property (nonatomic,copy) NSString  *date;
@property (nonatomic,copy) NSString  * kind;
@property (nonatomic,copy) NSString  * detail;
@end
