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
  inFolder?: string
  canClick?: boolean = true
  folderName?: string
  docNum?: string
}