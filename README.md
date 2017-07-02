# rddj-template

*A template for bootstrapping reproducible RMarkdown documents for data journalistic purposes.*

## Features

* Comes with cutting-edge, tried-and-tested packages for efficient data journalism with R, such as the `tidyverse`
* *Full* **reproducibility** with package snapshots (thanks to the `checkpoint` package)
* Runs out of the box and in one go, user doesn't have to have anything pre-installed (except R and maybe RStudio)
* Automatic deployment of knitted RMarkdown files (and zipped source code) to **GitHub pages**, see [this example](https://grssnbchr.github.io/rddj-template)
* Code **linting** according to the `tidyverse` style guide
* Preconfigured `.gitignore` which ignores shadow files, access tokens and the like per default
* Automatic working directory configuration for multiple users

*For more information please see the [accompanying blog post](https://timogrossenbacher.ch/2017/07/a-truly-reproducible-r-workflow/)*.

## Setup

First, clone and *reset* git repository. Also create `ignore` folders.

```
git clone https://github.com/grssnbchr/rddj-template.git
cd rddj-template
rm -rf .git
mkdir analysis/input/ignore
mkdir analysis/output/ignore
git init
```

If you have a remote repository, you can add it like so: 

```
git add remote origin https://github.com/user/repo.git
```

## Initial run

0. The main document `main.Rmd` lies in `analysis`.

1. Set config variables in the very first chunk and adapt your working directory (`path_to_wd`) in the second R chunk.

2. **RMarkdown**: To install the necessary packages for the given `package_date` and try-and-test the whole RMarkdown, knit it in **RStudio** (on Linux/Windows: <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>K</kbd>, on Mac: <kbd>Cmd</kbd>+<kbd>Shift</kbd>+<kbd>K</kbd>).

3. **Interpreter**: Also, instead of being knitted, the individual R chunks should be run in the interpreter once (`Code > Run Region > Run All`) on Linux/Windows: <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>R</kbd>, on Mac: <kbd>Cmd</kbd>+<kbd>Alt</kbd>+<kbd>R</kbd>). It is possible that some packages need to reinstalled or R restarted - confirm the respective prompt with "yes". 

It is recommended to restart R (`Session > Restart R`) between running chunks in the interpreter (e.g. `Run Current Chunk`) and knitting the whole RMarkdown. The use of `checkpoint` with both `knitr` and the ordinary interpreter is still a bit quirky (or I don't really understand it, could be the case too)

## *True* reproducibility with `checkpoint`

This template uses the [`checkpoint` package by Microsoft](https://mran.microsoft.com/documents/rro/reproducibility/#timemachine) for full package reproducibility. With this package, all necessary packages (specified in the `Define packages` R chunk) are from a certain CRAN snapshot which you can specify in the very same R chunk (`package_date`). For each `package_date`, the necessary source and compiled packages will be installed to a local `.checkpoint` folder that resides in your home directory. 

This has two big advantages:

1. All packages are from the same CRAN snapshot, i.e. are supposed to play nicely together.
2. If you re-run your script two or three years after initial creation, exactly those packages that were used at that point in time, that work with *your* code you wrote back then, are loaded and executed. No more deprecated code pieces and weird-looking `ggplot2` plots!

In order to make `checkpoint` work with `knitr`, [this vignette](https://github.com/RevolutionAnalytics/checkpoint/blob/master/vignettes/archive/using-checkpoint-with-knitr.Rmd) was adapted (it is now archived).

## Deployment to GitHub pages

The knitted RMarkdown may be deployed to a respective GitHub page. If your repository `repo` is public, it can then be accessed via `https://user.github.io/repo` (example: https://grssnbchr.github.io/rddj-template). In order to do that,

1. Knit your RMarkdown at least once (so there is a `main.html` in your analysis folder).

2. Make sure you're in the root folder of your project (the one above `analysis`)

3. Then locally create a `gh-pages` branch first, checkout master again and run the `deploy.sh` script in the root folder:

```
git checkout -b gh-pages
git checkout master
./deploy.sh
```

4. For further deployments, it sufficient to knit `main.Rmd` and re-run `./deploy.sh`. 

`deploy.sh` does the following: 

* Turn `main.html` into `index.html` so it can be rendered by GitHub pages.
* Bundle `main.Rmd`, `input`, `output` and `scripts` into a zipped folder `rscript.zip` so the repo can be easily downloaded by people who don't understand Git.
* Push everything to your remote `gh-pages` branch (will be created if not existing). 
* GitHub now builds the page and it should soon be accessible via `https://user.github.io/repo`.

## Linting / styleguide

Code is automatically *linted* with `lintr`, i.e. checked for good style and syntax errors according to the [tidyverse style guide](http://style.tidyverse.org/). When being knitted, the `lintr` output is at the very end of the document. When being interpreted, the `lintr` output appears in a new `Markers` pane at the bottom of RStudio. If you want to disable linting, just comment that last line in `main.Rmd` out.

## Other stuff

### Versioning of input and output

`input` and `output` files are not ignored by default. This has the advantage that output can be monitored for change when (subtle) details of the R code are changed. 

If you want to ignore (big) input or output files, put them into the respective `ignore` folders. Git only allows a maximum file size of 100MB (or is it 50?).

### Ability to outsource code to script files

If you want to keep your `main.Rmd` as tidy and brief as possible, you have the possibility to put into 

### Optimal RStudio settings

It is recommended to disable workspace saving in RStudio, see  https://mran.microsoft.com/documents/rro/reproducibility/doc-research/ 