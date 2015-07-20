<?php

// include this file in index.php of wordpress, at the begining.
// then call timer(); everywhere you want.
// all backtrace will be written in debuglog.txt next to this file.


$timpul=microtime(true);
function timer($nota=''){
        global $timpul;

        $trace = "";

        $acum = microtime(true);
        $trecute = $acum - $timpul;
        $timpul = $acum;
        $trace .= "Au trecut: ".$trecute."\n";
        $trace .= "Nota: ".$nota."\n";

        $dbg = debug_backtrace();
        $cnt = count($dbg);
        for($i = 0; $i < $cnt; $i++){
                $trace .= substr($dbg[$i]['file'],30,10000)
                ." : ".$dbg[$i]['line']
                ." : ".$dbg[$i]['function']
                ." : ".$dbg[$i]['class']
                //." : ".$dbg[$i]['object']
                ."\n";
        }

        $trace .= "\n";

        $h = fopen(dirname(__FILE__)."/debuglog.txt","a");
        fwrite($h,$trace);
        fclose($h);
}
?>
