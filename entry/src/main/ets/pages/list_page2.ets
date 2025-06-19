/**
 * List的分组列表
 */
@Entry
@Component
struct ListPage2 {
  contactsGroups: ContactsGroups[] = [
    {
      title: 'A',
      contacts: [
        new Contact('艾佳'),
        new Contact('安安'),
        new Contact('Angela'),
        new Contact('Angela'),
        new Contact('Angela'),
        new Contact('Angela'),
        new Contact('Angela'),
        new Contact('Angela'),
        new Contact('Angela'),
        new Contact('Angela'),
        new Contact('Angela'),
      ],
    },
    {
      title: 'B',
      contacts: [
        new Contact('白叶'),
        new Contact('伯明'),
        new Contact('伯明'),
        new Contact('伯明'),
        new Contact('伯明'),
        new Contact('伯明'),
        new Contact('伯明'),
        new Contact('伯明'),
        new Contact('伯明'),
        new Contact('伯明'),
      ],
    },
  ]

  build() {
    // 循环渲染ListItemGroup，contactsGroups为多个分组联系人contacts和标题title的数据集合
    Column() {
      List() {
        ForEach(this.contactsGroups, (item:ContactsGroups) => {
          //ListItemGroup:分组title，头部部件
          ListItemGroup({ header: this.itemHeader(item.title) }) {
            ForEach(item.contacts, (contact: Contact) => {
              ListItem() {
                Text(contact.name).height(100)

              }
              // },item=>contact.key)
            })
          }
        })
      }
      //List组件的sticky属性配合ListItemGroup组件使用，用于设置ListItemGroup中的头部组件是否呈现吸顶效果或者尾部组件是否呈现吸底效果。
      .sticky(StickyStyle.Header)
    }
  }

  @Builder itemHeader(title:string){
    Text(title)
      .fontSize(20)
      .backgroundColor('#fff1f3f5')
      .width('100%')
      .padding(5)
  }
}

class ContactsGroups{
  title?:string
  contacts?:Contact[]
}

class Contact{
  name:string

  constructor(name:string) {
    this.name = name
  }
}