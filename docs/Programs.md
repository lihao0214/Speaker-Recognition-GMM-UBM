# Programs

This is about different methods to generate MFCC features and analyze the effect.

## Content

- [1.ASV_verify](#asv-verify)
- [2.MSR ToolKit](#msr-toolkit)

## 1.ASV_verify <span id = "asv-verify">

- [(1)ASV_enroll.m](#asv-enroll)
- [(2)ASV_verify.m](#asv-verify-m)



### (1)ASV_enroll.m <span id = "asv-enroll">

```matlab
function err_code = ASV_enroll(wavfile, vpfile, mpfile)
% Usage :
% err_code = ASV_enroll(wavfile, vpfile, modelfile)
%   wavfile - wav file for enrolment (.wav), sampling frequency = 16Hz
%   vpfile - generated voiceprint file (.mat) 
%   mpfile - model parameters file (.mat)
%   err_code - error code
%
% Example:
%   octave --eval 'ASV_enroll("./test/thomas1.wav","./test/thomas_vp.mat","./mp.mat")'

load(mpfile);

data = read_feature(wavfile);
[N, F] = compute_bw_stats(data, ubm);
vp = extract_ivector([N; F], ubm, T);

save(vpfile,'vp');
err_code = 0;

end
```

```matlab
使用
wavfile = 'C:\Users\PC\Desktop\ivector-master\MSRIT\sample.wav';
vpfile = 'samplewav.mat';
mpfile = 'mp.mat';
err_code = ASV_enroll(wavfile, vpfile, mpfile) % err_code = 0
```

**参数**：

- [wavfile](#wavfile)
- [vpfile](#vpfile)
- [mpfile](#mpfile)

#### wavfile  <span id = "wavfile">

```matlab
size(wavfile) = 1 51
```
#### vpfile :  samplewav.mat <span id = "vpfile">

```matlab
vp 600x1 single
```


#### mpfile ：mp.mat  <span id = "mpfile">

```matlab
lda_dim = 400
plda : 1x1 structure 
       plda.Phi   : 400x400 double
       plda.Sigma : 400x400 double
       plda.W     : 400x400 double
       plda.M     : 400x1 double
s_std = 1.822602925083113e+03
s_thr = -6.351970516696982e+03
T = 600x79872 single
ubm : 1x1 structure
	   ubm.w      : 1x2048 double
	   ubm.mu	  : 39x2048 double
	   ubm.sigma  : 39x2048 double
V : 600x600 double
```

### (2)ASV_verify <span id = "asv-verify-m">

```matlab
function score = ASV_verify(wavfile, vpfile, mpfile)
% Usage :
% score = ASV_verify(vpfile, wavfile, mpfile)
%   wavfile - wav file for verification (.wav), sampling frequency = 16Hz
%   vpfile - target voiceprint file (.mat)
%   mpfile - model parameters file (.mat)
%   score - verification score
%
% Example:
%   octave --eval 'ASV_verify("./test/thomas2.wav","./test/thomas_vp.mat","./mp.mat")'

load(mpfile);
load(vpfile);

data = read_feature(wavfile);
[N, F] = compute_bw_stats(data, ubm);
vp2 = extract_ivector([N; F], ubm, T);

vp = V(:, 1:lda_dim)' * vp;
vp2 = V(:, 1:lda_dim)' * vp2;

score = score_gplda_trials(plda, vp, vp2);

score = 1/(1+exp(-(score-s_thr)/s_std));

end
```

```matlab
使用
wavfile = 'C:\Users\PC\Desktop\ivector-master\MSRIT\sample.wav';
vpfile = 'samplewav.mat';
mpfile = 'mp.mat';
score = ASV_verify(wavfile, vpfile, mpfile) % score = 0.9786
```



## 2.MSR ToolKit <span id = "msr-toolkit">


































