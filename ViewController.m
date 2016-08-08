//
//  ViewController.m
//  UIWebView
//
//  Created by 郑天昊 on 16/7/26.
//  Copyright © 2016年 rmitec. All rights reserved.
//

#import "ViewController.h"
#import "ComponentBlock.h"

#import "AFNetworking.h"
typedef void (^ReusltBlock)(void);
@interface ViewController ()
@property (nonatomic,strong) ReusltBlock reslt;
@property (nonatomic,strong) ComponentBlock *componet;
@property (nonatomic,strong) UILabel *showlabel;
@property (nonatomic,strong) NSDictionary *dict;
@end


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.dict = [[NSDictionary alloc]init];
    
    self.showlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, self.view.frame.size.width-20, 50)];
    [self.view addSubview:self.showlabel];
    

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"20160801", @"date", @"1", @"startRecord", @"5", @"len", @"1234567890", @"udid", @"Iphone", @"terminalType", @"213", @"cid", nil];
//    初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    不加上这句话， 会报 Reqest failed ：unacceptable content-type text.plain错误 因为我们要获取text /plain数据类型
    

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    post请求

    [manager POST:@"http://ipad-bjwb.bjd.com.cn/DigitalPublication/publish/Handler/APINewsList.ashx?" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
    {
        
//        拼接data到请求，这个block 的参数是遵守AFMultiPartFormData协议
    }
          progress:^(NSProgress * _Nonnull uploadProgress)
    {
  
//        这里可以获取到目前的数据请求的进度
    }
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
       
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

         NSArray *arr = dic[@"news"];
         [self writeFileToSandBox:dic];
         NSDictionary *content = arr[0];
         NSString *date = content[@"summary"];
         self.showlabel.text = date;
         
         self.dict = dic;
       NSLog(@"%@",self.dict)  ;
    }
           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        
        NSLog(@"%@",[error localizedDescription]);
    }];
    
//
//     Do any additional setup after loading the view, typically from a nib.
//    [self buildWebInfofromHtmlwithName:@"Baidu"];
    

    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
    
//    创建文件夹
//    NSString *createDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"BySelf"];
//    NSString *subDir = [createDir stringByAppendingPathComponent:@"subDir"];
//    [self createFolder:subDir];
    
}


- (void)writeFileToSandBox:(NSDictionary *)dicfile;
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *docdir = [paths lastObject];
    if (!docdir) {
        NSLog(@"DocDir目录未找到");
    }
    
    NSString *filePath = [docdir stringByAppendingPathComponent:@"testFle.plist"];
//    [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    [dicfile writeToFile:filePath atomically:YES];
    NSLog(@"%@",filePath);
    
}
- (void)createFolder:(NSString *)createDir
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:createDir isDirectory:&isDir];
    if (!(isDir == YES && existed == YES))
    {
        [fileManager createDirectoryAtPath:createDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}


//    沙盒Lib目录
   /**
 *  把Resouce 文件夹下的save1.dat 拷贝到沙盒
 *
 *  @param soourcePath Resource文件路径
 *  @param toPath      把文件拷贝到xxx文件夹
 *
 *  @return BOOL
 */
- (BOOL)copyMissingFile:(NSString *)soourcePath toPath:(NSString *)toPath
{
    BOOL retVal = YES; //if the file already exists ,we'll retrun success
    NSString *finalLocation = [toPath stringByAppendingPathComponent:[soourcePath lastPathComponent]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalLocation]) {
        retVal = [[NSFileManager defaultManager] copyItemAtPath:soourcePath toPath:finalLocation error:NULL];
        
    }

    
    return retVal;
}



/**
 *  从html文件加载webview
 **/
-(void)buildWebInfofromHtmlwithName:(NSString *)namePath
{
    // === 沙盒路径
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"%@",cachPath);
    NSString *htmlname = [NSString stringWithFormat:@"%@.html",namePath];
    NSString *filePath =[cachPath stringByAppendingPathComponent:htmlname]; // === 得到 html
    // === 图片路径
    NSString *picPath = [cachPath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    picPath = [picPath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *str = [NSString stringWithFormat:@"file:/%@//%@_files",picPath,namePath];
    NSURL *baseUrl = [NSURL URLWithString:str];
    //    NSLog(@"============== last filepath is %@",baseUrl);
    
    // === encoding:NSUTF8StringEncoding error:nil 这一段一定要加，不然中文字会乱码
    NSString *htmlstring=[[NSString alloc]initWithContentsOfFile:filePath  encoding:NSUTF8StringEncoding error:nil];
   UIWebView* _contentWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _contentWeb.scalesPageToFit = YES;
    _contentWeb.backgroundColor = [UIColor redColor];
    [_contentWeb loadHTMLString:htmlstring baseURL:baseUrl];
    [self.view addSubview:_contentWeb];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
