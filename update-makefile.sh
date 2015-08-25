
where=Makefile.order

echo "COMPILATION_ORDER = IO.cmx path_finder.cmx port.cmx motor.cmx led.cmx \\" > $where
printf "\tpower_supply.cmx sensors/sensor.cmx" >> $where

find src/sensors -type f ! -name "sensor.*" -name "*.ml" \
    | sed "s/src\///g" \
    | for x in $(xargs); do printf " \\\\\n\t${x%.ml}.cmx" >> $where; done

echo >> $where
