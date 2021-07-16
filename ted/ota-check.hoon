::  Check if you're behind your OTA source
/-  spider
/+  *strandio
=,  strand=strand:spider
=<
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
;<  =src                        bind:m  get-src
;<  hit=(map @ud tako:clay)     bind:m  (get-hit src)
;<  home-base=(list tako:clay)  bind:m  (get-base %home src)
;<  kids-base=(list tako:clay)  bind:m  (get-base %kids src)
;<  ~                           bind:m  (check %home src home-base hit)
;<  ~                           bind:m  (check %kids src kids-base hit)
(pure:m !>(~))
|%
+$  src  [=ship =desk =aeon:clay]
++  get-src
  =/  m  (strand ,src)
  ^-  form:m
  ;<  usrc=(unit src)  bind:m  (scry ,(unit src) /gx/hood/kiln/ota/noun)
  ?~  usrc
    (strand-fail:strand %get-ota-src-fail ~['No OTA source set!'])
  ?:  (lth aeon.u.usrc 2)
    %+  strand-fail:strand
      %no-first-aeon-fail
    ~[leaf+"We haven't yet received the first revision of {<desk.u.usrc>} from {<ship.u.usrc>}!"]
  =.  aeon.u.usrc  (dec aeon.u.usrc)
  (pure:m u.usrc)
++  get-base
  |=  [dsk=?(%kids %home) =src]
  =/  m  (strand ,(list tako:clay))
  ^-  form:m
  ;<  merge-base=(list tako:clay)
    bind:m
  (scry ,(list tako:clay) /cs/[dsk]/base/(scot %p ship.src)/[desk.src])
  ?~  merge-base
    %+  strand-fail:strand
      %find-merge-base-fail
    ~[leaf+"No common ancestor found between our {<dsk>} desk and {<ship.src>}'s {<desk.src>} desk!"]
  (pure:m merge-base)
++  get-hit
  |=  =src
  =/  m  (strand ,(map @ud tako:clay))
  ^-  form:m
  ;<  =riot:clay  bind:m  ((set-timeout ,riot:clay) ~m2 (warp ship.src desk.src ~ %sing %v ud+aeon.src ~))
  ?~  riot
    %+  strand-fail:strand
      %empty-riot-fail
    ~[leaf+"Failed to retreive {<ship.src>}'s {<desk.src>} desk state at aeon {<aeon.src>}!"]
  =/  =dome:clay  !<  dome:clay  q.r.u.riot
  (pure:m hit.dome)
++  check
  |=  [dsk=?(%kids %home) =src bases=(list tako:clay) hit=(map @ud tako:clay)]
  =/  m  (strand ,~)
  ^-  form:m
  =/  =aeon:clay  aeon.src 
  |-
  ?:  =(aeon 0)
    %+  strand-fail:strand
      %find-merge-base-aeon-fail
    ~[leaf+"Couldn't find the merge-base aeon on {<ship.src>}'s {<desk.src>} desk for our {<dsk>} desk!"]
  ?:  (lien bases |=(=tako:clay =(tako (~(got by hit) aeon))))
    ?:  =(aeon aeon.src)
      ((slog ~[leaf+"Our {<dsk>} desk is up to date with the {<desk.src>} desk on {<ship.src>}."]) (pure:m ~))
    ((slog ~[leaf+"Our {<dsk>} desk is {<(sub aeon.src aeon)>} commits behind the {<desk.src>} desk on {<ship.src>}."]) (pure:m ~))
  $(aeon (dec aeon))
--
