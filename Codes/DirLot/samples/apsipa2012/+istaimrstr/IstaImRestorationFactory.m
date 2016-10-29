classdef IstaImRestorationFactory
    %ISTAIMRESTORATIONFACTORY Factory class of PCD Image Restoration
    %
    % SVN identifier:
    % $Id: IstaImRestorationFactory.m 303 2012-03-11 01:39:03Z sho $
    %
    % Requirements: MATLAB R2008a, mlunit-2.0-beta1
    %
    % Copyright (c) 2012, Shogo MURAMATSU
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    
    methods (Static = true)
        
        function value = createIstaImRestoration(obj,varargin)
            if nargin == 0
                obj = 'dirsowt';
            end
            if nargin == 1 && isa(obj,'istaimrstr.AbstIstaImRestoration')
                value = clone(obj);
                %{
                if isa(obj,'istaimrstr.DirSowtIstaImRestoration')
                    value = istaimrstr.DirSowtIstaImRestoration(obj);
                elseif isa(obj,'istaimrstr.NsHaarWtIstaImRestoration')
                    value = istaimrstr.NsHaarWtIstaImRestoration(obj);
                else
                    id = 'DirLOT:IllegalArgumentException';
                    msg = 'Unsupported type of transforms';
                    me = MException(id, msg);
                    throw(me);
                end
                %}
            elseif isa(obj,'char')
                switch obj
                    case { 'dirsowt' }
                        value = istaimrstr.DirSowtIstaImRestoration(...
                            obj,varargin{:});
                    case { 'nshaar' }
                        value = istaimrstr.NsHaarWtIstaImRestoration(...
                            obj,varargin{:});
                    otherwise
                        id = 'DirLOT:IllegalArgumentException';
                        msg = 'Unsupported type of transforms';
                        me = MException(id, msg);
                        throw(me);
                end
            end
        end
    end
end
