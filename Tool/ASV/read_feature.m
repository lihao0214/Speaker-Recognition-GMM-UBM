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
