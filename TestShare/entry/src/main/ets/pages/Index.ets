import { wxApi, WxShareViewModel } from '../utils/WxShareViewModel';
import { common } from '@kit.AbilityKit';
import axios from '@ohos/axios';
import fs from '@ohos.file.fs';
import { promptAction } from '@kit.ArkUI';
import { QQShareInstance } from '../utils/QQShareInstance';
import { QQShareBean } from '../QQShareBean';
import { WeiboShareInstance } from '../utils/WeiboShareInstance';
import * as wxopensdk from '@tencent/wechat_open_sdk';

@Entry
@Component
struct Index {
  context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  build() {
    Column() {
      Button('分享文本到微信')
        .onClick(()=>{
          WxShareViewModel.getInstance().shareText(this.context,"hello")
        })
      Button('分享图片到微信')
        .onClick(()=>{
          this.downloadImage("shareimage","https://inews.gtimg.com/news_bt/OBkbmPLeWLy4IM4oUDGvOIqSDSZ9lYOtW3qSXCYh78KXcAA/1000")
        })
      Button('分享小程序到微信')
        .onClick(()=>{
          this.downloadImageToShareMiniProgram("shareimage","https://inews.gtimg.com/news_bt/OBkbmPLeWLy4IM4oUDGvOIqSDSZ9lYOtW3qSXCYh78KXcAA/1000")
        })

      Button('分享链接到QQ')
        .onClick(()=>{
          let shareBean:QQShareBean = new QQShareBean()
          shareBean.brief = "挖酒网"
          shareBean.msg_style = 0
          shareBean.picture_url = "https://edu-wenku.bdimg.com/v1/android/pic/android/android_wenku_share_icon-1532496424806.png"
          shareBean.summary = "我正在@挖酒网 阅读【注册安全工程师电气安全试卷】这篇文章，推荐给大家！文档链接在这里：http://wenku.baidu.com/view/874831c3b7daa58da0116c175f0e7cd185251806?from_appshare=readpage（用文库客户端随时随地阅读海量文档，马上下载体验http://wenku.baidu.com/apps?fr=2001&dataLib）"
          shareBean.title = "注册安全工程师电气安全试卷"
          shareBean.url = "https://wenku.baidu.com/view/874831c3b7daa58da0116c175f0e7cd185251806?from_appshare=dataLib"

          QQShareInstance.shareToQQFriend(shareBean,this.context)
        })
      Button('分享文件到微信好友')
        .onClick(()=>{
          this.downloadFileShareToWX("myfile","http://wkbjcloudbos.bdimg.com/v1/wenku10//77207907140c7d2855aaf8cec64e85c2?responseContentDisposition=attachment%3B%20filename%3D%22%25E5%2585%258D%25E8%25B4%25B9ppt%25E6%25A8%25A1%25E6%259D%25BF.ppt%22%3B%20filename%2A%3Dutf-8%27%27%25E5%2585%258D%25E8%25B4%25B9ppt%25E6%25A8%25A1%25E6%259D%25BF.ppt&responseContentType=application%2Foctet-stream&responseCacheControl=no-cache&authorization=bce-auth-v1%2Ffa1126e91489401fa7cc85045ce7179e%2F2025-09-24T01%3A45%3A10Z%2F3600%2Fhost%2F1642e884e2e043f4023f96c65cc58c61976ec77323b6f3b4aef4fd88829fc89b&token=eyJ0eXAiOiJKSVQiLCJ2ZXIiOiIxLjAiLCJhbGciOiJIUzI1NiIsImV4cCI6MTc1ODY4MTkxMCwidXJpIjp0cnVlLCJwYXJhbXMiOlsicmVzcG9uc2VDb250ZW50RGlzcG9zaXRpb24iLCJyZXNwb25zZUNvbnRlbnRUeXBlIiwicmVzcG9uc2VDYWNoZUNvbnRyb2wiXX0%3D.%2BR1qQSgZBBxHM7LTWu2PT8lVGf5jPXXhtQlA5Mdv%2B7g%3D.1758681910")
        })
      Button('分享到微博')
        .onClick(()=>{
          this.downloadImageToWeibo("shareimage","https://inews.gtimg.com/news_bt/OBkbmPLeWLy4IM4oUDGvOIqSDSZ9lYOtW3qSXCYh78KXcAA/1000")
        })
      Button('微信登录')
        .onClick(async ()=>{
          let req = new wxopensdk.SendAuthReq
          req.isOption1 = false
          req.nonAutomatic = true
          // req.scope = 'snsapi_userinfo'//只能填 snsapi_userinfo
          req.scope = 'snsapi_userinfo,snsapi_friend,snsapi_message,snsapi_contact'
          req.state = 'none'
          req.transaction = 'test123'

          // 向微信发送登录请求:
          //   finished为跳转微信的结果：true表示跳转成功；false表示跳转失败，可能是因为微信未安装
          let finished = await wxApi.sendReq(this.context, req)
          // finished为true时，获取微信个人信息的操作需要参考这个链接：
          // https://developers.weixin.qq.com/doc/oplatform/Mobile_App/WeChat_Login/Development_Guide.html
        })
    }
    .height('100%')
    .width('100%')
  }

  public async downloadFileShareToWX(fileName: string, url: string) {
    let applicationContext = this.context.getApplicationContext();
    const targetPath = `${applicationContext.filesDir}/downloads/${fileName}.ppt`
    try {
      //验证路径是否存在
      await this.directoryExists(targetPath);
      // 2. 开始下载文件
      await axios({
        url,
        method: 'GET',
        filePath: targetPath,
        responseType: 'ARRAY_BUFFER',
        onDownloadProgress: (progressEvent) => {
          const progress = progressEvent.total ? (progressEvent.loaded / progressEvent.total * 100) : 0;
          console.log('当前进度---', progress)
        }
      });
      // context: common.UIAbilityContext, shareFilePath: string,title:string,desc?:string
      WxShareViewModel.getInstance().shareFile(this.context, targetPath,"测试发送文件")
    } catch (error) {
      promptAction.showToast({ message: '下载失败' })
    }
  }

  async directoryExists(filePath: string): Promise<void> {
    const dirPath = filePath.substring(0, filePath.lastIndexOf('/'));
    if (!fs.accessSync(dirPath)) {
      fs.mkdirSync(dirPath);
    }
  }

  //这里只是简单的储存下图片，正式的时候可以参考OnlyHarmonyOSDemo的SaveImagePage这个类中的saveImageWithCopy这个方法
  public async downloadImage(imageName: string, url: string){
    let applicationContext = this.context.getApplicationContext();
    const targetPath = `${applicationContext.filesDir}/downloads/${imageName}.png`
    try {
      //验证路径是否存在
      await this.directoryExists(targetPath);
      // 2. 开始下载文件
      await axios({
        url,
        method: 'GET',
        filePath: targetPath,
        responseType: 'ARRAY_BUFFER',
        onDownloadProgress: (progressEvent) => {
          const progress = progressEvent.total ?
            (progressEvent.loaded / progressEvent.total * 100) : 0;
          console.log('当前进度---', progress)
        }
      });

      WxShareViewModel.getInstance().shareImage(this.context,targetPath)
    } catch (error) {
      promptAction.showToast({message:'下载失败'})
    }
  }

  public async downloadImageToShareMiniProgram(imageName: string, url: string){
    let applicationContext = this.context.getApplicationContext();
    const targetPath = `${applicationContext.filesDir}/downloads/${imageName}.png`
    try {
      //验证路径是否存在
      await this.directoryExists(targetPath);
      // 2. 开始下载文件
      await axios({
        url,
        method: 'GET',
        filePath: targetPath,
        responseType: 'ARRAY_BUFFER',
        onDownloadProgress: (progressEvent) => {
          const progress = progressEvent.total ?
            (progressEvent.loaded / progressEvent.total * 100) : 0;
          console.log('当前进度---', progress)
        }
      });
      WxShareViewModel.getInstance().shareMiniProgram(this.context,targetPath)
    } catch (error) {
      promptAction.showToast({message:'下载失败'})
    }
  }

  public async downloadImageToWeibo(imageName: string, url: string){
    let applicationContext = this.context.getApplicationContext();
    const targetPath = `${applicationContext.filesDir}/downloads/${imageName}.png`
    try {
      //验证路径是否存在
      await this.directoryExists(targetPath);
      // 2. 开始下载文件
      await axios({
        url,
        method: 'GET',
        filePath: targetPath,
        responseType: 'ARRAY_BUFFER',
        onDownloadProgress: (progressEvent) => {
          const progress = progressEvent.total ?
            (progressEvent.loaded / progressEvent.total * 100) : 0;
          console.log('当前进度---', progress)
        }
      });

      // WeiboShareInstance.share("我是title","我是desc","http://www.baidu.com","",this.context,1)//文字
      // WeiboShareInstance.share("","","",targetPath,this.context,2)//图片
      WeiboShareInstance.share("","@\"我正在@百度文库 阅读【(优质公开课)-学前班音乐公开课教案 第4课《小路弯弯》50页教案】http://wenku.baidu.com/view/79f8b4e55bf5f61fb7360b4c2e3f5727a5e92465?from_appshare=readpage，推荐给大家！（在http://wenku.baidu.com/apps?fr=2001&readpage下载文库客户端!）","http://www.baidu.com",targetPath,this.context,3)//图片+文字
    } catch (error) {
      promptAction.showToast({message:'下载失败'})
    }
  }
}