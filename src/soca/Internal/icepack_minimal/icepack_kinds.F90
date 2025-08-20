!=======================================================================
!
! Minimal icepack_kinds module for SOCA internal use
! Extracted from Icepack: https://github.com/CICE-Consortium/Icepack.git
! Original authors: Elizabeth C. Hunke and William H. Lipscomb, LANL
!
! This file contains only the type definitions needed for SOCA's 
! sea ice analysis postprocessing functionality.
!
!=======================================================================

module icepack_kinds

!=======================================================================

      implicit none
      public

      integer, parameter :: char_len  = 80, &
                            char_len_long  = 256, &
                            log_kind  = kind(.true.), &
                            int_kind  = selected_int_kind(6), &
                            int8_kind = selected_int_kind(13), &
                            real_kind = selected_real_kind(6), &
                            dbl_kind  = selected_real_kind(13), &
                            r16_kind  = selected_real_kind(13)

!=======================================================================

end module icepack_kinds

!=======================================================================