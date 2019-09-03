# Speaker-Recognition-GMM-UBM

![](https://img.shields.io/badge/build-success-green) ![](https://img.shields.io/badge/language-matlab-yellow) ![](https://img.shields.io/badge/Toolkit-MSR%20Identity%20Toolkit-orange) ![](https://img.shields.io/badge/method-GMM--UBM-blue) ![](https://img.shields.io/badge/license-MathWorks-brightgreen) 
![](./pictures/01-gmm-ubm.png)

<p align="center">
	<a href="./docs/matlab-common-operations.md">Common Matlab operations</a>&nbsp;&nbsp;&nbsp;
	<a href="./docs/matlab-functions-you-will-encounter.md">Matlab Functions Used</a>&nbsp;&nbsp;&nbsp;
	<a href="./docs/GMM-UBM-speaker-model.md">GMM-UBM speaker model</a>&nbsp;&nbsp;&nbsp;
	<a href="./docs/HTK-Tutorial.md">HTK Tutorial</a>&nbsp;&nbsp;&nbsp;
	<a href="./docs/MSR-Identity-Toolkit.md">MSR-Identity-Toolkit</a>
</p>

## Contents

1. [Transform WAV To Readable file](#transform-wav-to-readable-file)




### 1. Transform WAV To Readable file

![](https://img.shields.io/badge/language-python-brightgreen)
1. Download TIMIT corpus.

2. Create a file (copy TIMIT's two files in it：(1)TEST (2)TRAIN)which has the same directory form as TIMIT corpus：

   ```python
   import os, sys
   
   # path1 = 'D:/Project/Speaker-Recognition/timit_wav8000'
   # path1 = 'D:/Project/Speaker-Recognition/timit_mfcc'
   path1 = 'D:/Project/Speaker-Recognition/timit_wav16000'
   print(f'the path to be deleted is {path1}')
   files1 = os.listdir(path1)
   count = 0
   for file1 in files1:
       path2 = path1 + '/' + file1
       files2 = os.listdir(path2)
   
       for file2 in files2:
           path3 = path2 + '/' + file2
           files3 = os.listdir(path3)
           for file3 in files3:
               path4 = path3 + '/' + file3
               files4 = os.listdir(path4)
               for file4 in files4:
                   path5 = path4 + '/' + file4
                   # print(path5)
                   count += 1
                   os.unlink(path5)
   print(count)
   print('complete delete')
   ```

   