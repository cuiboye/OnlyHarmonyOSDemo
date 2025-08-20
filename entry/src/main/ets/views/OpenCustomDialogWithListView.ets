import { DataList } from "../entity/OpenCustomDialogListEntity"

/**
 * openCustomDialog中展示List
 */

export interface OnMoveListener{
  onClickItem:(list:DataList[],index:number)=>void
  onClickItemWithMutil:(list:DataList[],index:number)=>void
  onFinishMoveFile:()=>void
}

interface IMoveFileParamsOptions {
  isEditing?:boolean
  folderList?: DataList[]
  onMoveListener?:OnMoveListener
  mutilFileMoveOneFolder?:boolean//多个文件
}

export class CollectionMoveFileParams {
  isEditing?:boolean
  folderList?: DataList[]
  onMoveListener?:OnMoveListener
  mutilFileMoveOneFolder?:boolean
  constructor(options: IMoveFileParamsOptions) {
    this.isEditing = options?.isEditing ?? false
    this.folderList = options?.folderList
    this.mutilFileMoveOneFolder = options?.mutilFileMoveOneFolder
    this.onMoveListener = options?.onMoveListener
  }
}

@Builder
export function moveFileBuilder(params:CollectionMoveFileParams) {
  MoveFileContent({
    folderInfoList: params.folderList ?? [],
    onMoveListener:params.onMoveListener,
    isEditing:params.isEditing??false,
    mutilFileMoveOneFolder:params.mutilFileMoveOneFolder??false,
  })
}

@Component
struct MoveFileContent{
  @Prop folderInfoList: DataList[] = []
  onMoveListener?:OnMoveListener
  @Prop isEditing?: boolean //新建文件夹的状态
  @Prop mutilFileMoveOneFolder?: boolean
  private scroller:Scroller = new Scroller()
  @StorageProp('navigationHeight') navigationHeight: number = 0
  build() {
    Column() {
      Row(){
        Text('选择数据')
          .padding({top:20,bottom:20,left:20})
          .fontSize(14)
          .padding({left:20})
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
        Text('添加数据')
          .fontWeight(FontWeight.Bold)
          .fontColor('#569C81')
          .fontSize(12)
          .padding({right:20,top:20,left:20,bottom:20})
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      if(this.folderInfoList && this.folderInfoList.length>0){
        Column(){
          List({scroller: this.scroller}) {
            ForEach(this.folderInfoList, (item: DataList,index:number,) => {
              ListItem() {
                Column(){
                  FolderItem({item:item})
                    .onClick(()=>{
                      if(this.mutilFileMoveOneFolder){//只能选择一个
                        if(!item.canClick){
                          console.log('不可点击')
                          return
                        }
                        this.onMoveListener?.onClickItemWithMutil(this.folderInfoList ?? [], index)
                      }else {//可以选择多个
                        this.onMoveListener?.onClickItem(this.folderInfoList??[],index)
                      }
                    })
                  //todo
                  Row().height(15)
                }
              }
            },(item: string) => JSON.stringify(item))
          }
          .onAppear(()=>{
            let firstSelectedIndex: number = 0
            let hasIndex: boolean = false
            this.folderInfoList.filter((item: DataList, index: number) => {
              if(!hasIndex){
                if (item.inFolder === '1') {
                  hasIndex = true
                  firstSelectedIndex = index
                }
              }
            })
            this.scroller.scrollToIndex(firstSelectedIndex)
          })
          .layoutWeight(1)
          .scrollBar(BarState.Off)
          .padding({left:20})
        }
        .height(300)
      }else {
        Column(){
          Image($r('app.media.default_image'))
            .height(70)
          Text('我是空布局')
            .fontSize(14)
            .margin({top:15})
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
        }
        .height(200)
        .justifyContent(FlexAlign.Center)
      }

      Column(){
        Text('完成')
          .width('100%')
          .fontSize(14)
          .padding({bottom:10,top:10})
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .textAlign(TextAlign.Center)
          .onClick(()=>{
            this.onMoveListener?.onFinishMoveFile()
          })
      }
    }
    .borderRadius({
      topLeft: 15,
      topRight: 15
    })
    .backgroundColor(Color.White)
    .padding({bottom: this.navigationHeight})
    .width('100%')
  }
}

@Component
struct FolderItem{
  item?:DataList
  build() {
    RelativeContainer() {
      Image($r('app.media.ic_folder'))
        .width(30)
        .id("iv_img")
        .alignRules({
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          center: { anchor: '__container__', align: VerticalAlign.Center }
        })
        .opacity(this.item?.canClick ? 1 : 0.3)
      Text(this.item?.folderName??'')
        .fontSize(14)
        .fontColor(this.item?.canClick ? '#1f1f1f' : '#E0E0E0')
        .layoutWeight(1)
        .margin({
          left: 14,
          top: 2,
          right: 30
        })
        .maxLines(1)// 单行显示
        .textOverflow({
          // 超出部分显示...
          overflow: TextOverflow.Ellipsis
        })
        .alignRules({
          left: { anchor: 'iv_img', align: HorizontalAlign.End },
          top: { anchor: 'iv_img', align: VerticalAlign.Top }
        })
        .id('tv_title')
      Text('100个')
        .fontSize(12)
        .fontColor(this.item?.canClick ? '#c1c1c1' : '#E0E0E0')
        .margin({
          left: 14
        })
        .alignRules({
          left: { anchor: 'iv_img', align: HorizontalAlign.End },
          top: { anchor: 'iv_img', align: VerticalAlign.Bottom }
        })
      Stack() {
        Image(this.item?.inFolder === '1' ? $r('app.media.selected_icon') : $r('app.media.unselect_icon'))
          .width(16)
          .height(16)
      }

      .id('selected_stack')
      .alignRules({
        right: { anchor: '__container__', align: HorizontalAlign.End },
        center: { anchor: '__container__', align: VerticalAlign.Center },
      })
      .padding({
        left: 15,
        right: 15,
        top: 15,
        bottom: 15
      })
    }.height(45)
    .width('100%')
  }
}
