Fortran K-Means
=======================
A Fortran library of K-means algorithm written in Fortran 90. Parallel computing techniques are applied to deal with high-dimensional sparse data with a focus of real-world Natural Language Processing (NLP) problems.

Prerequisite
----
* [GCC (version >= 2.7.0)](https://gcc.gnu.org/releases.html)
* A table contains (page id, key word list) pairs.

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


License
----
[The MIT License (MIT)](https://mit-license.org/)
