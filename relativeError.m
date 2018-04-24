%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2018
%Computer Science and Engineering, University of California, Riverside
function rerror = relativeError(Xoriginal, Xcomputed)
    a = norm(Xoriginal-Xcomputed);
    b = norm(Xoriginal);
    rerror = a/b;
end