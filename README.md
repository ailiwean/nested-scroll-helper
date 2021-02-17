
 # Flutter嵌套PageView处理工具

google账号出问题暂时没法传到pub
### 效果
https://sm.ms/image/ALkGopHNK2M9Ttg


### 使用
外层PageView使用**NestPageHelperParent** 包裹并传入pageController，
内层ScrollView使用**NestPageHelperChild**包裹，  理论上可以多层包裹嵌套。

```
    return NestPageHelperParent(
        child: PageView.builder(
            itemCount: 5,
            controller: pageController,
            itemBuilder: (context, index) {
              //嵌套PageView
              if (index == 3)
                return NestPageHelperChild(
                    child: PageView.builder(
                        itemCount: 5,
                        itemBuilder: (_, index) {
                          return Center(
                            child: Text("内部" + index.toString()),
                          );
                        }));
              return Center(
                child: Text(index.toString()),
              );
            }),
        pageController: pageController);

```
