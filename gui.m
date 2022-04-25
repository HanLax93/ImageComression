clear all;clc
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp'},'File Selector','Select an Image');
name = filename(1:end-4);