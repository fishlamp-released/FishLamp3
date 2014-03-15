//
//  FLObjcNumberValueType.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcValueType.h"

@interface FLObjcNumberValueType : FLObjcValueType
- (NSString*) numberWithString;
- (NSString*) numberValueString;
@end

@interface FLObjcCharType : FLObjcNumberValueType
@end
@interface FLObjcUnsignedCharType : FLObjcNumberValueType
@end
@interface FLObjcNSIntegerType : FLObjcNumberValueType
@end
@interface FLObjcNSUIntegerType : FLObjcNumberValueType
@end
@interface FLObjcSInt32Type : FLObjcNumberValueType
@end
@interface FLObjcUInt32Type : FLObjcNumberValueType
@end
@interface FLObjcSInt64Type : FLObjcNumberValueType
@end
@interface FLObjcUInt64Type : FLObjcNumberValueType
@end
@interface FLObjcSInt16Type : FLObjcNumberValueType
@end
@interface FLObjcUInt16Type : FLObjcNumberValueType
@end
@interface FLObjcFloatType : FLObjcNumberValueType
@end
@interface FLObjcDoubleType : FLObjcNumberValueType
@end
