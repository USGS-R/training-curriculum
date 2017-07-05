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
This lesson will teach you how to manage your ScienceBase items and folders from R. **\[why is this useful???\]** You can add, remove, or edit ScienceBase items from R. The first half of the lesson will show you how to modify existing items, and the second half will how you how to add or remove items.

The following sections contain functions you would use to modify ScienceBase items from R. Keep in mind that most functions start with `item_*` (singular). These limit the input for only one item at a time. If you have more than one, you can use the equivalent `items_*` (plural) functions, which can accept single or multiple item values.

In these examples, you will be modifying ScienceBase items. These assume you have an account and are logged in. Refer to the [previous lesson](#sbtools-download) for information on logging in.

All the functions used here will have either `parent_id` or `sb_id` as the first argument. `parent_id` is looking for information on the location to create a new item or folder. Sometimes this defaults to your user account, but can be overridden with an object of class `sbitem` or the ScienceBase ID as a character value. The `sb_id` argument does not have a default and is looking for the ID of the ScienceBase item you are modifying. You can give this either the character string of the ScienceBase item ID or an object of class `sbitem`.

``` r
authenticate_sb()
```

Creating ScienceBase items and "folders"
----------------------------------------

ScienceBase can be used to create a hierarchical organization for projects. To do this, we can create folders and items within those folders directly from R using `sbtools`.

This section will give examples for the following functions:

-   `folder_create`
-   `item_create`
-   `items_create`

First, we will create a folder named "usgs-r-pkgs-test". Make this folder "top-level" under your user account. So, leave the default for the `parent_id` argument.

``` r
new_folder <- folder_create(name = "usgs-r-pkgs-test")
```

Now, create a single item inside of the newly created folder. To do this, use the `sbitem` object from the previous step as the `parent_id` here.

``` r
item_create(parent_id = new_folder, title = "single item")
```

Next, add three items at once. Nest the first two items under the new folder, and the last one as a top-level folder.

**introduce user\_id() somewhere**

``` r
items_create(parent_id = list(new_folder, new_folder, user_id()),
             title = c("item 1", "item 2", "item 3"))
```

Now navigate to your user account. You should see two items: "item 3" and the new folder "usgs-r-pkgs-test" with 3 nested items named "single item", "item 1", and "item 2".

Uploading your files
--------------------

You can upload files directly from R to an existing or new ScienceBase item. All you need to do is select the appropriate function and get the file names. There are a few helper functions from base R that might be useful when working with files and filepaths: `list.dirs`, `list.files`, `file.path`, `dir.exists`, `file.exists`, `system.file`. Some may be shown in these examples, but explore them in more detail if they are unfamiliar.

This section will give examples for the following functions:

-   `item_upload_create`
-   `item_append_files`

To upload files to a new ScienceBase item, use the function `item_upload_create`. Start by creating a new item and uploading the first two files available in the `sbtools` package.

``` r
dir <- system.file("examples", package="sbtools")
sbtools_files <- file.path(dir, list.files(dir)[1:2])
item_upload_create(parent_id = user_id(),
                   files = sbtools_files)
```

Verify that your new item was created by using functions introduced in the previous lesson.

``` r
item_exists()
item_list_files()
```

Now that you have an `sbitem`, append an additional file to it using the `item_append_files` function. Use the third file available in `sbtools`.

``` r
another_sbtools_file <- file.path(dir, list.files(dir)[2])
item_append_files(parent_id = user_id(),
                   files = another_sbtools_file)
```

Now verify that this new file was added to the existing item.

``` r
item_list_files()
```

Organizing and querying your files
----------------------------------

This section will give examples for the following functions:

-   `items_update`
-   `items_upsert`
-   `item_move`
-   `item_update`
-   `item_update_identifier`
-   `item_upsert`

Replacing and deleting your files
---------------------------------

This section will give examples for the following functions:

*`item_rename_files` *`item_replace_files` *`item_rm` *`item_rm_files`
