##! Calculate the variance.
module SumStats;

@load base/frameworks/sumstats/plugins/variance

@load base/frameworks/sumstats/plugins/average


export {
	redef enum Calculation += {
		## Calculate the variation coefficient of the values.
		VARIATION_COEFFICIENT
	};

	redef record ResultVal += {
		## For numeric data, this is the variation coefficient.
		variation_coefficient: double &optional;
	};
}

redef record ResultVal += {
    variation_coefficient: double &default=0.0;
};

function calc_coef_var2(rv: ResultVal)
	{
		rv$variation_coefficient = (rv$num > 1 && rv$average > 0.0) ? sqrt(rv$variance)/(rv$average) : 0.0;
	}

hook coef_var_hook(r: Reducer, val: double, obs: Observation, rv: ResultVal)
	{
	calc_coef_var2(rv);
	}

hook register_observe_plugins() &priority=-10
	{
	register_observe_plugin(VARIATION_COEFFICIENT, function(r: Reducer, val: double, obs: Observation, rv: ResultVal)
		{
		calc_coef_var2(rv);
		});
	add_observe_plugin_dependency(VARIATION_COEFFICIENT, VARIANCE);
	add_observe_plugin_dependency(VARIATION_COEFFICIENT, AVERAGE);

	}

hook compose_resultvals_hook(result: ResultVal, rv1: ResultVal, rv2: ResultVal) &priority=-10
	{
	calc_coef_var2(result);
	}
