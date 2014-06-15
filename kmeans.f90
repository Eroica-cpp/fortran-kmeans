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
	integer, dimension(:), allocatable :: len_list
	integer, dimension(:, :), allocatable :: points, centroids
	integer :: i

	allocate(len_list(points_num))
	allocate(points(2 + max_keyword_num, points_num))
	allocate(centroids(2 + max_keyword_num, k))

	call lenlist_init(len_list, points_num)
	call points_init(points, points_num, max_keyword_num, len_list)
	call centroids_init(centroids, points, k, points_num, max_keyword_num, len_list)

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