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
- [(5)compute_bw_stats](#compute-bw-stats)



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
% 倒谱均值和方差归一化（ CMVN）是用于鲁棒语音识别的计算上有效的归一化技术。CMVN 通过线性变换倒谱系数以具有相同的分段统计来最小化噪声污染引起的失真，从而实现稳健的特征提取。可在各种声学环境中保持高水平的识别精度。
% performs cepstral mean and variance normalization
%
% Inputs:
%   - fea     : 特征维度x帧数
%               input ndim x nobs feature matrix, where nobs is the number of frames and ndim is the feature dimension
%   - varnorm : true or false
%               binary switch (false|true), if true variance is normalized as well
% Outputs:
%   - Fea     : output p x n normalized feature matrix.
%
% Omid Sadjadi <s.omid.sadjadi@gmail.com>
% Microsoft Research, Conversational Systems Research Center

if ( nargin == 1 ), varnorm = false; end % 意思是varnorm默认为false
    
mu = mean(fea, 2); % 按照矩阵fea的每一行求平均值（每一个特征维度）
if varnorm, % 当varnorm为真时执行
    stdev = std(fea, [], 2); % 求fea的标准差 除以n－1,按照行分
else % 当varnorm不为真时执行
    stdev = 1;
end

Fea = bsxfun(@minus, fea, mu); % fea的每个元素减去mu的每个元素
Fea = bsxfun(@rdivide, Fea, stdev); % ..除以..
```

### (5)compute_bw_stats.m <span id = "compute-bw-stats">

```matlab
function [N, F] = compute_bw_stats(feaFilename, ubmFilename, statFilename)
% extracts sufficient statistics for features in feaFilename and GMM 
% ubmFilename, and optionally save the stats in statsFilename. The first order statistics are centered.
%
% Inputs:
%   - feaFilename  : input feature file name (string) or a feature matrix (one observation per column)
%   - ubmFilename  : file name of the UBM or a structure with UBM hyperparameters.
%   - statFilename : output file name (optional)   
%
% Outputs:
%   - N			   : mixture occupation counts (responsibilities) 
%   - F            : centered first order stats
%
% References:
%   [1] N. Dehak, P. Kenny, R. Dehak, P. Dumouchel, and P. Ouellet, "Front-end 
%       factor analysis for speaker verification," IEEE TASLP, vol. 19, pp. 788-798,
%       May 2011. 
%   [2] P. Kenny, "A small footprint i-vector extractor," in Proc. Odyssey, 
%       The Speaker and Language Recognition Workshop, Jun. 2012.
%
%
% Omid Sadjadi <s.omid.sadjadi@gmail.com>
% Microsoft Research, Conversational Systems Research Center

if ischar(ubmFilename),
	tmp  = load(ubmFilename);
	ubm  = tmp.gmm;
elseif isstruct(ubmFilename),
	ubm = ubmFilename;
else
    error('Oops! ubmFilename should be either a string or a structure!');
end
[ndim, nmix] = size(ubm.mu);
m = reshape(ubm.mu, ndim * nmix, 1);
idx_sv = reshape(repmat(1 : nmix, ndim, 1), ndim * nmix, 1);

if ischar(feaFilename),
    data = htkread(feaFilename);
else
    data = feaFilename;
end

[N, F] = expectation(data, ubm);
F = reshape(F, ndim * nmix, 1);
F = F - N(idx_sv) .* m; % centered first order stats

if ( nargin == 3)
	% create the path if it does not exist and save the file
	path = fileparts(statFilename);
	if ( exist(path, 'dir')~=7 && ~isempty(path) ), mkdir(path); end
	parsave(statFilename, N, F);
end

function parsave(fname, N, F) %#ok
save(fname, 'N', 'F')

function [N, F] = expectation(data, gmm)
% compute the sufficient statistics
post = postprob(data, gmm.mu, gmm.sigma, gmm.w(:));
N = sum(post, 2);
F = data * post';

function [post, llk] = postprob(data, mu, sigma, w)
% compute the posterior probability of mixtures for each frame
post = lgmmprob(data, mu, sigma, w);
llk  = logsumexp(post, 1);
post = exp(bsxfun(@minus, post, llk));

function logprob = lgmmprob(data, mu, sigma, w)
% compute the log probability of observations given the GMM
ndim = size(data, 1);
C = sum(mu.*mu./sigma) + sum(log(sigma));
D = (1./sigma)' * (data .* data) - 2 * (mu./sigma)' * data  + ndim * log(2 * pi);
logprob = -0.5 * (bsxfun(@plus, C',  D));
logprob = bsxfun(@plus, logprob, log(w));

function y = logsumexp(x, dim)
% compute log(sum(exp(x),dim)) while avoiding numerical underflow
xmax = max(x, [], dim);
y    = xmax + log(sum(exp(bsxfun(@minus, x, xmax)), dim));
ind  = find(~isfinite(xmax));
if ~isempty(ind)
    y(ind) = xmax(ind);
end
```



## 2.MSR ToolKit <span id = "msr-toolkit">


































