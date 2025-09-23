import { CommonHeader } from '../common/common_header';
import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import { DataList, OpenCustomDialogListEntity } from '../entity/OpenCustomDialogListEntity';
import { CollectionMoveFileParams, moveFileBuilder, OnMoveListener } from '../views/OpenCustomDialogWithListView';
import { ComponentContent, promptAction } from '@kit.ArkUI';
import { OpenCustomDialogUtils } from '../common/utils/OpenCustomDialogUtils';
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { NavigationConstants } from '../common/constants/NavigationConstants';

/**
 * 1）openCustomDialog中展示List
 * 2）点击物理返回键使openCustomDialog消失并同时返回上一个页面
 * 3）使List定位到某一个index位置上
 */
@HMRouter({ pageUrl: NavigationConstants.OPENCUSTOMDIALOGWITHLIST_PAGE })
@Component
export struct OpenCustomDialogWithListPage {
  @State folderInfoList: DataList[] = []
  private ctx: UIContext = this.getUIContext();
  @State mutilFileMoveOneFolder:boolean = false//true：单选  false：多选
  moveFileContentNode?: ComponentContent<Object>

  //传给openCustomDialog的回调
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
      Button(`切换成${this.mutilFileMoveOneFolder?'多选':'单选'}`)
        .onClick(()=>{
          this.mutilFileMoveOneFolder = !this.mutilFileMoveOneFolder
        })
      Button('打开弹框')
        .onClick(async () => {

          this.folderInfoList = await this.getDialogListData()
          if (this.mutilFileMoveOneFolder) {//单选
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

    let response:Uint8Array
    if(this.mutilFileMoveOneFolder){
      response = await rm.getRawFileContent("opencustomdialog_list_single_entity.json")//单选
    }else {
      response = await rm.getRawFileContent("opencustomdialog_list_entity.json")//多选
    }
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
          //不加下面这两句的话，按物理返回键只会使OpenCustomDialog消失，如果想让OpenCustomDialog消失同时退出当前页面的话需要如下处理：
          OpenCustomDialogUtils.closeDialog(contentNode)
          HMRouterMgr.pop();
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