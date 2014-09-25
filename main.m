//
//  main.m
//  SymbolicRegression
//
//  Created by Michal Cisarik on 8/14/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//
/*
 #import <SenTestingKit/SenTestingKit.h>
 #import "GFS.h"
 
 @interface GFSTests : SenTestCase
 @property GFS *gfs;
 @end
 
 @implementation GFSTests
 @synthesize gfs;
 - (void)setUp {
 gfs = [[GFS alloc]initWithFunctionSet:(uint64_t)98930 *98930];
 [super setUp];
 }
 
 - (void)tearDown {
 [super tearDown];
 }
 
 -(void)testDescription {
 NSString *expected=@"GFS={+, -, *, /, log, sin, cos, tan, x, 2, 3, }";
 NSString *evaluated=[gfs description];
 STAssertTrue([evaluated isEqualToString:expected],@"GFS Description");
 }
 
 
 
 -(void)testEvaluate {
 [gfs setValueOf:@"x" value:(double)7];
 int a[20]={0,5,6,7,8,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
 int b[20]={10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10};
 
 Calculation *c=[[Calculation alloc]initWithArray:a andRepairing:b];
 
 NSString *calculated=[NSString stringWithFormat:@"%.11f", [gfs evaluateRepairing:c]];
 NSString *expected=@"0.34911499659";
 STAssertTrue([calculated isEqualToString:expected],@"Calculate");
 
 }
 
 -(void)testEvaluate_DivisionByZero {
 [gfs setValueOf:@"x" value:(double)3];
 int a[20]={3,6,8,8,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
 int b[20]={9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10};
 
 Calculation *c=[[Calculation alloc]initWithArray:a andRepairing:b];
 
 NSString *calculated=[NSString stringWithFormat:@"%.11f", [gfs evaluateRepairing:c]];
 NSString *repr=[[[GFSrein alloc]initWithArray:a andGFS:gfs repairing:b] name];
 
 STAssertTrue([@"(cos(3)/3)" isEqualToString:repr],@"Calculate");
 
 // google: cos ( 3 radians ) / 3 =
 // -0.32999749886
 
 STAssertTrue([@"-0.32999749887" isEqualToString:calculated],@"Calculate");
 
 
 }

 
 */
#import "Heuristic.h"
#import "DDMathParser.h"
#import "DDMathStringTokenizer.h"
#import "DDMathOperator.h"

@import Cocoa;

typedef char** charstrings;

int main(int argc, const char * argv[]) {
    

    // ARC enabled  - input function, blocks & thread groups are created within main block
    @autoreleasepool { // this may cause problems in tests because there is one global pool

        NSString *sampleInputCommand=@"14D6860755|1.23,3.45,23.3|96,20,3|0,3,2|211,356,3456,2234,5,10";
        //NSString *sampleInputCommand=@"y=x^6−2*x^4+x^2,-1.0,1.0,50";
        //NSString *sampleInputCommand=@"z=y^6−2*x^4+x^2,-1.0,1.0,50";
        
        GFS* gfs;
        Configuration *conf=[[Configuration alloc]init];//=[[Configuration alloc]initFromCommand:sampleInputCommand];
        IN *in;
        
        uint64 gfsbin;
        
        
        NSFileManager *filemgr = [[NSFileManager alloc] init];
        NSString *currentpath = [filemgr currentDirectoryPath];
        NSLog(@"currentDirectoryPath:%@",currentpath);
        NSURL *inputurl=[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",currentpath,@"/input.txt"]];
        NSURL *migratingurl;//=[NSURL fileURLWithPath:@"~/migrating.txt"];
        
        charstrings strings;
        int i=0;
        int j=0;
        
        uint *alg;
        uint alglen;
        uint count;
        
        double min;
        double max;
        
        //double *consts;
        uint constslen;
        
        NSScanner *scanner;
        NSArray *separated =[sampleInputCommand componentsSeparatedByString:@"|"];
        NSArray *subseparated;
        
        NSString *functionstr;
        NSArray *expression;
        NSMutableArray *xs;
        NSMutableArray *ys;
        NSMutableArray *zs;
        
        BOOL is3D=NO;
        
        if ([separated count]==1) {
            
            subseparated=[[separated objectAtIndex:0]componentsSeparatedByString:@","];
            functionstr=[subseparated objectAtIndex:0];
            [conf.all setObject:functionstr  forKey:@"function"];
            
            expression=[[subseparated objectAtIndex:0]componentsSeparatedByString:@"="];
            functionstr=[expression objectAtIndex:1];
            
            if (!([[expression objectAtIndex:0]isEqualToString:@"y"])) {
                is3D=YES;
                
                functionstr=[functionstr stringByReplacingOccurrencesOfString:@"y" withString:@"$y"];
            }
            
            functionstr=[functionstr stringByReplacingOccurrencesOfString:@"x" withString:@"$x"];
            functionstr=[functionstr stringByReplacingOccurrencesOfString:@"^" withString:@"**"];
    
            min=[[subseparated objectAtIndex:1]doubleValue];
            max=[[subseparated objectAtIndex:2]doubleValue];
            count=[[subseparated objectAtIndex:3]intValue];
            
            NSMutableString *newinput=[[NSMutableString alloc]init];
            
            xs=[IN ekvidistantDoublesCount:count min:min max:max];
            
            [newinput appendString:[NSString stringWithFormat:@"%@\n",[subseparated objectAtIndex:0]]];
            [newinput appendString:[NSString stringWithFormat:@"%.12f\n",min]];
            [newinput appendString:[NSString stringWithFormat:@"%.12f\n",max]];
            [newinput appendString:[NSString stringWithFormat:@"%d\n",count]];
            
            double result;
            
            NSMutableDictionary *substitutions=[[NSMutableDictionary alloc]init];
            
            DDMathEvaluator *eval = [DDMathEvaluator defaultMathEvaluator];
            
            NSError *s=[[NSError alloc]init];
            DDExpression *function=[DDExpression expressionFromString:functionstr error:&s];
            
            if (is3D) {
                
                ys=[IN ekvidistantDoublesCount:count min:min max:max];
                zs=[[NSMutableArray alloc]initWithCapacity:count*count];
                uint ii=0;
                for (i=0; i<count; i++) {
                    for (j=0; j<count; j++) {
                        [substitutions setValue:[xs objectAtIndex:i] forKey:@"x"];
                        [substitutions setValue:[ys objectAtIndex:j] forKey:@"y"];
                        result=[[eval evaluateExpression:function withSubstitutions:substitutions error:&s]doubleValue];
                        [newinput appendString:[NSString stringWithFormat:@"%.12f,%.12f,%.12f\n",[[xs objectAtIndex:i]doubleValue],[[ys objectAtIndex:j]doubleValue],result]];
                        [zs insertObject:[NSNumber numberWithDouble:result] atIndex:ii++];
                    }
                }
                
            } else {
                ys=[[NSMutableArray alloc]initWithCapacity:count];
                
                for (i=0; i<count; i++) {
                    
                    [substitutions setValue:[xs objectAtIndex:i] forKey:@"x"];
                    result=[[eval evaluateExpression:function withSubstitutions:substitutions error:&s]doubleValue];
                    [ys insertObject:[NSNumber numberWithDouble:result] atIndex:i];
                    [newinput appendString:[NSString stringWithFormat:@"%.12f,%.12f\n",[[xs objectAtIndex:i]doubleValue],result]];
                }
            }
            
            [newinput writeToURL:inputurl atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            in=[[IN alloc] initWithXs:xs Ys:ys Zs:zs min:min max:max andCount:count];

            
        } else {
         
            NSString *inputfile=[NSString stringWithContentsOfURL:inputurl encoding:NSUTF8StringEncoding error:nil];
            
            NSArray *inputfilelines=[inputfile componentsSeparatedByString:@"\n"];
            
            i=0;
            
            uint ii=0;
            for (NSString *line in inputfilelines) {
                i++;
                if (i==1) {
                    
                    expression=[line componentsSeparatedByString:@"="];
                    functionstr=[expression objectAtIndex:1];
                    
                    if (!([[expression objectAtIndex:0]isEqualToString:@"y"]))
                        is3D=YES;
                    
                    [conf.all setObject:line  forKey:@"function"];
                    
                } else if (i==2) {
                    min=[line doubleValue];
                } else if (i==3) {
                    max=[line doubleValue];
                } else if (i==4) {
                    count=[line intValue];
                    if (is3D) {
                        xs=[[NSMutableArray alloc]initWithCapacity:count*count];
                        ys=[[NSMutableArray alloc]initWithCapacity:count*count];
                        zs=[[NSMutableArray alloc]initWithCapacity:count*count];
                    } else {
                        xs=[[NSMutableArray alloc]initWithCapacity:count];
                        ys=[[NSMutableArray alloc]initWithCapacity:count];
                    }
                } else if (((is3D) && (ii<count*count))||((!is3D) && (ii<count))){
                    
                    subseparated=[line componentsSeparatedByString:@","];
                    
                    [xs insertObject:[NSNumber numberWithDouble:[[subseparated objectAtIndex:0]doubleValue]] atIndex:ii];
                    [ys insertObject:[NSNumber numberWithDouble:[[subseparated objectAtIndex:1]doubleValue]] atIndex:ii];
                    
                    if (is3D) {
                        [zs insertObject:[NSNumber numberWithDouble:[[subseparated objectAtIndex:2]doubleValue]] atIndex:ii];
                    }
                    ii++;
                }
            }
            
            in=[[IN alloc] initWithXs:xs Ys:ys Zs:zs min:min max:max andCount:count];

        }
        
        if (is3D)
            [conf.all setObject:@YES forKey:@"3D"];
        else
            [conf.all setObject:@NO forKey:@"3D"];
        
        i=0;
            for (NSConstantString *substring in separated) {
                i++;
                NSLog(@"%@",substring);
                switch (i) {
                    case 1: // parsing gfs (hexadecimal 64 bit number) and saving it to "gfsbin" variable:
                        scanner = [NSScanner scannerWithString:substring];
                        [scanner scanHexLongLong:&gfsbin];
                        [conf.all setObject:[NSNumber numberWithLongLong:gfsbin] forKey:@"GFSbin"];
                        [conf.all setObject:substring forKey:@"GFShex"];
                        break;
                        
                    case 2:
                        subseparated=[substring componentsSeparatedByString:@","];
                        [conf.all setObject:[NSNumber numberWithInt:[subseparated count]] forKey:@"constantsCount"];
                        [conf.all setObject:[subseparated copy] forKey:@"constants"];
                        break;
                        
                    case 3: // metaheuristic's algorithm (array of ints)
                        subseparated=[substring componentsSeparatedByString:@","];
                        [conf.all setObject:[subseparated copy] forKey:@"algorithm"];
                        break;
                        
                    case 4: // metaheuristic's algorithm (array of ints)
                        subseparated=[substring componentsSeparatedByString:@","];
                        [conf.all setObject:[subseparated copy] forKey:@"parameters"];
                        break;
                }
            }
        
        gfs=[[GFS alloc]initWithInput:in andConfiguration:conf];
        NSLog(@"%@",gfs);
        
        
        NSURL *inputfilename = [NSURL URLWithString:@"~/"];
        
        
        
        NSString *parameters=@"";
        
        double *solution = (double *)malloc(sizeof(double) * 16 * 5); // 5 subintervals =>
        int *intsolution = (int *)malloc(sizeof(int) * 96 );
        
        NSMutableString *mutableout=[NSMutableString stringWithFormat:@""];
        NSMutableString *buffer;
        MersenneTwister *mt=[[MersenneTwister alloc]init];
        int x,y=0;
        
        // INPUT FILE:
        // X1,Y1
        // X2,Y2
        
        
        // GLOBAL PARAMETERS FILE:
        //
        
        for (x = 0; x < 96; x++) // ~100
            solution[x]=[mt randomDoubleFrom:0 to:1];
            
        
        for (y=0; y<5;y++) {
            
        for (x = y; x < y+16; x++)
            [buffer appendString:[NSString stringWithFormat:@"%.12f,",solution[x]]];
            
        }
        int end;
        
        //jsonstring s=sfs;
        
        //uint64 gfsbin_in = 89498453845;
        
        //NSString* gfsbinstr_in = [NSString stringWithFormat:@"%qX",gfsbin_in];
        
        //NSLog(@"output: %@",gfsbinstr_in);
        
        //NSMutableString *gfsbinstr_in=[NSMutableString stringWithFormat:@""];
        
        
        int a=30;
        
        //Heuristic* heuristic=[[Heuristic alloc]initWithGFSbin:UINT64_MAX];
        
        //[heuristic search];
        
        /*
         for (int i =33; i<64; i++) {
         actualbit=1 << i;
        
        /*
        HMGL gr = mgl_create_graph(600,400);
        
        mgl_set_origin(gr,0,0,0);
        mgl_set_ranges(gr,-1,1,0,0.17,0,0);
        mgl_axis(gr,"xy","","");
        
        mgl_fplot(gr,"x^6-2*x^4+x^2","w","");
        mgl_fplot(gr,"(cos(((6/6)^5))^5)","","");
        
        //(cos(((6/6)^5))^5)
        
        
        mgl_title(gr,"((\\cos{((\\frac{6}{6})^5)})^5)","",9.9);
        mgl_write_frame(gr,"/Users/cisary/SymbolicRegression/SymbolicRegression/graph.png","desc");
        mgl_delete_graph(gr);
         */
        return NSApplicationMain(argc, argv);
    }
    
}
