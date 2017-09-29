ruby perf_rollup_timings.rb -i evm.log > perf_roll.txt
ruby perf_process_timings.rb -i evm.log > perf_proc.txt
ruby ems_refresh_timings.rb -i evm.log > refresh.txt
