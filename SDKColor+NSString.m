//
//  FLNamedCssColors.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/26/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "SDKColor+NSString.h"
#import "FLColorValues.h"

typedef struct {
    __unsafe_unretained NSString* name;
    __unsafe_unretained NSString* color;
} FLHexColor_t;

static FLHexColor_t s_named_css_colors[] = {
    { @"AliceBlue", @"#F0F8FF" },
    { @"AntiqueWhite", @"#FAEBD7" },	 	
    { @"Aqua", @"#00FFFF" },	 	
    { @"Aquamarine", @"#7FFFD4" },	 	
    { @"Azure", @"#F0FFFF" },	 	
    { @"Beige", @"#F5F5DC" },	 	
    { @"Bisque", @"#FFE4C4" },	 	
    { @"Black", @"#000000" },	 	
    { @"BlanchedAlmond", @"#FFEBCD" },	 	
    { @"Blue", @"#0000FF" },	 	
    { @"BlueViolet", @"#8A2BE2" },	 	
    { @"Brown", @"#A52A2A" },	 	
    { @"BurlyWood", @"#DEB887" },	 	
    { @"CadetBlue", @"#5F9EA0" },	 	
    { @"Chartreuse", @"#7FFF00" },	 	
    { @"Chocolate", @"#D2691E" },	 	
    { @"Coral", @"#FF7F50" },	 	
    { @"CornflowerBlue", @"#6495ED" },	 	
    { @"Cornsilk", @"#FFF8DC" },	 	
    { @"Crimson", @"#DC143C" },	 	
    { @"Cyan", @"#00FFFF" },	 	
    { @"DarkBlue", @"#00008B" },	 	
    { @"DarkCyan", @"#008B8B" },	 	
    { @"DarkGoldenRod", @"#B8860B" },	 	
    { @"DarkGray", @"#A9A9A9" },	 	
    { @"DarkGreen", @"#006400" },	 	
    { @"DarkKhaki", @"#BDB76B" },	 	
    { @"DarkMagenta", @"#8B008B" },	 	
    { @"DarkOliveGreen", @"#556B2F" },	 	
    { @"Darkorange", @"#FF8C00" },	 	
    { @"DarkOrchid", @"#9932CC" },	 	
    { @"DarkRed", @"#8B0000" },	 	
    { @"DarkSalmon", @"#E9967A" },	 	
    { @"DarkSeaGreen", @"#8FBC8F" },	 	
    { @"DarkSlateBlue", @"#483D8B" },	 	
    { @"DarkSlateGray", @"#2F4F4F" },	 	
    { @"DarkTurquoise", @"#00CED1" },	 	
    { @"DarkViolet", @"#9400D3" },	 	
    { @"DeepPink", @"#FF1493" },	 	
    { @"DeepSkyBlue", @"#00BFFF" },	 	
    { @"DimGray", @"#696969" },	 	
    { @"DimGrey", @"#696969" },	 	
    { @"DodgerBlue", @"#1E90FF" },	 	
    { @"FireBrick", @"#B22222" },	 	
    { @"FloralWhite", @"#FFFAF0" },	 	
    { @"ForestGreen", @"#228B22" },	 	
    { @"Fuchsia", @"#FF00FF" },	 	
    { @"Gainsboro", @"#DCDCDC" },	 	
    { @"GhostWhite", @"#F8F8FF" },	 	
    { @"Gold", @"#FFD700" },	 	
    { @"GoldenRod", @"#DAA520" },	 	
    { @"Gray", @"#808080" },	 	
    { @"Green", @"#008000" },	 	
    { @"GreenYellow", @"#ADFF2F" },	 	
    { @"HoneyDew", @"#F0FFF0" },	 	
    { @"HotPink", @"#FF69B4" },	 	
    { @"IndianRed", @"#CD5C5C" },	
    { @"Indigo", @"#4B0082" },	 	
    { @"Ivory", @"#FFFFF0" },	 	
    { @"Khaki", @"#F0E68C" },	 	
    { @"Lavender", @"#E6E6FA" },	 	
    { @"LavenderBlush", @"#FFF0F5" },	 	
    { @"LawnGreen", @"#7CFC00" },	 	
    { @"LemonChiffon", @"#FFFACD" },	 	
    { @"LightBlue", @"#ADD8E6" },	 	
    { @"LightCoral", @"#F08080" },	 	
    { @"LightCyan", @"#E0FFFF" },	 	
    { @"LightGoldenRodYellow", @"#FAFAD2" },	 	
    { @"LightGray", @"#D3D3D3" },	 	
    { @"LightGreen", @"#90EE90" },	 	
    { @"LightPink", @"#FFB6C1" },	 	
    { @"LightSalmon", @"#FFA07A" },	 	
    { @"LightSeaGreen", @"#20B2AA" },	 	
    { @"LightSkyBlue", @"#87CEFA" },	 	
    { @"LightSlateGray", @"#778899" },	 	
    { @"LightSteelBlue", @"#B0C4DE" },	 	
    { @"LightYellow", @"#FFFFE0" },	 	
    { @"Lime", @"#00FF00" },	 	
    { @"LimeGreen", @"#32CD32" },	 	
    { @"Linen", @"#FAF0E6" },	 	
    { @"Magenta", @"#FF00FF" },	 	
    { @"Maroon", @"#800000" },	 	
    { @"MediumAquaMarine", @"#66CDAA" },	 	
    { @"MediumBlue", @"#0000CD" },	 	
    { @"MediumOrchid", @"#BA55D3" },	 	
    { @"MediumPurple", @"#9370DB" },	 	
    { @"MediumSeaGreen", @"#3CB371" },	 	
    { @"MediumSlateBlue", @"#7B68EE" },	 	
    { @"MediumSpringGreen", @"#00FA9A" },	 	
    { @"MediumTurquoise", @"#48D1CC" },	 	
    { @"MediumVioletRed", @"#C71585" },	 	
    { @"MidnightBlue", @"#191970" },	 	
    { @"MintCream", @"#F5FFFA" },	 	
    { @"MistyRose", @"#FFE4E1" },	 	
    { @"Moccasin", @"#FFE4B5" },	 	
    { @"NavajoWhite", @"#FFDEAD" },	 	
    { @"Navy", @"#000080" },	 	
    { @"OldLace", @"#FDF5E6" },	 	
    { @"Olive", @"#808000" },	 	
    { @"OliveDrab", @"#6B8E23" },	 	
    { @"Orange", @"#FFA500" },	 	
    { @"OrangeRed", @"#FF4500" },	 	
    { @"Orchid", @"#DA70D6" },	 	
    { @"PaleGoldenRod", @"#EEE8AA" },	 	
    { @"PaleGreen", @"#98FB98" },	 	
    { @"PaleTurquoise", @"#AFEEEE" },	 	
    { @"PaleVioletRed", @"#DB7093" },	 	
    { @"PapayaWhip", @"#FFEFD5" },	 	
    { @"PeachPuff", @"#FFDAB9" },	 	
    { @"Peru", @"#CD853F" },	 	
    { @"Pink", @"#FFC0CB" },	 	
    { @"Plum", @"#DDA0DD" },	 	
    { @"PowderBlue", @"#B0E0E6" },	 	
    { @"Purple", @"#800080" },	 	
    { @"Red", @"#FF0000" },	 	
    { @"RosyBrown", @"#BC8F8F" },	 	
    { @"RoyalBlue", @"#4169E1" },	 	
    { @"SaddleBrown", @"#8B4513" },	 	
    { @"Salmon", @"#FA8072" },	 	
    { @"SandyBrown", @"#F4A460" },	 	
    { @"SeaGreen", @"#2E8B57" },	 	
    { @"SeaShell", @"#FFF5EE" },	 	
    { @"Sienna", @"#A0522D" },	 	
    { @"Silver", @"#C0C0C0" },	 	
    { @"SkyBlue", @"#87CEEB" },	 	
    { @"SlateBlue", @"#6A5ACD" },	 	
    { @"SlateGray", @"#708090" },	 	
    { @"Snow", @"#FFFAFA" },	 	
    { @"SpringGreen", @"#00FF7F" },	 	
    { @"SteelBlue", @"#4682B4" },	 	
    { @"Tan", @"#D2B48C" },	 	
    { @"Teal", @"#008080" },	 	
    { @"Thistle", @"#D8BFD8" },	 	
    { @"Tomato", @"#FF6347" },	 	
    { @"Turquoise", @"#40E0D0" },	 	
    { @"Violet", @"#EE82EE" },	 	
    { @"Wheat", @"#F5DEB3" },	 	
    { @"White", @"#FFFFFF" },	 	
    { @"WhiteSmoke", @"#F5F5F5" },	 	
    { @"Yellow", @"#FFFF00" },	 	
    { @"YellowGreen", @"#9ACD32" },	 	
    { nil, nil }
};

//
//@interface FLCssColors : NSObject
//+ (SDKColor*) colorWithName:(NSString*) name;
//@end
//
//@implementation FLCssColors
//
//
//+ (void) initialize {
//}
//
//+ (SDKColor*) colorWithName:(NSString*) name {
//    return 
//}
//
//@end

SDKColor* FLColorFromHexColorName(NSString* string) {

    static NSMutableDictionary* s_colorLookup = nil;
    if(!s_colorLookup) {
        s_colorLookup = [[NSMutableDictionary alloc] init];
        
        for(int i = 0; s_named_css_colors[i].name != nil; i++) {
            [s_colorLookup setObject:s_named_css_colors[i].color forKey:[s_named_css_colors[i].name lowercaseString]];
        }
    }

    NSString* colorHex = [s_colorLookup objectForKey:[string lowercaseString]];
    return colorHex ? FLColorFromHexColorString(colorHex) : nil;
}

NSString* FLRgbStringFromColor(SDKColor* color) { //rgb(11,11,11,0.5)

    FLColorValues colorValues = color.rgbColorValues;
    	
	return [NSString stringWithFormat:@"rgb(%d,%d,%d,%f)", 
		(unsigned int) colorValues.red,
		(unsigned int) colorValues.green,
		(unsigned int) colorValues.blue,
        colorValues.alpha];
}

//#if OSX
//CGColorRef FLCreateCGColorFromNSColor(NSColor *color, CGColorSpaceRef colorSpace) {
//
//    if(!colorSpace) {
//        colorSpace = [[color colorSpace] CGColorSpace];
//    }
//
//    NSColor *deviceColor = [color colorUsingColorSpaceName:NSDeviceRGBColorSpace];
//
//    CGFloat components[4];
//    [deviceColor getRed: &components[0] green: &components[1] blue:
//    &components[2] alpha: &components[3]];
//
//    return CGColorCreate (colorSpace, components);
//#else
//    return color.CGColor;
//#endif
//}

SDKColor*  FLColorFromRGBString(NSString* string) {
    CGFloat rgb[4] = {
        0,
        0,
        0,
        1.0f 
        };

    int which = 0;
    
    char num[32];
    char *p = num;
    *p = 0;
    
    if([string rangeOfString:@"rgb("].location == 0)
    {
        for(int i = 4; i < string.length; i++)
        {
            char c = (char) [string characterAtIndex:i];
            
            switch(c)
            {
                case ')':
                case ',':
                case ' ':
                if(p > num)
                {
                    rgb[which++] = (CGFloat) atof(num);
                    p = num;
                    *p = 0;
                }
                break;
                
                case '.':
                default:
                    *p++ = c;
                    *p = 0;
                break;
            }
        }
        
        
    
        return [SDKColor colorWithRGBRed:rgb[0] green:rgb[1] blue:rgb[2] alpha:rgb[3]];
    }
    
    return nil;
}

NSString* FLCssColorStringFromColor(SDKColor* color) {
    FLColorValues colorValues = color.rgbColorValues;
		
	return [NSString stringWithFormat:@"#%X%X%X",
            (unsigned int) colorValues.red,
            (unsigned int) colorValues.green,
            (unsigned int) colorValues.blue];
}




SDKColor* FLColorFromHexColorString(NSString* string) {

    int firstChar = 0;
    if([string characterAtIndex:0] == '#') {
        if(string.length != 7) {
            return nil;
        }
        ++firstChar;
    }
    else if(string.length != 6) {
        return nil;
    }

    char redStr[3] = { 
        (char)[string characterAtIndex:firstChar], 
        (char)[string characterAtIndex:firstChar+1], 
        0 
        };
    char blueStr[3] = {
        (char)[string characterAtIndex:firstChar+2], 
        (char)[string characterAtIndex:firstChar+3], 
        0 
    };
    char greenStr[3] = {
        (char)[string characterAtIndex:firstChar+4], 
        (char)[string characterAtIndex:firstChar+5], 
        0 
    };
    char* endPtr;
    long red = strtol( redStr, &endPtr, 16 );
    long green = strtol( blueStr, &endPtr, 16 );
    long blue = strtol( greenStr, &endPtr, 16 );
    return [SDKColor colorWithRGBRed:red green:green blue:blue alpha:1.0f];
}

NSString* FLHexColorStringFromColor(SDKColor* color) {
    FLColorValues colorValues = color.rgbColorValues;
	return [NSString stringWithFormat:@"%X%X%X",
            (unsigned int) colorValues.red,
            (unsigned int) colorValues.green,
            (unsigned int) colorValues.blue];
}

SDKColor* FLColorFromString(NSString* string) {
    SDKColor* color = FLColorFromHexColorString(string);
    if(color) {
        return color;
    }
    color = FLColorFromRGBString(string);
    if(color) {
        return color;
    }
    return FLColorFromHexColorName(string);
}

