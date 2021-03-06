---
author: Lindsay R. Carr
date: 9999-04-01
slug: app-part4
title: Application - Part 4, publish results
draft: FALSE 
image: usgs-packages/static/img/workflow.svg
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 44
---
In this section, we will complete the workflow and push the finished plots to ScienceBase from within the script. See the [previous section](/usgs-packages/app-part3) to see how we created the plots (or visit [Part 5](/usgs-packages/app-part5) to see the completed Part 3 code).

Create location to publish on SB
--------------------------------

The challenge with this application was to provide summaries of precipitation, nitrogen, and phosphorus data for a specific set of sites provided by a cooperator. The challenge was to automate the entire workflow, so the final step is to publish our results to ScienceBase. It would make sense to push the results to the same ScienceBase item that the cooperator provided for sites, but since this is an exercise and others will be completing it, we will save the results to a personal SB item.

Therefore, the first step is to create a folder under your user to save the results. Title this new item "USGS Pkgs Curriculum - application results". Visit the [sbtools modify lesson](/usgs-packages/sbtools-modify) to remind yourself how to do this. Try it on your own before expanding the solution code!

<button class="ToggleButton" onclick="toggle_visibility('create-new-item')">
Show Answer
</button>
              <div id="create-new-item" style="display:none">

``` r
# automatically created under the authenticated user
sb_results_item <- item_create(title = "USGS Pkgs Curriculum - application results")

# only create the item once, then just use its ID moving forward
sb_results_id <- sb_results_item$id
```

</div>
Publish plots and map images
----------------------------

Next upload the time series and map PNGs to ScienceBase. Remember, those file names are stored as the variables `site_fnames` and `map_fname`. Then, check to see if the files were successfully uploaded to SB.

<button class="ToggleButton" onclick="toggle_visibility('plots-publish')">
Show Answer
</button>
              <div id="plots-publish" style="display:none">

``` r
all_fnames <- c(site_fnames, map_fname)
updated_item <- item_append_files(sb_results_id, files = all_fnames)

# verify that files were uploaded
sb_fnames <- item_list_files(sb_results_id)
all(all_fnames %in% sb_fnames$fname)
```

    ## [1] TRUE

``` r
# now that they are online, remove local copies
rm_files <- file.remove(all_fnames) 
```

</div>
