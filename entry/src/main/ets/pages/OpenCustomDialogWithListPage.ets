import { CommonHeader } from '../common/common_header';
import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import { DataList, OpenCustomDialogListEntity } from '../entity/OpenCustomDialogListEntity';
import { CollectionMoveFileParams, moveFileBuilder, OnMoveListener } from '../views/OpenCustomDialogWithListView';
import { ComponentContent, promptAction } from '@kit.ArkUI';
import { OpenCustomDialogUtils } from '../common/utils/OpenCustomDialogUtils';
import { HMRouter } from '@hadss/hmrouter';
import { NavigationConstants } from '../common/constants/NavigationConstants';

/**
 * openCustomDialog中展示List
 */
@HMRouter({ pageUrl: NavigationConstants.OPENCUSTOMDIALOGWITHLIST_PAGE })
@Component
export struct OpenCustomDialogWithListPage {
  @State folderInfoList: DataList[] = []
  private ctx: UIContext = this.getUIContext();
  mutilFileMoveOneFolder:boolean = false//true：可以选择一个  false：可以选择多个
  moveFileContentNode?: ComponentContent<Object>

  onMoveListener: OnMoveListener = {
    onClickItem: (list: DataList[], index: number): void => {
      //选中/取消选中item，更新数据
      this.folderInfoList = [...list];
      if (this.folderInfoList[index].inFolder === '1') {
        this.folderInfoList[index].inFolder = '0';
      } else {
        this.folderInfoList[index].inFolder = '1';
      }
      this.moveFileContentNode?.update(new CollectionMoveFileParams({
        folderList: this.folderInfoList
      }));
    },
    onClickItemWithMutil: (list: DataList[], index: number): void => {
      //当可以选择多个文件夹的时候
      this.folderInfoList = [...list];
      if (this.folderInfoList[index].inFolder === '1') {
        this.folderInfoList[index].inFolder = '0';
      } else {
        this.folderInfoList[index].inFolder = '1';
      }
      //多文件移动到一个文件夹
      let hasSelectedFolder: boolean = this.folderInfoList.some(item => item.inFolder==='1')
      if(hasSelectedFolder){
        //如果已经有选中的可移动的文件夹
        this.folderInfoList.forEach((item: DataList, itemIndex: number) => {
          if (itemIndex === index) {
            this.folderInfoList[itemIndex].canClick = true
          } else {
            this.folderInfoList[itemIndex].canClick = false
          }
        })
      }else {
        //如果没有选中的数据
        this.folderInfoList.map(item=>item.canClick=true)
      }

      this.moveFileContentNode?.update(new CollectionMoveFileParams({
        folderList: this.folderInfoList,
        mutilFileMoveOneFolder: this.mutilFileMoveOneFolder
      }));
    },
    onFinishMoveFile: (): void => {

    }
  }

  build() {
    Column() {
      CommonHeader()
      Button('打开弹框')
        .onClick(async () => {

          this.folderInfoList = await this.getDialogListData()
          if (this.mutilFileMoveOneFolder) {
            //这个时候folderInfoList中只能有一个inFolder===‘1’的数据
            this.folderInfoList.forEach((item: DataList, index: number) => {
              if(item.inFolder === '1'){
                this.folderInfoList[index].canClick = true
              }else {
                this.folderInfoList[index].canClick = false
              }
            })
          }else {
            this.folderInfoList.map(item => item.canClick = true)
          }

          //moveFileContentNode需要在这里实例化，否则this.folderInfoList不能首次初始化数据
          this.moveFileContentNode =
            new ComponentContent(this.ctx, wrapBuilder(moveFileBuilder), new CollectionMoveFileParams({
              folderList: this.folderInfoList,
              onMoveListener: this.onMoveListener,
              mutilFileMoveOneFolder: this.mutilFileMoveOneFolder
            }))
          OpenCustomDialogUtils.setContext(this.ctx);
          OpenCustomDialogUtils.setContentNode(this.moveFileContentNode);
          OpenCustomDialogUtils.openDialog(this.moveFileContentNode,
            this.getMoveOptions(this.moveFileContentNode, this.folderInfoList))
        })
      Text(`当前选中了${this.getSelectedFolderListNumber()}条数据`)
    }
    .height('100%')
    .width('100%')
  }

  getSelectedFolderListNumber(): number {
    let selectedList: DataList[] = this.folderInfoList.filter(item => item.inFolder==='1')
    return selectedList.length
  }

  async getDialogListData(): Promise<DataList[]> {
    let context = getContext(this) as common.UIAbilityContext;
    //这里有个坑，resourceManager在预览模式不支持
    const rm = context.resourceManager;
    let response = await rm.getRawFileContent("opencustomdialog_list_entity.json")
    let rawFile = response;
    let textdecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true })
    let retStr = textdecoder.decodeWithStream(rawFile, { stream: false });
    let result = JSON.parse(retStr) as OpenCustomDialogListEntity

    return result.data?.list ?? []
  }

  getMoveOptions(contentNode: ComponentContent<Object>, list: DataList[]): promptAction.BaseDialogOptions {
    return {
      alignment: DialogAlignment.Bottom,
      offset: { dx: 0, dy: 0 },
      transition: TransitionEffect.opacity(0.99).animation({ duration: 200 }),
      onWillDismiss: (action) => {
        if (action.reason == DismissReason.PRESS_BACK) {
          OpenCustomDialogUtils.closeDialog(contentNode)
          // HMRouterMgr.pop();
        }
        animateTo({
          duration: 200,
          onFinish: () => {
            action.dismiss()
          }
        }, () => {
          // contentNode.update(new CollectionMoveFileParams({
          //   isEnd: true,
          //   folderList: list,
          //   isEditing: isCreatingFolder
          // }))
        })
      }
    }
  }
}