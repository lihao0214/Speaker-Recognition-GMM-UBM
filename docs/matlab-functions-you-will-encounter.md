# Matlab Functions You Will Encounter

![](https://img.shields.io/badge/language-matlab-yellow)


## Content

- [Functions](#functions)
- [Trickes](#tricks)
- [Built-in Functions](#built-in-functions)


## Functions

- 




## Tricks

- [Compare Variation](#compare-variation)
- [Compare Variables' Details](#compare-variables-details)


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

## Built-in Functions

1. 什么是内置函数？

   - 内置函数是一类比较特殊的MATLAB底层函数，它们的特点是：一般不是用MATLAB语言写成的、无法看到其源代码（只能看到注释）、执行效率相对较高。 而一般的MATLAB自带的函数都是可以看到源代码甚至可以编辑源代码的。

2. 内置函数与关键字的区别？

   - 关键字是一类更加特殊的底层函数，包括break case catch classdef continue else elseif end for function global if otherwise parfor persistent return spmd switch try while这20个。
   - 关键字不能作为变量名，例如，不能新建一个名叫for的变量。内置函数可以被覆盖(override)，用做变量名。例如，你可以新建一个名叫abs的变量，只不过，MATLAB的绝对值函数abs就无法正常调用了。（实在想要调用的话，可以借助builtin函数）
   - 一般而言，不建议override内置函数。也就是说，变量名尽量避开内置函数名称。

3. 如何找到所有的内置函数？

   - 内置函数的特点在于，运算效率较高。那么，内置函数总共有多少个呢？如何找到这些函数？

   - 思路是：遍历MATLAB所有path路径下的所有文件，获取其文件名，然后用exist函数判断该函数是否为builtin函数。将确定为builtin函数的函数名称写入一个table中，最后去重排序。

   - ```matlab
     allPath = regexp(path,';','split');
     funTable = table;
     for ii = 1:length(allPath)
         cd(allPath{ii})
         files = dir;
         for jj = 1:length(files)
             func = regexp(files(jj).name,'\.','split');
             if exist(func{1},'builtin')
                 funTable = [funTable;func(1)];
             end
         end
     end
     funTable = unique(funTable);
     ```

   - 在R2019a下执行，得到了共计595个built-in函数。

   - 从函数名称上来看，既有abs这种常见的简写，也有ancestor这种全称；既有actxGetRunningServer这种驼峰命名，也有animatedline这种全部小写的命名，还有add_block这种用下划线代替空格的写法。总之，MATLAB函数名称的命名并没有一套统一的规范。

   - 有的builtin函数不一定有对应文件，有不少builtin函数是undocument。

   

   