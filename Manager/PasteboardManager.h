//
//  PasteboardManager.h
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import <roothide.h>
#import <UIKit/UIKit.h>
#import "PasteboardItem.h"
#import "../Utils/StringUtil.h"
#import "../Utils/ImageUtil.h"
#import "../Utils/AlertUtil.h"
#import "../Preferences/NotificationKeys.h"
#import "../Preferences/PreferenceKeys.h"

static NSString* const kHistoryPath = @"/var/mobile/Library/codes.aurora.kayoko/history.json";
static NSString* const kHistoryImagesPath = @"/var/mobile/Library/codes.aurora.kayoko/images/";
static NSString* const kHistoryKeyHistory = @"history";
static NSString* const kHistoryKeyFavorites = @"favorites";

@interface PasteboardManager : NSObject {
    UIPasteboard* _pasteboard;
    NSUInteger _lastChangeCount;
    NSFileManager* _fileManager;
}
@property(nonatomic, assign)NSUInteger maximumHistoryAmount;
@property(nonatomic, assign)BOOL saveText;
@property(nonatomic, assign)BOOL saveImages;
@property(nonatomic, assign)BOOL automaticallyPaste;
+ (instancetype)sharedInstance;
- (void)pullPasteboardChanges;
- (void)addPasteboardItem:(PasteboardItem *)item toHistoryWithKey:(NSString *)historyKey;
- (void)updatePasteboardWithItem:(PasteboardItem *)item fromHistoryWithKey:(NSString *)historyKey shouldAutoPaste:(BOOL)shouldAutoPaste;
- (void)removePasteboardItem:(PasteboardItem *)item fromHistoryWithKey:(NSString *)historyKey shouldRemoveImage:(BOOL)shouldRemoveImage;
- (NSMutableArray *)getItemsFromHistoryWithKey:(NSString *)historyKey;
- (PasteboardItem *)getLatestHistoryItem;
- (UIImage *)getImageForItem:(PasteboardItem *)item;
@end

@interface SBApplication : NSObject
@property(nonatomic, readonly)NSString* bundleIdentifier;
@end

@interface UIApplication (Private)
- (SBApplication *)_accessibilityFrontMostApplication;
@end
