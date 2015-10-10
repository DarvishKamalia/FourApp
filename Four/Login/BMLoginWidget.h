
#import <UIKit/UIKit.h>
#import "BMTextField.h"


/**
 * @protocol BMLoginWidgetDelegate
 * @brief    BMLoginWidgetDelegate
 *
 * BMLoginWidgetDelegate is notified when user attemps to login.
 */
@protocol BMLoginWidgetDelegate

@optional
- (void)loginAttemptWithUsername:(NSString *)username password:(NSString *)password;

@end


/**
 * @class APRLoginWidget
 * @brief APRLoginWidget
 *
 * Reusable subclass of UIView with Log in/Sign up tabs.
 */
@interface BMLoginWidget : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id<BMLoginWidgetDelegate> delegate;

- (IBAction)loginTabPressed:(id)sender;
- (IBAction)signupTabPressed:(id)sender;

@end
