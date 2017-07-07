---
author: Lindsay R. Carr
date: 9999-06-25
slug: sbtools-modify
title: sbtools - modify sbitems
draft: true 
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 2
---
This lesson will teach you how to manage your ScienceBase items and folders from R, which can be useful for batch or automated updates and edits. The following sections contain functions you would use to modify ScienceBase items from R. Keep in mind that most functions start with `item_*` (singular). These limit the input for only one item at a time. If you have more than one, you can use the equivalent `items_*` (plural) functions, which can accept single or multiple item values.

In these examples, you will be modifying ScienceBase items. These assume you have an account and are logged in (see `?authenticate_sb`). Make sure to load `sbtools` and sign in to ScienceBase. Refer to the [previous lesson](#sbtools-download) for detailed information on authentication.

``` r
library(sbtools)
```

All the functions used here will have either `parent_id` or `sb_id` as the first argument. `parent_id` is looking for information on the location to create a new item or folder. Sometimes this defaults to your user account, but can be overridden with an object of class `sbitem` or the ScienceBase ID as a character value. The `sb_id` argument does not have a default and is looking for an object of class `sbitem` or the ID of the ScienceBase item you are modifying.

In these functions, you might notice some `parent_id` arguments defaulting to `user_id()`. This is a function that returns the id for your ScienceBase account, and is frequently used when creating items. It can also be useful with the `item_list_*` functions taught in the previous lesson to see what items are saved under your account. If you are not authenticated, this will return an error.

    ## [1] "56215f74e4b06217fc478c3a"

    ## list()

    ## data frame with 0 columns and 0 rows

Creating ScienceBase items
--------------------------

ScienceBase can be used to create a hierarchical organization for projects. To do this, we can create folders and items within those folders directly from R using `sbtools`.

This section will give examples for the following functions:

-   `folder_create`
-   `item_create`
-   `items_create`

First, we will create a folder named "usgs-r-pkgs-test". Make this folder "top-level" under your user account by using the default for the `parent_id` argument, `user_id()`. Then, use `item_get` (introduced in the previous lesson) to see if the folder was actually created. It should return an error if the item does not exist.

``` r
new_folder <- folder_create(name = "usgs-r-pkgs-test")

# verify that it worked
is.sbitem(item_get(new_folder))
```

    ## [1] TRUE

Now, create a single item inside of the newly created folder. To do this, use the `sbitem` object from the previous step as the `parent_id` here. Verify that the item was added to the folder.

``` r
new_item <- item_create(parent_id = new_folder, title = "single item")

# verify that it worked
is.sbitem(item_get(new_item))
```

    ## [1] TRUE

``` r
"usgs-r-pkgs-test" == item_get_parent(new_item)$title
```

    ## [1] TRUE

Next, add three items at once. Nest the first two items under the new folder, and the last one as a top-level folder. Note that this currently does not do the expected behavior - it just puts everything under the new folder. This is a [known issue](https://github.com/USGS-R/sbtools/issues/242) in sbtools.

``` r
add_mult <- items_create(parent_id = list(new_folder, new_folder, user_id()),
                         title = c("item 1", "item 2", "top-level item"))

# verify that all three were successfully added
sapply(add_mult, function(item) is.sbitem(item_get(item)))
```

    ## [1] TRUE TRUE TRUE

``` r
# verify that they were put in the correct places
c("usgs-r-pkgs-test", "usgs-r-pkgs-test", item_get(user_id())$title) ==
  sapply(add_mult, function(item) item_get_parent(item)$title)
```

    ## [1]  TRUE  TRUE FALSE

If you want to confirm with your own eyes, navigate to your user account. You should see two items: "top-level item" and the folder "usgs-r-pkgs-test" with 3 child items named "single item", "item 1", and "item 2". **AGAIN, "top-level item" will not actually be top-level until [this issue](https://github.com/USGS-R/sbtools/issues/242) has been fixed, so the third item will return FALSE for the second verification step.**

Uploading your files
--------------------

You can upload files directly from R to an existing or new ScienceBase item. All you need to do is select the appropriate function and get the file names. There are a few helper functions from base R that might be useful when working with files and filepaths: `list.dirs`, `list.files`, `file.path`, `dir.exists`, `file.exists`, `system.file`. Some may be shown in these examples, but explore them in more detail if they are unfamiliar.

This section will give examples for the following functions:

-   `item_upload_create`
-   `item_append_files`

To upload files to a new ScienceBase item, use the function `item_upload_create`. This function creates a new item, and uploads new files simultaneously. Try it out by uploading the first two files available in the `sbtools` package to a new item.

``` r
dir <- system.file("examples", package="sbtools")
sbtools_files <- list.files(dir)[1:2]
sbtools_files
```

    ## [1] "books.json" "data.csv"

``` r
sbtools_filepaths <- file.path(dir, sbtools_files)
test_item <- item_upload_create(parent_id = user_id(),
                                files = sbtools_filepaths)
test_item
```

    ## <ScienceBase Item> 
    ##   Title: books.json
    ##   Creator/LastUpdatedBy:     lcarr@usgs.gov / lcarr@usgs.gov
    ##   Provenance (Created / Updated):  2017-07-07T14:58:56Z / 2017-07-07T14:58:56Z
    ##   Children: FALSE
    ##   Item ID: 595fa1b0e4b0d1f9f0586582
    ##   Parent ID: 56215f74e4b06217fc478c3a

Currently, the title of the new item defaults to the first file that is uploaded, and there is no argument to override this behavior. This is a known `sbtools` [issue](https://github.com/USGS-R/sbtools/issues/49). For now, you can change the title using the function `item_update`, which will be discusssed later in this lesson. Another interesting behavior is that uploading multiple files at once sometimes does not work for complex files. This is a [known issue](https://github.com/USGS-R/sbtools/issues/39). In the meantime, always verify that your files were actually uploaded.

``` r
is.sbitem(item_get(test_item))
```

    ## [1] TRUE

``` r
sbtools_files %in% item_list_files(test_item$id)$fname
```

    ## [1] TRUE TRUE

Now that you have a ScienceBase item, you can append additional files to it using the `item_append_files` function. Use the third file available in `sbtools` to practice appending files. Then, verify that this new file was added to the existing item.

``` r
another_sbtools_file <- list.files(dir)[3]
another_sbtools_filepath <- file.path(dir, another_sbtools_file)
item_append_files(sb_id = test_item$id,
                  files = another_sbtools_filepath)
```

    ## <ScienceBase Item> 
    ##   Title: books.json
    ##   Creator/LastUpdatedBy:     lcarr@usgs.gov / lcarr@usgs.gov
    ##   Provenance (Created / Updated):  2017-07-07T14:58:56Z / 2017-07-07T14:58:57Z
    ##   Children: FALSE
    ##   Item ID: 595fa1b0e4b0d1f9f0586582
    ##   Parent ID: 56215f74e4b06217fc478c3a

``` r
another_sbtools_file %in% item_list_files(test_item)$fname
```

    ## [1] TRUE

Editing your items
------------------

You can move, edit, and update your files all from R using `sbtools` functions. This can be useful if you have edits that can be done in bulk, or want to automate the process.

This section will give examples for the following functions:

-   `item_update`
-   `items_update`
-   `item_upsert`
-   `items_upsert`
-   `item_update_identifier`

The first four functions have very similar behavior and syntax. The obvious difference is whether the function has `item` or `items` for updating an individual item or multiple items at once. The other is that there is "update" and "upsert". Update functions only work if the item already exists. Alternatively, "upsert" updates an existing item, but creates a new item if it doesn't already exist. So for an existing item, `*_update` and `*_upsert` functions have the same behavior.

To use these functions, you need to provide the `sbitem` or id and a list of the metadata info that you intend to update. The list should be key-value pairs of the metadata field and the corresponding value. These fields can be `title`, `browseCategories`, `contacts`, etc. Additional fields can be found by looking at the [developer documentation for a SB item model](https://my.usgs.gov/confluence/display/sciencebase/ScienceBase+Item+Core+Model).

To update an existing item, use the `item_update` function. It requires two arguments: the `sbitem` and a list of the metadata key-values of what to change. Change the title of the item created earlier and saved as `test_item` in R to "sbtools example data". Then, look at the item title to verify.

``` r
# before
test_item$title
```

    ## [1] "books.json"

``` r
# update
updated_item <- item_update(test_item, info=list(title="sbtools example data"))

# after
updated_item$title
```

    ## [1] "sbtools example data"

You can also update multiple items at once using the plural of the function, `items_update`. Try adding a contact as metadata to each of the items under your user account. The `info` argument needs to be a list the same length as the number of sbitems you are updating. Each of these lists is a list with metadata key-value pairs. The contact metadata has a strange syntax where you need two additional nested lists.

``` r
all_items <- item_list_children(user_id())
update_contacts <- items_update(all_items, 
             info = 
               list(rep(list(contacts = list(list(name="Julius Caesar"))), 2)))

# verify that the contacts were added to all items
sapply(all_items, item_get_fields, fields="contacts")
```

    ## [[1]]
    ## [[1]]$name
    ## [1] "Julius Caesar"
    ## 
    ## 
    ## [[2]]
    ## [[2]]$name
    ## [1] "Julius Caesar"

If you want to update an item but it might not exist yet, use the `upsert` functions. Currently, this function is not working as you might expect. There are two `sbtools` issues that will address this: [issue 239](https://github.com/USGS-R/sbtools/issues/239) and [issue 240](https://github.com/USGS-R/sbtools/issues/240).

*EXAMPLES NOT CURRENTLY WORKING*

``` r
# creates a new item even though one already exists
item_upsert(title="books.json") 

# created another item with the name "books.json" with this message:
#   "title is NULL - re-using title from input SB item"
item_upsert(test_item, title=NULL, info=list(title = "sbtools stuff"))

# created a new item named "sbtools stuff" under the 
# books.json item
item_upsert(test_item, title="sbtools stuff")
```

Another way to edit or update SB items is to add alternative identifiers, e.g. digital object identifiers, IPDS codes, etc. They can be useful to identify your items in searches because they have a user-defined type, scheme, and key. For examples of identifiers, see the "Additional Information | Identifiers" section of [Differential Heating](https://www.sciencebase.gov/catalog/item/580587a2e4b0824b2d1c1f23) (two sets of identifiers, one for a DOI and one for an IPDS, each of which has type/scheme/key) and [nwis\_01645704](https://www.sciencebase.gov/catalog/item/556f2055e4b0d9246a9fc9f7) (one set of identifiers, created by us in our mda\_streams scheme to help us search for items). Here we will show how to add alternative identifiers. See ?`query_item_identifier` if you want to know more about querying by alternative identifiers.

Add identifiers to the item stored as the R object `test_item`.

``` r
item_update_identifier(test_item, scheme="example", type="sbtools", key="number 1")
```

    ## Response [https://www.sciencebase.gov/catalog/item/595fa1b0e4b0d1f9f0586582]
    ##   Date: 2017-07-07 14:58
    ##   Status: 200
    ##   Content-Type: application/json;charset=UTF-8
    ##   Size: 2.92 kB

``` r
item_get(test_item)$identifiers # verify that identifiers exist now
```

    ## [[1]]
    ## [[1]]$type
    ## [1] "sbtools"
    ## 
    ## [[1]]$scheme
    ## [1] "example"
    ## 
    ## [[1]]$key
    ## [1] "number 1"

Editing and removing your files
-------------------------------

In addition to updating ScienceBase items, `sbtools` has functions to edit files. You can rename, replace, or remove files within SB items.

This section will give examples for the following functions:

-   `item_rename_files`
-   `item_replace_files`
-   `item_rm_files`

To rename files of a ScienceBase item, you need to provide a vector of the file names and a vector of new file names in the same order. Try renaming the `books.json` file to `bookinfo.json` using the `item_rename_files` function.

``` r
renamed_item <- item_rename_files(test_item, names = "books.json", new_names = "bookinfo.json")
item_list_files(test_item)$fname # verify the name change
```

    ## [1] "species.json"  "bookinfo.json" "data.csv"

To replace files of a ScienceBase item, just provide the filepath for the new version and the `sbitem` that the file will be replacing. The filename of the replacement must match the one you are replacing.

``` r
# create a new file named bookinfo.json
fpath <- file.path(getwd(), 'bookinfo.json')
jsonlite::write_json(x = data.frame(author=c('JK Rowling'), book=c("Harry Potter")),
                     path = fpath)

# look at original file size
dplyr::filter(item_list_files(test_item), fname == "bookinfo.json")[['size']]
```

    ## [1] 1148

``` r
# replace with the new file
replaced_item <- item_replace_files(test_item, fpath)

# compare the new file size
dplyr::filter(item_list_files(replaced_item), fname == "bookinfo.json")[['size']]
```

    ## [1] 49

    ## [1] TRUE

To remove files associated with a ScienceBase item, provide a vector of file names that you want to remove. If you leave the `files` argument empty, all files under the SB item provided will be removed. Try removing the `species.json` file from `sbitem` saved under the R object `test_item`.

``` r
removed_file <- item_rm_files(test_item, "species.json")
item_list_files(test_item)$fname # verify species.json is removed
```

    ## [1] "bookinfo.json" "data.csv"

Now, try removing all remaining files from this item by not supplying anything to the argument `files`.

``` r
removed_all <- item_rm_files(test_item)
item_list_files(test_item) # verify that this is empty
```

    ## data frame with 0 columns and 0 rows

Moving and removing items
-------------------------

You can relocate and delete items on ScienceBase from R as well. There are two functions that are used to do this:

-   `item_move`
-   `item_rm`

To move items to different parent items or folders, use the `item_move` function. It requires two arguments: the id or `sbitem` object of what you want to move, and the `sbitem` for where to move. As an example, let's move the `sbitem` saved as the R object `test_item` to the folder we created previously called "usgs-r-pkgs-test" which is saved as the `new_folder` object in R.

``` r
moved_item <- item_move(test_item, id_new = new_folder)

# verify it was moved by looking at the parent of `moved_item`
"usgs-r-pkgs-test" == item_get_parent(moved_item)$title
```

    ## [1] TRUE

To remove items, use the `item_rm` function. The only required argument is the `sbitem` or the SB id of the item you want to remove. Try removing the item we created that is saved as the R object `moved_item`.

``` r
removed_item <- item_rm(moved_item)

# verify that this no longer exists under the `new_folder`
sapply(item_list_children(new_folder), function(item) item$title)
```

    ## [1] "item 2"               "sbtools example data" "item 1"              
    ## [4] "top-level item"       "single item"

In this lesson, we've added a few more items: "usgs-r-pkgs-test" folder and "top-level" item. Let's remove these to get back to our original state. We already removed the "books.json" item, so remove the "usgs-r-pkgs-test" folder and the "top-level" item which were saved as the `sbitems` `new_folder` and `add_mult[[3]]`, respectively. Note: the item saved in R as `new_folder` has child items, and you need to set the argument `recursive` to `TRUE` in order to remove an item that has children.

``` r
item_rm(new_folder, recursive = TRUE)
```

    ## [1] TRUE

``` r
# once top-level item is getting saved correctly:
# item_rm(add_mult[[3]])

# verify that those were removed by looking at what items are
# available through your account
sapply(item_list_children(user_id()), function(item) item$title)
```

    ## list()
