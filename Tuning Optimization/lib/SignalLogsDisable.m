% Find all logged signals
load_system('Landing_VV.slx');
if ~exist('all_signalLogs','var')
    mdlsignals = find_system('Landing_VV','FindAll','on','LookUnderMasks','all','FollowLinks','on','type','line','SegmentType','trunk');
    all_signalLogs = get_param(mdlsignals,'SrcPortHandle');
end
if ~exist('all_scope','var')
    % Find all scopes
    all_scope = find_system('Landing_VV','AllBlocks','on','FindAll','on','LookUnderMasks','all','BlockType','Scope');    
end
if ~exist('all_display','var')
    %Find all displays
    all_display = find_system('Landing_VV','AllBlocks','on','FindAll','on','LookUnderMasks','all','BlockType','Display');    
end

%% Disable loops
% And disable
for i=1: length(all_signalLogs)   
    set_param(all_signalLogs{i},'datalogging','off')
end
for i = 1:length(all_scope)
    set_param(all_scope(i),'Commented','on')
end
for i = 1:length(all_display)
    set_param(all_display(i),'Commented','on')
end

