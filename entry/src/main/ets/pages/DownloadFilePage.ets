import axios from '@ohos/axios';
import { CommonHeader } from '../common/common_header'
import FileUtils from '../common/FileUtils';
import { common } from '@kit.AbilityKit';
import { SystemShareUtils } from '../common/utils/SystemShareUtils';

@Entry
@Component
struct DownloadFilePage {
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
          const targetPath = `${applicationContext.filesDir}/app/wajiu.apk`;
          let fileExists = FileUtils.fileExists(targetPath)
          if(fileExists){
            const uri = 'file://' + getContext().applicationInfo.name + targetPath;
            const uniformDataType = SystemShareUtils.getUniformDataType(FileUtils.getFileExtention(this.shareFilePath))
            SystemShareUtils.share(this.getUIContext(), uri,uniformDataType)

            return
          }
          //不存在先下载文件
          let downloadSuccess = await this.downloadFile("https://cos3.pgyer.com/637012afb53cc81401afec0d9d24e596.apk?sign=320b6fd324ad1f1ad2e10bd09a76d2d7&sign2=35deeae6367753036b882fd4f91649db&t=1756711574&response-content-disposition=attachment%3Bfilename%3D%22%E6%8C%96%E9%85%92%E7%BD%91_3.81.5-debug.apk%22")
          if(downloadSuccess){
            const uri = 'file://' + getContext().applicationInfo.name + this.shareFilePath;

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
    const targetPath = `${applicationContext.filesDir}/app/wajiu.apk`;
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