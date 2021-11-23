%2.a)
ge = [1, 0, 0; 1, 0, 1; 1, 1, 1];
binary_data = [1, 0, 1, 1, 0];
encoded_data = conv_enc(binary_data, ge);
display(encoded_data)

%2.b)
d = [0 1 0 0 0 0 1 0 1 1 1 1 0 0 1 0 1 1 0 0 0];
decoded_data = conv_dec(d, ge);
display(decoded_data)

y = [0 0 1 1 0 1 0 0 0 1 0 1 0 0];
ge = [1, 0, 1; 1, 1, 1];
decoded_data = conv_dec(y, ge);
display(decoded_data)

% 2.c)
ber = [];
for p = 0:0.1:1
    x = randi([0 1],110000,1);
    ge = [1, 0, 0; 1, 0, 1; 1, 1, 1];
    encoded_data = conv_enc(x, ge);
    noised_data = bsc(encoded_data, p);
    decoded_data = conv_dec(noised_data, ge);
    bit_error_rate = 0;
    for n = 1:length(decoded_data)
        if encoded_data(n) ~= decoded_data(n)
            bit_error_rate = bit_error_rate + 1;
        end
    end
    ber = [ber, bit_error_rate/length(encoded_data)*100];
end
x = linspace(0, 1, 11);
plot(x, ber)
xlabel('Probability $p$','Interpreter','latex')
ylabel('$Bit$ $Error$ $Rate$ $\left(\%\right)$','Interpreter','latex')

function coded_bits = convention(bits, generators)
    for n = 1:length(generators(:,1))
        if sum(generators(n,:)) == 1
            coded_bits(n) = bits(1);
        elseif sum(generators(n,:)) == 2
            coded_bits(n) = xor(bits(1), bits(3));
        elseif sum(generators(n,:)) == 3
            coded_bits(n) = xor(xor(bits(1), bits(2)), bits(3));
        end
    end
end

function encoded_data = conv_enc(binary_data, impulse_response)
    s = [0 0; 0 1; 1 0; 1 1];
    encoded_data = [];
    current_s = s(1,:);

    for n = 1:length(binary_data)
        bits = [binary_data(n), current_s];
        c = convention(bits, impulse_response);
        encoded_data = [encoded_data, c];
        current_s = [binary_data(n), current_s(1)];
    end
end

function decoded_data = conv_dec(binary_data, impulse_response)
    s = [0 0; 0 1; 1 0; 1 1];
    row = length(impulse_response(:,1));
    col = length(impulse_response(1,:));
    decoded_data = [];
    
    v = zeros(4, length(binary_data)/row);
    s_from = zeros(4, length(binary_data)/row);
    
    %Start
    subdata = binary_data(1:row);
    c0 = convention([0,s(1,:)], impulse_response);
    c1 = convention([1,s(1,:)], impulse_response);
    d0 = 0;
    d1 = 0;
    for i = 1:length(subdata)
        d0 = d0 + xor(subdata(i), c0(i));
        d1 = d1 + xor(subdata(i), c1(i));
    end
    
    ste_idx = find((s(:, 1) == 0 & s(:, 2) == s(1, 1)) == 1);
    v(ste_idx, 1) = d0;
    s_from(ste_idx, 1) = 1;
    ste_idx = find((s(:, 1) == 1 & s(:, 2) == s(1, 1)) == 1);
    v(ste_idx, 1) = d1;
    s_from(ste_idx, 1) = 1;

    for n = 1:length(v)-1
        subdata = binary_data(row*n+1:row*n+row);
        for k = 1:length(s(:,1))
            if v(k, n) ~= 0
                c0 = convention([0, s(k,:)], impulse_response);
                c1 = convention([1, s(k,:)], impulse_response);
                d0 = 0;
                d1 = 0;
                for i = 1:length(subdata)
                    d0 = d0 + xor(subdata(i), c0(i));
                    d1 = d1 + xor(subdata(i), c1(i));
                end
                
                ste_idx = find((s(:, 1) == 0 & s(:, 2) == s(k, 1)) == 1);
                if v(ste_idx, n+1) == 0
                    v(ste_idx, n+1) = v(k, n) + d0;
                    s_from(ste_idx, n+1) = k;
                else
                    if v(ste_idx, n+1) > v(k, n) + d0 
                        v(ste_idx, n+1) = v(k, n) + d0;
                        s_from(ste_idx, n+1) = k;
                    end
                end

                ste_idx = find((s(:, 1) == 1 & s(:, 2) == s(k, 1)) == 1);
                if v(ste_idx, n+1) == 0
                    v(ste_idx, n+1) = v(k, n) + d1;
                    s_from(ste_idx, n+1) = k;
                else
                    if v(ste_idx, n+1) > v(k, n) + d1
                        v(ste_idx, n+1) = v(k, n) + d1;
                        s_from(ste_idx, n+1) = k;
                    end
                end
            end
        end
    end
    
    s_back = 0;
    s_now = 0;
    for n = length(v):-1:1
        if n == length(v)
            s_back = s_from(1, n);
            s_now = 1;
        else
            s_now = s_back;
            s_back = s_from(s_back, n);
        end
        
        c0 = convention([0, s(s_back,:)], impulse_response);
        c1 = convention([1, s(s_back,:)], impulse_response);
        if [0, s(s_back,1)] == s(s_now,:)
            decoded_data = [c0, decoded_data];
            
        elseif [1, s(s_back,1)] == s(s_now,:)
            decoded_data = [c1, decoded_data];
            
        end
    end
end