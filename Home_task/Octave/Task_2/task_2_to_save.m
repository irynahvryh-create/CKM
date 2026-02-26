% Метод хорд

clc; clear;

% Встановлюємо графічний рушій (краще на початку)
#{
if any(strcmpi(available_graphics_toolkits(), 'gnuplot'))
    graphics_toolkit('gnuplot');
    fprintf('Graphics toolkit set to gnuplot.\n');
else
    warning('gnuplot toolkit is not available, using default: %s', graphics_toolkit());
end
#}

%функція
#f = @(x) x.^3 - x - 2;
f=@(x) e.^x-x.^2-10

a0=0;
b0=4;

tol=1e-9;
max_iter=100;


#x_prev=NaN;
x_prev=0.5
iterations=[];
errors=[];
a=a0; b=b0;

 for k=1:max_iter
   x=(a*f(b)-b*f(a))/(f(b)-f(a));
   fx=f(x); #-------

   iterations(end+1)=x;

   if isnan(x_prev)
     errors(end+1)=NaN;
   else
     errors(end+1)=abs(x-x_prev);
   end

   if~isnan(x_prev)&&abs(x-x_prev)<tol
   break;
    end

    if f(a)*fx<0
   b=x;
    else
   a=x;
   end
 x_prev=x;
end
rood=x;

fprintf('Знайдений корінь :%.12f \n',rood);
fprintf('Кількість ітерацій: %d\n',length(iterations));
fprintf('Похибка: %10e \n ',errors(k));
fprintf('\n №\t x_k\t\t f(x_k)\t\t похибка\n');
for i = 1:length(iterations)
    if i == 1
        fprintf('%d\t %.10f\t %.10f\t %s\n', i, iterations(i), f(iterations(i)), '---');
    else
        fprintf('%d\t %.10f\t %.10f\t %.10e\n', i, iterations(i), f(iterations(i)), errors(i));
    end
end


%grafik

x_vals = linspace(a0, b0, 400);
y_vals = arrayfun(f, x_vals);

figure(1);
plot(x_vals, y_vals, 'b-', 'LineWidth', 1.5);
hold on;
plot(rood, f(rood), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

xlabel('x');
ylabel('f(x)');
title('Графік функції та знайдений корінь (метод хорд)');
grid on;
legend('f(x)', 'Знайдений корінь');

print -dpng function_plot.png


%print('function_plot.pdf', '-dpdfcairo');


figure(2);

iter_nums = 2:length(errors);
error_vals = errors(2:end);

plot(iter_nums, error_vals, '-o-', 'LineWidth', 1.5);
set(gca, 'YScale', 'log');
xlabel('Номер ітерації');
ylabel('Похибка |x_k - x_{k-1}|');
title('Зміна похибки від номера ітерації (метод хорд)');
grid on;
legend('Похибка');

print -dpng error_plot.png
#print('error_plot.pdf','-dpdf');
%print('error_plot.pdf', '-dpdfcairo');


