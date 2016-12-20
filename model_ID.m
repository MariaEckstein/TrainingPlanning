function model_ID = model_ID(model_name)

switch model_name
    case 'mf'
        model_ID = 1;
    case 'mb'
        model_ID = 2;
    case 'hyb'
        model_ID = 3;
    case 'nop'
        model_ID = 4;
    case 'nok'
        model_ID = 5;
    case 'nopk'
        model_ID = 6;
    case 'a1b1'
        model_ID = 7;
end