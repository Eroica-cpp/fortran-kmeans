! k-means algorithm
! Author: Tao Li
! email: eroicacmcs@gmail.com
!
! Pseudocode:
!***********************************!
! var centroid_list					!
! var points						!
! 									!
! centroid_list.init()				!
! points.init()						!
!									!
! while(terminate condition){		!
! 									!
! 	for point in points {			!
! 		point.update_lable()		!
! 	}								!
! 	centroid_list.update()			!
! }									!
!***********************************!

program kmeans

	implicit none
	integer, parameter :: k = 100, max_keyword_num = 500
	integer, dimension(:, :), allocatable :: centroids

	allocate(centroids(k, 1 + max_keyword_num))


end program kmeans 