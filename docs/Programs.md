# Programs

This is about different methods to generate MFCC features and analyze the effect.

## Content

- [ASV_verify](#asv-verify)
- [MSR ToolKit](#msr-toolkit)

## ASV_verify <span id = "asv-verify">

1. [ASV_enroll.m](#asv-enroll)



## ASV_enroll.m <span id = "asv-enroll">

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

1. [mpfile](#mpfile)

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


## MSR ToolKit <span id = "msr-toolkit">


































