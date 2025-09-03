export interface TabContInterface {
  callback:(func: (tag:boolean, isScroller: boolean) => void) => void
  webUrl:string
}