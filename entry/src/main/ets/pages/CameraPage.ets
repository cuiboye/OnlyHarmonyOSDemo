/**
 * 拍照
 */
import { Permissions } from '@ohos.abilityAccessCtrl';
import image from '@ohos.multimedia.image';
import { CommonHeader } from '../common/common_header'
import CarameUtils from '../common/utils/CarameUtils';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct CameraPage {
  //拍照的权限
  private permissions: Array<Permissions> = ['ohos.permission.CAMERA'];
  private  context = getContext(this) as common.UIAbilityContext

  build() {
    Column() {
      CommonHeader({title:'拍照'})
      Button('拍照')
        .onClick(()=>{
          CarameUtils.checkPermissions(this.context,this.permissions)

          //权限允许的情况下需要先获取surfaceId
          let receiver: image.ImageReceiver = image.createImageReceiver(8192, 8, image.ImageFormat.JPEG, 8);
          receiver.getReceivingSurfaceId().then((id: string) => {
            //surface id 用于拍照
            console.info(`Succeeded in getting the ReceivingSurfaceId. id:${id}`);
          })
        })
    }
    .height('100%')
  }
}