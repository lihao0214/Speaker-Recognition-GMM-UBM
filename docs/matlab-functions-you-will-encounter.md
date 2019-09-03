# Matlab Functions You Will Encounter

![](https://img.shields.io/badge/language-matlab-yellow)


## Content

- [Functions](#functions)
- [Trickes](#tricks)


## Functions

- [nargin](#nargin)
- 



## nargin

nargin是用来判断输入变量个数的函数，这样就可以针对不同的情况执行不同的功能。通常可以用他来设定一些默认值，如下面的函数。

```matlab
function y = nargin_test(a,b)
    if nargin==0
        a=1;b=1;
    elseif nargin==1
        b=1;
    end
    y=a+b;
end
```

在调用此函数时，如果写成y=nargin_test()，则输出y=2；如果写成y=nargin_test(3)，则输出y=4；如果写成y=nargin_test(4，5)，则输出y=9。


## Tricks

- [Compare Variation](#compare-variation)
- [Compare Variables' Details](#compare-variables-details)
- 


## Compare Variation

```matlab
figure
for i = 1:39
	plot(tmpdata(i,:), 'b.');
	hold on;
	plot(tmpdata2(i, :), 'r.');
	plot(tmphtk(i,:), 'g+');
	pause(2)
	clf('reset')
end
```
## Compare Variables' Details

```matlab
load('01-Ziyu-matlab.mat')
load('01-Ziyu-matlab.mat', 'data')
ziyu_original = data
wavfile='D:\Project\Speaker-Recognition\timit_wav16000\TEST\DR1\FAKS0\SA1.WAV'
data = read_feature(wavfile)
ziyu_remove = data
load('02-HKT-ToolKit.mat')
htk_original = data
```



