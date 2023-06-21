## Code review

This README will show what to check during the code review process.
The scripts contain examples of how the analyses was done and the generated figures. 
Some of the scripts may redirect to other used functions which the reviewer might need to take a look at.



### ROADMAP: One step inference
Take a look at the [one_step_inference_examples](one_step_inference_examples) script to begin with, shown for one of the pairs of host and phage.
The script used the functions:
* [one_step_simulate](./../src/one-step-src/one_step_simulate) -- this further uses.
* [one_step_before_dilution](./../src/one-step-src/one_step_eqn_before_dilution) -- THIS FUNCTION CONTAINS THE DIFFERENTIAL EQUATIONS -- CHECK WITH SUPPLEMENTATY INFO PART S1.1 MODEL A.
<img width="391" alt="image" src="https://github.com/RaunakDey/VIMIMO-Virus-Microbe-modeller/assets/39820997/513250c5-e8cc-4afe-9a00-801dc6339a01">



### ROADMAP: Community inference.
Next, read community_inference_SEIVD -- this has both has SEIVD and SEIV.
* The model classes are implemented here through [SEIV_diff_NE](./../src/models/SEIV_diff_NE.m) and used ordinary differential equations, given by [ode_funs](./../src/models/ode_funs.m) -- please compare them against the equations given in the appendix
* The other functions used in the script (which do not need review) are, [inferece_script](./../inference_script.m), [find_confidence_intervals](./../tools/find_confidence_interval_looped.m) and [get_dirstr](./../src/get_dirstr.m)


### Figures from paper:


### Supplementary Information
 Next, look at the examples of how the supplementary figures were generated at supple_post_processing.
The figures are generated using the following scripts.
* [debris_plot](./../tools/debris_plot)
* [CV_NE](./../tools/CV_NE)
* [debris_plot](./../tools/debris_plot)
* [gelman2](./../tools/gelman2)
* [trace_plots_compare_V2](./../tools/trace_plots_compare_V2)
* [AIC_plot](./../tools/AIC_plot)



