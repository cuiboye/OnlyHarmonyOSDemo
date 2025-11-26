import axios from '@ohos/axios';
import { CommonHeader } from '../common/common_header'
import FileUtils from '../common/FileUtils';
import { common } from '@kit.AbilityKit';
import { SystemShareUtils } from '../common/utils/SystemShareUtils';
import { HMRouter } from '@hadss/hmrouter';
import { NavigationConstants } from '../common/constants/NavigationConstants';
import { fileUri, picker } from '@kit.CoreFileKit';
import fs from '@ohos.file.fs';
import { BusinessError } from '@kit.BasicServicesKit';
import { Environment } from '@kit.CoreFileKit';
import { promptAction } from '@kit.ArkUI';

@HMRouter({pageUrl:NavigationConstants.DOWNLOADFILE_PAGE})
@Component
export struct DownloadFilePage {
  context = getContext(this) as common.UIAbilityContext
  @State progress: number = 0
  shareFilePath: string = ""
  hasDownloadUri = "" //已经下载文件的路径
  build() {
    Column() {
      CommonHeader()

      Button('获取Download下载路径')
        .onClick(()=>{
          this.getDownloadPath("", this.context)
        })

      Button('判断文件是否存在')
        .onClick(()=>{
          //判断文件是否存在
          let applicationContext = this.context.getApplicationContext();
          const targetPath = `${applicationContext.filesDir}/app/hahaha9.ppt`;
          let fileExists = FileUtils.fileExists(targetPath)
          if(fileExists){
            promptAction.showToast({message:'文件已经存在'})
          }else {
            promptAction.showToast({message:'文件不存在'})
          }
        })

      Button('文件下载完成后，调用系统分享(需要先使用axios将文件下载下来)')
        .onClick(()=>{
          this.hasDownloadUri = 'file://' + getContext().applicationInfo.name + this.shareFilePath;
          //也可以使用下面的方式 fileUri.getUriFromPath(targetPath) 来获取 uri
          // let uri = fileUri.getUriFromPath(targetPath) ?? ''
          const uniformDataType = SystemShareUtils.getUniformDataType(FileUtils.getFileExtention(this.shareFilePath))
          SystemShareUtils.share(this.getUIContext(), this.hasDownloadUri,uniformDataType)
        })

      Button('将文件下载到文件管理器中，由用户决定保存到哪个目录(需要先使用axios将文件下载下来)')
        .onClick(()=>{
          this.hasDownloadUri = 'file://' + getContext().applicationInfo.name + this.shareFilePath;
          //也可以使用下面的方式 fileUri.getUriFromPath(targetPath) 来获取 uri
          // let uri = fileUri.getUriFromPath(targetPath) ?? ''
          // const uniformDataType = SystemShareUtils.getUniformDataType(FileUtils.getFileExtention(this.shareFilePath))
          //保存到文档管理器
          this.saveDocumentPicker(this.hasDownloadUri)
        })

      Button('将文件下载到文件管理器中的Download目录中(需要先使用axios将文件下载下来)')
        .onClick(()=>{
          this.hasDownloadUri = 'file://' + getContext().applicationInfo.name + this.shareFilePath;
          //也可以使用下面的方式 fileUri.getUriFromPath(targetPath) 来获取 uri
          // let uri = fileUri.getUriFromPath(targetPath) ?? ''
          // const uniformDataType = SystemShareUtils.getUniformDataType(FileUtils.getFileExtention(this.shareFilePath))
          //保存到文档管理器
          this.saveDocumentPickerToDownload(this.hasDownloadUri)
        })

      Button('下载文件')
        .onClick(async () => {
          //判断文件是否存在
          //暂时注释 可以放开
          // let applicationContext = this.context.getApplicationContext();
          // const targetPath = `${applicationContext.filesDir}/app/hahaha9.ppt`;
          // let fileExists = FileUtils.fileExists(targetPath)
          // if(fileExists){
          //   promptAction.showToast({message:'文件已经存在'})
          //   return
          // }
          //不存在先下载文件
          let downloadSuccess = await this.downloadFile("https://wkbjcloudbos.bdimg.com/v1/wenku1325//5a77598dcc9036e3e82cf39e00bd939b?responseContentDisposition=attachment%3B%20filename%3D%22%25E4%25BC%25A0%25E7%25BB%259F%25E4%25B8%25AD%25E5%259B%25BD%25E7%25BB%2598%25E7%2594%25BB%25E7%259A%2584%25E8%2589%25BA%25E6%259C%25AF%25E9%25A3%258E%25E6%25A0%25BC%25E5%2588%2586%25E6%259E%2590.doc%22%3B%20filename%2A%3Dutf-8%27%27%25E4%25BC%25A0%25E7%25BB%259F%25E4%25B8%25AD%25E5%259B%25BD%25E7%25BB%2598%25E7%2594%25BB%25E7%259A%2584%25E8%2589%25BA%25E6%259C%25AF%25E9%25A3%258E%25E6%25A0%25BC%25E5%2588%2586%25E6%259E%2590.doc&responseContentType=application%2Foctet-stream&responseCacheControl=no-cache&authorization=bce-auth-v1%2Ffa1126e91489401fa7cc85045ce7179e%2F2025-11-26T02%3A59%3A34Z%2F3600%2Fhost%2F311a3a2348ef000afebd9ba96b6cc16a3041841d5ce35a8b5237cf1da315b5a1&token=eyJ0eXAiOiJKSVQiLCJ2ZXIiOiIxLjAiLCJhbGciOiJIUzI1NiIsImV4cCI6MTc2NDEyOTU3NCwidXJpIjp0cnVlLCJwYXJhbXMiOlsicmVzcG9uc2VDb250ZW50RGlzcG9zaXRpb24iLCJyZXNwb25zZUNvbnRlbnRUeXBlIiwicmVzcG9uc2VDYWNoZUNvbnRyb2wiXX0%3D.s7L%2BxPGvMri7n9Jw3%2BVZ79M84VRuFUTbpboiRA8LrJA%3D.1764129574")
          if(downloadSuccess){
            //是否下载成功
            promptAction.showToast({message:'下载成功'})
          }
        })
      Text(`当前下载进度为：${this.progress}`)
    }
    .height('100%')
    .width('100%')
  }

  /**
   * 使用axios下载文件
   */
  private async downloadFile(url: string): Promise<boolean> {
    // 1. 创建路径
    let applicationContext = this.context.getApplicationContext();
    const targetPath = `${applicationContext.filesDir}/app/hahaha9.ppt`;
    this.shareFilePath = targetPath
    try {
      await FileUtils.directoryExists(targetPath);
      // 2. 开始下载文件
      await axios({
        url,
        method: 'GET',
        filePath: targetPath,
        responseType: 'ARRAY_BUFFER',
        onDownloadProgress: (progressEvent) => {
          const progress = progressEvent.total ?
            (progressEvent.loaded / progressEvent.total * 100) : 0;
          console.log(`下载进度为：${progress}`)
          this.progress = progress
        }
      });
      // 判断文件大小是否大于0
      const fileSize = FileUtils.getFileSize(targetPath);
      if (fileSize <= 0) {
        throw new Error('下载的文件大小为0');
      }
      return true;
    } catch (error) {
      console.error('下载失败:', error);
      // 错误后需要清理错误文件，因为axios指定下载路径后就会创建这个文件然后往里写内容，就算没写文件也给自动创建了，所以失败需要清理掉。
      FileUtils.cleanFile(targetPath);
      return false;
    }
  }

  /**
   * 将文件下载到文件管理器中，这个方法会调起文件管理器页面让用户自己选择存储到哪个目录
   */
  saveDocumentPicker(sanPath: string){
    const documentSaveOptions = new picker.DocumentSaveOptions(); // 创建文件管理器保存选项实例
    documentSaveOptions.newFileNames = ["filedemo.doc"]; // 保存文件名（可选）
    documentSaveOptions.pickerMode = picker.DocumentPickerMode.DEFAULT;

    const documentViewPicker = new picker.DocumentViewPicker;
    documentViewPicker.save(documentSaveOptions)
      .then(async (documentSaveResult) => {
        // 获取到到图片或者视频文件的URI后进行文件读取等操作
        let uri = documentSaveResult[0];
        console.info('pub uri:' + uri)

        // 沙箱路径文件
        let sanFile = fs.openSync(sanPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
        let pubFile = fs.openSync(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
        // 将文件从沙箱路拷贝到公共路径
        fs.copyFileSync(sanFile.fd, pubFile.fd)
      })
      .catch((err:Error) => {
        console.error(`Invoke documentPicker.select failed, message is ${err.message}`); })
  }

  /**
   * 将文件下载到文件管理器中的Download目录
   * 注意：下面的操作是将文件下载到了Download相关的app目录下，无需权限，可以直接保存
   * 这个方法可以和getDownloadPath方法结合使用
   */
  saveDocumentPickerToDownload(sanPath: string){
    const documentSaveOptions = new picker.DocumentSaveOptions(); // 创建文件管理器保存选项实例
    //使用DocumentPickerMode.DOWNLOAD时documentSaveOptions的其他参数都会失效
    documentSaveOptions.pickerMode = picker.DocumentPickerMode.DOWNLOAD;

    const documentViewPicker = new picker.DocumentViewPicker;
    documentViewPicker.save(documentSaveOptions)
      .then(async (documentSaveResult) => {
        // 获取到到图片或者视频文件的URI后进行文件读取等操作
        let uri = documentSaveResult[0];
        console.info('pub uri:' + uri)
        //拿到uri后需要转换一下
        let path: string = new fileUri.FileUri(uri).path

        // 沙箱路径文件
        let sanFile = fs.openSync(sanPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
        let pubFile = fs.openSync(path+'/filedemo.doc', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)

        // 将文件从沙箱路拷贝到公共路径
        fs.copyFileSync(sanFile.fd, pubFile.fd)
      })
      .catch((err:Error) => {
        console.error(`Invoke documentPicker.select failed, message is ${err.message}`); })
  }

  /**
   * 获取Download的完整路径
   * 这个方法可以和saveDocumentPickerToDownload方法结合使用
   */
  async getDownloadPath(fileName: string, context: common.Context): Promise<string> {
    try {
      let uri: string = '';
      const documentViewPicker = new picker.DocumentViewPicker(context);
      const documentSaveOptions = new picker.DocumentSaveOptions();
      documentSaveOptions.pickerMode = picker.DocumentPickerMode.DOWNLOAD;

      let documentSaveResult: Array<string> = await documentViewPicker.save(documentSaveOptions)
      uri = documentSaveResult[0];

      if(FileUtils.fileExists(new fileUri.FileUri(uri + "/filedemo.doc").path)){
        console.log('文件存在')
      }else {
        console.log('文件不存在')
      }
      return "";
    } catch (e) {
      console.log(`error is ${e}}`)
      return ''
    }
  }
}