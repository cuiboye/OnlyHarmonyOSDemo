import { HMRouter } from '@hadss/hmrouter';
import { CommonHeader } from '../common/common_header';
import { NavigationConstants } from '../common/constants/NavigationConstants';
import { BusinessError } from '@kit.BasicServicesKit';

import fs from '@ohos.file.fs';
import picker from '@ohos.file.picker';
import { common } from '@kit.AbilityKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { image } from '@kit.ImageKit';
import { ImageUtils } from './longscreenshot/ImageUtils';

/**
 * 选择照片
 */
@HMRouter({ pageUrl: NavigationConstants.SELECT_PHOTO_PAGE })
@Component
export struct SelectPhotoPage {
  @State message: string = 'Hello World';

  build() {
    Column() {
      CommonHeader()
      Button('选择照片')
        .onClick(async () => {
          // this.selectPicture(5)
          let pictureList: string[] = await ImageUtils.selectPicture(5)
          console.log(JSON.stringify(`pictureList is ${pictureList}`));
        })
    }
    .height('100%')
    .width('100%')
  }

  async openCamera() {

  }
}