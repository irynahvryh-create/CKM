classdef Point
    properties
        x
        y
    end

    methods

        function obj = Point(x, y)
            if nargin == 0
                obj.x = 0;
                obj.y = 0;
            else
                obj.x = x;
                obj.y = y;
            end
        end
        function print(obj)
            fprintf('Point(%.2f, %.2f)\n', obj.x, obj.y);
        end
    end
end

