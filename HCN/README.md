## HCN

This code implements the proposed salient/co-salient object detection algorithm in the following paper:

 - **Jing Lou**, Fenglei Xu, Qingyuan Xia, Wankou Yang, Mingwu Ren, "Hierarchical Co-salient Object Detection via Color Names," in *Proceedings of the Asian Conference on Pattern Recognition* (**ACPR**), pp. 718-724, 2017. **(Spotlight)**

 - Project page: [http://www.loujing.com/hcn-co-sod/](http://www.loujing.com/hcn-co-sod/)
 - The zipped file of the developed MATLAB code can be directly downloaded: [HCN.zip](https://raw.githubusercontent.com/jinglou/p2017-hcn-co-sod/master/HCN.zip).

Copyright (C) 2017 [Jing Lou (楼竞)](http://www.loujing.com/)

Date: Nov 23, 2017


### Notes:

 1. This algorithm can be run in a row by the command:
 	```matlab
    >> HCN_Demo
	```

 2. This algorithm reads the input images from the folder `<images>` and generates two resultant folders:
	 1. `<HCNs>`     Saliency maps
	 2. `<HCNco>`    Co-saliency maps

 3. To regenerate the single-layer saliency maps of CNS [17] and RBD [26], please **DELETE** the subfolders `<L1>, <L2>, and <L3>` in the folders `<CNS> and <RBD>` and rerun `HCN_Demo`.

 4. We have noted that different versions of MATLAB have substantial influences on the edge detection results. In our experiments, both CNS, RBD, and HCN are all run in **MATLAB R2017a** (version 9.2).
