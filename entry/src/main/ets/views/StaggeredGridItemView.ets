import { CollectionCommunityItemEntity, Images } from "../entity/StaggeredGridEntity"

@Component
export struct StaggeredGridItemView {
  @Prop item: CollectionCommunityItemEntity
  @Prop verticalType: string
  @Prop tagName: string

  build() {
    if (this.item) {
      Column() {
        //PPT项
        if (this.item.type == 5) {
          Column() {
            Stack({ alignContent: Alignment.TopEnd }) {
              if (this.item.images && this.item.images.length > 0 && this.item.images[0] &&
              this.item.images[0].width && this.item.images[0].height) {
                Image(this.item.images![0].url)
                  .width('100%')
                  .aspectRatio(Number(this.item.images[0].width) / Number(this.item.images[0].height))
                  .borderRadius({ topLeft: 8, topRight: 8, })
                  .objectFit(ImageFit.Cover)
                  .alt($r('app.media.ic_community_placehold_horn'))
              } else {
                Image(this.item.images![0].url)
                  .width('100%')
                  .borderRadius({ topLeft: 8, topRight: 8, })
                  .objectFit(ImageFit.Cover)
                  .alt($r('app.media.ic_community_placehold_horn'))
              }

              if (this.item.images && this.item.images.length > 1) {
                Stack({ alignContent: Alignment.BottomStart }) {
                  if (this.item.images && this.item.images.length >= 5) {
                    Grid() {
                      ForEach(this.item.images.slice(1, 5), (imgItem: Images) => {
                        GridItem() {
                          Image(imgItem.url)
                            .width('100%')
                            .height('100%')
                            .objectFit(ImageFit.Cover)
                            .alt($r('app.media.ic_community_placehold_horn'))
                        }
                      })
                    }
                    .rowsTemplate('1fr 1fr')
                    .columnsTemplate('1fr 1fr')
                    .width('100%')
                    .height(96)
                  } else if (this.item.images && (this.item.images.length === 3 || this.item.images.length === 4)) {
                    Grid() {
                      ForEach(this.item.images.slice(1, 3), (imgItem: Images) => {
                        GridItem() {
                          Image(imgItem.url)
                            .width('100%')
                            .height('100%')
                            .objectFit(ImageFit.Cover)
                            .alt($r('app.media.ic_community_placehold_horn'))
                        }
                      })
                    }
                    .rowsTemplate('1fr')
                    .columnsTemplate('1fr 1fr')
                    .width('100%')
                    .height(48)
                  } else if (this.item.images && this.item.images.length === 2) {
                    Image(this.item.images[1].url)
                      .width('100%')
                      .height(48)
                      .objectFit(ImageFit.Cover)
                      .alt($r('app.media.ic_community_placehold_horn'))
                  }
                }
              }
            }
          }
        }

        //AI图片项
        if (this.item.type == 7) {
          Column() {
            Stack({ alignContent: Alignment.BottomStart }) {
              if (this.item.images && this.item.images.length > 0 && this.item.images[0] &&
              this.item.images[0].width && this.item.images[0].height) {
                if (Number(this.item.images[0].width) > Number(this.item.images[0].height)) {
                  // 横图处理
                  Image(this.item.images[0].url)
                    .borderRadius({ topLeft: 8, topRight: 8, })
                    .height(130)
                    .aspectRatio(16 / 9)
                    .width('100%')
                    .clip(true)
                    .alt($r('app.media.ic_community_placehold_horn'))
                } else if (Number(this.item.images[0].width) < Number(this.item.images[0].height)) {
                  // 竖图处理
                  if (Number(this.item.images[0].height) >= 220) {
                    Column() {
                      Image(this.item.images[0].url)
                        .width('100%')
                        .aspectRatio(9 / 16)
                        .height(220)
                        .align(Alignment.TopStart)
                        .clip(true)
                        .alt($r('app.media.ic_community_placehold_ver'))
                    }
                    .width('100%')
                    .height(220)
                    .clip(true)
                    .borderRadius({ topLeft: 8, topRight: 8, })
                  } else {
                    Image(this.item.images[0].url)
                      .borderRadius({ topLeft: 8, topRight: 8, })
                      .width('100%')
                      .alt($r('app.media.ic_community_placehold_ver'))
                  }
                } else if (Number(this.item.images[0].width) == Number(this.item.images[0].height)) {
                  Image(this.item.images[0].url)
                    .borderRadius({ topLeft: 8, topRight: 8, })
                    .width('100%')
                    .alt($r('app.media.ic_community_placehold_sq'))
                }
              }
            }
          }
        }
        //绘本项
        if (this.item.type == 6) {
          Column() {
            Stack({ alignContent: Alignment.TopEnd }) {
              Stack({ alignContent: Alignment.BottomStart }) {
                if (this.item.videos && this.item.videos[0] &&
                this.item.videos[0].width && this.item.videos[0].height) {
                  Image(this.item.videos![0].cover_url)
                    .borderRadius({ topLeft: 8, topRight: 8, })
                    .width('100%')
                    .aspectRatio(Number(this.item.videos![0].width) / Number(this.item.videos![0].height))
                    .alt($r('app.media.ic_community_placehold_horn'))
                    .objectFit(ImageFit.Cover)
                } else {
                  Image(this.item.videos![0].cover_url)
                    .borderRadius({ topLeft: 8, topRight: 8, })
                    .width('100%')
                    .alt($r('app.media.ic_community_placehold_horn'))
                    .objectFit(ImageFit.Cover)
                }
              }
            }
          }
        }
        //海报项
        if (this.item.type == 3) {
          Column() {
            Stack({ alignContent: Alignment.BottomStart }) {
              Column() {
                Image(this.item.images![0].url)
                  .width('100%')
                  .aspectRatio(9 / 16)
                  .height(220)
                  .align(Alignment.TopStart)
                  .clip(true)
                  .alt($r('app.media.ic_community_placehold_ver'))
              }
              .width('100%')
              .height(220)
              .clip(true)
              .borderRadius({ topLeft: 8, topRight: 8 })
            }
          }
        }
        //手抄报项
        if (this.item.type == 4) {
          Column() {
            Stack({ alignContent: Alignment.TopEnd }) {
              Image(this.item.images![0].url)
                .width('100%')
                .borderRadius({ topLeft: 8, topRight: 8, })
                .objectFit(ImageFit.Cover)
                .alt($r('app.media.ic_community_placehold_horn'))
            }

            Stack({ alignContent: Alignment.BottomStart }) {
              Image(this.item.images![1].url)
                .width('100%')
                .objectFit(ImageFit.Cover)
                .alt($r('app.media.ic_community_placehold_horn'))
            }
          }
        }
        Text(this.item.title)
          .fontSize(14)
          .lineHeight(22)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 6, left: 5, right: 5 })
      }
      .width('98%')
      .margin({
        left: 3,
        right: 6,
        top: 4,
        bottom: 0
      })
      .backgroundColor(Color.White)
      .borderRadius(8)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
    }
  }
}