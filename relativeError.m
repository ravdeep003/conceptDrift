function rerror = relativeError(Xoriginal, Xcomputed)
    a = norm(Xoriginal-Xcomputed);
    b = norm(Xoriginal);
    rerror = a/b;
end