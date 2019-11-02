#import "rm_helper.h"

@class XLFormRowDescriptor;

@implementation RMHelper

+ (void) set_hidden: (NSDictionary*) args {
  id control = [args objectForKey: @"control"];
  id value = [args objectForKey: @"hidden_value"];
  NSLog(
    @"RMHelper#set_hidden(args: %@ value: %@ value class: %@",
    args,
    value,
    [value class]
  );
  [control setHidden: value];
}

+ (void)hide_row: (XLFormRowDescriptor *) row {
  [row setHidden: YES];
}

@end
