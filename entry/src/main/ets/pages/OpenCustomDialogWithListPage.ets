import { CommonHeader } from '../common/common_header';
import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { DataEntity, DataList, OpenCustomDialogListEntity } from '../entity/OpenCustomDialogListEntity';

@Entry
@Component
struct OpenCustomDialogWithListPage {

  build() {
    Column() {
      CommonHeader()
      Button('打开弹框')
        .onClick(() => {
          const list = this.getDialogListData()
        })
    }
    .height('100%')
    .width('100%')
  }

  async getDialogListData(): Promise<DataList[]> {
    let context = getContext(this) as common.UIAbilityContext;
    //这里有个坑，resourceManager在预览模式不支持
    const rm = context.resourceManager;
    let response = await rm.getRawFileContent("index.json")
    let rawFile = response;
    let textdecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true })
    let retStr = textdecoder.decodeWithStream(rawFile, { stream: false });
    let result = JSON.parse(retStr) as OpenCustomDialogListEntity

    return result.data?.list ?? []
  }
}