function rerror = relativeError(Xoriginal, Xcomputed)
    Xoriginal = tensor(Xoriginal);
    a = norm(Xoriginal-Xcomputed);
    b = norm(Xoriginal);
    rerror = a/b;
end