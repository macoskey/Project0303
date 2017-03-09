% script to automatically make folders - for the lazy
home = cd;
cd E:\Research\Studies\Histology\DopBck_Study\TiledSamples
for fi = 15:62
    eval(sprintf('!mkdir S%.2d_ret',fi))
    eval(sprintf('!mkdir S%.2d_tri',fi))
end
for ci = 2:8
    eval(sprintf('!mkdir CO%.1d_ret',ci))
    eval(sprintf('!mkdir CO%.1d_tri',ci))
end
cd(home)
