/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { image } from '@kit.ImageKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import fs from '@ohos.file.fs';
//uiContext需要在EntryAbility中通过AppStorage存储下，否则在这个类中使用会有问题
const uiContext: UIContext | undefined = AppStorage.get('uiContext');

export class ImageUtils {
  // [Start get_snapshot_area]
  /**
   * Read the screenshot PixelMap object into the buffer area
   * @param {PixelMap} pixelMap - Screenshot PixelMap
   * @param {number[]} scrollYOffsets - Component scrolls an array of y-axis offsets
   * @param {number} listWidth - List component width
   * @param {number} listHeight - List component height
   * @returns {image.PositionArea} Picture buffer area
   */
  static async getSnapshotArea(pixelMap: PixelMap, scrollYOffsets: number[], listWidth: number,
    listHeight: number): Promise<image.PositionArea> {
    // Gets the number of bytes per line of image pixels.
    let stride = pixelMap.getBytesNumberPerRow();
    // Get the total number of bytes of image pixels.
    let bytesNumber = pixelMap.getPixelBytesNumber();
    let buffer: ArrayBuffer = new ArrayBuffer(bytesNumber);
    // 	Region size, read based on region.   PositionArea represents the data within the specified area of the image.
    let len = scrollYOffsets.length;

    // Except for the first screenshot, you don't need to crop it, and you need to crop the new parts
    if (scrollYOffsets.length >= 2) {


      // Realistic roll distance
      let realScrollHeight = scrollYOffsets[len-1] - scrollYOffsets[len-2];

      if (listHeight - realScrollHeight > 0) {
        let cropRegion: image.Region = {
          x: 0,
          y: uiContext?.vp2px(listHeight - realScrollHeight) || 0,//注意：uiContext需要在EntryAbility中通过AppStorage存储下
          size: {
            height: uiContext?.vp2px(realScrollHeight) || 0,
            width: uiContext?.vp2px(listWidth) || 0
          }
        };
        // Crop roll area
        try {
          await pixelMap.crop(cropRegion);
        }catch (e) {
          let err = e as BusinessError
          console.log(`e`)
        }
      }
    }

    let imgInfo = pixelMap.getImageInfoSync();
    // Region size, read based on region. PositionArea represents the data within the specified area of the image.
    let area: image.PositionArea = {
      pixels: buffer,
      offset: 0,
      stride: stride,
      region: {
        size: {
          width: imgInfo.size.width,
          height: imgInfo.size.height
        },
        x: 0,
        y: 0
      }
    }
    // Write data to a specified area
    pixelMap.readPixelsSync(area);
    return area;
  }

  // [End get_snapshot_area]

  // [Start merge_image]
  /**
   * Merge image area array into long screenshots
   * @param {image.PositionArea[]} areaArray - screenshot area
   * @param {number} lastOffsetY - The offset Y of the last screenshot
   * @param {number} listWidth - List component width
   * @param {number} listHeight - List component height
   * @returns {PixelMap} Long image after merge
   */
  static async mergeImage(areaArray: image.PositionArea[], lastOffsetY: number, listWidth: number,
    listHeight: number): Promise<PixelMap> {
    // Create a long screenshot PixelMap
    let opts: image.InitializationOptions = {
      editable: true,
      pixelFormat: 4,
      size: {
        width: uiContext?.vp2px(listWidth) || 0,
        height: uiContext?.vp2px(lastOffsetY + listHeight) || 0
      }
    };
    let longPixelMap = image.createPixelMapSync(opts);
    let imgPosition: number = 0;

    for (let i = 0; i < areaArray.length; i++) {
      let readArea = areaArray[i];
      let area: image.PositionArea = {
        pixels: readArea.pixels,
        offset: 0,
        stride: readArea.stride,
        region: {
          size: {
            width: readArea.region.size.width,
            height: readArea.region.size.height
          },
          x: 0,
          y: imgPosition
        }
      }
      imgPosition += readArea.region.size.height;
      longPixelMap.writePixelsSync(area);
    }
    return longPixelMap;
  }

  // [End merge_image]


  /**
   * 从相册选择图片
   * @param selectNumber 选择图片的最大数量
   */
  static async selectPicture(selectNumber: number): Promise<string[]> {
    // async selectPicture(selectNumber: number) {
    let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    // 设置要选择的媒体文件类型
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    // 设置选择文件最大数量
    photoSelectOptions.maxSelectNumber = selectNumber;
    let photoPicker = new photoAccessHelper.PhotoViewPicker();
    // await photoPicker.select(photoSelectOptions)
    let result: photoAccessHelper.PhotoSelectResult = await photoPicker.select(photoSelectOptions)
    let pathDir = getContext().cacheDir;

    console.info('PhotoViewPicker.select successfully, PhotoSelectResult uri: ' +
    JSON.stringify(result));

    let filePathList: string[] = []
    //select返回的uri权限是只读权限，注意不能在picker的回调里直接使用此uri进行打开文件操作，需要定义一个全局变量保存uri(如下面的photoUris)
    let photoUris: Array<string> = result.photoUris
    photoUris.forEach(photoUri => {
      let file = fs.openSync(photoUri)
      fs.copyFileSync(file.fd, pathDir + `/${file.name}`)
      let file2 = fs.openSync(pathDir + `/${file.name}`, fs.OpenMode.READ_WRITE)
      console.log(`file fd ==> ${file2.fd} | file path ==> ${file2.path}`)

      filePathList.push(file2.path)
    })
    return filePathList
  }

  /**
   * 图片压缩
   * @param pictureUri 图片uri
   * @param format 压缩后的目标格式，支持jpg、webp和png
   * @param quality 压缩质量，取值范围0-100，压缩质量数字越大，图片越大
   */
  static async compressPicture(pictureUri: string, format: string, quality: number): Promise<ArrayBuffer> {
    let file = fs.openSync(pictureUri, fs.OpenMode.READ_ONLY);
    let size = fs.statSync(file.fd).size;
    let buf = new ArrayBuffer(size);
    fs.readSync(file.fd, buf);
    fs.closeSync(file);
    let imageSource = image.createImageSource(buf);

    const imagePackerApi: image.ImagePacker = image.createImagePacker();
    let packOpts: image.PackingOption = { format: format, quality: quality };
    return await imagePackerApi.packing(imageSource, packOpts)
  }

  /**
   * 获取支持的图片或者视频格式
   * 参数为1表示获取支持的图片类型格式，参数为2表示获取支持的视频类型格式。
   */
  static async getSupportImageType(context: Context,type: number): Promise<string> {
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
    try {
      let outputText = '支持的类型为：\n';
      let imageFormat = await phAccessHelper.getSupportedPhotoFormats(type);
      let result = "";
      for (let i = 0; i < imageFormat.length; i++) {
        result += imageFormat[i];
        if (i !== imageFormat.length - 1) {
          result += ', ';
        }
      }
      outputText += result;
      console.info('getSupportedPhotoFormats success, data is ' + outputText);
      return outputText
    } catch (error) {
      console.error('getSupportedPhotoFormats failed, errCode is', error);
    }
    return ''
  }
}