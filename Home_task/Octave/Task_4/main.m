clc; clear;

A = Point(0,0 ); A.print();
B = Point(3, 0); B.print();
C = Point(0, 0); C.print();
D = Point(0,4 ); D.print();



v1 = Vector2D(A, B);
v2 = Vector2D(C, D);
disp('Вектори ');
v1.print();
v2.print();
fprintf('Довжина v1 = %.3f\n', v1.length());
fprintf('Довжина v2 = %.3f\n', v2.length());

v_sum = v1 + v2;

disp(' Результат додавання ');
v_sum.print();
fprintf('Довжина результату = %.3f\n', v_sum.length());

