
#import "BMTextField.h"
#import "UIView+Border.h"

@interface BMTextField()

@end
#pragma mark -



@implementation BMTextField
#pragma mark - Accessors
/**
 * @method setPlaceholderColor
 *
 * Sets the placeholder color as the given one
 * using attributed placeholder regardless of current type.
 */
- (void)setPlaceholderColor:(UIColor *)color
{
    _placeholderColor = color;
    
    NSString *text = self.placeholder;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text
                                                                 attributes:@{NSForegroundColorAttributeName : _placeholderColor}];
}



#pragma mark - Public Mehthos


@end
