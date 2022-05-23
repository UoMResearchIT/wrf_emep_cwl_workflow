cwlVersion: v1.2
class: ExpressionTool
doc: |
  This javascript tool will extract, and tidy up, the run directory
  for WRF from the WRF docker container.
hints:
  DockerRequirement:
    dockerPull: oliverwoolland/wrf-docker:latest
requirements:
  InlineJavascriptRequirement: {}
  LoadListingRequirement:
    loadListing: shallow_listing
  InitialWorkDirRequirement:
    listing:
      - $(inputs.run_dir_location.listing)

inputs:
  run_dir_location:
    type: string
    default: "/usr/local/WRF/run"

outputs:
  rundir:
    label: Run directory
    type: Directory

expression: |
  ${
  var rundir_orig_array = scandir('.');
  var rundir_listing_array = [];
  
  if ( rundir_orig_array != null ){
    for (var i=0; i<rundir_orig_array.length; i++){
      if ( rundir_orig_array[i] != "namelist.input" & rundir_orig_array[i] != "*.exe" ){
        rundir_listing_array.push(rundir_orig_array[i])
      }
      rundir_listing_array.push(rundir_orig_array[i])
    }
  };
  
  return {"rundir":
      {"class": "Directory",
       "basename": "run",
       "listing": rundir_listing_array}
  };
  }