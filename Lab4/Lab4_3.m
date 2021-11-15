symbols = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' };
prob = [0.2, 0.05, 0.005, 0.2, 0.3, 0.05, 0.045, 0.15];

sym_bit = {'11', '00000', '000011', '10', '01', '0001', '000010', '001'};

N = [10, 50, 100];
R = [10 20 50 100 200 500 1000];
data_length_array = [];
avg_codeword = [];

for n = 1:length(N)
    for k = 1:length(R)
        for j = 1:R(k)
            indices = randsrc(N(n),1,[1:numel(symbols); prob]);
            randomString = [symbols{indices}];
            %display(randomString);
            data_length = 0;
            for i = 1:length(randomString)
                idx = find(strcmp(symbols, randomString(i)));
                data_length = data_length + length(sym_bit{idx});
            end
            data_length_array(k, j) = data_length;
        end
        mean = sum(data_length_array(n, k))/length(data_length_array(k));
        avg_codeword(n, k) = mean/N(n);
    end
end

entropy_1a = 0.76225;
avg_codeword_1d = 2.6;
display(avg_codeword(1,:))
semilogx(entropy_1a)
semilogx(R, avg_codeword)
yline(entropy_1a, Color='magenta')
yline(avg_codeword_1d, Color='black')
h = legend('$\overline{L}_n(R)$ $n=10$', '$\overline{L}_n(R)$ $n=50$', '$\overline{L}_n(R)$ $n=100$', '$H[X]$ in 1a', '$\overline{L}$ in 1d','Interpreter','latex');
rect = [0.6, 0.25, 0.25, 0.25];
set(h, 'Position', rect)
grid on




