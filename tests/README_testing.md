## Code review

This README will show what to check during the code review process.
The scripts contain examples of how the analyses was done and the generated figures. 
Some of the scripts may redirect to other used functions which the reviewer might need to take a look at.

* The model classes are implemented here through [SEIV_diff_NE](./../src/models/SEIV_diff_NE.m) and used ordinary differential equations, given by [ode_funs](./../src/models/ode_funs.m)
* The other functions used in the script (which do not need review) are, [inferece_script](./../inference_script.m), [find_confidence_intervals](./../tools/find_confidence_interval_looped.m) and [get_dirstr](./../src/get_dirstr.m)