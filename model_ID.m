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
    case 'l0'
        model_ID = 8;
    case 'l1'
        model_ID = 9;
    case 'nok_l1'
        model_ID = 10;
    case 'nok_l0'
        model_ID = 11;
    case 'nok_mf'
        model_ID = 12;
    case 'nok_mb'
        model_ID = 13;
    case 'a1b1_nok'
        model_ID = 14;
    case 'a1b1_l0_nopk'
        model_ID = 15;
    case 'a1b1_l0_nok'
        model_ID = 16;        
    case 'test'
        model_ID = 18;
end