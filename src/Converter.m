#import "Converter.h"

@interface Converter ()

@property (strong) NSString *pdfPath;
@property (strong) PDFDocument *pdfDoc;
@property (assign) int pdfWidth;
@property (assign) int pdfHeight;

- (NSImage *)imageFromPDFPage:(PDFPage *)page;
- (BOOL)writeImage:(NSImage *)image withIndex:(int)index;
- (NSData *)PNGDataFromImage:(NSImage *)image;
- (NSString *)fileNameWithIndex:(int)index;

@end

@implementation Converter

- (id)initWithPDFFile:(NSString *)pdfPath
{
  self = [super init];
  if (self) {
    self.pdfPath = pdfPath;
    self.pdfDoc = [[PDFDocument alloc] initWithURL:[NSURL fileURLWithPath:self.pdfPath]];
  }

  return self;
}

- (void)convert
{
  int i;
  for (i = 0; i < [self.pdfDoc pageCount]; i++) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    PDFPage *page = [self.pdfDoc pageAtIndex:i];
    NSImage *image = [self imageFromPDFPage:page];
    if (!image) {
      [pool release];
      continue;
    }

    [self writeImage:image withIndex:i];

    [pool release];
  }
}

#pragma mark - PRIVATE

- (NSImage *)imageFromPDFPage:(PDFPage *)page
{
  NSData *data = [page dataRepresentation];

  NSPDFImageRep *pdfImageRep = [[[NSPDFImageRep alloc] initWithData:data] autorelease];
  if (!pdfImageRep)
    return nil;

  NSSize size;
  size.width  = [pdfImageRep pixelsWide];
  size.height = [pdfImageRep pixelsHigh];

  NSImage *image = [[[NSImage alloc] initWithSize:size] autorelease];
  if (!image)
    return nil;

  [image lockFocus];
  [pdfImageRep drawInRect: NSMakeRect(0, 0, size.width, size.height)];
  [image unlockFocus];

  return image;
}

- (BOOL)writeImage:(NSImage *)image withIndex:(int)index
{
  NSString *fileName = [self fileNameWithIndex:index];
  NSData *data = [self PNGDataFromImage:image];

  if (!data)
    return NO;

  return [data writeToFile:fileName atomically:YES];
}

- (NSData *)PNGDataFromImage:(NSImage *)image
{
  NSData *tiffRep = [image TIFFRepresentation];
  NSBitmapImageRep *imageRep = [[[NSBitmapImageRep alloc] initWithData:tiffRep] autorelease];
  if (!imageRep)
    return NO;

  NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithFloat: 1.0],
                                NSImageCompressionFactor, 
                              nil];
  return [imageRep representationUsingType:NSPNGFileType properties:properties];
}

- (NSString *)fileNameWithIndex:(int)index
{
  NSString *directory = [self.pdfPath stringByDeletingLastPathComponent];
  NSString *basename = [[self.pdfPath lastPathComponent] stringByDeletingPathExtension];
  return [directory stringByAppendingPathComponent:
          [NSString stringWithFormat:@"%@-%d.png", basename, index]];
}

@end
