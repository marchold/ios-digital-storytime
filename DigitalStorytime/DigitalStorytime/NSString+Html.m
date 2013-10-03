//
//  NSString+Html.m
//  DigitalStorytime
//
//  Created by Marc Kluver on 2/24/12.
//  Copyright (c) 2012 City Orb. All rights reserved.
//

#import "NSString+Html.h"

@implementation NSString (Html)
NSRegularExpression *htmlEscapeCode = nil;
NSDictionary *htmlEscapeCodes=nil; 

NSString *unescapeHtmlString(NSString *source);
void initalizeEcapeCodes(void);
NSRegularExpression* newRegex(NSString * pattern);

NSString *unescapeHtmlString(NSString *source) {
    
    NSString *dest = @"";
    NSArray* results = [htmlEscapeCode matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    
    int offset = 0;
    for (int i = 0; i < results.count; i++){
        NSTextCheckingResult *result = [results objectAtIndex:i];
        NSRange escapeCode = [result rangeAtIndex:0];
        NSRange beforeCode;
        beforeCode.location = offset;
        beforeCode.length = escapeCode.location-offset;
        NSString *beforeCodeText = [source substringWithRange:beforeCode];
        offset = escapeCode.location + escapeCode.length;
        NSString *escapedCode = [source substringWithRange:escapeCode];
        NSString *code = [htmlEscapeCodes objectForKey:escapedCode];
        if (code == nil){
            code = [source substringWithRange:escapeCode];
        }
        dest = [NSString stringWithFormat:@"%@%@%@",dest,beforeCodeText,code];
    }
    NSRange afterLastMatch;
    afterLastMatch.location = offset;
    afterLastMatch.length = source.length - offset;
    dest = [NSString stringWithFormat:@"%@%@",dest,[source substringWithRange:afterLastMatch]];
    return dest;
}

NSRegularExpression* newRegex(NSString * pattern) {
    NSRegularExpressionOptions options = NSRegularExpressionCaseInsensitive;
    NSError* _error = NULL;
    NSRegularExpression* regex = [[NSRegularExpression regularExpressionWithPattern:pattern options:options error:&_error] retain];
    if (_error) {
        NSLog(@"%@", [_error description]);
    }
    return regex;
}


void initalizeEcapeCodes(void) {
    if (htmlEscapeCodes == nil){
        htmlEscapeCodes = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"<",@"&lt;",
                           @">",@"&gt;",
                           @"&",@"&amp;",
                           @"\"",@"&quot;",
                           @"à",@"&agrave;",
                           @"À",@"&Agrave;",
                           @"â",@"&acirc;",
                           @"ä",@"&auml;",
                           @"Ä",@"&Auml;",
                           @"Â",@"&Acirc;",
                           @"å",@"&aring;",
                           @"Å",@"&Aring;",
                           @"æ",@"&aelig;",
                           @"Æ",@"&AElig;",
                           @"ç",@"&ccedil;",
                           @"Ç",@"&Ccedil;",
                           @"é",@"&eacute;",
                           @"É",@"&Eacute;",
                           @"è",@"&egrave;",
                           @"È",@"&Egrave;",
                           @"ê",@"&ecirc;",
                           @"Ê",@"&Ecirc;",
                           @"ë",@"&euml;",
                           @"Ë",@"&Euml;",
                           @"ï",@"&iuml;",
                           @"Ï",@"&Iuml;",
                           @"ô",@"&ocirc;",
                           @"Ô",@"&Ocirc;",
                           @"ö",@"&ouml;",
                           @"Ö",@"&Ouml;",
                           @"ø",@"&oslash;",
                           @"Ø",@"&Oslash;",
                           @"ß",@"&szlig;",
                           @"ù",@"&ugrave;",
                           @"Ù",@"&Ugrave;",
                           @"û",@"&ucirc;",
                           @"Û",@"&Ucirc;",
                           @"ü",@"&uuml;",
                           @"Ü",@"&Uuml;",
                           @" ",@"&nbsp;",
                           @" ",@"&#32;",
                           @"!",@"&#33;",
                           @"\"",@"&#34;",
                           @"#",@"&#35;",
                           @"$",@"&#36;",
                           @"%",@"&#37;",
                           @"&",@"&#38;",
                           @"'",@"&#39;",
                           @"(",@"&#40;",
                           @")",@"&#41;",
                           @"*",@"&#42;",
                           @"+",@"&#43;",
                           @",",@"&#44;",
                           @"-",@"&#45;",
                           @".",@"&#46;",
                           @"/",@"&#47;",
                           @"0",@"&#48;",
                           @"1",@"&#49;",
                           @"2",@"&#50;",
                           @"3",@"&#51;",
                           @"4",@"&#52;",
                           @"5",@"&#53;",
                           @"6",@"&#54;",
                           @"7",@"&#55;",
                           @"8",@"&#56;",
                           @"9",@"&#57;",
                           @":",@"&#58;",
                           @";",@"&#59;",
                           @"<",@"&#60;",
                           @"=",@"&#61;",
                           @">",@"&#62;",
                           @"?",@"&#63;",
                           @"@",@"&#64;",
                           @"A",@"&#65;",
                           @"B",@"&#66;",
                           @"C",@"&#67;",
                           @"D",@"&#68;",
                           @"E",@"&#69;",
                           @"F",@"&#70;",
                           @"G",@"&#71;",
                           @"H",@"&#72;",
                           @"I",@"&#73;",
                           @"J",@"&#74;",
                           @"K",@"&#75;",
                           @"L",@"&#76;",
                           @"M",@"&#77;",
                           @"N",@"&#78;",
                           @"O",@"&#79;",
                           @"P",@"&#80;",
                           @"Q",@"&#81;",
                           @"R",@"&#82;",
                           @"S",@"&#83;",
                           @"T",@"&#84;",
                           @"U",@"&#85;",
                           @"V",@"&#86;",
                           @"W",@"&#87;",
                           @"X",@"&#88;",
                           @"Y",@"&#89;",
                           @"Z",@"&#90;",
                           @"[",@"&#91;",
                           @"\\",@"&#92;",
                           @"]",@"&#93;",
                           @"^",@"&#94;",
                           @"_",@"&#95;",
                           @"`",@"&#96;",
                           @"a",@"&#97;",
                           @"b",@"&#98;",
                           @"c",@"&#99;",
                           @"d",@"&#100;",
                           @"e",@"&#101;",
                           @"f",@"&#102;",
                           @"g",@"&#103;",
                           @"h",@"&#104;",
                           @"i",@"&#105;",
                           @"j",@"&#106;",
                           @"k",@"&#107;",
                           @"l",@"&#108;",
                           @"m",@"&#109;",
                           @"n",@"&#110;",
                           @"o",@"&#111;",
                           @"p",@"&#112;",
                           @"q",@"&#113;",
                           @"r",@"&#114;",
                           @"s",@"&#115;",
                           @"t",@"&#116;",
                           @"u",@"&#117;",
                           @"v",@"&#118;",
                           @"w",@"&#119;",
                           @"x",@"&#120;",
                           @"y",@"&#121;",
                           @"z",@"&#122;",
                           @"{",@"&#123;",
                           @"|",@"&#124;",
                           @"}",@"&#125;",
                           @"~",@"&#126;", nil]; 
        htmlEscapeCode = newRegex(@"&#{0,1}\\w{2,4};");
    }//end if (htmlEscapeCodes == nil)

}



-(NSString *) stringByStrippingHTML {
    initalizeEcapeCodes();
    
    NSRange r;
    NSString *s = [[self copy] autorelease];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
        
        NSString *replaceWith = @"";
        if ([s characterAtIndex:r.location+1]=='/' && [s characterAtIndex:r.location+2]=='p'){
            replaceWith = @"\n";
        }
        
        s = [s stringByReplacingCharactersInRange:r withString:replaceWith];
    }
    //TODO: Need to colapse spans of spaces, and unescape html &nbsp;'s
    return unescapeHtmlString(s); 
}


#pragma mark - unescape HTML string



@end
