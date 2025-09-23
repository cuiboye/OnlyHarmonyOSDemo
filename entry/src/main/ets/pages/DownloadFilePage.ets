import axios from '@ohos/axios';
import { CommonHeader } from '../common/common_header'
import FileUtils from '../common/FileUtils';
import { common } from '@kit.AbilityKit';
import { SystemShareUtils } from '../common/utils/SystemShareUtils';
import { HMRouter } from '@hadss/hmrouter';
import { NavigationConstants } from '../common/constants/NavigationConstants';
import { fileUri } from '@kit.CoreFileKit';

@HMRouter({pageUrl:NavigationConstants.DOWNLOADFILE_PAGE})
@Component
export struct DownloadFilePage {
  context = getContext(this) as common.UIAbilityContext
  @State progress: number = 0
  shareFilePath: string = ""

  build() {
    Column() {
      CommonHeader()
      Button('下载文件')
        .onClick(async () => {
          //判断文件是否存在
          let applicationContext = this.context.getApplicationContext();
          const targetPath = `${applicationContext.filesDir}/app/hahaha9.ppt`;
          // const targetPath = `${applicationContext.filesDir}/app/hahaha1.apk`;
          let fileExists = FileUtils.fileExists(targetPath)
          if(fileExists){
            const uri = 'file://' + getContext().applicationInfo.name + targetPath;
            //也可以使用下面的方式 fileUri.getUriFromPath(targetPath) 来获取 uri
            // let uri = fileUri.getUriFromPath(targetPath) ?? ''
            const uniformDataType = SystemShareUtils.getUniformDataType(FileUtils.getFileExtention(this.shareFilePath))
            SystemShareUtils.share(this.getUIContext(), uri,uniformDataType)

            return
          }
          //不存在先下载文件
          // let downloadSuccess = await this.downloadFile("https://cos3.pgyer.com/b71562f81505c3e24017e4db012961d2.apk?sign=1eff388777dfecda13a78516ab2ed6e4&sign2=35deeae6367753036b882fd4f91649db&t=1757418942&response-content-disposition=attachment%3Bfilename%3D%22%E9%85%92%E9%97%AA%E9%97%AA_1.2.3.apk%22")
          let downloadSuccess = await this.downloadFile("http://wkbjcloudbos.bdimg.com/v1/wenku10//77207907140c7d2855aaf8cec64e85c2?responseContentDisposition=attachment%3B%20filename%3D%22%25E5%2585%258D%25E8%25B4%25B9ppt%25E6%25A8%25A1%25E6%259D%25BF.ppt%22%3B%20filename%2A%3Dutf-8%27%27%25E5%2585%258D%25E8%25B4%25B9ppt%25E6%25A8%25A1%25E6%259D%25BF.ppt&responseContentType=application%2Foctet-stream&responseCacheControl=no-cache&authorization=bce-auth-v1%2Ffa1126e91489401fa7cc85045ce7179e%2F2025-09-23T08%3A18%3A53Z%2F3600%2Fhost%2F5277d230bc98c5b32a709fcb5adb236dbe8c5c2414afd26ab87df0d8c673a6db&token=eyJ0eXAiOiJKSVQiLCJ2ZXIiOiIxLjAiLCJhbGciOiJIUzI1NiIsImV4cCI6MTc1ODYxOTEzMywidXJpIjp0cnVlLCJwYXJhbXMiOlsicmVzcG9uc2VDb250ZW50RGlzcG9zaXRpb24iLCJyZXNwb25zZUNvbnRlbnRUeXBlIiwicmVzcG9uc2VDYWNoZUNvbnRyb2wiXX0%3D.Y6EzgJWSEUqH%2BPg4YGAjtNwTXDDjDhw%2Bg%2FX%2FW%2B6uFEI%3D.1758619133")
          if(downloadSuccess){
            const uri = 'file://' + getContext().applicationInfo.name + this.shareFilePath;
            //也可以使用下面的方式 fileUri.getUriFromPath(targetPath) 来获取 uri
            // let uri = fileUri.getUriFromPath(targetPath) ?? ''
            const uniformDataType = SystemShareUtils.getUniformDataType(FileUtils.getFileExtention(this.shareFilePath))
            SystemShareUtils.share(this.getUIContext(), uri,uniformDataType)
          }
        })
      Text(`当前下载进度为：${this.progress}`)
    }
    .height('100%')
    .width('100%')
  }

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
}