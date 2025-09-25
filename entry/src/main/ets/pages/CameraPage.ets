/**
 * 拍照
 */
// import { Permissions } from '@ohos.abilityAccessCtrl';
// import { CommonHeader } from '../common/common_header'
// import CarameUtils from '../common/utils/CarameUtils';
// import { common } from '@kit.AbilityKit';
// import { HMRouter } from '@hadss/hmrouter';
// import { NavigationConstants } from '../common/constants/NavigationConstants';
// import { BusinessError } from '@kit.BasicServicesKit';
// import { camera, cameraPicker } from '@kit.CameraKit';

// @HMRouter({ pageUrl: NavigationConstants.CAMERA_PAGE })
// @Component
// export struct CameraPage {
//   //拍照的权限
//   private permissions: Array<Permissions> = ['ohos.permission.CAMERA'];
//   private context = getContext(this) as common.UIAbilityContext
//
//   build() {
//     Column() {
//       CommonHeader({ title: '拍照' })
//       Button('获取权限')
//         .onClick(() => {
//           CarameUtils.checkPermissions(this.context, this.permissions)
//         })
//
//       Button('拍照')
//         .onClick(async () => {
//           //调用系统的相机cameraPicker，不需要申请权限
//           let result = await this.camera()
//           console.log(`this result is ${result}`)
//         })
//     }
//     .height('100%')
//   }
//
//   async camera(options?: CameraOptions): Promise<string> {
//     try {
//       if (!options) {
//         options = new CameraOptions();
//       }
//       if (!options.mediaTypes || options.mediaTypes.length == 0) {
//         options.mediaTypes = [cameraPicker.PickerMediaType.PHOTO, cameraPicker.PickerMediaType.VIDEO];
//       }
//       let pickerProfile: cameraPicker.PickerProfile = {
//         cameraPosition: options.cameraPosition ? options.cameraPosition : camera.CameraPosition.CAMERA_POSITION_BACK,
//         videoDuration: options.videoDuration,
//         saveUri: options.saveUri //如果未配置该项，拍摄的照片和视频默认存入媒体库中，如果不想将照片和视频存入媒体库，请自行配置应用沙箱内的文件路径。
//       };
//
//       let context = getContext() as common.Context;
//       let pickerResult: cameraPicker.PickerResult = await cameraPicker.pick(context,
//         options.mediaTypes, pickerProfile);
//       if (pickerResult && pickerResult.resultUri) {
//         return pickerResult.resultUri;
//       }
//     } catch (err) {
//       let error = err as BusinessError;
//       console.info(`-camera-异常 ~ code: ${error.code} -·- message: ${error.message}`);
//     }
//     return "";
//   }
// }
//
// export class CameraOptions {
//   mediaTypes: Array<cameraPicker.PickerMediaType> =
//     [cameraPicker.PickerMediaType.PHOTO, cameraPicker.PickerMediaType.VIDEO]; // 媒体类型。
//   cameraPosition: camera.CameraPosition = camera.CameraPosition.CAMERA_POSITION_BACK; // 相机的位置。
//   saveUri?: string; // 保存配置信息的uri。
//   videoDuration?: number; // 录制的最大时长。
// }

import { HMRouter } from '@hadss/hmrouter';
import { camera, cameraPicker as picker } from '@kit.CameraKit';
import { fileIo, fileUri } from '@kit.CoreFileKit';
import { NavigationConstants } from '../common/constants/NavigationConstants';

/**
 * Camera Kit
 * 使用系统相机拍照和录像
 * 可调用CameraPicker拍摄照片或录制视频，无需申请相机权限。
 * 注意：如果是开发自定义相机时，需要申请拍照和录像的权限，申请拍照的权限可以使用：
 * CarameUtils.checkPermissions(this.context, this.permissions)
 */
@HMRouter({ pageUrl: NavigationConstants.CAMERA_PAGE })
@Component
export struct CameraPage {
  @State imgSrc: string = '';
  @State videoSrc: string = '';
  createPickerProfile(context: Context): picker.PickerProfile {
    let pathDir = context.filesDir;
    let fileName = `${new Date().getTime()}`;
    let filePath = pathDir + `/${fileName}.tmp`;
    fileIo.createRandomAccessFileSync(filePath, fileIo.OpenMode.CREATE);

    let uri = fileUri.getUriFromPath(filePath);
    let pickerProfile: picker.PickerProfile = {
      cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK,
      saveUri: uri //如果未配置该项，拍摄的照片和视频默认存入媒体库中，如果不想将照片和视频存入媒体库，请自行配置应用沙箱内的文件路径。
    };
    return pickerProfile;
  }

  async getPickerResult(context: Context, pickerProfile: picker.PickerProfile): Promise<picker.PickerResult> {
    // 调用picker方法拉起系统相机，获取拍摄的图片或视频。
    let result: picker.PickerResult =
      await picker.pick(context, [picker.PickerMediaType.PHOTO, picker.PickerMediaType.VIDEO],
        pickerProfile);
    console.info(`picker resultCode: ${result.resultCode},resultUri: ${result.resultUri},mediaType: ${result.mediaType}`);
    return result;
  }

  getContext(): Context | undefined {
    let uiContext: UIContext = this.getUIContext();
    let context: Context | undefined = uiContext.getHostContext();
    return context;
  }

  build() {
    RelativeContainer() {
      Column() {
        Image(this.imgSrc).width(200).height(200).backgroundColor(Color.Black).margin(5);
        Video({ src: this.videoSrc}).width(200).height(200).autoPlay(true);
        Button("Test Picker Photo&Video").fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(async () => {
            let context = this.getContext();
            if (context === undefined) {
              return;
            }
            let pickerProfile = this.createPickerProfile(context);
            let result = await this.getPickerResult(context, pickerProfile);
            if (result.resultCode == 0) {
              if (result.mediaType === picker.PickerMediaType.PHOTO) {
                this.imgSrc = result.resultUri;
              } else {
                this.videoSrc = result.resultUri;
              }
            }
          }).margin(5);

      }.alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      });
    }
    .height('100%')
    .width('100%')
  }
}