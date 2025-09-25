// xxx.ets
import {
  photoAccessHelper
} from '@kit.MediaLibraryKit';
import {
  RecentPhotoComponent, RecentPhotoOptions, PhotoSource, RecentPhotoInfo, RecentPhotoCheckResultCallback, RecentPhotoClickCallback, RecentPhotoCheckInfoCallback
} from '@ohos.file.RecentPhotoComponent';
import {
  BaseItemInfo
} from '@ohos.file.PhotoPickerComponent';
import { HMRouter } from '@hadss/hmrouter';
import { NavigationConstants } from '../common/constants/NavigationConstants';

/**
 * 最近图片组件 RecentPhotoComponent
 * 没有最近图片的数据
 */
@HMRouter({ pageUrl: NavigationConstants.RECENT_PHOTO_COMPONENT_PAGE })
@Component
export struct RecentPhotoCompomentPage {
  private recentPhotoOptions: RecentPhotoOptions = new RecentPhotoOptions();
  private recentPhotoCheckResultCallback: RecentPhotoCheckResultCallback = (recentPhotoExists: boolean) => this.onRecentPhotoCheckResult(recentPhotoExists);
  private recentPhotoClickCallback: RecentPhotoClickCallback = (recentPhotoInfo: BaseItemInfo): boolean => this.onRecentPhotoClick(recentPhotoInfo);
  private recentPhotoCheckInfoCallback: RecentPhotoCheckInfoCallback = (recentPhotoExists: boolean, info: RecentPhotoInfo) => this.onRecentPhotoCheckInfo(recentPhotoExists, info);

  aboutToAppear() {
    this.recentPhotoOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
    this.recentPhotoOptions.period = 30;
    this.recentPhotoOptions.photoSource = PhotoSource.ALL;
  }

  private onRecentPhotoCheckResult(recentPhotoExists: boolean): void {
    // 存在符合条件的照片或视频。
    if (recentPhotoExists) {
      console.info('The photo is exist.');
    }
  }

  private onRecentPhotoClick(recentPhotoInfo: BaseItemInfo): boolean {
    // 照片或视频返回。
    if (recentPhotoInfo) {
      console.info('The photo uri is ' + recentPhotoInfo.uri);
      return true;
    }
    return true;
  }

  private onRecentPhotoCheckInfo(recentPhotoExists: boolean, info: RecentPhotoInfo): void {
    // 是否存在符合条件的照片或视频，若存在则可以拿到该照片或视频的相关信息。
  }

  build() {
    Stack() {
      RecentPhotoComponent({
        recentPhotoOptions: this.recentPhotoOptions,
        onRecentPhotoCheckResult: this.recentPhotoCheckResultCallback,
        onRecentPhotoClick: this.recentPhotoClickCallback,
        onRecentPhotoCheckInfo: this.recentPhotoCheckInfoCallback,
      }).height('100%').width('100%')
    }.padding({top:30})
  }
}