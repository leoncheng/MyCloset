//
//  ImageToDataTransformer.m
//  MyCloset
//
//  Created by mmcl on 11-9-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageToDataTransformer.h"


@implementation ImageToDataTransformer


+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}


- (id)transformedValue:(id)value {
	NSData *data = UIImageJPEGRepresentation(value, 0.5);
	return data;
}


- (id)reverseTransformedValue:(id)value {
	UIImage *uiImage = [[UIImage alloc] initWithData:value];
	return [uiImage autorelease];
}

@end