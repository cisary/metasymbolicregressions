//
//  GFS.m
//  Testovanie
//
//  Created by Michal Cisarik on 8/1/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//

#import "GFS.h"
#import "AppDelegate.h"

// ================== // ERRORS AND EXCEPTIONS // ================== //
@implementation NotEnoughTerminalsInRepairingArray
@end

@implementation UnexpectedBehavior
@end

// =================== // IMPLEMENTATIONS // ======================= //
@implementation Configuration
@synthesize all;
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.all = [decoder decodeObjectForKey:@"all"];
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.all = [NSMutableDictionary dictionaryWithDictionary:@{
        @"function":@"",
        @"3D" : @NO,
        @"algorithm" : @[@0,@3,@2,@5,@0,@2],
        @"parameters": @[@211,@356,@3456,@2234,@5,@10],
        
        @"GFShex": @"",
        @"GFSbin":@0,
        @"GFSMaxWidth":@6,
        @"GFSMaxDepth":@9,
        
        @"individuals":@20,
        @"individualLength":@96,
        @"subintervals":@3,
        
        @"constants": @[],
        @"constantsCount":@5,
        @"randomConstants" :@NO,
        @"constantMinValue":@-100.0,
        @"constantMaxValue":@100.0,
        
        @"arithmeticFunctions" : @YES,
        @"logarithmicFunctions" : @YES,
        @"goniometricFunctions" : @YES,
        @"polynomialFunctions" : @YES,
        
        @"otherFunctions" : @YES,
        
        @"exponentialFunction" : @YES,
        
        @"linearConstants" : @YES,
        @"mathConstants" :@NO,
        

        @"reinforcedEvolution" : @YES,
        
        @"forcebit1": @YES, //add
        @"forcebit2": @YES, //sub
        @"forcebit3": @YES, //mul
        @"forcebit4": @YES, //div
        @"forcebit5": [NSNull null], //sin
        @"forcebit6": [NSNull null], //cos
        @"forcebit7": [NSNull null], //tan
        @"forcebit8": [NSNull null], //log   TODO: bug when @NO?
        @"forcebit9": [NSNull null], //log2
        @"forcebit10": [NSNull null], //log10
        @"forcebit11": [NSNull null], //^2
        @"forcebit12": [NSNull null], //^3
        @"forcebit13": [NSNull null], //^4
        @"forcebit14": [NSNull null], //^5
        @"forcebit15": [NSNull null], //^6
        @"forcebit16": [NSNull null], //1
        @"forcebit17": [NSNull null], //2
        @"forcebit18": [NSNull null], //3
        @"forcebit19": [NSNull null], //4
        @"forcebit20": [NSNull null], //5
        @"forcebit21": [NSNull null], //6
        @"forcebit22": [NSNull null], //7
        @"forcebit23": [NSNull null], //8
        @"forcebit24": [NSNull null], //9
        @"forcebit25": [NSNull null], //^
        @"forcebit26": [NSNull null], //sqrt
        @"forcebit27": [NSNull null], //abs
        @"forcebit28": [NSNull null], //exp
        @"forcebit29": [NSNull null], //pi
        @"forcebit30": [NSNull null], //e
        @"forcebit31": [NSNull null], //phi
        @"forcebit32": @NO, // REINFORCED SEARCH

        @"MDME_vectors" : @32,
        @"MDME_generations" : @100,
        @"MDME_scalingFactor" : @0.9,
        @"MDME_crossProb" : @0.9,
        @"MDME_mutProb" : @0.7,
        @"MDME_migProb" : @0.6,
        @"MDME_migrations" : @20,

        @"DE_vectors" : @32,
        @"DE_generations" : @1000,
        @"DE_scalingFactor" : @0.9,
        @"DE_crossProb" : @0.9,
        @"DE_mutProb" : @0.3,
        @"DE_migProb" : @0.6,
        @"DE_migrations" : @20,

        }];
    }
    
    return self;
}

@end


@implementation IN

//@synthesize xs,ys,zs,min,max,count;

-(id)initWithXs:(NSMutableArray *)x Ys:(NSMutableArray *)y Zs:(NSMutableArray *)z min:(double)i max:(double)mx andCount:(uint)c {
    self = [super init];
    if (self) {
        self.xs=x;
        self.ys=y;//[ys copy];
        self.zs=z;//[zs copy];
        self.min=i;
        self.max=mx;
        self.count=c;
    }
    return self;
}


+(NSMutableArray*) ekvidistantDoublesCount:(int)count min:(double)m max:(double)mx {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    double dx=m;
    double rx=(abs(m)+abs(mx))/(double)count;
    double qx=0.0;
    for (int i=0; i<count; i++) {
        if (qx+rx-dx>-0.005 &&qx+rx-dx<0.005 ) {
            [array insertObject:[NSNumber numberWithDouble:0.0] atIndex:i ];
        }
        else [array insertObject:[NSNumber numberWithDouble:qx+rx+dx] atIndex:i ];
        qx=qx+rx;
    }
    return array;
  
}

@end

@implementation GFSelement
@synthesize name;
@end

@implementation GFSvar
-(id)initWith:(double *)n name:(NSString *)s{
    self = [super init];
    if (self) {
        variable=n;
        name=s;
    }
    return self;
}
-(double)value{
    return (*variable);
}
@end

@implementation GFSconst
-(id)initWith:(double)n {
    self = [super init];
    if (self) {
        constant=n;
        name=[NSString stringWithFormat:@"%.2f",n];
    }
    return self;
}
-(double)value{
    return (constant);
}
@end

@implementation GFS2
-(double) eval:(double)parameter1 and:(double)parameter2{
    return function(parameter1,parameter2);
}
- (id)initWith:(func2) f name:(NSString *)n{
    self = [super init];
    if (self) {
        function=f;
        name=[[NSString alloc]initWithString:n];
    }
    return self;
}
@end

@implementation GFS1
-(double) eval:(double)parameter1{
    return function(parameter1);
}
- (id)initWith:(func1) f name:(NSString *)n{
    self = [super init];
    if (self) {
        function=f;
        name=[[NSString alloc]initWithString:n];
    }
    return self;
}
@end

@implementation GFS0
-(double) eval{
    return function();
}
- (id)initWith:(func0) f name:(NSString *)n{
    self = [super init];
    if (self) {
        function=f;
        name=[[NSString alloc]initWithString:n];
    }
    return self;
}
@end

@implementation GFSrein {
    
    GFS* gfs;
    int* array;
    int* repairing;
    
    NSArray *lines;
    NSArray *aarray;
    NSArray *barray;
    
    NSString *astr;
    NSString *bstr;
    
    
    NSString *gfsbinstr;
}
@synthesize tex;
-(int)getEnd {
    return endmarker+1;
}

-(int*)getArray{
    return array;
}


-(double)eval{
    int a=0;
    endmarker=0;
    
    int c=32;
    int d=0;
    int e=0;
    int f=0;
    
    return [gfs evaluateRecursive:&array[0] at:a last:&endmarker max:&c repairing:&repairing[0] lastrepairing:&d lastbigger:&e depth:&f];
}



- (id)initWithArray:(int [])n andGFS:(GFS *)g repairing:(int [])rep{
    self = [super init];
    if (self) {
        gfs=g;
        array=n;
        repairing=rep;
        [gfs repairA:&n[0] withB:&rep[0]];
        name=[gfs stringA:&n[0] withB:&rep[0]];
        //[gfs null];
    }
    return self;
}

-(id)initWithString:(NSString *)s andGFS:(GFS*)g {
    self = [super init];
    if (self) {
        array = (int *) malloc(sizeof(int) * MAXSIZE);
        repairing = (int *) malloc(sizeof(int) * MAXSIZE);
        
        lines = [NSArray arrayWithArray:  [s componentsSeparatedByString:@"\n"]];
        gfsbinstr=[NSString stringWithString:[lines objectAtIndex:1]];
        astr=[NSString stringWithString:[lines objectAtIndex:2]];
        bstr=[NSString stringWithString:[lines objectAtIndex:3]];
        name=[NSString stringWithString:[lines objectAtIndex:4]];
        tex=[NSString stringWithString:[lines objectAtIndex:5]];
              
        aarray= [NSArray arrayWithArray:  [astr componentsSeparatedByString:@","]];
        int i=0;
        int j=0;
        for (NSString *st in aarray) {
            if (i==0)
                array[i++]=[[st stringByReplacingOccurrencesOfString:@"[" withString:@""]intValue];
            else
                array[i++]=[st intValue];
            
            if (i==MAXSIZE)
                break;
            
            //TODO
            // find out length of reinforcement - mark with -1 for example in repairing
        }
        
        
        i=0;j=0;
        for (i=0; i<32; i++) {
            
            
            // if
            /*
            if ([[g.elements objectAtIndex:array[i]]conformsToProtocol: @protocol( GFSreinforced )]){
                j=i;
                
                
                
                int len=[sdtr getEnd];
                
                
             else
                array[i]=j++;
             */
        }
        
        barray=[NSArray arrayWithArray: [bstr componentsSeparatedByString:@","]];
        i=0;
        for (NSString *st2 in barray) {
            if (i==0)
                repairing[i++]=[[st2 stringByReplacingOccurrencesOfString:@"[" withString:@""]intValue];
            else
                repairing[i++]=[st2 intValue];
            
            if (i==33)
                break;
        }
        gfs=g;
        //name=namestr;
        //[gfs repairA:array withB:repairing];
        //name=[g stringA:array withB:repairing];
        
    }
    return self;
}
@end



@implementation GFS {
    __block double _x; // variable is used in dynamically created block
    __block double _y;
    
    IN *input;
    OUT *output;
    Configuration *configuration;
    NSMutableArray *consts;
    
    int _i;
    int _last_static;
    int _len_static;
    int _lastrepairing_static;
    int _lastbigger_static;
    int _debt;
    
    int* _last;
    int* _len;
    int* _lastrepairing;
    int* _lastbigger;
    
    int j;
    double sumdx,dx,da,db;
    
    NSMutableString *temp;
    NSMutableString *buffer1;
    NSMutableString *buffer2;
    
    MersenneTwister *mersennetwister;
}


@synthesize elements,variableNameInsteadOfValue,terminalsStartingIndex,bin,size,xpos,functions,constants;

-(NSDictionary*) mask:(uint64) b
{
    NSDictionary* dict = @{
                           
      // arithmeticFunctions:
      @"add" : (((b&bit1)==bit1)||([[configuration.all objectForKey:@"forcebit1"]isEqualTo:@YES]))?@YES:@NO,
      @"sub" : (((b&bit2)==bit2)||([[configuration.all objectForKey:@"forcebit2"]isEqualTo:@YES]))?@YES:@NO,
      @"mul" : (((b&bit3)==bit3)||([[configuration.all objectForKey:@"forcebit3"]isEqualTo:@YES]))?@YES:@NO,
      @"div" : (((b&bit4)==bit4)||([[configuration.all objectForKey:@"forcebit4"]isEqualTo:@YES]))?@YES:@NO,
      
      // goniometricFunctions:
      @"sin" : (((b&bit5)==bit5)||([[configuration.all objectForKey:@"forcebit5"]isEqualTo:@YES]))?@YES:@NO,
      @"cos" : (((b&bit6)==bit6)||([[configuration.all objectForKey:@"forcebit6"]isEqualTo:@YES]))?@YES:@NO,
      @"tan" : (((b&bit7)==bit7)||([[configuration.all objectForKey:@"forcebit7"]isEqualTo:@YES]))?@YES:@NO,
      
      // logarithmicFunctions:
      @"log" : (((b&bit8)==bit8)||([[configuration.all objectForKey:@"forcebit8"]isEqualTo:@YES]))?@YES:@NO,
      @"log2" : (((b&bit9)==bit9)||([[configuration.all objectForKey:@"forcebit9"]isEqualTo:@YES]))?@YES:@NO,
      @"log10" : (((b&bit10)==bit10)||([[configuration.all objectForKey:@"forcebit10"]isEqualTo:@YES]))?@YES:@NO,
      
      // polynomialFunctions:
      @"pow2" : (((b&bit11)==bit11)||([[configuration.all objectForKey:@"forcebit11"]isEqualTo:@YES]))?@YES:@NO,
      @"pow3" : (((b&bit12)==bit12)||([[configuration.all objectForKey:@"forcebit12"]isEqualTo:@YES]))?@YES:@NO,
      @"pow4" : (((b&bit13)==bit13)||([[configuration.all objectForKey:@"forcebit13"]isEqualTo:@YES]))?@YES:@NO,
      @"pow5" : (((b&bit14)==bit14)||([[configuration.all objectForKey:@"forcebit14"]isEqualTo:@YES]))?@YES:@NO,
      @"pow6" : (((b&bit15)==bit15)||([[configuration.all objectForKey:@"forcebit15"]isEqualTo:@YES]))?@YES:@NO, // Here is place for x,y according to 32th flag
      
      // linearConstants:
      @"1" : (((b&bit16)==bit16)||([[configuration.all objectForKey:@"forcebit16"]isEqualTo:@YES]))?@YES:@NO,
      @"2" : (((b&bit17)==bit17)||([[configuration.all objectForKey:@"forcebit17"]isEqualTo:@YES]))?@YES:@NO,
      @"3" : (((b&bit18)==bit18)||([[configuration.all objectForKey:@"forcebit18"]isEqualTo:@YES]))?@YES:@NO,
      @"4" : (((b&bit19)==bit19)||([[configuration.all objectForKey:@"forcebit19"]isEqualTo:@YES]))?@YES:@NO,
      @"5" : (((b&bit20)==bit20)||([[configuration.all objectForKey:@"forcebit20"]isEqualTo:@YES]))?@YES:@NO,
      @"6" : (((b&bit21)==bit21)||([[configuration.all objectForKey:@"forcebit21"]isEqualTo:@YES]))?@YES:@NO,
      @"7" : (((b&bit22)==bit22)||([[configuration.all objectForKey:@"forcebit22"]isEqualTo:@YES]))?@YES:@NO,
      @"8" : (((b&bit23)==bit23)||([[configuration.all objectForKey:@"forcebit23"]isEqualTo:@YES]))?@YES:@NO,
      @"9" : (((b&bit24)==bit24)||([[configuration.all objectForKey:@"forcebit24"]isEqualTo:@YES]))?@YES:@NO,
      
      // exponentialFunction:
      @"^" : (((b&bit25)==bit25)||([[configuration.all objectForKey:@"forcebit25"]isEqualTo:@YES]))?@YES:@NO,
      
      // otherFunctions:
      @"sqrt" : (((b&bit26)==bit26)||([[configuration.all objectForKey:@"forcebit26"]isEqualTo:@YES]))?@YES:@NO,
      @"abs" : (((b&bit27)==bit27)||([[configuration.all objectForKey:@"forcebit27"]isEqualTo:@YES]))?@YES:@NO,
      @"exp" : (((b&bit28)==bit28)||([[configuration.all objectForKey:@"forcebit28"]isEqualTo:@YES]))?@YES:@NO,
      
      // mathConstants:
      @"pi" : (((b&bit29)==bit29)||([[configuration.all objectForKey:@"forcebit29"]isEqualTo:@YES]))?@YES:@NO,
      @"e" : (((b&bit30)==bit30)||([[configuration.all objectForKey:@"forcebit30"]isEqualTo:@YES]))?@YES:@NO,
      @"phi" : (((b&bit31)==bit31)||([[configuration.all objectForKey:@"forcebit31"]isEqualTo:@YES]))?@YES:@NO,
      
      // 3D?
      @"y" : (((b&bit32)==bit32)||([[configuration.all objectForKey:@"forcebit32"]isEqualTo:@YES]))?@YES:@NO,
      } ;
    
    return dict;
}

/*! Instantiate GFS
 \return self
 */
-(id)initWithInput:(IN*)i andConfiguration:(Configuration *)cfg{
    
    self = [super init];
    if (self) {
        input=i;
        configuration=cfg;
        consts=[configuration.all objectForKey:@"constants"];
        output=[[OUT alloc]initWithInput:input configuration:configuration andGFS:self];
        bin=[[configuration.all objectForKey:@"GFSbin"]longLongValue];
        
        // local random generator initialized by "seed" parameter
        mersennetwister=[[MersenneTwister alloc]initWithSeed:(uint32)time(NULL)];
        
        
        /* max size of GFS:
          32 (number of predefined functions
          if mathConstants + 4 ?
          if linearConstants + 9 ?
          if randomConstants + MAXCONSTANTS
         
          if Xpriority + MAXCONSTANTS (x)
         
          if 3D + MAXCONSTANTS (y)
        
         
          if reinforcedEvolution + MAXREINFORCED
         */
        
        elements=[[NSMutableArray alloc] initWithCapacity:32+MAXCONSTANTS]; // + possibly reinforced?
        
        //_c = (double *) malloc(sizeof(double) * MAXCONSTANTS);
        
        _last=&_last_static;
        _len=&_len_static;
        _lastrepairing=&_lastrepairing_static;
        _lastbigger=&_lastbigger_static;
 
        bit1 = 1;          // 2^0   add
        bit2 = 1 << 1;     // 2^1   sub
        bit3 = 1 << 2;     // 2^2   mul
        bit4 = 1 << 3;     // 2^3   div
        bit5 = 1 << 4;     // 2^4   sin
        bit6 = 1 << 5;     // 2^5   cos
        bit7 = 1 << 6;     // 2^6   tan
        bit8 = 1 << 7;     // 2^7   log
        bit9 = 1 << 8;     // 2^8   log2
        bit10 = 1 << 9;    // 2^9   log10
        bit11 = 1 << 10;   // 2^10  pow2
        bit12 = 1 << 11;   // 2^11  pow3
        bit13 = 1 << 12;   // 2^12  pow4
        bit14 = 1 << 13;   // 2^13  pow5
        bit15 = 1 << 14;   // 2^14  pow6
        bit16 = 1 << 15;   // 2^15  1
        bit17 = 1 << 16;   // 2^16  2
        bit18 = 1 << 17;   // 2^17  3
        bit19 = 1 << 18;   // 2^18  4
        bit20 = 1 << 19;   // 2^19  5
        bit21 = 1 << 20;   // 2^20  6
        bit22 = 1 << 21;   // 2^21  7
        bit23 = 1 << 22;   // 2^22  8
        bit24 = 1 << 23;   // 2^23  9
        bit25 = 1 << 24;   // 2^24  ^
        bit26 = 1 << 25;   // 2^25  sqrt
        bit27 = 1 << 26;   // 2^26  abs
        bit28 = 1 << 27;   // 2^27  exp
        bit29 = 1 << 28;   // 2^28  pi
        bit30 = 1 << 29;   // 2^29  e
        bit31 = 1 << 30;   // 2^30  phi
        bit32 = 1 << 31;   // 2^31  y?
        
        // create functions for GFSelement subclasses:
        func2 _add = ^(double a, double b) { return a + b; };
        func2 _sub = ^(double a, double b) { return a - b; };
        func2 _mul = ^(double a, double b) { return a * b; };
        func2 _div = ^(double a, double b) { return a / b; };
        
        func1 _sin = ^(double par) { return sin(par); };
        func1 _cos = ^(double par) { return cos(par); };
        func1 _tan = ^(double par) { return tan(par); };
        func1 _log = ^(double par) { return log(par); };
        func1 _log2 = ^(double par) { return log2(par); };
        func1 _log10 = ^(double par) { return log10(par); };
        
        func1 _pow2 = ^(double par) { return pow(par,2); };
        func1 _pow3 = ^(double par) { return pow(par,3); };
        func1 _pow4 = ^(double par) { return pow(par,4); };
        func1 _pow5 = ^(double par) { return pow(par,5); };
        func1 _pow6 = ^(double par) { return pow(par,6); };
        
        func0 _1=^() { return (double) 1; };
        func0 _2=^() { return (double) 2; };
        func0 _3=^() { return (double) 3; };
        func0 _4=^() { return (double) 4; };
        func0 _5=^() { return (double) 5; };
        func0 _6=^() { return (double) 6; };
        func0 _7=^() { return (double) 7; };
        func0 _8=^() { return (double) 8; };
        func0 _9=^() { return (double) 9; };
        
        func2 _up = ^(double a, double b) { return pow(a,b); };
        
        func1 _sqrt = ^(double par) { return sqrt(par); };
        func1 _abs = ^(double par) { return fabs(par); };
        func1 _exp = ^(double par) { return exp(par); };
    
        func0 _pi=^() { return (double) M_PI; };
        func0 _e=^() { return (double) M_E; };
        func0 _phi=^() { return (double) 1.618033988749894848204586834365; };
        
        // initial values for variables which may be used in calculations:
        _x=1;
        _y=1;
        
        functions=0;
        
        NSDictionary* fs=[self mask:bin];
        
        bin=0;
        
        if (([[configuration.all objectForKey:@"arithmeticFunctions"]isEqualTo:@YES])){
        
            if (([[fs objectForKey:@"add"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit1"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit1"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS2 alloc]initWith:_add name:@"+"] atIndex:functions++ ];
                bin|=bit1;
            }
    
            if (([[fs objectForKey:@"sub"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit2"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit2"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS2 alloc]initWith:_sub name:@"-"] atIndex:functions++ ];
                bin|=bit2;
            }
            
            if (([[fs objectForKey:@"mul"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit3"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit3"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS2 alloc]initWith:_mul name:@"*"] atIndex:functions++ ];
                bin|=bit3;
            }
            
            
            if (([[fs objectForKey:@"div"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit4"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit4"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS2 alloc]initWith:_div name:@"/"] atIndex:functions++ ];
                bin|=bit4;
            }
            
        }
        
        if ([[configuration.all objectForKey:@"exponentialFunction"]isEqualTo:@YES]) {
            
            if (([[fs objectForKey:@"^"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit25"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit25"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS2 alloc]initWith:_up name:@"^"] atIndex:functions++ ];
                bin|=bit25;
            }
        }
        
        if ([[configuration.all objectForKey:@"goniometricFunctions"]isEqualTo:@YES]) {
            
            if (([[fs objectForKey:@"sin"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit5"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit5"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_sin name:@"sin"] atIndex:functions++ ];
                bin|=bit5;
            }
            
            if (([[fs objectForKey:@"cos"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit6"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit6"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_cos name:@"cos"] atIndex:functions++ ];
                bin|=bit6;
            }
            
            if (([[fs objectForKey:@"tan"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit7"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit7"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_tan name:@"tan"] atIndex:functions++ ];
                bin|=bit7;
            }
            
        }
        if ([[configuration.all objectForKey:@"logarithmicFunctions"]isEqualTo:@YES]) {
            
            if (([[fs objectForKey:@"log"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit8"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit8"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_log name:@"log"] atIndex:functions++ ];
                bin|=bit8;
            }
            
            if (([[fs objectForKey:@"log2"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit9"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit9"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_log2 name:@"log2"] atIndex:functions++ ];
                bin|=bit9;
            }
            
            if (([[fs objectForKey:@"log10"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit10"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit10"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_log10 name:@"log10"] atIndex:functions++ ];
                bin|=bit10;
            }
        }
        if ([[configuration.all objectForKey:@"polynomialFunctions"]isEqualTo:@YES]) {
            
            if (([[fs objectForKey:@"pow2"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit11"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit11"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_pow2 name:@"^2"] atIndex:functions++ ];
                bin|=bit11;
            }
            
            if (([[fs objectForKey:@"pow3"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit12"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit12"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_pow3 name:@"^3"] atIndex:functions++ ];
                bin|=bit12;
            }
            
            if (([[fs objectForKey:@"pow4"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit13"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit13"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_pow4 name:@"^4"] atIndex:functions++ ];
                bin|=bit13;
            }
            
            if (([[fs objectForKey:@"pow5"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit14"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit14"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_pow5 name:@"^5"] atIndex:functions++ ];
                bin|=bit14;
            }
            
            if (([[fs objectForKey:@"pow6"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit15"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit15"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_pow6 name:@"^6"] atIndex:functions++ ];
                bin|=bit15;
            }
        }
        
        if ([[configuration.all objectForKey:@"otherFunctions"]isEqualTo:@YES]) {
            
            if (([[fs objectForKey:@"sqrt"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit26"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit26"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_sqrt name:@"sqrt"] atIndex:functions++ ];
                bin|=bit26;
            }
            
            if (([[fs objectForKey:@"abs"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit27"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit27"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_abs name:@"abs"] atIndex:functions++ ];
                bin|=bit27;
            }
            
            if (([[fs objectForKey:@"e^"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit28"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit28"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_exp name:@"exp"] atIndex:functions++ ];
                bin|=bit28;
            }
            
        }
        
        int variables=0;
    
        [elements insertObject:[[GFSvar alloc] initWith:&_x name:@"x"] atIndex:functions++];
        variables+=1;
    
        if ([[configuration.all objectForKey:@"3D"] isEqualTo:@YES]) {
            [elements insertObject:[[GFSvar alloc] initWith:&_y name:@"y"] atIndex:functions++];
            variables+=1;
        }
        
        xpos=functions;
        
        terminalsStartingIndex=xpos-variables;
        
        
        if ([[configuration.all objectForKey:@"linearConstants"]isEqualTo:@YES]) {
        
            if (([[fs objectForKey:@"1"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit16"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit16"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_1 name:@"1"] atIndex:xpos++];
                bin|=bit16;
            }
            
            if (([[fs objectForKey:@"2"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit17"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit17"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_2 name:@"2"] atIndex:xpos++];
                bin|=bit17;
            }
            
            if (([[fs objectForKey:@"3"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit18"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit18"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_3 name:@"3"] atIndex:xpos++];
                bin|=bit18;
            }
            
            if (([[fs objectForKey:@"4"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit19"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit19"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_4 name:@"4"] atIndex:xpos++];
                bin|=bit19;
            }
            
            if (([[fs objectForKey:@"5"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit20"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit20"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_5 name:@"5"] atIndex:xpos++];
                bin|=bit20;
            }
            
            if (([[fs objectForKey:@"6"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit21"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit21"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_6 name:@"6"] atIndex:xpos++];
                bin|=bit21;
            }
            
            if (([[fs objectForKey:@"7"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit22"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit22"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_7 name:@"7"] atIndex:xpos++];
                bin|=bit22;
            }
            
            if (([[fs objectForKey:@"8"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit23"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit23"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_8 name:@"8"] atIndex:xpos++];
                bin|=bit23;
            }
            
            if (([[fs objectForKey:@"9"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit24"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit24"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_9 name:@"9"] atIndex:xpos++];
                bin|=bit24;
            }
        }
        
        if ([[configuration.all objectForKey:@"mathConstants"]isEqualTo:@YES]) {
            if (([[fs objectForKey:@"pi"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit29"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit29"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_pi name:@"pi"] atIndex:xpos++];
                bin|=bit29;
            }
            
            if (([[fs objectForKey:@"e"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit30"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit30"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_e name:@"e"] atIndex:xpos++];
                bin|=bit30;
            }
            
            if (([[fs objectForKey:@"phi"] isEqualTo:@YES])&&((![[configuration.all objectForKey:@"forcebit31"]isEqualTo:@NO])||([[configuration.all objectForKey:@"forcebit31"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_phi name:@"phi"] atIndex:xpos++];
                bin|=bit31;
            }
        }
        
        uint64 actualbit;
        uint64 originalgfsbin=[[configuration.all objectForKey:@"GFSbin"]longLongValue];
        int count=0;
        for (int i =33; i<65; i++) {
            actualbit=1 << i;
            if ((originalgfsbin&actualbit)==actualbit) {
                bin|=actualbit;
                if ([[configuration.all objectForKey:@"randomConstants"]isEqualTo:@YES])
                    
                    [elements insertObject:[[GFSconst alloc]initWith:[mersennetwister randomDoubleFrom:[[configuration.all objectForKey:@"constantMinValue"]doubleValue] to:[[configuration.all objectForKey:@"constantMinValue"]doubleValue]]] atIndex:xpos++];
                
                else
                    [elements insertObject:[[GFSconst alloc]initWith:[[consts objectAtIndex:count]doubleValue]] atIndex:xpos++];
                
                count++;
                if (count==[[configuration.all objectForKey:@"constantsCount"]intValue])
                    break;
            }
        }
        
        constants=xpos-terminalsStartingIndex-variables;
        /*
        constants-=1;//there is x variable everytime
        if ([[configuration.all objectForKey:@"3D"]isEqualTo:@YES])
            constants-=1;//y variable;
        */
        
        
        // forcing probability of choosing X or/and Y by
        /*
        int variables=0;
        
        
        do {
            [elements insertObject:[[GFSvar alloc] initWith:&_x name:@"x"] atIndex:xpos++];
            variables+=1;
            if ([[configuration.all objectForKey:@"3D"] isEqualTo:@YES]) {
                [elements insertObject:[[GFSvar alloc] initWith:&_y name:@"y"] atIndex:xpos++];
                variables+=1;
            }
        } while (variables<constants);
        */
        size=constants+functions-variables;
        reinforcementStartingIndex=xpos;
    }
    
    return self;
}


-(void)setValueOf:(NSString*)var value:(double)val{
    if ([var isEqual:@"x"])
        _x=val;
    if ([var isEqual:@"y"])
        _y=val;
}


-(NSString *)toTeXStringRecursive:(int[])array at:(int) i last:(int*)last max:(int*)len repairing:(int [])repairing lastrepairing:(int*)lastrepairing lastbigger:(int*)lastbigger{
    int j=*last;
    GFSelement *f=[elements objectAtIndex:array[i]];
    
    if ([f conformsToProtocol: @protocol( GFS2args )]){
        *last+=2;
        
        if ([[((GFS2*)f) name] isEqualToString:@"*"])
            return [NSString stringWithFormat:@"({%@}\\cdot{%@})",
                    [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger],
                    [self toTeXStringRecursive:array at:j+2 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        if ([[((GFS2*)f) name] isEqualToString:@"^"])
            return [NSString stringWithFormat:@"(%@^{%@})",
                    [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger],
                    [self toTeXStringRecursive:array at:j+2 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        if ([[((GFS2*)f) name] isEqualToString:@"/"])
            return [NSString stringWithFormat:@"(\\frac{%@}{%@})",
                   [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger],
                   [self toTeXStringRecursive:array at:j+2 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        return [NSString stringWithFormat:@"(%@%@%@)",
                [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger],
                [((GFS2*)f) name],
                [self toTeXStringRecursive:array at:j+2 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
    } else if ([f conformsToProtocol: @protocol( GFS1args )]){
        *last+=1;
        
        if ([[((GFS1*)f) name] isEqualToString:@"sqrt"])
            return [NSString stringWithFormat:@"(\\sqrt{%@}",
                    [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        if ([[((GFS1*)f) name] isEqualToString:@"abs"])
            return [NSString stringWithFormat:@"|%@|",
                    [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        if ([[((GFS1*)f) name] isEqualToString:@"e^"])
            return [NSString stringWithFormat:@"(\\e^%@)",
                    [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        if ([[((GFS1*)f) name] isEqualToString:@"log"])
            return [NSString stringWithFormat:@"(\\ln(%@))",
                    [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        if ([[((GFS1*)f) name] isEqualToString:@"log2"])
            return [NSString stringWithFormat:@"(\\log_2(%@))",
                    [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        if ([[((GFS1*)f) name] isEqualToString:@"log10"])
            return [NSString stringWithFormat:@"(\\log(%@))",
                    [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        if (([[((GFS1*)f) name] isEqualToString:@"^2"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^3"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^4"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^5"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^6"]))
            
            return [NSString stringWithFormat:@"(%@%@)",
                    [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger],
                    [((GFS1*)f) name]];
        
        else return [NSString stringWithFormat:@"\\%@(%@)",
                     [((GFS1*)f) name],
                     [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
    } else if ([f conformsToProtocol: @protocol( GFS0args )]){
        
        if (([[((GFS1*)f) name] isEqualToString:@"pi"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"e"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"phi"]))
            return [NSString stringWithFormat:@"\\%@",[((GFS0*)f) name]];
        
        return [NSString stringWithFormat:@"%@",[((GFS0*)f) name]];
        
    } else if ([f conformsToProtocol: @protocol( GFSreinforced )]){
        return [((GFSrein*)f) name];
        
    } else if ([f conformsToProtocol: @protocol( GFSvariable )]){
        if (variableNameInsteadOfValue)
            return [f name];
        if ([[f name] isEqual:@"x"])
            return[NSString stringWithFormat:@"%g",_x];
        else if ([[f name] isEqual:@"y"])
            return[NSString stringWithFormat:@"%g",_y];
        
    } else if ([f conformsToProtocol: @protocol( GFSconstant )]){
        return [f name];
    }
    return @"_";
}

-(NSString *)toStringRecursive:(int[])array at:(int) i last:(int*)last max:(int*)len repairing:(int [])repairing lastrepairing:(int*)lastrepairing lastbigger:(int*)lastbigger{
int j=*last;
    GFSelement *f=[elements objectAtIndex:array[i]];
    
    if ([f conformsToProtocol: @protocol( GFS2args )]){
        *last+=2;
        return [NSString stringWithFormat:@"(%@%@%@)",
                [self toStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger],
                [((GFS2*)f) name],
                [self toStringRecursive:array at:j+2 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
    } else if ([f conformsToProtocol: @protocol( GFS1args )]){
        
        *last+=1;
        
        if ([[((GFS1*)f) name] isEqualToString:@"log"])
            return [NSString stringWithFormat:@"log(%f,%@)",M_E,
            
                    [self toStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        if ([[((GFS1*)f) name] isEqualToString:@"log2"])
            return [NSString stringWithFormat:@"log(2,%@)",
                    [self toStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        if ([[((GFS1*)f) name] isEqualToString:@"log10"])
            return [NSString stringWithFormat:@"log(10,%@)",
                    [self toStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        if (([[((GFS1*)f) name] isEqualToString:@"^2"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^3"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^4"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^5"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^6"]))
            
            return [NSString stringWithFormat:@"(%@%@)",
                    [self toStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger],
                    [((GFS1*)f) name]];
        
        else return [NSString stringWithFormat:@"%@(%@)",
                     [((GFS1*)f) name],
                     [self toStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
    } else if ([f conformsToProtocol: @protocol( GFS0args )]){
        
        if ([[((GFS1*)f) name] isEqualToString:@"pi"] )
            return [NSString stringWithFormat:@"%f",M_PI];
        
        if ([[((GFS1*)f) name] isEqualToString:@"e"] )
            return [NSString stringWithFormat:@"%f",M_E];
        
        if ([[((GFS1*)f) name] isEqualToString:@"phi"] )
            return @"1.618033988749894848204586834365";
        
        return [NSString stringWithFormat:@"%@",[((GFS0*)f) name]];
        
    } else if ([f conformsToProtocol: @protocol( GFSreinforced )]){
        return [((GFSrein*)f) name];
        
    } else if ([f conformsToProtocol: @protocol( GFSvariable )]){
        if (variableNameInsteadOfValue)
            return [f name];
        if ([[f name] isEqual:@"x"])
            return[NSString stringWithFormat:@"%g",_x];
        else if ([[f name] isEqual:@"y"])
            return[NSString stringWithFormat:@"%g",_y];
        
    } else if ([f conformsToProtocol: @protocol( GFSconstant )]){
        return [NSString stringWithFormat:@"%.16f",[((GFSconst *)f)value]];
    }
    return @"_";
}


-(double)evaluateRecursive:(int[]) array
                                 at:(int)  i
                               last:(int*) last
                                max:(int*) len
                          repairing:(int[]) repairing
                      lastrepairing:(int*) lastrepairing
                         lastbigger:(int*) lastbigger
                              depth:(int*) depth{
    
    // necessary local variables inside recursion:
    int j = *last;
    GFSelement *f;
    double a,b,result;
    
    // get right GFS elements by number from array of indexes - expression
    f=[elements objectAtIndex:array[i]];
    
    if ([f conformsToProtocol: @protocol( GFS2args )]){
        
        *last+=2;
        
        a=[self evaluateRecursive:&array[0] at:j+1 last:last max:len repairing:&repairing[0] lastrepairing:lastrepairing lastbigger:lastbigger depth:depth];
        
        b=[self evaluateRecursive:&array[0] at:j+2 last:last max:len repairing:&repairing[0] lastrepairing:lastrepairing lastbigger:lastbigger depth:depth];
        result=[((GFS2 *)f) eval: a and: b];
        
        return result;
        
    } else if ([f conformsToProtocol: @protocol( GFS1args )]){
        
        *last+=1;
        
        b=[self evaluateRecursive:&array[0] at:j+1 last:last max:len repairing:&repairing[0] lastrepairing:lastrepairing lastbigger:lastbigger depth:depth];
        
        result=[((GFS1 *)f) eval:b];
        
        *depth+=1;
        
        return result;
        
    } else if ([f conformsToProtocol: @protocol( GFS0args )]){
        
        return [((GFS0 *)f) eval];
        
    } else if ([f conformsToProtocol: @protocol( GFSreinforced )]){
        
        return [((GFSrein *)f) eval];
        
    } else if ([f conformsToProtocol: @protocol( GFSvariable )]){
        
        if ([[f name] isEqual:@"x"])
            
            return _x;
        
        else if ([[f name] isEqual:@"y"])
            
            return _y;
        
    } else if ([f conformsToProtocol: @protocol( GFSconstant )]){
        
        return [((GFSconst *)f)value];
    }
    
    return (double) NAN; //.. Something went wrong so just return "not a number" so array can be repaired - this is also needed for ending recursion and avoid endless loops
}

-(double)evaluateRepairingRecursive:(int[]) array
                                 at:(int)  i
                               last:(int*) last
                                max:(int*) len
                          repairing:(int[]) repairing
                      lastrepairing:(int*) lastrepairing
                         lastbigger:(int*) lastbigger
                              depth:(int*) depth{
    
    // necessary local variables inside recursion:
    int j = *last;
    GFSelement *f;
    double a,b,result;
    
    // if there were MAXDEPTH or more calls of a GFS1 function:
    /*
    if (*last > *len) {
   
        f=[elements objectAtIndex:terminalsStartingIndex];
        array[i]=terminalsStartingIndex;
   
    } else if ((*depth > MAXDEPTH)||(*last > MAXWIDTH)) {
    
        f=[elements objectAtIndex:repairing[(*lastrepairing)]];
        array[i]=repairing[*lastrepairing];
        *lastrepairing+=1;
        
    } else
        
        f=[elements objectAtIndex:array[i]];
    */
    
    /*
    if ((*depth > MAXDEPTH)||(i > MAXWIDTH)) {
        *depth = 0;
        f=[elements objectAtIndex:repairing[(*lastrepairing)]];
        array[i]=repairing[*lastrepairing];
        *lastrepairing+=1;
        
    } else
        
        f=[elements objectAtIndex:array[i]];
    */
    if ((*last > MAXSIZE)||(*lastrepairing > MAXSIZE)) { // if there are no more elements to get from the repairing array
        
        f=[elements objectAtIndex:terminalsStartingIndex];
        array[i]=terminalsStartingIndex;                 // just use "x" variable
    }
    else if (*depth > MAXDEPTH) {
        *depth = 0;
        f=[elements objectAtIndex:repairing[(*lastrepairing)]];
        array[i]=repairing[*lastrepairing];
        *lastrepairing+=1;
    }
    else if (*last > MAXWIDTH) {
        
        f=[elements objectAtIndex:repairing[(*lastrepairing)]];
        array[i]=repairing[*lastrepairing];
        *lastrepairing+=1;
    }
    else
        f=[elements objectAtIndex:array[i]];
             
             
    if ([f conformsToProtocol: @protocol( GFSreinforced )]){
        //*last+=1;
        result=[((GFSrein *)f) eval];
        int en=[((GFSrein *)f) getEnd];
        int *implant=[((GFSrein *)f) getArray];
        
        int te,et;
        int l;
        int k;
        
        NSMutableString *buffer1=[NSMutableString stringWithFormat:@""];
        NSMutableString *buffer2=[NSMutableString stringWithFormat:@""];
        
        int v;
        for (v = 0; v < 30; v++) {
            [buffer1 appendString:[NSString stringWithFormat:@"%d,",array[v]]];
            [buffer2 appendString:[NSString stringWithFormat:@"%d,",repairing[v]]];
        }
        
        for (l=*len+en; l>i+en; l--) {
            array[l]=array[l-en];
            te=l-en;
        }
        
        buffer1=[NSMutableString stringWithFormat:@""];
        buffer2=[NSMutableString stringWithFormat:@""];
        
        for (v = 0; v < 30; v++) {
            [buffer1 appendString:[NSString stringWithFormat:@"%d,",array[v]]];
            [buffer2 appendString:[NSString stringWithFormat:@"%d,",repairing[v]]];
        }
        
        for (k=0; k<=en; k++) {
            //int sfr=array[i+k];
            array[i+k]=implant[k];
            //et=*last+k;
        }
        
        buffer1=[NSMutableString stringWithFormat:@""];
        buffer2=[NSMutableString stringWithFormat:@""];
        
        for (v = 0; v < 30; v++) {
            [buffer1 appendString:[NSString stringWithFormat:@"%d,",array[v]]];
            [buffer2 appendString:[NSString stringWithFormat:@"%d,",repairing[v]]];
        }
        
        //i+=en;
        
        //*last+=en;
        
        //return result;
        
        
        
        return [self evaluateRepairingRecursive:array at:i last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger depth:depth];
        
    }
    
    if ([f conformsToProtocol: @protocol( GFS2args )]){
        
        *last+=2;
        
        //====>recursion>
        a=[self evaluateRepairingRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger depth:depth];
        
        //====>recursion>
        b=[self evaluateRepairingRecursive:array at:j+2 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger depth:depth];
        result=[((GFS2 *)f) eval: a and: b];
        
        if ((a == NAN) || (b == NAN) || (a == INFINITY) || (b == INFINITY) ||
            (a == -INFINITY) || (b == -INFINITY) || (result == NAN) ||
            (result == INFINITY) || (result == -INFINITY)){
            
            f=[elements objectAtIndex:repairing[*lastrepairing]];
            array[i]=repairing[*lastrepairing];// REPAIRING!!
            *lastrepairing+=1;
            
        } else return result;
        
    } else if ([f conformsToProtocol: @protocol( GFS1args )]){
        *last+=1;
        
        //====>recursion>
        b=[self evaluateRepairingRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger depth:depth];
        result=[((GFS1 *)f) eval:b];
        
        if ((b == NAN) || (b==INFINITY) || (b==-INFINITY) || (result == NAN) || (result == INFINITY) || (result == -INFINITY)) {
            f=[elements objectAtIndex:repairing[*lastrepairing]];
            array[i]=repairing[*lastrepairing];
            *lastrepairing+=1;
            
        } else {
            *depth+=1;
            return result;
        }
        
    } else if ([f conformsToProtocol: @protocol( GFS0args )]){
        return [((GFS0 *)f) eval];
        
    } else if ([f conformsToProtocol: @protocol( GFSvariable )]){
        
        if ([[f name] isEqual:@"x"])
            return _x;
        
        else if ([[f name] isEqual:@"y"])
            return _y;
        
    } else if ([f conformsToProtocol: @protocol( GFSconstant )]){
        
        return [((GFSconst *)f)value];
    }
    return (double)NAN;
}

-(NSString*)description{
    NSMutableString *t=[NSMutableString stringWithString:@"{"];
    for (id element in elements){
        //if ((![element conformsToProtocol:@protocol(GFSconstant)])&&
         //   (![element conformsToProtocol:@protocol(GFSvariable)]))
            
        [t appendString:[NSString stringWithFormat:@"%@,",[element name]]];
    }
    [t appendString:@"}"];
    return [NSString stringWithString:t];
    
    
}

-(void)null {
    _i=0;
    _last_static=0;
    _len_static=32;
    _lastrepairing_static=0;
    _lastbigger_static=0;
    _debt=0;
}

-(NSString *)describeA:(int[])_a withB:(int[])_b{
    
    temp=[NSMutableString stringWithFormat:@""];
    buffer1=[NSMutableString stringWithFormat:@""];
    buffer2=[NSMutableString stringWithFormat:@""];
    
    for (int v = 0; v < 32; v++) {
        [buffer1 appendString:[NSString stringWithFormat:@"%d,",_a[v]]];
        [buffer2 appendString:[NSString stringWithFormat:@"%i,",_b[v]]];
    }
    
    //[temp appendFormat:@"\n[%@]\n[%@]\n",buffer1,buffer2];
    
    self.variableNameInsteadOfValue=YES;
    
    double fitness=[self errorA:&_a[0] withB:&_b[0]];
    
    [temp appendString:[NSString stringWithFormat:@"\n%llu\n[%@]\n[%@]\n%@\n%@\n%@",[self bin],buffer1,buffer2,[self stringA:&_a[0] withB:&_b[0]],[self teXStringA:&_a[0] withB:&_b[0]],[NSNumber numberWithDouble:fitness]]];
    
    return [NSString stringWithFormat:@"%@",temp];

}

-(NSString *)stringA:(int[])_a withB:(int[])_b{
    [self null];
    return [self toStringRecursive:&_a[0]
                                at:_i
                              last:_last
                               max:_len
                         repairing:&_b[0]
                     lastrepairing:_lastrepairing
                        lastbigger:_lastbigger];
}

-(NSString *)teXStringA:(int[])_a withB:(int[])_b{
    [self null];
    return [self toTeXStringRecursive:&_a[0]
                                at:_i
                              last:_last
                               max:_len
                         repairing:&_b[0]
                     lastrepairing:_lastrepairing
                        lastbigger:_lastbigger];
}

-(int)implantReinsOf:(int[])a len:(int)len {
    GFSelement *f;
    int itmp=0;
    int j=0;
    for (int i=0;i<len;i++){
        
        f=[elements objectAtIndex:a[i]];
    
    if ([f conformsToProtocol: @protocol( GFSreinforced )]){
        
        //itmp=i;
        
        int en=[((GFSrein *)f) getEnd];
        int *implant=[((GFSrein *)f) getArray];
        len+=en;
        
        int tmp;
        j=i;
        for (int k=len; k>=i; k--) {
             a[k]=a[i+k];
            a[i+k]=-1;
        }
        
        i+=en;
    }
}
    return len;
}

-(int)repairA:(int[])_a withB:(int[])_b{
    [self null];
    [self evaluateRepairingRecursive:&_a[0] at:_i last:_last max:_len repairing:&_b[0] lastrepairing:_lastrepairing lastbigger:_lastbigger depth:&_debt];
/*
int newlen=*_last+1;
    
for (int i=0; i<newlen;)
    if ([[self.elements objectAtIndex:_a[i]]  conformsToProtocol: @protocol( GFSreinforced )]){
    
    int en=[[self.elements objectAtIndex:_a[i]] getEnd];
    int *implant=[[self.elements objectAtIndex:_a[i]] getArray];
    
    int te,et;
    int l;
    int k;
    
    
    NSMutableString *buffer1=[NSMutableString stringWithFormat:@""];
    NSMutableString *buffer2=[NSMutableString stringWithFormat:@""];
    int v;
    for (v = 0; v < 30; v++) {
        [buffer1 appendString:[NSString stringWithFormat:@"%d,",_a[v]]];
        [buffer2 appendString:[NSString stringWithFormat:@"%d,",_b[v]]];
    }
    
    for (l=newlen+en; l>i+en; l--) {
        _a[l]=_a[l-en];
        te=l-en;
    }
    
    buffer1=[NSMutableString stringWithFormat:@""];
    buffer2=[NSMutableString stringWithFormat:@""];
    
    for (v = 0; v < 30; v++) {
        [buffer1 appendString:[NSString stringWithFormat:@"%d,",_a[v]]];
        [buffer2 appendString:[NSString stringWithFormat:@"%d,",_b[v]]];
    }
    
    for (k=0; k<=en; k++) {
        //int sfr=array[i+k];
        _a[i+k]=implant[k];
        //et=*last+k;
    }
    
    buffer1=[NSMutableString stringWithFormat:@""];
    buffer2=[NSMutableString stringWithFormat:@""];
    
    for (v = 0; v < 30; v++) {
        [buffer1 appendString:[NSString stringWithFormat:@"%d,",_a[v]]];
        [buffer2 appendString:[NSString stringWithFormat:@"%d,",_b[v]]];
    }
    
        i+=en;
        newlen+=en;
        
        } else {
            i+=1;
        }*/
    return *_last+1;
}

-(double)errorA:(int[])_a withB:(int[])_b{
    
    sumdx=0;
    double error=0;
    for (j=0; j<50; j++) {
        
        [self null];
        
        //dx=[[xs objectAtIndex:j]doubleValue];
        
        [self setValueOf:@"x" value:dx];
        
        da=[self evaluateRecursive:&_a[0] at:_i last:_last max:_len repairing:&_b[0] lastrepairing:_lastrepairing lastbigger:_lastbigger depth:&_debt];
        
        if ([[configuration.all objectForKey:@"function2D"] isEqualTo:@"x^6-2*x^4+x^2"])
            db=(pow(dx,6)-(2*pow(dx,4))+pow(dx,2));
        else if ([[configuration.all objectForKey:@"function2D"] isEqualTo:@"x^5−2*x^3+x"])
            db=(pow(dx,5)-(2*pow(dx,3))+dx);
        /*
        else if ([[configuration.all objectForKey:@"function2D"] isEqualTo:@"sin(x^6)-((2*cos(x))^4+(tan(x))^2)"])
            db=(sin(pow(dx,6))-(2*pow(cos(dx),4))+pow(tan(dx),2));
        */
        if ([[configuration.all objectForKey:@"function2D"] isEqualTo:@"x"])
            db=dx;
      
        if ((da==NAN)||(da==-INFINITY)||(da==INFINITY))
        
            return NAN;
        

        sumdx+=fabs(da-db);
    }
    return sumdx;
}

-(void)reinforceWith:(NSString*)s{
    [elements insertObject:[[GFSrein alloc]initWithString:s andGFS:self] atIndex:size];
    size+=1;
  
}

-(double)errorA:(int[])_a withB:(int[])_b andC:(double[])_c{
    
    sumdx=0;
    
    return sumdx;
}

@end

@implementation OUT {
    int i,j;
    double a,b,dx,dy,sumdx;
    double best;
    NSMutableString *mutable;
}

@synthesize gfs,configuration,calculations;

-(id)initWithInput:(IN*)n configuration:(Configuration*)con andGFS:(GFS*)gs{
    self = [super init];
    if (self) {
        self.in=n;
        best=DBL_MAX;
        self.configuration=con;
        self.gfs=gs;
        self.calculations=[[NSMutableDictionary alloc]initWithCapacity:1000];
    }
    return self;
}

-(BOOL)insertFitness:(double)f string:(NSString*)s ofMethod:(NSString*)m{
    
    if ((f<best)&&(f!=NAN)) {
        
        [calculations setValue:s forKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:f]]];
        best=f;
        [lock lock];
        NSLog(@"\n%@\n%@\n\n",m,[self bestDescription]); //DEBUGGING
        [lock unlock];
        return YES;
    }
    
    return NO;
}

-(NSString*)bestDescription{
    if (best!=FLT_MAX)
        return [NSString stringWithFormat:@"%@",[calculations  objectForKey:[NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:best]]]];
    else
        return @"";
}

-(NSString*)description{
    mutable=[NSMutableString stringWithFormat:@""];
    for (NSString *n in [calculations allKeys]) {
        [mutable appendString:[NSString stringWithFormat:@"%@",[calculations objectForKey:n]]];
    }
    return [NSString stringWithFormat:@"%@\n",mutable];
}
@end