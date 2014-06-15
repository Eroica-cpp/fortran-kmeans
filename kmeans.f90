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
		if (mod(1, 1) .eq. 0) then
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
	new_label = centroids(1, maxloc(distance_list, 1))

end function new_label

real(kind = 4) function distance(feature, feature2, max_keyword_num, points_num, len_list)

	implicit none
	integer, intent(in) :: points_num, max_keyword_num
	integer, intent(in) :: feature(2 + max_keyword_num)
	integer, intent(in) :: feature2(2 + max_keyword_num)
	integer, intent(in) :: len_list(points_num)
	integer :: i, sum

	! feature(1) is id
	do i = 1, len_list(feature(1))
		if ( any(feature(2+i) == feature2(3 : len_list(feature2(1)))) ) then
			sum = sum + 1
		end if
	end do

	distance = float(sum) / (len_list(feature(1)) * len_list(feature2(1)))

end function distance