# HTK-Tutorial

HTK全名HMM Toolkit，是一款基于hmm模型的语音处理工具。

#### 1. 下载

- 英文版：HTK官方主页：http://htk.eng.cam.ac.uk/，里面有最新版本的安装文件，有其文档材料htkbook.pdf。
- 中文版：HTK基础指南。

#### 2.安装

1. 先安装 Active Perl(确保电脑中装有ActivePerl)。
2. 下载到HTK-3.4.1.ZIP后，解压，将其中的htk文件夹整个复制到D:\htk\目录下。
3. 确保的环境变量Path包含路径C:\Program Files\Microsoft Visual Studio 10.0\Common7\Tools ，路径根据你安装所在目录作相应改变。

#### 3. 测试

1. 打开DOS 命令窗口，进入htk文件夹，在该文件夹下建立一个新文件夹bin.win32。

2. 输入：

   ```bash
   mkdir bin.win32
   ```

3. 在DOS窗口运行vsvars32。

4. 接下来编译htk库文件：

   ```bash
   cd  HTKLib # 进入HTKLib文件夹  
   nmake /f htk_htklib_nt.mkf all # 编译该文件夹下所有的库文件
   ```

5. ```bash
   cd .. 
   cd HTKTools # 进入HTKTools文件夹
   nmake /f htk_htktools_nt.mkf all
   ```

6. ```bash
   cd .. 
   cd HLMLib # 进入HLMLib文件夹
   nmake /f htk_hlmlib_nt.mkf all 
   ```

7. ```bash
   cd ..                          
   cd HLMTools # 进入HLMTools文件夹                   
   nmake /f htk_hlmtools_nt.mkf all
   ```

8. ```bash
   cd ..                          
   # 其他的库文件类似
   ```

9.  完成后，所有生成的exe文件在bin.win32文件夹中，然后将该目录D:\htk\bin.win32加入环境变量PATH中，即可。

10. 确保电脑中装有ActivePerl。测试一下安装是否成功：

11. 将HTK3.4.1文件夹下HTKDemo文件复制到D:\htk\下，然后使用如下命令

12. 运行HTKDemo中的例子：

    ```bash
    cd HTKDemo
    mkdir hmms
    cd hmms
    mkdir tmp
    mkdir hmm.0
    mkdir hmm.1
    mkdir hmm.2
    mkdir hmm.3
    cd ..
    mkdir proto
    mkdir acc
    mkdir test
    perl runDemo.pl configs\monPlainM1S1.dcf
    ```

#### 4. 工具

1. HSLab.exe     录音，标记工具
2. Hcopy.exe     从语音提取特征参数的工具
3. HInit.exe 和 HCompV.exe 对HMM模型初始化的工具，注意，这里需要对每个模型都要使用此命令进行初始化
4. HRest.exe     对模型进行迭代训练的工具
5. HParse.exe    语法转网络的工具，发音转本文用到的
6. HSGen.exe    语法查错工具
7. HVite.exe      解码工具，也就是识别工具。可以用命令行方式使用，也可以用交互方式使用

注意：

默认情况下HSLab工具使用的是x11做的图形界面接口,windows不支持，所以需要修改一下生成文件，使用windows GUI。修改htk_htklib_nt.mkf（两处）,将HGraf.null.obj替换为HGraf_WIN32.obj，HGraf.null.olv替换为 HGraf_WIN32.olv。
再按照上面的步骤安装即可。

#### 5. 使用

1. 建立语音库（略）

2. 实现特征提取：使用命令Hcopy来完成

   1. 首先需要完成两个配置文件的编写： 特征矢量参数的analysis.conf文件和源文件和目的文件的位置列表文件targetlist.txt：

      - analysis.conf文件制作：

        ```
        SOURCEFORMAT = HTK            #指定输入语音文件的搁置
        TARGETKIND = MFCC_0_D_A       #定义提取神马样的特征参数，这里定义的是12个MFCC系数，1个nullMFCC系数c0,13个一阶MFCC系数，13个二阶MFCC系数。一共39个。MFCC的有关材料 百度既可。
        WINDOWSIZE = 250000.0         #定义帧长
        TARGETRATE = 100000.0         #定义取帧时的滑动长度
        
        NUMCEPS = 12                  #定义取到的MFCC首系数的个数。上边的12就来源于此。
        USEHAMMING = T                #定义取帧时用到的窗函数。这里定义使用汉宁窗。
        PREEMCOEF = 0.97              #定义预加重系数，
        NUMCHANS = 26                 #定义美尔频谱的频道数量
        CEPLIFTER = 22                #定义倒谱所用到的滤波器组内滤波器个数
        ```

      - 然后制作targetlist.txt文件：

        ```
        D:\timit_wav8000\TEST\DR1\FAKS0\SA1.WAV D:\timit_mfcc\TEST\DR1\FAKS0\SA1.mfcc
        D:\timit_wav8000\TEST\DR1\FAKS0\SA2.WAV D:timit_mfcc\TEST\DR1\FAKS0\SA2.mfcc
        # ... 共6300行 表示6300条specch
        ```

   2. 完成上面两个文件后，运行如下命令：

      ```bash
      Hcopy -A -D -C  analysis.conf -S targetlist.txt
      ```

   3. 回车，如果没有错误的话，在指定文件夹下，应该有*.mfcc文件出现。此步骤不容易出错，一般都会成功。











































