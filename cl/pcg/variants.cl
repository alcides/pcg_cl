

// Rotate Helper Functions

inline uchar pcg_rotr_8(uchar value, unsigned int rot) {
	return (value >> rot) | (value << ((- rot) & 7));
}

inline ushort pcg_rotr_16(ushort value, unsigned int rot) {
    return (value >> rot) | (value << ((- rot) & 15));
}

inline uint pcg_rotr_32(uint value, unsigned int rot) {
    return (value >> rot) | (value << ((- rot) & 31));
}

inline ulong pcg_rotr_64(ulong value, unsigned int rot) {
    return (value >> rot) | (value << ((- rot) & 63));
}

// Output Functions

inline uchar pcg_output_xsh_rs_16_8(ushort state) {
    return (uchar)(((state >> 7u) ^ state) >> ((state >> 14u) + 3u));
}

inline ushort pcg_output_xsh_rs_32_16(uint state) {
    return (ushort)(((state >> 11u) ^ state) >> ((state >> 30u) + 11u));
}

inline uint pcg_output_xsh_rs_64_32(ulong state) {
    return (uint)(((state >> 22u) ^ state) >> ((state >> 61u) + 22u));
}

// XSH RR

inline uchar pcg_output_xsh_rr_16_8(ushort state)
{
    return pcg_rotr_8(((state >> 5u) ^ state) >> 5u, state >> 13u);
}

inline ushort pcg_output_xsh_rr_32_16(uint state)
{
    return pcg_rotr_16(((state >> 10u) ^ state) >> 12u, state >> 28u);
}

inline uint pcg_output_xsh_rr_64_32(ulong state)
{
    return pcg_rotr_32(((state >> 18u) ^ state) >> 27u, state >> 59u);
}


inline uchar pcg_output_rxs_m_xs_8_8(uchar state)
{
    uchar word = ((state >> ((state >> 6u) + 2u)) ^ state) * 217u;
    return (word >> 6u) ^ word;
}

inline ushort pcg_output_rxs_m_xs_16_16(ushort state)
{
    ushort word = ((state >> ((state >> 13u) + 3u)) ^ state) * 62169u;
    return (word >> 11u) ^ word;
}

inline uint pcg_output_rxs_m_xs_32_32(uint state)
{
    uint word = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;
    return (word >> 22u) ^ word;
}

inline ulong pcg_output_rxs_m_xs_64_64(ulong state)
{
    ulong word = ((state >> ((state >> 59u) + 5u)) ^ state)
                    * 12605985483714917081ul;
    return (word >> 43u) ^ word;
}


// XSL RR (only defined for >= 64 bits)

inline uint pcg_output_xsl_rr_64_32(ulong state)
{
    return pcg_rotr_32(((uint)(state >> 32u)) ^ (uint)state,
                       state >> 59u);
}

#define PCG_DEFAULT_MULTIPLIER_8   141U
#define PCG_DEFAULT_MULTIPLIER_16  12829U
#define PCG_DEFAULT_MULTIPLIER_32  747796405U
#define PCG_DEFAULT_MULTIPLIER_64  6364136223846793005UL

#define PCG_DEFAULT_INCREMENT_8    77U
#define PCG_DEFAULT_INCREMENT_16   47989U
#define PCG_DEFAULT_INCREMENT_32   2891336453U
#define PCG_DEFAULT_INCREMENT_64   1442695040888963407UL


struct pcg_state_8 {
    uchar state;
};

struct pcg_state_16 {
    ushort state;
};

struct pcg_state_32 {
    uint state;
};

struct pcg_state_64 {
    ulong state;
};

/* Representations setseq variants */

struct pcg_state_setseq_8 {
    uchar state;
    uchar inc;
};

struct pcg_state_setseq_16 {
    ushort state;
    ushort inc;
};

struct pcg_state_setseq_32 {
    uint state;
    uint inc;
};

struct pcg_state_setseq_64 {
    ulong state;
    ulong inc;
};


#include "pcg/advance.cl"


/* Functions to advance the underlying LCG, one version for each size and
 * each style.  These functions are considered semi-private.  There is rarely
 * a good reason to call them directly.
 */

inline void pcg_oneseq_8_step_r(struct pcg_state_8* rng)
{
    rng->state = rng->state * PCG_DEFAULT_MULTIPLIER_8
                 + PCG_DEFAULT_INCREMENT_8;
}

inline void pcg_oneseq_8_advance_r(struct pcg_state_8* rng, uchar delta)
{
    rng->state = pcg_advance_lcg_8(rng->state, delta, PCG_DEFAULT_MULTIPLIER_8,
                                   PCG_DEFAULT_INCREMENT_8);
}

inline void pcg_mcg_8_step_r(struct pcg_state_8* rng)
{
    rng->state = rng->state * PCG_DEFAULT_MULTIPLIER_8;
}

inline void pcg_mcg_8_advance_r(struct pcg_state_8* rng, uchar delta)
{
    rng->state
        = pcg_advance_lcg_8(rng->state, delta, PCG_DEFAULT_MULTIPLIER_8, 0u);
}

inline void pcg_unique_8_step_r(struct pcg_state_8* rng)
{
    rng->state = rng->state * PCG_DEFAULT_MULTIPLIER_8
                 + (uchar)(((intptr_t)rng) | 1u);
}

inline void pcg_unique_8_advance_r(struct pcg_state_8* rng, uchar delta)
{
    rng->state = pcg_advance_lcg_8(rng->state, delta, PCG_DEFAULT_MULTIPLIER_8,
                                   (uchar)(((intptr_t)rng) | 1u));
}

inline void pcg_setseq_8_step_r(struct pcg_state_setseq_8* rng)
{
    rng->state = rng->state * PCG_DEFAULT_MULTIPLIER_8 + rng->inc;
}

inline void pcg_setseq_8_advance_r(struct pcg_state_setseq_8* rng,
                                   uchar delta)
{
    rng->state = pcg_advance_lcg_8(rng->state, delta, PCG_DEFAULT_MULTIPLIER_8,
                                   rng->inc);
}

inline void pcg_oneseq_16_step_r(struct pcg_state_16* rng)
{
    rng->state = rng->state * PCG_DEFAULT_MULTIPLIER_16
                 + PCG_DEFAULT_INCREMENT_16;
}

inline void pcg_oneseq_16_advance_r(struct pcg_state_16* rng, ushort delta)
{
    rng->state = pcg_advance_lcg_16(
        rng->state, delta, PCG_DEFAULT_MULTIPLIER_16, PCG_DEFAULT_INCREMENT_16);
}

inline void pcg_mcg_16_step_r(struct pcg_state_16* rng)
{
    rng->state = rng->state * PCG_DEFAULT_MULTIPLIER_16;
}

inline void pcg_mcg_16_advance_r(struct pcg_state_16* rng, ushort delta)
{
    rng->state
        = pcg_advance_lcg_16(rng->state, delta, PCG_DEFAULT_MULTIPLIER_16, 0u);
}

inline void pcg_unique_16_step_r(struct pcg_state_16* rng)
{
    rng->state = rng->state * PCG_DEFAULT_MULTIPLIER_16
                 + (ushort)(((intptr_t)rng) | 1u);
}

inline void pcg_unique_16_advance_r(struct pcg_state_16* rng, ushort delta)
{
    rng->state
        = pcg_advance_lcg_16(rng->state, delta, PCG_DEFAULT_MULTIPLIER_16,
                             (ushort)(((intptr_t)rng) | 1u));
}

inline void pcg_setseq_16_step_r(struct pcg_state_setseq_16* rng)
{
    rng->state = rng->state * PCG_DEFAULT_MULTIPLIER_16 + rng->inc;
}

inline void pcg_setseq_16_advance_r(struct pcg_state_setseq_16* rng,
                                    ushort delta)
{
    rng->state = pcg_advance_lcg_16(rng->state, delta,
                                    PCG_DEFAULT_MULTIPLIER_16, rng->inc);
}

inline void pcg_oneseq_32_step_r(struct pcg_state_32* rng)
{
    rng->state = rng->state * PCG_DEFAULT_MULTIPLIER_32
                 + PCG_DEFAULT_INCREMENT_32;
}

inline void pcg_oneseq_32_advance_r(struct pcg_state_32* rng, uint delta)
{
    rng->state = pcg_advance_lcg_32(
        rng->state, delta, PCG_DEFAULT_MULTIPLIER_32, PCG_DEFAULT_INCREMENT_32);
}

inline void pcg_mcg_32_step_r(struct pcg_state_32* rng)
{
    rng->state = rng->state * PCG_DEFAULT_MULTIPLIER_32;
}

inline void pcg_mcg_32_advance_r(struct pcg_state_32* rng, uint delta)
{
    rng->state
        = pcg_advance_lcg_32(rng->state, delta, PCG_DEFAULT_MULTIPLIER_32, 0u);
}

inline void pcg_unique_32_step_r(struct pcg_state_32* rng)
{
    rng->state = rng->state * PCG_DEFAULT_MULTIPLIER_32
                 + (uint)(((intptr_t)rng) | 1u);
}

inline void pcg_unique_32_advance_r(struct pcg_state_32* rng, uint delta)
{
    rng->state
        = pcg_advance_lcg_32(rng->state, delta, PCG_DEFAULT_MULTIPLIER_32,
                             (uint)(((intptr_t)rng) | 1u));
}

inline void pcg_setseq_32_step_r(struct pcg_state_setseq_32* rng)
{
    rng->state = rng->state * PCG_DEFAULT_MULTIPLIER_32 + rng->inc;
}

inline void pcg_setseq_32_advance_r(struct pcg_state_setseq_32* rng,
                                    uint delta)
{
    rng->state = pcg_advance_lcg_32(rng->state, delta,
                                    PCG_DEFAULT_MULTIPLIER_32, rng->inc);
}

inline void pcg_oneseq_64_step_r(struct pcg_state_64* rng)
{
    rng->state = rng->state * PCG_DEFAULT_MULTIPLIER_64
                 + PCG_DEFAULT_INCREMENT_64;
}

inline void pcg_oneseq_64_advance_r(struct pcg_state_64* rng, ulong delta)
{
    rng->state = pcg_advance_lcg_64(
        rng->state, delta, PCG_DEFAULT_MULTIPLIER_64, PCG_DEFAULT_INCREMENT_64);
}

inline void pcg_mcg_64_step_r(struct pcg_state_64* rng)
{
    rng->state = rng->state * PCG_DEFAULT_MULTIPLIER_64;
}

inline void pcg_mcg_64_advance_r(struct pcg_state_64* rng, ulong delta)
{
    rng->state
        = pcg_advance_lcg_64(rng->state, delta, PCG_DEFAULT_MULTIPLIER_64, 0u);
}

inline void pcg_unique_64_step_r(struct pcg_state_64* rng)
{
    rng->state = rng->state * PCG_DEFAULT_MULTIPLIER_64
                 + (ulong)(((intptr_t)rng) | 1u);
}

inline void pcg_unique_64_advance_r(struct pcg_state_64* rng, ulong delta)
{
    rng->state
        = pcg_advance_lcg_64(rng->state, delta, PCG_DEFAULT_MULTIPLIER_64,
                             (ulong)(((intptr_t)rng) | 1u));
}

inline void pcg_setseq_64_step_r(struct pcg_state_setseq_64* rng)
{
    rng->state = rng->state * PCG_DEFAULT_MULTIPLIER_64 + rng->inc;
}

inline void pcg_setseq_64_advance_r(struct pcg_state_setseq_64* rng,
                                    ulong delta)
{
    rng->state = pcg_advance_lcg_64(rng->state, delta,
                                    PCG_DEFAULT_MULTIPLIER_64, rng->inc);
}

/* Functions to seed the RNG state, one version for each size and each
 * style.  Unlike the step functions, regular users can and should call
 * these functions.
 */

inline void pcg_oneseq_8_srandom_r(struct pcg_state_8* rng, uchar initstate)
{
    rng->state = 0U;
    pcg_oneseq_8_step_r(rng);
    rng->state += initstate;
    pcg_oneseq_8_step_r(rng);
}

inline void pcg_mcg_8_srandom_r(struct pcg_state_8* rng, uchar initstate)
{
    rng->state = initstate | 1u;
}

inline void pcg_unique_8_srandom_r(struct pcg_state_8* rng, uchar initstate)
{
    rng->state = 0U;
    pcg_unique_8_step_r(rng);
    rng->state += initstate;
    pcg_unique_8_step_r(rng);
}

inline void pcg_setseq_8_srandom_r(struct pcg_state_setseq_8* rng,
                                   uchar initstate, uchar initseq)
{
    rng->state = 0U;
    rng->inc = (initseq << 1u) | 1u;
    pcg_setseq_8_step_r(rng);
    rng->state += initstate;
    pcg_setseq_8_step_r(rng);
}

inline void pcg_oneseq_16_srandom_r(struct pcg_state_16* rng,
                                    ushort initstate)
{
    rng->state = 0U;
    pcg_oneseq_16_step_r(rng);
    rng->state += initstate;
    pcg_oneseq_16_step_r(rng);
}

inline void pcg_mcg_16_srandom_r(struct pcg_state_16* rng, ushort initstate)
{
    rng->state = initstate | 1u;
}

inline void pcg_unique_16_srandom_r(struct pcg_state_16* rng,
                                    ushort initstate)
{
    rng->state = 0U;
    pcg_unique_16_step_r(rng);
    rng->state += initstate;
    pcg_unique_16_step_r(rng);
}

inline void pcg_setseq_16_srandom_r(struct pcg_state_setseq_16* rng,
                                    ushort initstate, ushort initseq)
{
    rng->state = 0U;
    rng->inc = (initseq << 1u) | 1u;
    pcg_setseq_16_step_r(rng);
    rng->state += initstate;
    pcg_setseq_16_step_r(rng);
}

inline void pcg_oneseq_32_srandom_r(struct pcg_state_32* rng,
                                    uint initstate)
{
    rng->state = 0U;
    pcg_oneseq_32_step_r(rng);
    rng->state += initstate;
    pcg_oneseq_32_step_r(rng);
}

inline void pcg_mcg_32_srandom_r(struct pcg_state_32* rng, uint initstate)
{
    rng->state = initstate | 1u;
}

inline void pcg_unique_32_srandom_r(struct pcg_state_32* rng,
                                    uint initstate)
{
    rng->state = 0U;
    pcg_unique_32_step_r(rng);
    rng->state += initstate;
    pcg_unique_32_step_r(rng);
}

inline void pcg_setseq_32_srandom_r(struct pcg_state_setseq_32* rng,
                                    uint initstate, uint initseq)
{
    rng->state = 0U;
    rng->inc = (initseq << 1u) | 1u;
    pcg_setseq_32_step_r(rng);
    rng->state += initstate;
    pcg_setseq_32_step_r(rng);
}

inline void pcg_oneseq_64_srandom_r(struct pcg_state_64* rng,
                                    ulong initstate)
{
    rng->state = 0U;
    pcg_oneseq_64_step_r(rng);
    rng->state += initstate;
    pcg_oneseq_64_step_r(rng);
}

inline void pcg_mcg_64_srandom_r(struct pcg_state_64* rng, ulong initstate)
{
    rng->state = initstate | 1u;
}

inline void pcg_unique_64_srandom_r(struct pcg_state_64* rng,
                                    ulong initstate)
{
    rng->state = 0U;
    pcg_unique_64_step_r(rng);
    rng->state += initstate;
    pcg_unique_64_step_r(rng);
}

inline void pcg_setseq_64_srandom_r(struct pcg_state_setseq_64* rng,
                                    ulong initstate, ulong initseq)
{
    rng->state = 0U;
    rng->inc = (initseq << 1u) | 1u;
    pcg_setseq_64_step_r(rng);
    rng->state += initstate;
    pcg_setseq_64_step_r(rng);
}


/* Now, finally we create each of the individual generators. We provide
 * a random_r function that provides a random number of the appropriate
 * type (using the full range of the type) and a boundedrand_r version
 * that provides
 *
 * Implementation notes for boundedrand_r:
 *
 *     To avoid bias, we need to make the range of the RNG a multiple of
 *     bound, which we do by dropping output less than a threshold.
 *     Let's consider a 32-bit case...  A naive scheme to calculate the
 *     threshold would be to do
 *
 *         uint threshold = 0x100000000ull % bound;
 *
 *     but 64-bit div/mod is slower than 32-bit div/mod (especially on
 *     32-bit platforms).  In essence, we do
 *
 *         uint threshold = (0x100000000ull-bound) % bound;
 *
 *     because this version will calculate the same modulus, but the LHS
 *     value is less than 2^32.
 *
 *     (Note that using modulo is only wise for good RNGs, poorer RNGs
 *     such as raw LCGs do better using a technique based on division.)
 *     Empricical tests show that division is preferable to modulus for
 *     reducting the range of an RNG.  It's faster, and sometimes it can
 *     even be statistically prefereable.
 */

/* Generation functions for XSH RS */

inline uchar pcg_oneseq_16_xsh_rs_8_random_r(struct pcg_state_16* rng)
{
    ushort oldstate = rng->state;
    pcg_oneseq_16_step_r(rng);
    return pcg_output_xsh_rs_16_8(oldstate);
}

inline uchar pcg_oneseq_16_xsh_rs_8_boundedrand_r(struct pcg_state_16* rng,
                                                    uchar bound)
{
    uchar threshold = ((uchar)(-bound)) % bound;
    for (;;) {
        uchar r = pcg_oneseq_16_xsh_rs_8_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline ushort pcg_oneseq_32_xsh_rs_16_random_r(struct pcg_state_32* rng)
{
    uint oldstate = rng->state;
    pcg_oneseq_32_step_r(rng);
    return pcg_output_xsh_rs_32_16(oldstate);
}

inline ushort pcg_oneseq_32_xsh_rs_16_boundedrand_r(struct pcg_state_32* rng,
                                                      ushort bound)
{
    ushort threshold = ((ushort)(-bound)) % bound;
    for (;;) {
        ushort r = pcg_oneseq_32_xsh_rs_16_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline uint pcg_oneseq_64_xsh_rs_32_random_r(struct pcg_state_64* rng)
{
    ulong oldstate = rng->state;
    pcg_oneseq_64_step_r(rng);
    return pcg_output_xsh_rs_64_32(oldstate);
}

inline uint pcg_oneseq_64_xsh_rs_32_boundedrand_r(struct pcg_state_64* rng,
                                                      uint bound)
{
    uint threshold = -bound % bound;
    for (;;) {
        uint r = pcg_oneseq_64_xsh_rs_32_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}


inline uchar pcg_unique_16_xsh_rs_8_random_r(struct pcg_state_16* rng)
{
    ushort oldstate = rng->state;
    pcg_unique_16_step_r(rng);
    return pcg_output_xsh_rs_16_8(oldstate);
}

inline uchar pcg_unique_16_xsh_rs_8_boundedrand_r(struct pcg_state_16* rng,
                                                    uchar bound)
{
    uchar threshold = ((uchar)(-bound)) % bound;
    for (;;) {
        uchar r = pcg_unique_16_xsh_rs_8_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline ushort pcg_unique_32_xsh_rs_16_random_r(struct pcg_state_32* rng)
{
    uint oldstate = rng->state;
    pcg_unique_32_step_r(rng);
    return pcg_output_xsh_rs_32_16(oldstate);
}

inline ushort pcg_unique_32_xsh_rs_16_boundedrand_r(struct pcg_state_32* rng,
                                                      ushort bound)
{
    ushort threshold = ((ushort)(-bound)) % bound;
    for (;;) {
        ushort r = pcg_unique_32_xsh_rs_16_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline uint pcg_unique_64_xsh_rs_32_random_r(struct pcg_state_64* rng)
{
    ulong oldstate = rng->state;
    pcg_unique_64_step_r(rng);
    return pcg_output_xsh_rs_64_32(oldstate);
}

inline uint pcg_unique_64_xsh_rs_32_boundedrand_r(struct pcg_state_64* rng,
                                                      uint bound)
{
    uint threshold = -bound % bound;
    for (;;) {
        uint r = pcg_unique_64_xsh_rs_32_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline uchar pcg_setseq_16_xsh_rs_8_random_r(struct pcg_state_setseq_16* rng)
{
    ushort oldstate = rng->state;
    pcg_setseq_16_step_r(rng);
    return pcg_output_xsh_rs_16_8(oldstate);
}

inline uchar
pcg_setseq_16_xsh_rs_8_boundedrand_r(struct pcg_state_setseq_16* rng,
                                     uchar bound)
{
    uchar threshold = ((uchar)(-bound)) % bound;
    for (;;) {
        uchar r = pcg_setseq_16_xsh_rs_8_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline ushort
pcg_setseq_32_xsh_rs_16_random_r(struct pcg_state_setseq_32* rng)
{
    uint oldstate = rng->state;
    pcg_setseq_32_step_r(rng);
    return pcg_output_xsh_rs_32_16(oldstate);
}

inline ushort
pcg_setseq_32_xsh_rs_16_boundedrand_r(struct pcg_state_setseq_32* rng,
                                      ushort bound)
{
    ushort threshold = ((ushort)(-bound)) % bound;
    for (;;) {
        ushort r = pcg_setseq_32_xsh_rs_16_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline uint
pcg_setseq_64_xsh_rs_32_random_r(struct pcg_state_setseq_64* rng)
{
    ulong oldstate = rng->state;
    pcg_setseq_64_step_r(rng);
    return pcg_output_xsh_rs_64_32(oldstate);
}

inline uint
pcg_setseq_64_xsh_rs_32_boundedrand_r(struct pcg_state_setseq_64* rng,
                                      uint bound)
{
    uint threshold = -bound % bound;
    for (;;) {
        uint r = pcg_setseq_64_xsh_rs_32_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}


/* Generation functions for XSH RR */

inline uchar pcg_oneseq_16_xsh_rr_8_random_r(struct pcg_state_16* rng)
{
    ushort oldstate = rng->state;
    pcg_oneseq_16_step_r(rng);
    return pcg_output_xsh_rr_16_8(oldstate);
}

inline uchar pcg_oneseq_16_xsh_rr_8_boundedrand_r(struct pcg_state_16* rng,
                                                    uchar bound)
{
    uchar threshold = ((uchar)(-bound)) % bound;
    for (;;) {
        uchar r = pcg_oneseq_16_xsh_rr_8_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline ushort pcg_oneseq_32_xsh_rr_16_random_r(struct pcg_state_32* rng)
{
    uint oldstate = rng->state;
    pcg_oneseq_32_step_r(rng);
    return pcg_output_xsh_rr_32_16(oldstate);
}

inline ushort pcg_oneseq_32_xsh_rr_16_boundedrand_r(struct pcg_state_32* rng,
                                                      ushort bound)
{
    ushort threshold = ((ushort)(-bound)) % bound;
    for (;;) {
        ushort r = pcg_oneseq_32_xsh_rr_16_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline uint pcg_oneseq_64_xsh_rr_32_random_r(struct pcg_state_64* rng)
{
    ulong oldstate = rng->state;
    pcg_oneseq_64_step_r(rng);
    return pcg_output_xsh_rr_64_32(oldstate);
}

inline uint pcg_oneseq_64_xsh_rr_32_boundedrand_r(struct pcg_state_64* rng,
                                                      uint bound)
{
    uint threshold = -bound % bound;
    for (;;) {
        uint r = pcg_oneseq_64_xsh_rr_32_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}


inline uchar pcg_unique_16_xsh_rr_8_random_r(struct pcg_state_16* rng)
{
    ushort oldstate = rng->state;
    pcg_unique_16_step_r(rng);
    return pcg_output_xsh_rr_16_8(oldstate);
}

inline uchar pcg_unique_16_xsh_rr_8_boundedrand_r(struct pcg_state_16* rng,
                                                    uchar bound)
{
    uchar threshold = ((uchar)(-bound)) % bound;
    for (;;) {
        uchar r = pcg_unique_16_xsh_rr_8_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline ushort pcg_unique_32_xsh_rr_16_random_r(struct pcg_state_32* rng)
{
    uint oldstate = rng->state;
    pcg_unique_32_step_r(rng);
    return pcg_output_xsh_rr_32_16(oldstate);
}

inline ushort pcg_unique_32_xsh_rr_16_boundedrand_r(struct pcg_state_32* rng,
                                                      ushort bound)
{
    ushort threshold = ((ushort)(-bound)) % bound;
    for (;;) {
        ushort r = pcg_unique_32_xsh_rr_16_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline uint pcg_unique_64_xsh_rr_32_random_r(struct pcg_state_64* rng)
{
    ulong oldstate = rng->state;
    pcg_unique_64_step_r(rng);
    return pcg_output_xsh_rr_64_32(oldstate);
}

inline uint pcg_unique_64_xsh_rr_32_boundedrand_r(struct pcg_state_64* rng,
                                                      uint bound)
{
    uint threshold = -bound % bound;
    for (;;) {
        uint r = pcg_unique_64_xsh_rr_32_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline uchar pcg_setseq_16_xsh_rr_8_random_r(struct pcg_state_setseq_16* rng)
{
    ushort oldstate = rng->state;
    pcg_setseq_16_step_r(rng);
    return pcg_output_xsh_rr_16_8(oldstate);
}

inline uchar
pcg_setseq_16_xsh_rr_8_boundedrand_r(struct pcg_state_setseq_16* rng,
                                     uchar bound)
{
    uchar threshold = ((uchar)(-bound)) % bound;
    for (;;) {
        uchar r = pcg_setseq_16_xsh_rr_8_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline ushort
pcg_setseq_32_xsh_rr_16_random_r(struct pcg_state_setseq_32* rng)
{
    uint oldstate = rng->state;
    pcg_setseq_32_step_r(rng);
    return pcg_output_xsh_rr_32_16(oldstate);
}

inline ushort
pcg_setseq_32_xsh_rr_16_boundedrand_r(struct pcg_state_setseq_32* rng,
                                      ushort bound)
{
    ushort threshold = ((ushort)(-bound)) % bound;
    for (;;) {
        ushort r = pcg_setseq_32_xsh_rr_16_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline uint
pcg_setseq_64_xsh_rr_32_random_r(struct pcg_state_setseq_64* rng)
{
    ulong oldstate = rng->state;
    pcg_setseq_64_step_r(rng);
    return pcg_output_xsh_rr_64_32(oldstate);
}

inline uint
pcg_setseq_64_xsh_rr_32_boundedrand_r(struct pcg_state_setseq_64* rng,
                                      uint bound)
{
    uint threshold = -bound % bound;
    for (;;) {
        uint r = pcg_setseq_64_xsh_rr_32_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}



inline uchar pcg_mcg_16_xsh_rr_8_random_r(struct pcg_state_16* rng)
{
    ushort oldstate = rng->state;
    pcg_mcg_16_step_r(rng);
    return pcg_output_xsh_rr_16_8(oldstate);
}

inline uchar pcg_mcg_16_xsh_rr_8_boundedrand_r(struct pcg_state_16* rng,
                                                 uchar bound)
{
    uchar threshold = ((uchar)(-bound)) % bound;
    for (;;) {
        uchar r = pcg_mcg_16_xsh_rr_8_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline ushort pcg_mcg_32_xsh_rr_16_random_r(struct pcg_state_32* rng)
{
    uint oldstate = rng->state;
    pcg_mcg_32_step_r(rng);
    return pcg_output_xsh_rr_32_16(oldstate);
}

inline ushort pcg_mcg_32_xsh_rr_16_boundedrand_r(struct pcg_state_32* rng,
                                                   ushort bound)
{
    ushort threshold = ((ushort)(-bound)) % bound;
    for (;;) {
        ushort r = pcg_mcg_32_xsh_rr_16_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline uint pcg_mcg_64_xsh_rr_32_random_r(struct pcg_state_64* rng)
{
    ulong oldstate = rng->state;
    pcg_mcg_64_step_r(rng);
    return pcg_output_xsh_rr_64_32(oldstate);
}

inline uint pcg_mcg_64_xsh_rr_32_boundedrand_r(struct pcg_state_64* rng,
                                                   uint bound)
{
    uint threshold = -bound % bound;
    for (;;) {
        uint r = pcg_mcg_64_xsh_rr_32_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}


/* Generation functions for RXS M XS (no MCG versions because they
 * don't make sense when you want to use the entire state)
 */

inline uchar pcg_oneseq_8_rxs_m_xs_8_random_r(struct pcg_state_8* rng)
{
    uchar oldstate = rng->state;
    pcg_oneseq_8_step_r(rng);
    return pcg_output_rxs_m_xs_8_8(oldstate);
}

inline uchar pcg_oneseq_8_rxs_m_xs_8_boundedrand_r(struct pcg_state_8* rng,
                                                     uchar bound)
{
    uchar threshold = ((uchar)(-bound)) % bound;
    for (;;) {
        uchar r = pcg_oneseq_8_rxs_m_xs_8_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline ushort pcg_oneseq_16_rxs_m_xs_16_random_r(struct pcg_state_16* rng)
{
    ushort oldstate = rng->state;
    pcg_oneseq_16_step_r(rng);
    return pcg_output_rxs_m_xs_16_16(oldstate);
}

inline ushort
pcg_oneseq_16_rxs_m_xs_16_boundedrand_r(struct pcg_state_16* rng,
                                        ushort bound)
{
    ushort threshold = ((ushort)(-bound)) % bound;
    for (;;) {
        ushort r = pcg_oneseq_16_rxs_m_xs_16_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline uint pcg_oneseq_32_rxs_m_xs_32_random_r(struct pcg_state_32* rng)
{
    uint oldstate = rng->state;
    pcg_oneseq_32_step_r(rng);
    return pcg_output_rxs_m_xs_32_32(oldstate);
}

inline uint
pcg_oneseq_32_rxs_m_xs_32_boundedrand_r(struct pcg_state_32* rng,
                                        uint bound)
{
    uint threshold = -bound % bound;
    for (;;) {
        uint r = pcg_oneseq_32_rxs_m_xs_32_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline ulong pcg_oneseq_64_rxs_m_xs_64_random_r(struct pcg_state_64* rng)
{
    ulong oldstate = rng->state;
    pcg_oneseq_64_step_r(rng);
    return pcg_output_rxs_m_xs_64_64(oldstate);
}

inline ulong
pcg_oneseq_64_rxs_m_xs_64_boundedrand_r(struct pcg_state_64* rng,
                                        ulong bound)
{
    ulong threshold = -bound % bound;
    for (;;) {
        ulong r = pcg_oneseq_64_rxs_m_xs_64_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}


inline ushort pcg_unique_16_rxs_m_xs_16_random_r(struct pcg_state_16* rng)
{
    ushort oldstate = rng->state;
    pcg_unique_16_step_r(rng);
    return pcg_output_rxs_m_xs_16_16(oldstate);
}

inline ushort
pcg_unique_16_rxs_m_xs_16_boundedrand_r(struct pcg_state_16* rng,
                                        ushort bound)
{
    ushort threshold = ((ushort)(-bound)) % bound;
    for (;;) {
        ushort r = pcg_unique_16_rxs_m_xs_16_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline uint pcg_unique_32_rxs_m_xs_32_random_r(struct pcg_state_32* rng)
{
    uint oldstate = rng->state;
    pcg_unique_32_step_r(rng);
    return pcg_output_rxs_m_xs_32_32(oldstate);
}

inline uint
pcg_unique_32_rxs_m_xs_32_boundedrand_r(struct pcg_state_32* rng,
                                        uint bound)
{
    uint threshold = -bound % bound;
    for (;;) {
        uint r = pcg_unique_32_rxs_m_xs_32_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline ulong pcg_unique_64_rxs_m_xs_64_random_r(struct pcg_state_64* rng)
{
    ulong oldstate = rng->state;
    pcg_unique_64_step_r(rng);
    return pcg_output_rxs_m_xs_64_64(oldstate);
}

inline ulong
pcg_unique_64_rxs_m_xs_64_boundedrand_r(struct pcg_state_64* rng,
                                        ulong bound)
{
    ulong threshold = -bound % bound;
    for (;;) {
        ulong r = pcg_unique_64_rxs_m_xs_64_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline uchar pcg_setseq_8_rxs_m_xs_8_random_r(struct pcg_state_setseq_8* rng)
{
    uchar oldstate = rng->state;
    pcg_setseq_8_step_r(rng);
    return pcg_output_rxs_m_xs_8_8(oldstate);
}

inline uchar
pcg_setseq_8_rxs_m_xs_8_boundedrand_r(struct pcg_state_setseq_8* rng,
                                      uchar bound)
{
    uchar threshold = ((uchar)(-bound)) % bound;
    for (;;) {
        uchar r = pcg_setseq_8_rxs_m_xs_8_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline ushort
pcg_setseq_16_rxs_m_xs_16_random_r(struct pcg_state_setseq_16* rng)
{
    ushort oldstate = rng->state;
    pcg_setseq_16_step_r(rng);
    return pcg_output_rxs_m_xs_16_16(oldstate);
}

inline ushort
pcg_setseq_16_rxs_m_xs_16_boundedrand_r(struct pcg_state_setseq_16* rng,
                                        ushort bound)
{
    ushort threshold = ((ushort)(-bound)) % bound;
    for (;;) {
        ushort r = pcg_setseq_16_rxs_m_xs_16_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline uint
pcg_setseq_32_rxs_m_xs_32_random_r(struct pcg_state_setseq_32* rng)
{
    uint oldstate = rng->state;
    pcg_setseq_32_step_r(rng);
    return pcg_output_rxs_m_xs_32_32(oldstate);
}

inline uint
pcg_setseq_32_rxs_m_xs_32_boundedrand_r(struct pcg_state_setseq_32* rng,
                                        uint bound)
{
    uint threshold = -bound % bound;
    for (;;) {
        uint r = pcg_setseq_32_rxs_m_xs_32_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline ulong
pcg_setseq_64_rxs_m_xs_64_random_r(struct pcg_state_setseq_64* rng)
{
    ulong oldstate = rng->state;
    pcg_setseq_64_step_r(rng);
    return pcg_output_rxs_m_xs_64_64(oldstate);
}

inline ulong
pcg_setseq_64_rxs_m_xs_64_boundedrand_r(struct pcg_state_setseq_64* rng,
                                        ulong bound)
{
    ulong threshold = -bound % bound;
    for (;;) {
        ulong r = pcg_setseq_64_rxs_m_xs_64_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

/* Generation functions for XSL RR (only defined for "large" types) */

inline uint pcg_oneseq_64_xsl_rr_32_random_r(struct pcg_state_64* rng)
{
    ulong oldstate = rng->state;
    pcg_oneseq_64_step_r(rng);
    return pcg_output_xsl_rr_64_32(oldstate);
}

inline uint pcg_oneseq_64_xsl_rr_32_boundedrand_r(struct pcg_state_64* rng,
                                                      uint bound)
{
    uint threshold = -bound % bound;
    for (;;) {
        uint r = pcg_oneseq_64_xsl_rr_32_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline uint pcg_unique_64_xsl_rr_32_random_r(struct pcg_state_64* rng)
{
    ulong oldstate = rng->state;
    pcg_unique_64_step_r(rng);
    return pcg_output_xsl_rr_64_32(oldstate);
}

inline uint pcg_unique_64_xsl_rr_32_boundedrand_r(struct pcg_state_64* rng,
                                                      uint bound)
{
    uint threshold = -bound % bound;
    for (;;) {
        uint r = pcg_unique_64_xsl_rr_32_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline uint
pcg_setseq_64_xsl_rr_32_random_r(struct pcg_state_setseq_64* rng)
{
    ulong oldstate = rng->state;
    pcg_setseq_64_step_r(rng);
    return pcg_output_xsl_rr_64_32(oldstate);
}

inline uint
pcg_setseq_64_xsl_rr_32_boundedrand_r(struct pcg_state_setseq_64* rng,
                                      uint bound)
{
    uint threshold = -bound % bound;
    for (;;) {
        uint r = pcg_setseq_64_xsl_rr_32_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline uint pcg_mcg_64_xsl_rr_32_random_r(struct pcg_state_64* rng)
{
    ulong oldstate = rng->state;
    pcg_mcg_64_step_r(rng);
    return pcg_output_xsl_rr_64_32(oldstate);
}

inline uint pcg_mcg_64_xsl_rr_32_boundedrand_r(struct pcg_state_64* rng,
                                                   uint bound)
{
    uint threshold = -bound % bound;
    for (;;) {
        uint r = pcg_mcg_64_xsl_rr_32_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

/* Generation functions for XSL RR RR (only defined for "large" types) */

inline ulong pcg_oneseq_64_xsl_rr_rr_64_random_r(struct pcg_state_64* rng)
{
    ulong oldstate = rng->state;
    pcg_oneseq_64_step_r(rng);
    return pcg_output_xsl_rr_rr_64_64(oldstate);
}

inline ulong
pcg_oneseq_64_xsl_rr_rr_64_boundedrand_r(struct pcg_state_64* rng,
                                         ulong bound)
{
    ulong threshold = -bound % bound;
    for (;;) {
        ulong r = pcg_oneseq_64_xsl_rr_rr_64_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline ulong pcg_unique_64_xsl_rr_rr_64_random_r(struct pcg_state_64* rng)
{
    ulong oldstate = rng->state;
    pcg_unique_64_step_r(rng);
    return pcg_output_xsl_rr_rr_64_64(oldstate);
}

inline ulong
pcg_unique_64_xsl_rr_rr_64_boundedrand_r(struct pcg_state_64* rng,
                                         ulong bound)
{
    ulong threshold = -bound % bound;
    for (;;) {
        ulong r = pcg_unique_64_xsl_rr_rr_64_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}

inline ulong
pcg_setseq_64_xsl_rr_rr_64_random_r(struct pcg_state_setseq_64* rng)
{
    ulong oldstate = rng->state;
    pcg_setseq_64_step_r(rng);
    return pcg_output_xsl_rr_rr_64_64(oldstate);
}

inline ulong
pcg_setseq_64_xsl_rr_rr_64_boundedrand_r(struct pcg_state_setseq_64* rng,
                                         ulong bound)
{
    ulong threshold = -bound % bound;
    for (;;) {
        ulong r = pcg_setseq_64_xsl_rr_rr_64_random_r(rng);
        if (r >= threshold)
            return r % bound;
    }
}



typedef struct pcg_state_setseq_64      pcg32_random_t;
typedef struct pcg_state_64             pcg32s_random_t;
typedef struct pcg_state_64             pcg32u_random_t;
typedef struct pcg_state_64             pcg32f_random_t;
//// random_r
#define pcg32_random_r                  pcg_setseq_64_xsh_rr_32_random_r
#define pcg32s_random_r                 pcg_oneseq_64_xsh_rr_32_random_r
#define pcg32u_random_r                 pcg_unique_64_xsh_rr_32_random_r
#define pcg32f_random_r                 pcg_mcg_64_xsh_rs_32_random_r
//// boundedrand_r
#define pcg32_boundedrand_r             pcg_setseq_64_xsh_rr_32_boundedrand_r
#define pcg32s_boundedrand_r            pcg_oneseq_64_xsh_rr_32_boundedrand_r
#define pcg32u_boundedrand_r            pcg_unique_64_xsh_rr_32_boundedrand_r
#define pcg32f_boundedrand_r            pcg_mcg_64_xsh_rs_32_boundedrand_r
//// srandom_r
#define pcg32_srandom_r                 pcg_setseq_64_srandom_r
#define pcg32s_srandom_r                pcg_oneseq_64_srandom_r
#define pcg32u_srandom_r                pcg_unique_64_srandom_r
#define pcg32f_srandom_r                pcg_mcg_64_srandom_r
//// advance_r
#define pcg32_advance_r                 pcg_setseq_64_advance_r
#define pcg32s_advance_r                pcg_oneseq_64_advance_r
#define pcg32u_advance_r                pcg_unique_64_advance_r
#define pcg32f_advance_r                pcg_mcg_64_advance_r



//// Typedefs
typedef struct pcg_state_8              pcg8si_random_t;
typedef struct pcg_state_16             pcg16si_random_t;
typedef struct pcg_state_32             pcg32si_random_t;
typedef struct pcg_state_64             pcg64si_random_t;
//// random_r
#define pcg8si_random_r                 pcg_oneseq_8_rxs_m_xs_8_random_r
#define pcg16si_random_r                pcg_oneseq_16_rxs_m_xs_16_random_r
#define pcg32si_random_r                pcg_oneseq_32_rxs_m_xs_32_random_r
#define pcg64si_random_r                pcg_oneseq_64_rxs_m_xs_64_random_r
//// boundedrand_r
#define pcg8si_boundedrand_r            pcg_oneseq_8_rxs_m_xs_8_boundedrand_r
#define pcg16si_boundedrand_r           pcg_oneseq_16_rxs_m_xs_16_boundedrand_r
#define pcg32si_boundedrand_r           pcg_oneseq_32_rxs_m_xs_32_boundedrand_r
#define pcg64si_boundedrand_r           pcg_oneseq_64_rxs_m_xs_64_boundedrand_r
//// srandom_r
#define pcg8si_srandom_r                pcg_oneseq_8_srandom_r
#define pcg16si_srandom_r               pcg_oneseq_16_srandom_r
#define pcg32si_srandom_r               pcg_oneseq_32_srandom_r
#define pcg64si_srandom_r               pcg_oneseq_64_srandom_r
//// advance_r
#define pcg8si_advance_r                pcg_oneseq_8_advance_r
#define pcg16si_advance_r               pcg_oneseq_16_advance_r
#define pcg32si_advance_r               pcg_oneseq_32_advance_r
#define pcg64si_advance_r               pcg_oneseq_64_advance_r



//// Typedefs
typedef struct pcg_state_setseq_8       pcg8i_random_t;
typedef struct pcg_state_setseq_16      pcg16i_random_t;
typedef struct pcg_state_setseq_32      pcg32i_random_t;
typedef struct pcg_state_setseq_64      pcg64i_random_t;
//// random_r
#define pcg8i_random_r                  pcg_setseq_8_rxs_m_xs_8_random_r
#define pcg16i_random_r                 pcg_setseq_16_rxs_m_xs_16_random_r
#define pcg32i_random_r                 pcg_setseq_32_rxs_m_xs_32_random_r
#define pcg64i_random_r                 pcg_setseq_64_rxs_m_xs_64_random_r
//// boundedrand_r
#define pcg8i_boundedrand_r             pcg_setseq_8_rxs_m_xs_8_boundedrand_r
#define pcg16i_boundedrand_r            pcg_setseq_16_rxs_m_xs_16_boundedrand_r
#define pcg32i_boundedrand_r            pcg_setseq_32_rxs_m_xs_32_boundedrand_r
#define pcg64i_boundedrand_r            pcg_setseq_64_rxs_m_xs_64_boundedrand_r
//// srandom_r
#define pcg8i_srandom_r                 pcg_setseq_8_srandom_r
#define pcg16i_srandom_r                pcg_setseq_16_srandom_r
#define pcg32i_srandom_r                pcg_setseq_32_srandom_r
#define pcg64i_srandom_r                pcg_setseq_64_srandom_r
//// advance_r
#define pcg8i_advance_r                 pcg_setseq_8_advance_r
#define pcg16i_advance_r                pcg_setseq_16_advance_r
#define pcg32i_advance_r                pcg_setseq_32_advance_r
#define pcg64i_advance_r                pcg_setseq_64_advance_r


#define PCG32_INITIALIZER       PCG_STATE_SETSEQ_64_INITIALIZER
#define PCG32U_INITIALIZER      PCG_STATE_UNIQUE_64_INITIALIZER
#define PCG32S_INITIALIZER      PCG_STATE_ONESEQ_64_INITIALIZER
#define PCG32F_INITIALIZER      PCG_STATE_MCG_64_INITIALIZER