# wrf_emep_cwl_workflow

Example CWL workflow and tool descriptors for running WPS and WRF.

Requirements:

* docker
* CWL (use `conda` to install `cwltool` from `conda-forge` channel)
* example data: https://www.dropbox.com/s/d1y405qs4c477ol/wps_wrf_uk9km_example_input.tar.gz
  * download and extract in your repository directory, this will create the `ungrib_test_input` and `real_wrf_test_input` input directories.

Running the Workflows:

* `cwltool --relax-path-checks cwl/wps_workflow.cwl wps_cwl_settings.yaml`
* `cwltool --relax-path-checks cwl/wrf_workflow.cwl wrf_real_cwl_settings.yaml`

Notes:

* `--relax-path-checks` is needed because many wrf filenames contain special characters (`:`)
* default core usage is 2 cores for real, 2 for wrf. Edit `wrf_real_cwl_settings.yaml` to adjust for your system
* currently the WPS and WRF workflows are not linked (the `met_em*` files created by WPS have been included in the example input dataset)
* WRF runtime is currently 12 hours, but met inputs are available for up to 2 months run time if wanted. To change the runtime make these changes:
  * edit `ungrib_test_input/namelist.wps.emep_uk9km`
  * edit `real_wrf_test_input/namelist.input.uk9km`
  * after running WPS workflow, move `met_em*` files into `real_wrf_test_input/met_files`, replacing the files there

Hints:

* add `--cachedir cache-dir` (making sure to create the `cache-dir` directory first), to enable caching of the intermediate results
* add `--parallel` to run steps in parallel (if possible)