function color = colorValue(rubik)
    color = 0;
    imgray = rgb2gray(rubik);
    BW = imbinarize(imgray, 0.01);
    [x, y] = size(BW);
    patt = imread('pattern/patt1.jpg');
    
    c = normxcorr2(patt, BW);
    %figure;surf(c);
    %shading flat;
    
    flattenedC = reshape(c.',1,[]);
    %pass 99%
    lim = prctile(flattenedC, 99.6);
    
    cuttedC = zeros(size(BW));
    for i=1:x
        for j=1:y
            cuttedC(i,j) = c(size(patt,1)/2 + i,size(patt,2)/2 + j) > lim;
        end
    end
    
    %figure;imshow(rubik);
    stl = strel('disk', 8);
    cuttedC = imdilate(cuttedC, stl);
    stl = strel('disk', 7);
    cuttedC = imerode(cuttedC, stl);
    
    CC = bwconncomp(cuttedC);
    stats = regionprops(CC, 'centroid');
    pts = cat(1, stats.Centroid);
    
    left2 = pts(1,:);
    right2 = pts(1,:);
    bottom2 = pts(1,:);
    for i=2:size(pts, 1)
        if left2(1) > pts(i,1)
            left2 = pts(i,:);
        end
        if right2(1) < pts(i,1)
            right2 = pts(i,:);
        end
        if bottom2(2) < pts(i,2)
            bottom2 = pts(i,:);
        end
    end
    
    
    figure;imshow(cuttedC);hold on;
    plot(pts(:,1), pts(:,2), 'bo');
end