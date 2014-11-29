//
//  Entity.h
//  NewsAppSample
//
//  Created by jun on 2014/11/30.
//  Copyright (c) 2014年 edu.self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Article : NSManagedObject

@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSString * title;

@end
