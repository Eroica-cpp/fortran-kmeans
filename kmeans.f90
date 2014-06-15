! k-means algorithm
! Author: Tao Li
! email: eroicacmcs@gmail.com
! Homepage: https://github.com/Eroica-cpp
!
! Pseudocode:
!***********************************!
! var centroid_list					!
! var points						!
! 									!
! points.init()						!
! centroid_list.init()				!
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
	integer, parameter :: k = 100, points_num = 69568, max_keyword_num = 500
	integer, dimension(:), allocatable :: len_list
	integer, dimension(:, :), allocatable :: points, centroids

	allocate(len_list(points_num))
	allocate(points(1 + max_keyword_num, points_num))
	allocate(centroids(1 + max_keyword_num, k))

	call lenlist_init(len_list, points_num)
	call points_init(points, points_num, max_keyword_num, len_list)
	! call centroids_init()

end program kmeans 

subroutine points_init(points, points_num, max_keyword_num, len_list)
	
	implicit none
	integer, intent(in) :: points_num, max_keyword_num
	integer, intent(inout) :: points(1 + max_keyword_num, points_num)
	integer, intent(in) :: len_list(points_num)
	integer :: i


	open(unit = 10, file = "./data/id_codeList.txt")
	do i = 1, points_num
		
		read(unit = 10, fmt = *) points(1 : len_list(i) + 1, i)
		print *, i
		
		if (i .eq. 1) then
			print *, points(1 : len_list(i) + 1, i)
			close(10)
			exit
		end if
	end do
	close(10)
	
end subroutine points_init

subroutine lenlist_init(len_list, points_num)

	implicit none
	integer, intent(in) :: points_num
	integer, intent(inout) :: len_list(points_num)
	
	open(unit = 11, file = "./data/len.txt")
	read(unit = 11, fmt = *) len_list
	close(11)

end subroutine lenlist_init