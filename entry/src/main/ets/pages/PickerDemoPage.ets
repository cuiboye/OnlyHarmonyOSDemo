// xxx.ets
import {
  PhotoPickerComponent,
  PickerController,
  PickerOptions,
  DataType,
  BaseItemInfo,
  ItemInfo,
  PhotoBrowserInfo,
  ItemType,
  ClickType,
  MaxCountType,
  PhotoBrowserRange,
  PhotoBrowserUIElement,
  ItemsDeletedCallback,
  ExceedMaxSelectedCallback,
  CurrentAlbumDeletedCallback,
  videoPlayStateChangedCallback,
  VideoPlayerState
} from '@ohos.file.PhotoPickerComponent';
import { dataSharePredicates } from '@kit.ArkData';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { common } from '@kit.AbilityKit';
import { HMRouter } from '@hadss/hmrouter';
import { NavigationConstants } from '../common/constants/NavigationConstants';

/**
 * 相册操作Demo
 */
@HMRouter({ pageUrl: NavigationConstants.PICKER_DEMO_PAGE })
@Component
export struct PickerDemoPage {
  pickerOptions: PickerOptions = new PickerOptions();
  @State pickerController: PickerController = new PickerController();
  @State selectUris: string[] = [];
  @State currentUri: string = '';
  @State isBrowserShow: boolean = false;
  private selectedItemsDeletedCallback: ItemsDeletedCallback =
    (baseItemInfos: Array<BaseItemInfo>) => this.onSelectedItemsDeleted(baseItemInfos);
  private exceedMaxSelectedCallback: ExceedMaxSelectedCallback =
    (exceedMaxCountType: MaxCountType) => this.onExceedMaxSelected(exceedMaxCountType);
  private currentAlbumDeletedCallback: CurrentAlbumDeletedCallback = () => this.onCurrentAlbumDeleted();
  private videoPlayStateChangedCallback: videoPlayStateChangedCallback =
    (state: VideoPlayerState) => this.videoPlayStateChanged(state);
  private thumbnail: PixelMap[] = [];
  private assets: photoAccessHelper.PhotoAsset[] = [];

  aboutToAppear() {
    this.pickerOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
    this.pickerOptions.maxSelectNumber = 5;
    this.pickerOptions.isSearchSupported = false;
    this.pickerOptions.isPhotoTakingSupported = false;
    this.pickerOptions.photoBrowserCheckboxPosition = [0.5, 0.5];
    // 其他属性.....
  }

  private onSelect(uri: string): void {
    // 添加。
    if (uri) {
      this.selectUris.push(uri);
    }
  }

  private onDeselect(uri: string): void {
    // 移除。
    if (uri) {
      this.selectUris = this.selectUris.filter((item: string) => {
        return item != uri;
      })
    }
  }

  private onItemClicked(itemInfo: ItemInfo, clickType: ClickType): boolean {
    if (!itemInfo) {
      return false;
    }
    let type: ItemType | undefined = itemInfo.itemType;
    let uri: string | undefined = itemInfo.uri;
    if (type === ItemType.CAMERA) {
      // 点击相机item。
      return true; // 返回true则拉起系统相机，若应用需要自行处理则返回false。
    } else {
      if (clickType === ClickType.SELECTED) {
        // 应用做自己的业务处理（注：非长耗时操作，例如opensync大文件）。
        if (uri) {
          this.selectUris.push(uri);
          this.pickerOptions.preselectedUris = [...this.selectUris];
        }
        return true; // 返回true则勾选，否则不响应勾选。
      } else {
        if (uri) {
          this.selectUris = this.selectUris.filter((item: string) => {
            return item != uri;
          });
          this.pickerOptions.preselectedUris = [...this.selectUris];
        }
      }
      return true;
    }
  }

  private onEnterPhotoBrowser(photoBrowserInfo: PhotoBrowserInfo): boolean {
    // 进入大图的回调。
    this.isBrowserShow = true;
    return true;
  }

  private onExitPhotoBrowser(photoBrowserInfo: PhotoBrowserInfo): boolean {
    // 退出大图的回调。
    this.isBrowserShow = false;
    return true;
  }

  private onPickerControllerReady(): void {
    // 接收到该回调后，便可通过pickerController相关接口向picker发送数据，在此之前不生效。
    let elements: number[] = [PhotoBrowserUIElement.BACK_BUTTON];
    this.pickerController.setPhotoBrowserUIElementVisibility(elements, false); // 设置大图页不显示返回按钮。
  }

  private onPhotoBrowserChanged(browserItemInfo: BaseItemInfo): boolean {
    // 大图左右滑动的回调。
    this.currentUri = browserItemInfo.uri ?? '';
    return true;
  }

  private onSelectedItemsDeleted(baseItemInfos: Array<BaseItemInfo>): void {
    // 已勾选图片被删除时的回调。
  }

  private onExceedMaxSelected(exceedMaxCountType: MaxCountType): void {
    // 超过最大选择数量再次点击时的回调。
  }

  private onCurrentAlbumDeleted(): void {
    // 当前相册被删除时的回调。
  }

  private videoPlayStateChanged(state: VideoPlayerState): void {
    // 当视频播放状态变化时回调。
  }
  build() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center
    }) {
      Column() {
        if (this.isBrowserShow) {
          // 这里模拟应用自己的大图返回按钮。
          Row() {
            Button("退出大图").width('33%').height('8%').onClick(() => {
              this.pickerController.exitPhotoBrowser();
            })
          }.margin({ bottom: 20 })
        }
        //PhotoPicker组件
        PhotoPickerComponent({
          pickerOptions: this.pickerOptions,
          // onSelect: (uri: string): void => this.onSelect(uri),
          // onDeselect: (uri: string): void => this.onDeselect(uri),
          onItemClicked: (itemInfo: ItemInfo, clickType: ClickType): boolean => this.onItemClicked(itemInfo,
            clickType), // 该接口可替代上面两个接口。
          onEnterPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean => this.onEnterPhotoBrowser(photoBrowserInfo),
          onExitPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean => this.onExitPhotoBrowser(photoBrowserInfo),
          onPickerControllerReady: (): void => this.onPickerControllerReady(),
          onPhotoBrowserChanged: (browserItemInfo: BaseItemInfo): boolean => this.onPhotoBrowserChanged(browserItemInfo),
          onSelectedItemsDeleted: this.selectedItemsDeletedCallback,
          onExceedMaxSelected: this.exceedMaxSelectedCallback,
          onCurrentAlbumDeleted: this.currentAlbumDeletedCallback,
          onVideoPlayStateChanged: this.videoPlayStateChangedCallback,
          pickerController: this.pickerController,
        }).height('60%').width('100%')

        // 这里模拟应用侧底部的选择栏。
        if (this.isBrowserShow) {
          Row() {
            ForEach(this.assets, async (asset: photoAccessHelper.PhotoAsset, index) => {
              if (asset.uri === this.currentUri) {
                Image(this.thumbnail[index])
                  .height('10%')
                  .width('10%')
                  .onClick(() => {
                  })
                  .borderWidth(1)
                  .borderColor('red')
              } else {
                Image(this.thumbnail[index]).height('10%').width('10%').onClick(() => {
                  this.pickerController.setData(DataType.SET_SELECTED_URIS, this.selectUris);
                  this.pickerController.setPhotoBrowserItem(asset.uri, PhotoBrowserRange.ALL);
                })
              }
            }, (uri: string) => JSON.stringify(uri))
          }
        } else {
          Button('预览').width('33%').height('5%').onClick(async () => {
            if (this.selectUris.length > 0) {
              this.thumbnail = [];
              this.assets = [];
              for (let selectUri of this.selectUris) {
                let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
                predicates.equalTo(photoAccessHelper.PhotoKeys.URI, selectUri);
                let fetchOptions: photoAccessHelper.FetchOptions = {
                  fetchColumns: [],
                  predicates: predicates
                };
                let context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
                //photoAccessHelper.getPhotoAccessHelper：获取相册管理模块的实例，用于访问和修改相册中的媒体文件。
                let photoHelper = photoAccessHelper.getPhotoAccessHelper(context);
                let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> =
                  await photoHelper.getAssets(fetchOptions);
                let asset = await fetchResult.getFirstObject()
                this.assets.push(asset);
                this.thumbnail.push(await asset.getThumbnail())
              }
              this.pickerController.setPhotoBrowserItem(this.selectUris[0], PhotoBrowserRange.SELECTED_ONLY);
            }
          })
        }
      }
    }
  }
}