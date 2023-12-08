//
//  ColorUtil.h
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import <UIKit/UIKit.h>

@interface ColorUtil : NSObject
+ (UIColor *)getColorFromHex:(NSString *)hex;
+ (UIColor *)getColorFromRgb:(NSString *)rgb;
+ (UIColor *)getColorFromRgba:(NSString *)rgba;
@end
