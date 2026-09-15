! RUN: %flang_fc1 -emit-hlfir -fopenmp -fopenmp-version=52 %s -o %t
! RUN: FileCheck %s < %t
! RUN: fir-opt --canonicalize --verify-each %t | FileCheck %s

subroutine mapper_ranges()
  type :: t
    integer :: a(4), b(4)
  end type
  !$omp declare mapper(m: t :: v) &
  !$omp& map(iterator(i=1:4, j=2:1): v%a(i), v%b(j))
end

! CHECK-LABEL: omp.declare_mapper @_QQFmapper_rangesm
! CHECK: %[[A:.*]] = omp.iterator(%{{[^:]+}}: index) =
! CHECK: omp.map.info
! CHECK: } inclusive -> !omp.iterated<!llvm.ptr>
! CHECK: %[[B:.*]] = omp.iterator(%{{[^:]+}}: index) =
! CHECK: omp.map.info
! CHECK: } inclusive -> !omp.iterated<!llvm.ptr>
! CHECK: omp.declare_mapper.info
! CHECK-SAME: map_iterated(%[[A]], %[[B]]
