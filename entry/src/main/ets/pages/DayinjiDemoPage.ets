import fileUri from '@ohos.file.fileuri'
import { filePreview } from '@kit.PreviewKit'
import { BusinessError } from '@kit.BasicServicesKit'
import LocalFileSelectUtils, { FileSelectLocalFileModel } from '../common/utils/LocalFileSelectUtils'
import { CommonHeader } from '../common/common_header';
import { common } from '@kit.AbilityKit';
import FileUtils from '../common/FileUtils';

/**
 * 测试打印机功能
 */
@Entry
@Component
struct DayinjiDemoPage {


  //文件预览功能，使用的是Preview Kit：https://developer.huawei.com/consumer/cn/doc/harmonyos-references/preview-api
  //Media Library Kit(媒体文件管理服务)提供了管理相册和媒体文件的能力，包括照片和视频，帮助应用快速构建图片视频展示和播放能力。
  build() {
    Column(){
      CommonHeader()

    }
  }

  //连接打印机
  // connectPrint(info:PrinterInfo)
}

interface PrintFileModel {
  fileName: string,
  printNum: number,
  colorEnable: boolean,
  path: string,
  type: string
}