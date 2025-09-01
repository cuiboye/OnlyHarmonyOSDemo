import axios from '@ohos/axios';
import { CommonHeader } from '../common/common_header'
import FileUtils from '../common/FileUtils';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct DownloadFilePage {
  context = getContext(this) as common.UIAbilityContext
  @State progress: number = 0

  build() {
    Column() {
      CommonHeader()
      Button('下载文件')
        .onClick(() => {
          this.downloadFile("")
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