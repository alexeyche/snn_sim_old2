# Spiking Neural Network Sim 
Simulator of Spiking Neural Network for time series related tasks

Snn_sim is multithreaded simulator of recurrent neural networks dynamics written in C++.  It is consist of various components which can be connected with each other in different combination:
* Neurons:
    * AdExNeuron - [Adaptive Exponential Integrate-and-fire](http://www.scholarpedia.org/article/Adaptive_exponential_integrate-and-fire_model)
    * SRMNeuron - [Spike-Response Model](http://www.scholarpedia.org/article/Spike-response_model)
* Synapses:
    * SimpleSynapse - static synapse, can be described by simple exponential decay 
    * DynamicSynapse - synapse with short-term memory ([Tsodyks et al](https://scholar.google.ru/scholar?hl=ru&q=tsodyks+markram+1997&btnG=))
* Activation functions:
    * Determ - Determinate threshold, neuron is firing if membrane reached threshold
    * ExpHennequin - Exponential version of activation function, it has specific increase near threshold value ([Hennequin et al](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3001990/))
* Learning rules:
    * OptimalStdp - Supposed to maximize pre-post information ([Toyoizumi et al](https://scholar.google.ru/citations?view_op=view_citation&hl=ru&user=wUcLR0QAAAAJ&citation_for_view=wUcLR0QAAAAJ:9yKSN-GCB0IC))
    * Stdp - Simple [spike-timing dependent plasticity](http://www.scholarpedia.org/article/STDP)
    * TripleStdp - Complicated version of Stdp with long range dynamics ([Pfister et al](https://scholar.google.ru/citations?view_op=view_citation&hl=ru&user=mzUYoLgAAAAJ&citation_for_view=mzUYoLgAAAAJ:u5HHmVD_uO8C))
    * MaxLikelihood - Only works with SRM neuron. It is just maximizing of likelikelhood of spikes, it is makes no sense in unsupervised way, so it needs to be supported by some reward mechanism
* Weight normalizations:
    * MeanActivityHomeostasis - Weight derivative is became bounded by neuron activity ([Carlson 2013 et al](https://scholar.google.ru/scholar?hl=ru&q=Biologically+plausible+models+of+homeostasis+and+STDP%3A+Stability+and+learning+in+spiking+neural+networks&btnG=))
    * MinMax - [link](http://www.scholarpedia.org/article/Spike-timing_dependent_plasticity)
    * SoftMinMax - [link](http://www.scholarpedia.org/article/Spike-timing_dependent_plasticity)
    * NonLinearMinMax - Nonlinear power-like factor on ltp and ltd ([Gutig et al. 2003](http://www.jneurosci.org/content/23/9/3697.long))
* Reward modulations:
     * Likelihood - it is simple SRM related term: <div> p * log(p) + (1-p) * log(1-p)</div>
     * InputClassification - modulate a reward if neuron is related to some class, firing of that neuron means voting for that class. LTP generated when neuron is successfully predicted class, and LTD in the opposite case
