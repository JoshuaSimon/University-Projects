# Parallel posterior computations for the binomial model.

import numpy as np
import multiprocessing as mp
from numba import jit, prange
from time import time


def mc_multi(chunk_len, parameters, delta_out):
    """ 
    Inner function for multiprocessing call. 
    Draws from a beta posterior.
    """
    delta = np.zeros(chunk_len)
    for r in prange(chunk_len):
        p_1 = (np.random.beta(parameters[0], parameters[1]))
        p_2 = (np.random.beta(parameters[2], parameters[3]))
        delta[r] = p_1 - p_2
    delta_out.append(delta)


def multi_monte_carlo(draws, parameters, num_threads):
    """ 
    Function for managing threads and process calls. 
    handles chunk splits. 
    """
    threads = []
    manager = mp.Manager()
    shared_list = manager.list()
    chunk_len = int(draws / num_threads)

    # Define the jobs for every thread.
    for i in range(0, num_threads):
        thread = mp.Process(target=mc_multi, args=(chunk_len, parameters, shared_list))
        threads.append(thread)

    # Start the threads.
    for j in threads:
        j.start()

    # Ensure all of the threads have finished.
    for j in threads:
       j.join()

    return shared_list


@jit(nopython=True, parallel=True)
def parallel_monte_carlo(draws, parameters):
    """ Parallel monte carlo simulation for draws from a beta posterior. """
    delta = np.zeros(draws)
    for r in prange(draws):
        p_1 = (np.random.beta(parameters[0], parameters[1]))
        p_2 = (np.random.beta(parameters[2], parameters[3]))
        delta[r] = p_1 - p_2

    return delta


def serial_monte_carlo(draws, parameters):
    """ Serial monte carlo simulation for draws from a beta posterior. """
    #delta = []
    delta = np.zeros(draws)
    for r in range(draws):
        p_1 = (np.random.beta(parameters[0], parameters[1]))
        p_2 = (np.random.beta(parameters[2], parameters[3]))
        delta[r] = p_1 - p_2
        #delta.append(p_1 - p_2)

    return delta

@jit(nopython=True, parallel=True)
def naive_mc(draws, parameters):
    """ Drawing form a beta posterior only using basic numpy functions. """
    p_1 = np.random.beta(parameters[0], parameters[1], draws)
    p_2 = np.random.beta(parameters[2], parameters[3], draws)
    return p_1 - p_2


if __name__ == "__main__":
    # Given data from example.
    n_1 = 10
    n_2 = 20
    y_1 = 6
    y_2 = 10

    # Parameters for Beta prior distribution.
    a_1 = 1
    b_1 = 1
    a_2 = 1
    b_2 = 1

    # Parameters for Beta posterior distribution.
    parameters = np.array([a_1 + y_1,
        b_1 + n_1 - y_1,
        a_2 + y_2,
        b_2 + n_2 - y_2])

    # Number of random drwas.
    draws = int(1e8)

    # Parallel execution.
    time_parallel = time()
    delta_parallel = parallel_monte_carlo(draws, parameters)
    #parallel_monte_carlo.parallel_diagnostics(level=4)
    time_parallel = time() - time_parallel
    print(f"Parallel execution time using numba: {time_parallel}.")

    # Multithreaded execution.
    cores = mp.cpu_count()
    time_multi = time()
    delta_multi = multi_monte_carlo(draws, parameters, cores)
    time_multi = time() - time_multi
    print(f"Multi threaded execution time on {cores} CPU cores: {time_multi}.")

    # Serial execution.
    time_serial = time()
    delta_serial = serial_monte_carlo(draws, parameters)
    time_serial = time() - time_serial
    print(f"Serial execution time on 1 CPU core: {time_serial}.")

    # Serial execution only using numpy.
    time_naive = time()
    delta_naive = naive_mc(draws, parameters)
    time_naive = time() - time_naive
    print(f"Serial execution time on 1 CPU core using numpy: {time_naive}.")


    # Validation.
    print(np.mean(delta_parallel), np.mean(delta_multi), np.mean(delta_serial), np.mean(delta_naive))
    print(len(delta_parallel), len(delta_multi), len(delta_serial), len(delta_naive))
