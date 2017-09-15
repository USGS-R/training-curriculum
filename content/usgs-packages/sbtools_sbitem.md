---
author: Lindsay R. Carr
date: 9999-07-20
slug: sbtools-sbitem
title: sbtools - sbitem
draft: FALSE 
image: usgs-packages/static/img/sbtools.svg
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 32
---
"Items" are the objects in which ScienceBase stores and organizes data, and are necessary to understand for using `sbtools`. This lesson will introduce ScienceBase items and the R equivalent, `sbitem`.

What is a ScienceBase "item"?
-----------------------------

A ScienceBase "item" is the fundamental digital object available through ScienceBase. Items can contain files, contain and display metadata, or contain other items to create a hierarchical item/folder structure. Items all follow the same type of metadata model, so they have a structured format. Visit the [ScienceBase Items help page](https://www.sciencebase.gov/about/content/sciencebase-items) for more information, and look at the table below for some examples of items.

<!--html_preserve-->
<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="2" style="text-align: left;">
<caption>
Table 1. ScienceBase item examples.
</caption>
</td>
</tr>
<tr>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Item
</th>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Description
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
[Oil producer well: Record Number 2016815](https://www.sciencebase.gov/catalog/item/58a36dcbe4b0c82512870172)
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
a standalone item
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
[Bathymetric DEM of the lower Nooksack River, August 2015](https://www.sciencebase.gov/catalog/item/58c03c2de4b014cc3a3bb802)
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
item with files and metadata
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
[Data for calculating population, collision and displacement vulnerability among marine birds of the California Current System associated with offshore wind energy infrastructure](https://www.sciencebase.gov/catalog/item/5733bc85e4b0dae0d5dd627b)
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
item that contains files and child items
</td>
</tr>
</tbody>
</table>
<!--/html_preserve-->
What is an "sbitem"?
--------------------

An `sbitem` is the `sbtools` equivalent of ScienceBase items. In R, ScienceBase items are represented with the class `sbitem`, which is a lightweight representation containing the item's essential metadata. `sbitems` also contain links that allow you to query ScienceBase for even more information on the item.

Below is an example of what an `sbitem` looks like in R. [This item](https://www.sciencebase.gov/catalog/item/4f4e4b24e4b07f02db6aea14) was downloaded to the R object `itemexample`. The code to download this ScienceBase item will be explained in the lesson on [getting data from ScienceBase](/usgs-packages/sbtools-get).

``` r
# check class - it should be "sbitem"
class(itemexample)
```

    ## [1] "sbitem"

``` r
# all fields in sbitem
names(itemexample)
```

    ##  [1] "link"              "relatedItems"      "id"               
    ##  [4] "identifiers"       "title"             "citation"         
    ##  [7] "provenance"        "hasChildren"       "parentId"         
    ## [10] "contacts"          "webLinks"          "browseCategories" 
    ## [13] "browseTypes"       "tags"              "dates"            
    ## [16] "facets"            "files"             "distributionLinks"
    ## [19] "previewImage"

``` r
# view the item
itemexample
```

    ## <ScienceBase Item> 
    ##   Title: Coastal-change and glaciological maps of Antarctica
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):  2010-10-06T04:25:43Z / 2017-08-12T08:52:59Z
    ##   Children: FALSE
    ##   Item ID: 4f4e4b24e4b07f02db6aea14
    ##   Parent ID: 4f4e4771e4b07f02db47e1e4

There is a helper function available to verify that it has the `sbitem` class, `is.sbitem`. This would do the same check as `class(item) == "sbitem"`, just saves a bit of typing.

``` r
is.sbitem(itemexample)
```

    ## [1] TRUE

Additional item descriptions
----------------------------

In addition to metadata fields, ScienceBase items can be described by alternative identifiers, e.g. digital object identifiers, USGS Information Product Data System (IPDS) codes, etc. They can be useful to identify your items in searches because they have a user-defined type, scheme, and key.

For examples of identifiers, see the "Additional Information | Identifiers" section of [Differential Heating](https://www.sciencebase.gov/catalog/item/580587a2e4b0824b2d1c1f23) (one set of identifiers for a DOI which has a type/scheme/key) and [nwis\_01645704](https://www.sciencebase.gov/catalog/item/556f2055e4b0d9246a9fc9f7) (one set of identifiers; we invented the mda\_streams scheme, with associated types and keys, to organize items in one of our own projects). You could create your own scheme to organize items, or use some of the [standardized schemes](https://www.sciencebase.gov/vocab/categories?offset=10&max=10&parentId=528e99f7e4b05d51c7038afd) that ScienceBase offers. Alternative identifiers will be used when [introducing the function `identifier_exists`](usgs-packages/sbtools-get/#inspect-and-download-items).

Now that you understand the fundamental unit of ScienceBase and the `sbtools` equivalent unit, you can learn how to search ScienceBase for available data, download items, and modify or create items from R.
