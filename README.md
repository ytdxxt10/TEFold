#按数据进行展开，最多二级（三级目录）。

**自适应展开的情况，可能是一层目录（不展开）二级目录（展开一级）三级目录展开两级**

**写作原因：1.最近做的一个需求，感觉不错。2.git上没发现，大多数是一级展开，像qq那样，没发现二级展开的代码**
**可以得到的东西：自适应展开，二级目录的一级展开，三级目录的二级展开**

++ 思路：最难的无非是三级的情况，此时我们第一级用tableView的headerView自定义作为第一级，点击展开的tableView作为第二级数据显示，点击tableview的每一行，我们在cell里面用tableview作为他的第三级进行显示。  其它的如果是二级的话，tableview的headerView作为第一级，点击展开的tableview作为第二级。  如果是一级的情况，只需要把tableview的header作为第二级。 ++

#*如果对你有帮助，请加个star吧😊*

##*演示效果如下*

![image](https://github.com/ytdxxt10/TEFold/raw/master/fold.gif)