## HCN

This code implements the HCN salient/co-salient object detection algorithm in the following paper:

 - **Jing Lou**, Fenglei Xu, Qingyuan Xia, Wankou Yang, Mingwu Ren, "Hierarchical Co-salient Object Detection via Color Names," In *Proceedings of the Asian Conference on Pattern Recognition* (**ACPR**), pp. 1-7, 2017.

 - Project page: [http://www.loujing.com/hcn-co-sod/](http://www.loujing.com/hcn-co-sod/)
 <!--- You can directly download the zipped file of the MATLAB code: [RPC.zip](https://raw.githubusercontent.com/jinglou/p2014-rpc-saliency/master/RPC.zip).-->

Copyright (C) 2017 [Jing Lou (楼竞)](http://www.loujing.com/)

Date: Sep 3, 2017


### Notes:

 1. This algorithm can be run in a row by the command:
 	```matlab
  >> Demo
	```

 2. This algorithm reads the input images from the folder `images`, and generates two resulting folders:
	 1. `SalMaps`    saliency maps (HCN<sub>s</sub>)
	 2. `CoSalMaps`  co-saliency maps (HCN<sub>co</sub>)
