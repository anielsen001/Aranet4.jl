module aranet4

using Dates
using DataFrames
using CSV


"""

    read_aranet4_csv_old(fnames)

read a csv file or series of files produced by the Android Aranet4 app
the files must be sorted in time order

This reads an older csv file format.

**Arguments:**
- 'fnames': list of files to parse

**Returns:**
- 'df': DataFrame object 
    
if fnames is a list, the files will be concatenated into a single dataframe
and overlapping times will be cut dropped.
"""
function read_aranet4_csv_old(fnames)


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

"""

    read_aranet4_csv(fnames)

read a csv file or series of files produced by the Android Aranet4 app
the files must be sorted in time order.

This reads the current (as of 2022-11-12 csv format).

**Arguments:**
- 'fnames': list of files to parse

**Returns:**
- 'df': DataFrame object 
    
if fnames is a list, the files will be concatenated into a single dataframe
and overlapping times will be cut dropped.
"""
function read_aranet_csv(fnames)
    """
    read a csv file or series of files produced by the Android Aranet4 app

    if fnames is a list, the files will be concatenated into a single dataframe
    """

    # data format used by Aranet4 CSV files
    dateformat = DateFormat("dd/mm/yyyy HH:MM:SS p")

    # read first file into data frame
    dfc = CSV.read(fnames[1], DataFrame; dateformat = dateformat)
    lasttime = dfc[end,"Time(dd/mm/yyyy)"]

    # if there are more, read and append
    for fname = fnames[2:end]
        println(fname)
        dftmp = CSV.read(fname, DataFrame; dateformat = dateformat)

        dfc = vcat(dfc,dftmp[dftmp[!,"Time(dd/mm/yyyy)"].>lasttime,:])
        
        lasttime = dfc[end,"Time(dd/mm/yyyy)"]
    end


    return dfc

end

export read_aranet4_csv_old, read_aranet4_csv

end # module
