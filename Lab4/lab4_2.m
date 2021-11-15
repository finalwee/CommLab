symbols = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' };
prob = [0.2, 0.05, 0.005, 0.2, 0.3, 0.05, 0.045, 0.15];

dict = huffmandict( symbols, prob );
display(dict);

sym_seq = {'g', 'a', 'c', 'a', 'b'};
display(sym_seq);

bin_seq = huffmanenco(sym_seq, dict);
display(bin_seq);

sym_seq = huffmandeco(bin_seq, dict);
display(sym_seq)