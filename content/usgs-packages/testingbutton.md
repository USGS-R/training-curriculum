---
author: Lindsay R. Carr
date: 
slug: testtesttest
title: TESTING BUTTON
draft: true 
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 2
---
To start, let's setup a geojob that fails.

<button class="ToggleButton" onclick="toggle_visibility('unnamed-chunk-1')">
Show Answer
</button>
              <div id="unnamed-chunk-1" style="display:none">

``` r
print('hello')
```

    ## [1] "hello"

</div>
try one without a button

``` r
print('bonjour')
```

then a third with the button

<button class="ToggleButton" onclick="toggle_visibility('unnamed-chunk-3')">
Show Answer
</button>
              <div id="unnamed-chunk-3" style="display:none">

``` r
print('ciao')
```

    ## [1] "ciao"

</div>
