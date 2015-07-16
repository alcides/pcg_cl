#include "mwc64x.cl"
#include "pcg.cl"

__kernel void TestRng(__global uint *success)
{
	pcg32u_random_t a, b;
	pcg32_srandom_r(&a, 0, 1);
	uint lSuccess=1;
	
	for(uint dist=0;(dist<4096 && lSuccess);dist++){
		b=a;
		pcg32u_advance_r(&b, dist);
		for(uint i=0;i<dist;i++){
			pcg32u_random_r(&a);
		}
		//lSuccess &= (a.state==b.state);
	}
	
	*success=lSuccess;
}

// total is the number of words to output, must be divisible by 16*get_global_dim(0)
__kernel void DumpSamples(uint total, __global uint *data)
{
	ulong perStream=total/get_global_size(0);
	
	pcg32u_random_t rng;
	pcg32_srandom_r(&rng, 0, perStream);
	
	__global uint *dest=data+get_global_id(0)*perStream;
	for(uint i=0;i<perStream;i++){
		dest[i]=pcg32u_random_r(&rng);
	}
}

__kernel void EstimatePi(ulong n, ulong baseOffset, __global ulong *acc)
{
	pcg32u_random_t rng;
    ulong samplesPerStream=n/get_global_size(0);
	pcg32_srandom_r(&rng, baseOffset, 2*samplesPerStream);
    uint count=0;
    for(uint i=0;i<samplesPerStream;i++){
        ulong x=pcg32u_random_r(&rng);
        ulong y=pcg32u_random_r(&rng);
        ulong x2=x*x;
        ulong y2=y*y;
        if(x2+y2 >= x2)
            count++;
    }
	acc[get_global_id(0)] = count;
}
