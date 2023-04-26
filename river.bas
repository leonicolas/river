option explicit
#option keyboard repeat 600,25

const BG_GROUND=rgb(cyan)
const SEG_MAX_SLOPE=3
const SEG_GRID=40
const SEG_HEIGHT=64 'pixels
const SEG_SIZE=20 'pixels
const SEG_LMAX=SEG_GRID/2-1
const SEG_RMAX=SEG_LMAX+2
const RND_BASE = 32763067
const SEGMENT_BITS=24, MAX_SEGMENT=2 ^ (SEGMENT_BITS - 1) - 1

dim lsegment=MAX_SEGMENT, rsegment=MAX_SEGMENT
dim lrand=484283, rrand=239437
dim dist=0,speed=1

cls
speed=2
do while 1
  page scroll 0,0,-speed
  'print_segments(lsegment, rsegment)
  draw_segment(lrand, rrand)
  if dist >= SEG_HEIGHT then
    lrand=random(lrand)
    rrand=random(rrand)
    shift_segment(lsegment, lrand)
    shift_segment(rsegment, rrand)
    dist=0
  end if
  inc dist, speed
  pause 5
loop

sub draw_segment(_lsegment, _rsegment)
  local _bit, _lseg_val=_lsegment, _rseg_val=_rsegment, _lseg_count=0, _rseg_count=0
  for _bit=1 to SEGMENT_BITS
    if _lseg_val and 1 then inc _lseg_count
    _lseg_val=_lseg_val >> 1

    if _rseg_val and 1 then inc _rseg_count
    _rseg_val=_rseg_val >> 1 
  next
  line 0,0,MM.HRES,0,SEG_HEIGHT,BG_GROUND
  line 0,0,SEG_SIZE*_lseg_count+SEG_SIZE,0,SEG_HEIGHT,rgb(green)
  line MM.HRES,0,MM.HRES-(SEG_SIZE*_rseg_count+SEG_SIZE),0,SEG_HEIGHT,rgb(green)
end sub

sub shift_segment(_segment, _rand)
  local _bits=_rand mod 20
  if _bits < 3 then
    _segment=(_segment << (_bits mod SEG_MAX_SLOPE))
    if _segment > MAX_SEGMENT then _segment=MAX_SEGMENT
  elseif _bits < 15 then
    _segment=_segment >> (_bits mod SEG_MAX_SLOPE)
  end if
end sub

sub print_segments(_lsegment, _rsegment)
  print_segment(_lsegment, _rsegment)
  pause 50
end sub

sub print_segment(_lsegment, _rsegment)
  local _bit, _lseg_val=_lsegment, _rseg_val=_rsegment, _lseg$="", _rseg$=""
  for _bit=1 to SEGMENT_BITS
    _lseg$= _lseg$ + choice(_lseg_val and 1, "+", " ")
    _lseg_val=_lseg_val >> 1

    _rseg$=choice(_rseg_val and 1, "+", " ") + _rseg$
    _rseg_val=_rseg_val >> 1 
  next
  ? "[+" + _lseg$ + _rseg$ + "+]"
end sub

function random(_seed)
  random=(RND_BASE * (_seed >> 3)) mod 9999999
end function
