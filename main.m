#import <AppKit/AppKit.h>

int main(int argc, const char **argv)
{
    if(argc != 3) {
        fprintf(stderr, "Usage: %s source_img dest_pdf\n", argv[0]);
        exit(1);
    }

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    BOOL success;
    NSString *imgPath, *pdfPath;
    NSImage *myImage;
    NSImageView *myView;
    NSRect vFrame;
    NSBitmapImageRep *bitmapRep;
    NSData *pngData;

    pdfPath = [[NSString stringWithUTF8String:argv[1]] stringByExpandingTildeInPath];
    imgPath = [[NSString stringWithUTF8String:argv[2]] stringByExpandingTildeInPath];

    /* Calling NSApplicationLoad will give a Carbon application a connection
    to the window server and enable the use of NSImage, NSView, etc. */
    success = NSApplicationLoad();
    if(!success) {
        fprintf(stderr, "Failed to make a connection to the window server\n");
        exit(1);
    }

    /* Create image */
    myImage = [[NSImage alloc] initWithContentsOfFile:pdfPath];
    NSLog(@"%@",  myImage);
    if(!myImage) {
        fprintf(stderr, "Failed to create image from path %s\n", argv[1]);
        exit(1);
    }

    /* Create view with that size */
    vFrame = NSZeroRect;
    vFrame.size = [myImage size];
    myView = [[NSImageView alloc] initWithFrame:vFrame];

    [myView setImage:myImage];
    [myImage release];

    /* Generate data */
    bitmapRep = [myView bitmapImageRepForCachingDisplayInRect:vFrame];
    NSLog(@"%@",  bitmapRep);
    [bitmapRep retain];
    [myView release];

    /* Write data to file */
    pngData = [bitmapRep representationUsingType:NSPNGFileType properties:nil];
    [pngData retain];
    [bitmapRep release];

    success = [pngData writeToFile:imgPath options:0 error:NULL];
    [pngData release];
    if(!success) {
        fprintf(stderr, "Failed to write PDF data to path %s\n", argv[2]);
        exit(1);
    }

    [pool release];
    return 0; 
}
