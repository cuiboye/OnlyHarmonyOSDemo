
import { ShopCarModel } from '../page/model/ShopcarModel'
@Component
export struct ProductItem{
  @ObjectLink item:ShopCarModel
  @Link totalPrice:number

  //全部的数据，item改变后需要判断下productArray这个数组中item的选中状态
  @Prop productArray :ShopCarModel[]
  @Link selectedAll:boolean

  build(){
    Row(){
      Image(this.item.selected ? $r('app.media.selected_product') : $r('app.media.unselected_product'))
        .height(24)
        .width(24)
        .onClick(()=>{
          this.item.selected = !this.item.selected
          // console.log(`${JSON.stringify(this.productArray)}`)

          if(this.item.selected){
            this.totalPrice +=this.item.productPrice
          }else {
            this.totalPrice-=this.item.productPrice
          }
          //List.every：表示List中每一个都符合条件
          this.selectedAll = this.productArray.every((item:ShopCarModel)=>item.selected)
        })
      Text(`${this.item.productName}`).layoutWeight(1)
      Text(`${this.item.productPrice}`)
    }
    .height(80)
  }
}