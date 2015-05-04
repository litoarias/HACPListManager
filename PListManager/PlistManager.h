//
//  PlistManager.h
//  SantanderRio
//
//  Created by Invitado on 22/1/15.
//  Copyright (c) 2015 Indra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PlistManager : NSObject

+ (BOOL) createFullFilePath:(NSString *)fileName;
+ (void) insertObjectWithData:(NSDictionary *)data fileName:(NSString *) fileName;
+ (void) deleteObjectWithData:(NSDictionary *)data fileName:(NSString *) fileName;
+ (void) deleteAllObjectsWithFileName:(NSString *) fileName;
+ (NSDictionary *) getLastObjectWithFileName:(NSString *) fileName;
+ (NSArray *) getAllObjectsWithFileName:(NSString *) fileName;
+ (BOOL) containsObject:(NSDictionary *)data fileName:(NSString *) fileName;
+ (NSArray *) searchObjectsWith:(NSString *)stringSearch keyDictionary:(NSString *)keyDictionary fileName:(NSString *) fileName;
+ (void) logWithFileName:(NSString *)fileName;

+ (void)saveImage:(UIImage*)image name:(NSString *)imageName;
+ (UIImage*)loadImageWithName:(NSString *)imageName;

@end
