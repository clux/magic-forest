module class_Forest
    implicit none
    private
    public Forest, operator (==), operator(/=), operator(<)

    type Forest
        integer :: goats
        integer :: wolves
        integer :: lions
    contains
        procedure :: is_stable => forest_is_stable
        procedure :: is_valid => forest_is_valid

    end type Forest

    interface operator (==)
        procedure forest_equal
    end interface operator (==)

    interface operator (/=)
        procedure forest_not_equal
    end interface operator (/=)

    interface operator (<)
        procedure forest_less_than
    end interface operator (<)
contains
    pure function forest_is_stable(this) result(cond)
        class(Forest), intent(in) :: this
        logical :: cond
        cond = (this%goats == 0 .AND. (this%wolves == 0 .OR. this%lions == 0)) &
            &.OR. (this%wolves == 0 .AND. this%lions == 0)
    end function forest_is_stable

    pure function forest_is_valid(this) result(cond)
        class(Forest), intent(in) :: this
        logical :: cond
        cond = .NOT. (this%goats < 0 .OR. this%wolves < 0 .OR. this%lions < 0)
    end function forest_is_valid

    pure function forest_equal(this, other) result(cond)
        class(Forest), intent(in) :: this, other
        logical :: cond
        cond = this%goats == other%goats .AND. &
            & this%wolves == other%wolves .AND. &
            & this%lions == other%lions
    end function forest_equal

    pure function forest_not_equal(this, other) result(cond)
        class(Forest), intent(in) :: this, other
        logical :: cond
        cond = .NOT. (forest_equal(this, other))
    end function forest_not_equal

    pure function forest_less_than(this, other) result(cond)
        class(Forest), intent(in) :: this, other
        logical :: cond
        if (this%goats /= other%goats) then
            cond = this%goats < other%goats
            return
        else if (this%wolves /= other%wolves) then
            cond = this%wolves < other%wolves
            return
        else
            cond = this%lions < other%lions
            return
        end if
    end function forest_less_than
end module class_Forest

module solver
    use class_Forest

    implicit none
    private
    public solve

contains
    recursive subroutine quicksort(forests, first, last)
        type(Forest), dimension(:), allocatable, intent(inout) :: forests(:)
        integer, intent(in) :: first, last

        integer i, j
        type(Forest) :: middle, swap

        middle = forests( (first+last) / 2)
        i = first
        j = last
        do
            do while (forests(i) < middle)
                i = i+1
            end do
            do while (middle < forests(j))
                j = j-1
            end do
            if (i >= j) exit
            swap = forests(i); forests(i) = forests(j); forests(j) = swap
            i = i+1
            j = j-1
        end do
        if (first < i-1) call quicksort(forests, first, i-1)
        if (j+1 < last) call quicksort(forests, j+1, last)
    end subroutine quicksort

    ! this is the worst part of this module.
    ! usually you can apply any function for a fortran
    ! array and it will perform a map, but this does
    ! not work for classes for some reason so we
    ! have to write out the map function manually
    pure function are_stable(forests) result(conds)
        type(Forest), dimension(:), allocatable, intent(in) :: forests(:)
        logical, dimension(:), allocatable :: conds(:)

        type(Forest) :: current
        integer :: i

        allocate(conds(size(forests)))

        do i = 1, size(forests)
            current = forests(i)
            conds(i) = current%is_stable()
        end do
    end function are_stable

    pure function are_valid(forests) result(conds)
        type(Forest), dimension(:), allocatable, intent(in) :: forests(:)
        logical, dimension(:), allocatable :: conds(:)

        type(Forest) :: current
        integer :: i

        allocate(conds(size(forests)))

        do i = 1, size(forests)
            current = forests(i)
            conds(i) = current%is_valid()
        end do
    end function are_valid

    subroutine remove_dups(forests)
        type(Forest), dimension(:), allocatable, intent(inout) :: forests(:)
        type(Forest), dimension(:), allocatable :: temp(:)

        integer :: i, j
        if (size(forests) == 0 .OR. size(forests) == 1) return

        allocate(temp(size(forests)))

        j = 1
        do i = 1, size(forests)-1
            if (forests(i) /= forests(i+1)) then
                temp(j) = forests(i)
                j = j+1
            end if
        end do
        temp(j) = forests(i)
        deallocate(forests)
        allocate(forests(j))

        forests(1:j) = temp(1:j)
        deallocate(temp)
    end subroutine remove_dups

    function mutate(forests) result(next)
        type(Forest), dimension(:), allocatable :: forests(:), next(:)

        type(Forest) :: current
        integer :: i, j
        allocate(next(size(forests)*3))

        do i = 1, size(forests)
            j = (i * 3) - 2
            current = forests(i)
            next(j) = Forest(current%goats-1, current%wolves-1, current%lions+1)
            next(j+1) = Forest(current%goats-1, current%wolves+1, current%lions-1)
            next(j+2) = Forest(current%goats+1, current%wolves-1, current%lions-1)
        end do
        deallocate(forests)

        next = pack(next, are_valid(next))
        call quicksort(next, 1, size(next))
        call remove_dups(next)
    end function mutate

    function solve(initial) result(solution)
        type(Forest) :: initial
        type(Forest), dimension(:), allocatable :: solution

        allocate(solution(1))
        solution = [ initial ]

        do while ((.NOT. size(solution) == 0) .AND. .NOT. ANY(are_stable(solution)))
            solution = mutate(solution)
        end do

        ! this isn't the intended use of pack, but we can
        ! basically use it as a builtin filter function
        solution = pack(solution, mask=(are_stable(solution)))
    end function solve
end module solver

program magic_forests
    use class_Forest
    use solver

    type(Forest) :: initial
    type(Forest), dimension(:), allocatable :: solution

    character(len=20) :: cmd_goats, cmd_wolves, cmd_lions
    integer :: goats, wolves, lions
    type(Forest) :: current
    integer :: i

    call get_command_argument(1, cmd_goats)
    call get_command_argument(2, cmd_wolves)
    call get_command_argument(3, cmd_lions)

    read(cmd_goats, *) goats
    read(cmd_wolves, *) wolves
    read(cmd_lions, *) lions

    initial = Forest(goats, wolves, lions)

    print *, "initial"
    print *, initial

    solution = solve(initial)

    print *, "solutions"
    do i = 1, size(solution)
        current = solution(i)
        print *, current
    end do
end program
