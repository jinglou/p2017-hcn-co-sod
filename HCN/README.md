## HCN

This code implements the proposed salient/co-salient object detection algorithm in the following paper:

 - **Jing Lou**, Fenglei Xu, Qingyuan Xia, Wankou Yang, Mingwu Ren, "Hierarchical Co-salient Object Detection via Color Names," in *Proceedings of the Asian Conference on Pattern Recognition* (**ACPR**), pp. 1-7, 2017.

 - Project page: [http://www.loujing.com/hcn-co-sod/](http://www.loujing.com/hcn-co-sod/)
 - The zipped file of the developed MATLAB code can be directly download: [HCN.zip](https://raw.githubusercontent.com/jinglou/p2017-hcn-co-sod/master/HCN.zip).

Copyright (C) 2017 [Jing Lou (楼竞)](http://www.loujing.com/)

Date: Sep 8, 2017


### Notes:

 1. This algorithm can be run in a row by the command:
 	```matlab
    >> HCN_Demo
	```

 2. This algorithm reads the input images from the folder `images` and generates two resultant folders:
	 1. `HCNs`     Saliency maps
	 2. `HCNco`    Co-saliency maps

 3. To regenerate the single-layer saliency maps of CNS [17] and RBD [26], please delete the subfolders `<L1>, <L2>, and <L3>` in the folders `<CNS> and <RBD>` and rerun `HCN_Demo`.
