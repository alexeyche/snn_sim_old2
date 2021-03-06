
neuron_to_read = 2; syn_id=58; t_plot=1:1000
plot_stat = function(stat, cr, net, model, neuron_to_read =2, syn_id=58, t_plot=1:1000) {
    if(length(stat)==0) return
    listen_neuron = cr$sim_configuration$neurons_to_listen
    
    nstat_id = grep("NeuronStat", names(stat))
    if(length(nstat_id)>0) {
        nid = nstat_id[neuron_to_read]
        
        
        nst = stat[[nid]]
        #         par(mfrow=c(4,1))
        #         plot(nst[["u"]][t_plot], type="l")
        #         plot(nst[["p"]][t_plot], type="l")
        #         plot(nst[["M"]][t_plot], type="l")
        #         #sp = net[[listen_neuron]][net[[listen_neuron]]<1000]
        #         #plot(sp, rep(1, length(sp)), xlim=c(min(t_plot), max(t_plot)))
        #         syns = nst[["syns"]]
        #         if(length(syns)>0) {
        #             plot(syns[[1]][t_plot],type="l", ylim=c(0,3))
        #             for(i in 2:length(syns)) {
        #                 lines(syns[[i]][t_plot])
        #             }
        #         }
    }
    adex_stat_id = grep("AdExNeuronStat", names(stat))
    if(length(adex_stat_id)>0) {
        nid = adex_stat_id[neuron_to_read]
        
    }
    rew_stat_id = grep("RewardStat", names(stat))
    if(length(rew_stat_id)>0) {
        lid = rew_stat_id[1]
        
        rst = list(r=NULL, mean_r=NULL)
        for(old_ep in 1:1000) {
            old_stat_file = sprintf("%s/%s_stat.pb", workdir, old_ep)
            if(file.exists(old_stat_file)) {
                old_stat = RProto$new(old_stat_file)$read()
                old_rst = old_stat[[lid]]
                rst[["r"]] = c(rst[["r"]], old_rst[["r"]])
                rst[["mean_r"]] = c(rst[["mean_r"]], old_rst[["mean_r"]])
            } else {
                break
            }
        }            
        
        #rst = stat[[lid]]
        r = rst[["r"]]
        mean_r = rst[["mean_r"]]
        #plotl(r-mean_r)
    }
    maxl_stat_id = grep("MaxLikelihoodStat", names(stat))
    if(length(maxl_stat_id)>0) {
        id = maxl_stat_id[neuron_to_read]
        maxl = stat[[id]]
        tr = maxl[["traces"]]
        
        par(mfrow=c(3,1))
        #plot(nst[["p"]][t_plot], type="l")
        inp = any(sapply(cr$learning_rules, function(r) if("input_target" %in% names(r)) { r$input_target } else { FALSE } ))
        neuron_to_plot = listen_neuron
        if(inp) {
            neuron_to_plot = listen_neuron - sum(sapply(cr$sim_conf$input_layers_conf, function(l) l$size))
            syn_id = neuron_to_plot
        }
        sp = net[[neuron_to_plot+1]][ net[[neuron_to_plot+1]]<max(t_plot) ]
        sp = sp[ sp > min(t_plot) ]
        plot(sp, rep(1, length(sp)), xlim=c(min(t_plot), max(t_plot)))
        plot(nst[["syns"]][[syn_id+1]][t_plot], type="l")
        plot(tr[[syn_id]][t_plot], type="l")
    }
    opt_stdp_stat_id = grep("OptimalStdpStat", names(stat))
    mean_p_dur_min = min(sapply(cr$learning_rules, function(x) if("mean_p_dur" %in% names(x)) x$mean_p_dur else Inf))
    if((length(opt_stdp_stat_id)>0)&&(model[["sim_time"]]>=mean_p_dur_min)) {
        id = opt_stdp_stat_id[neuron_to_read]
        opt = stat[[id]]
        C = opt[["C"]]
        B = opt[["B"]]
        if(length(B) == 0) return();        
        
        neuron_to_plot = listen_neuron[neuron_to_read]
        par(mfrow=c(4,1))
        sp = net[[neuron_to_plot+1]][ net[[neuron_to_plot+1]]<max(t_plot) ]
        sp = sp[ sp > min(t_plot) ]
        plot(sp, rep(1, length(sp)), xlim=c(min(t_plot), max(t_plot)))
        plot(C[[syn_id]][t_plot], type="l", ylim=c(min(C[[syn_id]][t_plot]),max(C[[syn_id]][t_plot])))
        #plot(B[t_plot], type="l")
        plot(nst[["w"]][[syn_id]][t_plot], type="l")
        syns = nst[["syns"]]
        plot(syns[[syn_id]][t_plot],type="l", ylim=c(0,3))
        
        #         if(length(syns)>0) {
        #             plot(syns[[1]][t_plot],type="l", ylim=c(-3,3))
        #             for(i in 2:length(syns)) {
        #                 lines(syns[[i]][t_plot])
        #             }
        #         }
    }
    stdp_stat_id = grep("^StdpStat", names(stat)) 
    if(length(stdp_stat_id)>0) {
        id = stdp_stat_id[neuron_to_read]
        stdp = stat[[id]]
        
        par(mfrow=c(3,1))
        
        plot(nst[["w"]][[syn_id]][t_plot], type="l")            
        plot(stdp[["y_trace"]][t_plot], type="l")
        plot(stdp[["x_trace"]][[syn_id]][t_plot], type="l")
    }
    bcm_stat_id = grep("^BCMRuleStat", names(stat)) 
    if(length(bcm_stat_id)>0) {
        id = bcm_stat_id[neuron_to_read]
        bcm = stat[[id]]
        
        par(mfrow=c(4,1))
        
        plot(nst[["w"]][[syn_id]][t_plot], type="l")            
        plot(bcm[["p_acc"]][t_plot], type="l")
        plot(bcm[["y"]][t_plot], type="l")
        plot(bcm[["x"]][[syn_id]][t_plot], type="l")        
    }
    tr_stdp_stat_id = grep("^TripleStdpStat", names(stat)) 
    if(length(tr_stdp_stat_id)>0) {
        id = tr_stdp_stat_id[neuron_to_read]
        tr_stdp = stat[[id]]
        
        if(length(tr_stdp[["r2"]])>0) {
            par(mfrow=c(5,1))
        } else {
            par(mfrow=c(4,1))
        }
        
        plot(diff(nst[["w"]][[syn_id]][t_plot]), type="l", xlim=c(min(t_plot), max(t_plot)))
        plot(tr_stdp[["o1"]][t_plot], type="l", ylab="o1")
        plot(tr_stdp[["o2"]][t_plot], type="l", ylab="o2")
        plot(tr_stdp[["r1"]][[syn_id]][t_plot], type="l", ylab="r1")
        if(length(tr_stdp[["r2"]])>0) {
            plot(tr_stdp[["r2"]][[syn_id]][t_plot], type="l", ylab="r2")
        }
    }
}