# Feature-Detection-using-CPSFS
Feature detection algorithm using central projection stereo focal stack, which is suitable for focused plenoptic camera.
# Installation
Run \3rdPart\toolbox\vl_setup.m to install the SIFT detector.

Run \CPSFSTool\AddToolboxPath.m  to install the toolbox.

# Data
Google Driver.

https://drive.google.com/drive/folders/1GVFZuAARlYVaTA2JkMLxjELWisoTk9GD?usp=sharing

Download the dataset and put it anywhere you want.
# Demo 
Change the dataset path in \Demo\DemoDetect.m(Line 2).

`MainPath         = 'The path where you put the dataset'; `

Run \Demo\DemoDetect.m.

## Citing
If you find our codes useful, please cite our paper.
```
@article{liu2020feature,
  title={Feature Detection of Focused Plenoptic Camera Based on Central Projection Stereo Focal Stack},
  author={Liu, Qingsong and Xie, Xiaofang and Zhang, Xuanzhe and Tian, Yu and Wang, Yan and Xu, Xiaojun},
  journal={Applied Sciences},
  volume={10},
  number={21},
  pages={7632},
  year={2020},
  publisher={Multidisciplinary Digital Publishing Institute}
}
```
