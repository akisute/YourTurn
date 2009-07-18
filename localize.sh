#/usr/bin/env sh
genstrings -a $(find . -name "*.m") 
echo "Localizable.strings has been created."
