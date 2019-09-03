# Programs

This is about different methods to generate MFCC features and analyze the effect.

## Content

- [1.ASV_verify](#asv-verify)
- [2.MSR ToolKit](#msr-toolkit)

## 1.ASV_verify <span id = "asv-verify">

- [(1)ASV_enroll.m](#asv-enroll)
- [(2)ASV_verify.m](#asv-verify-m)
- [(3)read_feature.m](#read-feature)
- [(4)cmvn.m](#cmvn)



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

### (3)read_feature.m <span id = "read-feature">

```matlab
function data = read_feature(file)
%     assert(exist(file))
    [x,fs] = audioread(file); 
    % x - speech signal
    % fs - sample rate in Hz
%     assert(fs == 16000);
    premcoef = 0.97; % 定义预加重系数
    rand ("seed", 1);
%     x = rm_dc_n_dither(x, fs); 
%     x = filter([1 -premcoef], 1, x);
    v = vadsohn(x,fs);
    x = x(v==1);
    fL = 100.0/fs;   % 低端滤波器
    fH = 8000.0/fs;  % 高端滤波器
    fRate = 0.010 * fs; 
    fSize = 0.025 * fs; 
    nChan = 27;  % 定义美尔频谱的频道数量
    nCeps = 12;  % 定义取到的MFCC首系数的个数

    data = melcepst(x, fs, '0dD', nCeps, nChan, fSize, fRate, fL, fH);
    data = cmvn(data', true);
end
```

### (4)cmvn.m <span id = "cmvn">

```matlab
function Fea = cmvn(fea, varnorm)
% performs cepstral mean and variance normalization
%
% Inputs:
%   - fea     : input ndim x nobs feature matrix, where nobs is the 
%				number of frames and ndim is the feature dimension
%   - varnorm : binary switch (false|true), if true variance is normalized 
%               as well
% Outputs:
%   - Fea     : output p x n normalized feature matrix.
%
% Omid Sadjadi <s.omid.sadjadi@gmail.com>
% Microsoft Research, Conversational Systems Research Center

if ( nargin == 1 ), varnorm = false; end 
    
mu = mean(fea, 2);
if varnorm,
    stdev = std(fea, [], 2);
else
    stdev = 1;
end

Fea = bsxfun(@minus, fea, mu);
Fea = bsxfun(@rdivide, Fea, stdev);
```



## 2.MSR ToolKit <span id = "msr-toolkit">


































