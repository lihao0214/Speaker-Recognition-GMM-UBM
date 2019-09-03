# Matlab Functions You Will Encounter

![](https://img.shields.io/badge/language-matlab-yellow)


## Content

- [Functions](#functions)
- [Trickes](#tricks)


## Functions

- [nargin](#nargin)
- [nargout](#nargout)
- [varargin](#varargin)
- [varargout](#varargout)
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

## nargout

`nargout` 针对当前正在执行的函数，返回该函数调用中指定的函数输出参数的数目。该语法仅可在函数体内使用。

```matlab
function [s,varargout] = mysize(x)
    % 调用nargout命令取得调用函数时返回参数的个数
    out1 = nargout
    % 确定varargout中元素个数
    nout = max(out1,1) - 1
    % 将输入数组的行数和列数组成的数组赋值给输出参数s
    s = size(x);
    % 分别将输入数组的行数和列数保存到varargout中
    for k = 1:nout
        varargout(k) = {s(k)}
    end
end
```

```matlab
运行
[s,rows,cols]=mysize([1 2 3; 3 4 5])
s = 2 3 % s(1) = 2; s(2) = 3
rows = 2 % rows = s(1) = 2
cols = 3 % cols = s(2) = 3
% out1 = 3 []里是返回值，一共有3个返回值s,rows,cols
% nout = max(3,1)-1 = 2 代表varargout中的返回值的个数
% varargout(1) = s(1) s(1)是数组x的rows,所以varargout(1)=数组x的rows大小
% varargout(2) = s(2) s(2)是数组x的cols,所以varargout(2)=数组x的cols大小
```

## varargin

varargin,表示用在一个函数中，输入参数不确定的情况。

```matlab
function g = add(a,b,varargin)
    if nargin == 2
        g = a + b;
    elseif nargin == 3
        g = a + b + varargin{1}; 
    end
end
```

如果运行`g=add(1,2,100)`，此时`varargin{1}`指的就是100。

## varargout

varargout就是在函数实现过程中，将产生的结果赋给varargout{1},varargout{2}等。

```matlab
function varargout = add(a,b,varargin)
    if nargin == 2
        varargout{1} = a + b;
    elseif nargin == 3
        varargout{1} = a + b;
        varargout{2} = a + b - varargin{1};
    end
end
```

```matlab
运行
g = add(1,2) % g = 3
[g1,g2] = add(1,2,3) % g1 = 3 ; g2 = 0
```



## Tricks

- [Compare Variation In Figure](#compare-variation-in-figure)
- [Compare Variation In Number](#compare-variation-in-number)
- [Compare Variables' Details](#compare-variables-details)
- [Funtion Comments](#function-comments)


## Compare Variation In Figure

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
## Compare Variation In Number

```matlab
sum(sum(abs(tmpdata - tmpdata2(:,1:378))))/(39*378)
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

## Function Comments

```matlab
function err_code = ASV_enroll(wavfile, vpfile, mpfile)
% Author : 
% Date : 28 Nov, 2017
%
% Usage :
% err_code = ASV_enroll(wavfile, vpfile, modelfile)
%   wavfile - wav file for enrolment (.wav), sampling frequency = 16Hz
%   vpfile - generated voiceprint file (.mat) 
%   mpfile - model parameters file (.mat)
%   err_code - error code
%
% Example:
%   octave --eval 'ASV_enroll("./test/thomas1.wav","./test/thomas_vp.mat","./mp.mat")'
```

