import * as wxOpenSdk from '@tencent/wechat_open_sdk';
import { common } from '@kit.AbilityKit';
import { SendMessageToWXReq } from '@tencent/wechat_open_sdk';
import { image } from '@kit.ImageKit';
import { fileUri } from '@kit.CoreFileKit';

/**
 * 微信分享:目前只支持分享图片，小程序和文本
 */
export class WxShareViewModel {
  static instance: WxShareViewModel | null = null
  isWXApp: boolean = wxApi.isWXAppInstalled()

  //单例模式 constructor 需要设置为 private
  private constructor() {

  }

  static getInstance() {
    if (!WxShareViewModel.instance) {
      WxShareViewModel.instance = new WxShareViewModel()
    }
    return WxShareViewModel.instance
  }

  static isEmpty(str: string | undefined): boolean {
    return undefined == str || null == str || "" == str || '' == str;
  }

  //分享文本
   async shareText(context: common.UIAbilityContext, text: string) {
    // 微信限制文本长度不能超过1024
    if (text != null) {
      if (!WxShareViewModel.isEmpty(text) && text.length > 1024) {
        text = text.substring(0, 1024)
      }
    }
    let textObject:wxOpenSdk.WXTextObject = new wxOpenSdk.WXTextObject
    textObject.text = text

    let mediaMessage = new wxOpenSdk.WXMediaMessage()
    mediaMessage.mediaObject = textObject

    let req = new wxOpenSdk.SendMessageToWXReq()
    req.scene = SendMessageToWXReq.WXSceneSession
    req.message = mediaMessage
    wxApi.sendReq(context, req)
  }

  //分享图片
  //downloadLocalImagePath：下载到本地的图片路径
  async shareImage(context: common.UIAbilityContext,downloadLocalImagePath:string ) {
    const imageObject = new wxOpenSdk.WXImageObject
    imageObject.uri = fileUri.getUriFromPath(downloadLocalImagePath)

    const mediaMessage = new wxOpenSdk.WXMediaMessage()
    mediaMessage.mediaObject = imageObject

    //压缩图片
    const thumbData = await context.resourceManager.getMediaContent($r("app.media.startIcon"))
    const thumbPixel = image.createImageSource(thumbData.buffer).createPixelMapSync()
    const thumbBuffer = await image.createImagePacker().packToData(thumbPixel, { format: "image/png", quality: 100 })
    mediaMessage.thumbData = new Uint8Array(thumbBuffer)

    const req = new wxOpenSdk.SendMessageToWXReq()
    req.transaction = this.buildTransaction("img")
    req.message = mediaMessage
    const scene: number = SendMessageToWXReq.WXSceneSession //SendMessageToWXReq.WXSceneSessio为会话，也可以设置为朋友圈
    req.scene = scene

    wxApi.sendReq(context, req)
  }

  //shareImageDownloadLocalPath：封面需要下载到本地，使用下载到本地的image路径
  async shareMiniProgram(context: common.UIAbilityContext,shareImageDownloadLocalPath:string) {
    const miniProgramObject = new wxOpenSdk.WXMiniProgramObject()
    miniProgramObject.webpageUrl = "https://wenku.baidu.com/view/79f8b4e55bf5f61fb7360b4c2e3f5727a5e92465?from_appshare=dataLib" //小程序链接
    miniProgramObject.userName = "gh_bee515dc2420"
    // miniProgramObject.path = "/pages/homepage/homepage?nextPage=%2Fpages%2Fview%2Fview%3Fdocid%3D79f8b4e55bf5f61fb7360b4c2e3f5727a5e92465&isXreader=1"
    miniProgramObject.path = ""
    miniProgramObject.miniprogramType = wxOpenSdk.WXMiniProgramType.RELEASE
    const mediaMessage = new wxOpenSdk.WXMediaMessage()
    mediaMessage.mediaObject = miniProgramObject
    mediaMessage.title = "我是分享的title"

    //生成缩略图，缩略图需要下载到本地，分享的时候使用本地的地址
    if (shareImageDownloadLocalPath != null && shareImageDownloadLocalPath!="") {
      const thumbPixel = image.createImageSource(shareImageDownloadLocalPath).createPixelMapSync()
      const thumbBuffer = await this.compressImage(thumbPixel, 64, 100)
      if (thumbBuffer) {
        mediaMessage.thumbData = new Uint8Array(thumbBuffer)
      }
    } else {
      //默认的封面
      const thumbData = await context.resourceManager.getMediaContent($r("app.media.startIcon"))
      const thumbPixel = image.createImageSource(thumbData.buffer).createPixelMapSync()
      const thumbBuffer = await image.createImagePacker().packToData(thumbPixel, { format: "image/png", quality: 100 })
      mediaMessage.thumbData = new Uint8Array(thumbBuffer)
    }
    const req = new wxOpenSdk.SendMessageToWXReq()
    req.transaction = this.buildTransaction("miniProgram")
    req.scene = wxOpenSdk.SendMessageToWXReq.WXSceneSession
    req.message = mediaMessage

    wxApi.sendReq(context, req)
  }

  async compressImage(sourcePixelMap: image.PixelMap, maxCompressedImageSize: number, imageQuality: number) {
    let packOpts: image.PackingOption = { format: "image/jpeg", quality: imageQuality }
    let compressedImageData = await image.createImagePacker().packToData(sourcePixelMap, packOpts)
    const maxCompressedImageByte = maxCompressedImageSize * 1024
    while (maxCompressedImageByte < compressedImageData.byteLength) {
      compressedImageData =
        await this.compressImage(sourcePixelMap, maxCompressedImageSize, imageQuality - 10)
    }
    return compressedImageData
  }

  //图片设置宽高
  async packingDetail(pixelMap: PixelMap, targetWidth: number, targetHeight: number) {
    if (pixelMap) {
      let imageInfo = await pixelMap.getImageInfo();
      // 计算压缩比
      let scaleX: number = targetWidth / imageInfo.size.width;
      let scaleY: number = targetHeight / imageInfo.size.height;
      pixelMap.scaleSync(scaleX, scaleY)
      return pixelMap
    }
    return null
  }

  //生成时间戳
  private buildTransaction(type: string): string {
    return (type == null) ? Date.now().toString() : type + Date.now();
  }
}

export const wxApi = wxOpenSdk.WXAPIFactory.createWXAPI("wx9a773f86b35b3c8e")