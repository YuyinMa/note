fid = fopen('inst10-10-10-5.cfg','r');  % open instances
if fid < 0
    error('cannot open file %s\n',a); 
end