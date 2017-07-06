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
This lesson will teach you how to manage your ScienceBase items and folders from R. **\[why is this useful???\]** The following sections contain functions you would use to modify ScienceBase items from R. Keep in mind that most functions start with `item_*` (singular). These limit the input for only one item at a time. If you have more than one, you can use the equivalent `items_*` (plural) functions, which can accept single or multiple item values.

In these examples, you will be modifying ScienceBase items. These assume you have an account and are logged in. Make sure to load `sbtools` and sign in to ScienceBase. Refer to the [previous lesson](#sbtools-download) for detailed information on authentication.

``` r
library(sbtools)
authenticate_sb()
```

All the functions used here will have either `parent_id` or `sb_id` as the first argument. `parent_id` is looking for information on the location to create a new item or folder. Sometimes this defaults to your user account, but can be overridden with an object of class `sbitem` or the ScienceBase ID as a character value. The `sb_id` argument does not have a default and is looking for an object of class `sbitem` or the ID of the ScienceBase item you are modifying.

Creating ScienceBase items
--------------------------

ScienceBase can be used to create a hierarchical organization for projects. To do this, we can create folders and items within those folders directly from R using `sbtools`.

This section will give examples for the following functions:

-   `folder_create`
-   `item_create`
-   `items_create`

First, we will create a folder named "usgs-r-pkgs-test". Make this folder "top-level" under your user account by using the default for the `parent_id` argument. Then, use `item_get` to see if the folder was actually created. It should return an error if the item does not exist.

``` r
new_folder <- folder_create(name = "usgs-r-pkgs-test")

# verify that it worked
is.sbitem(item_get(new_folder))
```

Now, create a single item inside of the newly created folder. To do this, use the `sbitem` object from the previous step as the `parent_id` here. Verify that the item was added to the folder.

``` r
new_item <- item_create(parent_id = new_folder, title = "single item")

# verify that it worked
is.sbitem(item_get(new_item))
"usgs-r-pkgs-test" == item_get_parent(new_item)$title
```

Next, add three items at once. Nest the first two items under the new folder, and the last one as a top-level folder.

**introduce user\_id() somewhere**

``` r
# this throws an error for right now
# Error: If parent_id length > 1, it must be of same length as title and info
# but I thought "info" was an optional parameter
add_mult <- items_create(parent_id = c(new_folder, new_folder, user_id()),
                         title = c("item 1", "item 2", "top-level item"))

is.sbitem(item_get(add_mult))
c("usgs-r-pkgs-test", "usgs-r-pkgs-test", "??") == item_get_parent(add_mult)$title
```

If you want to confirm with your own eyes, navigate to your user account. You should see two items: "top-level item" and the folder "usgs-r-pkgs-test" with 3 child items named "single item", "item 1", and "item 2".

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
sbtools_filepaths <- file.path(dir, sbtools_files)
test_item <- item_upload_create(parent_id = user_id(),
                                files = sbtools_filepaths)
test_item
```

Currently, the title of the new item defaults to the first file that is uploaded, and there is no argument to override this behavior. This is a known `sbtools` [issue](https://github.com/USGS-R/sbtools/issues/49). For now, you can change the title using the function `item_update`, which will be discusssed later in this lesson. Another interesting behavior is that uploading multiple files at once sometimes does not work for complex files. This is a [known issue](https://github.com/USGS-R/sbtools/issues/39). In the meantime, always verify that your files were actually uploaded.

Verify that your new item was created and the two files were added by using functions introduced in the previous lesson.

``` r
is.sbitem(item_get(test_item))
sbtools_files %in% item_list_files(test_item$id)$fname
```

Now that you have an ScienceBase item, you can append additional files to it using the `item_append_files` function. Use the third file available in `sbtools` to practice appending files. Then, verify that this new file was added to the existing item.

``` r
another_sbtools_file <- list.files(dir)[3]
another_sbtools_filepath <- file.path(dir, another_sbtools_file)
item_append_files(sb_id = test_item$id,
                  files = another_sbtools_filepath)

another_sbtools_file %in% item_list_files(test_item)$fname
```

Editing your items
------------------

You can move, edit, and update your files all from R using `sbtools` functions. This can be useful if you have edits that can be done in bulk, or want to automate the process.

This section will give examples for the following functions:

-   `items_update`
-   `item_update`
-   `items_upsert`
-   `item_upsert`
-   `item_update_identifier`

The first four functions have very similar behavior and syntax. The obvious difference is whether the function has `item` or `items` for updating an individual item or multiple items at once. The other is that there is "update" and "upsert". Update functions only work if the item already exists. Alternatively, "upsert" updates an existing item, but creates a new item if it doesn't already exist. So for an existing item, `*_update` and `*_upsert` functions have the same behavior.

To use these functions, you need to provide the `sbitem` or id and a list of the metadata info that you intend to update. The list should be key-value pairs of the metadata field and the corresponding value. These fields can be `title`, `browseCategories`, `contacts`, *etc?!?!*. The `*_upsert` functions also need the title of the SB item.................

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

``` r
item_update(test_item, info=list(title="sbtools stuff"))
```

``` r
item_update_identifier(test_item, "scheme", "type", "key")
```

//////// NOT FINISHED WITH THIS SECTION

Editing and removing your files
-------------------------------

In addition to updating ScienceBase items, `sbtools` has functions to edit files. You can rename, replace, or remove files within SB items.

This section will give examples for the following functions:

-   `item_rename_files`
-   `item_replace_files`
-   `item_rm_files`

To rename files of a ScienceBase item, you need to provide a vector of the file name(s) and a vector of new file names in the same order. Try renaming the `books.json` file to `bookinfo.json` using the `item_rename_files` function. Remember, this item saved as the R object `test_item`.

``` r
item_rename_files(test_item, names = "books.json", new_names = "bookinfo.json")
item_list_files(test_item) # verify the name change
```

To replace files of a ScienceBase item, **??????**

``` r
item_replace_files(test_item, sbtools_filepaths[1])
```

To remove files associated with a ScienceBase item, provide a vector of file names that you want to remove. If you leave the `files` argument empty, all files under the SB item provided will be removed. Try removing the `species.json` file from `sbitem` saved under the R object `test_item`.

``` r
item_rm_files(test_item, "species.json")
item_list_files(test_item) # verify species.json is removed
```

Now, try removing all remaining files from this item by not supplying anything to the argument `files`.

``` r
item_rm_files(test_item)
item_list_files(test_item) # verify that this is empty
```

Moving and removing items
-------------------------

You can relocate and delete items on ScienceBase from R as well. There are two functions that are used to do this:

-   `item_move`
-   `item_rm`

To move items to different parent items or folders, use the `item_move` function. It requires two arguments: the id or `sbitem` object of what you want to move, and the `sbitem` for where to move. As an example, let's move the `sbitem` saved as the R object `test_item` to the folder we created previously called "usgs-r-pkgs-test" which is saved as the `new_folder` object in R.

``` r
item_move(test_item, id_new = new_folder)

# verify it was moved by looking at the children of `new_folder`
item_list_children(new_folder)
```

To remove items, use the `item_rm` function. The only required argument is the `sbitem` or the SB id of the item you want to remove. Try removing the item we created that is saved as the R object `test_item`.

``` r
item_rm(test_item)

# verify that this no longer exists under the `new_folder`
item_list_children(new_folder)
```

In this lesson, we've added a few more items: "usgs-r-pkgs-test" folder and "top-level" item. Since this was all just to check out the functionality, let's remove these to get back to our original state. We already removed the "books.json" item, so remove the "usgs-r-pkgs-test" folder and the "top-level" item which were saved as the `sbitems` `new_folder` and `add_mult`, respectively. Note: the item saved in R as `new_folder` has child items, and you need to set the argument `recursive` to `TRUE` in order to remove an item that has children.

``` r
item_rm(new_folder, recursive = TRUE)
item_rm(add_mult)

# verify that those were removed by looking at what items are
# available through your account
sapply(item_list_children(user_id()), function(item) item$title)
```
