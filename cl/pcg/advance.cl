uchar pcg_advance_lcg_8(uchar state, uchar delta, uchar cur_mult,
                          uchar cur_plus)
{
    uchar acc_mult = 1u;
    uchar acc_plus = 0u;
    while (delta > 0) {
        if (delta & 1) {
            acc_mult *= cur_mult;
            acc_plus = acc_plus * cur_mult + cur_plus;
        }
        cur_plus = (cur_mult + 1) * cur_plus;
        cur_mult *= cur_mult;
        delta /= 2;
    }
    return acc_mult * state + acc_plus;
}

ushort pcg_advance_lcg_16(ushort state, ushort delta, ushort cur_mult,
                            ushort cur_plus)
{
    ushort acc_mult = 1u;
    ushort acc_plus = 0u;
    while (delta > 0) {
        if (delta & 1) {
            acc_mult *= cur_mult;
            acc_plus = acc_plus * cur_mult + cur_plus;
        }
        cur_plus = (cur_mult + 1) * cur_plus;
        cur_mult *= cur_mult;
        delta /= 2;
    }
    return acc_mult * state + acc_plus;
}


uint pcg_advance_lcg_32(uint state, uint delta, uint cur_mult,
                            uint cur_plus)
{
    uint acc_mult = 1u;
    uint acc_plus = 0u;
    while (delta > 0) {
        if (delta & 1) {
            acc_mult *= cur_mult;
            acc_plus = acc_plus * cur_mult + cur_plus;
        }
        cur_plus = (cur_mult + 1) * cur_plus;
        cur_mult *= cur_mult;
        delta /= 2;
    }
    return acc_mult * state + acc_plus;
}

ulong pcg_advance_lcg_64(ulong state, ulong delta, ulong cur_mult,
                            ulong cur_plus)
{
    ulong acc_mult = 1u;
    ulong acc_plus = 0u;
    while (delta > 0) {
        if (delta & 1) {
            acc_mult *= cur_mult;
            acc_plus = acc_plus * cur_mult + cur_plus;
        }
        cur_plus = (cur_mult + 1) * cur_plus;
        cur_mult *= cur_mult;
        delta /= 2;
    }
    return acc_mult * state + acc_plus;
}