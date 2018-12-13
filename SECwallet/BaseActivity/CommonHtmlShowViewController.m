//
//  CommonHtmlJumpViewController.m
//  Huitai
//
//  Created by Laughing on 2017/6/17.
//  Copyright © 2017年 AnrenLionel. All rights reserved.
//

#import "CommonHtmlShowViewController.h"
#import "UIWebView+JS.h"
#import "SelectEntryViewController.h"

@interface CommonHtmlShowViewController ()<UIWebViewDelegate>
{
    UIWebView *_infoWebView;
    UIButton *agreementBtn;
    UIButton *continueBT;
}

@property (nonatomic , strong) UIProgressView *progressView;


@end

@implementation CommonHtmlShowViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setNavgationItemTitle:_titleStr];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tabBarController.tabBar setHidden:YES];
    
    if (_commonHtmlShowViewType == CommonHtmlShowViewType_startRgsProtocol) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    [self initSubViews];
    
}

-(void)initSubViews
{
    _infoWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -KNaviHeight)];
    _infoWebView.backgroundColor = WHITE_COLOR;
    _infoWebView.scrollView.showsVerticalScrollIndicator = NO;
    _infoWebView.scrollView.showsHorizontalScrollIndicator = NO;
    _infoWebView.delegate = self;
    [self.view addSubview:_infoWebView];
    //背景图
    UIImageView *bkgIV = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth -Size(150))/2, Size(150), Size(150), Size(150))];
    bkgIV.image = [UIImage imageNamed:@"logobkg"];
    [_infoWebView addSubview:bkgIV];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, Size(0.5), kScreenWidth, Size(3))];
    _progressView.trackTintColor = WHITE_COLOR;
    _progressView.progressTintColor = TEXT_GOLD_COLOR;
    [self.view addSubview:_progressView];
    if (_commonHtmlShowViewType == CommonHtmlShowViewType_startRgsProtocol) {
        _infoWebView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight -KNaviHeight -Size(80));
//        NSString *content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"RgsProtocol" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
//        [_infoWebView loadHTMLString:content];
        NSString *ducumentLocation = [[NSBundle mainBundle]pathForResource:@"RgsProtocol" ofType:@"docx"];
        _infoWebView.multipleTouchEnabled = YES;
        _infoWebView.scalesPageToFit = YES;
        [_infoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:ducumentLocation]]];
        /*****************用户协议*****************/
        agreementBtn = [[UIButton alloc] initWithFrame:CGRectMake(Size(15), _infoWebView.maxY,Size(180), Size(40))];
        [agreementBtn setTitleColor:TEXT_DARK_COLOR forState:UIControlStateNormal];
        [agreementBtn setTitle:@" 我已仔细阅读并同意以上条款" forState:UIControlStateNormal];
        agreementBtn.titleLabel.font = SystemFontOfSize(14);
        agreementBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [agreementBtn setImage:[UIImage imageNamed:@"invest_protocolun"] forState:UIControlStateNormal];
        [agreementBtn setImage:[UIImage imageNamed:@"invest_protocol"] forState:UIControlStateSelected];
        agreementBtn.selected = NO;
        [agreementBtn addTarget:self action:@selector(agreementBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:agreementBtn];
        //继续
        continueBT = [[UIButton alloc] initWithFrame:CGRectMake(0, agreementBtn.maxY, kScreenWidth, Size(40))];
        [continueBT customerBtnStyle:@"继续" andBkgImg:@"continue"];
        [continueBT addTarget:self action:@selector(continueAction) forControlEvents:UIControlEventTouchUpInside];
        continueBT.userInteractionEnabled = NO;
        [self.view addSubview:continueBT];
        
    }else if (_commonHtmlShowViewType == CommonHtmlShowViewType_RgsProtocol) {
        if ([_titleStr isEqualToString:@"什么是GAS费用？"]) {
            [_infoWebView loadHTMLString:@"在一个公链上，任何人都可以读写数据。读取数据是免费的，但是向公有链中写数据时需要花费一定费用的，这种开销有助于阻止垃圾内容，并通过支付保护其安全性。网络上的任何节点（每个包含账本拷贝的链接设备都被称作节点）都可以参与称作挖矿的方式来保护网络。由于挖矿需要计算能力和电费，所以矿工们的服务需要得到一定的报酬，这也是矿工费的由来。\n矿工会优先打包gas合理，gas price高的交易。如果用户交易时所支付的矿工费非常低，那么这笔交易可能不会被矿工打包，从而造成交易失败。\nCEC的交易费用（也是以太坊的交易费用）=gas 数量*gas price（gas单价，以太币计价）"];
        }else if ([_titleStr isEqualToString:@"什么是助记词？"]) {
            UILabel *lb1 = [[UILabel alloc]initWithFrame:CGRectMake(Size(15), Size(10), kScreenWidth -Size(15 *2), Size(20))];
            lb1.font = SystemFontOfSize(14);
            lb1.textColor = COLOR(175, 132, 68, 1);
            lb1.text = @"助记词的重要性！";
            [_infoWebView addSubview:lb1];
            UILabel *lb2 = [[UILabel alloc]initWithFrame:CGRectMake(lb1.minX, lb1.maxY +Size(5), lb1.width, Size(200))];
            lb2.font = SystemFontOfSize(14);
            lb2.textColor = COLOR(87, 87, 87, 1);
            lb2.numberOfLines = 11;
            lb2.text = @"     助记词是明文私钥的另一种表现形式, 最早是由BIP39提案提出, 其目的是为了帮助用户记忆复杂的私钥 (64位的哈希值)。\n     助记词一般由12、15、18、21个单词构成, 这些单词都取自一个固定词库, 其生成顺序也是按照一定算法而来, 所以用户没必要担心随便输入12个单词就会生成一个地址。虽然助记词和 Keystore 都可以作为私钥的另一种表现形式, 但与 Keystore 不同的是, 助记词是未经加密的私钥, 没有任何安全性可言,任何人得到了你的助记词, 可以不费吹灰之力的夺走你的资产。";
            //设置行间距
            NSMutableAttributedString *lb2Str = [[NSMutableAttributedString alloc] initWithString:lb2.text];
            NSMutableParagraphStyle * lb2paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            lb2paragraphStyle.lineSpacing = Size(5);
            [lb2Str addAttribute:NSParagraphStyleAttributeName value:lb2paragraphStyle range:NSMakeRange(0, lb2Str.length)];
            lb2.attributedText = lb2Str;
            [_infoWebView addSubview:lb2];
            
            UILabel *lb3 = [[UILabel alloc]initWithFrame:CGRectMake(lb2.minX, lb2.maxY +Size(10), lb2.width, lb1.height)];
            lb3.font = SystemFontOfSize(14);
            lb3.textColor = COLOR(175, 132, 68, 1);
            lb3.text = @"所以在用户在备份助记词之后, 一定要注意三点:";
            [_infoWebView addSubview:lb3];
            UILabel *lb4 = [[UILabel alloc]initWithFrame:CGRectMake(lb3.minX, lb3.maxY, lb3.width, Size(120))];
            lb4.font = SystemFontOfSize(14);
            lb4.textColor = COLOR(87, 87, 87, 1);
            lb4.numberOfLines = 6;
            lb4.text = @"1. 尽可能采用物理介质备份, 例如用笔抄在纸上等, 尽可能不要采用截屏或者拍照之后放在联网的设备里,以防被黑客窃取。\n2. 多次验证备份的助记词是否正确, 一旦抄错一两个单词, 那么将对后续找回正确的助记词带来巨大的困难;\n3. 将备份后的助记词妥善保管, 做好防盗防丢措施。";
            //设置行间距
            NSMutableAttributedString *lb4Str = [[NSMutableAttributedString alloc] initWithString:lb4.text];
            NSMutableParagraphStyle * lb4paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            lb4paragraphStyle.lineSpacing = Size(5);
            [lb4Str addAttribute:NSParagraphStyleAttributeName value:lb4paragraphStyle range:NSMakeRange(0, lb4Str.length)];
            lb4.attributedText = lb4Str;
            [_infoWebView addSubview:lb4];
            //小贴士
            UIView *bkgView = [[UIView alloc]initWithFrame:CGRectMake(lb4.minX, lb4.maxY +Size(10), lb4.width, Size(90))];
            bkgView.layer.cornerRadius = Size(3);
            bkgView.alpha = 0.14;
            bkgView.backgroundColor = COLOR(175, 132, 68, 1);
            [_infoWebView addSubview:bkgView];
            UILabel *lb5 = [[UILabel alloc]initWithFrame:CGRectMake(bkgView.minX +Size(8), bkgView.minY +Size(5), lb3.width -Size(8 *2), Size(80))];
            lb5.font = SystemFontOfSize(14);
            lb5.textColor = COLOR(87, 87, 87, 1);
            lb5.numberOfLines = 4;
            lb5.text = @"小贴士：\n用户可以使用备份的助记词, 重新导入CEC钱包 ,用新的密码生成一个新的 Keystore, 用这种方法来修改钱包密码。";
            //设置行间距
            NSMutableAttributedString *lb5Str = [[NSMutableAttributedString alloc] initWithString:lb5.text];
            NSMutableParagraphStyle * lb5paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            lb5paragraphStyle.lineSpacing = Size(5);
            [lb5Str addAttribute:NSParagraphStyleAttributeName value:lb5paragraphStyle range:NSMakeRange(0, lb5Str.length)];
            lb5.attributedText = lb5Str;
            [_infoWebView addSubview:lb5];
            
        }else if ([_titleStr isEqualToString:@"什么是keystore？"]) {
            
            UILabel *lb1 = [[UILabel alloc]initWithFrame:CGRectMake(Size(15), Size(10), kScreenWidth -Size(15 *2), Size(100))];
            lb1.font = SystemFontOfSize(14);
            lb1.textColor = COLOR(87, 87, 87, 1);
            lb1.numberOfLines = 5;
            lb1.text = @"     Keystore 文件是以太坊钱包存储私钥的一种文件格式 (JSON)。它使用用户自定义密码加密，以起到一定程度上的保护作用, 而保护的程度取决于用户加密该钱包的密码强度, 如果类似于 123456 这样的密码, 是极为不安全的。";
            //设置行间距
            NSMutableAttributedString *lb1Str = [[NSMutableAttributedString alloc] initWithString:lb1.text];
            NSMutableParagraphStyle * lb1paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            lb1paragraphStyle.lineSpacing = Size(5);
            [lb1Str addAttribute:NSParagraphStyleAttributeName value:lb1paragraphStyle range:NSMakeRange(0, lb1Str.length)];
            lb1.attributedText = lb1Str;
            [_infoWebView addSubview:lb1];
            
            UILabel *lb2 = [[UILabel alloc]initWithFrame:CGRectMake(lb1.minX, lb1.maxY +Size(5), lb1.width, Size(20))];
            lb2.font = SystemFontOfSize(14);
            lb2.textColor = COLOR(175, 132, 68, 1);
            lb2.text = @"在使用 Keystore 时有两点需要注意:";
            [_infoWebView addSubview:lb2];
            UILabel *lb3 = [[UILabel alloc]initWithFrame:CGRectMake(lb2.minX, lb2.maxY, lb2.width, Size(120))];
            lb3.font = SystemFontOfSize(14);
            lb3.textColor = COLOR(87, 87, 87, 1);
            lb3.numberOfLines = 6;
            lb3.text = @"1. 使用不常用, 并且尽可能复杂的密码加密 Keystore文件;\n2. 一定要记住加密 Keystore 的密码, 一旦忘记密码,那么你就失去了 Keystore 的使用权, 并且CEC钱包无法帮你找回密码, 所以一定要妥善保管好 Keystore以及密码。";
            //设置行间距
            NSMutableAttributedString *lb3Str = [[NSMutableAttributedString alloc] initWithString:lb3.text];
            NSMutableParagraphStyle * lb3paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            lb3paragraphStyle.lineSpacing = Size(5);
            [lb3Str addAttribute:NSParagraphStyleAttributeName value:lb3paragraphStyle range:NSMakeRange(0, lb3Str.length)];
            lb3.attributedText = lb3Str;
            [_infoWebView addSubview:lb3];
            
            UILabel *lb4 = [[UILabel alloc]initWithFrame:CGRectMake(lb3.minX, lb3.maxY +Size(10), lb3.width, lb2.height)];
            lb4.font = SystemFontOfSize(14);
            lb4.textColor = COLOR(87, 87, 87, 1);
            lb4.text = @"下面是 Keystore 的样式:";
            [_infoWebView addSubview:lb4];
            UILabel *lb5 = [[UILabel alloc]initWithFrame:CGRectMake(lb4.minX, lb4.maxY, lb4.width, Size(120))];
            lb5.font = SystemFontOfSize(10);
            lb5.textColor = COLOR(87, 87, 87, 1);
            lb5.numberOfLines = 8;
            lb5.text = [NSString stringWithFormat:@"{\"version\":\3\",\"id\":\"b7467fcb-3c8b-41bebccf-73d43a08c1b7\",\"address\":\"540f18196da5a533fa36577a81de55f0a2f4e751\",\"Crypto\":\"{\"ciphertext\":\"78ed11b8b6bf29b00f52b42b8542df0e4a6ac078e626af7edcf885c3b68154a4\",\"cipherparams\"{\"iv\":\"4516579601d96695fe30ace985a9066f\"},\"cipher\":\"aes-128ctr\",\"kdf\":\"scrypt\",\"kdfparams\"{\"dklen\"32,\"salt\":\"6276cfda7d40872352c801db5871e5a3368a8d0994cea39ed936760db78d1cdc\",\"n\":1024,\"r\":8,\"p\":1},\"mac\":\"d889a5dc609c3f312a41394cc47640676d2612501a6f8c837ed55598336db\"}\"}"];
            //设置行间距
            NSMutableAttributedString *lb5Str = [[NSMutableAttributedString alloc] initWithString:lb5.text];
            NSMutableParagraphStyle * lb5paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            lb5paragraphStyle.lineSpacing = Size(5);
            [lb5Str addAttribute:NSParagraphStyleAttributeName value:lb5paragraphStyle range:NSMakeRange(0, lb5Str.length)];
            lb5.attributedText = lb5Str;
            [_infoWebView addSubview:lb5];
            
            //小贴士
            UIView *bkgView = [[UIView alloc]initWithFrame:CGRectMake(lb5.minX, lb5.maxY +Size(10), lb5.width, Size(90))];
            bkgView.layer.cornerRadius = Size(3);
            bkgView.alpha = 0.14;
            bkgView.backgroundColor = COLOR(175, 132, 68, 1);
            [_infoWebView addSubview:bkgView];
            UILabel *lb6 = [[UILabel alloc]initWithFrame:CGRectMake(bkgView.minX +Size(8), bkgView.minY +Size(5), lb3.width -Size(8 *2), Size(80))];
            lb6.font = SystemFontOfSize(14);
            lb6.textColor = COLOR(87, 87, 87, 1);
            lb6.numberOfLines = 4;
            lb6.text = @"小贴士：\nKeystore 的密码是唯一、不可更改的, 如果想更改钱包密码需要使用助记词或明文私钥重新导入钱包,并使用新密码加密, 生成新的 Keystore。";
            //设置行间距
            NSMutableAttributedString *lb6Str = [[NSMutableAttributedString alloc] initWithString:lb6.text];
            NSMutableParagraphStyle * lb6paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            lb6paragraphStyle.lineSpacing = Size(5);
            [lb6Str addAttribute:NSParagraphStyleAttributeName value:lb6paragraphStyle range:NSMakeRange(0, lb6Str.length)];
            lb6.attributedText = lb6Str;
            [_infoWebView addSubview:lb6];
            
        }else if ([_titleStr isEqualToString:@"什么是私钥？"]) {
            UILabel *lb1 = [[UILabel alloc]initWithFrame:CGRectMake(Size(15), Size(10), kScreenWidth -Size(15 *2), Size(300))];
            lb1.font = SystemFontOfSize(14);
            lb1.textColor = COLOR(87, 87, 87, 1);
            lb1.numberOfLines = 14;
            lb1.text = @"     我们常说, 你对钱包中资金的控制取决于相应私钥的所有权和控制权。在区块链交易中, 私钥用于生成支付货币所必须的签名, 以证明资金的所有权。私钥必须始终保持机密, 因为一旦泄露给第三方, 相当于该私钥保护下的资产也拱手相让了。它不同于Keystore是加密过后的私钥文件, 只要密码强度足够强, 即使黑客得到 Keystore, 破解难度也足够大。\n     存储在用户钱包中的私钥完全独立, 可由用户的钱包软件生成并管理, 无需区块链或者网络连接。\n     用户的钱包地址由公钥经过 keccak256 计算，截取后 40 位 + 0x 得到的。私钥的样式为64位16进制的哈希值字符串。例如:56f759ece75f0ab1b783893cbe390288978d4d4ff24dd233245b4285fcc31cf6";
            //设置行间距
            NSMutableAttributedString *lb1Str = [[NSMutableAttributedString alloc] initWithString:lb1.text];
            NSMutableParagraphStyle * lb1paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            lb1paragraphStyle.lineSpacing = Size(5);
            [lb1Str addAttribute:NSParagraphStyleAttributeName value:lb1paragraphStyle range:NSMakeRange(0, lb1Str.length)];
            lb1.attributedText = lb1Str;
            [_infoWebView addSubview:lb1];
            
            //小贴士
            UIView *bkgView = [[UIView alloc]initWithFrame:CGRectMake(lb1.minX, lb1.maxY +Size(20), lb1.width, Size(90))];
            bkgView.layer.cornerRadius = Size(3);
            bkgView.alpha = 0.14;
            bkgView.backgroundColor = COLOR(175, 132, 68, 1);
            [_infoWebView addSubview:bkgView];
            UILabel *lb2 = [[UILabel alloc]initWithFrame:CGRectMake(bkgView.minX +Size(8), bkgView.minY +Size(5), lb1.width -Size(8 *2), Size(80))];
            lb2.font = SystemFontOfSize(14);
            lb2.textColor = COLOR(87, 87, 87, 1);
            lb2.numberOfLines = 4;
            lb2.text = @"小贴士：\n用户可以使用明文私钥导入CEC钱包, 用新的密码生成一个新的 Keystore (记得要将旧的 Keystore 删除), 用这种方法来修改钱包密码。";
            //设置行间距
            NSMutableAttributedString *lb2Str = [[NSMutableAttributedString alloc] initWithString:lb2.text];
            NSMutableParagraphStyle * lb2paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            lb2paragraphStyle.lineSpacing = Size(5);
            [lb2Str addAttribute:NSParagraphStyleAttributeName value:lb2paragraphStyle range:NSMakeRange(0, lb2Str.length)];
            lb2.attributedText = lb2Str;
            [_infoWebView addSubview:lb2];
        }else{
            NSString *ducumentLocation = [[NSBundle mainBundle]pathForResource:@"RgsProtocol" ofType:@"docx"];
            _infoWebView.multipleTouchEnabled = YES;
            _infoWebView.scalesPageToFit = YES;
            [_infoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:ducumentLocation]]];
        }
        
    }else if (_commonHtmlShowViewType == CommonHtmlShowViewType_other) {
        [_infoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_adUrl]]];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_progressView setProgress:0.8 animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_progressView setProgress:1.0 animated:YES];
    [_progressView removeFromSuperview];
    //禁止webview编辑
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
}

//协议
-(void)agreementBtnAction:(UIButton *)btn
{
    agreementBtn.selected = !agreementBtn.selected;
    if (!agreementBtn.selected) {
        [continueBT setBackgroundColor:DARK_COLOR];
        continueBT.userInteractionEnabled = NO;
    }else{
        [continueBT setBackgroundColor:TEXT_GOLD_COLOR];
        continueBT.userInteractionEnabled = YES;
    }
}
//继续
-(void)continueAction
{
    SelectEntryViewController *viewController = [[SelectEntryViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
    AppDelegateInstance.window.rootViewController = navi;
    [AppDelegateInstance.window makeKeyAndVisible];
}

@end
