#!/bin/bash
# knit
# add >>>export PATH="$PATH:/usr/lib/rstudio/bin/pandoc"<<< to your PATH in order for knitting to work

# first, find out OS
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

# terminate if neither Linux nor Mac
# TODO: -a "$machine" != "Mac" 
if [ "$machine" != "Linux" ]; then
  echo "ERROR: Your OS is not supported, terminating."
  exit 1
fi

# find out checkpoint package date from main.Rmd
package_date_raw="$(grep -E "package_date\s<-\s\"[0-9]{4}\-[0-9]{2}\-[0-9]{2}\"" analysis/main.Rmd -o)"
# extract substring for date
package_date=${package_date_raw:16}

# find out system variables
platform="$(Rscript -e "version[[\"platform\"]]")"
r_version="$(Rscript -e "paste0(version[[\"major\"]], \".\", version[[\"minor\"]])")"
# remove leading [1]
platform=${platform:4}
r_version=${r_version:4}

# build up path
r_lib_path="~/.checkpoint/$package_date/lib/$platform/$r_version/"
# remove "
r_lib_path=${r_lib_path//\"/}

echo "setting $r_lib_path as R_LIBS"
# set correct checkpoint folder, so main.Rmd is knitted with historical rmarkdown package
export R_LIBS_USER=${r_lib_path}
Rscript -e 'library(rmarkdown); rmarkdown::render("analysis/main.Rmd", "html_document")' --no-site-file --no-init-file --no-restore --no-save || { echo "ERROR: knitting failed."; exit 1; }

# open browser
# TODO should probably be adapted for Mac OS
# xdg-open analysis/main.html