# xswitch-testbench
SystemVerilog OOP reusable testbench for Xswitch.

# Usage:
## Regression Test
This command will run all testcases and merge the results into a single report.
### Functional Coverage
```
cd bin/
./regression_test.csh -fc
```
### Code Coverage
```
cd bin/
./regression_test.csh -cc
```
## Specific Testcase
This command will run the specified testcase and produce a test report.
### List Testcases
```
cd bin/
./testcases.csh -l
```
### Run Specific Testcase
```
cd bin/
./testcases.csh -t <test_sanity_check|test_reset|test_valid_in>
```
