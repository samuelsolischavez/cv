#!/usr/bin/perl
$par=shift;
if ($par=~/^$/) {
$log[1]="../cm.pinlog";
}
else {
$log[1]=$par;
}


open LST, "<device.lst" or die "no e puede abrir $cta.lst:$!";
while (<LST>) {
   chomp;
   $hs_cta{$_}=1;
}

close LST;
foreach $cta (sort keys %hs_cta) {

 print "cta=$cta\n";
   foreach $nodo (1) {
        print "nodo=$nodo\n";
        open LOG, "<$log[$nodo]" or die "1: No se puede abrir $log[$nodo]:$!";
        undef %hs_cm;
        while (<LOG>) {
           $i++;
           chomp;
           if ( /\s+cm\:\d+\s+/) {
             ($cm=$_)=~s/.*\s+cm\:(\d+)\s+.*/$1/;
              $cm_i=$i;
           }
          if ( /fm_/) {
            ($fm=$_)=~s/.*(fm_[a-z_]+).*/$1/;
           }
          if (/\d+\s+PIN_FLD_DEVICE_ID\s+STR\s+\[\d\]\s+\"$cta\"/ ) {
            $hs_cm{$cm}=1;
          }
        }
        close LOG;
        foreach $cm (sort keys %hs_cm) {
            ### 
              print "cm=$cm\n"; 
             open LOG, "<$log[$nodo]" or die "2: No se puede abrir $log[$nodo]:$!";
             $file_out="$cta\_$nodo\_$cm.txt";
          print "file_out=$file_out\n";
             open OUT, ">$file_out";
             while (<LOG>) {
               if (/\scm\:\d+\s/ ) {
                   if (/\scm\:$cm\s/) {
                      $prn_flag=1;
                   }
                   else {
                      $prn_flag=0;
                   }
               }
               print OUT $_ if $prn_flag;
             }
             close LOG;
             close OUT;
             ### 
        }
   }
   
}
