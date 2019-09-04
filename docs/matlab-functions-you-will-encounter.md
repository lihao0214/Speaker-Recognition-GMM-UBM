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
- [assert](#assert)
- [num2str](#num2str)
- [rand](#rand)
- [mean](#mean)
- [std](#std)
- [bsxfun](#bsxfun)



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

## assert

Generate error when condition is violated

**Syntax**：

- assert(expression)
- assert(expression, 'msgString')
- assert(expression, 'msgString', value1, value2, ...)
- assert(expression, 'msgIdent', 'msgString', value1, value2, ...)

**Description**：

- `assert(*expression*)` evaluates *expression* and, if it is `false`, generates an exception.

在matlab中assert函数用来判断一个expression是否成立，如不成立则报错'*msgString*'。

例如：

```matlab
assert(length(Y) == N, 'error: the number of labels does not match the number of instances!');  % 若Y的长度不为N，则输出后面这句错误提示。
```

注意'*msgString*'中还可嵌入指定值，如上面第三种方法。

Matlab也有错误报告函数 error 和 warning。由于要求对参数的保护，需要对输入参数或处理过程中的一些状态进行判断，判断程序能否/是否需要继续执行。在matlab中经常使用到这样的代码：

```matlab
if c<0
    error(['c = ' num2str(c) '<0, error!']);
end
```

虽然无伤大雅，可也不好看，如果借用assert函数，就可以写成：

```matlab
assert(c>=0, ['c = ' num2str(c) '<0 is impossible!']);
```

虽然系统要多执行一些（后面的参数必须先解释出来再执行assert函数），但在保证程序可读性和正确性方面功劳是很大的。当然，如果不想损失性能，直接写成：

```matlab
assert(c>=0);
```

## num2str

函数功能： 把数值转换成字符串， 转换后可以使用fprintf或disp函数进行输出。在matlab命令窗口中键入doc num2str或help num2str即可获得该函数的帮助信息。

**语法格式**：

- str = num2str(A)：把数组A中的数转换成字符串表示形式。
- str = num2str(A, precision)：把数组A转换成字符串形式表示，precision表示精度， 比如precision为3表示保留最多3位有效数字， 例如0.5345转换后为0.534,1.2345转换后为1.23。即从左边第一个不为0的数开始保留3个数值。
- str = num2str(A, format)：按format指定格式进行格式化转换，通常'%11.4g'是默认的。

**相关函数**：

- mat2str, int2str, str2num, sprintf, fprintf

  ```matlab
   A = [1, 2, 3];
   B = num2str(A); % B = '1 2 3'
   fprintf('%s', B)
   C = [1.564, 0.12345];
   D = num2str(C, 3) % D = '1.56 0.123'
   D = int32(1) % D = 1 % 32 位有符号整数数组
   num2str(D, '%.6f') % num2str = '1.000000'
  ```

## rand

rand('seed',key) : 对于固定的key，不是说从此以后产生的随机数都是相同的，而是在相同的key下，第一次调用rand产生的结果是相同的。

每次你要产生随机数的时候，比如你产生rand(10,1),先调用rand('seed',key)，这里key是某个确定的整数，那么你得到的结果是相同的，再体会一下：

```matlab
rand('seed',1)
rand(3,1) % rand(m,n)  m行n列随机数，数值在0到1之间
ans =
    0.5129
    0.4605
    0.3504
rand('seed',1)
rand(3,1)
ans =
    0.5129
    0.4605
    0.3504
% 如果你不调用rand('seed',1)，直接调用rand(3,1),那么和第一次的结果是不一样的
rand('seed',2)
rand(3,1)
ans =
    0.0258
    0.9210
    0.7008
rand(3,1)
ans =
    0.5129
    0.4605
    0.3504
rand('seed',2)
rand(3,1)
ans =
    0.0258
    0.9210
    0.7008
```

也就是说，在指定某个seed后，你第一次调用rand(3,1)得到的结果是“确定的”，相当于给rand设定了一个startpoint，相同的seed，对应的startpoint是相同的。

## mean 

```matlab
A = [1 2 3; 3 3 6; 4 6 8; 4 7 7];
mean(A,1) % 按照矩阵A的每一列求平均值
mean(A,2) % 按照矩阵A的每一行求平均值
```

## std

std函数是用来计算标准偏差的一个函数，由于其有不同的参数，我们就用下面的例子进行介绍：

标准差（Standard Deviation） ，中文环境中又常称均方差，是离均差平方的算术平均数的平方根，用σ表示。标准差是方差的算术平方根。标准差能反映一个数据集的离散程度。

```matlab
% y=std(x) 算出x的标准偏差。 x可以是vector或者一个matrix矩阵。
% 若x是vector，则y是算x的标准偏差。
% 若x是matrix，则y是个vector，存放的是算每一列/行的标准偏差。  
% std (x, flag,dim) flag表示标注公差时是要除以n还是n－1
%                   flag==0.........是除以n－1   
%                   flag==1.........是除以n
% dim表示维数
% dim==1..........是按照列分
% dim==2..........是按照行分 若是三维的矩阵，dim=＝3就按照第三维来分数据
% 默认std格式是std(x,0,1);

x=[ 1 2 3 4; 4 5 6 1 ]
std(x)     % std(x,0,1) 除以n－1,按照列分
% ans =
%    2.1213    2.1213    2.1213    2.1213
std(x,1)   % std(x,1,1) 除以n,按照列分
% ans =
%    1.5000    1.5000    1.5000    1.5000
std(x,0,2) % 又可以写成std(x,[],2) 除以n－1,按照行分
%ans =
%    1.2910
%    2.1602
std(x,1,2) % 除以n,按照行分
%ans =
%    1.1180
%    1.8708
```

## bsxfun

【函数描述】C=bsxfun(fun,A,B)：两个数组间元素逐个计算，fun是函数句柄或者m文件。

```matlab
a = [1,2,3;4,5,6;7,8,9]
acol = bsxfun(@times,a,[1 2 4]) % a和[1 2 4]点乘
% acol =
%     1     4    12
%     4    10    24
%     7    16    36
```



## Tricks

- [Compare Variation In Figure](#compare-variation-in-figure)
- [Compare Variation In Number](#compare-variation-in-number)
- [Compare Variables' Details](#compare-variables-details)
- [Funtion Comments](#function-comments)


## Compare Variation In Figure

```matlab
figure
count = 0;
for i = 1:39
	count = count + 1;
	plot(ziyu_original(i,:), 'b.');
	hold on;
	plot(ziyu_remove(i, :), 'r.');
	plot(htk_original(i,:), 'g+');
	pause(1)
	clf('reset')
	a = length(ziyu_original(i,:));
	b = length(ziyu_remove(i,:));
	c = length(htk_original(i,:));
	fprintf('count ziyu_original  ziyu_remove htk_original: %d %d %d %d\n',count,a,b,c)
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

