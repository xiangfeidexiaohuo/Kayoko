//
//  KayokoRootListController.m
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#include "KayokoRootListController.h"

#import <roothide.h>

extern NSBundle *KayokoBundle();

static inline NSString *LOC(NSString *key) {
    NSBundle *tweakBundle = KayokoBundle();
    return [tweakBundle localizedStringForKey:key value:nil table:nil];
}

NSBundle *KayokoBundle() {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        NSString *tweakBundlePath = [[NSBundle mainBundle] pathForResource:@"KayokoPreferences" ofType:@"bundle"];
        if (tweakBundlePath)
            bundle = [NSBundle bundleWithPath:tweakBundlePath];
        else
            bundle = [NSBundle bundleWithPath:jbroot(@"/Library/PreferenceBundles/KayokoPreferences.bundle")];
    });
    return bundle;
}


@implementation KayokoRootListController
/**
 * Loads the root specifiers.
 *
 * @return The specifiers.
 */
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

/**
 * Handles preference changes.
 *
 * @param value The new value for the changed option.
 * @param specifier The specifier that was interacted with.
 */
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    [super setPreferenceValue:value specifier:specifier];

    // Prompt to respring for options that require one to apply changes.
    if ([[specifier propertyForKey:@"key"] isEqualToString:kPreferenceKeyEnabled] ||
		[[specifier propertyForKey:@"key"] isEqualToString:kPreferenceKeyActivationMethod] ||
		[[specifier propertyForKey:@"key"] isEqualToString:kPreferenceKeyAutomaticallyPaste]
	) {
		[self promptToRespring];
    }
}

/**
 * Hides the keyboard when the "Return" key is pressed on focused text fields.
 * 
 * @param notification The event notification.
 */
- (void)_returnKeyPressed:(NSConcreteNotification *)notification {
    [[self view] endEditing:YES];
    [super _returnKeyPressed:notification];
}

/**
 * Prompts the user to respring to apply changes.
 */
- (void)promptToRespring {
    UIAlertController* resetAlert = [UIAlertController alertControllerWithTitle:@"Kayoko" message:LOC(@"CHOOSE_TEXT") preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:LOC(@"YES_TEXT") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self respring];
	}];

	UIAlertAction* noAction = [UIAlertAction actionWithTitle:LOC(@"NO_TEXT") style:UIAlertActionStyleCancel handler:nil];

	[resetAlert addAction:yesAction];
	[resetAlert addAction:noAction];

	[self presentViewController:resetAlert animated:YES completion:nil];
}

/**
 * Resprings the device.
 */
- (void)respring {
	NSTask* task = [[NSTask alloc] init];
	[task setLaunchPath:jbroot(@"/usr/bin/killall")];
	[task setArguments:@[@"backboardd"]];
	[task launch];
}

/**
 * Prompts the user to reset their preferences.
 */
- (void)resetPrompt {
    UIAlertController* resetAlert = [UIAlertController alertControllerWithTitle:@"Kayoko" message:LOC(@"RESET_TEXT") preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:LOC(@"YES_TEXT") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self resetPreferences];
	}];

	UIAlertAction* noAction = [UIAlertAction actionWithTitle:LOC(@"NO_TEXT") style:UIAlertActionStyleCancel handler:nil];

	[resetAlert addAction:yesAction];
	[resetAlert addAction:noAction];

	[self presentViewController:resetAlert animated:YES completion:nil];
}

/**
 * Resets the preferences.
 */
- (void)resetPreferences {
	NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:kPreferencesIdentifier];
	for (NSString* key in [userDefaults dictionaryRepresentation]) {
		[userDefaults removeObjectForKey:key];
	}

	[self reloadSpecifiers];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)kNotificationKeyPreferencesReload, nil, nil, YES);
}
@end
