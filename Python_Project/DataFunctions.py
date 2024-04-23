import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

def stats(dataframe) :
    """Function shows informations about dataset - shape and data types.
    
    Args:
        dataframe -> dataframe from where we load data
    
    """
    print('### Shape ###')
    print(f'Rows: {dataframe.shape[0]}')
    print(f'Columns: {dataframe.shape[1]}')
    print('\n')
    print('### Data Types ###')
    print(dataframe.dtypes)
    print('\n')

def miss_dupl(dataframe) :
    """Function shows information about missing values and duplicates in dataset.

    Args:
        dataframe -> dataframe from where we load data

    """
    print('\n')
    print('### Missing Values ###')
    ndf = dataframe.isna().sum()
    print(ndf[ndf > 0])
    print('\n')
    print('### Duplicate Values ###')
    print(dataframe.duplicated().sum())
    print('\n')
    print('### Unique Values ###')
    print(dataframe.nunique().sum())

def columns_bsize(dataframe) :
    """ Function shows size of each column in bytes.
    
    Args:
        dataframe -> dataframe from where we load data

    Return:
        Function returns list of column names and size in byte
    
    """
    return [f'{x} --- {dataframe[x].nbytes} --- {dataframe[x].dtype}' for x in dataframe]

def change_to_int(dataframe, list) :
    """ Change given columns type to int16.
    
    Args:
        dataframe -> dataframe from where we load data
        list -> list of columns that type is changed to int16.

    """
    for x in list:
        dataframe[x] = dataframe[x].astype('int16')

def drop_missing_five(dataframe) :
    """ Function that shows which column is in drop treshold of 5% missing values.
    
    Args:
        dataframe -> dataframe from where we load data

    Return:
        list of columns below 5% missing values.
    
    """
    tresh = int(len(dataframe) * 0.05)
    return dataframe.columns[dataframe.isna().sum() <= tresh]

def dataset_IQR(col) :
    """ Calculate IQR for given column
     
    Args:
        col -> column for IQR calculation

    Return:
        IQR value of specific column, value -> float
    
    """
    return np.quantile(col, 0.75) - np.quantile(col, 0.25)

def lower_tresh(col):
    """ Calculate lower treshold

    Args:
        col -> column for IQR calculation

    Return:
        lower outliner value -> float
    """ 
    return np.quantile(col, 0.25) - (1.5 * dataset_IQR(col))

def upper_tresh(col) :
    """ Calculate upper treshold

    Args:
        col -> column for IQR calculation

    Return:
        upper outliner value -> float
    """ 
    return np.quantile(col, 0.75) + (1.5 * dataset_IQR(col))

def lower_treshholders(dataframe) :
    """ Check how many outliners-lower we have for each column
    
    Args:
        dataframe -> dataframe from where we load data
    
    """
    for x in dataframe.select_dtypes(include= 'number') :
        print(f'Column: {x}')
        print(f'Lower treshold {lower_tresh(dataframe[x])}')
        print(f'Ilosc wartosci ponizej dolnego outlinera: {dataframe[x][dataframe[x] < lower_tresh(dataframe[x])].count()}\n')

def upper_treshholders(dataframe) :
    """ Check how many outliners-upper we have for each column
    
    Args:
        dataframe -> dataframe from where we load data
    
    """
    for x in dataframe.select_dtypes(include= 'number') :
        print(f'Column: {x}')
        print(f'Upper treshold {upper_tresh(dataframe[x])}')
        print(f'Ilosc wartosci powyzej górnego outlinera: {dataframe[x][dataframe[x] > upper_tresh(dataframe[x])].count()}\n')

def remove_outliners(dataframe) :
    """ Remove outliners for column with number type
    
    Args:
        dataframe -> dataframe from where we load data

    Return:
        new dataframe, value -> DataFrame 
    
    """
    for x in dataframe.select_dtypes(include= 'number') :
        dataframe = dataframe[(dataframe[x] >= lower_tresh(dataframe[x])) & (dataframe[x] <= upper_tresh(dataframe[x]))]
    return dataframe

def weight_average(group, col) :
    """ Return weight mean
    
    Args:
        group -> grouped dataframe
        col -> dataset column

    Return:
        list with weight value
    """
    d = group[col]
    w = group['Circulations']
    return (d * w).sum() / w.sum()

def barplot(data, x, y, title, col = None, col_wrap = None, hue = None) :
    """ Create bar plot

    Args:
        data -> dataframe from where we load data
        x -> x axis data
        y -> y axis data
        title -> title of chart
        *
        col = None -> data from specific column, 
        col_wrap = None -> how many charts should be in 1 column, 
        hue = None -> data show as color 
    """
    bar = sns.catplot(data= data, x = x, y = y, kind = 'bar', height= 8.27, aspect= 11.7/8.27, col = col, col_wrap = col_wrap, hue = hue)
    bar.figure.subplots_adjust(top= 0.9)
    bar.figure.suptitle(title)
    bar.set_xlabels('')
    plt.xticks(rotation = 60)
    pass