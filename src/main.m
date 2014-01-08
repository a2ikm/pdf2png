#import <AppKit/AppKit.h>
#import "Converter.h"

int main(int argc, const char **argv)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    int i;
    for (i = 0; i < argc; i++) {
      NSString *pdfPath = [[NSString stringWithUTF8String:argv[i]] stringByExpandingTildeInPath];
      Converter *conv = [[Converter alloc] initWithPDFFile:pdfPath];
      [conv convert];

      [conv release];
    }

    [pool release];
    return 0; 
}
