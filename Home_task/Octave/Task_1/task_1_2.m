clc; clear; close all;



% Функція для вибору простих чисел

function primes_out = select_primes(v)
    primes_out = v(arrayfun(@is_prime_custom, v));
end


function flag = is_prime_custom(n)
    if n < 2
        flag = false;
        return;
    end
    for i = 2:floor(sqrt(n))
        if mod(n,i) == 0
            flag = false;
            return;
        end
    end
    flag = true;
end


v = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11]


primes_vec = select_primes(v);

disp('Прості числа у векторі:');
disp(primes_vec);

