function output = strecth(input,T1,T2)

if (input <= T1)
    output = 0;
elseif (input>=T2)
    output = 255; 
else 
    output = round(255/(T2-T1)*(input-T1));
end 