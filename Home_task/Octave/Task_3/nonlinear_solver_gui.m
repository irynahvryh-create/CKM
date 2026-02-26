function nonlinear_solver_gui
f = figure('Position',[400 150 700 500], 'MenuBar','none','Name','Наближене розв’язування нелінійного рівняння', ...
             'NumberTitle','off','Resize','off');
uicontrol('Style','text','String','f(x)=','HorizontalAlignment','left','FontSize',10,'Position',[40 445 50 20]);
func_edit = uicontrol('Style','edit','Position',[90 440 250 25],'String','x^3 - x - 2','HorizontalAlignment','left','FontSize',10);
uicontrol('Style','text','Position',[390 445 60 20],'String','Метод:','HorizontalAlignment','left','FontSize',10);
method_list = uicontrol('Style','listbox','Position',[460 380 100 85], 'String',{'Ньютона','Січних','Бісекції'}, 'Value',1,'FontSize',10);
uicontrol('Style','text','Position',[40 405 70 20],'String','x0 (або a):','HorizontalAlignment','left','FontSize',10);
x0_edit = uicontrol('Style','edit','Position',[120 400 80 25],'String','1','HorizontalAlignment','left','FontSize',10);
uicontrol('Style','text','Position',[220 405 80 20],'String','x1 (для січних):','HorizontalAlignment','left','FontSize',10);
x1_edit = uicontrol('Style','edit','Position',[300 400 80 25],'String','2','HorizontalAlignment','left','FontSize',10);
uicontrol('Style','pushbutton','Position',[580 400 100 30],'String','Обчислити','Callback',@calculate,'FontSize',10);
uicontrol('Style','text','Position',[40 330 110 20],'String','Розв’язок x =','HorizontalAlignment','left','FontSize',10);
result_edit = uicontrol('Style','edit','Position',[160 330 150 25],'Enable','inactive','FontSize',10);
uicontrol('Style','text','Position',[40 300 110 20],'String','Похибка =','HorizontalAlignment','left','FontSize',10);
error_edit = uicontrol('Style','edit','Position',[160 300 150 25],'Enable','inactive','FontSize',10);
uicontrol('Style','text','Position',[40 270 110 20],'String','Ітерацій =','HorizontalAlignment','left','FontSize',10);
iter_edit = uicontrol('Style','edit','Position',[160 270 150 25],'Enable','inactive','FontSize',10);
uicontrol('Style','text','Position',[40 240 110 20],'String','Час (с) =','HorizontalAlignment','left','FontSize',10);
time_edit = uicontrol('Style','edit','Position',[160 240 150 25],'Enable','inactive','FontSize',10);
graph_axes = axes('Units','pixels','Position',[350 50 320 300]);

function calculate(~,~)
func_str = get(func_edit,'String');
try
f = @(x) eval(vectorize(func_str));
_ = f(0);
catch
set(result_edit,'String','Помилка у функції');
return;
end

method_id = get(method_list,'Value');
x0 = str2double(get(x0_edit,'String'));
x1 = str2double(get(x1_edit,'String'));
if isnan(x0) || (method_id ~= 1 && isnan(x1))
set(result_edit,'String','Некоректні дані');
return;
end

tol = 1e-6;
max_iter = 1000;
tic;
root = NaN;
err = NaN;
iter = 0;
try
switch method_id
case 1
  use_symbolic = exist('str2sym','file') && exist('matlabFunction','file');
 if use_symbolic
  syms xsym;
  f_sym = str2sym(func_str);
  df = matlabFunction(diff(f_sym, xsym));
  [root, err, iter] = newton_method(f, df, x0, tol, max_iter);
else
  df_num = @(x) (f(x + 1e-6) - f(x - 1e-6)) / (2e-6);
  [root, err, iter] = newton_method(f, df_num, x0, tol, max_iter);
end
case 2
  [root, err, iter] = secant_method(f, x0, x1, tol, max_iter);
case 3
  [root, err, iter] = bisection_method(f, min(x0,x1), max(x0,x1), tol, max_iter);
end
catch mem
set(result_edit,'String','Помилка обчислення');
set(error_edit,'String','-'); set(iter_edit,'String','-'); set(time_edit,'String','-');
return;
end
elapsed = toc;

if isnan(root) || iter >= max_iter
set(result_edit,'String','Не знайдено');
else
 set(result_edit,'String',num2str(root, '%.6f'));
end
 set(error_edit,'String',num2str(err, '%.6g'));
 set(iter_edit,'String',num2str(iter));
 set(time_edit,'String',num2str(elapsed, '%.5f'));

axes(graph_axes);
    if isnan(root)
        x_min = min(x0,x1)-1; x_max = max(x0,x1)+1;
    else
        x_min = min([x0,x1,root])-1; x_max = max([x0,x1,root])+1;
    end
    x = linspace(x_min,x_max,500);
    y = f(x);
    finite_y = y(isfinite(y));
    if isempty(finite_y)
        y_max_abs = 1;
    else
        y_max_abs = max(abs(finite_y))*1.5;
        if y_max_abs<1, y_max_abs=1; end
    end
    y_max_plot = min(y_max_abs,50);

    cla(graph_axes); hold on;
    plot(x,y,'b-','LineWidth',1.5);
    if ~isnan(root)
        plot(root,0,'ro','MarkerFaceColor','r','MarkerSize',8);
        text(root,0,sprintf('  x = %.6f',root),'Color','r','FontWeight','bold','FontSize',9,'VerticalAlignment','bottom');
    end
    ylim([-y_max_plot,y_max_plot]);
    title('Графік функції та розв’язок');
    xlabel('x'); ylabel('f(x)');
    grid on; hold off;
end
end

function [root, err, iter] = newton_method(f, df, x0, tol, max_iter)
  x_curr = x0;
  root = NaN;
  err = NaN;
  if abs(df(x_curr)) < eps
    return;
  end
  for iter = 1:max_iter
    denom = df(x_curr);
    if abs(denom) < eps
      return;
    end
    x_next = x_curr - f(x_curr)/denom;
    err = abs(x_next - x_curr);
    if err < tol || abs(f(x_next)) < tol * 1e-1
      root = x_next;
      return;
    end
    x_curr = x_next;
  end
  root = x_curr;
end

function [root, err, iter] = secant_method(f, x0, x1, tol, max_iter)
  x_prev = x0;
  x_curr = x1;
  root = NaN; err = NaN;
  for iter = 1:max_iter
    f_curr = f(x_curr);
    f_prev = f(x_prev);
    if abs(f_curr - f_prev) < eps
      root = NaN; err = NaN; return;
    end
    x_next = x_curr - f_curr*(x_curr - x_prev)/(f_curr - f_prev);
    err = abs(x_next - x_curr);
    if err < tol || abs(f(x_next)) < tol * 1e-1
      root = x_next; return;
    end
    x_prev = x_curr;
    x_curr = x_next;
  end
  root = x_curr;
end

function [root, err, iter] = bisection_method(f, a, b, tol, max_iter)
  root = NaN; err = NaN; iter = 0;
if f(a)*f(b) > 0
    return;
end
for iter = 1:max_iter
    c = (a + b)/2;
if f(c) == 0
      root = c; err = 0; return;
    end
    if f(a)*f(c) < 0
      b = c;
    else
      a = c;
    end
    err = abs(b - a);
    if err < tol
      root = (a + b)/2; return;
    end
  end
  root = (a + b)/2;
end
