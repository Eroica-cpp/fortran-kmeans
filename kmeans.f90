! k-means algorithm
! Author: Tao Li
! email: eroicacmcs@gmail.com
! Homepage: https://github.com/Eroica-cpp
!
! Pseudocode:
!***********************************
! var centroid_list					
! var points						
! 								
! points.init()						
! centroid_list.init()				
!								
! while(terminate condition){		
! 									
! 	for point in points {			
! 		point.update_lable()		
! 	}								
! 	centroid_list.update()			
! }									
!***********************************
!
! Description of Variables:
! @points, (id, label, keyword_list)
! @centroids, (id, label, keyword_list)
!

program kmeans

	implicit none
	integer, parameter :: k = 100, points_num = 69568, max_keyword_num = 500
	integer, parameter :: max_iter = 100
	integer, dimension(:), allocatable :: len_list
	integer, dimension(:, :), allocatable :: points, centroids
	integer :: i, loop = 1
	integer, dimension(4) :: test = (/1,12,3,4/)

	allocate(len_list(points_num))
	allocate(points(2 + max_keyword_num, points_num))
	allocate(centroids(2 + max_keyword_num, k))

	call lenlist_init(len_list, points_num)
	call points_init(points, points_num, max_keyword_num, len_list)
	call centroids_init(centroids, points, k, points_num, max_keyword_num, len_list)

	do while(loop <= max_iter)
		print *, loop
		call update_lable(centroids, points, k, points_num, max_keyword_num, len_list, loop)
		!call update_centroid(centroids, points, k, points_num, max_keyword_num, len_list, loop)
		loop = loop + 1
	end do

end program kmeans 

subroutine lenlist_init(len_list, points_num)

	implicit none
	integer, intent(in) :: points_num
	integer, intent(inout) :: len_list(points_num)
	
	open(unit = 11, file = "./data/len.txt")
	read(unit = 11, fmt = *) len_list
	close(11)

end subroutine lenlist_init

subroutine points_init(points, points_num, max_keyword_num, len_list)
	
	implicit none
	integer, intent(in) :: points_num, max_keyword_num
	integer, intent(inout) :: points(2 + max_keyword_num, points_num)
	integer, intent(in) :: len_list(points_num)
	integer :: i

	open(unit = 10, file = "./data/id_codeList.txt")
	do i = 1, points_num
		
		read(unit = 10, fmt = *) points(1 : len_list(i) + 2, i)
		if (mod(i, 1000) .eq. 0) then
			print *, "loading page:", i
		end if	
	end do
	close(10)
	
end subroutine points_init

subroutine centroids_init(centroids, points, k, points_num, max_keyword_num, len_list)
	
	implicit none
	integer, intent(in) :: k, points_num, max_keyword_num
	integer, intent(inout) :: centroids(2 + max_keyword_num, k)
	integer, intent(in) :: points(2 + max_keyword_num, points_num)
	integer, intent(in) :: len_list(points_num)
	integer :: i, step

	step = points_num / k
	do i = 1, k
		centroids(:, i) = points(:, 1 + (i-1) * step)
	end do

end subroutine centroids_init

subroutine update_lable(centroids, points, k, points_num, max_keyword_num, len_list, loop)

	implicit none
	integer, intent(in) :: k, points_num, max_keyword_num, loop
	integer, intent(in) :: centroids(2 + max_keyword_num, k)
	integer, intent(inout) :: points(2 + max_keyword_num, points_num)
	integer, intent(in) :: len_list(points_num)
	integer, external :: new_label
	integer :: feature(2 + max_keyword_num)
	integer :: i, j, label

	do i = 1, points_num
		! update label
		feature = points(:, i)
		label = new_label(feature, centroids, points_num, max_keyword_num, k, len_list)
		points(2, i) = label
		if (mod(i, 1000) .eq. 0) then
			print *, "i =", i, "label =", label, "loop =", loop, "done!"
		end if
	end do

end subroutine update_lable

integer function new_label(feature, centroids, points_num, max_keyword_num, k, len_list)
	
	implicit none
	integer, intent(in) :: k, points_num, max_keyword_num
	integer, intent(in) :: centroids(2 + max_keyword_num, k)
	integer, intent(in) :: len_list(points_num)
	integer, intent(in) :: feature(2 + max_keyword_num)
	real(kind = 4), external :: distance
	integer :: feature2(2 + max_keyword_num)
	real(kind = 4) :: distance_list(k)
	integer j

	do j = 1, k
		feature2 = centroids(:, j)
		distance_list(j) = distance(feature, feature2, max_keyword_num, points_num, len_list)
	end do 

	! use controids' id to represent the whole cluster
	new_label = centroids(1, minloc(distance_list, 1))

end function new_label

real(kind = 4) function distance(feature, feature2, max_keyword_num, points_num, len_list)

	implicit none
	integer, intent(in) :: points_num, max_keyword_num
	integer, intent(in) :: feature(2 + max_keyword_num)
	integer, intent(in) :: feature2(2 + max_keyword_num)
	integer, intent(in) :: len_list(points_num)
	integer :: i, sum

	sum = 0
	! feature(1) is id
	do i = 1, len_list(feature(1))
		if ( any(feature(2+i) == feature2(3 : len_list(feature2(1)))) ) then
			sum = sum + 1
		end if
	end do

	distance = 1.0 - float(sum) / (len_list(feature(1)) * len_list(feature2(1)))

end function distance

subroutine update_centroid(centroids, points, k, points_num, max_keyword_num, len_list, loop)

	implicit none
	integer, intent(in) :: k, points_num, max_keyword_num, loop
	integer, intent(inout) :: centroids(2 + max_keyword_num, k)
	integer, intent(in) :: points(2 + max_keyword_num, points_num)
	integer, intent(in) :: len_list(points_num)
	integer, external :: get_centroid
	integer :: cluster_ids(points_num)
	integer :: old_centroid_list(k)
	integer :: i, old_centroid, new_centroid
	
	old_centroid_list = centroids(1, :)
	
	do i = 1, k
		cluster_ids = 0
		old_centroid = old_centroid_list(i)
		call get_cluster(cluster_ids, points, old_centroid, k, points_num, max_keyword_num, len_list, loop)
		new_centroid = get_centroid(cluster_ids, points, points_num, max_keyword_num, loop, len_list)
		centroids(:, i) = points(:, new_centroid)
		print *, "cluster:", i, "has updated centroid!"
	end do

end subroutine update_centroid

subroutine get_cluster(cluster_ids, points, old_centroid, k, points_num, max_keyword_num, len_list, loop)

	implicit none
	integer, intent(in) :: k, points_num, max_keyword_num, loop, old_centroid
	integer, intent(in) :: points(2 + max_keyword_num, points_num)
	integer, intent(in) :: len_list(points_num)
	integer, intent(inout) :: cluster_ids(points_num)
	integer :: i, counter

	counter = 1
	do i = 1, points_num
		if (points(2, i) .eq. old_centroid) then
			cluster_ids(counter) = i
			counter = counter + 1
		end if
	end do

end subroutine get_cluster

integer function get_centroid(cluster_ids, points, points_num, max_keyword_num, loop, len_list)

	implicit none
	integer, intent(in) :: points_num, max_keyword_num, loop
	integer, intent(in) :: cluster_ids(points_num)
	integer, intent(in) :: len_list(points_num)
	integer, intent(in) :: points(2 + max_keyword_num, points_num)
	real(kind = 4), external :: distance
	real(kind = 4) :: avg_distance_list(points_num)
	real(kind = 4) :: avg_distance
	integer :: i, j, loc, iden, iden2, length

	avg_distance_list = 0.0
	length = 0

	! calculate length
	do i = 1, points_num
		if (cluster_ids(i) .eq. 0) then
			exit
		else
			length = length + 1
		end if		
	end do

	do i = 1, length
		iden = cluster_ids(i)

		! begin avg_distance 
		! calculate average distance of a single point
		avg_distance = 0.0
		do j = 1, length
			iden2 = cluster_ids(j)
			avg_distance = avg_distance + distance(points(:,iden), points(:, iden2), max_keyword_num, points_num, len_list)
			print *, "distance(points(:,iden), points(:, iden2), max_keyword_num, points_num, len_list)"
			print *, distance(points(:,iden), points(:, iden2), max_keyword_num, points_num, len_list)
		end do
		avg_distance_list(i) = avg_distance / length
		! end avg_distance 

		length = length + 1
		! test code
		print *, "i =", i, "in function get_centroid()", "avg_distance =", avg_distance

	end do

	loc = minloc(avg_distance_list(1:length), 1)
	get_centroid = cluster_ids(loc)

end function get_centroid