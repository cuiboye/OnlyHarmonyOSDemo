/**
 * openCustomDialog中的列表数据
 */
export class OpenCustomDialogListEntity {
  status?: StatusEntity
  data?: DataEntity
}

export interface StatusEntity {
  code: number
  msg: string
}

export class DataEntity {
  mydoc?: number
  list?: DataList[]
  total?: number
  collectionNum?: number
}

export class DataList {
  inFolder?: string //1:已选中 0:未选中
  canClick?: boolean = true  //是否可以点击
  folderName?: string
  docNum?: string
}