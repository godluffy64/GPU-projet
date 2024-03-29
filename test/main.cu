#include <iostream>
#include <cstdlib>
#include <iomanip>

#include "utils/chronoCPU.hpp"
#include "utils/chronoGPU.hpp"
#include "los/ppm.hpp"
#include "carteCPU.hpp"

int main(int argc, char **argv)
{
	// Parse program arguments
	// ================================================================================================================
	// Allocation and initialization

	// ================================================================================================================

	// ================================================================================================================
	// CPU sequential
	std::cout << "============================================" << std::endl;
	std::cout << "         Sequential version on CPU          " << std::endl;
	std::cout << "============================================" << std::endl;


	std::vector<int> dda(1000, 0);

    Heightmap h_data("img/input/1.input.ppm");
    Heightmap h_out(h_data.getWidth(), h_data.getHeight());

	ChronoCPU chrCPU;
	chrCPU.start();		// CPU method
	drawMap(dda.data(), h_data, h_out, 245.f, 497.f);
	chrCPU.stop();

	const float timeComputeCPU = chrCPU.elapsedTime();
	std::cout << "-> Done : " << std::fixed << std::setprecision(2) << timeComputeCPU << " ms" << std::endl
			  << std::endl;

	// ================================================================================================================

	// ================================================================================================================
	// GPU CUDA
	std::cout << "============================================" << std::endl;
	std::cout << "          Parallel version on GPU           " << std::endl;
	std::cout << "============================================" << std::endl;

	// GPU allocation
	ChronoGPU chrGPU;
	chrCPU.start();	

	chrCPU.stop();
	// ======================

	const float timeAllocGPU = chrCPU.elapsedTime();
	std::cout << "-> Done : " << std::fixed << std::setprecision(2) << timeAllocGPU << " ms" << std::endl
			  << std::endl;

	// Copy from host to device
	std::cout << "Copying data from Host to Device" << std::endl;
	chrGPU.start();

	chrGPU.stop();

	const float timeHtoDGPU = chrGPU.elapsedTime();
	std::cout << "-> Done : " << timeHtoDGPU << " ms" << std::endl
			  << std::endl;


	// Launch kernel
	std::cout << "Summming vectors" << std::endl;
	chrGPU.start();	// GPU method

	chrGPU.stop();

	const float timeComputeGPU = chrGPU.elapsedTime();
	std::cout << "-> Done : " << std::fixed << std::setprecision(2) << timeComputeGPU << " ms" << std::endl
			  << std::endl;

	// copy from device to host
	std::cout << "Copying data from Device to Host" << std::endl;

	chrGPU.start();

	chrGPU.stop();
	const float timeDtoHGPU = chrGPU.elapsedTime();
	std::cout << "-> Done : " << std::fixed << std::setprecision(2) << timeDtoHGPU << " ms" << std::endl
			  << std::endl;

	// Free GPU memory

	// ================================================================================================================

	std::cout << "============================================" << std::endl;
	std::cout << "              Checking results              " << std::endl;
	std::cout << "============================================" << std::endl;



	std::cout << "Congratulations! Job's done!" << std::endl
			  << std::endl;

	std::cout << "============================================" << std::endl;
	std::cout << "            Times recapitulation            " << std::endl;
	std::cout << "============================================" << std::endl;
	std::cout << "-> CPU	Sequential" << std::endl;
	std::cout << "   - Computation:    " << std::fixed << std::setprecision(2)
			  << timeComputeCPU << " ms" << std::endl;
	std::cout << "-> GPU	" << std::endl;
	std::cout << "   - Allocation:     " << std::fixed << std::setprecision(2)
			  << timeAllocGPU << " ms " << std::endl;
	std::cout << "   - Host to Device: " << std::fixed << std::setprecision(2)
			  << timeHtoDGPU << " ms" << std::endl;
	std::cout << "   - Computation:    " << std::fixed << std::setprecision(2)
			  << timeComputeGPU << " ms" << std::endl;
	std::cout << "   - Device to Host: " << std::fixed << std::setprecision(2)
			  << timeDtoHGPU << " ms " << std::endl
			  << std::endl;

	return EXIT_SUCCESS;
}