classdef Vector2D
    properties
        startPoint
        endPoint
    end

    methods

        function obj = Vector2D(p1, p2)
            if nargin == 0
                obj.startPoint = Point(0,0);
                obj.endPoint = Point(0,0);
            else
                obj.startPoint = p1;
                obj.endPoint = p2;
            end
        end


        function print(obj)
            fprintf('Vector from (%.2f, %.2f) to (%.2f, %.2f)\n', ...
                obj.startPoint.x, obj.startPoint.y, ...
                obj.endPoint.x, obj.endPoint.y);
        end

        function len = length(obj)
            dx = obj.endPoint.x - obj.startPoint.x;
            dy = obj.endPoint.y - obj.startPoint.y;
            len = sqrt(dx^2 + dy^2);
        end

        function res = plus(v1, v2)

            x1 = v1.endPoint.x - v1.startPoint.x;
            y1 = v1.endPoint.y - v1.startPoint.y;

            x2 = v2.endPoint.x - v2.startPoint.x;
            y2 = v2.endPoint.y - v2.startPoint.y;
            newEnd = Point(x1 + x2, y1 + y2);
            res = Vector2D(Point(0,0), newEnd);
        end
    end
end

