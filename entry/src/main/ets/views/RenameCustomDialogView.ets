import { WenkuToast, WkCommonUtils } from 'wk_toolkitcomponent'

//我的收藏-新建/重命名文件夹的Dialog
@CustomDialog
export struct EditFolderDialogView {
  cancel?: () => void
  confirm?: (fileName:string) => void
  controller: CustomDialogController
  initTitle: ResourceStr = $r('app.string.create_collection_folder')
  //@Prop不能更新
  @Prop isRenameDialog: boolean
  @Prop initContent:  ResourceStr = $r('app.string.create_collection_folder')
  @State inputValue: ResourceStr = $r('app.string.create_collection_folder')
  private inputController: TextInputController = new TextInputController()
  @State text: string = ''
  @State showDeleteBtn: boolean = true

  aboutToAppear(): void {
    this.inputValue = this.initContent
  }

  build() {
    Column() {
      Column() {
        Row() {
          Text($r('app.string.cancel_create_folder'))
            .onClick(() => {
              if (this.controller != undefined) {
                this.controller.close()
                this.cancel?.()
              }
            })
            .fontSize(13)
            .fontColor($r('app.color.color_060606'))
            .padding({
              left: 13,
              right: 13,
              top: 20,
              bottom: 20
            })
          Text(this.isRenameDialog?$r('app.string.rename_folder'):$r('app.string.create_collection_folder'))
            .fontSize(15)
            .fontColor($r('app.color.color_060606'))
          Text($r('app.string.completed_create_folder'))
            .onClick(() => {
              if (this.controller != undefined) {
                if ((this.inputValue.toString() ?? '').trim() === '') {
                  WenkuToast.show('请输入文件夹名称')
                  return
                }
                this.controller.close()
                this.confirm?.(this.inputValue.toString() ?? '')
              }
            })
            .fontSize(13)
            .fontColor($r('app.color.color_4fac72'))
            .fontWeight(FontWeight.Bold)
            .padding({
              left: 13,
              right: 13,
              top: 20,
              bottom: 20
            })
        }
        .borderRadius({
          topLeft: 15,
          topRight: 15
        })
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .backgroundColor(Color.White)

        Row() {
          Stack() {
            Image($r('app.media.ic_personal_folder'))
              .height(30)
          }
          .alignSelf(ItemAlign.End)
          .margin({ left: 13, right: 13 })

          Column() {
            Row().height(1).width('100%').backgroundColor(Color.White)
            Row() {
              TextInput({
                placeholder: '',
                text: this.inputValue,
                controller: this.inputController
              })
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.color_1d2424'))
                .padding({ left: 5 })
                .onFocus(() => {
                  this.inputController.setTextSelection(0, this.inputValue.toString().length??0)
                })
                .onChange((value: string) => {
                  this.inputValue = value
                  if(this.inputValue){
                    this.showDeleteBtn = true
                  }else {
                    this.showDeleteBtn = false
                  }
                })
                .defaultFocus(true)
                .layoutWeight(1)
                .backgroundColor(Color.White)
              Stack() {
                Image($r('app.media.search_clear_img')).width(20)
              }
              .onClick(() => {
                this.inputValue = ''
                this.showDeleteBtn = false
              })
              .visibility(this.showDeleteBtn ? Visibility.Visible : Visibility.None)
              .padding({ left: 13, right: 13 })
            }

            Row().height(1).width('100%').backgroundColor('#08000000').margin({ right: 20 })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .layoutWeight(1)
        }
        .width('100%')
        .backgroundColor(Color.White)
        .padding({ top: 15 })
      }
      .width('100%')

      Row()
        .height(WkCommonUtils.bottomBarHeight)
        .backgroundColor(Color.White)
        .width('100%')
    }.width('100%')
  }
}