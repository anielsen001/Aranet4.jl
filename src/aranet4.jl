module aranet4

using Dates
using DataFrames
using CSV


"""

    read_aranet4_csv(fnames)

read a csv file or series of files produced by the Android Aranet4 app
the files must be sorted in time order

**Arguments:**
- 'fnames': list of files to parse

**Returns:**
- 'df': DataFrame object 
    
if fnames is a list, the files will be concatenated into a single dataframe
and overlapping times will be cut dropped.
"""
function read_aranet4_csv(fnames)


    # data format used by Aranet4 CSV files
    dateformat = DateFormat("mm/dd/yyyy HH:MM:SS p")

    # read first file into data frame
    dfc = CSV.read(fnames[1], DataFrame; dateformat = dateformat)
    lasttime = dfc.Time[end]

    # if there are more, read and append
    for fname = fnames[2:end]
        println(fname)
        dftmp = CSV.read(fname, DataFrame; dateformat = dateformat)

        dfc = vcat(dfc,dftmp[dftmp.Time.>lasttime,:])
        
        lasttime = dfc.Time[end]
    end


    return dfc

end # read_aranet4_csv

export read_aranet4_csv

end # module
