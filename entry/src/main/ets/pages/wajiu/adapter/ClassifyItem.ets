@Component
export default struct ClassifyItem{
  classifyName:string = ''
  onClickItem = ()=>{}
  @Prop isSelected:boolean
  build(){
    if(this.classifyName){
      Text(`${this.classifyName}`)
        .fontColor(this.isSelected?$r('app.color.f56e1d'):$r('app.color.343434'))
        .fontSize(14)
        //点击item的时候执行onClickItem函数
        .onClick(this.onClickItem)
    }
  }
}