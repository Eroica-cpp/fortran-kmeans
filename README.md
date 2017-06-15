Fortran K-Means
=======================
A Fortran library of K-means algorithm written in Fortran 90. Parallel computing techniques are applied to deal with high-dimensional sparse data with a focus of real-world Natural Language Processing (NLP) problems.

Prerequisite
----
* [GCC (version >= 2.7.0)](https://gcc.gnu.org/releases.html)
* Data files in `./data` folder with format: <*page_id*, *key_word_list*> pairs stored in plain text , separated by line. (see  [preprocess.py](https://github.com/Eroica-cpp/fortran-kmeans/blob/master/preprocess.py))

Algorithm
----
```Fortran
var centroid_list
var points

points.init()						
centroid_list.init()				

while(terminate condition){

    for point in points {			
        point.update_lable()
    }
    centroid_list.update()		
}
```

Usage
----
```Bash
# (optional) preprocess raw data files in ./data folder
python preprocess.py

# compile
gfortran kmeans.f90

# run
./a.out
```

License
----
[The MIT License (MIT)](https://mit-license.org/)
