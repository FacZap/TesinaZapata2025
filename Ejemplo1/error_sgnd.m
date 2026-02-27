%% ERROR: diferencia entre setpoints y valor final de las salidas
final_value=[0 0 0 0];
try
    for k = 1:4
        final_value(k) = (yout(length(tout), k));
        eval(sprintf('err_rel(%d) = abs((final_value(%d) - sp%d) / sp%d) * 100;', k, k, k, k));
        eval(sprintf('err_sgnd(%d)=((final_value(%d) - sp%d) / sp%d) * 100;', k, k, k, k));
    end
    err_sgnd
    clipboard('copy', sprintf('%.4f\t%.4f\t%.4f\t%.4f', err_sgnd));
catch
    for k = 1:4
        final_value(k) = (out.yout(length(out.tout), k));
        eval(sprintf('err_rel(%d) = abs((final_value(%d) - sp%d) / sp%d) * 100;', k, k, k, k));
        eval(sprintf('err_sgnd(%d)=((final_value(%d) - sp%d) / sp%d) * 100;', k, k, k, k));
    end
    err_sgnd
    clipboard('copy', sprintf('%.4f\t%.4f\t%.4f\t%.4f', err_sgnd));
end