#import <AppKit/AppKit.h>
#import <Quartz/Quartz.h>

@interface Converter : NSObject

- (id)initWithPDFFile:(NSString *)pdfPath;
- (void)convert;

@end
