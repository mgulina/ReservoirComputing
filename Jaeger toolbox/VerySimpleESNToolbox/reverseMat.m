function reversedMat = reverseMat(mat, dim)
% reverses a 2-d matrix along dimension dim
reversedMat = mat;
sz = size(mat);
l = sz(dim);
if dim == 1
    for n = 1:l
        reversedMat(n,:) = mat(end-n+1,:);
    end
else
    for n = 1:l
        reversedMat(:,n) = mat(:,end-n+1);
    end
end
