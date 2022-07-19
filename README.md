# wrf_emep_cwl_workflow

Example CWL workflow and tool descriptors for running WPS and WRF.

Requirements:
 * docker
 * CWL (install `cwltool` from `conda-forge` channel using `conda`)
 * example data: https://www.dropbox.com/s/ge0wnt2hqi5ndkp/wrf_docker_example_data.tar.gz
   * download and extract in your repository directory

Running the Workflows:
 * `cwltool --relax-path-checks cwl/wps_workflow.cwl wps_cwl_settings.yaml`
 * `cwltool --relax-path-checks cwl/wrf_workflow.cwl wrf_real_cwl_settings.yaml`

Notes:
 * `--relax-path-checks` is needed because many wrf filenames contain special characters (`:`)
 * default core usage is 4 cores for real, 8 for wrf. Edit `wrf_real_cwl_settings.yaml` to adjust for your system
 * WRF runtime will be long (a day or more) - edit end time in `namelist_cwl_dir/namelist.input` to reduce this for your tests

Hints:
 * add `--cachedir cache-dir` (making sure to create the `cache-dir` directory first), to enable caching of the intermediate results
 * add `--parallel` to run steps in parallel (if possible)