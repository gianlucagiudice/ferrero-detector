function images = readlists(filename)
    f = fopen(filename);
    reads = textscan(f,'%s');
    fclose(f);
    images = reads{:};
end