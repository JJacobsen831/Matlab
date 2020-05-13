function Vector = OneDee(Matrix)
%convert 2D matrix to mx1 vector
Dim1 = length(Matrix(:,1));
Dim2 = length(Matrix(1,:));

Vector = reshape(Matrix, [Dim1*Dim2, 1]);
return