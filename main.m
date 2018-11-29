clear
clc
addpath(genpath('JPEG_Toolbox'));
Data = round(rand(1,1000000)*1);%�������01���أ���ΪǶ�������
payload =1000000;
I = imread('Lena.tiff');
imwrite(I,'Lena.jpg','jpeg','quality',70);%������������Ϊ70��JPEGͼ��
imwrite(I,'Ori_Lena.jpg','jpeg','quality',70);%������������Ϊ70��JPEGͼ��
%% ����JPEG�ļ�
jpeg_info = jpeg_read('Lena.jpg');%����JPEGͼ��
ori_jpeg_80 = imread('Lena.jpg');%��ȡԭʼjpegͼ��
quant_tables = jpeg_info.quant_tables{1,1};%��ȡ������
dct_coef = jpeg_info.coef_arrays{1,1};%��ȡdctϵ��
[num1,num_1] = jpeg_hist(dct_coef);%���Ʒ���acϵ��ֱ��ͼ
%% ����Ƕ��
[emdData,numData,jpeg_info_stego] = jpeg_emdding(Data,dct_coef,jpeg_info,payload);
jpeg_write(jpeg_info_stego,'stego_Lena.jpg');%��������jpegͼ��
stego_jpeg_80 = imread('stego_Lena.jpg');%��ȡ����jpegͼ��
%% ������ȡ
stego_jpeg_info = jpeg_read('stego_Lena.jpg');%����JPEGͼ��
[numData2,stego_jpeg_info,extData] = jpeg_extract(stego_jpeg_info,payload);
jpeg_write(stego_jpeg_info,'re_Lena.jpg');%����ָ�jpegͼ��
re_jpeg_80 = imread('re_Lena.jpg');%��ȡ�ָ�jpegͼ��
%% ��ʾ
figure;
subplot(221);imshow(I);title('tiffԭʼͼ��');%��ʾԭʼͼ��
subplot(222);imshow(ori_jpeg_80);title('jpegԭʼͼ��');%��ʾJPEGѹ��ͼ��
subplot(223);imshow(stego_jpeg_80);title('����ͼ��');%��ʾstego_jpeg_80
subplot(224);imshow(re_jpeg_80);title('�ָ�ͼ��');%��ʾ�ָ�ͼ��
%% ͼ�������Ƚ�
psnrvalue1 = psnr(ori_jpeg_80,stego_jpeg_80);
psnrvalue2 = psnr(ori_jpeg_80,re_jpeg_80);
v = isequal(emdData,extData);
if psnrvalue2 == -1
    disp('�ָ�ͼ����ԭʼͼ����ȫһ�¡�');
elseif psnrvalue2 ~= -1
    disp('warning���ָ�ͼ����ԭʼͼ��һ�£�');
end
if v == 1
    disp('��ȡ������Ƕ��������ȫһ�¡�');
elseif v ~= 1
    disp('warning����ȡ������Ƕ�����ݲ�һ��');
end
ori_filesize = imfinfo('stego_Lena.jpg');